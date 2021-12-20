import 'package:peliculas/models/model.dart';

class CreditsResponse {
  int id = 0;
  List<Person> cast = [];
  List<Person> crew = [];

  CreditsResponse({
    required this.id,
    required this.cast,
    required this.crew,
  });

  CreditsResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    if (json['cast'] != null) {
      cast = <Person>[];
      json['cast'].forEach((v) {
        cast.add(Person.fromJson(v));
      });
    }
    if (json['crew'] != null) {
      crew = <Person>[];
      json['crew'].forEach((v) {
        crew.add(Person.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['cast'] = cast.map((v) => v.toJson()).toList();
    data['crew'] = crew.map((v) => v.toJson()).toList();
    return data;
  }
}
