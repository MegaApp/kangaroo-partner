import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kenguroo_partner/create_questions/create_questions.dart';
import 'package:kenguroo_partner/extentions.dart';
import 'package:kenguroo_partner/models/models.dart';
import 'package:kenguroo_partner/repositories/repositories.dart';
import 'package:kenguroo_partner/support/support.dart';

class SupportForm extends StatefulWidget {
  SupportForm({super.key});

  @override
  State<SupportForm> createState() => _SupportFormState();
}

class _SupportFormState extends State<SupportForm> {
  List<Question> questions = List.empty(growable: true);

  void _onTapItem(BuildContext context, Question question) {}

  _listViewWidget() {
    return ListView.separated(
      separatorBuilder: (context, index) => Divider(),
      shrinkWrap: true,
      itemCount: questions.length,
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, position) {
        Question question = questions[position];
        return GestureDetector(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  question.title,
                  style: TextStyle(
                      fontSize: 15, color: HexColor.fromHex('#0C270F')),
                ),
                const Padding(padding: const EdgeInsets.only(top: 8)),
                Text(
                  question.question,
                  style: TextStyle(
                      fontSize: 15, color: HexColor.fromHex('#D7D7D7')),
                )
              ],
            ),
            onTap: () => _onTapItem(context, question));
      },
    );
  }

  _rootWidget(SupportState state) {
    if (state is SupportLoading)
      return Center(child: CircularProgressIndicator());
    if (state is SupportDidGetQuestions) if (state.questions.length > 0)
      return _listViewWidget();
    if (state is SupportInitial)
      BlocProvider.of<SupportBloc>(context).add(SupportGetQuestions());
    return Center(
        child: Text(
      'Пусто',
      style: TextStyle(fontSize: 25, color: Colors.grey),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SupportBloc, SupportState>(
      listener: (context, state) {
        if (state is SupportFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${state.error}'),
              backgroundColor: Colors.red,
            ),
          );
        }

        if (state is SupportDidGetQuestions) {
          questions = state.questions;
        }
      },
      child: BlocBuilder<SupportBloc, SupportState>(
        builder: (context, state) {
          return Scaffold(
            body: SafeArea(
              child: Stack(children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'Ваши текущие вопросы',
                    style: TextStyle(
                        color: HexColor.fromHex('#000000'),
                        fontSize: 21,
                        fontWeight: FontWeight.bold),
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
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                ApiRepository repository =
                    BlocProvider.of<SupportBloc>(context).apiRepository;
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => CreateQuestionsPage(
                          apiRepository: repository,
                        )));
              },
              child: Icon(
                Icons.edit,
                color: Colors.white,
              ),
              backgroundColor: Theme.of(context).hintColor,
            ),
          );
        },
      ),
    );
  }
}
