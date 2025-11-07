import 'package:flutter/material.dart';
// Widgets de base de Flutter (StatelessWidget, Icon, etc.)

import 'package:cached_network_image/cached_network_image.dart';
import 'package:notnetflix/ui/screens/movie_details_page.dart';
// Package "cached_network_image" : permet de charger des images depuis Internet
// et de les sauvegarder en cache local.
// → Avantage : une image déjà téléchargée n’est pas rechargée à chaque fois
// → Améliore les performances et réduit l’utilisation réseau

// ---------------------------------------------------
// MovieCard : widget qui affiche l’affiche d’un film
// ---------------------------------------------------
class MovieCard extends StatelessWidget {
  // L’objet film à afficher
  // "dynamic" → type flexible (mais ici, c’est normalement un objet Movie)
  // Cet objet doit avoir une méthode "posterURL()" qui retourne l’URL complète de l’affiche
  final dynamic movie;

  // Constructeur : "movie" est obligatoire
  const MovieCard({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return MovieDetailsPage(movie: movie);
            },
          ),
        );
      },
      child: CachedNetworkImage(
        // URL de l’image à charger → générée par movie.posterURL()
        imageUrl: movie.posterURL(),

        // Widget affiché en cas d’erreur de chargement de l’image
        // Exemple : problème de réseau ou URL invalide
        errorWidget:
            (context, url, error) => const Center(child: Icon(Icons.error)),

        // "fit" : définit comment l’image s’adapte dans son conteneur
        // BoxFit.cover → l’image remplit tout l’espace disponible
        // quitte à être recadrée (mais elle garde ses proportions)
        fit: BoxFit.cover,
      ),
    );
  }
}
