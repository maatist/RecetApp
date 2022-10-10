import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:RecetApp/models/models.dart';
import 'package:RecetApp/models/usuario.dart';
import 'package:provider/provider.dart';

class AuthService extends ChangeNotifier {
  final String _baseUrl = 'identitytoolkit.googleapis.com';
  final String _baseUrlBD = 'flutter-varios-ffe39-default-rtdb.firebaseio.com';
  final String _firebaseToken = 'AIzaSyD5mMRkRPTRPdHcAzka_crVwgRSNoc-y_4';
  final storage = new FlutterSecureStorage();
  late String loggedUser = '';
  User? user;

  Future<String?> createUser(String email, String password) async {
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };

    final url =
        Uri.https(_baseUrl, '//v1/accounts:signUp', {'key': _firebaseToken});

    final resp = await http.post(url, body: json.encode(authData));
    final Map<String, dynamic> decodedResp = json.decode(resp.body);

    if (decodedResp.containsKey('idToken')) {
      await storage.write(key: 'token', value: decodedResp['idToken']);
      loggedUser = await storage
          .write(key: 'userEmail', value: email)
          .then((value) => null)
          .toString();

      User usuario = new User(
          descripcion: '',
          foto_perfil_fondo_path:
              'https://img.freepik.com/fotos-premium/textura-fondo-acuarela-indigo-papel-digital-azul-indigo_199112-143.jpg',
          foto_perfil_path:
              'https://www.webespacio.com/wp-content/uploads/2012/01/foto-perfil.jpg',
          id_usuario: email,
          primer_apellido: 'Apellido',
          primer_nombre: 'Nombre');

      final createUserUrl = Uri.https(_baseUrlBD, 'usuario.json',
          {'auth': await storage.read(key: 'token') ?? ''});
      final createUserResp =
          await http.post(createUserUrl, body: usuario.toJson());
      final Map<String, dynamic> decodedData = json.decode(createUserResp.body);
      usuario.id = decodedData['name'];

      user = usuario;

      //decodedResp['idToken'];
      return null;
    } else {
      return decodedResp['error']['message'];
    }
  }

  Future<String?> login(String email, String password) async {
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };

    final url = Uri.https(
        _baseUrl, '//v1/accounts:signInWithPassword', {'key': _firebaseToken});

    final resp = await http.post(url, body: json.encode(authData));
    final Map<String, dynamic> decodedResp = json.decode(resp.body);

    if (decodedResp.containsKey('idToken')) {
      // TODO GUARDAR EN LUIGAR SEGURO

      //decodedResp['idToken'];
      await storage.write(key: 'token', value: decodedResp['idToken']);
      loggedUser = await storage
          .write(key: 'userEmail', value: email)
          .then((value) => null)
          .toString();

      return null;
    } else {
      return decodedResp['error']['message'];
    }
  }

  Future logout() async {
    await storage.delete(key: 'token');
    await storage.delete(key: 'userEmail');
    return;
  }

  Future<String> readToken() async {
    return await storage.read(key: 'token') ?? '';
  }

  Future<String> getEmailAccount() async {
    return await storage.read(key: 'userEmail') ?? '';
  }
}
