import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_select_flutter/dialog/mult_select_dialog.dart';
import 'package:multiselect/multiselect.dart';
import 'package:page_transition/page_transition.dart';

import 'package:RecetApp/provider/recepie_form_provider.dart';
import 'package:RecetApp/screens/screens.dart';
import 'package:RecetApp/widgets/multi_select_form_field.dart';
import 'package:provider/provider.dart';

import 'package:RecetApp/services/services.dart';

import 'package:RecetApp/ui/input_decorations.dart';
import 'package:RecetApp/widgets/widgets.dart';

class RecepieCreateScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final recepiesService = Provider.of<RecepiesService>(context);
    final userService = Provider.of<UserService>(context);

    return ChangeNotifierProvider(
      create: (_) => RecepieFormProvider(recepiesService.selectedRecepie),
      child: _RecepiesScreenBody(
        recepiesService: recepiesService,
        loggedUser: userService.usuario.id_usuario,
      ),
    );
  }
}

class _RecepiesScreenBody extends StatelessWidget {
  const _RecepiesScreenBody({
    Key? key,
    required this.recepiesService,
    required this.loggedUser,
  }) : super(key: key);

  final RecepiesService recepiesService;
  final String loggedUser;

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
                Positioned(
                    top: 60,
                    right: 20,
                    child: IconButton(
                      onPressed: () async {
                        final picker = new ImagePicker();
                        final XFile? pickedFile =
                            await picker.pickImage(source: ImageSource.camera);
                        //final PickedFile? pickedFile = await picker.getImage(source: ImageSource.gallery, imageQuality: 100);
                        if (pickedFile == null) {
                          print('no selecciono nada');
                          return;
                        }

                        recepiesService
                            .updateSelectedRecepieImage(pickedFile.path);
                      },
                      icon: Icon(
                        Icons.camera_alt_outlined,
                        size: 40,
                        color: Colors.white,
                      ),
                    )),
                Positioned(
                    top: 120,
                    right: 20,
                    child: IconButton(
                      onPressed: () async {
                        final picker = new ImagePicker();
                        final XFile? pickedFile =
                            await picker.pickImage(source: ImageSource.gallery);
                        //final PickedFile? pickedFile = await picker.getImage(source: ImageSource.gallery, imageQuality: 100);
                        if (pickedFile == null) {
                          print('no selecciono nada');
                          return;
                        }

                        recepiesService
                            .updateSelectedRecepieImage(pickedFile.path);
                      },
                      icon: Icon(
                        Icons.image_outlined,
                        size: 40,
                        color: Colors.white,
                      ),
                    )),
              ],
            ),
            _RecepieForm(),
            SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: FloatingActionButton(
        child: recepiesService.isSaving
            ? CircularProgressIndicator(
                color: Colors.white,
              )
            : Icon(Icons.save_outlined),
        onPressed: recepiesService.isSaving
            ? null
            : () async {
                if (!recepieForm.isValidForm()) return;

                final String? imageUrl = await recepiesService.uploadImage();

                if (imageUrl != null)
                  recepieForm.recepie.receta_foto_path = imageUrl;

                print(recepieForm.recepie.created_at);

                recepieForm.recepie.id_usuario_autor = loggedUser;

                await recepiesService.saveOrCreateRecepie(recepieForm.recepie);
                Navigator.of(context).push(PageTransition(
                    child: HomeScreen(),
                    type: PageTransitionType.leftToRight,
                    childCurrent: RecepieEditScreen()));
              },
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
              height: 10,
            ),
            TextFormField(
                initialValue: recepie.titulo,
                onChanged: (value) => recepie.titulo = value,
                validator: (value) {
                  if (value == null || value.length < 1)
                    return 'El titulo es obligatorio';
                },
                decoration: InputDecorations.authInputDecoration(
                    hintText: 'Titulo de la receta', labelText: 'Titulo: ')),
            SizedBox(
              height: 30,
            ),
            TextFormField(
                initialValue: '${recepie.tiempo_preparacion}',
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                      RegExp(r'^(\d+)?\.?\d{0,2}'))
                ],
                onChanged: (value) {
                  if (double.tryParse(value) == null) {
                    recepie.tiempo_preparacion = 0;
                  } else {
                    recepie.tiempo_preparacion = int.parse(value);
                  }
                },
                keyboardType: TextInputType.number,
                decoration: InputDecorations.authInputDecoration(
                    hintText: '30',
                    labelText: 'Tiempo preparacion: (En minutos)')),
            SizedBox(
              height: 30,
            ),
            TextFormField(
                initialValue: recepie.descripcion,
                onChanged: (value) => recepie.descripcion = value,
                validator: (value) {
                  if (value == null || value.length < 1)
                    return 'Favor incluir descripcion';
                },
                decoration: InputDecorations.authInputDecoration(
                    hintText: 'Descripcion de receta',
                    labelText: 'Descripcion: ')),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 30,
            ),
            TextFormField(
                initialValue: '',
                decoration: InputDecorations.authInputDecoration(
                    hintText: 'Ingrese ingredientes separados por ","',
                    labelText: 'Ingredientes: ')),
            SizedBox(
              height: 10,
            ),
            Divider(
              color: Colors.black87,
            ),
            SizedBox(
              height: 20,
            ),
            MultiSelectFormField(
              context: context,
              buttonText: 'Categorias',
              itemList: ['Arroz', 'Carnes', 'Dulces', 'Ensaladas', 'Mariscos'],
              questionText: 'Selecciona a que categorias pertenece tu receta',
              initialValue: [],
              validator: (categorias) => categorias!.length == 0
                  ? 'Selecciona al menos una categoria!'
                  : null,
              onSaved: (categorias) {
                print(categorias);
                // Logic to save selected flavours in the database
              },
            ),
            MultiSelectFormField(
              context: context,
              buttonText: 'Restricciones',
              itemList: [
                'Sin gluten',
                'Vegana',
                'Vegetariana',
                'Nueces',
                'Mariscos',
                'Soja'
              ],
              questionText: 'Seleccionas restricciones de tu receta',
              initialValue: [],
              validator: (restricciones) => restricciones!.length == 0
                  ? 'Selecciona la menos una restriccion!'
                  : null,
              onSaved: (restricciones) {
                print(restricciones);
                // Logic to save selected flavours in the database
              },
            ),
            SizedBox(
              height: 20,
            ),
            Divider(
              color: Colors.black87,
            ),
            SizedBox(
              height: 10,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  'Paso numero 1:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
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
                    image: AssetImage('assets/no-image.png'),
                    fit: BoxFit.cover,
                  )),
            ),
            SizedBox(
              height: 15,
            ),
            TextFormField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                initialValue: '',
                /* validator: (value) {
                  if (value == null || value.length < 1)
                    return 'Favor incluir descripcion de paso 1';
                }, */
                decoration: InputDecorations.authInputDecoration(
                    hintText: 'Paso 1', labelText: 'Paso 1:')),
            SizedBox(
              height: 30,
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                '+ Agregar siguiente paso',
                style: TextStyle(fontSize: 16),
              ),
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
