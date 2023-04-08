import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:streamfirestorepagination/model/comment.dart';
import 'package:streamfirestorepagination/repositories/comment_repository.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

final commentProvider =
    StateNotifierProvider<CommentNotifier, AsyncValue<List<Comment>>>(
        (ref) => CommentNotifier(ref: ref));

class CommentNotifier extends StateNotifier<AsyncValue<List<Comment>>> {
  CommentNotifier({required this.ref}) : super(AsyncLoading()) {
    _fetchFirestoreData();
    controller.addListener(() => _scrollListeners());
  }

  List<String> username =['Foo','Bar','Bob','Joo','Mart'];

  List<String> photostring = ['https://images.pexels.com/photos/1612353/pexels-photo-1612353.jpeg','https://images.pexels.com/photos/572897/pexels-photo-572897.jpeg',
  'https://images.pexels.com/photos/8821918/pexels-photo-8821918.jpeg',
 'https://images.pexels.com/photos/1612353/pexels-photo-1612353.jpeg',
 'https://images.pexels.com/photos/247431/pexels-photo-247431.jpeg',
  'https://images.pexels.com/photos/709552/pexels-photo-709552.jpeg',
  'https://images.pexels.com/photos/4418939/pexels-photo-4418939.jpeg?',
  'https://images.pexels.com/photos/2387873/pexels-photo-2387873.jpeg?',
  'https://images.pexels.com/photos/1367192/pexels-photo-1367192.jpeg?',
  'https://images.pexels.com/photos/15286/pexels-photo.jpg?'];


  final ScrollController controller = ScrollController();
  final CommentRepository _repository = CommentRepository();

  final Ref ref;

  bool _isLoading = false;
  bool uploadonce = true;
  int totalCount = 0;
  int i = 0;
  int j=0;
  _fetchFirestoreData() async {
    // If it's loading, return
print(photostring[0]);
 if (uploadonce ==true) { var collection = FirebaseFirestore.instance.collection('comments');
    var querySnapshots = await collection.get();
    for (var doc in querySnapshots.docs) {

      await doc.reference.update({
        'title': username[j],

      });

        await doc.reference.update({
          'text': photostring[i],

        });

      if(i==9){i=0;}
      if(j==4){j=0;}
      i++;
      j++;
    }
 uploadonce = false;
 }

    if (_isLoading) return;
    _isLoading = true;

    // Firestore Load the total number of documents
    totalCount = await _repository.commentTotalCount();
    if (totalCount == 0) {
      // If the entire document is empty, specify AsyncValue as an empty list
      // If you do not specify an empty list, it remains AsyncLoading
      state = AsyncValue.data([]);
    }

    // Firestore Document List Stream
    _repository.listenCommentStream().listen((event) async {
      totalCount = await _repository.commentTotalCount();
      state = AsyncValue.data(event);
      // print('controller called listencommentstream');
    });

    // When the operation is finished, specify a state that is not loading
    _isLoading = false;
  }

  _scrollListeners() async {
    // Whether the scroll has gone beyond the middle of the entire range.
    final reachMaxExtent =
        controller.offset >= controller.position.maxScrollExtent - 20.0;
    // Whether the scroll does not go beyond the full range and is not at the top.
    final outOfRange =
        !controller.position.outOfRange && controller.position.pixels != 0;
    if (reachMaxExtent && outOfRange) {
      // Firestore Load the next list
      await _fetchFirestoreData();
    }
  }

  addComment(Comment comment) async {
    await _firestore.collection('comments').add(comment.toJson());
    print('aadd executed');
  }

  removeComment(String id) async {
    await _firestore.collection('comments').doc(id).delete();
  }
}

final titleProvider =
    StateNotifierProvider<TitleNotifier, String>((ref) => TitleNotifier());

class TitleNotifier extends StateNotifier<String> {
  TitleNotifier() : super('');

  set value(String text) => state = text; // value and text are just name can be any word , ///state can be used directly in place of value in comment dialog
}

final textProvider =
    StateNotifierProvider<TextNotifier, String>((ref) => TextNotifier());

class TextNotifier extends StateNotifier<String> {
  TextNotifier() : super('');

  set value(String text) => state = text;  // value and text are just name can be any word ,

}
