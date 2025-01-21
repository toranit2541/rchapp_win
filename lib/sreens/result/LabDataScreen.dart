import 'dart:core';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:rchapp_v2/sreens/result/chartses/line_chart.dart';
import 'package:scrollable_table_view/scrollable_table_view.dart';
import 'package:rchapp_v2/data/apiservice.dart';

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
            child: Image.asset('assets/images/test/banner.png'),
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

                  // Generate row widgets dynamically based on data
                  final tableRows = allTableData.map<TableViewRow>((labApp) {
                    final cells = headers.map((header) {
                      return TableViewCell(
                        child: Text(
                          labApp[header]?.toString() ?? '-',
                          style: const TextStyle(fontSize: 12.00),
                        ),
                      );
                    }).toList();

                    return TableViewRow(
                      height: 60,
                      cells: cells,
                    );
                  }).toList();

                  if (headerWidgets.length > 1){
                    headerWidgets[0] = 'รายการตรวจ' as TableViewHeader;
                  }
                  return ScrollableTableView(
                    headers: headerWidgets, // Pass the dynamic headers
                    rows: tableRows, // Pass the dynamic rows
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
                                  // The index acts as the x value
                                  final x = (indexedEntry.key + 1).toDouble();

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
          body: Center(
            child: LineCharts(spots: spots),
          ),
        ),
      );
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      final tween = Tween(begin: const Offset(0, 1), end: Offset.zero);
      return SlideTransition(
        position: tween.animate(
            CurvedAnimation(parent: animation, curve: Curves.easeInOut)),
        child: child,
      );
    },
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
              color: Colors.black.withOpacity(0.2),
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
