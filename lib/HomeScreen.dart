import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:omdb_teste/DetailScreen.dart';
import 'package:omdb_teste/Favorites.dart';

import 'package:omdb_teste/service/movies_service.dart';

import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'model/movie_model.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Color secondaryColor = Color(0xFFe79808);
  Color primaryColor = Color(0xFF5F6FB7);
  List<Movie> movies;

  final search = TextEditingController();
  bool loading = false;
  bool init = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SlidingUpPanel(
        body: Container(
          child: Padding(
            padding: const EdgeInsets.only(top: 60),
            child: Column(
              children: <Widget>[
                Text('Bem vindo ao OMDb',
                    style: GoogleFonts.montserrat(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w500)),
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Image.asset(
                    "assets/images/cinema.png",
                    fit: BoxFit.cover,
                    height: 500,
                    width: 500,
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: Container(
                      width: 230,
                      height: 40,
                      child: RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          color: primaryColor,
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => Favorites()));
                          },
                          child: Text(
                            "Ver meus favoritos",
                            style: GoogleFonts.montserrat(
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                            ),
                          )),
                    ))
              ],
            ),
          ),
          color: secondaryColor,
        ),
        maxHeight: MediaQuery.of(context).size.height,
        minHeight: MediaQuery.of(context).size.height / 10,
        renderPanelSheet: false,
        panel: Container(
          decoration: BoxDecoration(
            color: primaryColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(34),
              topRight: Radius.circular(34),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Hero(
                  tag: "titleHome",
                  child: Text(
                    "Procurar por filmes ou séries",
                    style: GoogleFonts.montserrat(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: floatingSearchBar(),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 10),
                    child: Container(
                        width: MediaQuery.of(context).size.width / 1.1,
                        child: (loading)
                            ? Container(
                                color: primaryColor,
                                width: MediaQuery.of(context).size.width / 1.1,
                                height: MediaQuery.of(context).size.height,
                                child: Center(
                                  child: CircularProgressIndicator(
                                    backgroundColor: primaryColor,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  ),
                                ),
                              )
                            : (movies == null)
                                ? Container(
                                    child: Center(
                                      child: Text(
                                        "Procure por filmes ou séries acima",
                                        style: GoogleFonts.montserrat(
                                            fontSize: 16,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                  )
                                : showList()),
                  ),
                )
              ],
            ),
          ),
        ),
        collapsed: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 15),
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFE0E0E0),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  width: 40,
                  height: 5,
                ),
              ),
              Hero(
                tag: "title",
                child: Text(
                  "Pesquisar",
                  style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w400),
                ),
              ),
            ],
          ),
          decoration: BoxDecoration(
            color: primaryColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(34),
              topRight: Radius.circular(34),
            ),
          ),
        ),
      ),
    );
  }

  Widget floatingSearchBar() {
    return Container(
      width: MediaQuery.of(context).size.width / 1.2,
      child: Card(
        elevation: 11,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: TextField(
          onEditingComplete: () {
            setState(() {
              loading = true;
            });

            FocusScopeNode currentFocus = FocusScope.of(context);

            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }

            MoviesService().getMovies(search.text.trim()).then((data) {
              if (data == null) {
                print("vazio");
                movies = data;
                Future.delayed(Duration(milliseconds: 1500)).then((a) {
                  setState(() {
                    loading = false;
                    init = false;
                  });
                });
              } else {
                movies = data;
                Future.delayed(Duration(milliseconds: 1500)).then((a) {
                  setState(() {
                    init = false;
                    loading = false;
                  });
                });
              }
            });
          },
          controller: search,
          textAlignVertical: TextAlignVertical.center,
          style: GoogleFonts.montserrat(
            fontSize: 18,
            fontWeight: FontWeight.w400,
          ),
          decoration: InputDecoration(
            suffixIcon: GestureDetector(
              onTap: () {
                setState(() {
                  loading = true;
                });

                FocusScopeNode currentFocus = FocusScope.of(context);

                if (!currentFocus.hasPrimaryFocus) {
                  currentFocus.unfocus();
                }

                MoviesService().getMovies(search.text.trim()).then((data) {
                  if (data == null) {
                    print("vazio");
                    movies = data;

                    Future.delayed(Duration(milliseconds: 1500)).then((a) {
                      setState(() {
                        init = false;
                        loading = false;
                      });
                    });
                  } else {
                    movies = data;
                    Future.delayed(Duration(milliseconds: 1500)).then((a) {
                      setState(() {
                        init = false;
                        loading = false;
                      });
                    });
                  }
                });
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 5),
                child: Container(
                  width: 80,
                  height: 50,
                  child: Icon(
                    FontAwesomeIcons.search,
                    size: 20,
                  ),
                ),
              ),
            ),
            contentPadding: EdgeInsets.only(left: 20),
            border: InputBorder.none,
            hintText: "Pesquisar ....",
            hintStyle: GoogleFonts.montserrat(
                fontSize: 18, fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }

  Widget showList() {
    return GridView.count(
      mainAxisSpacing: 8,
      addAutomaticKeepAlives: true,
      crossAxisCount: 2,
      children: movies.map((f) {
        return Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => DetailScreen(
                        poster: f.poster,
                        title: f.title,
                        id: f.id,
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
                      f.title,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.montserrat(
                          fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Hero(
                    tag: f.id,
                    transitionOnUserGestures: true,
                    child: (f.poster == "N/A"
                        ? Image.asset(
                            'assets/images/3419636.jpg',
                            fit: BoxFit.cover,
                            height: 130,
                          )
                        : Image.network(
                            f.poster,
                            height: 120,
                            width: 150,
                          )),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
