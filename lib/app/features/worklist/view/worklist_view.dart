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
    worklist = await repository.getSurveys("5511985858505");
    setState(() {
      isLoading = false;
    });
  }

  Future<void> getScrips(String idSurvey, String title) async {
    final scrips = await repository.getScrips(idSurvey);
    Modular.to
        .pushNamed('/relatory', arguments: {'Scrips': scrips, 'Title': title});
  }
}
