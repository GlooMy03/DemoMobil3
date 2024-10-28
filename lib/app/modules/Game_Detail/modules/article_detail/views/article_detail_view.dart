import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/article.dart'; // Ensure this points to the right model file
import '../controllers/article_detail_controller.dart';
import 'article_detail_web_view.dart';

class ArticleDetailPage extends GetView<ArticleDetailController> {
  final Articles article; // Change from Article to Articles
  const ArticleDetailPage({Key? key, required this.article}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('News App'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Hero(
              tag: article.thumbnail ??
                  article.title, // Changed urlToImage to thumbnail
              child: article.thumbnail != null
                  ? Image.network(
                      article.thumbnail, // Use thumbnail
                      fit: BoxFit.cover,
                    )
                  : Container(
                      color: Colors.grey,
                      child: const Center(
                        child: Text(
                          'No Image',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.shortDescription ?? "-", // Use shortDescription
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const Divider(color: Colors.grey),
                  Text(
                    article.title,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const Divider(color: Colors.grey),
                  Text(
                    'Release Date: ${article.releaseDate}', // Changed to releaseDate
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Publisher: ${article.publisher}', // Changed to publisher
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const Divider(color: Colors.grey),
                  Text(
                    article.shortDescription ?? "-", // Use shortDescription
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    child: const Text('Read more'),
                    onPressed: () {
                      Get.to(() => ArticleDetailWebView(article: article));
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
