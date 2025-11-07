import 'package:flutter/material.dart';
// Widgets de base de Flutter (Text, Column, ListView, etc.)

import 'package:google_fonts/google_fonts.dart';
// Package Google Fonts pour appliquer des polices personnalisées (ici : Poppins)

import 'package:notnetflix/models/movie.dart';
// Import du modèle Movie (représente un film avec ses propriétés)

import 'package:notnetflix/ui/widgets/movie_card.dart';
// Import du widget MovieCard (affiche l’affiche d’un film)

// ---------------------------------------------------
// MovieCategory : widget qui affiche une catégorie de films
// avec un titre + une liste horizontale d’affiches
// ---------------------------------------------------
class MovieCategory extends StatelessWidget {
  // Label de la catégorie (ex: "Tendances Actuelles")
  final String label;

  // Liste de films à afficher
  final List<Movie> movieList;

  // Taille des affiches (hauteur et largeur)
  final double imageHeight;
  final double imageWidth;
  final Function callback;

  // Constructeur du widget
  const MovieCategory({
    super.key,
    required this.label,
    required this.movieList,
    required this.imageHeight,
    required this.imageWidth,
    required this.callback,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      // Aligne le texte et la liste à gauche
      children: [
        SizedBox(height: 15), // Espacement avant le titre
        // -------------------------
        // Titre de la section (ex: "Tendances Actuelles")
        // -------------------------
        Text(
          label, // Texte passé en paramètre
          style: GoogleFonts.poppins(
            fontSize: 18, // Taille du texte
            color: Colors.white, // Couleur blanche
            fontWeight: FontWeight.bold, // Gras
          ),
        ),

        SizedBox(height: 10), // Espacement entre le titre et la liste
        // -------------------------
        // Liste horizontale d’affiches
        // -------------------------
        SizedBox(
          height: imageHeight, // Hauteur définie pour la zone d’affichage
          child: NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification notification) {
              final currentPosition = notification.metrics.pixels;
              print("CURRENT POSITION = $currentPosition");
              final maxPosition = notification.metrics.maxScrollExtent;
              print("MAX POSITION = $maxPosition");
              if (currentPosition >= maxPosition / 2) {
                print("On est en fin de liste");
                callback();
              }
              // Empêche le scroll parent (la page entière) de capter les événements de scroll
              // Cela permet de scroller la liste horizontale sans faire défiler la page
              return true;
            },
            child: ListView.builder(
              itemCount: movieList.length,

              // Nombre d’éléments affichés dans la liste
              // ⚠️ Ici c’est fixé à 10 → peut être amélioré avec movieList.length
              scrollDirection: Axis.horizontal,

              // Scroll horizontal pour afficher les films en ligne
              itemBuilder: (context, index) {
                // Fonction qui construit chaque élément de la liste
                return Container(
                  width: imageWidth, // Largeur de chaque affiche
                  margin: EdgeInsets.symmetric(horizontal: 8),
                  // Espacement horizontal entre chaque élément

                  // Si la liste est vide → affiche un texte provisoire
                  // Sinon → affiche l’affiche du film avec MovieCard
                  child:
                      movieList.isEmpty
                          ? Center(
                            child: Text(
                              "Item $index", // Texte temporaire (placeholders)
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          )
                          : MovieCard(movie: movieList[index]),
                );
              },
              shrinkWrap: true,
              // shrinkWrap = ajuste la taille de la ListView au contenu
              // Ici utile car la ListView est dans une Column
            ),
          ),
        ),
      ],
    );
  }
}
