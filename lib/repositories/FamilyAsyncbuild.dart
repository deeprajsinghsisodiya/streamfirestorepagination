import 'package:flutter/material.dart';

import 'package:flutter/rendering.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:streamfirestorepagination/pages/controller/home_controller.dart';

import 'package:streamfirestorepagination/pages/widgets/comment_list_item.dart';

import 'package:streamfirestorepagination/pages/widgets/comment_shimmer.dart';

import 'dart:async';

import 'dart:async';

import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

/// FamilyAsyncNotifier End^



/// FamilyAsyncNotifier Start All calculation Done inside the build

class FamilyAsyncbuild extends ConsumerStatefulWidget {
  const FamilyAsyncbuild({super.key, required this.title});

  final String title;

  @override
  ConsumerState<FamilyAsyncbuild> createState() => _FamilyAsyncbuildState();
}

class _FamilyAsyncbuildState extends ConsumerState<FamilyAsyncbuild> {
  @override
  Widget build(BuildContext context) {
    int b = 10;
    DateTime x = DateTime.now();
    Commett ddd = Commett(title: 'car', text: 'car', createdAt: x, id: '22');
    return Scaffold(
      body: ref.watch(provider(ddd)).when(
          data: (List<Commett> a) => ListView.builder(
              cacheExtent: 88888,
              itemCount: a.length,
              itemBuilder: (context, index) {
                return Center(
                  child: Text(
                    // a[index].text  +
                    a[index].title,
                    // +
                    // a[index].createdAt.toString() ,

                    style: const TextStyle(fontSize: 30),
                  ),
                );
              }),
          error: (error, stack) => Text(error.toString()),
          loading: () => const Center(child: CircularProgressIndicator())),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ref.read(provider(ddd).notifier).doSomething();
        },
        child: const Icon(Icons.play_circle),
      ),
    );
  }
}

final StreamController<List<Commett>> _streamController = StreamController<List<Commett>>.broadcast();

final provider = AsyncNotifierProviderFamily<MyNotifier, List<Commett>, Commett>(MyNotifier.new);
final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class MyNotifier extends FamilyAsyncNotifier<List<Commett>, Commett> {
  List<Commett> comments = [];
  @override
  Future<List<Commett>> build(arg) async {
    // List<Comment> comments;
    DateTime x = DateTime.now();
    Commett c = Commett(title: 'tt', text: 'tt', createdAt: x, id: '11');
    Commett d = Commett(title: 'ff', text: 'ff', createdAt: x, id: '11');
    List<Commett> m = [c, d];
    List<Commett> n = [d, d];
    Commett xta = arg;
    // await _firestore
    // .collection('comments')
    // .orderBy('createdAt', descending: true)
    // .limit(20).get().then((event) {
    //   comments = event.docs
    //       .map((element) => Comment.fromFirestore(element))
    //       .toList();
    //   print(comments);
    // });
    // query.(event) {
    //  print('listen executed');
    //
    // comments = event.docs
    //     .map((element) => Comment.fromFirestore(element))
    //     .toList();
    //  print(comments);
    //  // return comments;
    n.add(xta);
    print(xta);
    return n;
  }

  doSomething() async {
    update((data) async {
      state = const AsyncLoading();
      await Future.delayed(const Duration(seconds: 1));
      print(comments);
      return comments;
    });
  }
}

                  //Createdclass using quicktype.io  website then added Equitable
                   //without equitable build was called repeatedly

Commett commettFromJson(String str) => Commett.fromJson(json.decode(str));

String commettToJson(Commett data) => json.encode(data.toJson());

class Commett extends Equatable {
  String id;
  String title;
  String text;
  DateTime createdAt;

  Commett({
    required this.id,
    required this.title,
    required this.text,
    required this.createdAt,
  });

  factory Commett.fromJson(Map<String, dynamic> json) => Commett(
        id: json["id"],
        title: json["title"],
        text: json["text"],
        createdAt: DateTime.parse(json["createdAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "text": text,
        "createdAt": createdAt.toIso8601String(),
      };

  @override
  // TODO: implement props
  List<Object> get props => [id];
  // List<Object> get props => [title];
  // List<Object> get props => [text];
  // List<Object> get props => [createdAt];
  // List<Object?> get props => throw UnimplementedError();
}

/// FamilyAsyncNotifier End^