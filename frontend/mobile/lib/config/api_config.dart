/// การตั้งค่า API Configuration
/// เปลี่ยน URL ที่ _baseUrl และ _flaskUrl ตามสภาพแวดล้อมที่ใช้งาน
class ApiConfig {
  // Node.js Backend (port 4000)
  static const String _baseUrl = 'http://localhost:4000';

  // Flask ML Server (port 5000)
  static const String _flaskUrl = 'http://localhost:5000';
  
  // Node.js Backend Endpoints
  static String get baseUrl => _baseUrl;
  static String get authUrl => '$_baseUrl/api/auth';
  static String get profileUrl => '$_baseUrl/api/profile';
  static String get dailyUrl => '$_baseUrl/api/daily';
  static String get uploadsUrl => '$_baseUrl/uploads';

  // Flask ML Server Endpoints
  static String get flaskUrl => _flaskUrl;
  static String get predictUrl => '$_flaskUrl/api/predict-food';
  static String get saveMealUrl => '$_flaskUrl/api/save-meal';
  static String get foodRecommendUrl => '$_flaskUrl/api/food-recommend';
  static String get sportRecommendUrl => '$_flaskUrl/api/sport-recommend';

  // สร้าง URL รูปภาพแบบเต็ม
  static String getImageUrl(String imagePath) {
    if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
      return imagePath;
    }

    String cleanPath = imagePath.replaceFirst(RegExp(r'^/+'), '');
    return '$_baseUrl/$cleanPath';
  }
}
