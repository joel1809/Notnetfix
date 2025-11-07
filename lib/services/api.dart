import 'package:notnetflix/services/api_key.dart';

// La classe API centralise toutes les constantes nécessaires
// pour communiquer avec l’API de TheMovieDB (TMDB).
class API {
  // Récupère la clé API depuis un fichier séparé (api_key.dart).
  // 👉 Cela permet de ne pas exposer directement la clé API dans le code principal.
  // Exemple dans api_key.dart :
  // class APIKey { static const apikey = "TA_CLE_API_ICI"; }
  final String apiKey = APIKey.apikey;

  // L’URL de base pour toutes les requêtes vers l’API TMDB
  // Exemple d’appel complet :
  // https://api.themoviedb.org/3/movie/popular?api_key=TA_CLE
  final String baseURL = "https://api.themoviedb.org/3";

  // URL de base pour récupérer les images des films et séries.
  // Le suffixe /w500 indique la taille de l’image (500px de largeur).
  // Exemple complet :
  // https://image.tmdb.org/t/p/w500/nom_de_l_image.jpg
  final String baseImageURL = "https://image.tmdb.org/t/p/w500";

  // URL de base pour afficher des vidéos YouTube (souvent des bandes-annonces).
  // On concatène l’ID de la vidéo à la fin.
  // Exemple complet :
  // https://www.youtube.com/watch?v=abcd1234
  final String baseVideoURL = "https://www.youtube.com/watch?v=";
}
