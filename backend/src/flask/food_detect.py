import torch
import torch.nn as nn
from torchvision import transforms
from PIL import Image
import io
import json
import mysql.connector
from dotenv import load_dotenv
import os
from datetime import datetime
from pathlib import Path
import jwt
from functools import wraps
from flask import request, jsonify

# โหลด .env จาก backend root
PROJECT_ROOT = Path(__file__).resolve().parents[2]
load_dotenv(str(PROJECT_ROOT / '.env'))

# ============================================
# Configuration
# ============================================

DB_CONFIG = {
    'host': os.getenv('DB_HOST'),
    'user': os.getenv('DB_USER'),
    'password': os.getenv('DB_PASSWORD'),
    'database': os.getenv('DB_NAME'),
    'port': int(os.getenv('DB_PORT', '3306'))
}

JWT_SECRET = os.getenv('JWT_SECRET')

if not JWT_SECRET:
    raise ValueError("JWT_SECRET is not set in .env file!")

# ============================================
# Load Mappings
# ============================================

with open(str(PROJECT_ROOT / 'src' / 'config' / 'food_classification_model' / 'food_class_name.json'), 'r', encoding='utf-8') as f:
    class_names = json.load(f)['class_names']

with open(str(PROJECT_ROOT / 'src' / 'config' / 'food_classification_model' / 'class_mapping.json'), 'r', encoding='utf-8') as f:
    class_to_idx = json.load(f)['class_to_idx']

idx_to_class = {v: k for k, v in class_to_idx.items()}

# ============================================
# Load Model
# ============================================

MODEL_PATH = str(PROJECT_ROOT / 'models' / 'food_classification_model' / 'food_model.pth')
device = torch.device('cuda' if torch.cuda.is_available() else 'cpu')

from torchvision.models import efficientnet_b0
model = efficientnet_b0(pretrained=False)
model.classifier[1] = nn.Linear(model.classifier[1].in_features, len(class_to_idx))

checkpoint = torch.load(MODEL_PATH, map_location=device)

# Handle backbone prefix
if any(k.startswith('backbone.') for k in checkpoint.keys()):
    new_checkpoint = {}
    for k, v in checkpoint.items():
        new_key = k.replace('backbone.', '')
        new_checkpoint[new_key] = v
    checkpoint = new_checkpoint

model.load_state_dict(checkpoint, strict=False)
model.to(device)
model.eval()

print(f"✅ Food model loaded on {device}")

# ============================================
# Image Preprocessing
# ============================================

transform = transforms.Compose([
    transforms.Resize((224, 224)),
    transforms.ToTensor(),
    transforms.Normalize(mean=[0.485, 0.456, 0.406], std=[0.229, 0.224, 0.225])
])

# ============================================
# JWT Authentication
# ============================================

def verify_token(token):
    """
    ตรวจสอบ JWT token และดึง user_id
    
    Args:
        token: JWT token string (รูปแบบ "Bearer <token>" หรือ "<token>")
    
    Returns:
        user_id (int) หรือ None ถ้า token ไม่ถูกต้อง
    """
    try:
        if not token:
            return None
        
        # ถ้ามี "Bearer " ให้ตัดออก
        if token.startswith('Bearer '):
            token = token[7:]
        
        # Verify token (ใช้ algorithm เดียวกับ Node.js = HS256)
        payload = jwt.decode(token, JWT_SECRET, algorithms=['HS256'])
        
        # ดึง userId จาก payload (ตาม Node.js controller ของคุณ)
        user_id = payload.get('userId')
        return user_id
        
    except jwt.ExpiredSignatureError:
        print("Token expired")
        return None
    except jwt.InvalidTokenError as e:
        print(f"Invalid token: {e}")
        return None


def require_auth(f):
    """
    Decorator สำหรับ protect routes
    ต้องมี valid JWT token ถึงจะเข้าถึง route ได้
    """
    @wraps(f)
    def decorated_function(*args, **kwargs):
        # ดึง token จาก Authorization header
        token = request.headers.get('Authorization')
        
        # Verify token
        user_id = verify_token(token)
        
        if not user_id:
            return jsonify({
                'error': 'Unauthorized',
                'message': 'Invalid or missing token'
            }), 401
        
        # เพิ่ม user_id ใน request object เพื่อให้ route อื่นใช้ได้
        request.user_id = user_id
        
        return f(*args, **kwargs)
    
    return decorated_function

# ============================================
# Database Functions
# ============================================

