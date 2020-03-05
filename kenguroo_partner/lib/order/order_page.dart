import 'package:flutter/material.dart';
import 'package:kenguroo_partner/models/models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kenguroo_partner/repositories/api_repository.dart';

import 'package:kenguroo_partner/order/order.dart';

class OrderPage extends StatelessWidget {
  final ApiRepository apiRepository;
  final Order order;

  OrderPage({Key key, @required this.apiRepository, @required this.order})
      : assert(apiRepository != null, order != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${order.number}')),
      body: BlocProvider(
        create: (context) {
          return OrderBloc(
            apiRepository: apiRepository,
          );
        },
        child: OrderForm(order: order),
      ),
    );
  }
}
