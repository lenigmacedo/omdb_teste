import 'dart:convert';
import 'package:omdb_teste/model/movie_model.dart';
import 'package:http/http.dart' as http;

class MoviesService {
  Future<List<Movie>> getMovies(String search) async {
    var response =
        await http.get('http://www.omdbapi.com/?s=$search&apikey=23e83391');
    var movies = <Movie>[];

    List data = json.decode(response.body)['Search'];

    if (data == null) {
      return data;
    } else {
      data.forEach((f) => movies.add((Movie(
            f["Title"],
            f["Poster"],
            f["imdbID"],
          ))));

      return movies;
    }
  }
}
