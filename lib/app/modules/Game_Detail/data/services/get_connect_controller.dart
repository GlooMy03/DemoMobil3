import 'package:get/get.dart';
import 'dart:convert';

import '../models/article.dart';

class GetConnectController extends GetxController {
  // Base URL yang sudah Anda tentukan
  static const String _baseUrl =
      'https://www.freetogame.com/api/games?category=shooter';

  RxList<Articles> articles = RxList<Articles>([]); // Changed to Articles
  RxBool isLoading = false.obs;

  // Membuat instance GetConnect
  final GetConnect getConnect = GetConnect();

  @override
  void onInit() async {
    await fetchArticles();
    super.onInit();
  }

  Future<void> fetchArticles() async {
    try {
      isLoading.value = true;
      final response = await getConnect.get(_baseUrl);

      if (response.statusCode == 200) {
        final jsonData = response.bodyString;
        // Directly parse the list of articles
        final List<dynamic> articlesJson = json.decode(jsonData!);
        articles.value = List<Articles>.from(articlesJson
            .map((x) => Articles.fromJson(x))); // Changed to Articles
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('An error occurred: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
