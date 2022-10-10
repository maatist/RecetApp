import 'package:flutter/material.dart';

class AuthBackground extends StatelessWidget {
  final Widget child;

  AuthBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      //color: Colors.red,
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: [
          _PurpleBox(),
          _HeaderIcon(),
          child,
        ],
      ),
    );
  }
}

class _HeaderIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          SizedBox(
            height: 30,
          ),
          Align(
            child: Text(
              'Bienvenido a RecetApp!',
              style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  color: Colors.white),
            ),
          ),
          Container(
            width: double.infinity,
            margin: EdgeInsets.only(top: 30),
            child: Icon(Icons.restaurant_menu, color: Colors.white, size: 100),
          )
        ],
      ),
    );
  }
}

class _PurpleBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      width: double.infinity,
      height: size.height * 0.4,
      decoration: _purpleBackground(),
      child: Stack(
        children: [
          Positioned(top: 90, left: 30, child: _Bubble()),
          Positioned(top: -30, left: -20, child: _Bubble()),
          Positioned(bottom: -40, right: 30, child: _Bubble()),
          Positioned(bottom: 110, right: 70, child: _Bubble()),
          Positioned(bottom: -10, left: 30, child: _Bubble()),
        ],
      ),
    );
  }
}

BoxDecoration _purpleBackground() {
  return BoxDecoration(
      gradient: LinearGradient(colors: [
    Color.fromRGBO(63, 63, 156, 1),
    Color.fromRGBO(90, 70, 178, 1)
  ]));
}

class _Bubble extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: Color.fromRGBO(255, 255, 255, 0.05)),
    );
  }
}
