import 'package:flutter/material.dart';

class ContractPage extends StatelessWidget {
  final List<Map<String, String>> vaccinationRecords = [
    {
      "Depat": "คอมพิวเตอร์และเทคโนโลยี",
      "Wh": "ชั้น 3",
      "PhNum": "027087501-10 ต่อ 313"
    },
    {
      "Depat": "เวชระเบียน",
      "Wh": "ชั้น 1",
      "PhNum": "027087501-10 ต่อ 107,108"
    },
    {
      "Depat": "ผู้ป่วย VIP",
      "Wh": "ชั้น 1",
      "PhNum": "027087501-10 ต่อ 311"
    },
    {
      "Depat": "ห้องฉุกเฉิน",
      "Wh": "ชั้น 3",
      "PhNum": "027087501-10 ต่อ 103,104"
    },
  ];

  ContractPage({super.key, required String title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      "แผนก: ${record["Depat"]}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "สถานที่: ${record["Wh"]}",
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "เบอร์โทร: ${record["PhNum"]}",
                      style: const TextStyle(fontSize: 14),
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
