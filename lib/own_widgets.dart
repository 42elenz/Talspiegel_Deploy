import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:talspiegel/med_lists.dart';
import 'models.dart';

class InputTextBox extends StatelessWidget {
  final List<TextInputFormatter>? inputFormatters;
  final TextEditingController controller;
  final void Function(String)? onChanged;
  final TextInputType? keyboardType;
  final EdgeInsetsGeometry padding;
  final String? unit;
  final String name;
  final int maxlength;
  final String infotext;
  final String infoname;

  const InputTextBox(
      {Key? key,
      required this.controller,
      required this.onChanged,
      required this.name,
      required this.infoname,
      required this.infotext,
      this.inputFormatters,
      this.unit,
      required this.maxlength,
      this.keyboardType = TextInputType.number,
      this.padding = const EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0)})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: TextField(
        maxLength: maxlength,
        onChanged: onChanged,
        controller: controller,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        decoration: InputDecoration(
            enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black38)),
            counterText: "",
            suffixText: unit,
            suffixIconConstraints:
                const BoxConstraints(minWidth: 0, minHeight: 0),
            suffixIcon: IconButton(
              icon: const Icon(Icons.info_outline_rounded, size: 20),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        backgroundColor: Color.fromARGB(236, 149, 204, 252),
                        title: Text(infoname),
                        content: Text(infotext),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text(
                                "OK",
                                style: TextStyle(color: Colors.black),
                              ))
                        ],
                      );
                    });
              },
            ),
            label: Text(name,
                style: const TextStyle(fontSize: 15, color: Colors.blueGrey))),
      ),
    );
  }
}

class Dropdown_Medication extends StatefulWidget {
  int radius;
  MedicationType? dropdownValue;
  List<Medication?> dropdownItems;
  TextEditingController textfield_hwz;
  TextEditingController textfield_tmin;

  Dropdown_Medication({
    this.radius = 10,
    this.dropdownValue,
    required this.dropdownItems,
    required this.textfield_hwz,
    required this.textfield_tmin,
  });

  @override
  _Dropdown_MedicationState createState() => _Dropdown_MedicationState();
}

class _Dropdown_MedicationState extends State<Dropdown_Medication> {
  String selectedMedication = 'Alle';
  List<String> medications = [
    'Alle',
    'Antidepressiva',
    'Antikonvulsiva',
    'Anxiolytika',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
        child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
                value: selectedMedication,
                items: medications.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? value) {
                  setState(() {
                    if (value == 'Alle') {
                      widget.dropdownValue = null;
                      widget.textfield_hwz.text = '';
                      widget.textfield_tmin.text = '';
                      dropdownItems = AllItems;
                    }
                  });
                })));
  }
}

Widget createInfoIconButton(
    String title, String content, BuildContext context) {
  return IconButton(
    icon: const Icon(
      Icons.info_outline_rounded,
      size: 20,
      color: Colors.black,
    ),
    onPressed: () {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Color.fromARGB(236, 149, 204, 252),
            title: Text(title),
            content: Text(content),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  "OK",
                  style: TextStyle(color: Colors.black),
                ),
              )
            ],
          );
        },
      );
    },
  );
}
