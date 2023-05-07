
import 'dart:convert';

import 'package:flutter/material.dart';
import 'modeluser.dart';
import 'package:http/http.dart' as http;

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

class displayfromapi extends ConsumerStatefulWidget {
  const displayfromapi({super.key,});

  @override
  ConsumerState<displayfromapi> createState() => _displayfromapiState();
}

List<User> userDetails = [];


class _displayfromapiState extends ConsumerState<displayfromapi> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ref.watch(provider).when(
          data: (List<User> a) => ListView.builder(
              controller: controller,
              cacheExtent: 88888,
              itemCount:  a.length ,
              itemBuilder: (context, index) {
                return Center(
                  child:Column(
                      children: [
                        Text(
                          'Id : ${userDetails[index].id.toString()}',
                        ),
                        Text(
                          'Name : ${userDetails[index].name.toString()}',
                        ),
                        Text(
                          'Username : ${userDetails[index].username.toString()}',
                        ),
                        Text(
                          'Email : ${userDetails[index].email.toString()}',
                        ),
                        Text(
                          'Phone : ${userDetails[index].phone.toString()}',
                        ),
                        Text(
                          'Address : ${userDetails[index].address.street.toString()}',
                        ),
                        Text(
                          ' ${userDetails[index].address.city.toString()}',
                        ),
                        Text(
                          'Company : ${userDetails[index].company.name.toString()}',
                        ),
                        Text(
                          'Website : ${userDetails[index].website.toString()}',
                        ),
                        Divider(),
                      ],
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
          // ref.read(provider.notifier).doSomethingaddtoasyncdata() ;
        },
        child: const Icon(Icons.play_circle),
      ),
    );
  }
}





DateTime x = DateTime.now();
Comment c = Comment(title: 'tt', text: 'tt', createdAt: x);
Comment d = Comment(title: 'ff', text: 'ff', createdAt: x);
int totalCount = 0;
List<Comment> m = [c, d];
List<Comment> n = [d, d];

final provider = AsyncNotifierProvider<MyNotifier, List<User>>(MyNotifier.new);
final FirebaseFirestore _firestore = FirebaseFirestore.instance;
class MyNotifier extends AsyncNotifier<List<User>> {
  bool onlylisten = true;

  DocumentSnapshot? _lastDocument;
  List<Comment> results1 = [];
  List<Comment> comments = [];
  List<List<Comment>> _comments = [];
  @override
  Future<List<User>> build() async {
    return getData();
  }


  Future<List<User>> getData() async {
    final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/users'));
    var data = jsonDecode(response.body.toString());
    if (response.statusCode == 200) {
      for (Map<String, dynamic> index in data) {
        userDetails.add(User.fromJson(index));
      }
      return userDetails;
    } else {
      return userDetails;
    }
  }
}





  //
  //
  // /// this update the state just by calling a function state= AsyncData(value to be updated). no need to return in this.
  // doSomething11111() async {
  //   state = const AsyncLoading();
  //   await Future.delayed(const Duration(seconds: 1));
  //   state = AsyncData(comments);
  //
  //   /// state = AsyncData(n); we can replace by this
  //   print(' only listen of do something $onlylisten');
  // }
  //
  // /// this update the state just by calling a update. returning is must here
  // doSomething() async {
  //   update((data) async {
  //     state = const AsyncLoading();
  //     await Future.delayed(const Duration(seconds: 1));
  //     print(' only listen of do something $onlylisten');
  //     print(comments);
  //     return results1;
  //
  //     /// return n; we can replace by this
  //   });
  // }
  //
  // /// this update the state by refresh.
  // doSomethingonrefresh() async {
  //   print(' only listen of do something $onlylisten');
  //   state = await ref.refresh(provider);
  // }
  //
  // /// This will add/remove its all local not impacted firebase. Comment instance on the async value.
  // doSomethingaddtoasyncdata()  async {
  //   print(' only listen of do something $onlylisten');
  //   state = AsyncValue.data([c, ...state.value!]);
  //
  //   await Future.delayed(const Duration(seconds: 5));
  //   state = AsyncValue.data(List.from(state.value!)..remove(c));
  //
  //   await Future.delayed(const Duration(seconds: 5));
  //   state = AsyncValue.data(List.from(state.value!)..remove(state.value![0]));
  //
  //   // state = await ref.refresh(provider);
  // }
