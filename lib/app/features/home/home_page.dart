import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reportpad/app/core/ui/extensions/size_extensions.dart';
import 'package:reportpad/app/features/home/view/home_view.dart';
import 'package:reportpad/app/repository/auth/i_auth_repository.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends HomeView<HomePage> {
  final TextEditingController phoneCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    repository = Modular.get<IAuthRepository>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: SizedBox.expand(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(
                'assets/images/logo.png',
                color: Colors.black,
              ),
              SizedBox(
                width: .75.sw,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Entre com seu telefone para receber um token de acesso válido por 60 segundos.",
                      style: GoogleFonts.inter(),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    IntlPhoneField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(),
                        ),
                      ),
                      disableLengthCheck: true,
                      languageCode: "pt-BR",
                      searchText: "Selecione a Bandeira",
                      initialCountryCode: "BR",
                      onChanged: (phone) {
                        phoneCtrl.text = phone.completeNumber;
                      },
                      onCountryChanged: (country) {
                        print('Country changed to: ' + country.name);
                      },
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 1,
              ),
              Column(
                children: [
                  SizedBox(
                    width: .85.sw,
                    height: 60,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: const BorderSide(
                            color: Colors.black,
                          ),
                        ),
                        shadowColor: Colors.transparent,
                        backgroundColor: Colors.transparent,
                      ),
                      onPressed: () {
                        onSubmit(context);
                      },
                      child: Text(
                        "Solicitar Token",
                        style: GoogleFonts.inter(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text("V1.0.2"),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onSubmit(context) async {
    final phone = phoneCtrl.text
        .replaceAll("(", "")
        .replaceAll(")", "")
        .replaceAll("-", "")
        .replaceAll(" ", "")
        .replaceAll("+", "");
    bool res = await sendPhone(phone);
    if (res) {
      Modular.to.pushNamed('/validate_token/', arguments: phone);
      showTopSnackBar(
        Overlay.of(context),
        const CustomSnackBar.success(
          message: "WhatsApp Enviado com sucesso !",
        ),
      );
    } else {
      showTopSnackBar(
        Overlay.of(context),
        const CustomSnackBar.error(
          message: "Tivemos alguns problemas no servidor!",
        ),
      );
    }
  }
}
