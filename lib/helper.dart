import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Future<String?> showDateTimePickerAndSetField({
  required FocusNode currentNode,
  required TextEditingController textFieldController,
  required BuildContext context,
  required DateTime abnahme,
  required DateTime gabe,
  required String toset,
  required bool tapped,
  FocusNode? nextNode,
}) async {
  if (currentNode.hasFocus && textFieldController.text.isEmpty && !tapped) {
    final date = await showDatePicker(
      context: context,
      initialDate: await DateTime.now(),
      firstDate: await DateTime(2000),
      lastDate: await DateTime(2100),
      helpText: await toset == 'gabe'
          ? 'Medikationsgabe-Datum'
          : 'Spiegelabnahme-Datum',
    );
    if (date == null) {
      FocusScope.of(context).unfocus();
      return null; // user cancels date selection
    }

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      helpText: await toset == 'gabe'
          ? 'Medikationsgabe-Uhrzeit'
          : 'Spiegelabnahme-Uhrzeit',
    );
    if (time == null) {
      FocusScope.of(context).unfocus();
      return null; // user cancels time selection
    }

    final dateTime = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
    textFieldController.text = await DateFormat('dd/MM-kk:mm').format(dateTime);
    if (toset == 'gabe') {
      gabe = dateTime;
    } else if (toset == 'abnahme') {
      abnahme = dateTime;
    }
    if (nextNode != null) nextNode.requestFocus();
  }
  return null;
}

Future<DateTime> showDateTimePickerAndSetField2({
  required FocusNode currentNode,
  required TextEditingController textFieldController,
  required BuildContext context,
  required DateTime abnahme,
  required DateTime gabe,
  required String toset,
  required bool tapped,
  FocusNode? nextNode,
}) async {
  if (currentNode.hasFocus && textFieldController.text.isEmpty && !tapped) {
    final date = await showDatePicker(
      context: context,
      initialDate: await DateTime.now(),
      firstDate: await DateTime(2000),
      lastDate: await DateTime(2100),
      helpText: await toset == 'gabe'
          ? 'Medikationsgabe-Datum'
          : 'Spiegelabnahme-Datum',
    );
    if (date == null) {
      FocusScope.of(context).unfocus();
      if (toset == 'gabe')
        return gabe;
      else
        return abnahme;
    }

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      helpText: await toset == 'gabe'
          ? 'Medikationsgabe-Uhrzeit'
          : 'Spiegelabnahme-Uhrzeit',
    );
    if (time == null) {
      FocusScope.of(context).unfocus();
      if (toset == 'gabe')
        return gabe;
      else
        return abnahme; // user cancels time selection
    }

    final dateTime = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
    textFieldController.text = await DateFormat('dd/MM-kk:mm').format(dateTime);
    if (toset == 'gabe') {
      gabe = dateTime;
      return gabe;
    } else if (toset == 'abnahme') {
      abnahme = dateTime;
      return abnahme;
    }
  }
  return abnahme;
}