def get_nutrition_data(food_name):
    """ค้นหาข้อมูลโภชนาการจากชื่ออาหาร"""
    try:
        print(f"Searching for food: '{food_name}'")
        
        conn = mysql.connector.connect(**DB_CONFIG)
        cursor = conn.cursor(dictionary=True)
        
        query = "SELECT * FROM Foods WHERE food_name = %s"
        cursor.execute(query, (food_name,))
        result = cursor.fetchone()
        
        cursor.close()
        conn.close()
        return result
        
    except Exception as e:
        print(f"Database error: {e}")
        return None


def save_meal_to_db(user_id, data):
    """
    บันทึกมื้อาหารลงฐานข้อมูล (Meals + MealDetails + AIAnalysis)
    
    Args:
        user_id: ID ของผู้ใช้ (มาจาก JWT token)
        data: ข้อมูลที่ต้องการบันทึก (food_id, confidence_score, meal_datetime)
    """
    conn = None
    try:
        food_id = data.get('food_id')
        meal_datetime = data.get('meal_datetime')
        confidence_score = data.get('confidence_score')
        
        if not food_id:
            return {'error': 'food_id is required'}
        
        # Default เวลาปัจจุบัน
        if not meal_datetime:
            now = datetime.now()
            meal_date = now.strftime('%Y-%m-%d')
            meal_time = now.strftime('%H:%M:%S')
        else:
            # แยก date และ time จาก meal_datetime
            dt = datetime.strptime(meal_datetime, '%Y-%m-%d %H:%M:%S')
            meal_date = dt.strftime('%Y-%m-%d')
            meal_time = dt.strftime('%H:%M:%S')
        
        conn = mysql.connector.connect(**DB_CONFIG)
        cursor = conn.cursor()
        
        # เริ่ม transaction
        conn.start_transaction()
        
        # Step 1: Insert or get existing Meal
        insert_meal_query = """
            INSERT INTO Meals (user_id, date) 
            VALUES (%s, %s)
            ON DUPLICATE KEY UPDATE meal_id = LAST_INSERT_ID(meal_id)
        """
        cursor.execute(insert_meal_query, (user_id, meal_date))
        meal_id = cursor.lastrowid
        
        # Step 2: Insert MealDetail
        insert_detail_query = """
            INSERT INTO MealDetails (meal_id, food_id, meal_time)
            VALUES (%s, %s, %s)
        """
        cursor.execute(insert_detail_query, (meal_id, food_id, meal_time))
        meal_detail_id = cursor.lastrowid
        
        # Step 3: Insert AIAnalysis (ถ้ามี confidence_score)
        analysis_id = None
        if confidence_score is not None:
            insert_analysis_query = """
                INSERT INTO AIAnalysis (user_id, food_id, confidence_score)
                VALUES (%s, %s, %s)
            """
            cursor.execute(insert_analysis_query, (user_id, food_id, confidence_score))
            analysis_id = cursor.lastrowid
        
        conn.commit()
        cursor.close()
        conn.close()
        
        result = {
            'success': True,
            'meal_id': meal_id,
            'meal_detail_id': meal_detail_id,
            'message': 'Meal saved successfully'
        }
        
        if analysis_id:
            result['analysis_id'] = analysis_id
        
        return result
        
    except Exception as e:
        if conn:
            conn.rollback()
            conn.close()
        print(f"Error: {e}")
        return {'error': str(e)}

# ============================================
# Model Prediction
# ============================================

def predict_food_image(file):
    """ทำนายอาหารจากรูปภาพ"""
    try:
        # Read image
        image_bytes = file.read()
        image = Image.open(io.BytesIO(image_bytes)).convert('RGB')
        
        # Predict
        input_tensor = transform(image).unsqueeze(0).to(device)
        
        with torch.no_grad():
            outputs = model(input_tensor)
            predicted_idx = torch.argmax(outputs, dim=1).item()
            confidence = torch.softmax(outputs, dim=1)[0][predicted_idx].item()
        
        # Get food info
        class_folder = idx_to_class[predicted_idx]
        food_name = class_names[class_folder]
        
        # Get nutrition
        nutrition = get_nutrition_data(food_name)
        
        response = {
            'predicted_food': food_name,
            'confidence': round(confidence, 4)
        }
        
        if nutrition:
            response['food_id'] = nutrition['food_id']
            response['nutrition'] = {
                'calories': float(nutrition['calories']),
                'protein_gram': float(nutrition['protein_gram']),
                'carbohydrate_gram': float(nutrition['carbohydrate_gram']),
                'fat_gram': float(nutrition['fat_gram'])
            }
        else:
            response['message'] = 'Nutrition data not found in database'
        
        return response
        
    except Exception as e:
        return {'error': str(e)}