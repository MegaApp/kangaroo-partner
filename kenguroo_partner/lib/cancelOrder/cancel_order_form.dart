import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kenguroo_partner/extentions.dart';
import 'package:kenguroo_partner/models/models.dart';
import 'package:kenguroo_partner/cancelOrder/cancel_order.dart';

class CancelOrderForm extends StatefulWidget {
  final String id;

  CancelOrderForm({Key key, @required this.id})
      : assert(id != null),
        super(key: key);

  @override
  State<CancelOrderForm> createState() => _CancelOrderFormState();
}

class _CancelOrderFormState extends State<CancelOrderForm> {
  _acceptBtnClicked() => () {
        BlocProvider.of<CancelOrderBloc>(context)
            .add(CancelOrderBtnPressed(id: widget.id));
      };

  @override
  Widget build(BuildContext context) {
    return BlocListener<CancelOrderBloc, CancelOrderState>(
      listener: (context, state) {
        if (state is CancelOrderFailure) {
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text('${state.error}'),
              backgroundColor: Colors.red,
            ),
          );
        }

        if (state is CancelOrderApproved) {
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        }
      },
      child: BlocBuilder<CancelOrderBloc, CancelOrderState>(
        builder: (context, state) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Stack(
                children: <Widget>[
                  (state is CancelOrderLoading)
                      ? Center(child: CircularProgressIndicator())
                      : Container(),
                  ListView(
                    children: <Widget>[
                      const Padding(padding: EdgeInsets.only(top: 32)),
                      Text(
                        'Почему вы отменяете заказ?',
                        style: TextStyle(
                            color: HexColor.fromHex('#0C270F'),
                            fontSize: 17,
                            fontWeight: FontWeight.bold),
                      ),
                      const Padding(padding: EdgeInsets.only(top: 40)),
                      Container(
                        height: 56,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'Нет в наличии',
                              style: TextStyle(
                                  color: HexColor.fromHex('#0C270F'),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w300),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.check,
                                color: Theme.of(context).accentColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(height: 1),
                      Container(
                        height: 56,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'Кухня не успеет выполнить заказ',
                              style: TextStyle(
                                  color: HexColor.fromHex('#0C270F'),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w300),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.check,
                                color: Theme.of(context).accentColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(height: 1),
                      Container(
                        height: 56,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'Нет свободных курьеров',
                              style: TextStyle(
                                  color: HexColor.fromHex('#0C270F'),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w300),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.check,
                                color: Theme.of(context).accentColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(height: 1),
                      Container(
                        height: 56,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'Другое',
                              style: TextStyle(
                                  color: HexColor.fromHex('#0C270F'),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w300),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.check,
                                color: Theme.of(context).accentColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(height: 1),
                      const Padding(padding: EdgeInsets.only(top: 32)),
                      Text(
                        'Комментарий',
                        style: TextStyle(
                            fontSize: 13, color: HexColor.fromHex('#CCCCCC')),
                      ),
                      TextField(
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Введите ваш комментарий...',
                            hintStyle: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w300,
                                color: HexColor.fromHex('#222831'))),
                      ),
                      const Divider(height: 1),
                      Padding(
                        padding: const EdgeInsets.all(56),
                        child: SizedBox(
                          height: 56,
                          width: double.infinity,
                          child: FlatButton(
                            shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(40.0),
                                side: BorderSide(color: Colors.red)),
                            color: Colors.white,
                            textColor: Colors.red,
                            onPressed: () {},
                            child: Text(
                              "Отменить",
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ],
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
