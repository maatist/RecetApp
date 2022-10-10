import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:RecetApp/models/models.dart';
import 'package:RecetApp/models/usuario.dart';

class FollowService extends ChangeNotifier {
  final String _baseUrl = 'flutter-varios-ffe39-default-rtdb.firebaseio.com';
  final List<FollowUser> followers = [];
  final List<FollowUser> following = [];
  final List<FollowUser> followersOf = [];
  final List<FollowUser> followingOf = [];
  late FollowUser userFollow;

  final storage = new FlutterSecureStorage();

  File? newPictureFile;

  bool isLoading = true;
  bool isSaving = false;

  FollowService() {
    loadFollowersData();
    loadFollowingData();
  }

  Future<List<FollowUser>> loadFollowersData() async {
    isLoading = true;
    notifyListeners();

    final url = Uri.https(_baseUrl, 'seguir_usuario.json',
        {'auth': await storage.read(key: 'token') ?? ''});
    final resp = await http.get(url);

    final Map<String, dynamic> followUserMap = json.decode(resp.body);

    String userEmail = await getEmailAccount();

    followUserMap.forEach((key, value) {
      final tempFollower = FollowUser.fromMap(value);
      if (tempFollower.id_usuario_autor.toString() == userEmail.toString()) {
        tempFollower.id = key;
        followers.add(tempFollower);
      }
    });

    isLoading = false;
    notifyListeners();

    return followers;
  }

  Future<List<FollowUser>> loadFollowingData() async {
    isLoading = true;
    notifyListeners();

    final url = Uri.https(_baseUrl, 'seguir_usuario.json',
        {'auth': await storage.read(key: 'token') ?? ''});
    final resp = await http.get(url);

    final Map<String, dynamic> followUserMap = json.decode(resp.body);

    String userEmail = await getEmailAccount();

    followUserMap.forEach((key, value) {
      final tempFollower = FollowUser.fromMap(value);
      if (tempFollower.id_usuario_seguidor.toString() == userEmail.toString()) {
        tempFollower.id = key;
        following.add(tempFollower);
      }
    });

    isLoading = false;
    notifyListeners();

    return following;
  }

  Future<List<FollowUser>> loadFollowersOfData(String user) async {
    isLoading = true;
    notifyListeners();

    final url = Uri.https(_baseUrl, 'seguir_usuario.json',
        {'auth': await storage.read(key: 'token') ?? ''});
    final resp = await http.get(url);

    final Map<String, dynamic> followUserMap = json.decode(resp.body);

    //t(user.id_usuario);

    followUserMap.forEach((key, value) {
      final tempFollower = FollowUser.fromMap(value);
      if (tempFollower.id_usuario_autor.toString() == user.toString()) {
        tempFollower.id = key;
        followersOf.add(tempFollower);
      }
    });

    isLoading = false;
    notifyListeners();

    return followersOf;
  }

  Future<List<FollowUser>> loadFollowingOfData(String user) async {
    isLoading = true;
    notifyListeners();

    final url = Uri.https(_baseUrl, 'seguir_usuario.json',
        {'auth': await storage.read(key: 'token') ?? ''});
    final resp = await http.get(url);

    final Map<String, dynamic> followUserMap = json.decode(resp.body);

    followUserMap.forEach((key, value) {
      final tempFollower = FollowUser.fromMap(value);
      if (tempFollower.id_usuario_seguidor.toString() == user.toString()) {
        tempFollower.id = key;
        followingOf.add(tempFollower);
      }
    });

    isLoading = false;
    notifyListeners();

    return followingOf;
  }

  Future createOrDeleteFollow(User usuario) async {
    isSaving = true;
    notifyListeners();

    if (usuario.id == null) {
      await createFollow(usuario);
    } else {
      await deleteFollow(usuario);
    }

    isSaving = false;
    notifyListeners();
  }

  Future<String?> deleteFollow(User logedUser) async {
    final url = Uri.https(_baseUrl, 'recetas/${logedUser.id}.json',
        {'auth': await storage.read(key: 'token') ?? ''});
    final resp = await http.put(url, body: logedUser.toJson());
    final decodedData = resp.body;

    final index = followers.indexWhere((element) => element.id == logedUser.id);
    followers[index] = userFollow;

    return logedUser.id;
  }

  Future<String?> createFollow(User logedUser) async {
    final url = Uri.https(_baseUrl, 'usuario.json',
        {'auth': await storage.read(key: 'token') ?? ''});
    final resp = await http.post(url, body: logedUser.toJson());
    final decodedData = json.decode(resp.body);

    logedUser.id = decodedData['name'];

    followers.add(userFollow);

    return logedUser.id;
  }

  Future<String> getEmailAccount() async {
    return await storage.read(key: 'userEmail') ?? '';
  }

  Future<String> readToken() async {
    return await storage.read(key: 'token') ?? '';
  }
}
