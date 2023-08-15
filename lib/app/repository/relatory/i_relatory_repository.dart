import 'package:reportpad/app/model/teaching_model.dart';
import 'package:reportpad/app/repository/repository.dart';

import '../../model/scrip_model.dart';
import '../../model/survey_model.dart';

abstract class IRelatoryRepository extends Repository {
  Future<List<SurveyModel>> getSurveys(String phone);
  Future<List<ScripModel>> getScrips(String idSurvey);
  Future<TeachingModel> getTeachings(String idTeaching, String idSurvey);
  Future<void> getPreviewReport(String phone, String procedure, String idSurvey, String html, bool isPDF);
}
