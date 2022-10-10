import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:RecetApp/models/models.dart';
import 'package:RecetApp/screens/screens.dart';
import 'package:RecetApp/services/services.dart';
import 'package:provider/provider.dart';

import 'package:RecetApp/widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final recepieService = Provider.of<RecepiesService>(context);
    final authService = Provider.of<AuthService>(context, listen: false);
    final userService = Provider.of<UserService>(context);
    final followService = Provider.of<FollowService>(context, listen: false);

    final loggedUser = userService.usuario.id_usuario;

    print(userService.usuario.id_usuario);

    if (userService.isLoading) return LoadingScreen();
    if (recepieService.isLoading) return LoadingScreen();

    return Scaffold(
      appBar: AppBar(
        title: Text('RecetApp'),
        leading: IconButton(
          icon: Icon(Icons.person_outline),
          onPressed: () {
            recepieService.loadUserRecepies();
            Navigator.of(context).push(PageTransition(
                child: ProfileScreen(),
                type: PageTransitionType.leftToRight,
                childCurrent: HomeScreen()));
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.message_outlined),
            onPressed: () {
              Navigator.of(context).push(PageTransition(
                  child: ListMessagesScreen(),
                  type: PageTransitionType.rightToLeft,
                  childCurrent: HomeScreen()));
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          /* Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(60, 5, 0, 15),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: TextButton(
                      onPressed: () {},
                      child: Text(
                        'Descubrir',
                        style: TextStyle(fontSize: 18, color: Colors.indigo),
                      )),
                ),
              ),
              VerticalDivider(
                width: 3,
                thickness: 5,
                endIndent: 765,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 5, 70, 15),
                child: Align(
                  alignment: Alignment.topRight,
                  child: TextButton(
                      onPressed: () {},
                      child: Text(
                        'Seguidos',
                        style: TextStyle(fontSize: 18, color: Colors.indigo),
                      )),
                ),
              ),
            ],
          ), */
          /* Divider(
            height: 110,
            thickness: 5,
          ), */
          ListView.builder(
              itemCount: recepieService.recepies.length,
              padding: EdgeInsets.only(top: 10),
              itemBuilder: (BuildContext context, int index) => GestureDetector(
                  onTap: () {
                    recepieService.selectedRecepie =
                        recepieService.recepies[index].copy();
                    Navigator.pushNamed(context, 'readRecepie');
                  },
                  child: /* ProductCard(
                  product: productsService.products[index],
                ), */

                      Stack(children: <Widget>[
                    RecepieAuthorHeader(
                      fechaCreacionPublicacion:
                          recepieService.recepies[index].created_at.toString(),
                      loggedUser: loggedUser,
                      id_usuario:
                          recepieService.recepies[index].id_usuario_autor,
                      nombreUsuario:
                          '${(userService.usuarios.firstWhere((u) => u.id_usuario.toString() == recepieService.recepies[index].id_usuario_autor.toString())).primer_nombre} ${(userService.usuarios.firstWhere((u) => u.id_usuario.toString() == recepieService.recepies[index].id_usuario_autor.toString())).primer_apellido}',
                      pathFotoPerfil: userService.usuarios
                          .firstWhere((u) =>
                              u.id_usuario.toString() ==
                              recepieService.recepies[index].id_usuario_autor
                                  .toString())
                          .foto_perfil_path
                          .toString(),
                    ),
                    RecipeCard(
                        title: recepieService.recepies[index].titulo,
                        cookTime:
                            recepieService.recepies[index].tiempo_preparacion,
                        likes: 3,
                        thumbnailUrl:
                            recepieService.recepies[index].receta_foto_path),
                    Positioned(
                      child: TextButton(
                        child: Text(
                          'Comentarios...',
                          style: TextStyle(color: Colors.indigo),
                        ),
                        onPressed: () {},
                      ),
                      left: 20,
                      top: 330,
                    ),
                  ])

                  /* RecipeCard(
                title: 'Receta1',
                cookTime: '30 min',
                likes: '4',
                thumbnailUrl:
                    'https://www.annarecetasfaciles.com/files/migas-coliflor-1-2-815x458.jpg',
              ) */
                  )),
          SizedBox(
            height: 30,
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          final now = new DateTime.now();
          final DateTime date = new DateTime(
              now.year, now.month, now.day, now.hour, now.minute, now.second);

          recepieService.selectedRecepie = Recepie(
              created_at: date.toString(),
              descripcion: '',
              id_categoria: 1,
              id_receta: 1,
              id_usuario_autor: loggedUser,
              receta_foto_path: 'assets/no-image.png',
              tiempo_preparacion: 0,
              titulo: '',
              updated_at: date.toString());
          Navigator.of(context).push(PageTransition(
              child: RecepieCreateScreen(),
              type: PageTransitionType.rightToLeft,
              childCurrent: HomeScreen()));
        },
      ),
    );
  }
}
