import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'book.dart';
import 'main.dart';

class BookService extends ChangeNotifier {
  List<Book> bookList = [];
  List<Book> bookLikedList = [];
  BookService() {
    loadData();
  }

  void searchBook(String q) async {
    if (q.isNotEmpty) {
      Response res = await Dio().get(
          'https://www.googleapis.com/books/v1/volumes?q=$q&startIndex=0&maxResults=40');
      List items = res.data["items"];
      jsonParsing(items);
    }
    notifyListeners();
  }

  void toggleLike(Book book) {
    String bookId = book.id;

    if (bookLikedList.map((book) => book.id).contains(bookId)) {
      bookLikedList.removeWhere((book) => book.id == bookId);
    } else {
      bookLikedList.add(book);
    }
    print(bookLikedList);
    notifyListeners();
    saveData();
  }

  void jsonParsing(List items) {
    bookList.clear();
    for (Map<String, dynamic> item in items) {
      Book book = Book(
        id: item["id"] ?? "",
        authors: item["volumeInfo"]["authors"] ?? [],
        title: item["volumeInfo"]["title"] ?? "",
        subtitle: item["volumeInfo"]["subtitle"] ?? "",
        thumbnail: item["volumeInfo"]["imageLinks"]?["thumbnail"] ??
            "https://thumbs.dreamstime.com/b/no-image-available-icon-flat-vector-no-image-available-icon-flat-vector-illustration-132482953.jpg",
        previewLink: item["volumeInfo"]["previewLink"] ?? "",
        publisher: item["volumeInfo"]["publisher"] ?? "",
        publishedDate: item["volumeInfo"]["publishedDate"] ?? "",
      );
      bookList.add(book);
    }
  }

  //shared_pref 사용법
  // prefs.getString(key)
  // prefs.setString(key, value)

  void loadData() {
    // 데이터를 가져오는것.
    String? jsonString = prefs.getString('bookLikeList');
    // '[{"content": "1"}, {"content": "2"}]'

    if (jsonString == null) return; // null 이면 로드하지 않음

    List bookLikeListJson = jsonDecode(jsonString);

    bookLikedList =
        bookLikeListJson.map((json) => Book.fromJson(json)).toList();
  }

  void saveData() {
    // 데이터를 세이브 하는것.
    List bookLikedListJson =
        bookLikedList.map((book) => book.toJson()).toList();
    // [{"content": "1"}, {"content": "2"}]

    String jsonString = jsonEncode(bookLikedListJson);
    // '[{"content": "1"}, {"content": "2"}]'

    prefs.setString('bookLikeList', jsonString);
  }
}
