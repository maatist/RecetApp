import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:RecetApp/screens/screens.dart';
import 'package:RecetApp/widgets/item_chats.dart';

class ChatScreen extends StatefulWidget {
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat con Lorena'),
        leading: IconButton(
          icon: Icon(Icons.message),
          onPressed: () {
            Navigator.of(context).push(PageTransition(
                child: ListMessagesScreen(),
                type: PageTransitionType.leftToRight,
                childCurrent: ChatScreen()));
          },
        ),
      ),
      backgroundColor: Colors.indigo,
      body: /* SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: MediaQuery.of(context).size.width,
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: IntrinsicHeight(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Column(
                    children: [
                      _bodyChat(),
                    ],
                  ),
                  SafeArea(child: _formChat()),
                ],
              ),
            ),
          ),
        ) */

          Stack(
        children: [
          Column(
            children: [
              _bodyChat(),
            ],
          ),
          _formChat(),
        ],
      ),
    );
  }

  Widget _bodyChat() {
    return Expanded(
      child: Container(
          padding: EdgeInsets.only(left: 25, right: 25, top: 25),
          margin: EdgeInsets.only(top: 10),
          width: double.infinity,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(45), topRight: Radius.circular(45)),
              color: Colors.white),
          child: ListView(
            physics: BouncingScrollPhysics(),
            children: [
              ItemChats(
                  avatar: 'assets/retratos/5.jpg',
                  chat: 1,
                  message:
                      'There is no strife, no prejudice, no national conflict in outer space as yet.',
                  time: '09.20'),
              ItemChats(
                  avatar: 'assets/retratos/5.jpg',
                  chat: 0,
                  message: 'Its hazards are hostile to us all.',
                  time: '09.22'),
              ItemChats(
                  avatar: 'assets/retratos/5.jpg',
                  chat: 1,
                  message:
                      'Why choose this as our goal? And they may well ask why climb the highest mountain?',
                  time: '09.25'),
            ],
          )),
    );
  }

  Widget _formChat() {
    return Positioned(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          height: 120,
          padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
          child: TextField(
            decoration: InputDecoration(
                hintText: 'Escribe tu mensaje aca...',
                filled: true,
                fillColor: Colors.indigo.shade100,
                labelStyle: TextStyle(fontSize: 12),
                contentPadding: EdgeInsets.all(20),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.indigo.shade100),
                  borderRadius: BorderRadius.circular(25),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.indigo.shade100),
                  borderRadius: BorderRadius.circular(25),
                ),
                suffixIcon: Container(
                  padding: EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.indigo,
                  ),
                  child: Icon(
                    Icons.send_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
                )),
          ),
        ),
      ),
    );
  }
}
