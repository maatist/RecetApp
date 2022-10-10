import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:page_transition/page_transition.dart';
import 'package:RecetApp/screens/screens.dart';

class RecepieAuthorHeader extends StatelessWidget {
  final String nombreUsuario;
  final String fechaCreacionPublicacion;
  final String pathFotoPerfil;
  final String id_usuario;
  final String loggedUser;
  const RecepieAuthorHeader({
    super.key,
    required this.id_usuario,
    required this.nombreUsuario,
    required this.pathFotoPerfil,
    required this.loggedUser,
    required this.fechaCreacionPublicacion,
  });
  @override
  Widget build(BuildContext context) {
    final double profileHeight = 144;
    final storage = new FlutterSecureStorage();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      width: MediaQuery.of(context).size.width,
      height: 60,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    loggedUser == id_usuario
                        ? Navigator.of(context).push(PageTransition(
                            child: ProfileScreen(),
                            type: PageTransitionType.leftToRight,
                            childCurrent: HomeScreen()))
                        : Navigator.of(context).push(PageTransition(
                            child: OtherProfileScreen(usuario: id_usuario),
                            type: PageTransitionType.leftToRight,
                            childCurrent: HomeScreen()));
                  },
                  child: CircleAvatar(
                    radius: profileHeight / 2 - 40,
                    backgroundColor: Colors.grey.shade800,
                    backgroundImage: NetworkImage(pathFotoPerfil),
                  ),
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(1),
                    backgroundColor: Colors.blue, // <-- Button color
                    foregroundColor: Colors.red, // <-- Splash color
                  ),
                )
                // ignore: prefer_const_literals_to_create_immutables
                /* children: [
                    const Icon(
                      Icons.favorite,
                      color: Colors.red,
                      size: 18,
                    ),
                    const SizedBox(width: 7),
                    const Text(
                      'asdasdas',
                      style: TextStyle(color: Colors.black),
                    ),
                  ], */
              ],
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10),
              child: Text(
                nombreUsuario,
                style: const TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10),
                child: Column(
                  children: [
                    Text(
                      fechaCreacionPublicacion.split(' ')[0],
                      style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.w300),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      fechaCreacionPublicacion.split(' ')[1].split('.')[0],
                      style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                          fontWeight: FontWeight.w300),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                    ),
                  ],
                )),
          ),
        ],
      ),
    );
  }
}
