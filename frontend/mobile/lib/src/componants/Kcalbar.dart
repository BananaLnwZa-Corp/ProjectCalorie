// components/calorie_progress_bar.dart
import 'package:flutter/material.dart';


class Kcalbar extends StatelessWidget {
  final double current;        // แคลอรี่ที่กินไปแล้ว
  final double target;         // แคลอรี่เป้าหมาย
  final Color progressColor;   // สีของแถบความคืบหน้า
  final Color backgroundColor; // สีพื้นหลัง

  const Kcalbar({
    super.key,
    required this.current,
    required this.target,
    this.progressColor = const Color(0xFF8bc273),
    this.backgroundColor = const Color(0xFFE5E7EB),
  });

  @override
  Widget build(BuildContext context) {
    // คำนวณค่าต่างๆ
    double remaining = target - current;
    double progress = current / target;
    
    // จำกัด progress ไม่ให้เกิน 1.0 (100%)
    double displayProgress = progress > 1.0 ? 1.0 : progress;
    
    // เปลี่ยนสีถ้ากินเกิน
    Color barColor = progress > 1.0 ? Colors.red : progressColor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // หัวข้อด้านบน
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Kcal',
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontFamily: 'TA8bit',
                ),
              ),
              Text(
                '${current.toStringAsFixed(0)} Kcal from ${target.toStringAsFixed(0)} Kcal',
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  fontFamily: 'TA8bit',
                ),
              ),
            ],
          ),
        ),
        
        // Progress Bar
        Container(
          height: 32,
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 4),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                offset: const Offset(4, 4),
                blurRadius: 0,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(26),
            child: Stack(
              children: [
                // Background (สีเทา)
                Container(
                  decoration: BoxDecoration(
                    color: backgroundColor,
                  ),
                ),
                
                // Progress Bar (สีเขียวหรือแดง)
                FractionallySizedBox(
                  widthFactor: displayProgress,
                  child: Container(
                    decoration: BoxDecoration(
                      color: barColor,
                    ),
                  ),
                ),
                
                // ข้อความคงเหลือด้านขวา
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          // decoration: BoxDecoration(
                          //   color: Colors.white.withOpacity(0.9),
                          //   borderRadius: BorderRadius.circular(15),
                          //   border: Border.all(color: Colors.black, width: 2),
                          // ),
                          child: Text(
                            remaining > 0
                                ? '${remaining.toStringAsFixed(0)} Kcal'
                                : 'Over ${(-remaining).toStringAsFixed(0)} Kcal!',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: remaining > 0 ? Colors.black87 : Colors.red,
                              fontFamily: 'TA8bit',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}