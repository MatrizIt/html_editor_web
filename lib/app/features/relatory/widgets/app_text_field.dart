import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:reportpad/app/core/ui/helpers/phrase_editing_controller.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:intl/intl.dart';

import 'app_dropdown_textfield.dart';

enum Type {
  selection,
  multiselection,
  text,
  date,
  cpf,
  currency,
  number,
  error,
}

class AppTextField extends StatefulWidget {
  late final Type? type;
  final List<String> options = [];
  final String phrase;
  final String selectedOption;
  final Function(String text) onChanged;
  final PhraseEditingController controller;
  var defaultValue = "";

  AppTextField({
    super.key,
    required this.phrase,
    required this.onChanged,
    required this.controller,
    required this.selectedOption,
  }) {
    RegExp exp = RegExp(r'!\*([^\(]+)\(([^\)]+)\)=?(.*?)?\*!');
    RegExpMatch? match;
    String typeRecognized;
    try {
      match = exp.allMatches(phrase).first;
      typeRecognized = match.group(1)!;
    } catch (e) {
      match = null;
      typeRecognized = "";
    }

    switch (typeRecognized) {
      case 'multiselect':
        type = Type.multiselection;
        break;
      case 'select':
        type = Type.selection;
        break;
      case 'num':
        type = Type.number;
        defaultValue = "00";
        break;
      case 'cpf':
        type = Type.cpf;
        break;
      case 'currency':
        type = Type.currency;
        break;
      case 'data':
        type = Type.date;
        defaultValue = "01/01/2000";
        break;
      case "":
        type = Type.error;
        break;
      case 'text':
      default:
        type = Type.text;
        defaultValue = "_____";
        break;
    }
    if ([Type.multiselection, Type.selection].contains(type)) {
      match?.group(2)!.split(",").forEach(
        (option) {
          options.add(option);
        },
      );
    }
  }

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  final textCtrl = TextEditingController();
  final border = OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: const BorderSide(
      color: Colors.black,
      width: 1,
    ),
  );
  final MultiValueDropDownController _ctrlMulti =
      MultiValueDropDownController();

  String? getLabel(String text) {
    try {
      final regexp = RegExp(r"!\*.+\(.*?.*?\)=(.*?)\*!");
      regexp.allMatches(text).forEach((element) {
        print("Element > ${element.group(1)}");
      });

      return regexp.allMatches(text).first.group(1) ?? "";
    } catch (e) {
      return null;
    }
    /*return text.replaceAllMapped(
      RegExp(r"!*.+(.?.?)=(.*?)*!"),
      (match) => match.group(1) ?? "",
    );*/
  }

  @override
  void initState() {
    super.initState();
    print(widget.phrase);
  }

  TextInputType? setKeyboardType() {
    if ([Type.cpf, Type.currency, Type.number].contains(widget.type)) {
      return TextInputType.number;
    }
    return null;
  }

  void pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().year - 10),
      lastDate: DateTime(DateTime.now().year + 10),
    );

    if (date != null) {
      widget.controller.text = DateFormat('dd/MM/yyyy').format(date);
    }
  }

  List<TextInputFormatter> fillInputFormatters() {
    final textInputFormatters = <TextInputFormatter>[];
    if (widget.type == Type.currency) {
      textInputFormatters.add(
        CurrencyTextInputFormatter(
          locale: 'pt-BR',
          name: "R\$",
        ),
      );
    }
    if (widget.type == Type.cpf) {
      textInputFormatters.add(MaskTextInputFormatter(mask: "###.###.###-##"));
    }
    return textInputFormatters;
  }

  final List<String> selectedOptions = [];

  @override
  Widget build(BuildContext context) {
    return _selectInputType();
  }

  Widget _selectInputType() {
    return <Widget>() {
      final List<DropDownValueModel> parsedOptions =
          widget.options.map<DropDownValueModel>((option) {
        return DropDownValueModel(
          name: option,
          value: option,
        );
      }).toList();
      switch (widget.type) {
        case Type.selection:
          return AppDropdownTextfield(
            options: widget.options,
            onSelectOption: (value) {
              setState(() {
                widget.onChanged(value as String);
              });
            },
            selectedOption: widget.controller.text,
            hintText: "Selecione",
          );
        case Type.multiselection:
          return DropDownTextField.multiSelection(
            initialValue: parsedOptions[0].value,
            onChanged: (values) {
              String parsed = "";
              if (values is List<DropDownValueModel>) {
                for (int i = 0; i < values.length; i++) {
                  if (i == 0) {
                    parsed = values[i].name;
                    continue;
                  }
                  if (values.length == 2) {
                    parsed += " e ${values[i].name}";
                    continue;
                  }
                  if (values.length == 3) {
                    if (i == 1) {
                      parsed += ", ${values[i].name}";
                      continue;
                    }
                    parsed += " e ${values[i].name}";
                    continue;
                  }
                }
              }
              widget.onChanged(parsed);
            },
            displayCompleteItem: true,
            textFieldDecoration: InputDecoration(
                border: const UnderlineInputBorder(borderSide: BorderSide.none),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                hintText: "${parsedOptions[0].name} ",
                hintStyle: const TextStyle(color: Colors.blue)),
            dropDownList: parsedOptions,
          );
        case Type.error:
          return Text(widget.phrase);
        default:
          return TextField(
            readOnly: widget.type == Type.date,
            textAlignVertical: TextAlignVertical.center,
            onTap: widget.type == Type.date ? pickDate : null,
            inputFormatters: fillInputFormatters(),
            keyboardType: setKeyboardType(),
            controller: widget.controller,
            decoration: InputDecoration(
              border: const UnderlineInputBorder(borderSide: BorderSide.none),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              hintText: getLabel(widget.phrase) ?? widget.defaultValue,
              hintStyle: TextStyle(
                color: Colors.blue,
              ),
            ),
          );
      }
    }();
  }
}
