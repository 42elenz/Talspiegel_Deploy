import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:talspiegel/own_widgets.dart';

import 'med_lists.dart';
import 'models.dart';

import 'result_elim.dart';
import 'choice_screen2.dart';

class EnterDataForm_elimination extends StatefulWidget {
  const EnterDataForm_elimination({Key? key}) : super(key: key);

  @override
  _EnterDataForm_eliminationState createState() =>
      _EnterDataForm_eliminationState();
}

String? validateInput(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter a value';
  }
  return null;
}

class _EnterDataForm_eliminationState extends State<EnterDataForm_elimination> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController textfield_intervall = TextEditingController();
  TextEditingController textfield_gabe = TextEditingController();
  TextEditingController textfield_abn = TextEditingController();
  TextEditingController textfield_abshwz = TextEditingController();
  TextEditingController textfield_verteilungsvol = TextEditingController();
  TextEditingController textfield_eliminations_hwz = TextEditingController();
  TextEditingController textfield_gewicht = TextEditingController();
  TextEditingController textfield_dosis = TextEditingController();
  TextEditingController textfield_bioverfuegbarkeit = TextEditingController();
  DateTime gabe = DateTime.now().subtract(const Duration(days: 100));
  DateTime abnahme = DateTime.now().add(const Duration(days: 100));
  double verteilungsvol_min = 0.9;
  double verteilungsvol_max = 0.1;
  String floatingRegeEp = "[+-]?([0-9]+([.][0-9]*)?|[.][0-9]+)";
  MedicationType? selectedMedicationType = MedicationType.Substanzklasse;
  List<Medication?> dropdownItems = AllItems;

  FocusNode textfield_gewicht_focus = FocusNode();
  FocusNode textfield_dosis_focus = FocusNode();
  FocusNode textfield_gabe_focus = FocusNode();
  FocusNode textfield_abn_focus = FocusNode();

  Medication? dropdownValue = AllItems[0];
  String classvalue = 'Filtern nach Substanzklasse';

  String? _gabeError;
  String? _abnahmeError;
  String? _bioverfuegbarkeitError;
  String? _ehwzError;
  String? _dosisError;
  String? _intervallError;
  String? _gewichtError;
  String? _verteilungsvolError;
  String? _abshwzError;

  final borderSideColor = Color.fromRGBO(224, 227, 231, 1);
  final focusBorderSideColor = Color(0xFF4DABF6);
  final borderColorFilled = Color(0xFF4DABF6);
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
    int hours = int.tryParse(textfield_eliminations_hwz.text) ?? -99;
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
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
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
                          child: SingleChildScrollView(
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                                                    return DropdownMenuItem<
                                                        String>(
                                                      value: value,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: (value !=
                                                                'Filtern nach Substanzklasse')
                                                            ? Center(
                                                                child: Text(
                                                                  value,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .visible,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal),
                                                                ),
                                                              )
                                                            : Text(
                                                                "Filtern nach Substanzklasse",
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal),
                                                              ),
                                                      ),
                                                    );
                                                  }).toList(),
                                                  onChanged: (String? value) {
                                                    setState(() {
                                                      if (value ==
                                                          'Filtern nach Substanzklasse') {
                                                        dropdownValue = null;
                                                        textfield_eliminations_hwz
                                                            .text = '';
                                                        textfield_intervall
                                                            .text = '';
                                                        dropdownItems =
                                                            AllItems;
                                                        classvalue =
                                                            'Filtern nach Substanzklasse';
                                                      } else if (value ==
                                                          'Antidepressiva') {
                                                        dropdownValue = null;
                                                        textfield_eliminations_hwz
                                                            .text = '';
                                                        textfield_intervall
                                                            .text = '';
                                                        dropdownItems =
                                                            AntidepressivaItems;
                                                        classvalue =
                                                            'Antidepressiva';
                                                      } else if (value ==
                                                          'Antipsychotika') {
                                                        dropdownValue = null;
                                                        textfield_eliminations_hwz
                                                            .text = '';
                                                        textfield_intervall
                                                            .text = '';
                                                        dropdownItems =
                                                            AntpsychotikaItems;
                                                        classvalue =
                                                            'Antipsychotika';
                                                      } else if (value ==
                                                          'Antikonvulsiva') {
                                                        dropdownValue = null;
                                                        textfield_eliminations_hwz
                                                            .text = '';
                                                        textfield_intervall
                                                            .text = '';
                                                        dropdownItems =
                                                            AntikonvulsivaItems;
                                                        classvalue =
                                                            'Antikonvulsiva';
                                                      } else if (value ==
                                                          'Anxiolytika') {
                                                        dropdownValue = null;
                                                        textfield_eliminations_hwz
                                                            .text = '';
                                                        textfield_intervall
                                                            .text = '';
                                                        dropdownItems =
                                                            AnxiolytikaItems;
                                                        classvalue =
                                                            'Anxiolytika';
                                                      } else if (value ==
                                                          'Sucht-Med.') {
                                                        dropdownValue = null;
                                                        textfield_eliminations_hwz
                                                            .text = '';
                                                        textfield_intervall
                                                            .text = '';
                                                        dropdownItems =
                                                            SuchtItems;
                                                        classvalue =
                                                            'Sucht-Med.';
                                                      } else if (value ==
                                                          'Sonstige') {
                                                        dropdownValue = null;
                                                        textfield_eliminations_hwz
                                                            .text = '';
                                                        textfield_intervall
                                                            .text = '';
                                                        dropdownItems =
                                                            SonstigeItems;
                                                        classvalue = 'Sonstige';
                                                      }
                                                      dropdownItems
                                                          .sort((a, b) {
                                                        if (a == null &&
                                                            b == null) return 0;
                                                        if (a == null)
                                                          return -1;
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
                                      alignment:
                                          AlignmentDirectional(0.00, 0.00),
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
                                                    underline: Container(),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    isExpanded: true,
                                                    menuMaxHeight: 300,
                                                    value: dropdownValue,
                                                    items: dropdownItems.map(
                                                        (Medication?
                                                            medication) {
                                                      return DropdownMenuItem(
                                                        value: medication,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: medication !=
                                                                  null
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
                                                                              FontWeight.normal)),
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
                                                                      fontSize:
                                                                          14,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal)),
                                                        ),
                                                      );
                                                    }).toList(),
                                                    onChanged:
                                                        (Medication? val) {
                                                      setState(() {
                                                        dropdownValue = val;
                                                        if (dropdownValue ==
                                                            null) {
                                                          textfield_eliminations_hwz
                                                              .text = '';
                                                          textfield_intervall
                                                              .text = '';
                                                          return;
                                                        } else {
                                                          textfield_eliminations_hwz
                                                                  .text =
                                                              dropdownValue!.hlf
                                                                      .toString() +
                                                                  ' h';
                                                          textfield_intervall
                                                                  .text =
                                                              dropdownValue!
                                                                      .mintal
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: CustomTextInputField(
                                              controller:
                                                  textfield_bioverfuegbarkeit,
                                              labelText: 'Bioverfügbarkeit',
                                              nextNode: textfield_gabe_focus,
                                              hintText: 'in %',
                                              suffixText: '%',
                                              maxLength: 3,
                                              errorText:
                                                  _bioverfuegbarkeitError,
                                              infoText:
                                                  "Die Bioverfügbarkeit beschreibt wie viel der oralen Dosis letztendlich im Blutkreislauf ankommt.",
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: CustomTextInputField(
                                              controller: textfield_intervall,
                                              labelText:
                                                  'Verabreichungsintervall',
                                              hintText: 'in h',
                                              suffixText: 'h',
                                              infoText:
                                                  "Das Verabreichungsintervall beschreibt den Abstand der Medikationsgaben. Dies entspricht dem Talspiegel-Zeitpunkt (tmin) in Stunden (h). Wenn Sie das Medikament z.B. einmal täglich geben, ist das Verabreichungsintervall (und somit tmin) mit 24h einzutragen.",
                                              onChanged: (p0) =>
                                                  setState(() {}),
                                              errorText: _intervallError,
                                              maxLength: 3,
                                            ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(7.5, 0, 0, 0),
                                              child: CustomTextInputField(
                                                controller: textfield_abshwz,
                                                labelText: 'Absorbtions-HWZ',
                                                hintText: 'in h',
                                                suffixText: 'h',
                                                infoText:
                                                    "Die Halbwertszeit (HWZ) gibt an, wie lange es dauert, bis sich die Konzentration eines Medikaments in der Blutbahn halbiert hat. Geben Sie eine eigene HWZ ein oder nutzen Sie die hinterlegte HWZ des Medikaments in Stunden (h).",
                                                onChanged: (p0) =>
                                                    setState(() {}),
                                                errorText: _abshwzError,
                                                maxLength: 3,
                                                regExp: floatingRegeEp,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        45, 10, 45, 5),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: CustomTextInputField(
                                            controller:
                                                textfield_verteilungsvol,
                                            labelText: 'Verteilungsvolumen',
                                            hintText: 'in l/kg',
                                            suffixText: 'l/kg',
                                            infoText:
                                                "Das Verteilungsvolumen wird aus der Literatur entnommen. Falls nicht vorhanden, muss es selbst recharchiert werden.",
                                            onChanged: (p0) => setState(() {}),
                                            maxLength: 5,
                                            errorText: _verteilungsvolError,
                                            regExp: floatingRegeEp,
                                          ),
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    7.5, 0, 0, 0),
                                            child: CustomTextInputField(
                                              controller:
                                                  textfield_eliminations_hwz,
                                              labelText: 'Eliminations-HWZ',
                                              hintText: 'in h',
                                              suffixText: 'h',
                                              errorText: _ehwzError,
                                              infoText:
                                                  "Die Halbwertszeit (HWZ) gibt an, wie lange es dauert, bis sich die Konzentration eines Medikaments in der Blutbahn halbiert hat. Hierbei wird die Ausscheidungsrate mit beachtet.",
                                              onChanged: (p0) =>
                                                  setState(() {}),
                                              maxLength: 5,
                                              regExp: floatingRegeEp,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Align(
                                    alignment: AlignmentDirectional(0.00, 0.00),
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          45, 10, 45, 5),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: TextFormField(
                                              controller: textfield_gabe,
                                              focusNode: textfield_gabe_focus,
                                              keyboardType: TextInputType.none,
                                              onTap: () async {
                                                final date = await showDatePicker(
                                                    context: context,
                                                    initialEntryMode:
                                                        DatePickerEntryMode
                                                            .calendarOnly,
                                                    initialDate: DateTime.now(),
                                                    firstDate: DateTime.now()
                                                        .subtract(
                                                            const Duration(
                                                                days: 30)),
                                                    lastDate: DateTime.now()
                                                        .add(const Duration(
                                                            days: 30)),
                                                    helpText:
                                                        'Medikationsgabe-Zeitpunkt');
                                                if (date == null)
                                                  return; // user cancels date selection
                                                final time =
                                                    await showTimePicker(
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
                                                  if (gabe.compareTo(abnahme) >
                                                      0) {
                                                    textfield_gabe.text =
                                                        DateFormat(
                                                                'dd/MM-kk:mm')
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
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: textfield_gabe
                                                              .text.isEmpty
                                                          ? borderSideColor
                                                          : borderColorFilled,
                                                      width: 2,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color:
                                                          focusBorderSideColor,
                                                      width: 2,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                  errorBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color:
                                                          errorBorderSideColor,
                                                      width: 2,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                  focusedErrorBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color:
                                                          errorBorderSideColor,
                                                      width: 2,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
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
                                                      .subtract(const Duration(
                                                          days: 30)),
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
                                                if (gabe.compareTo(abnahme) >
                                                    0) {
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
                                                  textfield_gewicht_focus
                                                      .requestFocus();
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
                                                enabledBorder:
                                                    OutlineInputBorder(
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
                                                focusedBorder:
                                                    OutlineInputBorder(
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
                                  Align(
                                    alignment: AlignmentDirectional(0.00, 0.00),
                                    child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            45, 10, 45, 5),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              child: CustomTextInputField(
                                                controller: textfield_gewicht,
                                                focusNode:
                                                    textfield_gewicht_focus,
                                                nextNode: textfield_dosis_focus,
                                                labelText: 'Gewicht',
                                                hintText: 'in kg',
                                                suffixText: 'kg',
                                                errorText: _gewichtError,
                                                infoText:
                                                    "Das Gewicht muss ermittelt im Form des Bodymass-Indexes muss ermittelt werden!",
                                                onChanged: (p0) =>
                                                    setState(() {}),
                                                maxLength: 7,
                                                regExp: floatingRegeEp,
                                              ),
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(7.5, 0, 0, 0),
                                                child: CustomTextInputField(
                                                  controller: textfield_dosis,
                                                  focusNode:
                                                      textfield_dosis_focus,
                                                  labelText: 'Dosis',
                                                  hintText: 'in mg',
                                                  suffixText: 'mg',
                                                  errorText: _dosisError,
                                                  infoText:
                                                      "Dosis des Medikaments in mg.",
                                                  onChanged: (p0) =>
                                                      setState(() {}),
                                                  maxLength: 8,
                                                  regExp: floatingRegeEp,
                                                ),
                                              ),
                                            )
                                          ],
                                        )),
                                  ),
                                  Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0, 15, 0, 30),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            ElevatedButton(
                                              onPressed: () async {
                                                bool _hasError = false;
                                                if (textfield_bioverfuegbarkeit
                                                    .text.isEmpty) {
                                                  _bioverfuegbarkeitError =
                                                      "Wert eingeben";
                                                  _hasError = true;
                                                }
                                                if (textfield_abshwz
                                                    .text.isEmpty) {
                                                  _abshwzError =
                                                      "Wert eingeben";
                                                  _hasError = true;
                                                }
                                                if (textfield_eliminations_hwz
                                                    .text.isEmpty) {
                                                  _ehwzError = "Wert eingeben";
                                                  _hasError = true;
                                                }
                                                if (textfield_dosis
                                                    .text.isEmpty) {
                                                  _dosisError = "Wert eingeben";
                                                  _hasError = true;
                                                }
                                                if (textfield_gewicht
                                                    .text.isEmpty) {
                                                  _gewichtError =
                                                      "Wert eingeben";
                                                  _hasError = true;
                                                }
                                                if (textfield_intervall
                                                    .text.isEmpty) {
                                                  _intervallError =
                                                      "Wert eingeben";
                                                  _hasError = true;
                                                }
                                                if (textfield_abn
                                                    .text.isEmpty) {
                                                  _abnahmeError =
                                                      "Wert eingeben";
                                                  _hasError = true;
                                                }
                                                if (textfield_gabe
                                                    .text.isEmpty) {
                                                  _gabeError = "Wert eingeben";
                                                  _hasError = true;
                                                }
                                                if (textfield_verteilungsvol
                                                    .text.isEmpty) {
                                                  _verteilungsvolError =
                                                      "Wert eingeben";
                                                  _hasError = true;
                                                }

                                                if (_hasError) {
                                                  setState(() {});
                                                  return;
                                                }

                                                if (abnahme.isBefore(gabe) ||
                                                    abnahme.isAtSameMomentAs(
                                                        gabe)) {
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
                                                      textfield_intervall:
                                                          textfield_intervall,
                                                      textfield_abshwz:
                                                          textfield_abshwz,
                                                      textfield_verteilungsvol:
                                                          textfield_verteilungsvol,
                                                      verteilungsvol_max:
                                                          verteilungsvol_max,
                                                      verteilungsvol_min:
                                                          verteilungsvol_min,
                                                      textfield_eliminations_hwz:
                                                          textfield_eliminations_hwz,
                                                      textfield_gewicht:
                                                          textfield_gewicht,
                                                      textfield_dosis:
                                                          textfield_dosis,
                                                      gabe_passed: gabe,
                                                      abnahme_passed: abnahme,
                                                      textfield_bioverfuegbarkeit:
                                                          textfield_bioverfuegbarkeit,
                                                    ),
                                                  ),
                                                );
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.white,
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
                        ),
                      ],
                    ),
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
