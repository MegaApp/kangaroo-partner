import 'package:flutter/material.dart';
import 'package:kenguroo_partner/authentication/authentication.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kenguroo_partner/repositories/api_repository.dart';

import 'package:kenguroo_partner/support/support.dart';

class SupportPage extends StatelessWidget {
  final ApiRepository apiRepository;

  SupportPage({Key key, @required this.apiRepository})
      : assert(apiRepository != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Служба поддержки')),
      body: BlocProvider(
        create: (context) {
          return SupportBloc(
              apiRepository: apiRepository);
        },
        child: SupportForm(),
      ),
    );
  }
}
