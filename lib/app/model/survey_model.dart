import 'dart:convert';
import 'package:intl/intl.dart';

class SurveyModel {
  final int id;
  final int idProcedure;
  final String patient;
  final String patientGender;
  final String procedureName;
  final String healthInsuranceName;
  final DateTime scheduleDate;
  final String doctor;
  final String requesterName;

  SurveyModel({
    required this.id,
    required this.idProcedure,
    required this.patient,
    required this.patientGender,
    required this.procedureName,
    required this.healthInsuranceName,
    required this.scheduleDate,
    required this.doctor,
    required this.requesterName,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'procedimento': idProcedure,
      'nomeCompleto': patient,
      'sexo': patientGender,
      'nomeProcedimento': procedureName,
      'nomeConvenio': healthInsuranceName,
      'dataExane': DateFormat("yyyy-MM-ddTHH:mm:ss").format(scheduleDate),
      'nomeRealizador': doctor,
      'nomeSolicitante': requesterName,
    };
  }

  factory SurveyModel.fromMap(Map<String, dynamic> map) {
    try {
      return SurveyModel(
        id: map['id'],
        idProcedure: map['procedimento'],
        patient: map['nomeCompleto'] ?? '',
        patientGender: map['sexo'] ?? '',
        procedureName: map['nomeProcedimento'] ?? '',
        healthInsuranceName: map['nomeConvenio'] ?? '',
        scheduleDate: DateTime.tryParse(
                (map['dataExame'] as String).replaceAll("T", " ")) ??
            DateTime.now(),
        doctor: map['nomeRealizador'] ?? '',
        requesterName: map['nomeSolicitante'] ?? '',
      );
    } catch (e, s) {
      print("Erro: $e, stackTrace: $s");
      throw Exception();
    }
  }

  String toJson() => json.encode(toMap());

  factory SurveyModel.fromJson(String source) =>
      SurveyModel.fromMap(json.decode(source));
}
