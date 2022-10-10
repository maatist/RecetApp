import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:RecetApp/models/usuario.dart';
import 'package:RecetApp/screens/screens.dart';
import 'package:RecetApp/services/services.dart';
import 'package:RecetApp/widgets/widgets.dart';
import 'package:provider/provider.dart';

class OtherProfileScreen extends StatelessWidget {
  final double coverHeight = 280;
  final double profileHeight = 144;
  final String usuario;
  const OtherProfileScreen({super.key, required this.usuario});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    final followService = Provider.of<FollowService>(context, listen: false);

    final recepiesService = Provider.of<RecepiesService>(context);
    final userService = Provider.of<UserService>(context);

    if (userService.isLoading) return LoadingScreen();

    User user = userService.usuarios
        .firstWhere((u) => u.id_usuario.toString() == usuario.toString());

    final int cantRecetas = recepiesService.otherUserRecepies.length;

    print(recepiesService.otherUserRecepies.length);

    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil de'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.home_outlined),
            tooltip: 'Go to home',
            onPressed: () {
              Navigator.of(context).push(PageTransition(
                  child: HomeScreen(),
                  type: PageTransitionType.rightToLeft,
                  childCurrent: OtherProfileScreen(
                    key: key,
                    usuario: usuario,
                  )));
            },
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          buildTop(user, context),
          buildContent(cantRecetas, user, followService, context),
        ],
      ),
    );
  }

  Stack buildTop(User user, BuildContext context) {
    final bottom = profileHeight / 2;
    final top = coverHeight - profileHeight / 2;
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Container(
            margin: EdgeInsets.only(bottom: bottom),
            child: buildCoverImege(user)),
        Positioned(
          top: top,
          child: buildProfileImage(user),
        ),
        Positioned(
          top: top + 80,
          right: 10,
          child: TextButton(
              onPressed: () {},
              child: Text(
                '  Seguir  ',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.indigo),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: BorderSide(color: Colors.indigo))))),
        )
      ],
    );
  }

  Widget buildCoverImege(User user) => Container(
        color: Colors.grey,
        child: Image.network(
          user.foto_perfil_fondo_path,
          width: double.infinity,
          height: coverHeight,
          fit: BoxFit.cover,
        ),
      );

  Widget buildProfileImage(User user) => CircleAvatar(
        radius: profileHeight / 2,
        backgroundColor: Colors.white,
        child: CircleAvatar(
          radius: profileHeight / 2 - 6,
          backgroundColor: Colors.grey.shade800,
          backgroundImage: NetworkImage(user.foto_perfil_path),
        ),
      );

  Widget buildContent(int cantRecetas, User user, FollowService followService,
          BuildContext context) =>
      Column(
        children: [
          const SizedBox(
            height: 8,
          ),
          Text(
            "${user.primer_nombre} ${user.primer_apellido}",
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            user.id_usuario,
            style: TextStyle(fontSize: 18, color: Colors.black38),
          ),
          const SizedBox(
            height: 16,
          ),
          Divider(),
          const SizedBox(
            height: 16,
          ),
          NumbersWidget(cantRecetas, followService.followersOf.length.toInt(),
              followService.followingOf.length.toInt()),
          const SizedBox(
            height: 16,
          ),
          Divider(),
          const SizedBox(
            height: 16,
          ),
          buildAbout(user.descripcion.toString()),
        ],
      );

  Widget buildAbout(String about) => Padding(
        padding: EdgeInsets.symmetric(horizontal: 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Acerca de mi',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 16,
            ),
            Text(
              about,
              style: TextStyle(fontSize: 18, height: 1.4),
            )
          ],
        ),
      );
}
