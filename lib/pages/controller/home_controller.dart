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

  final ScrollController controller = ScrollController();
  final CommentRepository _repository = CommentRepository();

  final Ref ref;

  bool _isLoading = false;
  int totalCount = 0;

  _fetchFirestoreData() async {
    // 로딩 중인 경우, return

    // var collection = FirebaseFirestore.instance.collection('comments');
    // var querySnapshots = await collection.get();
    // for (var doc in querySnapshots.docs) {
    //   await doc.reference.update({
    //     'text': 'https://www.pixelstalk.net/wp-content/uploads/2016/07/Wallpapers-pexels-photo.jpg',
    //   });
    // }

    if (_isLoading) return;
    _isLoading = true;

    // Firestore Load the total number of documents
    totalCount = await _repository.commentTotalCount();
    if (totalCount == 0) {
      // 전체 문서가 비어있으면 AsyncValue 빈 리스트로 지정
      // 빈 리스트로 지정하지 않으면 계속 AsyncLoading인 상태가 유지
      state = AsyncValue.data([]);
    }

    // Firestore 문서 목록 스트림
    _repository.listenCommentStream().listen((event) async {
      totalCount = await _repository.commentTotalCount();
      state = AsyncValue.data(event);
      // print('controller called listencommentstream');
    });

    // 작업이 끝나면 로딩 중이 아닌 상태로 지정
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
  }

  removeComment(String id) async {
    await _firestore.collection('comments').doc(id).delete();
  }
}

final titleProvider =
    StateNotifierProvider<TitleNotifier, String>((ref) => TitleNotifier());

class TitleNotifier extends StateNotifier<String> {
  TitleNotifier() : super('');

  set value(String text) => state = text;
}

final textProvider =
    StateNotifierProvider<TextNotifier, String>((ref) => TextNotifier());

class TextNotifier extends StateNotifier<String> {
  TextNotifier() : super('');

  set value(String text) => state = text;
}
