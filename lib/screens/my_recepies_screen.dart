import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:RecetApp/models/recepies.dart';
import 'package:RecetApp/screens/screens.dart';
import 'package:RecetApp/services/services.dart';
import 'package:RecetApp/widgets/widgets.dart';
import 'package:provider/provider.dart';

class MyRecepiesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final recepieService = Provider.of<RecepiesService>(context);
    final authService = Provider.of<AuthService>(context, listen: false);

    if (recepieService.isLoading) return LoadingScreen();

    return _MyRecepies(authService, context, recepieService);
  }

  Scaffold _MyRecepies(AuthService authService, BuildContext context,
      RecepiesService recepieService) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mis recetas'),
        leading: IconButton(
          icon: Icon(Icons.person_outline),
          onPressed: () {
            Navigator.of(context).push(PageTransition(
                child: ProfileScreen(),
                type: PageTransitionType.leftToRight,
                childCurrent: MyRecepiesScreen()));
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.home_outlined),
            onPressed: () {
              Navigator.of(context).push(PageTransition(
                  child: HomeScreen(),
                  type: PageTransitionType.rightToLeft,
                  childCurrent: MyRecepiesScreen()));
            },
          ),
        ],
      ),
      body: ListView.builder(
          itemCount: recepieService.userRecepies.length,
          itemBuilder: (BuildContext context, int index) => GestureDetector(
              onTap: () {
                recepieService.selectedRecepie =
                    recepieService.userRecepies[index].copy();
                Navigator.pushNamed(context, 'recepie');
              },
              child: MyRecipeCard(
                  title: recepieService.userRecepies[index].titulo,
                  cookTime:
                      recepieService.userRecepies[index].tiempo_preparacion,
                  likes: 3,
                  thumbnailUrl:
                      recepieService.userRecepies[index].receta_foto_path))),
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
              id_usuario_autor: '',
              receta_foto_path: 'assets/no-image.png',
              tiempo_preparacion: 0,
              titulo: '',
              updated_at: date.toString());
          Navigator.of(context).push(PageTransition(
              child: RecepieCreateScreen(),
              type: PageTransitionType.rightToLeft,
              childCurrent: MyRecepiesScreen()));
        },
      ),
    );
  }
}
