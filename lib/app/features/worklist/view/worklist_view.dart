import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:reportpad/app/model/survey_model.dart';
import 'package:reportpad/app/repository/relatory/i_relatory_repository.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

abstract class WorklistView<T extends StatefulWidget> extends State<T> {
  late final IRelatoryRepository repository;
  List<SurveyModel> worklist = [];
  bool isLoading = false;

  Future<void> getSurveys(String phone) async {
    try {
      setState(() {
        isLoading = true;
      });
      worklist = await repository.getSurveys(phone) ?? [];

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      showTopSnackBar(
        Overlay.of(context),
        displayDuration: const Duration(seconds: 3),
        const CustomSnackBar.error(
          maxLines: 4,
          message: "Ocorreu um erro !",
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> getScrips(String idSurvey, String title, String phone,
      String idProcedure, String patientId, String studyId) async {
    try {
      setState(() {
        isLoading = true;
      });
      final scrips = await repository.getScrips(idSurvey);
      final imagesFTP =
          await repository.getImagesFtp(phone, studyId, patientId) ?? [];
      log("Images > ${imagesFTP[0].bytes}");
      setState(() {
        isLoading = false;
      });
      Modular.to.pushNamed(
        '/relatory',
        arguments: {
          'Scrips': scrips,
          'Title': title,
          'idSurvey': idSurvey,
          'phone': phone,
          'procedure': idProcedure,
          'patientId': patientId,
          'studyId': studyId,
          'imageList': imagesFTP
        },
      );
    } catch (e) {
      showTopSnackBar(
        Overlay.of(context),
        displayDuration: const Duration(seconds: 3),
        const CustomSnackBar.error(
          maxLines: 4,
          message: "Ocorreu um erro !",
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
