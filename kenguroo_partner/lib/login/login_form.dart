import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kenguroo_partner/login/login.dart';

class LoginForm extends StatefulWidget {
  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _onLoginButtonPressed() {
      FocusScopeNode currentFocus = FocusScope.of(context);
      if (!currentFocus.hasPrimaryFocus) {
        currentFocus.unfocus();
      }
      BlocProvider.of<LoginBloc>(context).add(
        LoginButtonPressed(
          username: _usernameController.text,
          password: _passwordController.text,
        ),
      );
    }

    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginFailure) {
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text('${state.error}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          return SafeArea(
            child: Stack(
              children: [
                Align(
                  alignment: FractionalOffset.topRight,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0, right: 8),
                    child: FlatButton(
                      onPressed: _onLoginButtonPressed,
                      child: Text(
                        "Далее",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: FractionalOffset.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 100.0),
                    child: Image(
                      image: AssetImage('assets/logo.png'),
                      width: 140,
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 16, right: 16),
                      child: TextField(
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Введите ваш логин',
                            hintStyle: TextStyle(color: Colors.white30)),
                        controller: _usernameController,
                        style: TextStyle(color: Colors.white, fontSize: 29),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16, right: 16),
                      child: TextField(
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Введите ваш пароль',
                            hintStyle: TextStyle(color: Colors.white30)),
                        controller: _passwordController,
                        style: TextStyle(color: Colors.white, fontSize: 29),
                      ),
                    ),
                  ],
                ),
                Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: state is LoginLoading
                        ? Padding(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 60),
                            child: SizedBox(
                                width: double.infinity,
                                height: 4,
                                child: LinearProgressIndicator(
                                  backgroundColor:
                                      Color.fromRGBO(242, 242, 242, 1),
                                )),
                          )
                        : null)
              ],
            ),
          );
        },
      ),
    );
  }
}
