import 'package:flutter/material.dart';
// Widgets et composants de base Flutter

import 'package:notnetflix/models/movie.dart';
// Import du modèle Movie (représente un film avec ses propriétés)

import 'package:notnetflix/repositories/data_repository.dart';
// Repository qui gère la récupération et le stockage des données (API → App)

import 'package:notnetflix/services/api_service.dart';
// Service qui fait la communication avec l’API externe

import 'package:notnetflix/ui/widgets/movie_card.dart';
// Widget personnalisé qui affiche une carte de film (affiche du film)

import 'package:notnetflix/ui/widgets/movie_category.dart';
// Widget personnalisé qui affiche une catégorie de films (titre + liste horizontale d’affiches)

import 'package:notnetflix/utils/constant.dart';
// Import des constantes globales (ex: couleurs, tailles, etc.)

import 'package:google_fonts/google_fonts.dart';
// Package pour utiliser facilement des polices personnalisées (Google Fonts)

import 'package:provider/provider.dart';
// Provider est utilisé pour gérer l’état global et partager DataRepository entre les widgets

// ---------------------------------------------------
// HomeScreen : Écran principal de l’application
// ---------------------------------------------------
class HomeScreen extends StatefulWidget {
  // StatefulWidget car on pourrait gérer un état qui change
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

// ---------------------------------------------------
// Classe interne qui gère l’état de HomeScreen
// ---------------------------------------------------
class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Ici on pourrait initialiser des données (mais ce n’est pas utilisé pour l’instant)
  }

  @override
  Widget build(BuildContext context) {
    // On récupère DataRepository via Provider
    // Cela permet d’accéder à la liste des films chargés depuis l’API
    final dataProvider = Provider.of<DataRepository>(context);

    // Scaffold est la structure de base d’une page Flutter :
    // - AppBar en haut
    // - body pour le contenu
    // - backgroundColor pour la couleur du fond
    return Scaffold(
      backgroundColor:
          kBackgroundColor, // Couleur de fond (constante définie dans utils)
      // -------------------------
      // AppBar (barre supérieure)
      // -------------------------
      appBar: AppBar(
        backgroundColor: kBackgroundColor, // Couleur identique au fond
        leading: Image.asset("assets/images/netflix_logo_2.png"),
        // "leading" = widget à gauche dans la barre (ici un logo Netflix)
      ),

      // -------------------------
      // Body (contenu principal de la page)
      // On utilise un ListView car le contenu est long et doit défiler verticalement
      // -------------------------
      body: ListView(
        children: [
          // Section d’en-tête : grande bannière avec l’affiche du premier film
          SizedBox(
            height: 500, // Hauteur fixe
            child:
                dataProvider.popularMovieList.isEmpty
                    ? const Center() // Si la liste est vide, on affiche un container vide (à améliorer)
                    : MovieCard(movie: dataProvider.popularMovieList.first),
            // Sinon, on affiche la carte du premier film de la liste
          ),

          // -------------------------
          // Catégorie 1 : Tendances actuelles
          // -------------------------
          MovieCategory(
            label: "Tendances Actuelles", // Titre de la section
            movieList:
                dataProvider.popularMovieList, // Liste de films à afficher
            imageHeight: 160, // Hauteur des affiches
            imageWidth: 110,
            callback: dataProvider.getPopularMovies, // Largeur des affiches
          ),

          // -------------------------
          // Catégorie 2 : Films actuellement au cinéma
          // -------------------------
          MovieCategory(
            label: "Actuellement au Cinéma",
            movieList: dataProvider.nowPlayingMovieList,
            imageHeight: 320, // Ici on veut de grandes affiches
            imageWidth: 220,
            callback: dataProvider.getNowPlaying,
          ),

          // -------------------------
          // Catégorie 3 : Films à venir
          // -------------------------
          MovieCategory(
            label: "Ils arrivent Bientôt",
            movieList: dataProvider.upcomingMovieList,
            imageHeight: 160,
            imageWidth: 110,
            callback: dataProvider.getUpComingMovies,
          ),
          MovieCategory(
            label: "Animation",
            movieList: dataProvider.animationMovieList,
            imageHeight: 320,
            imageWidth: 220,
            callback: dataProvider.getAnimationMovies,
          ),
        ],
      ),
    );
  }
}
