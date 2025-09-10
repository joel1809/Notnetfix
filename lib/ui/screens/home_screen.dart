import 'package:flutter/material.dart';
import 'package:notnetflix/utils/constant.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: kBackgroundColor,
        leading: Image.asset("assets/images/netflix_logo_2.png"),
      ),
      body: ListView(
        children: [
          Container(height: 500, color: Colors.red),
          SizedBox(height: 15),
          Text(
            "Tendances Actuelles",
            style: GoogleFonts.poppins(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          SizedBox(
            height: 150,
            child: ListView.builder(
              itemCount: 10,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Container(
                  width: 150,
                  margin: EdgeInsets.symmetric(horizontal: 8),
                  color: Colors.blueGrey,
                  child: Center(
                    child: Text(
                      "Item $index",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                );
              },
              shrinkWrap: true,
              // Retirer NeverScrollableScrollPhysics pour permettre le scroll horizontal
            ),
          ),
          SizedBox(height: 15),
          Text(
            "Actuellement au Cinéma",
            style: GoogleFonts.poppins(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          SizedBox(
            height: 320,
            child: ListView.builder(
              itemCount: 10,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Container(
                  width: 220,
                  margin: EdgeInsets.symmetric(horizontal: 8),
                  color: Colors.blue,
                  child: Center(
                    child: Text(
                      "Item $index",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                );
              },
              shrinkWrap: true,
              // Retirer NeverScrollableScrollPhysics pour permettre le scroll horizontal
            ),
          ),
          SizedBox(height: 15),
          Text(
            "Ils arrivent Bientôt",
            style: GoogleFonts.poppins(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          SizedBox(
            height: 150,
            child: ListView.builder(
              itemCount: 10,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Container(
                  width: 150,
                  margin: EdgeInsets.symmetric(horizontal: 8),
                  color: Colors.green,
                  child: Center(
                    child: Text(
                      "Item $index",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                );
              },
              shrinkWrap: true,
              // Retirer NeverScrollableScrollPhysics pour permettre le scroll horizontal
            ),
          ),
        ],
      ),
    );
  }
}
