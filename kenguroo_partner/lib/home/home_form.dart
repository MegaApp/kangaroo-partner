import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kenguroo_partner/extentions.dart';
import 'package:flutter/material.dart';
import 'package:kenguroo_partner/home/home.dart';
import 'package:kenguroo_partner/store/store.dart';

class HomeForm extends StatefulWidget {
  @override
  _HomeFormState createState() => _HomeFormState();
}

class _HomeFormState extends State<HomeForm> {
  int _selectedIndex = 0;

  _onItemTapped(int index) {
    _selectedIndex = index;
    BlocProvider.of<HomeBloc>(context)
        .add(HomeNavBottomItemClicked(index: index));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeBloc, HomeState>(listener: (context, state) {
      if (state is HomeFailure) {
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text('${state.error}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }, child: BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
      return Scaffold(
        backgroundColor: HexColor.fromHex('#F3F6F9'),
        body: rootWidget(context, state),
        bottomNavigationBar: _bottomNavigationBar(),
      );
    }));
  }

  Widget rootWidget(BuildContext context, HomeState state) {
    if (state is HomeShowSearch) {
      return Center(child: Text('HomeShowSearch'));
    }

    if (state is HomeShowStatistic) {
      return Center(child: Text('HomeShowStatistic'));
    }

    if (state is HomeShowProfile) {
      return Center(child: Text('HomeShowProfile'));
    }
    return StorePage(
        userRepository: BlocProvider.of<HomeBloc>(context).apiRepository);
  }

  Widget _bottomNavigationBar() => BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.room_service),
            title: Text('Users'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            title: Text('Ads'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.timeline),
            title: Text('Ads'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: Text('Ads'),
          )
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Theme.of(context).accentColor,
      );
}
