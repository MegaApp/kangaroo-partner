import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kenguroo_partner/models/statistic_item.dart';
import 'package:kenguroo_partner/order_list/order_list_page.dart';
import 'package:kenguroo_partner/repositories/repositories.dart';
import 'package:kenguroo_partner/statistics_item/statistics_item.dart';
import '../extentions.dart';

class StatisticsItemForm extends StatefulWidget {
  final StatisticItem statisticItem;

  StatisticsItemForm({Key key, this.statisticItem}) : super(key: key);

  @override
  State<StatisticsItemForm> createState() => _StatisticsItemFormState();
}

class _StatisticsItemFormState extends State<StatisticsItemForm> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<StatisticsItemBloc, StatisticsItemState>(
        listener: (context, state) {},
        child: BlocBuilder<StatisticsItemBloc, StatisticsItemState>(
            builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                        width: double.infinity,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              const Padding(padding: const EdgeInsets.all(20)),
                              Text('Итого за неделю',
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: HexColor.fromHex('#E4E4E4'))),
                              const Padding(padding: const EdgeInsets.all(4)),
                              Text('${widget.statisticItem.total} сом',
                                  style: TextStyle(
                                      fontSize: 29,
                                      color: HexColor.fromHex('#0C270F'))),
                              const Padding(padding: const EdgeInsets.all(24)),
                            ])),
                    Text('Оплата за заказы',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            fontSize: 13, color: HexColor.fromHex('#E4E4E4'))),
                    const Padding(padding: const EdgeInsets.all(4)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          '${widget.statisticItem.count} заказов',
                          style: TextStyle(
                              color: HexColor.fromHex('#0C270F'),
                              fontSize: 16,
                              fontWeight: FontWeight.w300),
                        ),
                        Text(
                          '${widget.statisticItem.total} сом',
                          style: TextStyle(
                              color: HexColor.fromHex('#0C270F'), fontSize: 16),
                        ),
                      ],
                    ),
                    Divider(),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 32),
                  child: SizedBox(
                    height: 56,
                    width: 223,
                    child: FlatButton(
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(40.0),
                          side: BorderSide(color: HexColor.fromHex('#3FC64F'))),
                      onPressed: () => {_buttonClick()},
                      color: HexColor.fromHex('#3FC64F'),
                      textColor: Colors.white,
                      child: Text('Показать заказы',
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
              ],
            ),
          );
        }));
  }

  _buttonClick() {
    ApiRepository repository =
        BlocProvider.of<StatisticsItemBloc>(context).apiRepository;
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => OrderListPage(
              userRepository: repository,
              date: widget.statisticItem.date,
            )));
  }
}
