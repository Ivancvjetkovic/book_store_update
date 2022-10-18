import 'dart:convert';

import 'package:http/http.dart';

import 'package:book_store/book_model.dart';

class HttpService {
  final String baseApi = 'fakerapi.it';
  final String bookEndpoint = '/api/v1/books';
  // final Uri booksUrl = Uri.http('fakerapi.it', '/api/v1/books');

  Future<List<Book>> getBooks({int quantity = 10}) async {
    Response res =
        await get(Uri.http(baseApi, bookEndpoint, {'_quantity': '$quantity'}));

    print(res.body);

    if (res.statusCode == 200) {
      List<dynamic> body = jsonDecode(res.body)['data'];
      List<Book> books =
          body.map((dynamic item) => Book.fromJson(item)).toList();

      return books;
    } else {
      throw 'Cant get books';
    }
  }
}
