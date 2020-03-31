import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:kenguroo_partner/models/models.dart';
import 'package:kenguroo_partner/statistics/statistics.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import '../extentions.dart';

class StatisticsForm extends StatefulWidget {
  StatisticsForm({Key key}) : super(key: key);

  @override
  State<StatisticsForm> createState() => _StatisticsFormState();
}

class _StatisticsFormState extends State<StatisticsForm> {
  List<Item> _list;
  int touchedIndex;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String stateText;

  showPicker(StatisticsState state) {
    DateTime time;
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
            height: MediaQuery.of(context).copyWith().size.height / 2.2,
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
                    (state is StatisticsDidSetStartDate)
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
                    minDateTime: (state is StatisticsDidSetStartDate)
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
                      pickerHeight:
                          MediaQuery.of(context).copyWith().size.height / 4,
                      itemHeight: 74.0,
                    ),
                    onChange: (dateTime, selectedIndex) {
                      setState(() {
                        time = dateTime;
                      });
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
                        (state is StatisticsDidSetStartDate)
                            ? BlocProvider.of<StatisticsBloc>(context).add(
                                StatisticsSetEndDate(
                                    start: state.startDate, end: time))
                            : BlocProvider.of<StatisticsBloc>(context)
                                .add(StatisticsSetStartDate(start: time))
                      },
                      color: HexColor.fromHex('#3FC64F'),
                      textColor: Colors.white,
                      child: Text(
                          (state is StatisticsDidSetStartDate)
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

  @override
  Widget build(BuildContext context) {
    return BlocListener<StatisticsBloc, StatisticsState>(
      listener: (context, state) {
        if (state is StatisticsFailure) {
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text('${state.error}'),
              backgroundColor: Colors.red,
            ),
          );
        }

        if (state is StatisticsDidGet) {
          _list = state.items;
        }

        if (state is StatisticsDidSetStartDate) {
          showPicker(state);
        }
      },
      child: BlocBuilder<StatisticsBloc, StatisticsState>(
        builder: (context, state) {
          if (state is StatisticsInitial)
            BlocProvider.of<StatisticsBloc>(context).add(StatisticsGet());
          return Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(title: Text('Статистика'), actions: <Widget>[
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
              child: Stack(
                children: <Widget>[
                  (state is StatisticsLoading)
                      ? Center(child: CircularProgressIndicator())
                      : Container(),
                  ListView(
                    children: <Widget>[
                      const Padding(padding: EdgeInsets.only(top: 8)),
                      Text(
                        'Статистика за неделю',
                        style: TextStyle(
                            color: HexColor.fromHex('#0C270F'),
                            fontSize: 21,
                            fontWeight: FontWeight.bold),
                      ),
                      const Padding(padding: EdgeInsets.only(top: 48)),
                      SizedBox(
                          width: double.infinity,
                          height: 260,
                          child: (_list == null || _list.length == 0)
                              ? Container()
                              : buildBarChart()),
                      const Padding(padding: EdgeInsets.only(top: 48)),
                      GestureDetector(
                        child: Stack(children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: Align(
                                alignment: Alignment.bottomRight,
                                child: Icon(Icons.keyboard_arrow_right,
                                    color: HexColor.fromHex('#EEEEEE'))),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Image(
                                  image: AssetImage('assets/ic_activity.png'),
                                  width: 24),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(
                                  'Подробная статистика',
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: HexColor.fromHex('#0C270F')),
                                ),
                              ),
                            ],
                          )
                        ]),
                        onTap: () {},
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 40),
                        child: Divider(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  BarChart buildBarChart() {
    int maxY = _list
        .reduce((curr, next) => curr.count > next.count ? curr : next)
        .count;
    return BarChart(BarChartData(
      alignment: BarChartAlignment.spaceAround,
      maxY: maxY.toDouble(),
      barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            tooltipRoundedRadius: 12,
            tooltipBgColor: HexColor.fromHex('#007FD0'),
            tooltipPadding:
                const EdgeInsets.only(top: 4, bottom: 0, right: 8, left: 8),
            tooltipBottomMargin: 8,
            getTooltipItem: (
              BarChartGroupData group,
              int groupIndex,
              BarChartRodData rod,
              int rodIndex,
            ) {
              return BarTooltipItem(
                '${rod.y.round().toString()} сом',
                TextStyle(
                  color: Colors.white,
                ),
              );
            },
          ),
          touchCallback: (barTouchResponse) {
            setState(() {
              if (barTouchResponse.spot != null &&
                  barTouchResponse.touchInput is! FlPanEnd &&
                  barTouchResponse.touchInput is! FlLongPressEnd) {
                touchedIndex = barTouchResponse.spot.touchedBarGroupIndex;
              }
            });
          }),
      gridData: FlGridData(
        show: true,
        checkToShowHorizontalLine: (value) =>
            value % 1000 == 0 ? true : value == 1,
        getDrawingHorizontalLine: (value) => FlLine(
          color: HexColor.fromHex('#EEEEEE'),
          strokeWidth: 1,
        ),
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          textStyle:
              TextStyle(color: HexColor.fromHex('#E4E4E4'), fontSize: 13),
          margin: 20,
          getTitles: (double value) {
            return _list[value.toInt()].name;
          },
        ),
        leftTitles: SideTitles(
            showTitles: true,
            textStyle:
                TextStyle(color: HexColor.fromHex('#E4E4E4'), fontSize: 13),
            interval: 1000,
            margin: 32,
            reservedSize: 40),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: showingGroups(),
    ));
  }

  BarChartGroupData makeGroupData(
    int x,
    double y, {
    bool isTouched = false,
  }) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          y: y,
          color: isTouched
              ? Theme.of(context).accentColor
              : HexColor.fromHex('#EEEEEE'),
          width: 10,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(5), topRight: Radius.circular(5)),
        ),
      ],
      showingTooltipIndicators: isTouched ? const [0] : const [],
    );
  }

  List<BarChartGroupData> showingGroups() => List.generate(_list.length, (i) {
        return makeGroupData(0, _list[i].count.toDouble(),
            isTouched: i == touchedIndex);
      });
}
