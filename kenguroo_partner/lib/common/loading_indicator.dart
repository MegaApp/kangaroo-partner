import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: <Widget>[
            Positioned(
                child: Align(
              alignment: FractionalOffset.center,
              child: Image(image: AssetImage('assets/app-icon.png'), width: 140),
            )),
            Positioned(
              child: Align(
                alignment: FractionalOffset.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16, 0, 16, 60),
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
        ));
  }
}
