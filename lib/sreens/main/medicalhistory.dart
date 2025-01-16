import 'package:flutter/material.dart';

class MedicalHistoryPage extends StatelessWidget {
  final List<Map<String, String>> medicalRecords = [
    {
      "date": "2024-01-10",
      "doctor": "Dr. king",
      "diagnosis": "Flu",
      "notes": "Prescribed rest and hydration."
    },
    {
      "date": "2023-11-22",
      "doctor": "Dr. king",
      "diagnosis": "Allergy",
      "notes": "Prescribed antihistamines. Avoid peanuts."
    },
    {
      "date": "2023-08-15",
      "doctor": "Dr. king",
      "diagnosis": "Back Pain",
      "notes": "Recommended physiotherapy."
    },
    {
      "date": "2023-04-05",
      "doctor": "Dr. king",
      "diagnosis": "Cold and Cough",
      "notes": "Advised over-the-counter medication."
    },
  ];

  MedicalHistoryPage({super.key, required String title});

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
          itemCount: medicalRecords.length,
          itemBuilder: (context, index) {
            final record = medicalRecords[index];
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
                      "Date: ${record["date"]}",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "Doctor: ${record["doctor"]}",
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "Diagnosis: ${record["diagnosis"]}",
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "Notes: ${record["notes"]}",
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
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
