import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:RecetApp/models/usuario.dart';

class UserService extends ChangeNotifier {
  final String _baseUrl = 'flutter-varios-ffe39-default-rtdb.firebaseio.com';
  User usuario = new User(
      descripcion: 'descripcion',
      foto_perfil_fondo_path: 'foto_perfil_fondo_path',
      foto_perfil_path: 'foto_perfil_path',
      id_usuario: 'id_usuario',
      primer_apellido: 'primer_apellido',
      primer_nombre: 'primer_nombre');
  final List<User> usuarios = [];

  final storage = new FlutterSecureStorage();

  File? newPictureFile;

  bool isLoading = true;
  bool isSaving = false;

  UserService() {
    loadUsersData();
    loadUserData();
  }

  Future<User> loadUserData() async {
    isLoading = true;
    notifyListeners();

    final url = Uri.https(_baseUrl, 'usuario.json',
        {'auth': await storage.read(key: 'token') ?? ''});
    final resp = await http.get(url);

    final Map<String, dynamic> usuariosMap = json.decode(resp.body);

    String userEmail = await getEmailAccount();

    usuariosMap.forEach((key, value) {
      final tempUser = User.fromMap(value);
      if (tempUser.id_usuario.toString() == userEmail.toString()) {
        tempUser.id = key;
        usuario = tempUser;
      }
    });

    isLoading = false;
    notifyListeners();

    return usuario;
  }

  Future<List<User>> loadUsersData() async {
    isLoading = true;
    notifyListeners();

    final url = Uri.https(_baseUrl, 'usuario.json',
        {'auth': await storage.read(key: 'token') ?? ''});
    final resp = await http.get(url);

    final Map<String, dynamic> usuariosMap = json.decode(resp.body);

    usuariosMap.forEach((key, value) {
      final tempUser = User.fromMap(value);
      tempUser.id = key;
      usuarios.add(tempUser);
    });

    isLoading = false;
    notifyListeners();

    return usuarios;
  }

  Future saveOrCreateUser(User usuario) async {
    isSaving = true;
    notifyListeners();

    if (usuario.id == null) {
      await createUser(usuario);
    } else {
      await updateUser(usuario);
    }

    isSaving = false;
    notifyListeners();
  }

  Future<String?> updateUser(User logedUser) async {
    final url = Uri.https(_baseUrl, 'recetas/${logedUser.id}.json',
        {'auth': await storage.read(key: 'token') ?? ''});
    final resp = await http.put(url, body: logedUser.toJson());
    final decodedData = resp.body;

    final index = usuarios.indexWhere((element) => element.id == logedUser.id);
    usuarios[index] = logedUser;

    return logedUser.id;
  }

  Future<String?> createUser(User logedUser) async {
    final url = Uri.https(_baseUrl, 'usuario.json',
        {'auth': await storage.read(key: 'token') ?? ''});
    final resp = await http.post(url, body: logedUser.toJson());
    final decodedData = json.decode(resp.body);

    logedUser.id = decodedData['name'];

    usuarios.add(logedUser);

    usuario = new User(
        descripcion: '',
        foto_perfil_fondo_path:
            'https://img.freepik.com/fotos-premium/textura-fondo-acuarela-indigo-papel-digital-azul-indigo_199112-143.jpg',
        foto_perfil_path:
            'https://www.webespacio.com/wp-content/uploads/2012/01/foto-perfil.jpg',
        id_usuario: logedUser.id_usuario,
        primer_apellido: 'Apellido',
        primer_nombre: 'Nombre');

    return logedUser.id;
  }

  void updateSelectedProfileImage(String path) {
    usuario.foto_perfil_path = path;
    newPictureFile = File.fromUri(Uri(path: path));

    notifyListeners();
  }

  void updateSelectedProfileBackgroundImage(String path) {
    usuario.foto_perfil_fondo_path = path;
    newPictureFile = File.fromUri(Uri(path: path));

    notifyListeners();
  }

  Future<String?> uploadImage() async {
    if (newPictureFile == null) return null;
    isSaving = true;
    notifyListeners();
    final url = Uri.parse(
        'https://api.cloudinary.com/v1_1/dvwtoqoal/image/upload?upload_preset=dp722mff');
    final imageUploadRequest = http.MultipartRequest('POST', url);
    final file =
        await http.MultipartFile.fromPath('file', newPictureFile!.path);

    imageUploadRequest.files.add(file);

    final streamResponse = await imageUploadRequest.send();
    final resp = await http.Response.fromStream(streamResponse);

    if (resp.statusCode != 200 && resp.statusCode != 201) {
      print('algo salio mal');
      print(resp.body);
      return null;
    }
    newPictureFile = null;
    final decodedData = json.decode(resp.body);
    return decodedData['secure_url'];
  }

  Future<String> getEmailAccount() async {
    return await storage.read(key: 'userEmail') ?? '';
  }

  Future<String> readToken() async {
    return await storage.read(key: 'token') ?? '';
  }

  Future<String?> getRecepieProfilePicString(String usuarioAutor) async {
    isLoading = true;

    final url = Uri.https(_baseUrl, 'usuario.json',
        {'auth': await storage.read(key: 'token') ?? ''});
    final resp = await http.get(url);

    final Map<String, dynamic> usuariosMap = json.decode(resp.body);

    usuariosMap.forEach((key, value) {
      final tempUser = User.fromMap(value);
      if (tempUser.id_usuario.toString() == usuarioAutor.toString()) {
        tempUser.id = key;
        usuario = tempUser;
      }
    });

    isLoading = false;

    return usuario.foto_perfil_path;
  }

  Future<String?> getNombreUsuario(String usuarioAutor) async {
    isLoading = true;

    final url = Uri.https(_baseUrl, 'usuario.json',
        {'auth': await storage.read(key: 'token') ?? ''});
    final resp = await http.get(url);

    final Map<String, dynamic> usuariosMap = json.decode(resp.body);

    usuariosMap.forEach((key, value) {
      final tempUser = User.fromMap(value);
      if (tempUser.id_usuario.toString() == usuarioAutor.toString()) {
        tempUser.id = key;
        usuario = tempUser;
      }
    });

    isLoading = false;

    return '${usuario.primer_nombre}${usuario.primer_apellido}';
  }
}
