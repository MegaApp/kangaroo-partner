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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor.fromHex('#F3F6F9'),
      body: StorePage(
          userRepository: BlocProvider.of<HomeBloc>(context).apiRepository),
      bottomNavigationBar: _bottomNavigationBar(0),
    );
  }

  Widget _bottomNavigationBar(int selectedIndex) => BottomNavigationBar(
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
        currentIndex: selectedIndex,
        selectedItemColor: Theme.of(context).accentColor,
      );
}
