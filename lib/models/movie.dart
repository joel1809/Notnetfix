// ignore_for_file: public_member_api_docs, sort_constructors_first
// 👇 Cette ligne indique au linter (l’analyseur de code Dart) d’ignorer deux règles :
// - "public_member_api_docs" : signifie qu’on n’est pas obligé de documenter chaque membre public avec des commentaires ///
// - "sort_constructors_first" : signifie qu’on n’est pas obligé de placer les constructeurs en tout début de classe

import 'dart:convert';
// 👇 Import du package standard Dart "convert", utilisé pour convertir des données
// entre formats (par exemple JSON ↔ objet Dart). Ici, il n’est pas encore directement utilisé,
// mais il peut servir pour le décodage des données API plus tard.

import 'package:flutter/material.dart';
import 'package:notnetflix/models/person.dart';
import 'package:notnetflix/services/api.dart';
// 👇 Import d’un fichier local (dans ton projet Flutter) appelé "api.dart"
// Ce fichier contient probablement la classe "API" avec des informations comme
// l’URL de base pour les requêtes réseau, les clés API, ou les chemins d’accès aux images.

// 🎬 Définition de la classe Movie, qui représente un film dans ton application.
class Movie {
  // 🧱 Déclaration des attributs (propriétés) de la classe

  final int id; // Identifiant unique du film (ex: 123)
  final String name; // Nom ou titre du film (ex: "Inception")
  final String description; // Description ou résumé du film (synopsis)
  final String?
  posterPath; // Chemin relatif de l’affiche du film (peut être null)
  final List<String>?
  genres; // Liste des genres (ex: ["Action", "Science-fiction"])
  final String? releaseDate; // Date de sortie du film (ex: "2023-05-17")
  final double? vote; // Note moyenne du film (ex: 8.3)
  final List<String>? videos;
  final List<Person>?
  casting; // Liste des vidéos associées au film (ex: trailers)
  final List<String>?
  images; // Liste des images associées au film (ex: captures d’écran)
  // 🏗️ Constructeur de la classe Movie
  // Les paramètres "required" doivent être fournis obligatoirement.
  Movie({
    required this.id,
    required this.name,
    required this.description,
    this.posterPath,
    this.genres,
    this.releaseDate,
    this.vote,
    this.videos,
    this.casting,
    this.images,
  });

  // 🧩 Méthode "copyWith" : très utile en programmation fonctionnelle.
  // Elle permet de copier un objet Movie existant en changeant seulement certaines valeurs.
  // Exemple :
  //    var newMovie = oldMovie.copyWith(name: "Avatar 2");
  Movie copyWith({
    int? id,
    String? name,
    String? description,
    String? posterPath,
    List<String>? genres,
    String? releaseDate,
    double? vote,
    List<String>? videos,
    List<Person>? casting,
    List<String>? images,
  }) {
    return Movie(
      id:
          id ??
          this.id, // Si un nouvel "id" est fourni → on le prend, sinon on garde l’ancien
      name: name ?? this.name, // Idem pour "name"
      description: description ?? this.description, // Idem pour "description"
      posterPath: posterPath ?? this.posterPath, // Idem pour "posterPath"
      genres: genres ?? this.genres, // Idem pour "genres"
      releaseDate: releaseDate ?? this.releaseDate, // Idem pour "releaseDate"
      vote: vote ?? this.vote, // Idem pour "vote"
      videos: videos ?? this.videos, // Idem pour "videos"
      casting: casting ?? this.casting, // Idem pour "casting"
      images: images ?? this.images, // Idem pour "images"
    );
  }

  // 🏭 Factory constructor "fromJson"
  // Sert à transformer un objet JSON (provenant d’une API par exemple)
  // en une instance de la classe Movie.
  // Exemple :
  //    var movie = Movie.fromJson(apiResponse);
  factory Movie.fromJson(Map<String, dynamic> map) {
    return Movie(
      id: map['id'] as int, // Récupère la clé "id" du JSON
      name: map['title'] as String, // Récupère la clé "title" → titre du film
      description:
          map['overview']
              as String, // Récupère la clé "overview" → résumé du film
      posterPath:
          map['poster_path'] !=
                  null // Si "poster_path" existe et n’est pas null
              ? map['poster_path']
                  as String // On le convertit en String
              : null, // Sinon → null
    );
  }

  // 🖼️ Méthode "posterURL" : génère l’URL complète de l’affiche du film
  // Exemple :
  //   api.baseImageURL = "https://image.tmdb.org/t/p/w500/"
  //   posterPath = "/xyz123.jpg"
  // Résultat → "https://image.tmdb.org/t/p/w500/xyz123.jpg"
  String posterURL() {
    API api =
        API(); // On crée une instance de la classe API pour accéder à baseImageURL
    return api.baseImageURL + posterPath!;
    // On concatène l’URL de base et le chemin de l’affiche
    // Le "!" indique qu’on force Dart à considérer "posterPath" comme non null
  }

  // 🎭 Méthode "reformatGenres" : transforme la liste de genres en une seule chaîne de texte
  // Exemple :
  //   genres = ["Action", "Aventure", "Drame"]
  //   Résultat → "Action, Aventure, Drame"
  String reformatGenres() {
    String categories = ""; // On initialise une variable vide
    for (int i = 0; i < genres!.length; i++) {
      // On parcourt tous les genres un par un
      if (i == genres!.length - 1) {
        // Si on est sur le dernier genre → on ne met pas de virgule
        categories = categories + genres![i];
      } else {
        // Sinon → on ajoute une virgule et un espace
        categories = categories + "${genres![i]}, ";
      }
    }
    return categories; // On renvoie la chaîne finale
  }
}
