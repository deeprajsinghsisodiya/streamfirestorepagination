import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:streamfirestorepagination/model/comment.dart';
import 'package:streamfirestorepagination/pages/controller/home_controller.dart';

class CommentListItem extends ConsumerWidget {
  const CommentListItem({Key? key, required this.comment}) : super(key: key);

  final Comment comment;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.watch(commentProvider.notifier);
    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        color: Colors.red,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Icon(Icons.delete, color: Colors.white),
        ),
      ),
      onDismissed: (direction) => notifier.removeComment(comment.id!),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
        children: [

              Padding(
                padding: const EdgeInsets.all(12.0),
                child: ClipRRect(borderRadius: BorderRadius.circular(8),
                    child: Image.network(comment.text)),
              ),
             Padding(
               padding:  EdgeInsets.fromLTRB( 20.0,  2.0, 0.0, 0.0),
               child: Text(comment.title,style: TextStyle(fontSize:15,fontWeight: FontWeight.bold ),),
             ),

          // ListTile(
          //   // title: Text(comment.text),
          //   subtitle: Text(comment.title),
          // ),
          SizedBox(height: 3,),
          Divider(color: Colors.black12,thickness: 2,),
        ],
      ),
    );
  }
}
