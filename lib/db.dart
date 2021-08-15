import 'dart:async';

import 'package:flutter/widgets.dart';
import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'movie.dart';
import 'dart:io';

class DB {
  static DB? _databaseHelper; // Singleton DatabaseHelper
  static Database? _database; // Singleton Database
  String movieTable = "movie";

  DB._createInstance(); // Named constructor to create instance of DatabaseHelper

  factory DB() {
    if (_databaseHelper == null) {
      _databaseHelper =
          DB._createInstance(); // This is executed only once, singleton object
    }
    return _databaseHelper!;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database!;
  }

  Future<Database> initializeDatabase() async {
    String directory = await getDatabasesPath();
    String path = directory + 'movie_database.db';
    var movie_database =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return movie_database;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $movieTable(id INTEGER PRIMARY KEY, title TEXT, plot TEXT, posterUrl TEXT)');
  }

  Future<int> insertMovie(Movie movie) async {
    final db = await database;
    return await db.insert(
      movieTable,
      movie.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Movie>> getMovies() async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query(movieTable);

    return List.generate(maps.length, (i) {
      return Movie.withId(
        maps[i]['id'],
        maps[i]['title'],
         maps[i]['plot'],
        maps[i]['posterUrl'],
      );
    });
  }

  Future<int> updateMovie(Movie movie) async {
    final db = await database;
   return await db.update(
      movieTable,
      movie.toMap(),
      where: 'id = ?',
      whereArgs: [movie.id],
    );
  }

  Future<int> deleteMovie(int id) async {
    final db = await database;
    int result = await db.delete(
      movieTable,
      where: 'id = ?',
      whereArgs: [id],
    );
    return result;
  }

  Future<int?> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT (*) from $movieTable');
    int? result = Sqflite.firstIntValue(x);
    return result;
  }

  Future<void> addAllDataIntoDB(BuildContext context) async {
    int? count = await getCount();
    if (count == 0) {
      String data = await DefaultAssetBundle.of(context)
          .loadString("assets/json/list.json");

      final db = await database;

      Batch batch = db.batch();

      var movieData = json.decode(data);
      var movieList = movieData['movies'];

      movieList.forEach((val) {
        Movie movie = Movie.fromMap(val);
        batch.insert(
          movieTable,
          movie.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      });

      batch.commit();
    }
  }
}
