import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kenguroo_partner/password/password.dart';

class PasswordForm extends StatefulWidget {
  @override
  State<PasswordForm> createState() => _PasswordFormState();
}

class _PasswordFormState extends State<PasswordForm> {
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _onReadyButtonPressed() {
      FocusScopeNode currentFocus = FocusScope.of(context);
      if (!currentFocus.hasPrimaryFocus) {
        currentFocus.unfocus();
      }
      BlocProvider.of<PasswordBloc>(context).add(
        PasswordButtonPressed(
          password: _passwordController.text,
        ),
      );
    }

    return BlocListener<PasswordBloc, PasswordState>(
      listener: (context, state) {
        if (state is PasswordFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${state.error}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: BlocBuilder<PasswordBloc, PasswordState>(
        builder: (context, state) {
          return SafeArea(
            child: Stack(
              children: [
                Align(
                  alignment: FractionalOffset.topRight,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0, right: 8),
                    child: TextButton(
                      onPressed: _onReadyButtonPressed,
                      child: Text(
                        "Готово",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: FractionalOffset.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 100.0, left: 16, right: 16),
                    child: Text(
                      "Создайте пароль",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 29),
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
                            hintText: 'Введите новый пароль',
                            hintStyle: TextStyle(color: Colors.white30)),
                        controller: _confirmPasswordController,
                        style: TextStyle(color: Colors.white, fontSize: 29),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16, right: 16),
                      child: TextField(
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Повторите пароль',
                            hintStyle: TextStyle(color: Colors.white30)),
                        controller: _passwordController,
                        style: TextStyle(color: Colors.white, fontSize: 29),
                      ),
                    ),
                  ],
                ),
                Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: state is PasswordLoading
                        ? Padding(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 60),
                            child: SizedBox(
                                width: double.infinity,
                                height: 4,
                                child: LinearProgressIndicator(
                                  backgroundColor: Color.fromRGBO(242, 242, 242, 1),
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
