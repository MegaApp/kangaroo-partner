import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kenguroo_partner/extentions.dart';
import 'package:kenguroo_partner/models/comment.dart';
import 'package:kenguroo_partner/models/models.dart';

import 'comments.dart';

class CommentForm extends StatefulWidget {
  CommentForm({super.key});

  @override
  State<CommentForm> createState() => _CommentFormState();
}

class _CommentFormState extends State<CommentForm> {
  List<Comment> questions = List.empty(growable: true);

  void _onTapItem(BuildContext context, Comment question) {}

  _listViewWidget() {
    return ListView.separated(
      separatorBuilder: (context, index) => Divider(),
      shrinkWrap: true,
      itemCount: questions.length,
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, position) {
        Comment question = questions[position];
        return GestureDetector(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  question.comment,
                  style: TextStyle(fontSize: 15, color: HexColor.fromHex('#0C270F')),
                ),
                const Padding(padding: const EdgeInsets.only(top: 8)),
                Row(children: [
                  Text(
                    '★ ${question.rating}',
                    style: const TextStyle(fontSize: 15, color: Colors.amber, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  Text(
                    question.date,
                    style: TextStyle(fontSize: 15, color: HexColor.fromHex('#D7D7D7')),
                  )
                ],)
              ],
            ),
            onTap: () => _onTapItem(context, question));
      },
    );
  }

  _rootWidget(CommentState state) {
    if (state is CommentLoading) return Center(child: CircularProgressIndicator());
    if (state is CommentDidGetQuestions) if (state.questions.length > 0) return _listViewWidget();
    if (state is CommentInitial) BlocProvider.of<CommentBloc>(context).add(CommentGetQuestions());
    return Center(
        child: Text(
      'Пусто',
      style: TextStyle(fontSize: 25, color: Colors.grey),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CommentBloc, CommentState>(
      listener: (context, state) {
        if (state is CommentFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${state.error}'),
              backgroundColor: Colors.red,
            ),
          );
        }

        if (state is CommentDidGetQuestions) {
          questions = state.questions;
        }
      },
      child: BlocBuilder<CommentBloc, CommentState>(
        builder: (context, state) {
          return Scaffold(
            body: SafeArea(
              child: Stack(children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'Комментарии',
                    style: TextStyle(color: HexColor.fromHex('#000000'), fontSize: 21, fontWeight: FontWeight.bold),
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 59),
                    child: _rootWidget(state),
                  ),
                )
              ]),
            ),
          );
        },
      ),
    );
  }
}
