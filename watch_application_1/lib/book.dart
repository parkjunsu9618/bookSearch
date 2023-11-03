class Book {
  Book(
      {required this.id,
      required this.authors,
      required this.title,
      required this.subtitle,
      required this.thumbnail,
      required this.previewLink,
      required this.publisher,
      required this.publishedDate});

  String id;
  List authors;
  String title;
  String subtitle;
  String thumbnail;
  String previewLink;
  String publisher;
  String publishedDate;

  Map toJson() {
    return {
      "id": id,
      "authors": authors,
      "title": title,
      "subtitle": subtitle,
      "thumbnail": thumbnail,
      "previewLink": previewLink,
      "publisher": publisher,
      "publishedDate": publishedDate,
    };
  }

  factory Book.fromJson(json) {
    return Book(
      id: json['id'],
      authors: json['authors'],
      title: json['title'],
      subtitle: json['subtitle'],
      thumbnail: json['thumbnail'],
      previewLink: json['previewLink'],
      publisher: json['publisher'],
      publishedDate: json['publishedDate'],
    );
  }
}
