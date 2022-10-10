import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_select_flutter/dialog/mult_select_dialog.dart';
import 'package:multiselect/multiselect.dart';

import 'package:RecetApp/provider/recepie_form_provider.dart';
import 'package:RecetApp/widgets/multi_select_form_field.dart';
import 'package:provider/provider.dart';

import 'package:RecetApp/services/services.dart';

import 'package:RecetApp/ui/input_decorations.dart';
import 'package:RecetApp/widgets/widgets.dart';

class ReadRecepieScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final recepiesService = Provider.of<RecepiesService>(context);

    return ChangeNotifierProvider(
      create: (_) => RecepieFormProvider(recepiesService.selectedRecepie),
      child: _RecepiesScreenBody(recepiesService: recepiesService),
    );
  }
}

class _RecepiesScreenBody extends StatelessWidget {
  const _RecepiesScreenBody({
    Key? key,
    required this.recepiesService,
  }) : super(key: key);

  final RecepiesService recepiesService;

  @override
  Widget build(BuildContext context) {
    final recepieForm = Provider.of<RecepieFormProvider>(context);

    return Scaffold(
      body: SingleChildScrollView(
        //keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Column(
          children: [
            Stack(
              children: [
                ProductImage(
                    url: recepiesService.selectedRecepie.receta_foto_path),
                Positioned(
                    top: 60,
                    left: 20,
                    child: IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Icon(
                        Icons.arrow_back_ios_new,
                        size: 40,
                        color: Colors.white,
                      ),
                    )),
              ],
            ),
            _RecepieForm(),
            SizedBox(
              height: 100,
            ),
          ],
        ),
      ),
    );
  }
}

class _RecepieForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final recepieForm = Provider.of<RecepieFormProvider>(context);
    final recepie = recepieForm.recepie;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        width: double.infinity,
        decoration: _buildBoxDecoration(),
        child: Form(
          key: recepieForm.formkey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(children: [
            SizedBox(
              height: 30,
            ),
            Align(
              child: Text(
                recepie.titulo,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Text(
                'Tiempo de preparacion: ${recepie.tiempo_preparacion} min',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
              ),
            ),
            SizedBox(
              height: 60,
            ),
            Align(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  recepie.descripcion,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Divider(
              color: Colors.black87,
            ),
            SizedBox(
              height: 15,
            ),
            Align(
              child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Text(
                        ' Ingredientes',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          alignment: WrapAlignment.center,
                          spacing: 35,
                          runSpacing: 10,
                          children: [
                            Text(
                              'Arroz',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w400),
                            ),
                            Text(
                              'Pollo',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w400),
                            ),
                            Text(
                              'Aceite',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w400),
                            ),
                            Text(
                              'Sal',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w400),
                            ),
                            Text(
                              'Ingrediente 5',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w400),
                            ),
                            Text(
                              'Ingrediente 6',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w400),
                            ),
                            Text(
                              'Ingrediente 7',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                      )
                    ],
                  )),
            ),
            SizedBox(
              height: 15,
            ),
            Divider(
              color: Colors.black87,
            ),
            SizedBox(
              height: 20,
            ),
            Align(
              child: Text(
                'Categorias',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.w600),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Align(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Carnes',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                ),
                SizedBox(
                  width: 20,
                ),
                Text(
                  'Arroz',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                ),
              ],
            )),
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
              height: 5,
            ),
            Align(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  ' - ',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                ),
              ],
            )),
            SizedBox(
              height: 5,
            ),
            Divider(
              color: Colors.black87,
            ),
            SizedBox(
              height: 5,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Text(
                  'Paso numero 1:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 80),
                  child: Image(
                    image: AssetImage('assets/receta-paso-1.jpg'),
                    fit: BoxFit.cover,
                  )),
            ),
            SizedBox(
              height: 15,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    'The Earth is the only world known so far to harbor life. There is nowhere else, at least in the near future, to which our species could migrate.',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Divider(),
            SizedBox(
              height: 5,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Text(
                  'Paso numero 2:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 80),
                  child: Image(
                    image: AssetImage('assets/receta-paso-2.jpg'),
                    fit: BoxFit.cover,
                  )),
            ),
            SizedBox(
              height: 15,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    'It has been said that astronomy is a humbling and character-building experience. There is perhaps no better demonstration of the folly of human conceits than this distant image of our tiny world.',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
          ]),
        ),
      ),
    );
  }

  BoxDecoration _buildBoxDecoration() => BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(25),
            bottomLeft: Radius.circular(25),
          ),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.05),
                offset: Offset(0, 5),
                blurRadius: 5)
          ]);
}
