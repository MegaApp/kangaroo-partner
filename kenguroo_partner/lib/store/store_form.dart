import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
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
  List<Order> orders = List.empty(growable: true);
  bool isLoading = false;

  @override
  void initState() {
    FlutterBackgroundService().on('update').listen((event) {
      if (!mounted) return;
      if (event != null) {
        List<dynamic> response = event['response'] ?? List.empty();
        List<Order> orders = response.map((e) => Order.fromJson(e)).toList();
        if (orders.isEmpty) {
          if (_selectedIndex == 0) {
            this.orders = orders;
          }
        } else {
          _selectedIndex = 0;
          this.orders = orders;
        }
        setState(() {});
      }
    });
    BlocProvider.of<StoreBloc>(context).add(const StoreSegmentedCtrPressed(index: 0));
    super.initState();
  }

  onValueChanged(int? newValue) {
    _selectedIndex = newValue ?? 0;
    orders.clear();
    BlocProvider.of<StoreBloc>(context).add(StoreSegmentedCtrPressed(index: newValue ?? 0));
  }

  Future<void> onTapItem(BuildContext context, Order order) async {
    ApiRepository repository = BlocProvider.of<StoreBloc>(context).apiRepository;
    Map result = await Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => OrderPage(
              apiRepository: repository,
              order: order,
            )));
    if (result['needUpdate']) {
      BlocProvider.of<StoreBloc>(context).add(StoreSegmentedCtrPressed(index: _selectedIndex));
    }
  }

  @override
  Widget build(BuildContext context) {
    const children = <int, Widget>{
      0: Text('Новые'),
      1: Text('Готовится'),
      2: Text('Завершен'),
    };

    return BlocListener<StoreBloc, StoreState>(
      listener: (context, state) {
        if (state is StoreOrderLoaded) {
          setState(() {
            isLoading = false;
            orders = state.orders;
          });
        }
        if (state is StoreLoading) {
          setState(() {
            isLoading = true;
          });
        }
        if (state is StoreOrderEmpty) {
          setState(() {
            isLoading = false;
            orders.clear();
          });
        }
        if (state is StoreFailure) {
          setState(() {
            isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error),
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
                      onValueChanged: onValueChanged,
                      groupValue: _selectedIndex,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 50),
                    child: Stack(
                      children: [
                        if (isLoading) const Center(child: CircularProgressIndicator()),
                        if (orders.isNotEmpty)
                          ListView(children: [
                            ...orders.map((order) => Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: GestureDetector(
                                      child: Stack(
                                        children: <Widget>[
                                          Container(
                                            margin: const EdgeInsets.all(4),
                                            decoration: const BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.all(Radius.circular(18.0))),
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
                                                            '${order.number}',
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
                                                                  color: HexColor.fromHex('#869FB1'), fontSize: 13)),
                                                          const Padding(padding: EdgeInsets.all(8)),
                                                          Text('${order.itemsCount}',
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
                                                                  color: HexColor.fromHex('#869FB1'), fontSize: 13)),
                                                          const Padding(padding: EdgeInsets.all(8)),
                                                          Text(order.orderedAt,
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
                                                image: AssetImage(order.status == 'Новый'
                                                    ? 'assets/yellow-corn.png'
                                                    : (order.status == 'Готовится'
                                                        ? 'assets/green-corn.png'
                                                        : 'assets/red-corn.png')),
                                                width: 21),
                                          ),
                                        ],
                                      ),
                                      onTap: () => onTapItem(context, order)),
                                ))
                          ]),
                        if (orders.isEmpty)
                          Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                const Image(
                                  image: AssetImage('assets/ic-plh.png'),
                                  width: 120,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 80, left: 80, top: 66),
                                  child: Text(
                                    'Пока нет результатов',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 21, color: HexColor.fromHex('#E0E0E0'), fontWeight: FontWeight.bold),
                                  ),
                                )
                              ],
                            ),
                          )
                      ],
                    ),
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
