import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:movie/edit_movie.dart';
import 'package:movie/movie.dart';
import 'movie_detail.dart';
import 'db.dart';
import 'package:sqflite/sqflite.dart';

class MovieList extends StatefulWidget {
  @override
  MovieListState createState() {
    return new MovieListState();
  }
}

class MovieListState extends State<MovieList> {
  var movies;
  Color mainColor = const Color(0xff613232);
  DB databaseHelper = DB();

  void getData(BuildContext context) async {
    databaseHelper.initializeDatabase();
    databaseHelper.addAllDataIntoDB(context);
    updateListView();
  }

  void navigateToDetail(Movie movie) async {
    bool result =
    await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return new EditMovie(movie);
    }));

    if (result == true) {
      updateListView();
    }
  }

  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Movie>> todoListFuture = databaseHelper.getMovies();
      todoListFuture.then((todoList) {
        setState(() {
          this.movies = todoList;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    getData(context);

    return new Scaffold(
      backgroundColor: Colors.black,
      appBar: new AppBar(
        elevation: 0.3,
        centerTitle: true,
        backgroundColor: Colors.black,
        actions: <Widget>[
          TextButton(
              onPressed: () {
                navigateToDetail(Movie("", "", ""));
              },
              child: new Icon(
                Icons.add,
                color: Colors.white,
              ))
        ],
      ),
      body: new Padding(
        padding: const EdgeInsets.all(16.0),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new MovieTitle(mainColor),
            new Expanded(
              child: new ListView.builder(
                  itemCount: movies == null ? 0 : movies.length,
                  itemBuilder: (context, i) {
                    return new FlatButton(
                      child: new MovieCell(movies, i),
                      padding: const EdgeInsets.all(0.0),
                      onPressed: () {
                        navigateToDetail(movies[i]);
                      },
                      color: Colors.black,
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }
}

Future<Map> getJson(BuildContext context) async {
  String data =
  await DefaultAssetBundle.of(context).loadString("assets/json/list.json");

  return jsonDecode(data);
}

class MovieTitle extends StatelessWidget {
  final Color mainColor;

  MovieTitle(this.mainColor);

  @override
  Widget build(BuildContext context) {
    return new Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      child: new Text(
        'Movie List',
        style: new TextStyle(
            fontSize: 40.0,
            color: mainColor,
            fontWeight: FontWeight.bold,
            fontFamily: 'Arvo'),
        textAlign: TextAlign.left,
      ),
    );
  }
}

class MovieCell extends StatelessWidget {
  final movies;
  final i;
  DB databaseHelper = DB();
  Color mainColor = const Color(0xff000000);

  MovieCell(this.movies, this.i);

  @override
  Widget build(BuildContext context) {
    return new Column(
      children: <Widget>[
        new Row(
          children: <Widget>[
            new Padding(
                padding: const EdgeInsets.all(0.0),
                child: GestureDetector(
                  child: new Container(
                    margin: const EdgeInsets.all(16.0),
                    child: new Container(
                      width: 70.0,
                      height: 70.0,
                    ),
                    decoration: new BoxDecoration(
                      borderRadius: new BorderRadius.circular(10.0),
                      color: Colors.grey,
                      image: new DecorationImage(
                          image: new NetworkImage(movies[i].posterUrl),
                          fit: BoxFit.cover),
                      boxShadow: [
                        new BoxShadow(
                            color: mainColor,
                            blurRadius: 5.0,
                            offset: new Offset(2.0, 5.0))
                      ],
                    ),
                  ),
                  onTap: () {
                    _onView(context, movies[i]);
                  },
                )),
            new Expanded(
                child: new Container(
                  margin: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
                  child: new Column(
                    children: [
                      new Text(
                        movies[i].title,
                        style: new TextStyle(
                            fontSize: 20.0,
                            fontFamily: 'Arvo',
                            fontWeight: FontWeight.bold,
                            color: const Color(0xffffffff)),
                      ),
                      new Padding(padding: const EdgeInsets.all(2.0)),
                      new Text(
                        movies[i].plot,
                        maxLines: 3,
                        style: new TextStyle(
                            color: const Color(0xffffffff), fontFamily: 'Arvo'),
                      )
                    ],
                    crossAxisAlignment: CrossAxisAlignment.start,
                  ),
                )),
            GestureDetector(
              child: Icon(
                Icons.delete,
                color: Colors.red,
              ),
              onTap: () {
                _delete(context, movies[i]);
              },
            ),
          ],
        ),
        new Container(
          width: 300.0,
          height: 0.5,
          color: const Color(0xD2D2E1ff),
          margin: const EdgeInsets.all(16.0),
        )
      ],
    );
  }

  void _delete(BuildContext context, Movie movie) async {
    int result = await databaseHelper.deleteMovie(movie.id);
    if (result != 0) {
      _showSnackBar(context, 'Movie Deleted Successfully');
    }
  }

  void _onView(BuildContext context, Movie movie) async {
    Navigator.push(context, new MaterialPageRoute(builder: (context) {
      return new MovieDetail(movies[i]);
    }));
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
  }
}
