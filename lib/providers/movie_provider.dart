import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:peliculas/helpers/debouncer.dart';
import 'package:peliculas/models/model.dart';
import 'package:peliculas/models/search_movie_response.dart';

class MovieProvider extends ChangeNotifier {
  final String _appKey = dotenv.env['API_KEY'] ?? '';
  final String _language = dotenv.env['LANGUAGE'] ?? '';
  final String _baseUrl =
      dotenv.env['BASE_URL']?.replaceAll('https://', '') ?? '';

  List<Movies> movie = [];
  List<Movies> moviePopular = [];
  int _page = 0;
  bool _isLoading = true;
  Map<int, List<Person>> movieCast = {};
  Map<int, List<Person>> movieCrew = {};
  Map<int, Actor> actor = {};

  final debouncer = Debouncer(
    duration: const Duration(
      milliseconds: 500,
    ),
  );

  final StreamController<List<Movies>> _streamController =
      StreamController.broadcast();

  Stream<List<Movies>> get suggestionStream => _streamController.stream;

  MovieProvider() {
    getOnDisplayMovie();
    getOnDisplayMoviePopular();
  }

  Future<Map<String, dynamic>> _getJsonData(String path,
      [int page = 1, String query = '']) async {
    final url = Uri.https(_baseUrl, '3/$path', {
      'api_key': _appKey,
      'language': _language,
      'page': '$page',
      'query': query
    });

    final response = await http.get(url);
    final Map<String, dynamic> dataMap = json.decode(response.body);
    return dataMap;
  }

  getOnDisplayMovie() async {
    final getJsonData = await _getJsonData('movie/now_playing');
    final data = NowPlaying.fromJson(getJsonData);
    movie = data.results;
    notifyListeners();
  }

  getOnDisplayMoviePopular() async {
    if (_isLoading) {
      _isLoading = false;
      _page++;
      final getJsonData = await _getJsonData('movie/popular', _page);
      _isLoading = true;
      final data = PopularResponse.fromJson(getJsonData);
      moviePopular = [...moviePopular, ...data.results];
      notifyListeners();
    }
  }

  Future<List<Person>> getMovieCast(movieId) async {
    if (movieCast.containsKey(movieId)) return movieCast[movieId]!;
    final getJsonData = await _getJsonData('movie/$movieId/credits');
    final data = CreditsResponse.fromJson(getJsonData);
    movieCast[movieId] = data.cast;
    return data.cast;
  }

  Future<List<Person>> getMovieCrew(movieId) async {
    if (movieCrew.containsKey(movieId)) return movieCrew[movieId]!;
    final getJsonData = await _getJsonData('movie/$movieId/credits');
    final data = CreditsResponse.fromJson(getJsonData);
    movieCast[movieId] = data.cast;
    return data.crew;
  }

  Future<List<Movies>> searchMovies(String query) async {
    final getJsonData = await _getJsonData('search/movie', 1, query);
    final data = SearchMovieResponse.fromJson(getJsonData);
    return data.results;
  }

  void getSuggestionsByQuery(String search) {
    debouncer.value = '';
    debouncer.onValue = (value) async {
      final result = await searchMovies(value);
      _streamController.add(result);
    };
    final timer = Timer.periodic(const Duration(milliseconds: 300), (_) {
      debouncer.value = search;
    });
    Future.delayed(const Duration(milliseconds: 301))
        .then((_) => timer.cancel());
  }

  Future<Actor> getActor(String idActor) async {
    final getJsonData = await _getJsonData('person/$idActor');
    final data = Actor.fromJson(getJsonData);
    return data;
  }

  Future<List<Movies>> getSimilar(idMovie) async {
    _page++;
    final getJsonData = await _getJsonData('/movie/$idMovie/similar', _page);
    _isLoading = true;
    final data = PopularResponse.fromJson(getJsonData);
    return data.results;
  }

  Future<List<Movies>> getRecommendations(idMovie) async {
    _page++;
    final getJsonData =
        await _getJsonData('/movie/$idMovie/recommendations', _page);
    _isLoading = true;
    final data = PopularResponse.fromJson(getJsonData);
    return data.results;
  }
}
