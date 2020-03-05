import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kenguroo_partner/extentions.dart';
import 'package:kenguroo_partner/models/models.dart';
import 'package:kenguroo_partner/order/order.dart';

class OrderForm extends StatefulWidget {
  final Order order;

  OrderForm({Key key, @required this.order})
      : assert(order != null),
        super(key: key);

  @override
  State<OrderForm> createState() => _OrderFormState();
}

class _OrderFormState extends State<OrderForm> {
  _acceptBtnClicked() => () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0)),
                child: Stack(
                  alignment: Alignment.topRight,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    Container(
                      padding: const EdgeInsets.all(32.0),
                      height: 315,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.room_service,
                            color: Theme.of(context).accentColor,
                            size: 56,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Text(
                              'Вы приняли заказ',
                              style: TextStyle(
                                  color: HexColor.fromHex('#222831'),
                                  fontSize: 21,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 16, bottom: 40),
                            child: Text(
                              'Заказ перемещен во вкладку “готовится”. Отслеживайте заказ!',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: HexColor.fromHex('#CCCCCC'),
                                  fontSize: 16),
                            ),
                          ),
                          SizedBox(
                            height: 56,
                            width: double.infinity,
                            child: FlatButton(
                              shape: new RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(40.0),
                                  side: BorderSide(
                                      color: HexColor.fromHex('#3FC64F'))),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              color: HexColor.fromHex('#3FC64F'),
                              textColor: Colors.white,
                              child: Text("Готово",
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold)),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              );
            });
      };

  @override
  Widget build(BuildContext context) {
    return BlocListener<OrderBloc, OrderState>(
      listener: (context, state) {
        if (state is OrderFailure) {
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text('${state.error}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: BlocBuilder<OrderBloc, OrderState>(
        builder: (context, state) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: <Widget>[
                  const Padding(padding: EdgeInsets.only(top: 16)),
                  Text(
                    'Блюда (${widget.order.itemsCount})',
                    style: TextStyle(
                        color: HexColor.fromHex('#0C270F'),
                        fontSize: 17,
                        fontWeight: FontWeight.bold),
                  ),
                  const Padding(padding: EdgeInsets.only(top: 16)),
                  Container(
                    height: widget.order.items.length * 53.0,
                    child: ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: widget.order.items.length,
                      itemBuilder: (BuildContext context, int index) {
                        Item _item = widget.order.items[index];
                        return Container(
                          height: 53,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                _item.name,
                                style: TextStyle(
                                    color: HexColor.fromHex('#0C270F'),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w300),
                              ),
                              Text(
                                '${_item.count} шт.',
                                style: TextStyle(
                                    color: HexColor.fromHex('#0C270F'),
                                    fontSize: 16),
                              ),
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) =>
                          const Divider(
                        height: 1,
                      ),
                    ),
                  ),
                  const Divider(),
                  const Padding(padding: EdgeInsets.only(top: 32)),
                  widget.order.comment.isNotEmpty
                      ? Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Image(
                                    image: AssetImage('assets/info.png'),
                                    width: 20),
                                const Padding(
                                    padding: EdgeInsets.only(right: 10)),
                                Text(
                                  'Комментарий к заказу',
                                  style: TextStyle(
                                      color: HexColor.fromHex('#0C270F'),
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 16),
                              padding: EdgeInsets.all(16),
                              decoration: new BoxDecoration(
                                  border: Border.all(
                                    width: 1,
                                    color: HexColor.fromHex('#DEE9F5'),
                                  ),
                                  borderRadius: new BorderRadius.all(
                                      Radius.circular(12.0))),
                              child: Center(
                                child: Text(
                                  widget.order.comment,
                                  style: TextStyle(
                                      color: HexColor.fromHex('#5E5E5E'),
                                      fontSize: 15),
                                ),
                              ),
                            ),
                          ],
                        )
                      : Container(),
                  const Padding(padding: EdgeInsets.only(top: 40)),
                  Text(
                    'О заказе',
                    style: TextStyle(
                        color: HexColor.fromHex('#0C270F'),
                        fontSize: 17,
                        fontWeight: FontWeight.bold),
                  ),
                  const Padding(padding: EdgeInsets.only(top: 16)),
                  Container(
                    height: 53,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Номер заказа',
                          style: TextStyle(
                              color: HexColor.fromHex('#0C270F'),
                              fontSize: 16,
                              fontWeight: FontWeight.w300),
                        ),
                        Text(
                          '${widget.order.number}',
                          style: TextStyle(
                              color: HexColor.fromHex('#0C270F'), fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  Container(
                    height: 53,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Время выдачи',
                          style: TextStyle(
                              color: HexColor.fromHex('#0C270F'),
                              fontSize: 16,
                              fontWeight: FontWeight.w300),
                        ),
                        Text(
                          '${widget.order.orderedAt}',
                          style: TextStyle(
                              color: HexColor.fromHex('#0C270F'), fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  Container(
                    height: 53,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Курьер',
                          style: TextStyle(
                              color: HexColor.fromHex('#0C270F'),
                              fontSize: 16,
                              fontWeight: FontWeight.w300),
                        ),
                        Text(
                          '${widget.order.driver}',
                          style: TextStyle(
                              color: HexColor.fromHex('#0C270F'), fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  Container(
                    height: 53,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Итого',
                          style: TextStyle(
                              color: HexColor.fromHex('#0C270F'),
                              fontSize: 16,
                              fontWeight: FontWeight.w300),
                        ),
                        Text(
                          '${widget.order.price}',
                          style: TextStyle(
                              color: HexColor.fromHex('#0C270F'), fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  const Padding(padding: EdgeInsets.only(top: 40)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      FlatButton(
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(40.0),
                            side:
                                BorderSide(color: HexColor.fromHex('#3FC64F'))),
                        padding: EdgeInsets.only(
                            top: 16, bottom: 16, right: 48, left: 48),
                        onPressed: _acceptBtnClicked(),
                        color: HexColor.fromHex('#3FC64F'),
                        textColor: Colors.white,
                        child: Text("Принять",
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.bold)),
                      ),
                      SizedBox(width: 10),
                      FlatButton(
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(40.0),
                            side: BorderSide(color: Colors.red)),
                        color: Colors.white,
                        textColor: Colors.red,
                        padding: EdgeInsets.only(
                            top: 16, bottom: 16, right: 48, left: 48),
                        onPressed: () {},
                        child: Text(
                          "Отменить",
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const Padding(padding: EdgeInsets.only(top: 40)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
