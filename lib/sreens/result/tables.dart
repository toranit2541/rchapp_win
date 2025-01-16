import 'package:flutter/material.dart';
import 'package:rchapp_v2/data/apimodels.dart';

class Tables extends StatelessWidget {
  final Future<List<LabApplication>> futureLabData;

  const Tables({super.key, required this.futureLabData});

  @override
  Widget build(BuildContext context) {
    const TextStyle headerStyle =
        TextStyle(fontWeight: FontWeight.bold, fontSize: 16);
    const TextStyle cellStyle = TextStyle(fontSize: 14);

    return FutureBuilder<List<LabApplication>>(
      future: futureLabData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error occurred: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No data available'));
        }

        final tableData = snapshot.data!;
        return SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Table(
            border: TableBorder.all(),
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: [
              // Header row
              const TableRow(
                children: [
                  TableCell(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Center(child: Text('สารชีวะเคมี', style: headerStyle)),
                    ),
                  ),
                  TableCell(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Center(child: Text('ผลตรวจ', style: headerStyle)),
                    ),
                  ),
                  TableCell(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Center(child: Text('ค่าปกติ', style: headerStyle)),
                    ),
                  ),
                ],
              ),
              // Data rows
              ...List<TableRow>.generate(
                tableData.length,
                (index) {
                  final row = tableData[index];
                  return TableRow(
                    decoration: BoxDecoration(
                      color: index.isEven ? Colors.grey[200] : null,
                    ),
                    children: [
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Text(
                              '${row.labNameTH} (${row.labNameEN})',
                              style: cellStyle,
                            ),
                          ),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Text(
                              row.labResultCode ?? 'N/A',
                              style: cellStyle,
                            ),
                          ),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Text(
                              row.labMax ?? 'N/A',
                              style: cellStyle,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}