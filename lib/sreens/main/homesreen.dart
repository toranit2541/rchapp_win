import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:rchapp_v2/data/apiservice.dart';
import 'package:rchapp_v2/sreens/main/contactpage.dart';
import 'package:rchapp_v2/sreens/main/medicalhistory.dart';
import 'package:rchapp_v2/sreens/main/newspage.dart';
import 'package:rchapp_v2/sreens/main/shopping.dart';
import 'package:rchapp_v2/sreens/main/vaccinationhistory.dart';
import 'package:rchapp_v2/sreens/result/LabDataScreen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CarouselSliderController controller = CarouselSliderController();
  List<ImageInfo> dynamicImageInfo = [];
  List<String> imgList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPopulation();
    fetchPromotion();
  }

  Future<void> fetchPopulation() async {
    try {
      final apiService = ApiService();
      final population = await apiService.getPopulation();
      setState(() {
        dynamicImageInfo = population.map<ImageInfo>((data) {
          return ImageInfo(
            '',
            '',
            data['file'] ?? '',
          );
        }).toList();
      });
    } catch (error) {
      showError(context, 'Failed to load population data');
    }
  }

  Future<void> fetchPromotion() async {
    try {
      final apiService = ApiService();
      final promotion = await apiService.getPromotion();
      setState(() {
        imgList = List<String>.from(
          promotion.map((item) =>
              item['file'] ?? 'https://marketplace.canva.com/EAGP6SRTq5I/1/0/1600w/canva-%E0%B8%AA%E0%B8%B5%E0%B8%8A%E0%B8%A1%E0%B8%9E%E0%B8%B9-%E0%B8%AA%E0%B8%B5%E0%B8%82%E0%B8%B2%E0%B8%A7-%E0%B8%99%E0%B9%88%E0%B8%B2%E0%B8%A3%E0%B8%B1%E0%B8%81-%E0%B9%82%E0%B8%A1%E0%B9%80%E0%B8%94%E0%B8%B4%E0%B8%A3%E0%B9%8C%E0%B8%99-%E0%B9%82%E0%B8%9B%E0%B8%A3%E0%B9%82%E0%B8%A1%E0%B8%8A%E0%B8%B1%E0%B9%88%E0%B8%99-%E0%B8%84%E0%B8%A5%E0%B8%B4%E0%B8%99%E0%B8%B4%E0%B8%81%E0%B8%84%E0%B8%A7%E0%B8%B2%E0%B8%A1%E0%B8%87%E0%B8%B2%E0%B8%A1-instagram-post-frW2D8xA63c.jpg'),
        );
        isLoading = false; // Ensure loading state is updated
      });
    } catch (error) {
      showError(context, 'Failed to load Promotion data');
    }
  }

  void showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;

    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCarousel(height),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.count(
                crossAxisCount: 3,
                shrinkWrap: true,
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildGridItem(
                    context,
                    Icons.assignment_rounded,
                    'ผลตรวจ\nสุขภาพ',
                    LabDataScreen(
                      title: 'ผลตรวจสุขภาพ',
                    ),
                  ),
                  // _buildGridItem(
                  //   context,
                  //   Icons.calendar_month_rounded,
                  //   'หมอนัด',
                  //   const AppointmentScreen(
                  //     title: 'หมอนัด',
                  //   ),
                  // ),
                  _buildGridItem(
                    context,
                    Icons.shopify_rounded,
                    'บริการ\nโรงพยาบาล',
                    const ShoppingPage(),
                  ),
                  _buildGridItem(
                    context,
                    Icons.newspaper_rounded,
                    'ข่าวสาร',
                    NewsPage(),
                  ),
                  _buildGridItem(
                    context,
                    Icons.event_repeat_rounded,
                    'ประวัติ\nการรักษา',
                    MedicalHistoryPage(
                      title: 'ประวัติการรักษา',
                    ),
                  ),
                  _buildGridItem(
                    context,
                    Icons.vaccines_rounded,
                    'ประวัติ\nฉีดวัคซีน',
                    VaccinationHistoryPage(
                      title: 'ประวัติฉีดวัคซีน',
                    ),
                  ),
                  _buildGridItem(
                    context,
                    Icons.contact_phone_rounded,
                    'สมุดโทรศัพท์',
                    ContractPage(
                      title: 'สมุดโทรศัพท์',
                    ),
                  ),
                ],
              ),
            ),
            _buildSectionHeader("คุณอาจสนใจ !!", Icons.medical_services),
            const SizedBox(height: 10),
            _buildPromotionCarousel(),
          ],
        ),
      ),
    );
  }

  Widget _buildCarousel(double height) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: height / 2),
      child: CarouselSlider(
        carouselController: controller,
        options: CarouselOptions(
          height: height / 2,
          autoPlay: true,
          enlargeCenterPage: true,
          viewportFraction: 0.8,
        ),
        items: dynamicImageInfo.map((image) {
          return HeroLayoutCard(imageInfo: image);
        }).toList(),
      ),
    );
  }

  Widget _buildPromotionCarousel() {
    if (imgList.isEmpty) {
      return Center(child: Text('No promotions available'));
    }
    return CarouselSlider(
      options: CarouselOptions(
        aspectRatio: 2.0,
        enlargeCenterPage: true,
        enableInfiniteScroll: false,
        initialPage: 2,
        autoPlay: true,
      ),
      items: imgList.map((item) {
        return Container(
          margin: const EdgeInsets.all(5.0),
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(5.0)),
            child: Image.network(
              item,
              // 'https://marketplace.canva.com/EAGP6SRTq5I/1/0/1600w/canva-%E0%B8%AA%E0%B8%B5%E0%B8%8A%E0%B8%A1%E0%B8%9E%E0%B8%B9-%E0%B8%AA%E0%B8%B5%E0%B8%82%E0%B8%B2%E0%B8%A7-%E0%B8%99%E0%B9%88%E0%B8%B2%E0%B8%A3%E0%B8%B1%E0%B8%81-%E0%B9%82%E0%B8%A1%E0%B9%80%E0%B8%94%E0%B8%B4%E0%B8%A3%E0%B9%8C%E0%B8%99-%E0%B9%82%E0%B8%9B%E0%B8%A3%E0%B9%82%E0%B8%A1%E0%B8%8A%E0%B8%B1%E0%B9%88%E0%B8%99-%E0%B8%84%E0%B8%A5%E0%B8%B4%E0%B8%99%E0%B8%B4%E0%B8%81%E0%B8%84%E0%B8%A7%E0%B8%B2%E0%B8%A1%E0%B8%87%E0%B8%B2%E0%B8%A1-instagram-post-frW2D8xA63c.jpg',
              fit: BoxFit.cover,
              width: 1000.0,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildGridItem(
      BuildContext context, IconData icon, String label, Widget destination) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => destination),
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            backgroundColor: const Color(0xFFb1d8b7),
            child: Icon(icon, color: const Color(0xFFFFFFFF)),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 8.50, decorationThickness: 10.50),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF76b947)),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

class HeroLayoutCard extends StatelessWidget {
  const HeroLayoutCard({
    super.key,
    required this.imageInfo,
  });

  final ImageInfo imageInfo;

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Stack(
      alignment: AlignmentDirectional.bottomStart,
      children: <Widget>[
        ClipRect(
          child: OverflowBox(
            maxWidth: width * 7 / 8,
            minWidth: width * 7 / 8,
            child: Image.network(
              imageInfo.url,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            (loadingProgress.expectedTotalBytes ?? 1)
                        : null,
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return Center(
                  child: Text('Failed to load image'),
                );
              },
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                imageInfo.title,
                overflow: TextOverflow.clip,
                softWrap: false,
                style: Theme.of(context)
                    .textTheme
                    .headlineLarge
                    ?.copyWith(color: Colors.white),
              ),
              const SizedBox(height: 10),
              Text(
                imageInfo.subtitle,
                overflow: TextOverflow.clip,
                softWrap: false,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: Colors.white),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ImageInfo {
  final String title;
  final String subtitle;
  final String url;

  ImageInfo(this.title, this.subtitle, this.url);
}
