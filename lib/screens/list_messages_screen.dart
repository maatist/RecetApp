import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:RecetApp/screens/screens.dart';
import 'package:RecetApp/widgets/item_chats.dart';

class ListMessagesScreen extends StatefulWidget {
  @override
  State<ListMessagesScreen> createState() => _ListMessagesScreenState();
}

class _ListMessagesScreenState extends State<ListMessagesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('RecetApp'),
        leading: IconButton(
          icon: Icon(Icons.home_outlined),
          onPressed: () {
            Navigator.of(context).push(PageTransition(
                child: HomeScreen(),
                type: PageTransitionType.leftToRight,
                childCurrent: ListMessagesScreen()));
          },
        ),
      ),
      backgroundColor: Colors.indigo,
      body: Column(
        children: [
          _top(),
          _body(),
        ],
      ),
    );
  }

  Widget _top() {
    return Container(
      padding: EdgeInsets.only(top: 30, left: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Chatea con tus amigos!',
            style: TextStyle(
                fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.black12,
                ),
                child: Icon(
                  Icons.search,
                  size: 30,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                  child: Container(
                height: 120,
                child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: 7,
                  itemBuilder: (context, index) {
                    return Avatar(
                      margin: EdgeInsets.only(right: 15),
                      image: 'assets/retratos/${index + 2}.jpg',
                    );
                  },
                ),
              ))
            ],
          )
        ],
      ),
    );
  }

  Widget _body() {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 30),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(45),
            topRight: Radius.circular(45),
          ),
          color: Colors.white,
        ),
        child: ListView(
          padding: EdgeInsets.only(top: 35),
          physics: BouncingScrollPhysics(),
          children: [
            _itemChats(
                avatar: 'assets/retratos/2.jpg',
                name: 'Juan Martinez',
                chat:
                    'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
                time: '21:50'),
            _itemChats(
                avatar: 'assets/retratos/3.jpg',
                name: 'Lorena Alvarado',
                chat:
                    'Look again at that dot. Thats here. Thats home. Thats us.',
                time: '21:50'),
            _itemChats(
                avatar: 'assets/retratos/5.jpg',
                name: 'Javiera Farias',
                chat: 'The Earth is a very small stage in a vast cosmic arena.',
                time: '21:50'),
            _itemChats(
                avatar: 'assets/retratos/4.jpg',
                name: 'Martin Donoso',
                chat:
                    'Our posturings, our imagined self-importance, the delusion that we have some privileged position in the Universe, are challenged',
                time: '21:50'),
            _itemChats(
                avatar: 'assets/retratos/6.jpg',
                name: 'Pilar Martinez',
                chat:
                    'The Earth is the only world known so far to harbor life.',
                time: '21:50'),
            _itemChats(
                avatar: 'assets/retratos/7.jpg',
                name: 'Emilia Rojas',
                chat:
                    'It has been said that astronomy is a humbling and character-building experience. There is perhaps no better demonstration of the folly of human conceits than this distant image of our tiny world.',
                time: '21:50'),
            _itemChats(
                avatar: 'assets/retratos/8.jpg',
                name: 'Fernando Martinez',
                chat:
                    'I believe that space travel will one day become as common as airline travel is today.',
                time: '21:50'),
          ],
        ),
      ),
    );
  }

  Widget _itemChats(
      {String avatar = '', name = '', chat = '', time = '00.00'}) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(PageTransition(
            child: ChatScreen(),
            type: PageTransitionType.rightToLeft,
            childCurrent: ListMessagesScreen()));
      },
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 20),
        elevation: 0,
        child: Row(
          children: [
            Avatar(
              margin: EdgeInsets.only(right: 20),
              size: 60,
              image: avatar,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '$name',
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '$time',
                        style: TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    '$chat',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Colors.black54, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class Avatar extends StatelessWidget {
  final double size;
  final image;
  final EdgeInsets margin;
  Avatar({this.image, this.size = 50, this.margin = const EdgeInsets.all(0)});
  Widget build(BuildContext context) {
    return Padding(
      padding: margin,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            image:
                DecorationImage(image: AssetImage(image), fit: BoxFit.cover)),
      ),
    );
  }
}
