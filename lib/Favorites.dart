import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:omdb_teste/service/local_database.dart';

import 'DetailScreen.dart';

class Favorites extends StatefulWidget {
  @override
  _FavoritesState createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  List favorites;

  @override
  void initState() {
    super.initState();
    getFavorites();
  }

  Color primaryColor = Color(0xFF5F6FB7);
  Color secondaryColor = Color(0xFFe79808);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondaryColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: secondaryColor,
        title: Text("Filmes e séries favoritas"),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20,bottom: 10),
        child: Container(
            color: secondaryColor,
            child: (favorites == null ? Container() : showFavorites())),
      ),
    );
  }

  showFavorites() {
    return GridView.count(
      mainAxisSpacing: 8,
      addAutomaticKeepAlives: true,
      crossAxisCount: 2,
      children: favorites.map((f) {
        return Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => DetailScreen(
                        poster: f['poster'],
                        title: f['title'],
                        id: f['id'],
                      )));
            },
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              margin: EdgeInsets.only(bottom: 10),
              elevation: 5,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      f['title'],
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.montserrat(
                          fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Hero(
                    tag: f['id'],
                    transitionOnUserGestures: true,
                    child: Image.network(
                      f['poster'],
                      height: 120,
                      width: 150,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  getFavorites() async {
    await LocalDatabase.db.select().then((response) {
      setState(() {
        favorites = response;
      });
    });
  }
}
