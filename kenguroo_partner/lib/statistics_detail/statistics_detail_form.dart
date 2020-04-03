import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:kenguroo_partner/models/models.dart';
import 'package:kenguroo_partner/models/statistic_item.dart';
import 'package:kenguroo_partner/repositories/repositories.dart';
import 'package:kenguroo_partner/statistics_detail/statistics_detail.dart';
import 'package:kenguroo_partner/statistics_item/statistics_item.dart';
import '../extentions.dart';

class StatisticsDetailForm extends StatefulWidget {
  final DateTime from;
  final DateTime to;

  Statistic statistic;

  StatisticsDetailForm({Key key, this.statistic, this.from, this.to})
      : super(key: key);

  @override
  State<StatisticsDetailForm> createState() => _StatisticsDetailFormState();
}

class _StatisticsDetailFormState extends State<StatisticsDetailForm> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<StatisticsDetailBloc, StatisticsDetailState>(
      listener: (context, state) {
        if (state is StatisticsDetailFailure) {
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text('${state.error}'),
              backgroundColor: Colors.red,
            ),
          );
        }

        if (state is StatisticsDetailDidGet) {
          widget.statistic = state.statistic;
        }

        if (state is StatisticsDetailDidSetStartDate) {
          showPicker(state);
        }
      },
      child: BlocBuilder<StatisticsDetailBloc, StatisticsDetailState>(
        builder: (context, state) {
          if (state is StatisticsDetailInitial &&
              widget.from != null &&
              widget.to != null)
            BlocProvider.of<StatisticsDetailBloc>(context).add(
                StatisticsDetailSetEndDate(start: widget.from, end: widget.to));
          return Scaffold(
            appBar:
                AppBar(title: Text('Подробная статистика'), actions: <Widget>[
              IconButton(
                icon: Image(
                  image: AssetImage('assets/ic-calendar.png'),
                  width: 24,
                ),
                onPressed: () {
                  showPicker(state);
                },
              ),
            ]),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: (state is StatisticsDetailLoading)
                  ? Center(child: CircularProgressIndicator())
                  : (widget.statistic != null)
                      ? ListView(
                          children: <Widget>[
                            Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  const Padding(
                                      padding: const EdgeInsets.all(20)),
                                  Text('Итого за неделю',
                                      style: TextStyle(
                                          fontSize: 13,
                                          color: HexColor.fromHex('#E4E4E4'))),
                                  const Padding(
                                      padding: const EdgeInsets.all(4)),
                                  Text('${widget.statistic.total} сом',
                                      style: TextStyle(
                                          fontSize: 29,
                                          color: HexColor.fromHex('#0C270F'))),
                                  const Padding(
                                      padding: const EdgeInsets.all(20)),
                                ]),
                            ListView.separated(
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: widget.statistic.items.length,
                              shrinkWrap: true,
                              itemBuilder: (BuildContext context, int index) {
                                StatisticItem _item =
                                    widget.statistic.items[index];
                                String title = _item.name == null
                                    ? _item.date
                                    : _item.name;
                                return GestureDetector(
                                    child: Container(
                                      color: Colors.transparent,
                                      height: 53,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(
                                            title,
                                            style: TextStyle(
                                                color:
                                                    HexColor.fromHex('#0C270F'),
                                                fontSize: 16,
                                                fontWeight: FontWeight.w300),
                                          ),
                                          Row(
                                            children: <Widget>[
                                              Text(
                                                '${_item.total} сом',
                                                style: TextStyle(
                                                    color: HexColor.fromHex(
                                                        '#0C270F'),
                                                    fontSize: 16),
                                              ),
                                              const Padding(
                                                  padding:
                                                      const EdgeInsets.all(4)),
                                              Icon(Icons.keyboard_arrow_right,
                                                  color: HexColor.fromHex(
                                                      '#EEEEEE'))
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                    onTap: () => {onTap(_item)});
                              },
                              separatorBuilder:
                                  (BuildContext context, int index) =>
                                      const Divider(
                                height: 1,
                              ),
                            )
                          ],
                        )
                      : Container(),
            ),
          );
        },
      ),
    );
  }

  onTap(StatisticItem item) {
    ApiRepository apiRepository =
        BlocProvider.of<StatisticsDetailBloc>(context).apiRepository;
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => StatisticsItemPage(
              apiRepository: apiRepository,
              statisticItem: item,
            )));
  }

  showPicker(StatisticsDetailState state) {
    DateTime time = DateTime.now();
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (BuildContext builder) {
          return Container(
            decoration: new BoxDecoration(
                color: Colors.white,
                borderRadius: new BorderRadius.only(
                    topRight: Radius.circular(18.0),
                    topLeft: Radius.circular(18.0))),
            height: 350,
            child: Column(
              children: <Widget>[
                Padding(padding: const EdgeInsets.only(top: 16.0)),
                Container(
                  decoration: new BoxDecoration(
                      color: HexColor.fromHex('#EEEEEE'),
                      borderRadius: new BorderRadius.only(
                          topRight: Radius.circular(18.0),
                          topLeft: Radius.circular(18.0))),
                  height: 3,
                  width: 56,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 24.0, bottom: 8),
                  child: Text(
                    (state is StatisticsDetailDidSetStartDate)
                        ? "Укажите период “до”"
                        : "Укажите период “от”",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                        color: HexColor.fromHex('#222831')),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 8, right: 8),
                  child: DatePickerWidget(
                    locale: DateTimePickerLocale.ru,
                    minDateTime: (state is StatisticsDetailDidSetStartDate)
                        ? state.startDate
                        : null,
                    maxDateTime: DateTime.now(),
                    initialDateTime: DateTime.now(),
                    dateFormat: 'MMMM,d,yyyy',
                    pickerTheme: DateTimePickerTheme(
                      showTitle: false,
                      itemTextStyle: TextStyle(
                          color: HexColor.fromHex('#333333'),
                          fontSize: 21,
                          fontWeight: FontWeight.bold),
                      pickerHeight: 185,
                      itemHeight: 74.0,
                    ),
                    onChange: (dateTime, selectedIndex) {
                      time = dateTime;
                    },
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(bottom: 16.0, right: 16, left: 16),
                  child: SizedBox(
                    height: 56,
                    width: double.infinity,
                    child: FlatButton(
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(40.0),
                          side: BorderSide(color: HexColor.fromHex('#3FC64F'))),
                      onPressed: () => {
                        Navigator.pop(context),
                        (state is StatisticsDetailDidSetStartDate)
                            ? BlocProvider.of<StatisticsDetailBloc>(context)
                                .add(StatisticsDetailSetEndDate(
                                    start: state.startDate, end: time))
                            : BlocProvider.of<StatisticsDetailBloc>(context)
                                .add(StatisticsDetailSetStartDate(start: time))
                      },
                      color: HexColor.fromHex('#3FC64F'),
                      textColor: Colors.white,
                      child: Text(
                          (state is StatisticsDetailDidSetStartDate)
                              ? 'Готово'
                              : 'Далее',
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
