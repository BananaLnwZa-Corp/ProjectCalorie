// ============================================
// activity_factor.dart - Activity Factor Component (Pixel Art 8-bit, Compact & Clean, Font = Black)
// ============================================

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ActivityFactorButton extends StatefulWidget {
  final Function(int, String)? onSaved;
  const ActivityFactorButton({Key? key, this.onSaved}) : super(key: key);

  @override
  State<ActivityFactorButton> createState() => _ActivityFactorButtonState();
}

class _ActivityFactorButtonState extends State<ActivityFactorButton> {
  int? _savedLevel;
  String? _savedLabel;
  bool _isLocked = false;

  @override
  void initState() {
    super.initState();
    _loadSavedData();
  }

  Future<void> _loadSavedData() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLevel = prefs.getInt('activity_level');
    final savedLabel = prefs.getString('activity_label');
    final savedTimestamp = prefs.getString('activity_timestamp');

    if (savedLevel != null && savedLabel != null && savedTimestamp != null) {
      final savedDate = DateTime.parse(savedTimestamp);
      final now = DateTime.now();
      final isSameDay = savedDate.year == now.year &&
          savedDate.month == now.month &&
          savedDate.day == now.day;
      setState(() {
        _savedLevel = savedLevel;
        _savedLabel = savedLabel;
        _isLocked = isSameDay;
      });
    }
  }

  Future<void> _openActivitySelector(BuildContext context) async {
    if (_isLocked) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            '⭐ เลือกได้อีกครั้งพรุ่งนี้นะ!',
            style: TextStyle(fontFamily: 'monospace', fontWeight: FontWeight.bold),
          ),
          backgroundColor: const Color(0xFFFFF9BD),
          behavior: SnackBarBehavior.floating,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
            side: BorderSide(color: Colors.black, width: 3),
          ),
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      barrierColor: Colors.black.withOpacity(0.7),
      builder: (context) => const ActivityFactorDialog(),
    );

    if (result != null) {
      final level = result['level'] as int;
      final label = result['label'] as String;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('activity_level', level);
      await prefs.setString('activity_label', label);
      await prefs.setString('activity_timestamp', DateTime.now().toIso8601String());

      setState(() {
        _savedLevel = level;
        _savedLabel = label;
        _isLocked = true;
      });

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '✨ บันทึก LV.$level: $label แล้ว!',
              style: const TextStyle(fontFamily: 'monospace', fontWeight: FontWeight.bold),
            ),
            backgroundColor: const Color(0xFFFFF9BD),
            behavior: SnackBarBehavior.floating,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
              side: BorderSide(color: Colors.black, width: 3),
            ),
            duration: const Duration(seconds: 2),
          ),
        );
      }

      widget.onSaved?.call(level, label);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _openActivitySelector(context),
        child: Container(
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: _savedLevel != null ? const Color(0xFFFFF9BD) : const Color(0xFFF5F5F5),
            border: Border.all(color: Colors.black, width: 4),
            boxShadow: const [
              BoxShadow(color: Colors.black, offset: Offset(3, 3), blurRadius: 0),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 🔸 ช่องแสดง LV / ไอคอน
              Container(
                width: 42,
                height: 42,
                padding: const EdgeInsets.symmetric(vertical: 1), // ป้องกัน overflow
                decoration: BoxDecoration(
                  color: _savedLevel != null ? const Color(0xFFFFF9BD) : Colors.white,
                  border: Border.all(color: Colors.black, width: 3),
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: _savedLevel != null
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'LV',
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'monospace',
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              '$_savedLevel',
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'monospace',
                                color: Colors.black,
                              ),
                            ),
                          ],
                        )
                      : const Icon(Icons.directions_run, size: 22, color: Colors.black),
                ),
              ),
              const SizedBox(width: 10),

              // 🔸 ข้อความ activity
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'ACTIVITY',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'monospace',
                        letterSpacing: 1,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      _savedLevel != null ? (_savedLabel ?? 'ไม่ระบุ') : 'กดเพื่อเลือก',
                      style: const TextStyle(
                        fontSize: 14,
                        fontFamily: 'monospace',
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),

              const Icon(Icons.arrow_forward_ios, color: Colors.black, size: 15),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================
// ActivityFactorDialog
// ============================================

class ActivityFactorDialog extends StatefulWidget {
  const ActivityFactorDialog({Key? key}) : super(key: key);

  @override
  State<ActivityFactorDialog> createState() => _ActivityFactorDialogState();
}

class _ActivityFactorDialogState extends State<ActivityFactorDialog> {
  int? _selectedLevel;

  final List<Map<String, dynamic>> _activityLevels = [
    {'level': 1, 'label': 'น้อยมาก', 'description': 'นอนเฉยๆ'},
    {'level': 2, 'label': 'น้อย', 'description': 'ทำงานเบาๆ เดินเล่น'},
    {'level': 3, 'label': 'ปานกลาง', 'description': 'ยืน เดิน ยกของเล็กน้อย'},
    {'level': 4, 'label': 'มาก', 'description': 'ออกกำลังกายหนัก'},
    {'level': 5, 'label': 'มากที่สุด', 'description': 'นักกีฬา'},
  ];

  void _saveSelection() {
    if (_selectedLevel == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            '⚠️ เลือกระดับก่อนนะ!',
            style: TextStyle(fontFamily: 'monospace', fontWeight: FontWeight.bold),
          ),
          backgroundColor: const Color(0xFFFFF9BD),
          behavior: SnackBarBehavior.floating,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
            side: BorderSide(color: Colors.black, width: 3),
          ),
        ),
      );
      return;
    }

    final selectedData = _activityLevels.firstWhere((item) => item['level'] == _selectedLevel);
    Navigator.pop(context, {'level': _selectedLevel, 'label': selectedData['label']});
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 420, maxHeight: 480),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black, width: 4),
        ),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              color: const Color(0xFFFFF9BD),
              child: const Center(
                child: Text(
                  'ACTIVITY LEVEL',
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'monospace',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(14),
                child: Column(
                  children: [
                    ..._activityLevels.map((item) {
                      final isSelected = _selectedLevel == item['level'];
                      return GestureDetector(
                        onTap: () => setState(() => _selectedLevel = item['level']),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(8),
                          color: isSelected
                              ? const Color(0xFFFFF9BD)
                              : const Color(0xFFE0E0E0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: Colors.black, width: 2),
                                ),
                                child: Center(
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      '${item['level']}',
                                      style: const TextStyle(
                                        fontFamily: 'monospace',
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item['label'],
                                      style: const TextStyle(
                                        fontFamily: 'monospace',
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Text(
                                      item['description'],
                                      style: const TextStyle(
                                        fontFamily: 'monospace',
                                        fontSize: 10,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (isSelected)
                                Container(
                                  width: 16,
                                  height: 16,
                                  margin: const EdgeInsets.only(left: 6),
                                  color: Colors.black,
                                  child: const Center(
                                    child: Text(
                                      '✔',
                                      style: TextStyle(
                                        color: Colors.yellow,
                                        fontSize: 12,
                                        fontFamily: 'monospace',
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              height: 36,
                              color: const Color(0xFFC0C0C0),
                              child: const Center(
                                child: Text(
                                  'ยกเลิก',
                                  style: TextStyle(
                                    fontFamily: 'monospace',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: GestureDetector(
                            onTap: _saveSelection,
                            child: Container(
                              height: 36,
                              color: const Color(0xFFFFF9BD),
                              child: const Center(
                                child: Text(
                                  'บันทึก',
                                  style: TextStyle(
                                    fontFamily: 'monospace',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
