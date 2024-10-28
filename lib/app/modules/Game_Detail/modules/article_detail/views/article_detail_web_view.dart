import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../data/models/article.dart'; // Ensure this points to the correct model
import '../controllers/article_detail_controller.dart';

// ignore: must_be_immutable
class ArticleDetailWebView extends GetView<ArticleDetailController> {
  final Articles article; // Change from Article to Articles

  const ArticleDetailWebView({
    super.key,
    required this.article,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("WebView"),
      ),
      body: WebViewWidget(
        controller: controller
            .webViewController(article.gameUrl), // Use gameUrl for the WebView
      ),
    );
  }
}
