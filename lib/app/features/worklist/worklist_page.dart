import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reportpad/app/core/ui/extensions/size_extensions.dart';
import 'package:reportpad/app/features/worklist/view/worklist_view.dart';
import 'package:reportpad/app/repository/relatory/i_relatory_repository.dart';
import 'package:intl/intl.dart';

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
  @override
  void initState() {
    super.initState();
    repository = Modular.get<IRelatoryRepository>();
    getSurveys(widget.phone);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              final survey = worklist[index];
              final hour = DateFormat("Hm").format(survey.scheduleDate);
              return GestureDetector(
                onTap: () {
                  getScrips(survey.id.toString(), survey.procedureName);
                },
                child: Container(
                  width: .85.sw,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 15,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.black,
                      width: 2,
                    ),
                  ),
                  child: Text(
                      "$hour ${survey.patient} - ${survey.procedureName} - ${survey.healthInsuranceName}"),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
