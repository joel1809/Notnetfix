import 'package:dio/dio.dart';
// Import du package Dio : une librairie HTTP puissante pour effectuer des requêtes (GET, POST...) vers une API.

import 'package:flutter/material.dart';
// Package Flutter de base (ici, surtout utile pour ChangeNotifier qui vient de Flutter foundation).

import 'package:notnetflix/models/movie.dart';
// Import du modèle Movie (classe qui représente un film avec id, titre, description, etc.).

import 'package:notnetflix/services/api_service.dart';
// Import du service ApiService : classe qui gère la communication avec l’API externe (ex: The Movie DB).

// -------------------------
// Classe DataRepository : c'est un "Repository" qui fait le lien entre l'API et l'application.
// Elle étend ChangeNotifier pour notifier les widgets consommateurs (Provider).
// -------------------------
class DataRepository with ChangeNotifier {
  // Instance de ApiService (permet d’appeler les méthodes qui parlent à l’API).
  final ApiService apiService = ApiService();

  // Liste interne qui stocke les films populaires récupérés depuis l’API.
  final List<Movie> _popularMovieList = [];

  // Variable pour gérer la pagination (numéro de page à charger).
  int _popularMoviePage = 1;
  final List<Movie> _nowPlayingMovieList = [];
  int _nowPlayingMoviePage = 1;

  final List<Movie> _upcomingMovieList = [];
  int _upcomingMoviePage = 1;

  final List<Movie> _animationMovieList = [];
  int _animationMoviePage = 1;
  // Getter pour exposer la liste des films populaires de manière sécurisée (lecture seule).
  List<Movie> get popularMovieList => _popularMovieList;
  List<Movie> get nowPlayingMovieList => _nowPlayingMovieList;
  List<Movie> get upcomingMovieList => _upcomingMovieList;
  List<Movie> get animationMovieList => _animationMovieList;

  // -------------------------
  // Méthode asynchrone qui récupère les films populaires depuis l’API.
  // -------------------------
  Future<void> getPopularMovies() async {
    try {
      // On appelle ApiService pour récupérer la liste des films de la page courante.
      List<Movie> movies = await apiService.getPopularMovies(
        pageNumber:
            _popularMoviePage, // Numéro de page (ex: page 1, puis page 2...)
      );

      // On ajoute les nouveaux films à la liste interne.
      _popularMovieList.addAll(movies);

      // On incrémente le numéro de page pour préparer le prochain appel.
      _popularMoviePage++;

      // On notifie les widgets qui écoutent ce repository (Provider).
      notifyListeners();
    } on Response catch (response) {
      // Gestion d’erreur spécifique à Dio (si la requête échoue).
      print("ERROR: ${response.statusCode}");
      rethrow; // On relance l’erreur pour qu’elle puisse être gérée ailleurs si besoin.
    }
  }

  Future<void> getNowPlaying() async {
    try {
      // On appelle ApiService pour récupérer la liste des films de la page courante.
      List<Movie> movies = await apiService.getNowPlaying(
        pageNumber:
            _nowPlayingMoviePage, // Numéro de page (ex: page 1, puis page 2...)
      );

      // On ajoute les nouveaux films à la liste interne.
      _nowPlayingMovieList.addAll(movies);

      // On incrémente le numéro de page pour préparer le prochain appel.
      _nowPlayingMoviePage++;

      // On notifie les widgets qui écoutent ce repository (Provider).
      notifyListeners();
    } on Response catch (response) {
      // Gestion d’erreur spécifique à Dio (si la requête échoue).
      print("ERROR: ${response.statusCode}");
      rethrow; // On relance l’erreur pour qu’elle puisse être gérée ailleurs si besoin.
    }
  }

  Future<void> getUpComingMovies() async {
    try {
      // On appelle ApiService pour récupérer la liste des films de la page courante.
      List<Movie> movies = await apiService.getUpComingMovies(
        pageNumber:
            _upcomingMoviePage, // Numéro de page (ex: page 1, puis page 2...)
      );

      // On ajoute les nouveaux films à la liste interne.
      _upcomingMovieList.addAll(movies);

      // On incrémente le numéro de page pour préparer le prochain appel.
      _upcomingMoviePage++;

      // On notifie les widgets qui écoutent ce repository (Provider).
      notifyListeners();
    } on Response catch (response) {
      // Gestion d’erreur spécifique à Dio (si la requête échoue).
      print("ERROR: ${response.statusCode}");
      rethrow; // On relance l’erreur pour qu’elle puisse être gérée ailleurs si besoin.
    }
  }

  Future<void> getAnimationMovies() async {
    try {
      // On appelle ApiService pour récupérer la liste des films de la page courante.
      List<Movie> movies = await apiService.getAnimationMovies(
        pageNumber:
            _animationMoviePage, // Numéro de page (ex: page 1, puis page 2...)
      );

      // On ajoute les nouveaux films à la liste interne.
      _animationMovieList.addAll(movies);

      // On incrémente le numéro de page pour préparer le prochain appel.
      _animationMoviePage++;

      // On notifie les widgets qui écoutent ce repository (Provider).
      notifyListeners();
    } on Response catch (response) {
      // Gestion d’erreur spécifique à Dio (si la requête échoue).
      print("ERROR: ${response.statusCode}");
      rethrow; // On relance l’erreur pour qu’elle puisse être gérée ailleurs si besoin.
    }
  }

  Future<Movie> getMovieDetails({required Movie movie}) async {
    try {
      // On appelle ApiService pour récupérer les détails du film par son ID.
      Movie newMovie = await apiService.getMovieDetails(movie: movie);
      newMovie = await apiService.getMovieVideos(movie: newMovie);
      newMovie = await apiService.getMovieCast(movie: newMovie);
      newMovie = await apiService.getMovieImage(movie: newMovie);
      // On retourne l’objet Movie avec les détails complets.
      return newMovie;
    } on Response catch (response) {
      // Gestion d’erreur spécifique à Dio (si la requête échoue).
      print("ERROR: ${response.statusCode}");
      rethrow; // On relance l’erreur pour qu’elle puisse être gérée ailleurs si besoin.
    }
  }

  // -------------------------
  // Méthode initData : point d’entrée pour initialiser les données.
  // Ici, on commence par charger la première page des films populaires.
  // -------------------------
  Future<void> initData() async {
    await Future.wait([
      getPopularMovies(),
      getNowPlaying(),
      getUpComingMovies(),
      getAnimationMovies(),
    ]);
  }
}
