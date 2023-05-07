import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:streamfirestorepagination/pages/controller/home_controller.dart';
import 'package:streamfirestorepagination/pages/widgets/comment_list_item.dart';
import 'package:streamfirestorepagination/pages/widgets/comment_shimmer.dart';
import 'dart:async';
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:streamfirestorepagination/model/comment.dart';
final ScrollController controller = ScrollController();

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;


  @override
  ConsumerState<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    controller.addListener(() => scrollListeners());

    return Scaffold(
      body: ref.watch(provider).when(
          data: (List<Comment> a) => ListView.builder(
            controller: controller,
              cacheExtent: 88888,


              itemCount:  a.length ,
              itemBuilder: (context, index) {
                return Center(
                  child: Text(
                    '$index' + a[index].title ,

                    // a[index].text + a[index].title + a[index].createdAt.toString(),
                    style: const TextStyle(fontSize: 30),
                  ),
                );
              }),
          error: (error, stack) => SingleChildScrollView(
            child: Column(
              children: [
                Text(error.toString()),
                // Text(stack.toString()),
              ],
            ),
          ),
          loading: () => const Center(child: CircularProgressIndicator())),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ref.read(provider.notifier).doSomethingaddtoasyncdata() ;
        },
        child: const Icon(Icons.play_circle),
      ),
    );
  }

  scrollListeners() async {
    // Whether the scroll has gone beyond the middle of the entire range.
    final reachMaxExtent =
        controller.offset >= controller.position.maxScrollExtent;
    // Whether the scroll does not go beyond the full range and is not at the top.
    final outOfRange =
        !controller.position.outOfRange && controller.position.pixels != 0;
    if (reachMaxExtent && outOfRange ) {
      // Firestore Load the next list
      print('scrooooooooool  caaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaallllllllllllllleeeeeeeeeeed');
      // ref.read(provider.notifier).aasd();

       await  ref.read(provider.notifier).doSomethingonrefresh() ;

      // doSomething();

    }
  }

}
//
// final chatProvider = StreamProvider<List<Comment>>((ref) async* {
//   // Connect to an API using sockets, and decode the output
//
//
//     // ref.refresh(chatProvider); cant be done;
//
//   var query = _firestore.collection('comments').orderBy('createdAt', descending: true).limit(20);
//   List<Comment> comments = [];
//   bool updown = true;
//   // var currentRequestIndex = _comments.length;
//    query.snapshots().listen(
//           (event) {
//         if (event.docs.isNotEmpty) {
//           var comments1 = event.docs.map((element) => Comment.fromFirestore(element)).toList();
//           // _comments.add(comments);
//           comments = comments1;
//           if(updown == false){
//            /// ref.refresh(chatProvider); cant be done; /// we cant make function or update the value.
//           }
//         }
//       });
//   await Future.delayed(const Duration(seconds: 1));
//   yield comments;
// });






final StreamController<List<Comment>> _streamController = StreamController<List<Comment>>.broadcast();
DateTime x = DateTime.now();
Comment c = Comment(title: 'tt', text: 'tt', createdAt: x);
Comment d = Comment(title: 'ff', text: 'ff', createdAt: x);
int totalCount = 0;
List<Comment> results = [];


List<Comment> m = [c, d];
List<Comment> n = [d, d];

final provider = StreamNotifierProvider<MyNotifier, List<Comment>>(MyNotifier.new);
final FirebaseFirestore _firestore = FirebaseFirestore.instance;




class MyNotifier extends StreamNotifier <List<Comment>> {
  bool onlylisten = true;

  DocumentSnapshot? _lastDocument;
  List<Comment> results1 = [];
  List<Comment> comments = [];
  List<List<Comment>> _comments = [];
  @override
  Stream<List<Comment>> build() async* {
    // List<Comment> comments;
    print(' only listen $onlylisten');

    ref.notifyListeners();
    totalCount = await count();
     print('$totalCount');
    yield* aasd();    ///* is needed to solve assigning issue from list of comments to stream of list of comments
  }


