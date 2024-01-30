// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class AnalysisScreen extends StatefulWidget {
  const AnalysisScreen({Key? key}) : super(key: key);

  @override
  _AnalysisScreenState createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisScreen> {
  late Map<String, double> expenseData;
  late double totalAmount;
  late String selectedReportType;

  @override
  void initState() {
    super.initState();
    // Sample data for different expense categories
    expenseData = {
      'Food': 250.0,
      'Transportation': 120.0,
      'Entertainment': 80.0,
      'Shopping': 150.0,
    };

    // Calculate total amount
    totalAmount = expenseData.values.reduce((sum, expense) => sum + expense);

    // Default selected report type
    selectedReportType = 'Group Reports';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Financial Reports'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // Add the share functionality here
              // For example, open a share dialog
              // Share.share('Check out my financial reports!');
            },
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Expense Overview',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: PieChart(
                PieChartData(
                  sectionsSpace: 4,
                  centerSpaceRadius: 60,
                  sections: _generatePieSections(expenseData),
                  borderData: FlBorderData(
                    show: false,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: _buildReportTypeDropdown(),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Column(
                children: _generateExpenseRows(expenseData),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportTypeDropdown() {
    return DropdownButton<String>(
      value: selectedReportType,
      onChanged: (String? newValue) {
        setState(() {
          selectedReportType = newValue!;
          // Update UI or fetch new data based on the selected report type
        });
      },
      items: ['Group Reports', 'Personal Reports']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
            style: const TextStyle(fontSize: 18, color: Colors.black),
          ),
        );
      }).toList(),
      style: const TextStyle(fontSize: 18),
    );
  }

  List<Widget> _generateExpenseRows(Map<String, double> data) {
    return data.entries.map((entry) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            _buildCategoryColorBox(data.keys.toList().indexOf(entry.key)),
            const SizedBox(width: 12),
            Text(
              entry.key,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black, // Black text color
              ),
            ),
            const Spacer(),
            if (selectedReportType == 'Group Reports')
              Text(
                '${(entry.value / totalAmount * 100).toStringAsFixed(2)}%',
                style: const TextStyle(fontSize: 16),
              ),
          ],
        ),
      );
    }).toList();
  }

  Widget _buildCategoryColorBox(int index) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: _getCategoryColor(index),
        shape: BoxShape.circle,
      ),
    );
  }

  List<PieChartSectionData> _generatePieSections(Map<String, double> data) {
    int index = 0;
    return data.entries.map((entry) {
      final isTouched = index == 0;
      final double radius = isTouched ? 80 : 70; // Adjusted radius

      final value = PieChartSectionData(
        color: _getCategoryColor(index),
        value: entry.value,
        title: selectedReportType == 'Group Reports'
            ? '${(entry.value / totalAmount * 100).toStringAsFixed(2)}%'
            : '${(entry.value / totalAmount * 100).toStringAsFixed(2)}%', // Percentage inside chart for Personal Reports
        radius: radius,
        titleStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Color(0xffffffff),
        ),
        showTitle: true, // Always show title
      );

      index++;

      return value;
    }).toList();
  }

  Color _getCategoryColor(int index) {
    switch (index) {
      case 0:
        return const Color(0xff0293ee);
      case 1:
        return const Color(0xfff8b250);
      case 2:
        return const Color(0xff845bef);
      case 3:
        return const Color(0xffff6f61);
      default:
        return const Color(0xff0293ee);
    }
  }
}
