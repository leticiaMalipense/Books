import 'dart:io';

import 'package:books/helpers/books_helper.dart';
import 'package:flutter/material.dart';

class BookPage extends StatefulWidget {
  final Book book;

  BookPage({this.book});

  @override
  _BookPageState createState() => _BookPageState();
}

class _BookPageState extends State<BookPage> {
  final _titleController = TextEditingController();
  final _authorController = TextEditingController();
  final _publicationYearController = TextEditingController();
  final _commentsController = TextEditingController();

  final _titleFocus = FocusNode();
  final _authorFocus = FocusNode();
  final _publicationYearFocus = FocusNode();

  bool _userEdited = false;
  Book _edited;

  @override
  void initState() {
    super.initState();

    if(widget.book == null) {
      _edited = Book();
    } else {
      _edited = Book.fromMap(widget.book.toMap());
      _titleController.text = _edited.title;
      _authorController.text = _edited.author;
      _publicationYearController.text = _edited.publicationYear;
      _commentsController.text = _edited.comments;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrangeAccent,
        title: Text(_edited.title ?? "Adicionar novo livro"),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          if(_edited.title.isNotEmpty && _edited.author.isNotEmpty && _edited.publicationYear.isNotEmpty) {
            Navigator.pop(context, _edited);
          }
        },
        child: Icon(Icons.save),
        backgroundColor: Colors.deepOrangeAccent,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            GestureDetector(
              child: Container(
                width: 140.0,
                height: 140.0,
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    image: DecorationImage(image: _edited.img != null ? FileImage(File(_edited.img)) : AssetImage("images/camera.png"))
                ),
              ),
            ),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: "Título"),
              onChanged: (text){
                _userEdited = true;
                setState(() {
                  _edited.title = text;
                });
              },
            ),
            TextField(
              controller: _authorController,
              decoration: InputDecoration(labelText: "Autor"),
              onChanged: (text){
                _userEdited = true;
                _edited.author = text;
              },
            ),
            TextField(
              controller: _publicationYearController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "Ano de publicação"),
              onChanged: (text){
                _userEdited = true;
                _edited.publicationYear = text;
              },
            ),
            TextField(
              controller: _commentsController,
              decoration: InputDecoration(labelText: "Observações"),
              onChanged: (text){
                _userEdited = true;
                _edited.comments = text;
              },
            ),
          ],
        ),
      ),
    );
  }
}
