import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          child: new Stack(
            children: <Widget>[
              new Positioned(
                  child: new Align(
                alignment: FractionalOffset.center,
                child:
                    Image(image: AssetImage('assets/app-icon.png'), width: 140),
              )),
              new Positioned(
                child: new Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 60),
                    child: SizedBox(
                        width: double.infinity,
                        height: 4,
                        child: LinearProgressIndicator(
                          backgroundColor: Color.fromRGBO(242, 242, 242, 1),
                        )),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
