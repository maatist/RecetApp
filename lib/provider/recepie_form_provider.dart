import 'package:flutter/material.dart';
import 'package:RecetApp/models/models.dart';

class RecepieFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formkey = new GlobalKey<FormState>();

  Recepie recepie;

  RecepieFormProvider(this.recepie);

  /* updateAvailability(bool value) {
    //print(value);

    this.recepie.available = value;
    notifyListeners();
  } */

  bool isValidForm() {
    print(recepie.titulo);
    print(recepie.descripcion);
    print(recepie.receta_foto_path);

    return formkey.currentState?.validate() ?? false;
  }
}
