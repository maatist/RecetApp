import 'package:flutter/material.dart';

class MyRecipeCard extends StatelessWidget {
  final String title;
  final int likes;
  final int cookTime;
  final String thumbnailUrl;
  MyRecipeCard({
    required this.title,
    required this.cookTime,
    required this.likes,
    required this.thumbnailUrl,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 30, 10, 10),
      width: MediaQuery.of(context).size.width,
      height: 250,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.6),
            offset: Offset(
              0.0,
              10.0,
            ),
            blurRadius: 10.0,
            spreadRadius: -6.0,
          ),
        ],
        image: thumbnailUrl.contains('assets')
            ? DecorationImage(
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.35),
                  BlendMode.multiply,
                ),
                image: AssetImage('assets/no-image.png'),
                fit: BoxFit.cover,
              )
            : DecorationImage(
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.35),
                  BlendMode.multiply,
                ),
                image: NetworkImage(thumbnailUrl),
                fit: BoxFit.cover,
              ),
      ),
      child: Stack(
        children: [
          Align(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 10),
              child: Text(
                title,
                style: TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                textAlign: TextAlign.center,
              ),
            ),
            alignment: Alignment.topCenter,
          ),
          Align(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.all(5),
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.favorite,
                        color: Colors.red,
                        size: 18,
                      ),
                      SizedBox(width: 7),
                      Text(
                        likes.toString(),
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(5),
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.schedule,
                        color: Colors.yellow,
                        size: 18,
                      ),
                      SizedBox(width: 7),
                      Text(cookTime.toString() + ' min',
                          style: TextStyle(color: Colors.white)),
                    ],
                  ),
                )
              ],
            ),
            alignment: Alignment.bottomLeft,
          ),
        ],
      ),
    );
  }
}
