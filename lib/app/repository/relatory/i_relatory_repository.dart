import 'package:reportpad/app/repository/repository.dart';

import '../../model/scrip_model.dart';
import '../../model/survey_model.dart';

abstract class IRelatoryRepository extends Repository {
  Future<List<SurveyModel>> getSurveys(String phone);
  Future<List<ScripModel>> getScrips(String idSurvey);
  // Future<dynamic> getTeachings(String scrip);
}