  count () async {
    AggregateQuerySnapshot query = await _firestore
        .collection('comments')
        .orderBy('createdAt', descending: true)
        .count()
        .get();
    return query.count;
  }
  Stream<List<Comment>> aasd() async* {
    /// Return type has to be Future<List<Comment>> all the other places List<Comment>,

    onlylisten = false;
    print(' only listen $onlylisten');
    var query = _firestore.collection('comments').orderBy('createdAt', descending: true).limit(30);

    if (_lastDocument != null  ) {
      query = query.startAfterDocument(_lastDocument!);
    }
    var currentRequestIndex = _comments.length;
    var d = _comments.length;
    print('currentRequestIndex outside isnotempty $currentRequestIndex');
    // print('_comments.length $_comments.length');
    // print('_comments $_comments');
    // var p =_comments8.length ;
    // listen() Use methods to subscribe to updates
    query.snapshots().listen(
          (event) {
        if (event.docs.isNotEmpty) {
          comments = event.docs.map((element) => Comment.fromFirestore(element)).toList();
          // _comments.add(comments);
          ///yield comments; this will not work
          print('listen executed');
          if (onlylisten == true) {
            // doSomething();
            print(' only listen $onlylisten');
          }

          var pageExists = currentRequestIndex < _comments.length;
          print('currentRequestIndex inside if of isnotempty $currentRequestIndex');
          // print('currentRequestIndex d inside if of isnotempty $d');
          // print('currentRequestIndex p inside if of isnotempty $p');
          // print('_comments.length $_comments.length');
          int z = _comments.length;
          print('_comments $z.');
          if (pageExists) {
            _comments[currentRequestIndex] = comments;
            int y = comments.length;
            print('if of page exist executed here is comment $y');
             // doSomethingonrefresh();
            // ref.notifyListeners();
          }
          // If the page doesn't exist, add a new page
          else {
            print('else of page exist executed $pageExists'); //else of page exist executed false executed when we add data first time
            _comments.add(comments);
          }

            results = _comments.fold<List<Comment>>(
                [], (initialValue, pageItems) => initialValue..addAll(pageItems));
            int x = results.length;
            print('result $x');


          if (pageExists) {
            doSomethingonrefresh1();
            // state = ref.refresh(provider);
          }
        }
        if (event.docs.isEmpty && event.docChanges.isNotEmpty) {
          for (final data in event.docChanges) {
            //If the index of the modified document is -1 (deleted article)
            if (data.newIndex == -1) {
              // Delete the article from the global list
              results
                  .removeWhere((element) => element.id == data.doc.data()?['id']);
              print('delete if called');

            }
          }
          // StreamController Broadcast all comments using
          // _streamController.add(results);
        }


        if (results.isNotEmpty && currentRequestIndex == _comments.length - 1) {
          _lastDocument = event.docs.last;
          print('last doc called');
        }
      },
    );

    print(_comments);
    await Future.delayed(const Duration(seconds: 1));
    onlylisten = true;
    print(' only listen $onlylisten');
    yield results;
    // results1 = results;


    // ref.notifyListeners();
    // results1 =results;
  }





  /// this update the state just by calling a function state= AsyncData(value to be updated). no need to return in this.
  doSomething11111() async {
    state = const AsyncLoading();
    await Future.delayed(const Duration(seconds: 1));
    state = AsyncData(comments);

    /// state = AsyncData(n); we can replace by this
    print(' only listen of do something $onlylisten');
  }

  /// this update the state just by calling a update. returning is must here
  doSomething() async {
    update((data) async {
      state = const AsyncLoading();
      await Future.delayed(const Duration(seconds: 1));
      print(' only listen of do something $onlylisten');
      print(comments);
      return results;

      /// return n; we can replace by this
    });
  }
  doSomethingonrefresh1() async {
      state = await ref.refresh(provider);}

  /// this update the state by refresh.
  doSomethingonrefresh() async {
    print('ref ke if ke bahar');
    print(totalCount);
    print(results.length);
    if(totalCount >=results.length){
      print('ref ke if ke andar');
    print(' only listen of do something $onlylisten');
    state = await ref.refresh(provider);}
  }

  /// This will add/remove its all local not impacted firebase. Comment instance on the async value.
  doSomethingaddtoasyncdata()  async {
    print(' only listen of do something $onlylisten');
    state = AsyncValue.data([c, ...state.value!]);

    await Future.delayed(const Duration(seconds: 5));
    state = AsyncValue.data(List.from(state.value!)..remove(c));

    await Future.delayed(const Duration(seconds: 5));
    state = AsyncValue.data(List.from(state.value!)..remove(state.value![0]));

    // state = await ref.refresh(provider);
  }


}


