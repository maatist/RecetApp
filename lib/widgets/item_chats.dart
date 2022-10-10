import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:RecetApp/screens/screens.dart';

class ItemChats extends StatelessWidget {
  final String avatar;
  final int chat;
  final String message;
  final String time;
  ItemChats({
    required this.avatar,
    required this.chat,
    required this.message,
    required this.time,
  });
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          chat == 0 ? MainAxisAlignment.end : MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        chat == 1
            ? Avatar(
                image: avatar,
                size: 50,
              )
            : Text(
                '$time',
                style: TextStyle(color: Colors.grey.shade400),
              ),
        Flexible(
          child: Container(
            margin: EdgeInsets.only(left: 10, right: 10, top: 20),
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
                color:
                    chat == 0 ? Colors.indigo.shade100 : Colors.indigo.shade50,
                borderRadius: chat == 0
                    ? BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                        bottomLeft: Radius.circular(30),
                      )
                    : BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      )),
            child: Text('$message'),
          ),
        ),
        chat == 1
            ? Text(
                '$time',
                style: TextStyle(color: Colors.grey.shade400),
              )
            : SizedBox()
      ],
    );
  }
}
