import 'dart:convert';
import 'dart:ffi';

class Recepie {
  Recepie({
    required this.created_at,
    required this.descripcion,
    required this.id_categoria,
    required this.id_receta,
    required this.id_usuario_autor,
    required this.receta_foto_path,
    required this.tiempo_preparacion,
    required this.titulo,
    required this.updated_at,
    this.id,
  });

  String created_at;
  String descripcion;
  int id_categoria;
  int id_receta;
  String id_usuario_autor;
  String receta_foto_path;
  int tiempo_preparacion;
  String titulo;
  String updated_at;
  String? id;

  factory Recepie.fromJson(String str) => Recepie.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Recepie.fromMap(Map<String, dynamic> json) => Recepie(
        created_at: json["created_at"],
        descripcion: json["descripcion"],
        id_categoria: json["id_categoria"],
        id_receta: json["id_receta"],
        id_usuario_autor: json["id_usuario_autor"],
        receta_foto_path: json["receta_foto_path"],
        tiempo_preparacion: json["tiempo_preparacion"],
        titulo: json["titulo"],
        updated_at: json["updated_at"],
      );

  Map<String, dynamic> toMap() => {
        "created_at": created_at,
        "descripcion": descripcion,
        "id_categoria": id_categoria,
        "id_receta": id_receta,
        "id_usuario_autor": id_usuario_autor,
        "receta_foto_path": receta_foto_path,
        "tiempo_preparacion": tiempo_preparacion,
        "titulo": titulo,
        "updated_at": updated_at,
      };

  Recepie copy() => Recepie(
        created_at: this.created_at,
        descripcion: this.descripcion,
        id_categoria: this.id_categoria,
        id_receta: this.id_receta,
        id_usuario_autor: this.id_usuario_autor,
        receta_foto_path: this.receta_foto_path,
        tiempo_preparacion: this.tiempo_preparacion,
        titulo: this.titulo,
        updated_at: this.updated_at,
        id: this.id,
      );
}
