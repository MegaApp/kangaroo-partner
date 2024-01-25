import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kenguroo_partner/order/order.dart';
import 'package:kenguroo_partner/repositories/api_repository.dart';
import 'package:kenguroo_partner/search/search.dart';
import 'package:kenguroo_partner/models/models.dart';
import '../extentions.dart';

class SearchForm extends StatefulWidget {
  @override
  State<SearchForm> createState() => _SearchFormState();
}

class _SearchFormState extends State<SearchForm> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<SearchBloc, SearchState>(
      listener: (context, state) {
        if (state is SearchFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${state.error}'),
              backgroundColor: Colors.red,
            ),
          );
        }

        if (state is SearchDidCleanHistory) {
          BlocProvider.of<SearchBloc>(context).add(SearchTextDidChange(text: ''));
        }
      },
      child: BlocBuilder<SearchBloc, SearchState>(
        builder: (context, state) {
          return Padding(
              padding: EdgeInsets.all(16),
              child: Scaffold(
                appBar: AppBar(
                    title: TextField(
                      controller: _editingController,
                      style: new TextStyle(
                        color: HexColor.fromHex('#0C270F'),
                      ),
                      decoration: new InputDecoration(
                          border: InputBorder.none,
                          hintText: "Найти",
                          hintStyle: new TextStyle(color: HexColor.fromHex('#D7D7D7'))),
                      onChanged: (text) {
                        BlocProvider.of<SearchBloc>(context).add(SearchTextDidChange(text: text));
                      },
                    ),
                    leading: Icon(Icons.search, color: HexColor.fromHex('#0C270F')),
                    actions: <Widget>[
                      _editingController.text.isEmpty
                          ? Container()
                          : IconButton(
                              icon: Icon(
                                Icons.close,
                                color: HexColor.fromHex('#0C270F'),
                              ),
                              onPressed: () {
                                _editingController.clear();
                                BlocProvider.of<SearchBloc>(context).add(SearchTextDidChange(text: ''));
                              },
                            ),
                    ]),
                backgroundColor: state is SearchHistoryOrderLoaded ? Colors.white : HexColor.fromHex('#F3F6F9'),
                body: SafeArea(child: rootWidget(state)),
              ));
        },
      ),
    );
  }

  void onTapItem(BuildContext context, Order? order) {
    if (order == null) return;
    BlocProvider.of<SearchBloc>(context).add(SearchAddToHistory(orderId: order.id));
    ApiRepository repository = BlocProvider.of<SearchBloc>(context).apiRepository;
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
      padding: const EdgeInsets.only(top: 16, bottom: 16),
      itemBuilder: (context, position) {
        Order _order = orders[position];
        return GestureDetector(child: buildListItem(_order), onTap: () => onTapItem(context, _order));
      },
    );
  }

  Widget listViewWithSectionWidget(List<OrderSection> orders) {
    List<ListItem> items = List.empty(growable: true);

    orders.forEach((i) {
      items.add(HeadingItem(i.time));
      i.items.forEach((o) {
        items.add(MessageItem(o));
      });
    });

    return ListView(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 24.0),
          child: Text(
            'История поиска',
            style: TextStyle(color: HexColor.fromHex('#0C270F'), fontSize: 21, fontWeight: FontWeight.bold),
          ),
        ),
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: items.length,
          padding: const EdgeInsets.only(top: 16.0, bottom: 16),
          itemBuilder: (context, position) {
            final orderSection = items[position];
            Order? _order = orderSection is MessageItem ? orderSection.order : null;
            return GestureDetector(
                child: Container(
                  color: Colors.white,
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[orderSection.buildTitle(context), orderSection.buildSubtitle(context)],
                      ),
                      orderSection.buildLine(context)
                    ],
                  ),
                ),
                onTap: () => onTapItem(context, _order));
          },
        ),
        Container(
          margin: const EdgeInsets.only(top: 40.0, left: 64, right: 64),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(40.0),
              border: Border.all(color: Colors.red, width: 2)),
          padding: EdgeInsets.only(top: 16, bottom: 16, right: 48, left: 48),
          child: TextButton(
            onPressed: () {
              BlocProvider.of<SearchBloc>(context).add(SearchClearHistory());
            },
            child: Text(
              'Очистить историю',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.red),
            ),
          ),
        )
      ],
    );
  }

  Widget rootWidget(SearchState state) {
    if (state is SearchLoading) return Center(child: CircularProgressIndicator());
    if (state is SearchOrderLoaded) if (state.orders.length > 0) return listViewWidget(state.orders);
    if (state is SearchHistoryOrderLoaded) if (state.orders.length > 0) return listViewWithSectionWidget(state.orders);
    if (state is SearchInitial) BlocProvider.of<SearchBloc>(context).add(SearchTextDidChange(text: ''));
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
          padding: const EdgeInsets.only(right: 64, left: 64, top: 66),
          child: Text(
            'Пока нет результатов. Воспользуйтесь поиском',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 21, color: HexColor.fromHex('#E0E0E0'), fontWeight: FontWeight.bold),
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
          decoration: new BoxDecoration(color: Colors.white, borderRadius: new BorderRadius.all(Radius.circular(18.0))),
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
                          style: TextStyle(color: HexColor.fromHex('#869FB1'), fontSize: 13),
                        ),
                        const Padding(padding: EdgeInsets.all(8)),
                        Text(
                          '${_order.number}',
                          style:
                              TextStyle(color: HexColor.fromHex('#0C270F'), fontSize: 21, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Блюда', style: TextStyle(color: HexColor.fromHex('#869FB1'), fontSize: 13)),
                        const Padding(padding: EdgeInsets.all(8)),
                        Text('${_order.itemsCount}',
                            style: TextStyle(
                                color: HexColor.fromHex('#0C270F'), fontSize: 21, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Время выдачи', style: TextStyle(color: HexColor.fromHex('#869FB1'), fontSize: 13)),
                        const Padding(padding: EdgeInsets.all(8)),
                        Text(_order.orderedAt,
                            style: TextStyle(
                                color: HexColor.fromHex('#0C270F'), fontSize: 21, fontWeight: FontWeight.bold)),
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
                  : (_order.status == 'Готовится' ? 'assets/green-corn.png' : 'assets/red-corn.png')),
              width: 21),
        ),
      ],
    );
  }

  final TextEditingController _editingController = TextEditingController();
}

abstract class ListItem {
  Widget buildTitle(BuildContext context);

  Widget buildSubtitle(BuildContext context);

  Widget buildLine(BuildContext context);
}

class HeadingItem implements ListItem {
  final String heading;

  HeadingItem(this.heading);

  Widget buildTitle(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 32.0, bottom: 16),
      child: Text(
        heading,
        style: TextStyle(color: HexColor.fromHex('#0C270F'), fontSize: 13),
      ),
    );
  }

  Widget buildSubtitle(BuildContext context) => Container();

  @override
  Widget buildLine(BuildContext context) => Container();
}

class MessageItem implements ListItem {
  final Order order;

  MessageItem(this.order);

  Widget buildTitle(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 16.0, bottom: 16),
        child: Text(order.driver,
            style: TextStyle(color: HexColor.fromHex('#0C270F'), fontSize: 16, fontWeight: FontWeight.w300)),
      );

  Widget buildSubtitle(BuildContext context) =>
      Text('${order.number}', style: TextStyle(color: HexColor.fromHex('#0C270F'), fontSize: 16));

  @override
  Widget buildLine(BuildContext context) => Divider(height: 1);
}
