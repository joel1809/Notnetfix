import 'package:flutter/material.dart';
// Package Flutter de base qui contient tous les widgets essentiels (Scaffold, Container, etc.)

import 'package:notnetflix/repositories/data_repository.dart';
// Import de la classe DataRepository, responsable de la gestion/récupération des données (films, séries, etc.)

import 'package:notnetflix/ui/screens/home_screen.dart';
// Import de l’écran principal (HomeScreen), vers lequel on redirige l’utilisateur après le chargement.

import 'package:notnetflix/utils/constant.dart';
// Import d’un fichier de constantes (par ex. couleurs, textes, tailles...).

import 'package:flutter_spinkit/flutter_spinkit.dart';
// Package externe (flutter_spinkit) qui fournit des animations de chargement (spinners, loaders).

import 'package:provider/provider.dart';
// Provider est un package pour gérer l’état global de l’application et partager des données (ici DataRepository).

// -------------------------
// Définition de l’écran LoadingScreen
// -------------------------
class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

// -------------------------
// Classe "State" liée au StatefulWidget LoadingScreen
// C’est ici que toute la logique et l’UI seront définies
// -------------------------
class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    // ⚠️ Petite erreur ici : il manque un "t" -> ça devrait être "initState"
    super.initState();
    initData(); // On appelle la méthode initData() pour charger les données dès l’ouverture de l’écran
  }

  // Méthode asynchrone qui initialise les données
  void initData() async {
    // Récupération du DataRepository depuis Provider (listen: false = pas besoin d’écouter les changements)
    final dataProvider = Provider.of<DataRepository>(context, listen: false);

    // Appel de la méthode initData() du repository pour charger les données (ex: films depuis une API)
    await dataProvider.initData();

    // Une fois les données chargées, on redirige l’utilisateur vers HomeScreen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) {
          return const HomeScreen();
        },
      ),
    );
  }

  // -------------------------
  // Méthode build : décrit l’interface utilisateur de l’écran
  // -------------------------
  @override
  Widget build(BuildContext context) {
    return Container(
      color: kBackgroundColor, // Fond de l’écran (défini dans constants)
      child: Column(
        mainAxisAlignment:
            MainAxisAlignment.center, // Centre verticalement les widgets
        children: [
          // Logo Netflix stocké dans les assets
          Image.asset("assets/images/netflix_logo_1.png"),

          // Animation de chargement (cercle qui tourne)
          SpinKitFadingCircle(
            color: kPrimaryColor, // Couleur principale définie dans constants
            size: 40, // Taille de l’animation
          ),
        ],
      ),
    );
  }
}
