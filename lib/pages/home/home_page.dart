import 'package:flutter/material.dart';
import 'package:streamfirestorepagination/pages/widgets/comment_dialog.dart';
import 'package:streamfirestorepagination/pages/widgets/comment_list.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Photos'), backgroundColor: Colors.black38, actions: [
        IconButton(
          onPressed: () => showDialog(
            context: context,
            builder: (context) => CommentDialog(),
          ),
          icon: Icon(Icons.add),
        )
      ]),
      body: CommentList(),
    );
  }
}
