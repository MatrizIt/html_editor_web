import 'dart:convert';

class ImageFtpModel {
  final String bytes;
  final String extension;
  final String nameFile;

  const ImageFtpModel({
    required this.bytes,
    required this.extension,
    required this.nameFile,
  });

  Map<String, dynamic> toMap() {
    return {
      'bytes': bytes,
      'extensão': extension,
      'nomeArquivo': nameFile,
    };
  }

  factory ImageFtpModel.fromMap(Map<String, dynamic> map) {
    return ImageFtpModel(
      bytes: map['bytes'] ?? '',
      extension: map['extensão'] ?? '',
      nameFile: map['nomeArquivo'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ImageFtpModel.fromJson(String source) =>
      ImageFtpModel.fromMap(json.decode(source));
}
