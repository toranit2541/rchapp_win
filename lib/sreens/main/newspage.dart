import 'dart:math';
import 'package:flutter/material.dart';
import 'package:rchapp_v2/data/apiservice.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  List<Map<String, dynamic>> allArticles = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchNewsAndArticles();
  }

  void fetchNewsAndArticles() async {
    try {
      final apiService = ApiService();
      final newsList = await apiService.getNews();
      final articleList =
          await apiService.getArticle(); // Assuming fetchArticle() exists

      setState(() {
        // Merge both lists
        allArticles = List<Map<String, dynamic>>.from(newsList + articleList);

        // Shuffle the list to randomize order
        allArticles.shuffle(Random());

        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching data: $e');
    }
  }

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
            bottomLeft: Radius.circular(25),
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : allArticles.isEmpty
              ? const Center(
                  child: Text("No News and Article available"),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(8.0),
                  itemCount: allArticles.length,
                  itemBuilder: (context, index) {
                    final article = allArticles[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 10.0),
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  NewsDetailPage(article: article),
                            ),
                          );
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(15.0)),
                              child: Image.network(article["file"],
                                  fit: BoxFit.cover),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                article["title"],
                                style: const TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                article["content"] ?? "No description",
                                style: const TextStyle(
                                    fontSize: 14.0, color: Colors.grey),
                              ),
                            ),
                            const SizedBox(height: 8.0),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}

class NewsDetailPage extends StatelessWidget {
  final Map<String, dynamic> article;

  const NewsDetailPage({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SizedBox(
          width: 120,
          child: Image.asset('assets/images/icons.png'),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: Image.network(article["file"], fit: BoxFit.cover),
            ),
            const SizedBox(height: 16.0),
            Text(
              article["title"],
              style:
                  const TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Text(
              article["content"] ?? "No content available",
              style: const TextStyle(fontSize: 16.0),
            ),
          ],
        ),
      ),
    );
  }
}
