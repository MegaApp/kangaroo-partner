import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kenguroo_partner/authentication/authentication.dart';
import 'package:kenguroo_partner/extentions.dart';

//class HomePage extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        title: Text('Home'),
//      ),
//      body: Column(
//        children: <Widget>[
//          RaisedButton(
//            child: Text('logout'),
//            onPressed: () {
//              BlocProvider.of<AuthenticationBloc>(context).add(LoggedOut());
//            },
//          ),
//        ],
//      ),
//    );
//  }
//}

class HomePage extends StatefulWidget {
  static const String routeName = 'cupertino/segmented_control';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Map<int, Widget> children = const <int, Widget>{
    0: Text('Новые'),
    1: Text('Готовится'),
    2: Text('Ожидает'),
  };

  final Map<int, Widget> icons = <int, Widget>{
    0: ListView(
      shrinkWrap: true,
      padding: const EdgeInsets.all(16.0),
      children: <Widget>[
        Stack(
          children: <Widget>[
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
              ),
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
                              style: TextStyle(
                                  color: HexColor.fromHex('#869FB1'), fontSize: 13),
                            ),
                            const Padding(padding: EdgeInsets.all(8)),
                            Text(
                              '67266',
                              style: TextStyle(
                                  color: HexColor.fromHex('#0C270F'),
                                  fontSize: 21,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text('Блюда',
                                style: TextStyle(
                                    color: HexColor.fromHex('#869FB1'),
                                    fontSize: 13)),
                            const Padding(padding: EdgeInsets.all(8)),
                            Text('10',
                                style: TextStyle(
                                    color: HexColor.fromHex('#0C270F'),
                                    fontSize: 21,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text('Время выдачи',
                                style: TextStyle(
                                    color: HexColor.fromHex('#869FB1'),
                                    fontSize: 13)),
                            const Padding(padding: EdgeInsets.all(8)),
                            Text('12:44',
                                style: TextStyle(
                                    color: HexColor.fromHex('#0C270F'),
                                    fontSize: 21,
                                    fontWeight: FontWeight.bold)),
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
              child: Image(image: AssetImage('assets/yellow-corn.png'), width: 21),
            ),
          ],
        ),
      ],
    ),
    1: ListView(
      shrinkWrap: true,
      padding: const EdgeInsets.all(16.0),
      children: <Widget>[
        Stack(
          children: <Widget>[
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
              ),
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
                              style: TextStyle(
                                  color: HexColor.fromHex('#869FB1'), fontSize: 13),
                            ),
                            const Padding(padding: EdgeInsets.all(8)),
                            Text(
                              '67266',
                              style: TextStyle(
                                  color: HexColor.fromHex('#0C270F'),
                                  fontSize: 21,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text('Блюда',
                                style: TextStyle(
                                    color: HexColor.fromHex('#869FB1'),
                                    fontSize: 13)),
                            const Padding(padding: EdgeInsets.all(8)),
                            Text('10',
                                style: TextStyle(
                                    color: HexColor.fromHex('#0C270F'),
                                    fontSize: 21,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text('Время выдачи',
                                style: TextStyle(
                                    color: HexColor.fromHex('#869FB1'),
                                    fontSize: 13)),
                            const Padding(padding: EdgeInsets.all(8)),
                            Text('12:44',
                                style: TextStyle(
                                    color: HexColor.fromHex('#0C270F'),
                                    fontSize: 21,
                                    fontWeight: FontWeight.bold)),
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
              child: Image(image: AssetImage('assets/green-corn.png'), width: 21),
            ),
          ],
        ),
      ],
    ),
    2: ListView(
      shrinkWrap: true,
      padding: const EdgeInsets.all(16.0),
      children: <Widget>[
        Stack(
          children: <Widget>[
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
              ),
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
                              style: TextStyle(
                                  color: HexColor.fromHex('#869FB1'), fontSize: 13),
                            ),
                            const Padding(padding: EdgeInsets.all(8)),
                            Text(
                              '67266',
                              style: TextStyle(
                                  color: HexColor.fromHex('#0C270F'),
                                  fontSize: 21,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text('Блюда',
                                style: TextStyle(
                                    color: HexColor.fromHex('#869FB1'),
                                    fontSize: 13)),
                            const Padding(padding: EdgeInsets.all(8)),
                            Text('10',
                                style: TextStyle(
                                    color: HexColor.fromHex('#0C270F'),
                                    fontSize: 21,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text('Время выдачи',
                                style: TextStyle(
                                    color: HexColor.fromHex('#869FB1'),
                                    fontSize: 13)),
                            const Padding(padding: EdgeInsets.all(8)),
                            Text('12:44',
                                style: TextStyle(
                                    color: HexColor.fromHex('#0C270F'),
                                    fontSize: 21,
                                    fontWeight: FontWeight.bold)),
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
              child: Image(image: AssetImage('assets/red-corn.png'), width: 21),
            ),
          ],
        ),
      ],
    ),
  };

  int currentSegment = 0;

  void onValueChanged(int newValue) {
    setState(() {
      currentSegment = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor.fromHex('#E5E5E5'),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            SizedBox(
              width: 500,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: CupertinoSlidingSegmentedControl<int>(
                  backgroundColor: HexColor.fromHex('#E8F0F9'),
                  children: children,
                  onValueChanged: onValueChanged,
                  groupValue: currentSegment,
                ),
              ),
            ),
            icons[currentSegment],
          ],
        ),
      ),
      bottomNavigationBar: _bottomNavigationBar(_selectedIndex),
    );
  }

  int _selectedIndex = 0;

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
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).accentColor,
        onTap: (int index) => setState(() {
          _selectedIndex = index;
        }),
      );
}
