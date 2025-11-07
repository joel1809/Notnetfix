// ===========================================================================
// 📦 Importation des dépendances
// ===========================================================================

// Importation de la librairie Dio : un client HTTP très complet pour Flutter.
// Il simplifie les requêtes réseau (GET, POST, PUT, DELETE, etc.) et la gestion des réponses,
// erreurs, en-têtes, et timeouts.
import 'package:dio/dio.dart';

// Import du modèle Movie : permet de transformer les données JSON reçues de l’API
// en objets Dart (instances de la classe Movie).
import 'package:notnetflix/models/movie.dart';
import 'package:notnetflix/models/person.dart';

// Import de la classe API : contient probablement des constantes utiles comme
// l’URL de base de l’API (baseURL), la clé d’authentification (apiKey), et les liens pour les images.
import 'package:notnetflix/services/api.dart';

// ===========================================================================
// 🎬 Classe ApiService
// ---------------------------------------------------------------------------
// Cette classe agit comme un **pont entre ton application et l’API TMDB**
// (The Movie Database). Elle regroupe toutes les fonctions qui récupèrent
// des données de films via des requêtes HTTP.
// ===========================================================================
class ApiService {
  // Instance de la classe API, pour accéder aux constantes (baseURL, apiKey, etc.).
  final API api = API();

  // Instance de Dio, le client HTTP utilisé pour exécuter les requêtes.
  final Dio dio = Dio();

  // -------------------------------------------------------------------------
  // ⚙️ Méthode générique : getData()
  // -------------------------------------------------------------------------
  // Cette méthode centralise la logique pour exécuter une requête GET sur TMDB.
  // Elle est réutilisée par les autres fonctions spécifiques (films populaires, récents, etc.).
  //
  // Arguments :
  // - [path]  : chemin de l’endpoint, ex : "/movie/popular"
  // - [params]: paramètres optionnels pour la requête (ex: {'page': 2})
  Future<Response> getData(String path, {Map<String, dynamic>? params}) async {
    // Création de l’URL complète : baseURL + chemin.
    // Exemple : "https://api.themoviedb.org/3/movie/popular"
    String _url = api.baseURL + path;

    // Création des paramètres de base nécessaires à chaque requête.
    // - api_key : clé d’accès à l’API TMDB (obligatoire pour s’authentifier)
    // - language : langue de la réponse (ici "fr-FR" pour le français)
    Map<String, dynamic> query = {'api_key': api.apiKey, 'language': 'fr-FR'};

    // Si d'autres paramètres sont fournis (comme "page" ou "with_genres"),
    // on les ajoute au Map existant grâce à addAll().
    if (params != null) {
      query.addAll(params);
    }

    // Envoi de la requête GET via Dio.
    // - L’URL complète (_url)
    // - Les paramètres de requête (queryParameters)
    final response = await dio.get(_url, queryParameters: query);

    // Vérification du code de réponse HTTP.
    // - 200 = succès → on retourne la réponse
    // - Autre code = erreur → on lève une exception
    if (response.statusCode == 200) {
      return response;
    } else {
      throw Exception('Failed to load data');
    }
  }

  // -------------------------------------------------------------------------
  // 🎥 getPopularMovies()
  // -------------------------------------------------------------------------
  // Récupère la liste des films populaires depuis TMDB.
  // Utilise la méthode générique [getData] pour simplifier la requête.
  Future<List<Movie>> getPopularMovies({required int pageNumber}) async {
    // Appel de l’API TMDB pour les films populaires
    Response response = await getData(
      '/movie/popular',
      params: {'page': pageNumber}, // Ajout du numéro de page
    );

    // Si la réponse est valide (code 200)
    if (response.statusCode == 200) {
      // On extrait les données JSON brutes
      Map data = response.data;

      // "results" contient la liste des films dans la réponse de TMDB
      List<dynamic> results = data['results'];

      // On crée une liste vide de Movie
      List<Movie> movies = [];

      // Conversion de chaque élément JSON en objet Movie avec fromJson()
      for (Map<String, dynamic> json in results) {
        Movie movie = Movie.fromJson(json);
        movies.add(movie);
      }

      // Retourne la liste complète de films convertis
      return movies;
    } else {
      // En cas d’échec, on renvoie la réponse brute
      throw response;
    }
  }

