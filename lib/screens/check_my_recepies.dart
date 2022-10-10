import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:RecetApp/screens/screens.dart';
import 'package:RecetApp/services/services.dart';
import 'package:provider/provider.dart';

class CheckMyRecepiesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final recepiesService =
        Provider.of<RecepiesService>(context, listen: false);

    return Scaffold(
      body: Center(
        child: FutureBuilder(
          future: recepiesService.readToken(),
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            if (!snapshot.hasData)
              return CircularProgressIndicator(
                color: Colors.white,
              );

            if (snapshot.data == '') {
              Future.microtask(() {
                Navigator.of(context).push(
                  PageTransition(
                      child: MyRecepiesScreen(),
                      type: PageTransitionType.fade,
                      duration: Duration(milliseconds: 1000)),
                );
              });
            } else {
              Future.microtask(() {
                Navigator.of(context).push(
                  PageTransition(
                      child: MyRecepiesScreen(),
                      type: PageTransitionType.fade,
                      duration: Duration(milliseconds: 1000)),
                );
              });
            }
            return Container();
          },
        ),
      ),
    );
  }
}
