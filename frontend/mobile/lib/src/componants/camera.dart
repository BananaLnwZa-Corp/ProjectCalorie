import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

/// Camera Icon Component
/// คอมโพเนนต์ไอคอนกล้องที่คลิกแล้วเปิดกล้องได้
class CameraIconButton extends StatelessWidget {
  final double size;
  final Color color;
  final Function(File?)? onImageCaptured;

  const CameraIconButton({
    Key? key,
    this.size = 32.0,
    this.color = const Color(0xFF6fa85e),
    this.onImageCaptured,
  }) : super(key: key);

  Future<void> _openCamera(BuildContext context) async {
    // แสดง popup ให้เลือก
    final ImageSource? source = await showDialog<ImageSource>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ปุ่มเปิดกล้อง
              ListTile(
                leading: const Icon(
                  Icons.camera_alt,
                  color: Color(0xFF6fa85e),
                  size: 32,
                ),
                title: const Text(
                  'ถ่ายรูป',
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: const Text(
                  'เปิดกล้องเพื่อถ่ายรูปใหม่',
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 12,
                  ),
                ),
                onTap: () => Navigator.pop(context, ImageSource.camera),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: const BorderSide(color: Colors.grey, width: 1),
                ),
              ),
              const SizedBox(height: 12),
              // ปุ่มเลือกจากแกลเลอรี่
              ListTile(
                leading: const Icon(
                  Icons.photo_library,
                  color: Color(0xFF6fa85e),
                  size: 32,
                ),
                title: const Text(
                  'เลือกจากอัลบั้ม',
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: const Text(
                  'เลือกรูปจากแกลเลอรี่',
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 12,
                  ),
                ),
                onTap: () => Navigator.pop(context, ImageSource.gallery),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: const BorderSide(color: Colors.grey, width: 1),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'ยกเลิก',
                style: TextStyle(
                  fontFamily: 'monospace',
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        );
      },
    );

    // ถ้าผู้ใช้ยกเลิก
    if (source == null) return;

    final ImagePicker picker = ImagePicker();
    
    try {
      // เปิดกล้องหรือแกลเลอรี่ตามที่เลือก
      final XFile? image = await picker.pickImage(
        source: source,
        imageQuality: 85,
      );

      if (image != null) {
        final File imageFile = File(image.path);
        
        // ส่งรูปกลับผ่าน callback (ถ้ามี)
        if (onImageCaptured != null) {
          onImageCaptured!(imageFile);
        }

        // เปิดหน้า FoodDetailScreen
        if (context.mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FoodDetailScreen(
                imageFile: imageFile,
                foodName: 'What food is this',
                carbs: 53,
                fat: 80,
                protein: 23,
                calories: 954,
              ),
            ),
          );
        }
      }
    } catch (e) {
      // จัดการ error
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ เกิดข้อผิดพลาด: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xFFD4F2C1),
      child: Center(
        child: IconButton(
          icon: Icon(
            Icons.camera_alt,
            size: size,
            color: color,
          ),
          onPressed: () => _openCamera(context),
          tooltip: 'เปิดกล้อง',
        ),
      ),
    );
  }
}

// ===== FoodDetailScreen =====
class FoodDetailScreen extends StatelessWidget {
  final File imageFile;
  final String foodName;
  final int carbs;
  final int fat;
  final int protein;
  final int calories;

  const FoodDetailScreen({
    Key? key,
    required this.imageFile,
    this.foodName = 'What food is this',
    this.carbs = 53,
    this.fat = 80,
    this.protein = 23,
    this.calories = 954,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Back Button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 3),
                    color: Colors.white,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, size: 24),
                    onPressed: () => Navigator.pop(context),
                    padding: const EdgeInsets.all(8),
                  ),
                ),
              ),
            ),

            // Food Image
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                width: double.infinity,
                height: 280,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 4),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      offset: const Offset(6, 6),
                      blurRadius: 0,
                    ),
                  ],
                ),
                child: ClipRect(
                  child: Image.file(
                    imageFile,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Nutrition Info Box
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 4),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      offset: const Offset(6, 6),
                      blurRadius: 0,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Header
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        border: const Border(
                          bottom: BorderSide(
                            color: Colors.black,
                            width: 3,
                          ),
                        ),
                      ),
                      child: Text(
                        foodName,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ),

                    // Nutrition Values
                    Container(
                      color: const Color(0xFFFFF8DC),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          _buildNutritionRow('คาโบไฮเดรต', carbs),
                          const SizedBox(height: 8),
                          _buildNutritionRow('คาร์บ', carbs),
                          const SizedBox(height: 8),
                          _buildNutritionRow('ไขมัน', fat),
                          const SizedBox(height: 8),
                          _buildNutritionRow('โปรตีน', protein),
                          const SizedBox(height: 8),
                          _buildNutritionRow('แคลอรี่', calories),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const Spacer(),

            // Save Button
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 4),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      offset: const Offset(4, 4),
                      blurRadius: 0,
                    ),
                  ],
                ),
                child: Material(
                  color: const Color(0xFF6fa85e),
                  child: InkWell(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('✓ บันทึกข้อมูลสำเร็จ!'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.save,
                            color: Colors.white,
                            size: 24,
                          ),
                          SizedBox(width: 12),
                          Text(
                            'SAVE',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontFamily: 'monospace',
                              letterSpacing: 2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNutritionRow(String label, int value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontFamily: 'monospace',
          ),
        ),
        Text(
          ': $value',
          style: const TextStyle(
            fontSize: 16,
            fontFamily: 'monospace',
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

// ===== ตัวอย่างการใช้งาน =====
class CameraIconDemo extends StatefulWidget {
  const CameraIconDemo({Key? key}) : super(key: key);

  @override
  State<CameraIconDemo> createState() => _CameraIconDemoState();
}

class _CameraIconDemoState extends State<CameraIconDemo> {
  File? _capturedImage;

  void _handleImageCaptured(File? imageFile) {
    setState(() {
      _capturedImage = imageFile;
    });
    print('รูปถูกบันทึกที่: ${imageFile?.path}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Camera Icon Demo'),
        backgroundColor: const Color(0xFF6fa85e),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF5a9448),
              Color(0xFF6fa85e),
              Color(0xFF8bc273),
              Color(0xFFa8d88e),
              Color(0xFFc5e8b7),
            ],
          ),
        ),
        child: Center(
          child: Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.black, width: 4),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  offset: const Offset(8, 8),
                  blurRadius: 0,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  '◆ CAMERA ICON ◆',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'monospace',
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'คลิกไอคอนเพื่อเปิดกล้อง',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'monospace',
                  ),
                ),
                const SizedBox(height: 16),
                
                // ไอคอนกล้อง
                CameraIconButton(
                  size: 64,
                  color: const Color(0xFF6fa85e),
                  onImageCaptured: _handleImageCaptured,
                ),
                
                const SizedBox(height: 24),
                
                const Text(
                  'เมื่อถ่ายรูป/เลือกรูปเสร็จ\nจะเปิดหน้าใหม่อัตโนมัติ! 📱',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'monospace',
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}