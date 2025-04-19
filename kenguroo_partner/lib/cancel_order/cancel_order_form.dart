import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kenguroo_partner/extentions.dart';
import 'package:kenguroo_partner/cancel_order/cancel_order.dart';
import 'package:kenguroo_partner/models/item.dart';

import '../models/menu.dart';
import '../models/order.dart';

class CancelOrderForm extends StatefulWidget {
  final Order order;

  CancelOrderForm({required this.order});

  @override
  State<CancelOrderForm> createState() => _CancelOrderFormState();
}

class _CancelOrderFormState extends State<CancelOrderForm> {
  String _message = '';
  final _messageController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _requestFocus() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_focusNode);
    });
  }

  void _removeFocus() {
    _focusNode.unfocus(); // убрать фокус
  }

  _cancelBtnClicked() => () {
        if (_message.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Выберите причину отмены'),
            backgroundColor: Colors.red,
          ));
          return;
        }

        if (_message == 'Другое') {
          if (_messageController.text.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Введите ваш комментарий'),
              backgroundColor: Colors.red,
            ));
            return;
          } else {
            _message = _messageController.text;
          }
        }

        if (_message == 'Нет в наличии') {
          if (widget.order.items.where((element) => element.active == true).isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Выберите какой продукты нет в наличии'),
              backgroundColor: Colors.red,
            ));
            return;
          } else {
            _message =
                'Нет в наличии ${widget.order.items.where((element) => element.active == true).map((e) => e.name).toList()}';
          }
        }

        BlocProvider.of<CancelOrderBloc>(context)
            .add(CancelOrderBtnPressed(id: widget.order.id, message: '$_message: ${_messageController.text}'));
      };

  @override
  Widget build(BuildContext context) {
    return BlocListener<CancelOrderBloc, CancelOrderState>(
      listener: (context, state) {
        if (state is CancelOrderFailure) {
          _message = '';
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${state.error}'),
              backgroundColor: Colors.red,
            ),
          );
        }

        if (state is CancelOrderApproved) {
          _message = '';
          Navigator.of(context).pop({'needUpdate': true});
        }
      },
      child: BlocBuilder<CancelOrderBloc, CancelOrderState>(
        builder: (context, state) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Stack(
                children: <Widget>[
                  (state is CancelOrderLoading) ? Center(child: CircularProgressIndicator()) : Container(),
                  ListView(
                    children: <Widget>[
                      const Padding(padding: EdgeInsets.only(top: 32)),
                      Text(
                        'Почему вы отменяете заказ?',
                        style: TextStyle(color: HexColor.fromHex('#0C270F'), fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                      const Padding(padding: EdgeInsets.only(top: 40)),
                      GestureDetector(
                          child: Container(
                            color: Colors.transparent,
                            height: 56,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  'Нет в наличии',
                                  style: TextStyle(
                                      color: HexColor.fromHex('#0C270F'), fontSize: 16, fontWeight: FontWeight.w300),
                                ),
                                Icon(
                                  Icons.check,
                                  color: _message == 'Нет в наличии' ? Theme.of(context).hintColor : Colors.transparent,
                                ),
                              ],
                            ),
                          ),
                          onTap: () => {
                                setState(() {
                                  _removeFocus();
                                  _message = 'Нет в наличии';
                                })
                              }),
                      if (_message == 'Нет в наличии') _listViewWidget(widget.order.items),
                      const Divider(height: 1),
                      GestureDetector(
                          child: Container(
                            height: 56,
                            color: Colors.transparent,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  'Кухня не успеет выполнить заказ',
                                  style: TextStyle(
                                      color: HexColor.fromHex('#0C270F'), fontSize: 16, fontWeight: FontWeight.w300),
                                ),
                                Icon(
                                  Icons.check,
                                  color: _message == 'Кухня не успеет выполнить заказ'
                                      ? Theme.of(context).hintColor
                                      : Colors.transparent,
                                ),
                              ],
                            ),
                          ),
                          onTap: () => {
                                setState(() {
                                  _removeFocus();
                                  _message = 'Кухня не успеет выполнить заказ';
                                })
                              }),
                      const Divider(height: 1),
                      GestureDetector(
                          child: Container(
                            height: 56,
                            color: Colors.transparent,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  'Другое',
                                  style: TextStyle(
                                      color: HexColor.fromHex('#0C270F'), fontSize: 16, fontWeight: FontWeight.w300),
                                ),
                                Icon(
                                  Icons.check,
                                  color: _message == 'Другое' ? Theme.of(context).hintColor : Colors.transparent,
                                ),
                              ],
                            ),
                          ),
                          onTap: () => {
                                setState(() {
                                  _message = 'Другое';
                                  _requestFocus();
                                })
                              }),
                      const Divider(height: 1),
                      const Padding(padding: EdgeInsets.only(top: 32)),
                      Text(
                        'Комментарий',
                        style: TextStyle(fontSize: 13, color: HexColor.fromHex('#CCCCCC')),
                      ),
                      TextField(
                        enabled: _message == 'Другое',
                        controller: _messageController,
                        focusNode: _focusNode,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Введите ваш комментарий...',
                            hintStyle: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w300, color: HexColor.fromHex('#222831'))),
                      ),
                      const Divider(height: 1),
                      Padding(
                        padding: const EdgeInsets.all(56),
                        child: Container(
                          height: 56,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40.0),
                              border: Border.all(color: _message.isNotEmpty ? Colors.red : Colors.grey, width: 2)),
                          child: TextButton(
                            style: TextButton.styleFrom(
                                foregroundColor: _message.isNotEmpty ? Colors.red : Colors.grey,
                                backgroundColor: Colors.white),
                            onPressed: _cancelBtnClicked(),
                            child: Text(
                              "Отменить",
                              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
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

  _listViewWidget(List<Item> orders) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: orders.length,
      padding: const EdgeInsets.only(left: 24.0, right: 0, top: 8, bottom: 8),
      itemBuilder: (context, position) {
        Item _menu = orders[position];
        return Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.only(top: 16, bottom: 16),
                  child: Text(
                    _menu.name,
                    textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 16, color: HexColor.fromHex('#0C270F')),
                  ),
                )),
                // Image(
                //     image: AssetImage(_menu.active
                //         ? 'assets/close.png'
                //         : 'assets/open.png'),
                //     width: 24),
                Checkbox(
                  value: _menu.active,
                  onChanged: (value) {
                    setState(() {
                      _menu.active = value ?? false;
                    });
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