// final StreamController<List<Comment>> _streamController = StreamController<List<Comment>>.broadcast();
// DateTime x = DateTime.now();
// Comment c = Comment(title: 'tt', text: 'tt', createdAt: x);
// Comment d = Comment(title: 'ff', text: 'ff', createdAt: x);
// int totalCount = 0;
//
//
// List<Comment> m = [c, d];
// List<Comment> n = [d, d];
//
// final provider = AsyncNotifierProvider<MyNotifier, List<Comment>>(MyNotifier.new);
// final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//
//
//
//
// class MyNotifier extends AsyncNotifier<List<Comment>> {
//   bool onlylisten = true;
//
//   DocumentSnapshot? _lastDocument;
//   List<Comment> results1 = [];
//   List<Comment> comments = [];
//   List<List<Comment>> _comments = [];
//   @override
//   Future<List<Comment>> build() async {
//     // List<Comment> comments;
//     print(' only listen $onlylisten');
//
//     ref.notifyListeners();
//   totalCount = await count();
//   print('$totalCount');
//     return aasd();
//   }
//
//
//   count () async {
//     AggregateQuerySnapshot query = await _firestore
//         .collection('comments')
//         .orderBy('createdAt', descending: true)
//         .count()
//         .get();
//     return query.count;
//   }
//   Future<List<Comment>> aasd() async {
//     /// Return type has to be Future<List<Comment>> all the other places List<Comment>,
//     List<Comment> results = [];
//     onlylisten = false;
//     print(' only listen $onlylisten');
//     var query = _firestore.collection('comments').orderBy('createdAt', descending: true).limit(30);
//
//     if (_lastDocument != null) {
//       query = query.startAfterDocument(_lastDocument!);
//     }
//     var currentRequestIndex = _comments.length;
//     var d = _comments.length;
//     print('currentRequestIndex outside isnotempty $currentRequestIndex');
//     // print('_comments.length $_comments.length');
//     // print('_comments $_comments');
//     // var p =_comments8.length ;
//     // listen() Use methods to subscribe to updates
//     query.snapshots().listen(
//       (event) {
//         if (event.docs.isNotEmpty) {
//           comments = event.docs.map((element) => Comment.fromFirestore(element)).toList();
//           _comments.add(comments);
//           ///yield comments; this will not work
//           print('listen executed');
//           if (onlylisten == true) {
//             // doSomething();
//             print(' only listen $onlylisten');
//           }
//
//           var pageExists = currentRequestIndex < _comments.length;
//           print('currentRequestIndex inside if of isnotempty $currentRequestIndex');
//           // print('currentRequestIndex d inside if of isnotempty $d');
//           // print('currentRequestIndex p inside if of isnotempty $p');
//           // print('_comments.length $_comments.length');
//           int z = _comments.length;
//           print('_comments $z.');
//           if (pageExists) {
//             _comments[currentRequestIndex] = comments;
//             int y = comments.length;
//             print('if of page exist executed here is comment $y');
//           }
//           // If the page doesn't exist, add a new page
//           else {
//             print('else of page exist executed $pageExists'); //else of page exist executed false executed when we add data first time
//             _comments.add(comments);
//           }
//           results = _comments.fold<List<Comment>>(
//               [], (initialValue, pageItems) => initialValue..addAll(pageItems));
//           int x = results.length;
//           print('result $x');
//         }
//         if (event.docs.isEmpty && event.docChanges.isNotEmpty) {
//           for (final data in event.docChanges) {
//             //If the index of the modified document is -1 (deleted article)
//             if (data.newIndex == -1) {
//               // Delete the article from the global list
//               results
//                   .removeWhere((element) => element.id == data.doc.data()?['id']);
//               print('delete if called');
//
//             }
//           }
//           // StreamController Broadcast all comments using
//           // _streamController.add(results);
//         }
//
//
//         if (results.isNotEmpty && currentRequestIndex == _comments.length - 1) {
//           _lastDocument = event.docs.last;
//           print('last doc called');
//         }
//       },
//     );
//
//     print(_comments);
//     await Future.delayed(const Duration(seconds: 1));
//     onlylisten = true;
//     print(' only listen $onlylisten');
//
//     results1 = results;
//     return results;
//     results1 =results;
//   }
//
//
//
//
//
//   /// this update the state just by calling a function state= AsyncData(value to be updated). no need to return in this.
//   doSomething11111() async {
//     state = const AsyncLoading();
//     await Future.delayed(const Duration(seconds: 1));
//     state = AsyncData(comments);
//
//     /// state = AsyncData(n); we can replace by this
//     print(' only listen of do something $onlylisten');
//   }
//
//   /// this update the state just by calling a update. returning is must here
//   doSomething() async {
//     update((data) async {
//       state = const AsyncLoading();
//       await Future.delayed(const Duration(seconds: 1));
//       print(' only listen of do something $onlylisten');
//       print(comments);
//       return results1;
//
//       /// return n; we can replace by this
//     });
//   }
//
//   /// this update the state by refresh.
//   doSomethingonrefresh() async {
//     print(' only listen of do something $onlylisten');
//     state = await ref.refresh(provider);
//   }
//
//   /// This will add/remove its all local not impacted firebase. Comment instance on the async value.
//   doSomethingaddtoasyncdata()  async {
//     print(' only listen of do something $onlylisten');
//     state = AsyncValue.data([c, ...state.value!]);
//
//     await Future.delayed(const Duration(seconds: 5));
//     state = AsyncValue.data(List.from(state.value!)..remove(c));
//
//     await Future.delayed(const Duration(seconds: 5));
//     state = AsyncValue.data(List.from(state.value!)..remove(state.value![0]));
//
//     // state = await ref.refresh(provider);
//   }
//
//
// }

// @protected
// Future<State> update(
//     FutureOr<State> Function(State) cb, {
//       FutureOr<State> Function(Object err, StackTrace stackTrace)? onError,
//     }) async {
//   // TODO cancel on rebuild?
//
//   final newState = await future.then(cb, onError: onError);
//   state = AsyncData<State>(newState);
//   return newState;
// }

