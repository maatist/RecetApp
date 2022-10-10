import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:RecetApp/screens/screens.dart';
import 'package:RecetApp/services/services.dart';
import 'package:provider/provider.dart';

class NumbersWidget extends StatelessWidget {
  final int cantRecetas;
  final int cantSeguidores;
  final int cantSeguidos;
  NumbersWidget(this.cantRecetas, this.cantSeguidores, this.cantSeguidos);

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          buildDivider(),
          buildButton(text: 'Recetas', value: cantRecetas, context: context),
          buildDivider(),
          buildButton(
              text: 'Seguidores', value: cantSeguidores, context: context),
          buildDivider(),
          buildButton(text: 'Seguidos', value: cantSeguidos, context: context),
        ],
      );
}

Widget buildDivider() => Container(
      height: 24,
      child: VerticalDivider(),
    );

Widget buildButton({
  required String text,
  required int value,
  required BuildContext context,
}) =>
    MaterialButton(
      padding: EdgeInsets.symmetric(vertical: 4),
      onPressed: () {
        if (text.toString() == 'Recetas') {
          Navigator.of(context).push(PageTransition(
              child: CheckMyRecepiesScreen(),
              type: PageTransitionType.rightToLeft,
              childCurrent: NumbersWidget(1, 2, 3)));
        }
      },
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(
            '$value',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 24),
          ),
          SizedBox(
            height: 2,
          ),
          Text(
            text,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
          )
        ],
      ),
    );
