import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:RecetApp/models/usuario.dart';
import 'package:RecetApp/screens/screens.dart';
import 'package:RecetApp/services/services.dart';
import 'package:RecetApp/widgets/widgets.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  final double coverHeight = 280;
  final double profileHeight = 144;

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    final followService = Provider.of<FollowService>(context, listen: false);
    final recepiesService = Provider.of<RecepiesService>(context);
    final userService = Provider.of<UserService>(context);

    //if (userService.isLoading) return LoadingScreen();

    return Scaffold(
      appBar: AppBar(
        title: Text('Mi Perfil'),
        leading: IconButton(
          icon: Icon(
            Icons.login_outlined,
            color: Colors.red.shade500,
          ),
          onPressed: () {
            authService.logout();
            Navigator.of(context).push(PageTransition(
                child: LoginScreen(),
                type: PageTransitionType.rightToLeft,
                childCurrent: ProfileScreen()));
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.home_outlined),
            tooltip: 'Go to home',
            onPressed: () {
              Navigator.of(context).push(PageTransition(
                  child: HomeScreen(),
                  type: PageTransitionType.rightToLeft,
                  childCurrent: ProfileScreen()));
            },
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          buildTop(userService),
          buildContent(followService, recepiesService, userService, context),
        ],
      ),
    );
  }

  Stack buildTop(UserService userService) {
    final bottom = profileHeight / 2;
    final top = coverHeight - profileHeight / 2;
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Container(
            margin: EdgeInsets.only(bottom: bottom),
            child: buildCoverImege(userService)),
        Positioned(
          top: top,
          child: buildProfileImage(userService),
        )
      ],
    );
  }

  Widget buildCoverImege(UserService userService) => Container(
        color: Colors.grey,
        child: Image.network(
          userService.usuario.foto_perfil_fondo_path.toString(),
          width: double.infinity,
          height: coverHeight,
          fit: BoxFit.cover,
        ),
      );

  Widget buildProfileImage(UserService userService) => CircleAvatar(
        radius: profileHeight / 2,
        backgroundColor: Colors.white,
        child: CircleAvatar(
          radius: profileHeight / 2 - 6,
          backgroundColor: Colors.grey.shade800,
          backgroundImage:
              NetworkImage(userService.usuario.foto_perfil_path.toString()),
        ),
      );

  Widget buildContent(
          FollowService followService,
          RecepiesService recepiesService,
          UserService userService,
          BuildContext context) =>
      Column(
        children: [
          const SizedBox(
            height: 8,
          ),
          Text(
            "${userService.usuario.primer_nombre} ${userService.usuario.primer_apellido}",
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            userService.usuario.id_usuario,
            style: TextStyle(fontSize: 18, color: Colors.black38),
          ),
          const SizedBox(
            height: 16,
          ),
          Divider(),
          const SizedBox(
            height: 16,
          ),
          NumbersWidget(
              recepiesService.userRecepies.length.toInt(),
              followService.followers.length.toInt(),
              followService.following.length.toInt()),
          const SizedBox(
            height: 16,
          ),
          Divider(),
          const SizedBox(
            height: 16,
          ),
          buildAbout(userService.usuario.descripcion.toString()),
          SizedBox(
            height: 20,
          ),
          Divider(
            color: Colors.black87,
          ),
          SizedBox(
            height: 20,
          ),
          Align(
            child: Text(
              'Restricciones',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.w600),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Align(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                ' Vegetariano - Nueces ',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
              ),
            ],
          )),
          SizedBox(
            height: 50,
          ),
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
