import 'package:book_store/blocs/bloc/book_bloc.dart';
import 'package:book_store/blocs/bloc/book_event.dart';
import 'package:book_store/blocs/bloc/book_state.dart';
import 'package:book_store/book_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class BookList extends StatefulWidget {
  const BookList({super.key});

  @override
  State<BookList> createState() => _BookListState();
}

class _BookListState extends State<BookList> {
  String dropDownValue = '10';

  List<int> items = [
    10,
    20,
    50,
    100,
  ];

  RefreshController refreshController =
      RefreshController(initialRefresh: false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BOOKSHOP'),
        backgroundColor: const Color(0xff7585db),
        automaticallyImplyLeading: false,
        actions: [
          Container(
            padding: const EdgeInsets.all(6),
            margin: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
                color: Colors.white),
            child: BlocBuilder<BookBloc, BookState>(
              builder: (context, bookState) {
                return DropdownButtonHideUnderline(
                  child: DropdownButton(
                    icon: const SizedBox.shrink(),
                    value: bookState.quantity ?? dropDownValue,
                    items: items.map((int items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(
                          items.toString(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      context
                          .read<BookBloc>()
                          .add(BookLoadEvent(quantity: newValue as int));
                    },
                  ),
                );
              },
            ),
          )
        ],
      ),
      body: BlocBuilder<BookBloc, BookState>(builder: (context, bookState) {
        return SmartRefresher(
            controller: refreshController,
            onRefresh: () {
              // setState(() {
              //   // httpService.getBooks(quantity: int.parse(dropDownValue));
              // });
              context
                  .read<BookBloc>()
                  .add(BookLoadEvent(quantity: bookState.quantity));
              refreshController.refreshCompleted();
            },
            child: () {
              if (bookState.status == BookStateStatus.loading) {
                return const Center(child: CircularProgressIndicator());
              } else if (bookState.status == BookStateStatus.loadedError) {
                return const Center(child: Text('There was no data'));
              } else {
                return ListView.builder(
                  itemCount: bookState.books?.length,
                  itemBuilder: (context, index) => bookTemplate(
                    bookState.books![index],
                  ),
                );
              }
            }());
      }

          // body: FutureBuilder(
          //   future: httpService.getBooks(quantity: int.parse(dropDownValue)),
          //   builder: (
          //     BuildContext context,
          //     AsyncSnapshot<List<Book>> snapshot,
          //   ) {
          //     if (snapshot.hasData) {
          //       List<Book>? books = snapshot.data;

          //       return SmartRefresher(
          //           controller: _refreshController,
          //           onRefresh: () {
          //             setState(() {
          //               httpService.getBooks(quantity: int.parse(dropDownValue));
          //             });
          //             _refreshController.refreshCompleted();
          //           },
          //           child: _refreshController.isRefresh
          //               ? const CircularProgressIndicator()
          //               : ListView.builder(
          //                   itemCount: books?.length,
          //                   itemBuilder: ((context, index) => bookTemplate(
          //                         books![index],
          //                       )),
          //                 ));
          //     }

          //     return const CircularProgressIndicator();
          //   },
          // ),
          ),
    );
  }
}

Widget bookTemplate(Book model) {
  return Card(
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(20),
      ),
    ),
    color: const Color.fromARGB(255, 214, 214, 214),
    margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
    elevation: 0,
    child: Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      height: 165,
                      width: 100,
                      color: const Color(0xff7585db),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    model.title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 1.0, bottom: 20.0),
                    child: Text(
                      model.author,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ),
                  SizedBox(
                    width: 200,
                    height: 80,
                    child: Text(
                      model.description,
                      style: const TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0, bottom: 8.0),
                    child: Text(
                      model.isbn,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                model.genre,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              ),
              Text(
                model.publisher,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
              Text(
                model.published,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ],
          )
        ],
      ),
    ),
  );
}
