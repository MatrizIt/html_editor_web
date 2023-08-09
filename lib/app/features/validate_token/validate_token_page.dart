import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:html_editor_web/app/core/ui/extensions/size_extensions.dart';
import 'package:html_editor_web/app/features/validate_token/view/validate_token_view.dart';
import 'package:html_editor_web/app/repository/auth/i_auth_repository.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class ValidateTokenPage extends StatefulWidget {
  final String phone;
  const ValidateTokenPage({
    super.key,
    required this.phone,
  });

  @override
  State<ValidateTokenPage> createState() => _ValidateTokenPageState();
}

class _ValidateTokenPageState extends ValidateTokenView<ValidateTokenPage> {
  final pinCtrl = TextEditingController();
  bool loading = false;

  @override
  void initState() {
    super.initState();
    repository = Modular.get<IAuthRepository>();
  }

  @override
  void dispose() {
    pinCtrl.dispose();
    super.dispose();
  }

  onSendToken() async {
    print("Olá Mundo");
    await sendToken(pinCtrl.text);
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
                      "Digite o token enviado para seu Whatsapp:",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1,
                          color: Colors.black,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      width: .85.sw,
                      child: PinCodeTextField(
                        controller: pinCtrl,
                        appContext: context,
                        keyboardType: TextInputType.number,
                        length: 4,
                        cursorColor: Colors.black,
                        pinTheme: PinTheme(
                          activeColor: Colors.black,
                          disabledColor: Colors.black,
                          inactiveColor: Colors.black,
                          selectedColor: Colors.black,
                          activeFillColor: Colors.black,
                          errorBorderColor: Colors.black,
                          inactiveFillColor: Colors.black,
                          selectedFillColor: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    SizedBox(
                      width: .7.sw,
                      child: RichText(
                        textAlign: TextAlign.end,
                        text: TextSpan(
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: Colors.black,
                          ),
                          children: [
                            const TextSpan(
                              text: "Caso não tenha recebido, ",
                            ),
                            TextSpan(
                              text: "Clique aqui...",
                              recognizer: TapGestureRecognizer()
                                ..onTap = () async {
                                  setState(() {
                                    loading = true;
                                  });
                                  await requestToken(widget
                                      .phone); //CHAMADA DA FUNÇÃO requestToken
                                  setState(() {
                                    loading = false;
                                  });
                                },
                              style: GoogleFonts.inter(
                                color: Colors.blueAccent,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
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
                      onPressed: onSendToken,
                      child: loading
                          ? const CircularProgressIndicator(
                              color: Colors.black,
                            )
                          : Text(
                              "Confirmar Token",
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
}