// class MyHomePage extends ConsumerStatefulWidget {
//   const MyHomePage({super.key, required this.title});
//
//   final String title;
//
//   @override
//   ConsumerState<MyHomePage> createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends ConsumerState<MyHomePage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: ref.watch(provider).when(
//           data: (List<Comment> a) => ListView.builder(
//               cacheExtent: 88888,
//               itemCount: a.length,
//
//               itemBuilder: (context, index) {
//
//                   return    Center(
//                       child: Text(
//                         a[index].text  + a[index].title + a[index].createdAt.toString() ,
//
//                         style: const TextStyle(fontSize: 30),
//                       ),);
//                 }
//                 ),
//
//
//
//
//
//
//           error: (error, stack) => Text(error.toString()),
//           loading: () => const Center(child: CircularProgressIndicator())),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           ref.read(provider.notifier).doSomething();
//         },
//         child: const Icon(Icons.play_circle),
//       ),
//     );
//   }
// }
//
//
// final StreamController<List<Comment>> _streamController =
// StreamController<List<Comment>>.broadcast();
// DateTime  x=DateTime.now();
// Comment c = Comment(title: 'tt', text: 'tt', createdAt: x) ;
// Comment d = Comment(title: 'ff', text: 'ff', createdAt: x) ;
// List<Comment> m = [c,d];
// List<Comment> n = [d,d];
//
// final provider = AsyncNotifierProvider<MyNotifier, List<Comment>>(MyNotifier.new);
// final FirebaseFirestore _firestore = FirebaseFirestore.instance;
// class MyNotifier extends AsyncNotifier<List<Comment>> {
//   List<Comment> comments = [];
//   @override
//   Future<List<Comment>> build() async {
//     // List<Comment> comments;
//         await _firestore
//         .collection('comments')
//         .orderBy('createdAt', descending: true)
//         .limit(20).get().then((event) {
//           comments = event.docs
//               .map((element) => Comment.fromFirestore(element))
//               .toList();
//           print(comments);
//         });
//         // query.(event) {
//         //  print('listen executed');
//         //
//         // comments = event.docs
//         //     .map((element) => Comment.fromFirestore(element))
//         //     .toList();
//         //  print(comments);
//         //  // return comments;
//
//         print(comments);
//         return comments;
//   }
//
//   doSomething() async {
//     update((data) async {
//       state = const AsyncLoading();
//       await Future.delayed(const Duration(seconds: 1));
//      print(comments);
//       return comments;
//     });
//   }
// }
//
//

//
//
// class MyHomePage extends ConsumerStatefulWidget {
//   const MyHomePage({super.key, required this.title});
//
//   final String title;
//
//   @override
//   ConsumerState<MyHomePage> createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends ConsumerState<MyHomePage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: ref.watch(provider).when(
//           data: (Comment a) =>  Center(
//
//               child: Text(
//                a.text  + a.title + a.createdAt.toString() ,
//
//                 style: const TextStyle(fontSize: 30),
//               )),
//           error: (error, stack) => Text(error.toString()),
//           loading: () => const Center(child: CircularProgressIndicator())),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           ref.read(provider.notifier).doSomething();
//         },
//         child: const Icon(Icons.play_circle),
//       ),
//     );
//   }
// }
// DateTime  x=DateTime.now();
// Comment c = Comment(title: 'tt', text: 'tt', createdAt: x) ;
// Comment d = Comment(title: 'ff', text: 'ff', createdAt: x) ;
// final provider = AsyncNotifierProvider<MyNotifier, Comment>(MyNotifier.new);
//
// class MyNotifier extends AsyncNotifier<Comment> {
//   @override
//   Future<Comment> build() async {
//
//     await Future.delayed(const Duration(seconds: 1));
//     // List<int> a = [1,2,2];
//     return c;
//   }
//
//   doSomething() async {
//     update((data) async {
//       state = const AsyncLoading();
//       await Future.delayed(const Duration(seconds: 1));
//       return d;
//     });
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:streamfirestorepagination/pages/controller/home_controller.dart';
// import 'package:streamfirestorepagination/pages/widgets/comment_list_item.dart';
// import 'package:streamfirestorepagination/pages/widgets/comment_shimmer.dart';
// import 'dart:async';
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:streamfirestorepagination/model/comment.dart';
//
// class asyncnotifierriverpod extends ConsumerWidget {
//   const asyncnotifierriverpod({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final state = ref.watch(commentProvider);
//     final notifier = ref.watch(commentProvider.notifier);
//     return state.when(
//       data: (data) => ListView.builder(
//         cacheExtent: 88888,
//         controller: notifier.controller,
//         itemCount:
//         data.length < notifier.totalCount ? data.length + 1 : data.length,
//         itemBuilder: (context, index) {
//           if (index != data.length) {
//             return CommentListItem(comment: data[index]);
//           } else {
//             return Center(
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 20.0),
//                 child: CircularProgressIndicator(),
//               ),
//             );
//           }
//         },
//       ),
//       loading: () => CommentShimmer(),
//       error: (error, stackTrace) => Center(
//         child: Text('error'),
//       ),
//     );
//   }
// }
//
//
//
//
//
// final FirebaseFirestore _firestore = FirebaseFirestore.instance;
// final StreamController<List<Comment>> _streamController =
// StreamController<List<Comment>>.broadcast();
//
//
// final CommentRepositoryProvider =
// AsyncNotifierProvider<CommentRepository1,Future<List<Comment>>> (CommentRepository1.new);
//
// class CommentRepository1 extends AsyncNotifier <List<Comment>> {
//   // A page of each item in a limited amount (20)
//   // For example, if you have 24 total documents,
//   // [ [document1, document2, ..., document 20], [document21, document22, ..., document 24] ]
//   // The list is generated in the following format
//   List<List<Comment>> _comments = [];
//   List<List<Comment>> _comments8 = [];
//   DocumentSnapshot? _lastDocument;
//
//
//
//   Stream<List<Comment>> listenCommentStream() {
//     fetchCommentList();
//     return _streamController.stream;
//   }
//
//   void fetchCommentList([int limit = 20]) {
//     // Limited document requests (20)
//
//     print('fetch comment startted');
//     var query = _firestore
//         .collection('comments')
//         .orderBy('createdAt', descending: true)
//         .limit(limit);
//     List<Comment> results = [];
//
//     // If there is a last document, adjust the query to look up after the last document
//     if (_lastDocument != null) {
//       query = query.startAfterDocument(_lastDocument!);
//     }
//
//     // Specify the page to which the current requesting document belongs
//     var currentRequestIndex = _comments.length;
//     var d = _comments.length;
//     print('currentRequestIndex outside isnotempty $currentRequestIndex');
//     // print('_comments.length $_comments.length');
//     // print('_comments $_comments');
//     var p =_comments8.length ;
//     // listen() Use methods to subscribe to updates
//     query.snapshots().listen((event) {
//       if (event.docs.isNotEmpty) {
//         var comments = event.docs
//             .map((element) => Comment.fromFirestore(element))
//             .toList();
//
//         // Whether the page exists
//         var pageExists = currentRequestIndex < _comments.length;
//
//         print('currentRequestIndex inside if of isnotempty $currentRequestIndex');
//         print('currentRequestIndex d inside if of isnotempty $d');
//         print('currentRequestIndex p inside if of isnotempty $p');
//         // print('_comments.length $_comments.length');
//         int z = _comments.length;
//         print('_comments $z.');
//
//
//         // If the page exists, update the page
//         if (pageExists) {
//           _comments[currentRequestIndex] = comments;
//           int y = comments.length;
//           print('if of page exist executed here is comment $y');
//         }
//         // If the page doesn't exist, add a new page
//         else {
//           print('else of page exist executed $pageExists');//else of page exist executed false executed when we add data first time
//           _comments.add(comments);
//           _comments8.add(comments);
//
//         }
//
//         // Combine multiple pages into one list
//         results = _comments.fold<List<Comment>>(
//             [], (initialValue, pageItems) => initialValue..addAll(pageItems));
//         int x = results.length;
//         print('result $x');
//         // StreamController Broadcast all comments using
//         _streamController.add(results);
//
//
//       }
//
//       // The updated article does not exist, but the article has been modified.
//       if (event.docs.isEmpty && event.docChanges.isNotEmpty) {
//         for (final data in event.docChanges) {
//           //If the index of the modified document is -1 (deleted article)
//           if (data.newIndex == -1) {
//             // Delete the article from the global list
//             results
//                 .removeWhere((element) => element.id == data.doc.data()?['id']);
//             print('delete if called');
//
//           }
//         }
//         // StreamController Broadcast all comments using
//         _streamController.add(results);
//       }
//
//       // Specify the last document
//       if (results.isNotEmpty && currentRequestIndex == _comments.length - 1) {
//         _lastDocument = event.docs.last;
//         print('last doc called');
//       }
//     });
//   }
//
//   // Load the total number of documents
//   Future<int> commentTotalCount() async {
//     AggregateQuerySnapshot query = await _firestore
//         .collection('comments')
//         .orderBy('createdAt', descending: true)
//         .count()
//         .get();
//     return query.count;
//   }
//
//   @override
//   Future<List<Comment>> build() {
//     // TODO: implement build
//     throw UnimplementedError();
//   }
// }






