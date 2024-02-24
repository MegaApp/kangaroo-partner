import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kenguroo_partner/repositories/api_repository.dart';

import 'comments_bloc.dart';
import 'comments_form.dart';

class CommentPage extends StatelessWidget {
  final ApiRepository apiRepository;

  CommentPage({super.key, required this.apiRepository});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('')),
      body: BlocProvider(
        create: (context) {
          return CommentBloc(
              apiRepository: apiRepository);
        },
        child: CommentForm(),
      ),
    );
  }
}
