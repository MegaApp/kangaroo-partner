import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kenguroo_partner/extentions.dart';
import 'package:kenguroo_partner/create_questions/create_questions.dart';

class CreateQuestionsForm extends StatefulWidget {
  @override
  State<CreateQuestionsForm> createState() => _CreateQuestionsFormState();
}

class _CreateQuestionsFormState extends State<CreateQuestionsForm> {
  final _titleController = TextEditingController();
  final _questionsController = TextEditingController();

  _cancelBtnClicked() => () {
        BlocProvider.of<CreateQuestionsBloc>(context).add(
            CreateQuestionsBtnPressed(
                title: _titleController.text,
                questions: _questionsController.text));
      };

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateQuestionsBloc, CreateQuestionsState>(
      listener: (context, state) {
        if (state is CreateQuestionsFailure) {
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text('${state.error}'),
              backgroundColor: Colors.red,
            ),
          );
        }

        if (state is CreateQuestionsApproved) {
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        }
      },
      child: BlocBuilder<CreateQuestionsBloc, CreateQuestionsState>(
        builder: (context, state) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Stack(
                children: <Widget>[
                  (state is CreateQuestionsLoading)
                      ? Center(child: CircularProgressIndicator())
                      : Container(),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Padding(padding: EdgeInsets.only(top: 32)),
                          Text(
                            'Тема вопроса',
                            style: TextStyle(
                                fontSize: 13,
                                color: HexColor.fromHex('#CCCCCC')),
                          ),
                          TextField(
                            controller: _titleController,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Без названия',
                                hintStyle: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w300,
                                    color: HexColor.fromHex('#222831'))),
                          ),
                          const Divider(height: 1),
                          const Padding(padding: EdgeInsets.only(top: 16)),
                          Text(
                            'Текст вопроса',
                            style: TextStyle(
                                fontSize: 13,
                                color: HexColor.fromHex('#CCCCCC')),
                          ),
                          TextField(
                            controller: _questionsController,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Введите текст вопроса',
                                hintStyle: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w300,
                                    color: HexColor.fromHex('#222831'))),
                          ),
                          const Divider(height: 1),
                        ],
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 56, right: 56, left: 56),
                        child: SizedBox(
                          height: 56,
                          width: double.infinity,
                          child: FlatButton(
                            shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(40.0),
                                side: BorderSide(
                                    color: Theme.of(context).accentColor)),
                            color: Theme.of(context).accentColor,
                            textColor: Colors.white,
                            onPressed: _cancelBtnClicked(),
                            child: Text(
                              'Отправить',
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