// }


// class displayfromapi extends StatefulWidget {
//   const displayfromapi({Key? key}) : super(key: key);
//
//   @override
//   State<displayfromapi> createState() => _displayfromapiState();
// }
//
// List<User> userDetails = [];
//
// class _displayfromapiState extends State<displayfromapi> {
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//         future: getData(),
//         builder: (context, snapshopt) {
//           if (snapshopt.hasData) {
//             return ListView.builder(
//                 itemCount: userDetails.length,
//                 itemBuilder: (context, index) {
//                   return Container(
//                     height: 200,
//                     color: Colors.white10,
//                     child: Column(
//                       children: [
//                         Text(
//                           'Id : ${userDetails[index].id.toString()}',
//                         ),
//                         Text(
//                           'Name : ${userDetails[index].name.toString()}',
//                         ),
//                         Text(
//                           'Username : ${userDetails[index].username.toString()}',
//                         ),
//                         Text(
//                           'Email : ${userDetails[index].email.toString()}',
//                         ),
//                         Text(
//                           'Phone : ${userDetails[index].phone.toString()}',
//                         ),
//                         Text(
//                           'Address : ${userDetails[index].address.street.toString()}',
//                         ),
//                         Text(
//                           ' ${userDetails[index].address.city.toString()}',
//                         ),
//                         Text(
//                           'Company : ${userDetails[index].company.name.toString()}',
//                         ),
//                         Text(
//                           'Website : ${userDetails[index].website.toString()}',
//                         ),
//                         Divider(),
//                       ],
//                     ),
//                   );
//                 });
//           } else {
//             return const Center(
//               child: CircularProgressIndicator(),
//             );
//           }
//         });
//   }
//
//   Future<List<User>> getData() async {
//     final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/users'));
//     var data = jsonDecode(response.body.toString());
//     if (response.statusCode == 200) {
//       for (Map<String, dynamic> index in data) {
//         userDetails.add(User.fromJson(index));
//       }
//       return userDetails;
//     } else {
//       return userDetails;
//     }
//   }
// }




// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'modeluser.dart';
// import 'package:http/http.dart' as http;
//
// class displayfromapi extends StatefulWidget {
//   const displayfromapi({Key? key}) : super(key: key);
//
//   @override
//   State<displayfromapi> createState() => _displayfromapiState();
// }
//
// List<User> userDetails = [];
//
// class _displayfromapiState extends State<displayfromapi> {
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//         future: getData(),
//         builder: (context, snapshopt) {
//           if (snapshopt.hasData) {
//             return ListView.builder(
//                 itemCount: userDetails.length,
//                 itemBuilder: (context, index) {
//                   return Container(
//                     height: 200,
//                     color: Colors.white10,
//                     child: Column(
//                       children: [
//                         Text(
//                           'Id : ${userDetails[index].id.toString()}',
//                         ),
//                         Text(
//                           'Name : ${userDetails[index].name.toString()}',
//                         ),
//                         Text(
//                           'Username : ${userDetails[index].username.toString()}',
//                         ),
//                         Text(
//                           'Email : ${userDetails[index].email.toString()}',
//                         ),
//                         Text(
//                           'Phone : ${userDetails[index].phone.toString()}',
//                         ),
//                         Text(
//                           'Address : ${userDetails[index].address.street.toString()}',
//                         ),
//                         Text(
//                           ' ${userDetails[index].address.city.toString()}',
//                         ),
//                         Text(
//                           'Company : ${userDetails[index].company.name.toString()}',
//                         ),
//                         Text(
//                           'Website : ${userDetails[index].website.toString()}',
//                         ),
//                         Divider(),
//                       ],
//                     ),
//                   );
//                 });
//           } else {
//             return const Center(
//               child: CircularProgressIndicator(),
//             );
//           }
//         });
//   }
//
//   Future<List<User>> getData() async {
//     final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/users'));
//     var data = jsonDecode(response.body.toString());
//     if (response.statusCode == 200) {
//       for (Map<String, dynamic> index in data) {
//         userDetails.add(User.fromJson(index));
//       }
//       return userDetails;
//     } else {
//       return userDetails;
//     }
//   }
// }
