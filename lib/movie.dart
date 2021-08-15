class Movie {
  late final int id;
  late final String title;
  late final String plot;
  late final String posterUrl;

  Movie(String title,
      String plot,
      String posterUrl) {
    this.title = title;
    this.plot = plot;
    this.posterUrl = posterUrl;
  }

  Movie.withId(int id, String title,
      String plot,
      String posterUrl) {
    this.id = id;
    this.title = title;
    this.plot = plot;
    this.posterUrl = posterUrl;
  }


  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'plot': plot,
      'posterUrl': posterUrl
    };
  }

  @override
  String toString() {
    return 'Movie{id: $id, title: $title, plot: $plot, posterUrl: $posterUrl}';
  }

  static Movie fromMap(Map<String, dynamic> val) {
    return Movie.withId(
      val['id'],
      val['title'],
      val['plot'],
      val['posterUrl'],
    );
  }
}