import 'dart:convert';

class GatilhoModel {
  final int idScrip;
  final String teachingName;
  final String teachingText;

  const GatilhoModel({
    required this.idScrip,
    required this.teachingName,
    required this.teachingText,
  });

  Map<String, dynamic> toMap() {
    return {
      'idScrip': idScrip,
      'teachingName': teachingName,
      'teachingText': teachingText,
    };
  }

  factory GatilhoModel.fromMap(Map<String, dynamic> map) {
    return GatilhoModel(
      idScrip: map['idTitulo']?.toInt() ?? 0,
      teachingName: map['nomeEnsinamento'] ?? '',
      teachingText: map['textoEnsinamento'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory GatilhoModel.fromJson(String source) =>
      GatilhoModel.fromMap(json.decode(source));
}
