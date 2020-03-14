import 'package:flutter/material.dart';
import 'package:kenguroo_partner/models/models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kenguroo_partner/repositories/api_repository.dart';
import 'package:kenguroo_partner/create_questions/create_questions.dart';

class CreateQuestionsPage extends StatelessWidget {
  final ApiRepository apiRepository;

  CreateQuestionsPage({Key key, @required this.apiRepository})
      : assert(apiRepository != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: new IconButton(
            icon: new Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text('Отмена заказа')),
      body: BlocProvider(
        create: (context) {
          return CreateQuestionsBloc(
            apiRepository: apiRepository,
          );
        },
        child: CreateQuestionsForm(),
      ),
    );
  }
}
