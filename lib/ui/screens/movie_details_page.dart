import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notnetflix/models/movie.dart';
import 'package:notnetflix/repositories/data_repository.dart';
import 'package:notnetflix/services/api.dart';
import 'package:notnetflix/ui/widgets/action_button.dart';
import 'package:notnetflix/ui/widgets/casting_card.dart';
import 'package:notnetflix/ui/widgets/galerieCard.dart';
import 'package:notnetflix/ui/widgets/movie_info.dart';
import 'package:notnetflix/ui/widgets/my_video_player.dart';
import 'package:notnetflix/utils/constant.dart';
import 'package:provider/provider.dart';

class MovieDetailsPage extends StatefulWidget {
  final Movie movie;
  const MovieDetailsPage({Key? key, required this.movie}) : super(key: key);

  @override
  State<MovieDetailsPage> createState() => _MovieDetailsPageState();
}

class _MovieDetailsPageState extends State<MovieDetailsPage> {
  Movie? newMovie;
  @override
  void initState() {
    super.initState();
    getMovieData();
  }

  void getMovieData() async {
    final dataProvider = Provider.of<DataRepository>(context, listen: false);
    Movie _movie = await dataProvider.getMovieDetails(movie: widget.movie);
    setState(() {
      newMovie = _movie;
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(backgroundColor: kBackgroundColor),
      body:
          newMovie == null
              ? Center(child: SpinKitCircle(color: kPrimaryColor, size: 20))
              : Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView(
                  children: [
                    Container(
                      height: 200,
                      width: MediaQuery.of(context).size.width,
                      child:
                          newMovie!.videos!.isEmpty
                              ? Center(
                                child: Text(
                                  "Aucune bande annonce disponible",
                                  style: GoogleFonts.poppins(
                                    color: Colors.white70,
                                    fontSize: 16,
                                  ),
                                ),
                              )
                              : MyVideoPlayer(movieId: newMovie!.videos!.first),
                    ),
                    MovieInfo(movie: newMovie!),
                    SizedBox(height: 10),
                    ActionButton(
                      label: "Lecture",
                      icon: Icons.play_arrow,
                      bgColor: Colors.white,
                      color: Colors.black,
                    ),
                    SizedBox(height: 5),
                    ActionButton(
                      label: "Telecharger la video",
                      icon: Icons.download,
                      bgColor: Colors.grey.withOpacity(0.3),
                      color: Colors.white,
                    ),
                    SizedBox(height: 10),
                    Text(
                      newMovie!.description,
                      style: GoogleFonts.poppins(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Casting",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 350,
                      child: ListView.builder(
                        itemCount: newMovie!.casting!.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, int index) {
                          return newMovie!.casting![index].imageURL == null
                              ? Center()
                              : CastingCard(person: newMovie!.casting![index]);
                        },
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Galerie",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 200,
                      child: ListView.builder(
                        itemCount: newMovie!.images!.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, int index) {
                          return GalerieCard(
                            posterPath: newMovie!.images![index],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
    );
  }
}
