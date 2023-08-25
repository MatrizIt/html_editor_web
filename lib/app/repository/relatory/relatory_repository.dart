import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:reportpad/app/model/image_ftp_model.dart';
import 'package:reportpad/app/model/scrip_model.dart';
import 'package:reportpad/app/model/survey_model.dart';
import 'package:reportpad/app/model/teaching_model.dart';
import 'package:reportpad/app/repository/relatory/i_relatory_repository.dart';
import 'package:intl/intl.dart';

class RelatoryRepository extends IRelatoryRepository {
  String? phone;

  @override
  Future<List<SurveyModel>> getSurveys(String phone) async {
    this.phone = phone;
    final date = getDatetime();
    final response = await get(
        "PegarAgenda?chave=$phone&ExibirDat=${true}&dataInicial=$date&dataFinal=$date&workflow=${0}");
    return (jsonDecode(response?.data) as List)
        .map<SurveyModel>((survey) => SurveyModel.fromMap(survey))
        .toList();
  }

  String getDatetime() {
    return DateFormat("yyyy-MM-dd").format(DateTime.parse("2023-08-18"));
  }

  @override
  Future<List<ScripModel>> getScrips(String idSurvey) async {
    final response =
        await get("TitulosMesclados?chave=$phone&idAgendamento=$idSurvey");
    return (jsonDecode(response?.data) as List)
        .map<ScripModel>((scrip) => ScripModel.fromMap(scrip))
        .toList();
  }

  @override
  Future<TeachingModel> getTeachings(String idTeaching, String idSurvey) async {
    final response = await get(
        "EnsinamentosMesclados?idEnsinamento=$idTeaching&idAgendamento=$idSurvey");

    print("Agendamento e ensinamento ");

    return TeachingModel.fromMap(jsonDecode(response?.data)['ensinamentos'][0]);
  }

  @override
  Future<dynamic> getPreviewReport(String phone, int idProcedure, int idSurvey,
      String html, bool isPDF) async {
    final finalHTML = html.replaceAll("&", "%26");
    var response = await get(
        "PreviewReport?chave=$phone&idProcedimento=$idProcedure&idAgendamento=$idSurvey&html=$finalHTML&pdf=$isPDF");

    return response?.data;
  }

  @override
   Future<List<ImageFtpModel>>getImagesFtp(String phone, String studyId, String patientId) async{
      var response = await get("PegarImagensFtp?Chave=$phone&StudyId=$studyId&PacienteID=$patientId");

      print("URL > PegarImagensFtp?Chave=$phone&StudyId=$studyId&PacienteID=$patientId");

      return (jsonDecode(response?.data) as List)
          .map<ImageFtpModel>((image) => ImageFtpModel.fromMap(image))
          .toList();
  }
}
