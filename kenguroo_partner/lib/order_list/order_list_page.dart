import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kenguroo_partner/repositories/api_repository.dart';

import 'package:kenguroo_partner/order_list/order_list.dart';

import '../extentions.dart';

class OrderListPage extends StatelessWidget {
  final ApiRepository userRepository;
  final String date;

  OrderListPage({Key key, @required this.userRepository, @required this.date})
      : assert(userRepository != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$date'),
      ),
      backgroundColor: HexColor.fromHex('#F3F6F9'),
      body: BlocProvider(
        create: (context) {
          return OrderListBloc(
            apiRepository: userRepository,
          );
        },
        child: OrderListForm(date: date),
      ),
    );
  }
}
