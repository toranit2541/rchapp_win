import 'dart:core';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:rchapp_v2/sreens/result/chartses/bar_chart.dart';
import 'package:rchapp_v2/sreens/result/chartses/line_chart.dart';
import 'package:scrollable_table_view/scrollable_table_view.dart';
import 'package:rchapp_v2/data/apiservice.dart';
import 'package:intl/intl.dart';

class LabDataScreen extends StatefulWidget {
  final String title;
  final ApiService apiService;

  LabDataScreen({super.key, required this.title, ApiService? apiService})
      : apiService = apiService ?? ApiService();

  @override
  _LabDataScreenState createState() => _LabDataScreenState();
}

class _LabDataScreenState extends State<LabDataScreen> {
  // late Future<List<LabApplication>> _futureLabData;
  late Future<dynamic> _getLabResults;
  late Future<dynamic> _getLabResultsAll;
  late Future<dynamic> _futureGraphData;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() {
    setState(() {
      // _futureLabData = widget.apiService.fetchLabData();
      _getLabResults = widget.apiService.getLabResults();
      _getLabResultsAll = widget.apiService.getLabResultsAll();
      _futureGraphData = widget.apiService.getLabResultsAll();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: SizedBox(
            width: 120,
            child: Image.asset('assets/images/icons.png'),
          ),
          centerTitle: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(25),
                bottomLeft: Radius.circular(25)),
          ),
          bottom: const TabBar(
            tabs: [
              Tab(text: "To Day"),
              Tab(text: "All"),
              Tab(
                text: "Graph",
              )
            ],
          ),
        ),
        body: TabBarView(
          children: [
            FutureBuilder<dynamic>(
              future: _getLabResults,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error: ${snapshot.error}',
                      style: const TextStyle(color: Colors.red, fontSize: 16.0),
                    ),
                  );
                } else if (!snapshot.hasData ||
                    (snapshot.data as List).isEmpty) {
                  return const Center(
                    child: Text(
                      'No data available',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  );
                } else {
                  // Ensure snapshot data is a list
                  final List allTableData = snapshot.data;
                  final screenWidth = MediaQuery.of(context).size.width;
                  final columnWidth = screenWidth / 3;

                  // Define headers
                  final headers = ["รายการตรวจ", "ผลการตรวจ", "ค่าปกติ"];

                  // Create header widgets
                  final headerWidgets = headers.map((header) {
                    return TableViewHeader(
                      minWidth: columnWidth,
                      alignment: Alignment.center,
                      label: header,
                      textStyle: const TextStyle(
                        fontSize: 13.0,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  }).toList();

                  // Map the JSON data to table rows
                  final rows = allTableData.map((record) {
                    return TableViewRow(
                      height: 60,
                      cells: [
                        TableViewCell(
                          child: Text(
                            record['AppLabName'] ?? '',
                            style: const TextStyle(fontSize: 11.00),
                          ),
                        ),
                        TableViewCell(
                          child: Text(
                            record['LabResultValue'] ?? '',
                            style: const TextStyle(fontSize: 11.00),
                          ),
                        ),
                        TableViewCell(
                          child: Text(
                            record['LabResultMIN'] ?? '',
                            style: const TextStyle(fontSize: 11.00),
                          ),
                        ),
                      ],
                    );
                  }).toList();

                  // Render the ScrollableTableView
                  return ScrollableTableView(
                    headers: headerWidgets,
                    rows: rows,
                  );
                }
              },
            ),

            // Second tab content (can be customized for "All")
            FutureBuilder<dynamic>(
              future: _getLabResultsAll,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error: ${snapshot.error}',
                      style: const TextStyle(color: Colors.red, fontSize: 16),
                    ),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No data available'));
                } else {
                  final allTableData = snapshot.data!;
                  final screenWidth = MediaQuery.of(context).size.width;

// Dynamically extract headers from the first data item
                  final headers = allTableData.isNotEmpty
                      ? (allTableData[0] as Map<String, dynamic>).keys.toList()
                      : [];

// Determine column count dynamically
                  final colnum = headers.length <= 3 ? headers.length : 3;
                  final columnWidth = screenWidth / colnum;

// Generate header widgets dynamically
                  final headerWidgets = headers.map((header) {
                    return TableViewHeader(
                      minWidth: columnWidth,
                      alignment: Alignment.center,
                      label: header,
                      textStyle: const TextStyle(fontSize: 13.00),
                    );
                  }).toList();

// Modify the first header if there are multiple headers
                  if (headerWidgets.length > 1) {
                    headerWidgets[0] = TableViewHeader(
                      minWidth: columnWidth,
                      alignment: Alignment.center,
                      label: 'รายการตรวจ', // Updated header label
                      textStyle: const TextStyle(fontSize: 13.00),
                    );
                  }

// Generate row widgets dynamically based on data
                  final tableRows = allTableData.map<TableViewRow>((labApp) {
                    final cells = headers.map((header) {
                      final cellValue = labApp[header]?.toString();
                      return TableViewCell(
                        child: InkWell(
                          onTap: (cellValue?.isNotEmpty ?? false)
                              ? () {
                                  print('Tapped cell with value: $cellValue');
                                }
                              : null,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                              cellValue ?? '-',
                              style: const TextStyle(fontSize: 12.0),
                            ),
                          ),
                        ),
                      );
                    }).toList();

                    return TableViewRow(
                      height: 60,
                      cells: cells,
                    );
                  }).toList();

