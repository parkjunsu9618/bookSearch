import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:watch_application_1/book_service.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'book.dart';

class MainPage extends StatefulWidget {
  MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  var bottomNavIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Consumer<BookService>(
      builder: (context, bookService, child) {
        return Scaffold(
          body: [
            searchPage(),
            LikePage(),
          ][bottomNavIndex],
          bottomNavigationBar: BottomNavigationBar(
            selectedItemColor: Colors.black,
            unselectedItemColor: Colors.grey,
            showUnselectedLabels: true,
            selectedFontSize: 12,
            unselectedFontSize: 12,
            iconSize: 28,
            type: BottomNavigationBarType.fixed,
            onTap: (value) {
              setState(() {
                bottomNavIndex = value;
              });
            },
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: '검색',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.star),
                label: '좋아요',
              ),
            ],
            currentIndex: bottomNavIndex,
          ),
        );
      },
    );
  }
}

class LikePage extends StatelessWidget {
  const LikePage({super.key});

  @override
  Widget build(BuildContext context) {
    BookService bookService = context.read<BookService>();
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
        child: ListView.separated(
          itemBuilder: (context, index) {
            if (bookService.bookLikedList.isEmpty) {
              return Container();
            }
            Book book = bookService.bookLikedList.elementAt(index);
            return BookListTile(book: book);
          },
          separatorBuilder: (context, index) => Divider(),
          itemCount: bookService.bookLikedList.length,
        ),
      ),
    );
  }
}

class searchPage extends StatelessWidget {
  const searchPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    TextEditingController controller1 = TextEditingController();

    BookService bookService = context.read<BookService>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        toolbarHeight: 80,
        elevation: 1,
        title: TextField(
          controller: controller1,
          onSubmitted: (value) {
            bookService.searchBook(value);
          },
          cursorColor: Colors.grey,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.search, color: Colors.grey),
            hintText: "작품, 감독, 배우, 컬렉션, 유저 등",
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              bookService.searchBook(controller1.text);
            },
            child: Text(
              "검색",
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
        child: ListView.separated(
          itemBuilder: (context, index) {
            Book book = bookService.bookList[index];
            return BookListTile(book: book);
          },
          separatorBuilder: (context, index) => Divider(),
          itemCount: bookService.bookList.length,
        ),
      ),
    );
  }
}

class BookListTile extends StatelessWidget {
  BookListTile({super.key, required this.book});

  final Book book;

  @override
  Widget build(BuildContext context) {
    BookService bookService = context.read<BookService>();
    return ListTile(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return WebViewPage(
                url: book.previewLink.replaceFirst("http", "https"),
              );
            },
          ),
        );
      },
      leading: Image.network(
        book.thumbnail,
        fit: BoxFit.fitHeight,
      ),
      title: Text(book.title),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(book.authors.isEmpty ? "없음" : book.authors[0]),
          Text(book.publisher),
          Text(book.subtitle),
        ],
      ),
      subtitleTextStyle: TextStyle(fontSize: 13),
      titleTextStyle: TextStyle(fontSize: 20, color: Colors.black),
      trailing: IconButton(
        onPressed: () {
          bookService.toggleLike(book);
        },
        icon: bookService.bookLikedList.map((book) => book.id).contains(book.id)
            ? Icon(
                Icons.star,
                color: Colors.amber,
              )
            : Icon(Icons.star_border),
      ),
    );
  }
}

class WebViewPage extends StatelessWidget {
  const WebViewPage({super.key, required this.url});

  final url;

  @override
  Widget build(BuildContext context) {
    return WebView(
      initialUrl: url,
    );
  }
}
