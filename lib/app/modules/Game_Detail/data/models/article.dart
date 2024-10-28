// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

List<Articles> welcomeFromJson(String str) =>
    List<Articles>.from(json.decode(str).map((x) => Articles.fromJson(x)));

String welcomeToJson(List<Articles> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Articles {
  int id;
  String title;
  String thumbnail;
  String shortDescription;
  String gameUrl;
  Genre genre;
  Platform platform;
  String publisher;
  String developer;
  String releaseDate;
  String freetogameProfileUrl;

  Articles({
    required this.id,
    required this.title,
    required this.thumbnail,
    required this.shortDescription,
    required this.gameUrl,
    required this.genre,
    required this.platform,
    required this.publisher,
    required this.developer,
    required this.releaseDate,
    required this.freetogameProfileUrl,
  });

  factory Articles.fromJson(Map<String, dynamic> json) => Articles(
        id: json["id"],
        title: json["title"],
        thumbnail: json["thumbnail"],
        shortDescription: json["short_description"],
        gameUrl: json["game_url"],
        genre: genreValues.map[json["genre"]]!,
        platform: platformValues.map[json["platform"]]!,
        publisher: json["publisher"],
        developer: json["developer"],
        releaseDate: json["release_date"],
        freetogameProfileUrl: json["freetogame_profile_url"],
      );

  get urlToImage => null;

  get author => null;

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "thumbnail": thumbnail,
        "short_description": shortDescription,
        "game_url": gameUrl,
        "genre": genreValues.reverse[genre],
        "platform": platformValues.reverse[platform],
        "publisher": publisher,
        "developer": developer,
        "release_date": releaseDate,
        "freetogame_profile_url": freetogameProfileUrl,
      };
}

enum Genre {
  ACTION,
  BATTLE_ROYALE,
  FIGHTING,
  MMO,
  MMORPG,
  MOBA,
  SHOOTER,
  STRATEGY
}

final genreValues = EnumValues({
  "Action": Genre.ACTION,
  "Battle Royale": Genre.BATTLE_ROYALE,
  "Fighting": Genre.FIGHTING,
  "MMO": Genre.MMO,
  "MMORPG": Genre.MMORPG,
  "MOBA": Genre.MOBA,
  "Shooter": Genre.SHOOTER,
  "Strategy": Genre.STRATEGY
});

enum Platform { PC_WINDOWS, PC_WINDOWS_WEB_BROWSER, WEB_BROWSER }

final platformValues = EnumValues({
  "PC (Windows)": Platform.PC_WINDOWS,
  "PC (Windows), Web Browser": Platform.PC_WINDOWS_WEB_BROWSER,
  "Web Browser": Platform.WEB_BROWSER
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
