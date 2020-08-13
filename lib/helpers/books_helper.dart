import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

final String bookTable = "bookTable";
final String idColumn = "idColumn";
final String titleColumn = "titleColumn";
final String authorColumn = "authorColumn";
final String publicationYearColumn = "publicationYearColumn";
final String commentsColumn = "commentsColumn";
final String imgColumn = "imgColumn";



class BooksHelper {
  static final BooksHelper _instance = BooksHelper.internal();

  factory BooksHelper() => _instance;
  BooksHelper.internal();

  Database _db;

  Future<Database> get db async {
    if(_db != null) {
      return _db;
    } else {
      _db = await initDb();
      return _db;
    }
  }

  Future<Database> initDb() async {
    final dataBasePath = await getDatabasesPath();
    final path = join(dataBasePath, "books.db");

    return openDatabase(path, version:1, onCreate: (Database db, int newerVersion) async {
      await db.execute(
          "CREATE TABLE $bookTable($idColumn INTEGER PRIMARY KEY, $titleColumn TEXT, $authorColumn TEXT, "
                        "$publicationYearColumn TEXT, $commentsColumn TEXT, $imgColumn TEXT )"
      );
    });
  }

  Future<Book> saveBook(Book book) async {
    Database dbBook = await db;
    book.id = await dbBook.insert(bookTable, book.toMap());
    return book;
  }

  Future<Book> getBooks(int id) async {
    Database dbBook = await db;
    List<Map> maps = await dbBook.query(bookTable, columns:[idColumn, titleColumn, authorColumn, publicationYearColumn, commentsColumn, imgColumn],
                     where: "$idColumn = ?",
                     whereArgs: [id]);
    if(maps.length > 0) {
      return Book.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<int> deleteBook(int id) async {
    Database dbBook = await db;
    return await dbBook.delete(bookTable,where: "$idColumn = ?", whereArgs: [id]);
  }

  Future<int> updateBook(Book book) async {
    Database dbBook = await db;
    return await dbBook.update(bookTable, book.toMap(), where: "$idColumn = ?", whereArgs: [book.id]);
  }

  Future<List> getAllBooks() async {
    Database dbBook = await db;
    List<Map> booksMap = await dbBook.rawQuery("SELECT * FROM $bookTable");
    List<Book> books = List();

    for(Map map in booksMap){
      books.add(Book.fromMap(map));
    }

    return books;
  }

  Future close() async {
    Database dbBook = await db;
    dbBook.close();
  }
}

class Book {
    int id;
    String title;
    String author;
    String publicationYear;
    String comments;
    String img;

    Book();

    Book.fromMap(Map map){
      id = map[idColumn];
      title = map[titleColumn];
      author = map[authorColumn];
      publicationYear = map[publicationYearColumn];
      comments = map[commentsColumn];
      img = map[imgColumn];
    }

    Map toMap(){
      Map<String, dynamic> map = {
        titleColumn: title,
        authorColumn: author,
        publicationYearColumn: publicationYear,
        commentsColumn: comments,
        imgColumn: img,
      };
      if(id != null) {
        map[idColumn] = id;
      }
      return map;
    }

    @override
    String toString() {
      return 'Book{id: $id, title: $title, author: $author, publicationYear: $publicationYear, comments: $comments, img: $img}';
    }

}