// Pass the headerWidgets and tableRows to ScrollableTableView
                  return ScrollableTableView(
                    headers: headerWidgets,
                    rows: tableRows,
                  );
                }
              },
            ),
            // Third tab content (can be customized for "Graph")
            FutureBuilder<dynamic>(
              future: _futureGraphData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error: ${snapshot.error}',
                      style: const TextStyle(color: Colors.red, fontSize: 16.0),
                    ),
                  );
                } else if (!snapshot.hasData ||
                    (snapshot.data as List).isEmpty) {
                  return const Center(
                    child: Text(
                      'No data available',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  );
                } else {
                  final List allData = snapshot.data;
                  final List<Widget> buttons = allData.map<Widget>((record) {
                    final String appLabName = record['AppLabName'] ?? 'Unknown';

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: GradientButton(
                        label: appLabName,
                        onTap: () {
                          final List<FlSpot> spots = record.entries
                              .where((entry) =>
                                  entry.key != 'AppLabName' &&
                                  entry.value != null) // Filter valid entries
                              .toList()
                              .asMap() // Map entries to get an index
                              .entries
                              .map((indexedEntry) {
                                try {
                                  // Parse the date key as the x value
                                  final DateTime date = DateFormat("yyyy-MM-dd")
                                      .parse(indexedEntry.value.key);
                                  final double x =
                                      date.millisecondsSinceEpoch.toDouble();

                                  // Parse the value (indexedEntry.value.value) to a double, accounting for commas
                                  final y = indexedEntry.value.value is num
                                      ? (indexedEntry.value.value as num)
                                          .toDouble()
                                      : double.tryParse(indexedEntry.value.value
                                              .toString()
                                              .replaceAll(',', '')) ??
                                          0.0;

                                  // Return the FlSpot
                                  return FlSpot(x, y);
                                } catch (e) {
                                  debugPrint(
                                      'Error processing entry: ${indexedEntry.value}, Error: $e');
                                  return null; // Skip invalid entries
                                }
                              })
                              .whereType<
                                  FlSpot>() // Exclude null FlSpot entries
                              .toList();

                          _showChartDialog(context, spots);
                        },
                      ),
                    );
                  }).toList();
                  return ListView.builder(
                    padding: const EdgeInsets.all(8.0),
                    itemCount: buttons.length,
                    itemBuilder: (context, index) => buttons[index],
                  );
                }
              },
            )
          ],
        ),
      ),
    );
  }
}

void _showChartDialog(BuildContext context, List<FlSpot> spots) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Close',
    pageBuilder: (context, animation, secondaryAnimation) {
      return SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Row 1: Line chart
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Card(
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // const Text(
                              //   'แผนภูมิเส้น',
                              //   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              // ),
                              // const SizedBox(height: 8),
                              SizedBox(
                                height: 310,
                                child: LineCharts(spots: spots), // Ensure LineCharts accepts `spots`
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Row 2: Bar chart
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Card(
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // const Text(
                              //   'แผนภูมิแท่ง',
                              //   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              // ),
                              // const SizedBox(height: 8),
                              SizedBox(
                                height: 310,
                                child: BarChartWidget(
                                  data: spots
                                      .asMap()
                                      .entries
                                      .map((entry) => {
                                    'label': 'Day ${entry.key + 1}',
                                    'value': entry.value.y,
                                  })
                                      .toList(),
                                ), // Pass properly formatted data
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Row 3: Categories, Earnings, Sales
                Row(
                  children: [
                    _buildCard('ค่าปัจจุบัน', '25', Colors.purple),
                    _buildCard('ค่ากลาง', '3,200', Colors.red),
                    _buildCard('ค่าสูงสุด/ต่ำสุด', '43', Colors.orange),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      final tween = Tween(begin: const Offset(0, 1), end: Offset.zero);
      return SlideTransition(
        position: tween.animate(
          CurvedAnimation(parent: animation, curve: Curves.easeInOut),
        ),
        child: child,
      );
    },
  );
}

Widget _buildCard(String title, String value, Color color) {
  return Expanded(
    child: Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 16, color: color, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    ),
  );
}

class GradientButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const GradientButton({required this.label, required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.purple, Colors.blue, Colors.green],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black,
              blurRadius: 4,
              offset: const Offset(2, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Icon(Icons.arrow_forward, color: Colors.white),
          ],
        ),
      ),
    );
  }
}


