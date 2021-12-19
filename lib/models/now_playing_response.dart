import 'package:peliculas/models/model.dart';

class NowPlaying {
  Dates? dates;
  int page = 0;
  List<Movies> results = [];
  int totalPages = 0;
  int totalResults = 0;

  NowPlaying({
    required this.dates,
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  NowPlaying.fromJson(Map<String, dynamic> json) {
    dates = (json['dates'] != null ? Dates.fromJson(json['dates']) : null)!;
    page = json['page'];
    if (json['results'] != null) {
      results = <Movies>[];
      json['results'].forEach((v) {
        results.add(Movies.fromJson(v));
      });
    }
    totalPages = json['total_pages'];
    totalResults = json['total_results'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['dates'] = dates?.toJson();
    data['page'] = page;
    data['results'] = results.map((v) => v.toJson()).toList();
    data['total_pages'] = totalPages;
    data['total_results'] = totalResults;
    return data;
  }
}

class Dates {
  String maximum = '';
  String minimum = '';

  Dates({required this.maximum, required this.minimum});

  Dates.fromJson(Map<String, dynamic> json) {
    maximum = json['maximum'];
    minimum = json['minimum'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['maximum'] = maximum;
    data['minimum'] = minimum;
    return data;
  }
}
