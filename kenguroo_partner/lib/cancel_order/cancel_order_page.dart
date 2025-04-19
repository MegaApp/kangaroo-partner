import 'package:flutter/material.dart';
import 'package:kenguroo_partner/models/models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kenguroo_partner/repositories/api_repository.dart';
import 'package:kenguroo_partner/cancel_order/cancel_order.dart';

class CancelOrderPage extends StatelessWidget {
  final ApiRepository apiRepository;
  final Order order;

  CancelOrderPage({super.key, required this.apiRepository, required this.order});

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
          return CancelOrderBloc(
            apiRepository: apiRepository,
          );
        },
        child: CancelOrderForm(order: order),
      ),
    );
  }
}
