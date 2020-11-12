import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kenguroo_partner/menu/menu.dart';
import 'package:kenguroo_partner/models/models.dart';
import '../extentions.dart';

class MenuForm extends StatefulWidget {
  @override
  State<MenuForm> createState() => _MenuFormState();
}

class _MenuFormState extends State<MenuForm> {
  @override
  Widget build(BuildContext context) {
    _getMenu() {
      BlocProvider.of<MenuBloc>(context).add(MenuGetList());
    }

    _onTapItem(BuildContext context, Menu menu) {
      BlocProvider.of<MenuBloc>(context)
          .add(MenuActivation(active: menu.active, id: menu.id));
    }

    _listViewWidget(List<Menu> orders) {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: orders.length,
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (context, position) {
          Menu _menu = orders[position];
          return GestureDetector(
              child: Column(
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
                          style: TextStyle(
                              fontSize: 16, color: HexColor.fromHex('#0C270F')),
                        ),
                      )),
                      // Image(
                      //     image: AssetImage(_menu.active
                      //         ? 'assets/close.png'
                      //         : 'assets/open.png'),
                      //     width: 24),
                      Checkbox(
                        value: _menu.active,
                        onChanged: (bool value) {
                          setState(() {
                            _onTapItem(context, _menu);
                            _menu.active = value;
                          });
                        },
                      ),
                    ],
                  ),
                  Divider(),
                ],
              ),
              onTap: () => _onTapItem(context, _menu));
        },
      );
    }

    _rootWidget(MenuState state) {
      if (state is MenuLoading)
        return Center(child: CircularProgressIndicator());
      if (state is MenuLoaded) if (state.menu.length > 0)
        return _listViewWidget(state.menu);
      if (state is MenuInitial) _getMenu();
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image(
            image: AssetImage('assets/ic-plh.png'),
            width: 120,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 80, left: 80, top: 66),
            child: Text(
              'Пока нет результатов',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 21,
                  color: HexColor.fromHex('#E0E0E0'),
                  fontWeight: FontWeight.bold),
            ),
          )
        ],
      );
    }

    return BlocListener<MenuBloc, MenuState>(
      listener: (context, state) {
        if (state is MenuFailure) {
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text('${state.error}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: BlocBuilder<MenuBloc, MenuState>(
        builder: (context, state) {
          return SafeArea(
            child: _rootWidget(state),
          );
        },
      ),
    );
  }
}
