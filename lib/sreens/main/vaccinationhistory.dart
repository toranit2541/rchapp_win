import 'package:flutter/material.dart';

class VaccinationHistoryPage extends StatelessWidget {
  final List<Map<String, String>> vaccinationRecords = [
    {
      "vaccineName": "COVID-19 Vaccine (Pfizer)",
      "date": "2023-06-15",
      "provider": "โรงพยาบาลรวมชัยประชารักษ์",
      "status": "Completed"
    },
    {
      "vaccineName": "Influenza Vaccine",
      "date": "2022-10-10",
      "provider": "โรงพยาบาลรวมชัยประชารักษ์",
      "status": "Completed"
    },
    {
      "vaccineName": "Hepatitis B",
      "date": "2021-03-05",
      "provider": "โรงพยาบาลรวมชัยประชารักษ์",
      "status": "Completed"
    },
    {
      "vaccineName": "Tetanus Booster",
      "date": "2020-11-20",
      "provider": "โรงพยาบาลรวมชัยประชารักษ์",
      "status": "Completed"
    },
  ];

  VaccinationHistoryPage({super.key, required String title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: vaccinationRecords.length,
          itemBuilder: (context, index) {
            final record = vaccinationRecords[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 10.0),
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Vaccine: ${record["vaccineName"]}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "Date: ${record["date"]}",
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "Provider: ${record["provider"]}",
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        const Text(
                          "Status: ",
                          style: TextStyle(fontSize: 14),
                        ),
                        Text(
                          record["status"]!,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: record["status"] == "Completed"
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