///version 1 olny async notifier above we are trying for pagination.
///
// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:streamfirestorepagination/pages/controller/home_controller.dart';
// import 'package:streamfirestorepagination/pages/widgets/comment_list_item.dart';
// import 'package:streamfirestorepagination/pages/widgets/comment_shimmer.dart';
// import 'dart:async';
// import 'dart:async';
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:streamfirestorepagination/model/comment.dart';
//
// class MyHomePage extends ConsumerStatefulWidget {
//   const MyHomePage({super.key, required this.title});
//
//   final String title;
//
//   @override
//   ConsumerState<MyHomePage> createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends ConsumerState<MyHomePage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: ref.watch(provider).when(
//           data: (List<Comment> a) => ListView.builder(
//               cacheExtent: 88888,
//               itemCount: a.length,
//               itemBuilder: (context, index) {
//                 return Center(
//                   child: Text(
//                     a[index].text + a[index].title + a[index].createdAt.toString(),
//                     style: const TextStyle(fontSize: 30),
//                   ),
//                 );
//               }),
//           error: (error, stack) => SingleChildScrollView(
//             child: Column(
//               children: [
//                 Text(error.toString()),
//                 // Text(stack.toString()),
//               ],
//             ),
//           ),
//           loading: () => const Center(child: CircularProgressIndicator())),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           ref.read(provider.notifier).doSomethingaddtoasyncdata() ;
//         },
//         child: const Icon(Icons.play_circle),
//       ),
//     );
//   }
// }
//
// final chatProvider = StreamProvider<List<Comment>>((ref) async* {
//   // Connect to an API using sockets, and decode the output
//
//
//   // ref.refresh(chatProvider); cant be done;
//
//   var query = _firestore.collection('comments').orderBy('createdAt', descending: true).limit(20);
//   List<Comment> comments = [];
//   bool updown = true;
//   // var currentRequestIndex = _comments.length;
//   query.snapshots().listen(
//           (event) {
//         if (event.docs.isNotEmpty) {
//           var comments1 = event.docs.map((element) => Comment.fromFirestore(element)).toList();
//           // _comments.add(comments);
//           comments = comments1;
//           if(updown == false){
//             /// ref.refresh(chatProvider); cant be done; /// we cant make function or update the value.
//           }
//         }
//       });
//   await Future.delayed(const Duration(seconds: 1));
//   yield comments;
// });
//
//
//
//
//
//
//
//
//
// final StreamController<List<Comment>> _streamController = StreamController<List<Comment>>.broadcast();
// DateTime x = DateTime.now();
// Comment c = Comment(title: 'tt', text: 'tt', createdAt: x);
// Comment d = Comment(title: 'ff', text: 'ff', createdAt: x);
// List<Comment> m = [c, d];
// List<Comment> n = [d, d];
//
// final provider = AsyncNotifierProvider<MyNotifier, List<Comment>>(MyNotifier.new);
// final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//
// class MyNotifier extends AsyncNotifier<List<Comment>> {
//   bool onlylisten = true;
//   List<Comment> comments = [];
//   List<List<Comment>> _comments = [];
//
//   @override
//   Future<List<Comment>> build() async {
//     // List<Comment> comments;
//     print(' only listen $onlylisten');
//
//     return aasd();
//
//   }
//
//   Future<List<Comment>> aasd() async {
//     /// Return type has to be Future<List<Comment>> all the other places List<Comment>,
//     onlylisten = false;
//     print(' only listen $onlylisten');
//     var query = _firestore.collection('comments').orderBy('createdAt', descending: true).limit(0);
//
//     var currentRequestIndex = _comments.length;
//     query.snapshots().listen(
//           (event) {
//         if (event.docs.isNotEmpty) {
//           comments = event.docs.map((element) => Comment.fromFirestore(element)).toList();
//           _comments.add(comments);
//           ///yeild commets; this will not work
//           print('listen executed');
//           if (onlylisten == true) {
//             // doSomething();
//             print(' only listen $onlylisten');
//           }
//
//           var pageExists = currentRequestIndex < _comments.length;
//           if (pageExists) {
//             _comments[currentRequestIndex] = comments;
//             int y = comments.length;
//             print('if of page exist executed here is comment $y');
//           }
//           // If the page doesn't exist, add a new page
//           else {
//             print('else of page exist executed $pageExists'); //else of page exist executed false executed when we add data first time
//             _comments.add(comments);
//           }
//         }
//       },
//     );
//
//     print(_comments);
//     await Future.delayed(const Duration(seconds: 1));
//     onlylisten = true;
//     print(' only listen $onlylisten');
//     return comments;
//   }
//
//   /// this update the state just by calling a function state= AsyncData(value to be updated). no need to return in this.
//   doSomething11111() async {
//     state = const AsyncLoading();
//     await Future.delayed(const Duration(seconds: 1));
//     state = AsyncData(comments);
//
//     /// state = AsyncData(n); we can replace by this
//     print(' only listen of do something $onlylisten');
//   }
//
//   /// this update the state just by calling a update. returning is must here
//   doSomething() async {
//     update((data) async {
//       state = const AsyncLoading();
//       await Future.delayed(const Duration(seconds: 1));
//       print(' only listen of do something $onlylisten');
//       print(comments);
//       return comments;
//
//       /// return n; we can replace by this
//     });
//   }
//
//   /// this update the state by refresh.
//   doSomethingonrefresh() async {
//     print(' only listen of do something $onlylisten');
//     state = await ref.refresh(provider);
//   }
//
//   /// This will add/remove its all local not impacted firebase. Comment instance on the async value.
//   doSomethingaddtoasyncdata()  async {
//     print(' only listen of do something $onlylisten');
//     state = AsyncValue.data([c, ...state.value!]);
//
//     await Future.delayed(const Duration(seconds: 5));
//     state = AsyncValue.data(List.from(state.value!)..remove(c));
//
//     await Future.delayed(const Duration(seconds: 5));
//     state = AsyncValue.data(List.from(state.value!)..remove(state.value![0]));
//
//     // state = await ref.refresh(provider);
//   }
//
//
// }
// // @protected
// // Future<State> update(
// //     FutureOr<State> Function(State) cb, {
// //       FutureOr<State> Function(Object err, StackTrace stackTrace)? onError,
// //     }) async {
// //   // TODO cancel on rebuild?
// //
// //   final newState = await future.then(cb, onError: onError);
// //   state = AsyncData<State>(newState);
// //   return newState;
// // }
//
// // class MyHomePage extends ConsumerStatefulWidget {
// //   const MyHomePage({super.key, required this.title});
// //
// //   final String title;
// //
// //   @override
// //   ConsumerState<MyHomePage> createState() => _MyHomePageState();
// // }
// //
// // class _MyHomePageState extends ConsumerState<MyHomePage> {
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       body: ref.watch(provider).when(
// //           data: (List<Comment> a) => ListView.builder(
// //               cacheExtent: 88888,
// //               itemCount: a.length,
// //
// //               itemBuilder: (context, index) {
// //
// //                   return    Center(
// //                       child: Text(
// //                         a[index].text  + a[index].title + a[index].createdAt.toString() ,
// //
// //                         style: const TextStyle(fontSize: 30),
// //                       ),);
// //                 }
// //                 ),
// //
// //
// //
// //
// //
// //
// //           error: (error, stack) => Text(error.toString()),
// //           loading: () => const Center(child: CircularProgressIndicator())),
// //       floatingActionButton: FloatingActionButton(
// //         onPressed: () {
// //           ref.read(provider.notifier).doSomething();
// //         },
// //         child: const Icon(Icons.play_circle),
// //       ),
// //     );
// //   }
// // }
// //
// //
// // final StreamController<List<Comment>> _streamController =
// // StreamController<List<Comment>>.broadcast();
// // DateTime  x=DateTime.now();
// // Comment c = Comment(title: 'tt', text: 'tt', createdAt: x) ;
// // Comment d = Comment(title: 'ff', text: 'ff', createdAt: x) ;
// // List<Comment> m = [c,d];
// // List<Comment> n = [d,d];
// //
// // final provider = AsyncNotifierProvider<MyNotifier, List<Comment>>(MyNotifier.new);
// // final FirebaseFirestore _firestore = FirebaseFirestore.instance;
// // class MyNotifier extends AsyncNotifier<List<Comment>> {
// //   List<Comment> comments = [];
// //   @override
// //   Future<List<Comment>> build() async {
// //     // List<Comment> comments;
// //         await _firestore
// //         .collection('comments')
// //         .orderBy('createdAt', descending: true)
// //         .limit(20).get().then((event) {
// //           comments = event.docs
// //               .map((element) => Comment.fromFirestore(element))
// //               .toList();
// //           print(comments);
// //         });
// //         // query.(event) {
// //         //  print('listen executed');
// //         //
// //         // comments = event.docs
// //         //     .map((element) => Comment.fromFirestore(element))
// //         //     .toList();
// //         //  print(comments);
// //         //  // return comments;
// //
// //         print(comments);
// //         return comments;
// //   }
// //
// //   doSomething() async {
// //     update((data) async {
// //       state = const AsyncLoading();
// //       await Future.delayed(const Duration(seconds: 1));
// //      print(comments);
// //       return comments;
// //     });
// //   }
// // }
// //
// //
//
// //
// //
// // class MyHomePage extends ConsumerStatefulWidget {
// //   const MyHomePage({super.key, required this.title});
// //
// //   final String title;
// //
// //   @override
// //   ConsumerState<MyHomePage> createState() => _MyHomePageState();
// // }
// //
// // class _MyHomePageState extends ConsumerState<MyHomePage> {
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       body: ref.watch(provider).when(
// //           data: (Comment a) =>  Center(
// //
// //               child: Text(
// //                a.text  + a.title + a.createdAt.toString() ,
// //
// //                 style: const TextStyle(fontSize: 30),
// //               )),
// //           error: (error, stack) => Text(error.toString()),
// //           loading: () => const Center(child: CircularProgressIndicator())),
// //       floatingActionButton: FloatingActionButton(
// //         onPressed: () {
// //           ref.read(provider.notifier).doSomething();
// //         },
// //         child: const Icon(Icons.play_circle),
// //       ),
// //     );
// //   }
// // }
// // DateTime  x=DateTime.now();
// // Comment c = Comment(title: 'tt', text: 'tt', createdAt: x) ;
// // Comment d = Comment(title: 'ff', text: 'ff', createdAt: x) ;
// // final provider = AsyncNotifierProvider<MyNotifier, Comment>(MyNotifier.new);
// //
// // class MyNotifier extends AsyncNotifier<Comment> {
// //   @override
// //   Future<Comment> build() async {
// //
// //     await Future.delayed(const Duration(seconds: 1));
// //     // List<int> a = [1,2,2];
// //     return c;
// //   }
// //
// //   doSomething() async {
// //     update((data) async {
// //       state = const AsyncLoading();
// //       await Future.delayed(const Duration(seconds: 1));
// //       return d;
// //     });
// //   }
// // }
//
// // import 'package:flutter/material.dart';
// // import 'package:flutter/rendering.dart';
// // import 'package:flutter_riverpod/flutter_riverpod.dart';
// // import 'package:streamfirestorepagination/pages/controller/home_controller.dart';
// // import 'package:streamfirestorepagination/pages/widgets/comment_list_item.dart';
// // import 'package:streamfirestorepagination/pages/widgets/comment_shimmer.dart';
// // import 'dart:async';
// //
// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:streamfirestorepagination/model/comment.dart';
// //
// // class asyncnotifierriverpod extends ConsumerWidget {
// //   const asyncnotifierriverpod({Key? key}) : super(key: key);
// //
// //   @override
// //   Widget build(BuildContext context, WidgetRef ref) {
// //     final state = ref.watch(commentProvider);
// //     final notifier = ref.watch(commentProvider.notifier);
// //     return state.when(
// //       data: (data) => ListView.builder(
// //         cacheExtent: 88888,
// //         controller: notifier.controller,
// //         itemCount:
// //         data.length < notifier.totalCount ? data.length + 1 : data.length,
// //         itemBuilder: (context, index) {
// //           if (index != data.length) {
// //             return CommentListItem(comment: data[index]);
// //           } else {
// //             return Center(
// //               child: Padding(
// //                 padding: const EdgeInsets.symmetric(vertical: 20.0),
// //                 child: CircularProgressIndicator(),
// //               ),
// //             );
// //           }
// //         },
// //       ),
// //       loading: () => CommentShimmer(),
// //       error: (error, stackTrace) => Center(
// //         child: Text('error'),
// //       ),
// //     );
// //   }
// // }
// //
// //
// //
// //
// //
// // final FirebaseFirestore _firestore = FirebaseFirestore.instance;
// // final StreamController<List<Comment>> _streamController =
// // StreamController<List<Comment>>.broadcast();
// //
// //
// // final CommentRepositoryProvider =
// // AsyncNotifierProvider<CommentRepository1,Future<List<Comment>>> (CommentRepository1.new);
// //
// // class CommentRepository1 extends AsyncNotifier <List<Comment>> {
// //   // A page of each item in a limited amount (20)
// //   // For example, if you have 24 total documents,
// //   // [ [document1, document2, ..., document 20], [document21, document22, ..., document 24] ]
// //   // The list is generated in the following format
// //   List<List<Comment>> _comments = [];
// //   List<List<Comment>> _comments8 = [];
// //   DocumentSnapshot? _lastDocument;
// //
// //
// //
// //   Stream<List<Comment>> listenCommentStream() {
// //     fetchCommentList();
// //     return _streamController.stream;
// //   }
// //
// //   void fetchCommentList([int limit = 20]) {
// //     // Limited document requests (20)
// //
// //     print('fetch comment startted');
// //     var query = _firestore
// //         .collection('comments')
// //         .orderBy('createdAt', descending: true)
// //         .limit(limit);
// //     List<Comment> results = [];
// //
// //     // If there is a last document, adjust the query to look up after the last document
// //     if (_lastDocument != null) {
// //       query = query.startAfterDocument(_lastDocument!);
// //     }
// //
// //     // Specify the page to which the current requesting document belongs
// //     var currentRequestIndex = _comments.length;
// //     var d = _comments.length;
// //     print('currentRequestIndex outside isnotempty $currentRequestIndex');
// //     // print('_comments.length $_comments.length');
// //     // print('_comments $_comments');
// //     var p =_comments8.length ;
// //     // listen() Use methods to subscribe to updates
// //     query.snapshots().listen((event) {
// //       if (event.docs.isNotEmpty) {
// //         var comments = event.docs
// //             .map((element) => Comment.fromFirestore(element))
// //             .toList();
// //
// //         // Whether the page exists
// //         var pageExists = currentRequestIndex < _comments.length;
// //
// //         print('currentRequestIndex inside if of isnotempty $currentRequestIndex');
// //         print('currentRequestIndex d inside if of isnotempty $d');
// //         print('currentRequestIndex p inside if of isnotempty $p');
// //         // print('_comments.length $_comments.length');
// //         int z = _comments.length;
// //         print('_comments $z.');
// //
// //
// //         // If the page exists, update the page
// //         if (pageExists) {
// //           _comments[currentRequestIndex] = comments;
// //           int y = comments.length;
// //           print('if of page exist executed here is comment $y');
// //         }
// //         // If the page doesn't exist, add a new page
// //         else {
// //           print('else of page exist executed $pageExists');//else of page exist executed false executed when we add data first time
// //           _comments.add(comments);
// //           _comments8.add(comments);
// //
// //         }
// //
// //         // Combine multiple pages into one list
// //         results = _comments.fold<List<Comment>>(
// //             [], (initialValue, pageItems) => initialValue..addAll(pageItems));
// //         int x = results.length;
// //         print('result $x');
// //         // StreamController Broadcast all comments using
// //         _streamController.add(results);
// //
// //
// //       }
// //
// //       // The updated article does not exist, but the article has been modified.
// //       if (event.docs.isEmpty && event.docChanges.isNotEmpty) {
// //         for (final data in event.docChanges) {
// //           //If the index of the modified document is -1 (deleted article)
// //           if (data.newIndex == -1) {
// //             // Delete the article from the global list
// //             results
// //                 .removeWhere((element) => element.id == data.doc.data()?['id']);
// //             print('delete if called');
// //
// //           }
// //         }
// //         // StreamController Broadcast all comments using
// //         _streamController.add(results);
// //       }
// //
// //       // Specify the last document
// //       if (results.isNotEmpty && currentRequestIndex == _comments.length - 1) {
// //         _lastDocument = event.docs.last;
// //         print('last doc called');
// //       }
// //     });
// //   }
// //
// //   // Load the total number of documents
// //   Future<int> commentTotalCount() async {
// //     AggregateQuerySnapshot query = await _firestore
// //         .collection('comments')
// //         .orderBy('createdAt', descending: true)
// //         .count()
// //         .get();
// //     return query.count;
// //   }
// //
// //   @override
// //   Future<List<Comment>> build() {
// //     // TODO: implement build
// //     throw UnimplementedError();
// //   }
// // }
