import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kenguroo_partner/cancel_order/cancel_order.dart';
import 'package:kenguroo_partner/extentions.dart';
import 'package:kenguroo_partner/models/models.dart';
import 'package:kenguroo_partner/order/order.dart';
import 'package:kenguroo_partner/repositories/repositories.dart';

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
        BlocProvider.of<OrderBloc>(context)
            .add(OrderConfirmBtnPressed(id: widget.order.id));
      };

  _readyBtnClicked() => () {
        BlocProvider.of<OrderBloc>(context)
            .add(OrderFinishBtnPressed(id: widget.order.id));
      };

  _cancelBtnClicked() => () async {
        ApiRepository repository =
            BlocProvider.of<OrderBloc>(context).apiRepository;
        Map result = await Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => CancelOrderPage(
                apiRepository: repository, id: widget.order.id)));
        if (result != null && result['needUpdate']) {
          Navigator.of(context).pop({'needUpdate': true});
        }
      };

  _showAcceptDialog() {
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
                  height: 325,
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
                        padding: const EdgeInsets.only(top: 16, bottom: 30),
                        child: Text(
                          'Заказ перемещен во вкладку “готовится”. Отслеживайте заказ!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: HexColor.fromHex('#CCCCCC'), fontSize: 16),
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
                            Navigator.of(context).pop({'needUpdate': true});
                          },
                          color: HexColor.fromHex('#3FC64F'),
                          textColor: Colors.white,
                          child: Text("Готово",
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.bold)),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }

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

        if (state is OrderShowDialog) {
          _showAcceptDialog();
        }

        if (state is OrderFinished) {
          Navigator.of(context).pop({'needUpdate': true});
        }
      },
      child: BlocBuilder<OrderBloc, OrderState>(
        builder: (context, state) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
              child: Stack(
                children: <Widget>[
                  (state is OrderLoading)
                      ? Center(child: CircularProgressIndicator())
                      : Container(),
                  Padding(
                    padding: (widget.order.status == 'Завершен')
                        ? const EdgeInsets.all(0)
                        : const EdgeInsets.only(bottom: 60),
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
                        if (widget.order.items != null)
                          Container(
                            height: widget.order.items.length * 73.0,
                            child: ListView.separated(
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: widget.order.items.length,
                              itemBuilder: (BuildContext context, int index) {
                                Item _item = widget.order.items[index];
                                return Container(
                                  height: 73,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      const Padding(
                                          padding: EdgeInsets.only(top: 8)),
                                      Text(
                                        _item.name,
                                        style: TextStyle(
                                            color: HexColor.fromHex('#0C270F'),
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      const Padding(
                                          padding: EdgeInsets.only(top: 12)),
                                      Text(
                                        'Кол-во: ${_item.count} шт.      Стоимость: ${_item.price}',
                                        style: TextStyle(
                                            color: HexColor.fromHex('#0C270F'),
                                            fontWeight: FontWeight.w300,
                                            fontSize: 13),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              separatorBuilder:
                                  (BuildContext context, int index) =>
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
                                    color: HexColor.fromHex('#0C270F'),
                                    fontSize: 16),
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
                                    color: HexColor.fromHex('#0C270F'),
                                    fontSize: 16),
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
                                    color: HexColor.fromHex('#0C270F'),
                                    fontSize: 16),
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
                                    color: HexColor.fromHex('#0C270F'),
                                    fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                        !widget.order.cash
                            ? const Divider(height: 1)
                            : Container(),
                        !widget.order.cash
                            ? const Padding(padding: EdgeInsets.only(top: 16))
                            : Container(),
                        !widget.order.cash
                            ? Container(
                                height: 53,
                                child: Text(
                                  'Заказ оплачен картой. Итого за заказ оплачено ${widget.order.price}',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: HexColor.fromHex('#3FC64F'),
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                            : Container(),
                        const Divider(height: 1),
                        const Padding(padding: EdgeInsets.only(top: 40)),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: (widget.order.status == 'Завершен')
                        ? Container()
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              FlatButton(
                                shape: new RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(40.0),
                                    side: BorderSide(
                                        color: HexColor.fromHex('#3FC64F'))),
                                padding: EdgeInsets.only(
                                    top: 16, bottom: 16, right: 40, left: 40),
                                onPressed: (widget.order.status == 'Готовится')
                                    ? _readyBtnClicked()
                                    : _acceptBtnClicked(),
                                color: HexColor.fromHex('#3FC64F'),
                                textColor: Colors.white,
                                child: Text(
                                    (widget.order.status == 'Готовится')
                                        ? 'Готово'
                                        : 'Принять',
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold)),
                              ),
                              (widget.order.status == 'Готовится')
                                  ? Container()
                                  : SizedBox(width: 16),
                              (widget.order.status == 'Готовится')
                                  ? Container()
                                  : FlatButton(
                                      shape: new RoundedRectangleBorder(
                                          borderRadius:
                                              new BorderRadius.circular(40.0),
                                          side: BorderSide(color: Colors.red)),
                                      color: Colors.white,
                                      textColor: Colors.red,
                                      padding: EdgeInsets.only(
                                          top: 16,
                                          bottom: 16,
                                          right: 40,
                                          left: 40),
                                      onPressed: _cancelBtnClicked(),
                                      child: Text(
                                        'Отменить',
                                        style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )
                            ],
                          ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
