import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_share_me/flutter_share_me.dart';
import 'package:omdb_teste/service/details_service.dart';
import 'package:omdb_teste/service/local_database.dart';

class DetailScreen extends StatefulWidget {
  @override
  _DetailScreenState createState() => _DetailScreenState();

  String id;
  String title;
  String poster;

  DetailScreen({this.poster, this.id, this.title}) : super();
}

class _DetailScreenState extends State<DetailScreen> {
  var details;
  bool loading = true;
  Color secondaryColor = Color(0xFFe79808);
  Color primaryColor = Color(0xFF5F6FB7);
  bool favorite = false;
  String favoriteLabel = "Favoritar";
  final snack = SnackBar(
      behavior: SnackBarBehavior.floating,
      duration: Duration(milliseconds: 1500),
      content: Text(
        'Filme excluido :(',
        style:
            GoogleFonts.montserrat(fontSize: 18, fontWeight: FontWeight.w500),
      ));

  @override
  void initState() {
    super.initState();
    getDetails();

    LocalDatabase.db.isFavorite(widget.id).then((response) {
      if (response.toString().contains("Favorite")) {
        setState(() {
          favorite = true;
        });
      }
    });
  }

  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

  @override
  build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      floatingActionButton: SpeedDial(
        backgroundColor: primaryColor,
        animatedIcon: AnimatedIcons.menu_close,
        children: [
          SpeedDialChild(
            label: favoriteLabel,
            labelStyle: GoogleFonts.montserrat(
                fontWeight: FontWeight.w400, fontSize: 14),
            onTap: () async {
              LocalDatabase.db
                  .insert(widget.id, widget.title, widget.poster)
                  .then((response) {
                if (response.toString().contains("DatabaseException")) {
                  showConfirm();
                } else {
                  setState(() {
                    favorite = true;
                    favoriteLabel = "Favoritado";
                    print("Favoritado");
                  });
                }
              });
            },
            backgroundColor: Colors.red,
            child: (favorite == false
                ? Icon(
                    FontAwesomeIcons.heart,
                  )
                : Icon(FontAwesomeIcons.solidHeart)),
          ),
          SpeedDialChild(
            labelStyle: GoogleFonts.montserrat(
                fontWeight: FontWeight.w400, fontSize: 14),
            backgroundColor: secondaryColor,
            label: "Compartilhar",
            child: Icon(Icons.share),
            onTap: () async => await FlutterShareMe().shareToSystem(
                msg:
                    "Eu amo esse filme, e estou compartilhando com você para assistir comigo também.\n Assista agora ${widget.title}"),
          )
        ],
      ),
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.grey[250],
          child: (loading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Hero(
                      transitionOnUserGestures: true,
                      tag: widget.id,
                      child: (widget.poster == "N/A"
                          ? ClipPath(
                              clipper: WaveClipperOne(),
                              child: Container(
                                child: Image.asset(
                                  'assets/images/sem_poster.jpg',
                                  fit: BoxFit.cover,
                                ),
                                height:
                                    MediaQuery.of(context).size.height / 2.1,
                                width: MediaQuery.of(context).size.width,
                              ),
                            )
                          : ClipPath(
                              clipper: WaveClipperOne(),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                height: 400,
                                child: Image.network(
                                  widget.poster,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 30, top: 10),
                      child: Text(
                        widget.title,
                        style: GoogleFonts.montserrat(
                            fontSize: 22, fontWeight: FontWeight.w600),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 30, top: 10, right: 30),
                      child: (details["Plot"] == 'N/A'
                          ? Text("No description available.",
                              style: GoogleFonts.montserrat(
                                  fontSize: 16, fontWeight: FontWeight.w300))
                          : Text(
                              details["Plot"],
                              textAlign: TextAlign.justify,
                              style: GoogleFonts.montserrat(
                                  fontSize: 16, fontWeight: FontWeight.w300),
                            )),
                    ),
                    Padding(
                        padding: const EdgeInsets.fromLTRB(30, 15, 0, 0),
                        child: (details['Language'] == 'N/A'
                            ? Text(
                                "Language not available",
                                style: GoogleFonts.montserrat(
                                    fontSize: 16, fontWeight: FontWeight.w300),
                              )
                            : Text(
                                'Language: ' + details["Language"],
                                style: GoogleFonts.montserrat(
                                    fontSize: 16, fontWeight: FontWeight.w300),
                              ))),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(30, 5, 0, 0),
                      child: (details['Country'] == 'N/A'
                          ? Text(
                              "Country not available",
                              style: GoogleFonts.montserrat(
                                  fontSize: 16, fontWeight: FontWeight.w300),
                            )
                          : Text(
                              'Country: ' + details["Country"],
                              style: GoogleFonts.montserrat(
                                  fontSize: 16, fontWeight: FontWeight.w300),
                            )),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(30, 5, 0, 0),
                      child: (details['Director'] == 'N/A'
                          ? Text(
                              "Director not available",
                              style: GoogleFonts.montserrat(
                                  fontSize: 16, fontWeight: FontWeight.w300),
                            )
                          : Text(
                              'Director: ' + details["Director"],
                              style: GoogleFonts.montserrat(
                                  fontSize: 16, fontWeight: FontWeight.w300),
                            )),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(30, 5, 0, 0),
                      child: (details['Runtime'] == 'N/A'
                          ? Text(
                              "Runtime not available",
                              style: GoogleFonts.montserrat(
                                  fontSize: 16, fontWeight: FontWeight.w300),
                            )
                          : Text(
                              'Runtime: ' + details["Runtime"],
                              style: GoogleFonts.montserrat(
                                  fontSize: 16, fontWeight: FontWeight.w300),
                            )),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(30, 5, 0, 0),
                      child: (details['Genre'] == 'N/A'
                          ? Text(
                              "Genre not available",
                              style: GoogleFonts.montserrat(
                                  fontSize: 16, fontWeight: FontWeight.w300),
                            )
                          : Text(
                              'Genre: ' + details["Genre"],
                              style: GoogleFonts.montserrat(
                                  fontSize: 16, fontWeight: FontWeight.w300),
                            )),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(30, 5, 0, 0),
                      child: (details['imdbRating'] == 'N/A'
                          ? Text(
                              "IMDB Rating not available",
                              style: GoogleFonts.montserrat(
                                  fontSize: 16, fontWeight: FontWeight.w300),
                            )
                          : Text(
                              'IMDB Rating: ' + details["imdbRating"],
                              style: GoogleFonts.montserrat(
                                  fontSize: 16, fontWeight: FontWeight.w300),
                            )),
                    )
                  ],
                ))),
    );
  }

  showConfirm() {
    return showDialog(
      //barrierDismissible: true,
      context: context,
      child: AlertDialog(
        title: Text(
          "Confirmar exclusão?",
          style:
              GoogleFonts.montserrat(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        content: Container(
          child: Text(
            "Tem certeza que deseja remover esse filme dos favoritos?",
            textAlign: TextAlign.justify,
            style: GoogleFonts.montserrat(
              fontSize: 18,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        actions: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  width: 90,
                  height: 40,
                  child: OutlineButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    borderSide: BorderSide(width: 1, color: primaryColor),
                    child: Text(
                      'Sim',
                      style: GoogleFonts.montserrat(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w500),
                    ),
                    onPressed: () {
                      LocalDatabase.db.delete(widget.id).then((response) {
                        setState(() {
                          favorite = false;
                          favoriteLabel = 'Favoritar';
                        });
                        Navigator.of(context).pop();
                      });
                    },
                  ),
                ),
                Container(
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(5)),
                  width: 90,
                  height: 40,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    color: primaryColor,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      "Não",
                      style: GoogleFonts.montserrat(
                          fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  getDetails() async {
    await DetailsService().getDetails(widget.id).then((response) {
      details = response;
      setState(() {
        loading = false;
      });
    });
  }
}