  // -------------------------------------------------------------------------
  // 🎞️ getNowPlaying()
  // -------------------------------------------------------------------------
  // Récupère la liste des films actuellement en salle (now playing)
  Future<List<Movie>> getNowPlaying({required int pageNumber}) async {
    // Appel à l’endpoint "/movie/now_playing"
    Response response = await getData(
      '/movie/now_playing',
      params: {'page': pageNumber},
    );

    // Traitement identique à getPopularMovies()
    if (response.statusCode == 200) {
      Map data = response.data;
      List<Movie> movies =
          data['results']
              .map<Movie>((dynamic movieJson) => Movie.fromJson(movieJson))
              .toList();
      return movies;
    } else {
      throw response;
    }
  }

  // -------------------------------------------------------------------------
  // 🎬 getUpComingMovies()
  // -------------------------------------------------------------------------
  // Récupère la liste des films à venir (upcoming)
  Future<List<Movie>> getUpComingMovies({required int pageNumber}) async {
    Response response = await getData(
      '/movie/upcoming',
      params: {'page': pageNumber},
    );

    if (response.statusCode == 200) {
      Map data = response.data;
      List<Movie> movies =
          data['results']
              .map<Movie>((dynamic movieJson) => Movie.fromJson(movieJson))
              .toList();
      return movies;
    } else {
      throw response;
    }
  }

  // -------------------------------------------------------------------------
  // 🧸 getAnimationMovies()
  // -------------------------------------------------------------------------
  // Récupère les films appartenant au genre "Animation".
  // TMDB utilise des identifiants numériques pour les genres :
  // - 16 = Animation
  Future<List<Movie>> getAnimationMovies({required int pageNumber}) async {
    Response response = await getData(
      '/discover/movie', // Endpoint générique pour filtrer les films
      params: {'page': pageNumber, 'with_genres': 16}, // 16 = animation
    );

    if (response.statusCode == 200) {
      Map data = response.data;
      List<Movie> movies =
          data['results']
              .map<Movie>((dynamic movieJson) => Movie.fromJson(movieJson))
              .toList();
      return movies;
    } else {
      throw response;
    }
  }

  // -------------------------------------------------------------------------
  // 🧩 getMovieDetails()
  // -------------------------------------------------------------------------
  // Récupère les détails complets d’un film à partir de son identifiant.
  // Cela inclut : les genres, la date de sortie, la note moyenne, etc.
  Future<Movie> getMovieDetails({required Movie movie}) async {
    // Appel à l’API TMDB avec l’id du film (ex: /movie/12345)
    Response response = await getData('/movie/${movie.id}');

    if (response.statusCode == 200) {
      // On extrait les données JSON
      Map<String, dynamic> _data = response.data;

      // Le champ "genres" contient une liste d’objets {id, name}
      var genres = _data['genres'] as List;

      // On extrait uniquement les noms des genres dans une liste de String
      List<String> genreList =
          genres.map((item) {
            return item['name'] as String;
          }).toList();

      // On crée une nouvelle instance de Movie avec les infos mises à jour
      Movie newMovie = movie.copyWith(
        genres: genreList, // Liste des genres
        releaseDate: _data['release_date'] as String?, // Date de sortie
        vote: (_data['vote_average'] as num).toDouble(), // Note moyenne
      );

      // On retourne le film enrichi
      return newMovie;
    } else {
      throw response;
    }
  }

  Future<Movie> getMovieVideos({required Movie movie}) async {
    Response response = await getData('/movie/${movie.id}/videos');
    if (response.statusCode == 200) {
      Map _data = response.data;
      List<String> videoKeys =
          _data['results'].map<String>((dynamic videoJson) {
            return videoJson['key'] as String;
          }).toList();
      return movie.copyWith(videos: videoKeys);
    } else {
      throw response;
    }
  }

  Future<Movie> getMovieCast({required Movie movie}) async {
    Response response = await getData('/movie/${movie.id}/credits');
    if (response.statusCode == 200) {
      Map _data = response.data;
      List<Person> _casting =
          _data['cast'].map<Person>((dynamic personJson) {
            return Person.fromJson(personJson);
          }).toList();
      return movie.copyWith(casting: _casting);
    } else {
      throw response;
    }
  }

  Future<Movie> getMovieImage({required Movie movie}) async {
    Response response = await getData(
      '/movie/${movie.id}/images',
      params: {'include_image_language': 'en,null'},
    );
    if (response.statusCode == 200) {
      Map _data = response.data;
      List<String> imagePath =
          _data['backdrops'].map<String>((dynamic imageJson) {
            return imageJson['file_path'] as String;
          }).toList();
      return movie.copyWith(images: imagePath);
    } else {
      throw response;
    }
  }
}
