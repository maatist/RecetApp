import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:RecetApp/models/models.dart';
import 'package:http/http.dart' as http;
import 'package:RecetApp/models/usuario.dart';

class RecepiesService extends ChangeNotifier {
  final String _baseUrl = 'flutter-varios-ffe39-default-rtdb.firebaseio.com';
  final List<Recepie> recepies = [];
  late Recepie selectedRecepie;
  final List<Recepie> userRecepies = [];
  final List<Recepie> otherUserRecepies = [];

  final storage = new FlutterSecureStorage();

  File? newPictureFile;

  bool isLoading = true;
  bool isSaving = false;

  RecepiesService() {
    loadRecepie();
    loadUserRecepies();
  }

  Future<List<Recepie>> loadRecepie() async {
    isLoading = true;
    notifyListeners();

    final url = Uri.https(_baseUrl, 'recetas.json',
        {'auth': await storage.read(key: 'token') ?? ''});
    final resp = await http.get(url);

    final Map<String, dynamic> recepiesMap = json.decode(resp.body);

    recepiesMap.forEach((key, value) {
      final tempRecepie = Recepie.fromMap(value);
      tempRecepie.id = key;
      recepies.add(tempRecepie);
    });

    isLoading = false;
    notifyListeners();

    recepies.sort(((a, b) {
      final adate = a.created_at;
      final bdate = b.created_at;
      return DateTime.parse(bdate).compareTo(DateTime.parse(adate));
    }));

    return recepies;
  }

  Future<List<Recepie>> loadUserRecepies() async {
    isLoading = true;
    notifyListeners();

    final url = Uri.https(_baseUrl, 'recetas.json',
        {'auth': await storage.read(key: 'token') ?? ''});
    final resp = await http.get(url);

    final Map<String, dynamic> recepiesMap = json.decode(resp.body);

    String userEmail = await getEmailAccount();
    //print(userEmail);

    userRecepies.clear();

    recepiesMap.forEach((key, value) async {
      final tempRecepie = Recepie.fromMap(value);
      if (tempRecepie.id_usuario_autor.toString() == userEmail.toString()) {
        tempRecepie.id = key;
        userRecepies.add(tempRecepie);
      }
    });
    isLoading = false;
    notifyListeners();

    userRecepies.sort(((a, b) {
      final adate = a.created_at;
      final bdate = b.created_at;
      return DateTime.parse(bdate).compareTo(DateTime.parse(adate));
    }));

    return userRecepies;
  }

  Future loadOtherUserRecepies(User user) async {
    isLoading = true;
    notifyListeners();

    final url = Uri.https(_baseUrl, 'recetas.json',
        {'auth': await storage.read(key: 'token') ?? ''});
    final resp = await http.get(url);

    final Map<String, dynamic> recepiesMap = json.decode(resp.body);

    String userEmail = user.id_usuario;

    recepiesMap.forEach((key, value) async {
      final tempRecepie = Recepie.fromMap(value);
      if (tempRecepie.id_usuario_autor.toString() == userEmail.toString()) {
        tempRecepie.id = key;
        otherUserRecepies.add(tempRecepie);
      }
    });
    isLoading = false;
    notifyListeners();

    otherUserRecepies.sort(((a, b) {
      final adate = a.created_at;
      final bdate = b.created_at;
      return bdate.compareTo(adate);
    }));

    return otherUserRecepies;
  }

  Future saveOrCreateRecepie(Recepie recepie) async {
    isSaving = true;
    notifyListeners();

    if (recepie.id == null) {
      await createRecepie(recepie);
    } else {
      await updateRecepie(recepie);
    }

    recepies.sort(((a, b) {
      final adate = a.created_at;
      final bdate = b.created_at;
      return DateTime.parse(bdate).compareTo(DateTime.parse(adate));
    }));

    userRecepies.sort(((a, b) {
      final adate = a.created_at;
      final bdate = b.created_at;
      return DateTime.parse(bdate).compareTo(DateTime.parse(adate));
    }));

    isSaving = false;
    notifyListeners();
  }

  Future<String?> updateRecepie(Recepie recepie) async {
    final url = Uri.https(_baseUrl, 'recetas/${recepie.id}.json',
        {'auth': await storage.read(key: 'token') ?? ''});
    final resp = await http.put(url, body: recepie.toJson());
    final decodedData = resp.body;

    final index = recepies.indexWhere((element) => element.id == recepie.id);
    recepies[index] = recepie;

    final indexUser =
        userRecepies.indexWhere((element) => element.id == recepie.id);
    userRecepies[indexUser] = recepie;

    return recepie.id;
  }

  Future<String?> deleteRecepie(Recepie recepie) async {
    print('eliminando...');
    isSaving = true;
    notifyListeners();
    final url = Uri.https(_baseUrl, 'recetas/${recepie.id}.json',
        {'auth': await storage.read(key: 'token') ?? ''});
    final resp = await http.delete(url, body: recepie.toJson());
    final decodedData = resp.body;

    final index = recepies.indexWhere((element) => element.id == recepie.id);
    recepies.removeAt(index);

    final indexUser =
        userRecepies.indexWhere((element) => element.id == recepie.id);
    userRecepies.removeAt(indexUser);
    isSaving = false;
    notifyListeners();
    return recepie.id;
  }

  Future<String?> createRecepie(Recepie recepie) async {
    final url = Uri.https(_baseUrl, 'recetas.json',
        {'auth': await storage.read(key: 'token') ?? ''});
    final resp = await http.post(url, body: recepie.toJson());
    final decodedData = json.decode(resp.body);

    String userEmail = await getEmailAccount().then((e) => e.toString());

    recepie.id_usuario_autor = userEmail;

    List<Recepie> recepiesCopy = recepies;

    recepiesCopy.sort(((a, b) {
      final adate = a.id_receta;
      final bdate = b.id_receta;
      return bdate.compareTo(adate);
    }));

    recepie.id_receta = recepiesCopy.last.id_receta + 1;

    recepie.id = decodedData['name'];

    recepies.add(recepie);
    userRecepies.add(recepie);

    return recepie.id;
  }

  void updateSelectedRecepieImage(String path) {
    selectedRecepie.receta_foto_path = path;
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
}
