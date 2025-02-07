import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:rchapp_v2/widget/animatedviruspainter.dart';

class MedicalHistoryPage extends StatefulWidget {
  const MedicalHistoryPage({super.key, required String title});

  @override
  State<MedicalHistoryPage> createState() => _MedicalHistoryPageState();
}

class _MedicalHistoryPageState extends State<MedicalHistoryPage>
    with SingleTickerProviderStateMixin {
  final List<Map<String, String>> medicalRecords = [
    {
      "date": "2024-01-10",
      "doctor": "Dr. King",
      "diagnosis": "Flu",
      "notes": "Prescribed rest and hydration."
    },
    {
      "date": "2023-11-22",
      "doctor": "Dr. King",
      "diagnosis": "Allergy",
      "notes": "Prescribed antihistamines. Avoid peanuts."
    },
    {
      "date": "2023-08-15",
      "doctor": "Dr. King",
      "diagnosis": "Back Pain",
      "notes": "Recommended physiotherapy."
    },
    {
      "date": "2023-04-05",
      "doctor": "Dr. King",
      "diagnosis": "Cold and Cough",
      "notes": "Advised over-the-counter medication."
    },
  ];

  late List<VirusObject> _viruses;
  late Ticker _ticker;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _initializeViruses();

    // Start animation loop
    _ticker = createTicker((_) {
      setState(() {
        for (var virus in _viruses) {
          virus.move(MediaQuery.of(context).size);
        }
      });
    })..start();
  }

  void _initializeViruses() {
    _viruses = List.generate(10, (index) {
      return VirusObject(
        position: Offset(_random.nextDouble() * 400, _random.nextDouble() * 800),
        radius: _random.nextDouble() * 30 + 15,
        color: Colors.greenAccent,
        velocity:
        Offset(_random.nextDouble() * 3 - 1.5, _random.nextDouble() * 3 - 1.5),
      );
    });
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

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
              bottomRight: Radius.circular(25), bottomLeft: Radius.circular(25)),
        ),
      ),
      body: Stack(
        children: [
          // Moving Virus Background
          Positioned.fill(
            child: CustomPaint(painter: AnimatedVirusPainter(_viruses)),
          ),

          // Medical Records List
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.85), // Background for readability
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: ListView.builder(
                physics: const BouncingScrollPhysics(), // Smooth scrolling
                itemCount: medicalRecords.length,
                itemBuilder: (context, index) {
                  final record = medicalRecords[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
                    elevation: 8, // Increased elevation for depth
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "📅 Date: ${record["date"]}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "👨‍⚕️ Doctor: ${record["doctor"]}",
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.blueGrey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "🩺 Diagnosis: ${record["diagnosis"]}",
                            style: const TextStyle(fontSize: 14),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "📝 Notes: ${record["notes"]}",
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
