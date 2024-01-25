import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kenguroo_partner/order/order.dart';
import 'package:kenguroo_partner/repositories/api_repository.dart';
import 'package:kenguroo_partner/order_list/order_list.dart';
import 'package:kenguroo_partner/models/models.dart';
import '../extentions.dart';

class OrderListForm extends StatefulWidget {
  final String date;

  OrderListForm({super.key, required this.date});

  @override
  State<OrderListForm> createState() => _OrderListFormState();
}

class _OrderListFormState extends State<OrderListForm> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<OrderListBloc, OrderListState>(
      listener: (context, state) {
        if (state is OrderListFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${state.error}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: BlocBuilder<OrderListBloc, OrderListState>(
        builder: (context, state) {
          return SafeArea(child: rootWidget(state));
        },
      ),
    );
  }

  void onTapItem(BuildContext context, Order order) {
    if (order == null) return;
    ApiRepository repository =
        BlocProvider.of<OrderListBloc>(context).apiRepository;
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => OrderPage(
              apiRepository: repository,
              order: order,
            )));
  }

  Widget listViewWidget(List<Order> orders) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: orders.length,
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, position) {
        Order _order = orders[position];
        return GestureDetector(
            child: buildListItem(_order),
            onTap: () => onTapItem(context, _order));
      },
    );
  }

  Widget rootWidget(OrderListState state) {
    if (state is OrderListLoading)
      return Center(child: CircularProgressIndicator());
    if (state is OrderListLoaded) if (state.orders.length > 0)
      return listViewWidget(state.orders);
    if (state is OrderListInitial)
      BlocProvider.of<OrderListBloc>(context)
          .add(OrderListDidSetDate(time: widget.date));
    return emptyView();
  }

  Column emptyView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Image(
          image: AssetImage('assets/ic-plh.png'),
          width: 120,
        ),
        Padding(
          padding: const EdgeInsets.only(right: 80, left: 80, top: 66),
          child: Text(
            'Пока нет результатов. Воспользуйтесь поиском',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 21,
                color: HexColor.fromHex('#E0E0E0'),
                fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }

  Stack buildListItem(Order _order) {
    return Stack(
      children: <Widget>[
        Container(
          margin: EdgeInsets.all(4),
          decoration: new BoxDecoration(
              color: Colors.white,
              borderRadius: new BorderRadius.all(Radius.circular(18.0))),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          '№ заказа',
                          style: TextStyle(
                              color: HexColor.fromHex('#869FB1'), fontSize: 13),
                        ),
                        const Padding(padding: EdgeInsets.all(8)),
                        Text(
                          '${_order.number}',
                          style: TextStyle(
                              color: HexColor.fromHex('#0C270F'),
                              fontSize: 21,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Блюда',
                            style: TextStyle(
                                color: HexColor.fromHex('#869FB1'),
                                fontSize: 13)),
                        const Padding(padding: EdgeInsets.all(8)),
                        Text('${_order.itemsCount}',
                            style: TextStyle(
                                color: HexColor.fromHex('#0C270F'),
                                fontSize: 21,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Время выдачи',
                            style: TextStyle(
                                color: HexColor.fromHex('#869FB1'),
                                fontSize: 13)),
                        const Padding(padding: EdgeInsets.all(8)),
                        Text(_order.orderedAt,
                            style: TextStyle(
                                color: HexColor.fromHex('#0C270F'),
                                fontSize: 21,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 24, right: 16, left: 16),
                  child: Stack(
                    alignment: AlignmentDirectional.centerEnd,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(right: 40),
                        child: Container(
                          width: double.infinity,
                          height: 1,
                          color: HexColor.fromHex('#EEEEEE'),
                        ),
                      ),
                      Stack(
                        alignment: AlignmentDirectional.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(left: 2.0),
                            child: Icon(
                              Icons.navigate_next,
                              size: 24,
                              color: HexColor.fromHex('#EEEEEE'),
                            ),
                          ),
                          Icon(
                            Icons.panorama_fish_eye,
                            size: 30,
                            color: HexColor.fromHex('#EEEEEE'),
                          )
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Image(
              image: AssetImage(_order.status == 'Новый'
                  ? 'assets/yellow-corn.png'
                  : (_order.status == 'Готовится'
                      ? 'assets/green-corn.png'
                      : 'assets/red-corn.png')),
              width: 21),
        ),
      ],
    );
  }

  Widget buildAppBar(BuildContext context) {
    return AppBar(title: Text(''));
  }
}
