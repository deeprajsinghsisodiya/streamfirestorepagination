import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:streamfirestorepagination/model/comment.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final StreamController<List<Comment>> _streamController =
    StreamController<List<Comment>>.broadcast();

class CommentRepository {
  // A page of each item in a limited amount (20)
  // For example, if you have 24 total documents,
  // [ [document1, document2, ..., document 20], [document21, document22, ..., document 24] ]
  // The list is generated in the following format
  List<List<Comment>> _comments = [];
  List<List<Comment>> _comments8 = [];
  DocumentSnapshot? _lastDocument;



  Stream<List<Comment>> listenCommentStream() {
    fetchCommentList();
    return _streamController.stream;
  }

  void fetchCommentList([int limit = 20]) {
    // Limited document requests (20)

    print('fetch comment startted');
    var query = _firestore
        .collection('comments')
        .orderBy('createdAt', descending: true)
        .limit(limit);
    List<Comment> results = [];

    // If there is a last document, adjust the query to look up after the last document
    if (_lastDocument != null) {
      query = query.startAfterDocument(_lastDocument!);
    }

    // Specify the page to which the current requesting document belongs
    var currentRequestIndex = _comments.length;
    var d = _comments.length;
     print('currentRequestIndex outside isnotempty $currentRequestIndex');
    print('_comments.length $_comments.length');
    print('_comments $_comments');
var p =_comments8.length ;
    // listen() Use methods to subscribe to updates
    query.snapshots().listen((event) {
      if (event.docs.isNotEmpty) {
        var comments = event.docs
            .map((element) => Comment.fromFirestore(element))
            .toList();

        // Whether the page exists
        var pageExists = currentRequestIndex < _comments.length;

        print('currentRequestIndex inside if of isnotempty $currentRequestIndex');
        print('currentRequestIndex d inside if of isnotempty $d');
        print('currentRequestIndex p inside if of isnotempty $p');
        // print('_comments.length $_comments.length');
        int z = _comments.length;
        print('_comments $z.');


        // If the page exists, update the page
        if (pageExists) {
          _comments[currentRequestIndex] = comments;
          int y = comments.length;
          print('if of page exist executed here is comment $y');
        }
        // If the page doesn't exist, add a new page
        else {
          print('else of page exist executed $pageExists');//else of page exist executed false executed when we add data first time
          _comments.add(comments);
          _comments8.add(comments);

        }

        // Combine multiple pages into one list
        results = _comments.fold<List<Comment>>(
            [], (initialValue, pageItems) => initialValue..addAll(pageItems));
        int x = results.length;
        print('result $x');
        // StreamController Broadcast all comments using
        _streamController.add(results);
      }

      // The updated article does not exist, but the article has been modified.
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
        _streamController.add(results);
      }

      // Specify the last document
      if (results.isNotEmpty && currentRequestIndex == _comments.length - 1) {
        _lastDocument = event.docs.last;
        print('last doc called');
      }
    });
  }

  // Load the total number of documents
  Future<int> commentTotalCount() async {
    AggregateQuerySnapshot query = await _firestore
        .collection('comments')
        .orderBy('createdAt', descending: true)
        .count()
        .get();
    return query.count;
  }
}
