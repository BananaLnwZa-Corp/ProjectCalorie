from flask import Flask, request, jsonify
import os
import sys
from dotenv import load_dotenv
from pathlib import Path

# ที่เก็บไฟล์นี้: .../ProjectCalorie/backend/src
BASE_DIR = Path(__file__).resolve().parent        # backend/src
PROJECT_ROOT = BASE_DIR.parent                     # backend
FLASK_MODULE_DIR = PROJECT_ROOT / 'src' / 'flask'  # backend/src/flask

# โหลด .env จาก backend root (C:\Users\User\Documents\ProjectCalorie\backend\.env)
load_dotenv(str(PROJECT_ROOT / '.env'))

# เพิ่มโฟลเดอร์ที่มี food_detect.py ลงใน sys.path เพื่อให้ import ทำงานได้
for p in (str(FLASK_MODULE_DIR), str(BASE_DIR)):
    if p not in sys.path:
        sys.path.insert(0, p)

# import โมดูลจาก backend/src/flask/food_detect.py
from food_detect import (
    predict_food_image, 
    save_meal_to_db,
    require_auth  # import decorator สำหรับ JWT auth
)

app = Flask(__name__)

# ============================================
# API Routes
# ============================================

@app.route('/api/predict-food', methods=['POST'])
@require_auth  # ป้องกันด้วย JWT token
def predict_food():
    """
    ทำนายอาหารจากรูปภาพ (ต้อง login)
    
    Headers:
        Authorization: Bearer <token>
    
    Body (form-data):
        image: file
    """
    try:
        if 'image' not in request.files:
            return jsonify({'error': 'No image provided'}), 400
        
        file = request.files['image']
        
        if file.filename == '':
            return jsonify({'error': 'Empty filename'}), 400
        
        result = predict_food_image(file)
        return jsonify(result)
        
    except Exception as e:
        return jsonify({'error': str(e)}), 500


@app.route('/api/save-meal', methods=['POST'])
@require_auth  # ป้องกันด้วย JWT token
def save_meal():
    """
    บันทึกมื้อาหาร (ต้อง login)
    
    Headers:
        Authorization: Bearer <token>
        Content-Type: application/json
    
    Body:
        {
            "food_id": 101,
            "confidence_score": 0.95,
            "meal_datetime": "2025-10-14 08:30:00"  // optional
        }
    """
    try:
        # ดึง user_id จาก JWT token (ที่ decorator ใส่ไว้ใน request)
        user_id = request.user_id
        
        data = request.get_json()
        
        if not data:
            return jsonify({'error': 'No data provided'}), 400
        
        # ส่ง user_id จาก token ไปยัง function (ไม่รับจาก body)
        result = save_meal_to_db(user_id, data)
        
        if 'error' in result:
            return jsonify(result), 400
        
        return jsonify(result), 201
        
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/api/health', methods=['GET'])
def health():
    """
    Health check (ไม่ต้อง login)
    """
    return jsonify({
        'status': 'ok',
        'message': 'Flask ML API is running'
    })

# ============================================
# Error Handlers
# ============================================

@app.errorhandler(401)
def unauthorized(error):
    return jsonify({
        'error': 'Unauthorized',
        'message': 'Please login to access this resource'
    }), 401


@app.errorhandler(404)
def not_found(error):
    return jsonify({
        'error': 'Not Found',
        'message': 'The requested resource was not found'
    }), 404


@app.errorhandler(500)
def internal_error(error):
    return jsonify({
        'error': 'Internal Server Error',
        'message': 'An unexpected error occurred'
    }), 500

# ============================================
# Run Server
# ============================================

if __name__ == '__main__':
    # แนะนำรันจากโฟลเดอร์ backend:
    #   PS> cd C:\Users\User\Documents\ProjectCalorie\backend
    #   PS> python src\flask_server.py
    port = int(os.getenv('PORT', 4000))
    app.run(host='0.0.0.0', port=port, debug=True)