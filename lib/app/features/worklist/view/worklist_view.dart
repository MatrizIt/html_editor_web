import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:reportpad/app/model/survey_model.dart';
import 'package:reportpad/app/repository/relatory/i_relatory_repository.dart';

abstract class WorklistView<T extends StatefulWidget> extends State<T> {
  late final IRelatoryRepository repository;
  List<SurveyModel> worklist = [];
  bool isLoading = false;

  Future<void> getSurveys(String phone) async {
    setState(() {
      isLoading = true;
    });
    worklist = await repository.getSurveys(phone);

    setState(() {
      isLoading = false;
    });
  }

  Future<void> getScrips(String idSurvey, String title, String phone, String idProcedure, String patientId, String studyId) async {
    final scrips = await repository.getScrips(idSurvey);
    final imagesFTP = await repository.getImagesFtp(phone, studyId, patientId);
    log("Images > ${imagesFTP[0].bytes}");

    Modular.to.pushNamed('/relatory',
        arguments: {'Scrips': scrips, 'Title': title, 'idSurvey': idSurvey, 'phone': phone, 'procedure': idProcedure, 'patientId': patientId, 'studyId':studyId,  'imageList' : imagesFTP},);
  }

}
