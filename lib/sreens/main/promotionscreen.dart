import 'package:flutter/material.dart';
import 'package:rchapp_v2/data/apiservice.dart';

class PromotionScreen extends StatefulWidget {
  const PromotionScreen({super.key});

  @override
  State<PromotionScreen> createState() => _PromotionScreenState();
}

class _PromotionScreenState extends State<PromotionScreen> {
  bool isLoading = true;
  List<Map<String, dynamic>> promotions = [];

  @override
  void initState() {
    super.initState();
    fetchPromotion();
  }

  void fetchPromotion() async {
    try {
      final apiService = ApiService();
      final promotionData = await apiService.getPromotion();

      setState(() {
        promotions = List<Map<String, dynamic>>.from(promotionData);
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching promotions: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Promotions'),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.symmetric(
                vertical: 10.0,
                horizontal: 8.0,
              ),
              shrinkWrap: true,
              itemCount: promotions.length,
              itemBuilder: (context, index) {
                final promotion = promotions[index];
                return Card(
                  color: Colors.blueGrey.shade200,
                  elevation: 5.0,
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        const Image(
                          height: 80,
                          width: 80,
                          image: AssetImage('assets/images/64/ic-vc64.png'),
                        ),
                        SizedBox(
                          width: 130,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 5.0),
                              RichText(
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                text: TextSpan(
                                  text: 'Name: ',
                                  style: TextStyle(
                                      color: Colors.blueGrey.shade800,
                                      fontSize: 16.0),
                                  children: [
                                    TextSpan(
                                      text: promotion['name'] ?? 'N/A',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                              RichText(
                                maxLines: 1,
                                text: TextSpan(
                                  text: 'Unit: ',
                                  style: TextStyle(
                                      color: Colors.blueGrey.shade800,
                                      fontSize: 16.0),
                                  children: [
                                    TextSpan(
                                      text: promotion['unit']?.toString() ??
                                          'N/A',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                              RichText(
                                maxLines: 1,
                                text: TextSpan(
                                  text: 'Price: ' r"$",
                                  style: TextStyle(
                                      color: Colors.blueGrey.shade800,
                                      fontSize: 16.0),
                                  children: [
                                    TextSpan(
                                      text: promotion['price']?.toString() ??
                                          'N/A',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blueGrey.shade900,
                                ),
                                onPressed: () {
                                  // Add your onPressed functionality here
                                },
                                child: const Text('Add to Cart'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
