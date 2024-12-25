import 'dart:io';
import 'package:code/data/models/meeting_point.dart';

class Contact {
  static int _lastId = 0;

  int id;
  String nome;
  String email;
  String telefone;
  DateTime? dataNascimento;
  File? imagem;
  List<MeetingPoint>? encontros;

  Contact({
    required this.nome,
    required this.email,
    required this.telefone,
    this.dataNascimento,
    this.imagem,
    this.encontros
  }) : id = ++_lastId;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'email': email,
      'telefone': telefone,
      'dataNascimento': dataNascimento?.toIso8601String(),
      'imagem': imagem?.path,
      'encontros': encontros?.map((encontro) => encontro.toJson()).toList(),
    };
  }

  factory Contact.fromJson(Map<String, dynamic> json) {
    var encontrosJson = json['encontros'] as List?;
    List<MeetingPoint>? encontrosList = encontrosJson?.map((item) => MeetingPoint.fromJson(item)).toList();

    return Contact(
      nome: json['nome'],
      email: json['email'],
      telefone: json['telefone'],
      dataNascimento: json['dataNascimento'] != null
          ? DateTime.parse(json['dataNascimento'])
          : null,
      imagem: json['imagem'] != null && json['imagem'].isNotEmpty
          ? File(json['imagem'])
          : null,
      encontros: encontrosList,
    )..id = json['id'] ?? ++_lastId;
  }
}