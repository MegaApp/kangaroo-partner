import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kenguroo_partner/extentions.dart';
import 'package:kenguroo_partner/models/models.dart';
import 'package:kenguroo_partner/profile/profile.dart';

class ProfileForm extends StatefulWidget {
  ProfileForm({Key key}) : super(key: key);

  @override
  State<ProfileForm> createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  Profile _profile;

  _menuNeedChanges() => () {
        Navigator.of(context).pop();
        BlocProvider.of<ProfileBloc>(context).add(ProfileMenuChanged());
      };

  _logOutAction() => () {
        BlocProvider.of<ProfileBloc>(context).add(ProfileLoggedOut());
      };

  void showMenuChangedDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0)),
            child: Stack(
              alignment: Alignment.topRight,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                Container(
                  padding: const EdgeInsets.all(32.0),
                  height: 331,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.room_service,
                        color: Theme.of(context).accentColor,
                        size: 56,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Text(
                          'Есть ли изменения по меню',
                          style: TextStyle(
                              color: HexColor.fromHex('#222831'),
                              fontSize: 19,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      const Padding(
                        padding: const EdgeInsets.only(bottom: 40),
                      ),
                      SizedBox(
                        height: 56,
                        width: double.infinity,
                        child: FlatButton(
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(40.0),
                              side: BorderSide(
                                  color: HexColor.fromHex('#3FC64F'))),
                          onPressed: _menuNeedChanges(),
                          color: HexColor.fromHex('#3FC64F'),
                          textColor: Colors.white,
                          child: Text("Да",
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      const Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                      ),
                      SizedBox(
                        height: 56,
                        width: double.infinity,
                        child: FlatButton(
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(40.0),
                              side: BorderSide(
                                  color: HexColor.fromHex('#3FC64F'))),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          color: HexColor.fromHex('#3FC64F'),
                          textColor: Colors.white,
                          child: Text("Нет",
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }

  void showDoneDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0)),
            child: Stack(
              alignment: Alignment.topRight,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                Container(
                  padding: const EdgeInsets.all(32.0),
                  height: 315,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.room_service,
                        color: Theme.of(context).accentColor,
                        size: 56,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Text(
                          'Благодарим вас',
                          style: TextStyle(
                              color: HexColor.fromHex('#222831'),
                              fontSize: 21,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16, bottom: 40),
                        child: Text(
                          'В ближайшее время с вами свяжется наш менеджер',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: HexColor.fromHex('#CCCCCC'), fontSize: 16),
                        ),
                      ),
                      SizedBox(
                        height: 56,
                        width: double.infinity,
                        child: FlatButton(
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(40.0),
                              side: BorderSide(
                                  color: HexColor.fromHex('#3FC64F'))),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          color: HexColor.fromHex('#3FC64F'),
                          textColor: Colors.white,
                          child: Text("Готово",
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.bold)),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is ProfileFailure) {
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text('${state.error}'),
              backgroundColor: Colors.red,
            ),
          );
        }

        if (state is ProfileDidGet) {
          _profile = state.profile;
        }

        if (state is ProfileShowDialog) {
          showDoneDialog();
        }
      },
      child: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is ProfileInitial && _profile == null)
            BlocProvider.of<ProfileBloc>(context).add(ProfileGet());
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Stack(
                children: <Widget>[
                  (state is ProfileLoading)
                      ? Center(child: CircularProgressIndicator())
                      : Container(),
                  Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: CircleAvatar(
                          radius: 40.0,
                          backgroundImage: NetworkImage((_profile != null)
                              ? _profile.image
                              : 'https://via.placeholder.com/150'),
                          backgroundColor: Colors.transparent,
                        ),
                      ),
                      Text(
                        (_profile != null) ? _profile.name : 'Не указан',
                        style: TextStyle(
                            fontSize: 21,
                            color: HexColor.fromHex('#0C270F'),
                            fontWeight: FontWeight.bold),
                      ),
                      const Padding(
                        padding: const EdgeInsets.only(top: 32.0),
                      ),
                      GestureDetector(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Image(
                                image: AssetImage('assets/ic_food.png'),
                                width: 24),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                'Внести правки в меню',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: HexColor.fromHex('#0C270F')),
                              ),
                            )
                          ],
                        ),
                        onTap: () {
                          showMenuChangedDialog();
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 40),
                        child: Divider(),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Image(
                              image: AssetImage('assets/ic_pin.png'),
                              width: 24),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              'Добавить филиал',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: HexColor.fromHex('#0C270F')),
                            ),
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 40),
                        child: Divider(),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Image(
                              image: AssetImage('assets/ic_alert_triangle.png'),
                              width: 24),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              'Служба поддержки',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: HexColor.fromHex('#0C270F')),
                            ),
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 40),
                        child: Divider(),
                      ),
                      GestureDetector(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Image(
                                image: AssetImage('assets/ic_exit.png'),
                                width: 24),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                'Выйти',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: HexColor.fromHex('#0C270F')),
                              ),
                            )
                          ],
                        ),
                        onTap: _logOutAction(),
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
}
