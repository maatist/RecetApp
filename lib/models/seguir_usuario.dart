import 'dart:convert';

class FollowUser {
  FollowUser({
    required this.created_at,
    required this.id_usuario_autor,
    required this.id_usuario_seguidor,
    this.id,
  });

  DateTime created_at;
  String id_usuario_autor;
  String id_usuario_seguidor;
  String? id;

  factory FollowUser.fromJson(String str) =>
      FollowUser.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory FollowUser.fromMap(Map<String, dynamic> json) => FollowUser(
        created_at: DateTime.parse(json["created_at"]),
        id_usuario_autor: json["id_usuario_autor"],
        id_usuario_seguidor: json["id_usuario_seguidor"],
      );

  Map<String, dynamic> toMap() => {
        "created_at": created_at,
        "id_usuario_autor": id_usuario_autor,
        "id_usuario_seguidor": id_usuario_seguidor,
      };

  FollowUser copy() => FollowUser(
        created_at: this.created_at,
        id_usuario_autor: this.id_usuario_autor,
        id_usuario_seguidor: this.id_usuario_seguidor,
        id: this.id,
      );
}
