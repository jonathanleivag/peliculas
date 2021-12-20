class Person {
  bool adult = false;
  int? gender;
  int id = 0;
  String knownForDepartment = '';
  String name = '';
  String originalName = '';
  double popularity = 0.0;
  String? profilePath;
  int? castId;
  String? character;
  String creditId = '';
  int? order;

  String? department;
  String? job;

  Person({
    required this.adult,
    this.gender,
    required this.id,
    required this.knownForDepartment,
    required this.name,
    required this.originalName,
    required this.popularity,
    this.profilePath,
    this.castId,
    required this.character,
    required this.creditId,
    this.order,
    this.department,
    this.job,
  });

  Person.fromJson(Map<String, dynamic> json) {
    adult = json['adult'];
    gender = json['gender'];
    id = json['id'];
    knownForDepartment = json['known_for_department'];
    name = json['name'];
    originalName = json['original_name'];
    popularity = json['popularity'];
    profilePath = json['profile_path'];
    castId = json['cast_id'];
    character = json['character'];
    creditId = json['credit_id'];
    order = json['order'];

    department = json['department'];
    job = json['job'];
  }

  get fullProfilePath {
    String img = 'https://i.stack.imgur.com/GNhxO.png';

    if (profilePath != null) {
      img = 'https://image.tmdb.org/t/p/w500$profilePath';
    }

    return img;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['adult'] = adult;
    data['gender'] = gender;
    data['id'] = id;
    data['known_for_department'] = knownForDepartment;
    data['name'] = name;
    data['original_name'] = originalName;
    data['popularity'] = popularity;
    data['profile_path'] = profilePath;
    data['cast_id'] = castId;
    data['character'] = character;
    data['credit_id'] = creditId;
    data['order'] = order;
    data['department'] = department;
    data['job'] = job;
    return data;
  }
}
