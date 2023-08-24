import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reportpad/app/core/ui/extensions/size_extensions.dart';
import 'package:reportpad/app/features/worklist/view/worklist_view.dart';
import 'package:reportpad/app/repository/relatory/i_relatory_repository.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WorklistPage extends StatefulWidget {
  final String phone;
  const WorklistPage({
    super.key,
    required this.phone,
  });

  @override
  State<WorklistPage> createState() => _WorklistPageState();
}

class _WorklistPageState extends WorklistView<WorklistPage> {
  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    repository = Modular.get<IRelatoryRepository>();
    getSurveys(widget.phone);
    initSharedPreferences();
  }

  void initSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _prefs.setBool("isTrust", _prefs.getBool('isChecked') ?? false);
      print("Valor prefs > ${_prefs.getBool('isChecked')}");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromRGBO(0, 160, 0, 100),
        onPressed: () {
          getSurveys(widget.phone);
        },
        child: const Icon(
          Icons.refresh_outlined,
          color: Colors.white,
        ),
      ),
      appBar: AppBar(

        title: Row(
          children: [
            Image.asset(
              "assets/images/icon.png",
              width: 50,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              "WorkList Realizados",
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Visibility(
          visible: isLoading == false,
          replacement: const Center(
            child: CircularProgressIndicator(),
          ),
          child: ListView.separated(
            separatorBuilder: (context, index) {
              return const SizedBox(
                height: 10,
              );
            },
            itemCount: worklist.length,
            itemBuilder: (context, index) {
              worklist.sort((a, b) => a.scheduleDate.compareTo(b.scheduleDate));
              final survey = worklist[index];
              final hour = DateFormat("Hm").format(survey.scheduleDate);
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: GestureDetector(
                  onTap: () {
                    print("Survey > ${survey.id}");

                    getScrips(survey.id.toString(), survey.procedureName, widget.phone, survey.idProcedure.toString());
                  },
                  child: Container(
                    width: .85.sw,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 15,
                    ),
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(1, 134, 167,100),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.black,
                        width: 1,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(survey.procedureName, style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold
                        ),),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(hour,style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold
                            ),),

                            Text(
                                "Paciente: ${survey.patient}"),
                            const Text(""),
                            const Text(""),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(survey.healthInsuranceName, textAlign: TextAlign.center,)
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
