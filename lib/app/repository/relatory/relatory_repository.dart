import 'dart:convert';

import 'package:html_editor_web/app/model/scrip_model.dart';
import 'package:html_editor_web/app/model/survey_model.dart';
import 'package:html_editor_web/app/repository/relatory/i_relatory_repository.dart';
import 'package:intl/intl.dart';

class RelatoryRepository extends IRelatoryRepository {
  String? phone;

  @override
  Future<List<SurveyModel>> getSurveys(String phone) async {
    this.phone = phone;
    final date = getDatetime();
    final response = await get(
        "PegarAgenda?chave=5511985858505&ExibirDat=${true}&dataInicial=$date&dataFinal=$date&workflow=${0}");
    return (jsonDecode(response?.data) as List)
        .map<SurveyModel>((survey) => SurveyModel.fromMap(survey))
        .toList();
  }

  String getDatetime() {
    return DateFormat("yyyy-MM-dd").format(DateTime(2023, 8, 6));
  }

  @override
  Future<List<ScripModel>> getScrips(String idSurvey) async {
    final response = await get(
        "TitulosMesclados?chave=5511985858505&idAgendamento=$idSurvey");
    return (jsonDecode(response?.data) as List)
        .map<ScripModel>((scrip) => ScripModel.fromMap(scrip))
        .toList();
  }

  // @override
  // Future getTeachings(String scrip) async {
  //   final response = await get("Ensinamentos?id=string&idTitulo=$scrip");
  // }
}
