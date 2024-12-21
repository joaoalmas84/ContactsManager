import 'dart:io';

class Contact {
  String nome;
  String email;
  String telefone;
  DateTime? dataNascimento;
  File? imagem;


  Contact({
    required this.nome,
    required this.email,
    required this.telefone,
    this.dataNascimento,
    this.imagem,
  });

  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'email': email,
      'telefone': telefone,
      'dataNascimento': dataNascimento?.toIso8601String(),
      'imagem': imagem?.path,
    };
  }

  factory Contact.fromJson(Map<String, dynamic> json) {
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
    );
  }

  @override
  String toString() {
    return 'Contact(nome: $nome, email: $email, telefone: $telefone, dataNascimento: ${dataNascimento?.toIso8601String() ?? "N/A"}, imagem: ${imagem?.path ?? "N/A"})';
  }
}