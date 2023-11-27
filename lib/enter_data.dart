import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:talspiegel/own_widgets.dart';

import 'med_lists.dart';
import 'models.dart';

import 'result.dart';
import 'choice_screen2.dart';
import 'helper.dart';

class EnterDataForm extends StatefulWidget {
  const EnterDataForm({Key? key}) : super(key: key);

  @override
  _EnterDataFormState createState() => _EnterDataFormState();
}

String? validateInput(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter a value';
  }
  return null;
}

class _EnterDataFormState extends State<EnterDataForm> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController textfield_tmin = TextEditingController();
  TextEditingController textfield_gabe = TextEditingController();
  TextEditingController textfield_ct = TextEditingController();
  TextEditingController textfield_hwz = TextEditingController();
  TextEditingController textfield_abn = TextEditingController();

  FocusNode textfield_ct_focus = FocusNode();
  FocusNode textfield_gabe_focus = FocusNode();
  FocusNode textfield_abn_focus = FocusNode();
  FocusNode textfield_substanz_focus = FocusNode();

  DateTime gabe = DateTime.now().subtract(const Duration(days: 100));
  DateTime abnahme = DateTime.now().add(const Duration(days: 100));
  String floatingRegeEp = "[+-]?([0-9]+([.][0-9]*)?|[.][0-9]+)";

  MedicationType? selectedMedicationType = MedicationType.Substanzklasse;
  List<Medication?> dropdownItems = AllItems;

  Medication? dropdownValue = AllItems[0];
  String classvalue = 'Filtern nach Substanzklasse';

  String? _gabeError;
  String? _abnahmeError;
  String? _spiegelError;
  String? _hwzError;
  String? _tminError;
  String? _verteilungsvolError;

  bool tapped = false;

  final borderSideColor = Color.fromRGBO(224, 227, 231, 1);
  final borderColorFilled = Color(0xFF4DABF6);
  final focusBorderSideColor = Color(0xFF4DABF6);
  final errorBorderSideColor = Colors.red;
  final labelStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: Colors.black,
    fontFamily: 'Readex Pro',
  );

  final hintStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: Colors.black,
    fontFamily: 'Readex Pro',
  );

  final styleHeaderAppBar = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.normal,
    color: Colors.black,
    fontFamily: GoogleFonts.outfit().fontFamily,
  );

  String duration() {
    //function to change return hours as a String in hours and days
    int hours = int.tryParse(textfield_hwz.text) ?? -99;
    if (hours == -99) return ('');
    hours *= 5;
    int days = hours ~/ 24;
    int rest = hours % 24;
    String result = '';
    if (days > 0) {
      if (days == 1)
        result = days.toString() + ' Tag';
      else if (days > 1) result = days.toString() + ' Tagen';
    }
    if (rest > 0) {
      if (days > 0) result = result + ' ';
      if (rest == 1)
        result = result + rest.toString() + ' Stunde';
      else if (rest > 1) result = result + rest.toString() + ' Stunden';
    }
    return result;
  }

  void _ChangeToDropdown() {
    textfield_substanz_focus.requestFocus();
    final context = textfield_substanz_focus.context;
    if (context != null) {
      Scrollable.ensureVisible(context);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (FocusManager.instance.primaryFocus?.hasFocus == true) {
          FocusManager.instance.primaryFocus?.unfocus();
        }
      },
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
          key: scaffoldKey,
          backgroundColor: Colors.white.withOpacity(0.4),
          appBar: PreferredSize(
              preferredSize: Size.fromHeight(kToolbarHeight),
              child: CustomAppBar(screenName: 'Eingabe')),
          body: SafeArea(
            top: true,
            child: Center(
              child: SingleChildScrollView(
                child: SizedBox(
                  width: 700,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Align(
                        alignment: AlignmentDirectional(0.00, 0.00),
                        child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Align(
                                alignment: AlignmentDirectional(0.00, 0.00),
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      45, 5, 50, 5),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.transparent,
                                            border: Border.all(
                                              color: classvalue ==
                                                      'Filtern nach Substanzklasse'
                                                  ? borderSideColor
                                                  : borderColorFilled,
                                              width: 2,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: DropdownButton<String>(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              value: classvalue,
                                              isExpanded: true,
                                              underline: Container(),
                                              menuMaxHeight: 300,
                                              items: medications
                                                  .map((String value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: (value !=
                                                            'Filtern nach Substanzklasse')
                                                        ? Center(
                                                            child: Text(value,
                                                                overflow:
                                                                    TextOverflow
                                                                        .visible,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal)),
                                                          )
                                                        : const Text(
                                                            "Filtern nach Substanzklasse",
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal)),
                                                  ),
                                                );
                                              }).toList(),
                                              onChanged: (String? value) {
                                                setState(() {
                                                  if (value ==
                                                      'Filtern nach Substanzklasse') {
                                                    dropdownValue = null;
                                                    textfield_hwz.text = '';
                                                    textfield_tmin.text = '';
                                                    dropdownItems = AllItems;
                                                    classvalue =
                                                        'Filtern nach Substanzklasse';
                                                  } else if (value ==
                                                      'Antidepressiva') {
                                                    dropdownValue = null;
                                                    textfield_hwz.text = '';
                                                    textfield_tmin.text = '';
                                                    dropdownItems =
                                                        AntidepressivaItems;
                                                    classvalue =
                                                        'Antidepressiva';
                                                    textfield_substanz_focus
                                                        .requestFocus();
                                                  } else if (value ==
                                                      'Antipsychotika') {
                                                    dropdownValue = null;
                                                    textfield_hwz.text = '';
                                                    textfield_tmin.text = '';
                                                    dropdownItems =
                                                        AntpsychotikaItems;
                                                    classvalue =
                                                        'Antipsychotika';
                                                    textfield_substanz_focus
                                                        .requestFocus();
                                                  } else if (value ==
                                                      'Antikonvulsiva') {
                                                    dropdownValue = null;
                                                    textfield_hwz.text = '';
                                                    textfield_tmin.text = '';
                                                    dropdownItems =
                                                        AntikonvulsivaItems;
                                                    classvalue =
                                                        'Antikonvulsiva';
                                                    textfield_substanz_focus
                                                        .requestFocus();
                                                  } else if (value ==
                                                      'Anxiolytika') {
                                                    dropdownValue = null;
                                                    textfield_hwz.text = '';
                                                    textfield_tmin.text = '';
                                                    dropdownItems =
                                                        AnxiolytikaItems;
                                                    classvalue = 'Anxiolytika';
                                                    textfield_substanz_focus
                                                        .requestFocus();
                                                  } else if (value ==
                                                      'Sucht-Med.') {
                                                    dropdownValue = null;
                                                    textfield_hwz.text = '';
                                                    textfield_tmin.text = '';
                                                    dropdownItems = SuchtItems;
                                                    classvalue = 'Sucht-Med.';
                                                    textfield_substanz_focus
                                                        .requestFocus();
                                                  } else if (value ==
                                                      'Sonstige') {
                                                    dropdownValue = null;
                                                    textfield_hwz.text = '';
                                                    textfield_tmin.text = '';
                                                    dropdownItems =
                                                        SonstigeItems;
                                                    classvalue = 'Sonstige';
                                                    textfield_substanz_focus
                                                        .requestFocus();
                                                  }
                                                  dropdownItems.sort((a, b) {
                                                    if (a == null && b == null)
                                                      return 0;
                                                    if (a == null) return -1;
                                                    if (b == null) return 1;
                                                    return a.name
                                                        .compareTo(b.name);
                                                  });
                                                });
                                              }),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Align(
                                  alignment: AlignmentDirectional(0.00, 0.00),
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        45, 10, 50, 5),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.transparent,
                                              border: Border.all(
                                                color: dropdownValue == null
                                                    ? borderSideColor
                                                    : borderColorFilled,
                                                width: 2,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: DropdownButton(
                                                focusNode:
                                                    textfield_substanz_focus,
                                                underline: Container(),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                isExpanded: true,
                                                menuMaxHeight: 300,
                                                value: dropdownValue,
                                                items: dropdownItems.map(
                                                    (Medication? medication) {
                                                  return DropdownMenuItem(
                                                    value: medication,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: medication != null
                                                          ? Center(
                                                              child: Text(
                                                                  medication
                                                                      .name,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .visible,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal)),
                                                            )
                                                          : const Text(
                                                              "Substanz-Auswahl",
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: TextStyle(
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal)),
                                                    ),
                                                  );
                                                }).toList(),
                                                onChanged: (Medication? val) {
                                                  setState(() {
                                                    dropdownValue = val;
                                                    if (dropdownValue == null) {
                                                      textfield_hwz.text = '';
                                                      textfield_tmin.text = '';
                                                      return;
                                                    } else {
                                                      textfield_hwz.text =
                                                          dropdownValue!.hlf
                                                                  .toString() +
                                                              ' h';
                                                      textfield_tmin.text =
                                                          dropdownValue!.mintal
                                                                  .toString() +
                                                              ' h';

                                                      textfield_gabe_focus
                                                          .requestFocus();
                                                    }
                                                  });
                                                }),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                              Align(
                                alignment: AlignmentDirectional(0.00, 0.00),
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      45, 10, 45, 5),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: CustomTextInputField(
                                          controller: textfield_tmin,
                                          labelText: 'Verabreichungsintervall',
                                          hintText: 'in h',
                                          suffixText: 'h',
                                          infoText:
                                              "Das Verabreichungsintervall beschreibt den Abstand der Medikationsgaben. Dies entspricht dem Talspiegel-Zeitpunkt (tmin) in Stunden (h). Wenn Sie das Medikament z.B. einmal täglich geben, ist das Verabreichungsintervall (und somit tmin) mit 24h einzutragen.",
                                          onChanged: (p0) => setState(() {}),
                                          maxLength: 3,
                                          errorText: _tminError,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  7.5, 0, 0, 0),
                                          child: CustomTextInputField(
                                            controller: textfield_hwz,
                                            labelText: 'Halbwertszeit',
                                            hintText: 'in h',
                                            suffixText: 'h',
                                            infoText:
                                                "Die Halbwertszeit (HWZ) gibt an, wie lange es dauert, bis sich die Konzentration eines Medikaments in der Blutbahn halbiert hat. Geben Sie eine eigene HWZ ein oder nutzen Sie die hinterlegte HWZ des Medikaments in Stunden (h).",
                                            onChanged: (p0) => setState(() {}),
                                            maxLength: 4,
                                            regExp: floatingRegeEp,
                                            errorText: _hwzError,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Align(
                                alignment: AlignmentDirectional(0.00, 0.00),
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      45, 10, 45, 5),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: TextFormField(
                                          controller: textfield_gabe,
                                          focusNode: textfield_gabe_focus,
                                          keyboardType: TextInputType.none,
                                          onTap: () async {
                                            tapped = true;
                                            final date = await showDatePicker(
                                                context: context,
                                                initialEntryMode:
                                                    DatePickerEntryMode
                                                        .calendarOnly,
                                                initialDate: DateTime.now(),
                                                firstDate: DateTime.now()
                                                    .subtract(const Duration(
                                                        days: 30)),
                                                lastDate: DateTime.now().add(
                                                    const Duration(days: 30)),
                                                helpText:
                                                    'Medikationsgabe-Zeitpunkt');

                                            if (date == null)
                                              return; // user cancels date selection
                                            final time = await showTimePicker(
                                              helpText:
                                                  'Medikationsgabe-Zeitpunkt',
                                              context: context,
                                              initialTime: TimeOfDay.now(),
                                            );
                                            if (time == null)
                                              return; // user cancels time selection
                                            final dateTime = DateTime(
                                                date.year,
                                                date.month,
                                                date.day,
                                                time.hour,
                                                time.minute);
                                            setState(() {
                                              gabe = dateTime;
                                              if (gabe.compareTo(abnahme) > 0) {
                                                textfield_gabe.text =
                                                    DateFormat('dd/MM-kk:mm')
                                                        .format(dateTime);
                                                setState(() {
                                                  _gabeError =
                                                      "Chronologie beachten!";
                                                });
                                                return;
                                              }
                                              textfield_gabe.text =
                                                  DateFormat('dd/MM-kk:mm')
                                                      .format(dateTime);
                                              setState(() {
                                                if (_abnahmeError !=
                                                    'Wert eingeben') {
                                                  _gabeError = null;
                                                  _abnahmeError = null;
                                                } else
                                                  _gabeError = null;
                                              });
                                              textfield_abn_focus
                                                  .requestFocus();
                                            });
                                          },
                                          decoration: InputDecoration(
                                              filled: true,
                                              hintText:
                                                  'klicken um Datum einzutragen',
                                              hintStyle: hintStyle,
                                              fillColor: Colors.transparent,
                                              suffixIcon: createInfoIconButton(
                                                  "Medikationsgabe",
                                                  "Tragen Sie hier den Zeitpunkt der Medikationsgabe ein! Die Medikationsgabe muss zeitlich VOR der Spiegelabnahme liegen. Aktuell sind nur Zeitpunkte innerhalb der letzten 30 Tage möglich.",
                                                  context),
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: textfield_gabe
                                                          .text.isEmpty
                                                      ? borderSideColor
                                                      : borderColorFilled,
                                                  width: 2,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: focusBorderSideColor,
                                                  width: 2,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              errorBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: errorBorderSideColor,
                                                  width: 2,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              focusedErrorBorder:
                                                  OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: errorBorderSideColor,
                                                  width: 2,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              label: Text(
                                                  'Medikationsgabe-Zeitpunkt',
                                                  style: const TextStyle(
                                                      fontSize: 14,
                                                      color: Color.fromARGB(
                                                          255, 0, 0, 0))),
                                              errorText: _gabeError,
                                              errorStyle: const TextStyle(
                                                  color: Colors.red)),
                                          style: TextStyle(
                                            fontSize: 14,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    45, 10, 45, 5),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: TextFormField(
                                        controller: textfield_abn,
                                        focusNode: textfield_abn_focus,
                                        keyboardType: TextInputType.none,
                                        onChanged: (p0) => setState(() {}),
                                        onTap: () async {
                                          final date = await showDatePicker(
                                              context: context,
                                              initialEntryMode:
                                                  DatePickerEntryMode
                                                      .calendarOnly,
                                              initialDate: DateTime.now(),
                                              firstDate: DateTime.now()
                                                  .subtract(
                                                      const Duration(days: 30)),
                                              lastDate: DateTime.now().add(
                                                  const Duration(days: 30)),
                                              helpText:
                                                  'Spiegelabnahme-Zeitpunkt');
                                          if (date == null)
                                            return; // user cancels date selection
                                          final time = await showTimePicker(
                                            helpText:
                                                'Spiegelabnahme-Zeitpunkt',
                                            context: context,
                                            initialTime: TimeOfDay.now(),
                                          );
                                          if (time == null)
                                            return; // user cancels time selection
                                          final dateTime = DateTime(
                                              date.year,
                                              date.month,
                                              date.day,
                                              time.hour,
                                              time.minute);
                                          setState(() {
                                            abnahme = dateTime;
                                            if (gabe.compareTo(abnahme) > 0) {
                                              textfield_abn.text =
                                                  DateFormat('dd/MM-kk:mm')
                                                      .format(dateTime);
                                              setState(() {
                                                _abnahmeError =
                                                    "Chronologie beachten!";
                                              });
                                              return;
                                            }
                                            textfield_abn.text =
                                                DateFormat('dd/MM-kk:mm')
                                                    .format(dateTime);
                                            setState(() {
                                              if (_abnahmeError !=
                                                  'Wert eingeben') {
                                                _gabeError = null;
                                                _abnahmeError = null;
                                              } else
                                                _abnahmeError = null;
                                              textfield_ct_focus.requestFocus();
                                            });
                                          });
                                        },
                                        decoration: InputDecoration(
                                            filled: true,
                                            hintText:
                                                'klicken um Datum einzutragen',
                                            hintStyle: hintStyle,
                                            fillColor: Colors.transparent,
                                            suffixIcon: createInfoIconButton(
                                                "Spiegelabnahme-Zeitpunkt",
                                                "Tragen Sie hier den Zeitpunkt der Spiegelabnahme ein! Die Spiegelabnahme muss zeitlich NACH der Medikationsgabe liegen. Aktuell sind nur Zeitpunkte innerhalb der letzten 30 Tage möglich.",
                                                context),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color:
                                                    textfield_gabe.text.isEmpty
                                                        ? borderSideColor
                                                        : borderColorFilled,
                                                width: 2,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: focusBorderSideColor,
                                                width: 2,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: errorBorderSideColor,
                                                width: 2,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            focusedErrorBorder:
                                                OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: errorBorderSideColor,
                                                width: 2,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            label: Text(
                                                'Spiegelabnahme-Zeitpunkt',
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    color: Color.fromARGB(
                                                        255, 0, 0, 0))),
                                            errorText: _abnahmeError,
                                            errorStyle: const TextStyle(
                                                color: Colors.red)),
                                        style: TextStyle(fontSize: 14),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    45, 10, 45, 5),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0, 0, 2, 0),
                                        child: CustomTextInputField(
                                          controller: textfield_ct,
                                          focusNode: textfield_ct_focus,
                                          labelText: 'Spiegel bei Abnahme',
                                          hintText: 'in ng/ml',
                                          suffixText: 'ng/ml',
                                          infoText:
                                              "Die Konzentration bei Abnahme in ng/ml ist die Konzentration, welche bei der Blutentnahme festegestellt wurde und auf deren Basis der theoretische Talspiegel berechnet wird.",
                                          onChanged: (p0) => setState(() {}),
                                          maxLength: 4,
                                          regExp: floatingRegeEp,
                                          errorText: _spiegelError,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0, 15, 0, 16),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () async {
                                            bool _hasError = false;
                                            if (textfield_ct.text.isEmpty) {
                                              _spiegelError = "Wert eingeben";
                                              _hasError = true;
                                            }
                                            if ((double.tryParse(textfield_ct
                                                        .text
                                                        .split(' ')[0]) ??
                                                    1) >
                                                999.0) {
                                              textfield_hwz.text = '';
                                              _spiegelError =
                                                  "Wert zu groß. Wert < 1000";
                                              _hasError = true;
                                            }
                                            if (textfield_hwz.text.isEmpty) {
                                              _hwzError = "Wert eingeben";
                                              _hasError = true;
                                            }
                                            if ((double.tryParse(textfield_hwz
                                                        .text
                                                        .split(' ')[0]) ??
                                                    1) >
                                                999.0) {
                                              textfield_hwz.text = '';
                                              _hwzError =
                                                  "Wert zu groß. Wert < 1000";
                                              _hasError = true;
                                            }
                                            if (textfield_tmin.text.isEmpty) {
                                              _tminError = "Wert eingeben";
                                              _hasError = true;
                                            }
                                            if (textfield_abn.text.isEmpty) {
                                              _abnahmeError = "Wert eingeben";
                                              _hasError = true;
                                            }
                                            if (textfield_gabe.text.isEmpty) {
                                              _gabeError = "Wert eingeben";
                                              _hasError = true;
                                            }
                                            if (_hasError) {
                                              setState(() {});
                                              return;
                                            }

                                            if (abnahme.isBefore(gabe) ||
                                                abnahme
                                                    .isAtSameMomentAs(gabe)) {
                                              _abnahmeError =
                                                  "Chronologie beachten!";
                                              _gabeError =
                                                  "Chronologie beachten!";
                                              setState(() {});
                                              return;
                                            }
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ResultWidget(
                                                  textfield_tmin:
                                                      textfield_tmin,
                                                  textfield_ct: textfield_ct,
                                                  textfield_hwz: textfield_hwz,
                                                  gabe_passed: gabe,
                                                  abnahme_passed: abnahme,
                                                  gabe_passed_string:
                                                      textfield_gabe.text,
                                                  abnahme_passed_string:
                                                      textfield_abn.text,
                                                ),
                                              ),
                                            );
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors
                                                .white, // Set your desired color
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 60),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                          child: Text(
                                            'Berechnen',
                                            style: TextStyle(
                                              fontFamily: 'Readex Pro',
                                              fontSize: 16,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ]),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
