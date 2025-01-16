import 'package:flutter/material.dart';

class BuyHistoryPage extends StatelessWidget {
  final List<Map<String, String>> purchaseHistory = [
    {"date": "2024-12-10", "item": "แพ็คเก็จตรวจหัวใจ", "price": "\$59.99"},
    {"date": "2024-11-25", "item": "แพ็คเก็จตัวมะเร็ง", "price": "\$699.00"},
    {
      "date": "2024-11-15",
      "item": "แพ็คเก็จตรวจวัดสายตา",
      "price": "\$1200.00"
    },
    {"date": "2024-10-30", "item": "แพ็คเก็จ Botox", "price": "\$199.99"},
  ];

  BuyHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView.builder(
          itemCount: purchaseHistory.length,
          itemBuilder: (context, index) {
            final purchase = purchaseHistory[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: ListTile(
                leading: const Icon(
                  Icons.shopping_bag,
                ),
                title: Text(
                  purchase["item"]!,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                subtitle: Text("Date: ${purchase["date"]}"),
                trailing: Text(
                  purchase["price"]!,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
