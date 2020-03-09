import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kenguroo_partner/order/order.dart';
import 'package:kenguroo_partner/repositories/api_repository.dart';
import 'package:kenguroo_partner/store/store.dart';
import 'package:kenguroo_partner/models/models.dart';

import '../extentions.dart';

class StoreForm extends StatefulWidget {
  @override
  State<StoreForm> createState() => _StoreFormState();
}

class _StoreFormState extends State<StoreForm> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final children = const <int, Widget>{
      0: Text('Новые'),
      1: Text('Готовится'),
      2: Text('Ожидает'),
    };

    final iconCorners = [
      'assets/yellow-corn.png',
      'assets/green-corn.png',
      'assets/red-corn.png'
    ];

    _onValueChanged(int newValue) {
      _selectedIndex = newValue;
      BlocProvider.of<StoreBloc>(context)
          .add(StoreSegmentedCtrPressed(index: newValue));
    }

    void _onTapItem(BuildContext context, Order order) {
      ApiRepository repository =
          BlocProvider.of<StoreBloc>(context).apiRepository;
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => OrderPage(
                apiRepository: repository,
                order: order,
              )));
    }

    _listViewWidget(int _index, List<Order> orders) {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: orders.length,
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (context, position) {
          Order _order = orders[position];
          return GestureDetector(
              child: Stack(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.all(4),
                    decoration: new BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            new BorderRadius.all(Radius.circular(18.0))),
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
                                        color: HexColor.fromHex('#869FB1'),
                                        fontSize: 13),
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
                            padding: const EdgeInsets.only(
                                top: 24, right: 16, left: 16),
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
                        image: AssetImage(iconCorners[_index]), width: 21),
                  ),
                ],
              ),
              onTap: () => _onTapItem(context, _order));
        },
      );
    }

    _rootWidget(StoreState state) {
      if (state is StoreLoading)
        return Center(child: CircularProgressIndicator());
      if (state is StoreOrderLoaded)
        return _listViewWidget(state.index, state.orders);
      if (state is StoreInitial) _onValueChanged(_selectedIndex);
      return Center(
          child: Text(
        'Пусто',
        style: TextStyle(fontSize: 25, color: Colors.grey),
      ));
    }

    return BlocListener<StoreBloc, StoreState>(
      listener: (context, state) {
        if (state is StoreFailure) {
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text('${state.error}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: BlocBuilder<StoreBloc, StoreState>(
        builder: (context, state) {
          return SafeArea(
            child: Stack(
              children: <Widget>[
                SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: CupertinoSlidingSegmentedControl<int>(
                      backgroundColor: HexColor.fromHex('#E8F0F9'),
                      children: children,
                      onValueChanged: _onValueChanged,
                      groupValue: _selectedIndex,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 50),
                    child: _rootWidget(state),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
