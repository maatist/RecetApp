import 'dart:convert';

class User {
  User({
    required this.descripcion,
    required this.foto_perfil_fondo_path,
    required this.foto_perfil_path,
    required this.id_usuario,
    required this.primer_apellido,
    required this.primer_nombre,
    this.id,
  });

  String descripcion;
  String foto_perfil_fondo_path;
  String foto_perfil_path;
  String id_usuario;
  String primer_apellido;
  String primer_nombre;
  String? id;

  factory User.fromJson(String str) => User.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory User.fromMap(Map<String, dynamic> json) => User(
        descripcion: json["descripcion"],
        foto_perfil_fondo_path: json["foto_perfil_fondo_path"],
        foto_perfil_path: json["foto_perfil_path"],
        id_usuario: json["id_usuario"],
        primer_apellido: json["primer_apellido"],
        primer_nombre: json["primer_nombre"],
      );

  Map<String, dynamic> toMap() => {
        "descripcion": descripcion,
        "foto_perfil_fondo_path": foto_perfil_fondo_path,
        "foto_perfil_path": foto_perfil_path,
        "id_usuario": id_usuario,
        "primer_apellido": primer_apellido,
        "primer_nombre": primer_nombre,
      };

  User copy() => User(
        descripcion: this.descripcion,
        foto_perfil_fondo_path: this.foto_perfil_fondo_path,
        foto_perfil_path: this.foto_perfil_path,
        id_usuario: this.id_usuario,
        primer_apellido: this.primer_apellido,
        primer_nombre: this.primer_nombre,
        id: this.id,
      );
}
