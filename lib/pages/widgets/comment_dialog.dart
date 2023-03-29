import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:streamfirestorepagination/model/comment.dart';
import 'package:streamfirestorepagination/pages/controller/home_controller.dart';

class CommentDialog extends ConsumerStatefulWidget {
  const CommentDialog({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CommentDialogState();
}

class _CommentDialogState extends ConsumerState<CommentDialog> {
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textState = ref.watch(textProvider);
    final textNotifier = ref.watch(textProvider.notifier);

    final titleState = ref.watch(titleProvider);
    final titleNotifier = ref.watch(titleProvider.notifier);

    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Writing', style: Theme.of(context).textTheme.titleLarge),
            SizedBox(height: 12.0),
            TextField(
              controller: _textController,
              onChanged: (value) => textNotifier.value = value, ///state can be used directly in place of value
              decoration: InputDecoration(
                label: Text('Text'),
              ),
            ),
            TextField(
              controller: _titleController,
              onChanged: (value) => titleNotifier.value = value,
              decoration: InputDecoration(
                label: Text('Title'),
              ),
            ),
            SizedBox(height: 12.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: textState.isNotEmpty && titleState.isNotEmpty
                      ? () {
                          var comment = Comment(
                            text: textState,
                            title: titleState,
                            createdAt: DateTime.now(),
                          );
                          ref.watch(commentProvider.notifier).addComment(comment);
                          Navigator.pop(context);
                        }
                      : null,
                  child: Text('Write'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
