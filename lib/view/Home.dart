import 'dart:io';

import 'package:books/helpers/books_helper.dart';
import 'package:flutter/material.dart';

import 'BookPage.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  BooksHelper helper = BooksHelper();
  List<Book> books = List();

  @override
  void initState() {
    super.initState();
    getBooks();
  }

  void getBooks() {
    helper.getAllBooks().then((value){
      setState(() {
        books = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("MyBooks"),
        centerTitle: true,
        backgroundColor: Colors.deepOrangeAccent,
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          _showBookPage();
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.deepOrangeAccent,
      ),
        body: ListView.builder(
          itemCount: books.length,
          itemBuilder: (context, index){
            return _bookCar(context, index);
          },
          padding: EdgeInsets.all(10.0)
        )
    );
  }

  Widget _bookCar(BuildContext context, int index) {
    return GestureDetector(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(
            children: <Widget>[
              Container(
                width: 90.0,
                height: 90.0,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  image: DecorationImage(image: books[index].img != null ? FileImage(File(books[index].img)) : AssetImage("images/camera.png"))
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("Título: " + books[index].title ?? "", style: TextStyle(fontSize: 18.0),
                        overflow: TextOverflow.ellipsis),
                    Text("Autor: " + books[index].author ?? "", style: TextStyle(fontSize: 16.0),
                        overflow: TextOverflow.ellipsis),
                    Text("Publicação: " + books[index].publicationYear.toString() ?? "", style: TextStyle(fontSize: 16.0),
                        overflow: TextOverflow.ellipsis),
                  ],
                ),
              )
            ],
          )
        ),
      ),
      onTap: (){
        _showBookPage(book: books[index]);
      },
    );
  }
  void _showBookPage({Book book}) async {
    final responseBook = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => BookPage(book: book,))
    );

    if(responseBook != null){
      if(book != null){
        await helper.updateBook(responseBook);
      } else {
        await helper.saveBook(responseBook);
      }
      getBooks();
    }
  }
}
