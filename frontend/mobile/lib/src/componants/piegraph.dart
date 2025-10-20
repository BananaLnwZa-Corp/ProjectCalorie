// nutrition_pie_chart_component.dart
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class NutritionPieChartComponent extends StatelessWidget {
  final double carbs;
  final double fats;
  final double protein;

  const NutritionPieChartComponent({
    super.key,
    required this.carbs,
    required this.fats,
    required this.protein,
  });

  @override
  Widget build(BuildContext context) {
    return _buildPieChart();
  }

  Widget _buildPieChart() {
    return SizedBox(
      height: 250,
      child: PieChart(
        PieChartData(
          sections: _buildSections(),
          sectionsSpace: 2,
          centerSpaceRadius: 40,
        ),
      ),
    );
  }

  List<PieChartSectionData> _buildSections() {
    return [
      _buildSection(carbs, const Color.fromARGB(255, 152, 206, 251), 'Carbs'),
      _buildSection(fats, const Color.fromARGB(255, 243, 122, 113), 'Fat'),
      _buildSection(protein, const Color.fromARGB(255, 243, 199, 103), 'Protein'),
    ];
  }

  PieChartSectionData _buildSection(double value, Color color, String title) {
    return PieChartSectionData(
      value: value,
      color: color,
      title: '$title\n${value.toStringAsFixed(1)}g',
      radius: 60,
      titleStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Color.fromARGB(255, 3, 0, 0),
      ),
    );
  }
}
