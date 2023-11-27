// Packages
//TODO: Formel kontrollieren. mit 0 fehler
import 'package:flutter/material.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart' as assetManifest;
import 'dart:math';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

// Models
import 'med_lists.dart';
import 'models.dart';
import 'onboarding_screen.dart';
import 'own_widgets.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  assetManifest.SystemChrome.setPreferredOrientations(
      [assetManifest.DeviceOrientation.portraitUp]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [GlobalMaterialLocalizations.delegate],
      supportedLocales: [const Locale('de')],
      title: 'Talspiegel-Rechner',
      theme: ThemeData(
          useMaterial3: true,
          primarySwatch: Colors.blue,
          appBarTheme: const AppBarTheme(
              backgroundColor: Color.fromRGBO(142, 202, 230, 0)),
          colorScheme: ColorScheme.fromSwatch(backgroundColor: Colors.white),
          fontFamily: 'Roboto'),
      home: OnboardingWidget(),
      //const HomeScreen(),
    );
  }
}

final styleHeaderAppBar = TextStyle(
  fontSize: 24,
  fontWeight: FontWeight.normal,
  color: Colors.black,
  fontFamily: GoogleFonts.outfit().fontFamily,
);

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController textfield_tmin = TextEditingController();
  TextEditingController textfield_gabe = TextEditingController();
  TextEditingController textfield_ct = TextEditingController();
  TextEditingController textfield_hwz = TextEditingController();
  TextEditingController textfield_abn = TextEditingController();
  DateTime gabe = DateTime.now();
  DateTime abnahme = DateTime.now();

  MedicationType? selectedMedicationType = MedicationType.Substanzklasse;
  List<Medication?> dropdownItems = AllItems;

  Medication? dropdownValue = AllItems[0];
  String classvalue = 'Alle';

  String? _gabeError;
  String? _abnahmeError;

  @override
  void initState() {
    super.initState();
  }

  String calculate() {
    Duration diff = abnahme.difference(gabe);
    int t = diff.inHours < 0 ? -1 : diff.inHours;
    if (t == -1) return ('Zeiten kontrollieren');
    int halflife = int.tryParse(textfield_hwz.text) ?? 1;
    double ct = double.tryParse(textfield_ct.text.replaceAll(',', '.')) ?? 0;
    double tmin = double.tryParse(textfield_tmin.text) ?? 0;
    double negke = (ln2 / halflife) * -1;
    double result = ct * pow(e, (negke * (tmin - t)));
    if (result > 99999) return ("out of bound");
    return (result.toStringAsFixed(2) + ' ng/ml');
  }

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

  @override
  Widget build(BuildContext context) {
    //final isKeyboard = MediaQuery.of(context).viewInsets.bottom != 0;
    dropdownItems.sort((a, b) => (a?.name ?? '').compareTo(b?.name ?? ''));
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
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
            backgroundColor: Colors.transparent,
            resizeToAvoidBottomInset: true,
            appBar: AppBar(
              title: Text(
                  context.findAncestorWidgetOfExactType<Title>()?.title ??
                      "Talspiegel-Rechner",
                  style: TextStyle(fontSize: 20)),
              actions: [
                // About Page
                CupertinoButton(
                    padding: const EdgeInsets.all(10.0),
                    child: const Icon(Icons.info_outline_rounded),
                    onPressed: () => showAboutDialog(
                        context: context,
                        //applicationIcon: ,
                        applicationVersion:
                            "V1.0; \nDr.med.Esra Lenz \n Support by Paul Geeser",
                        applicationLegalese:
                            "This app is free to use. Sources: 'Kompendium der Psychiatrischen Pharmakotherapie', O.Benkert, H.Hippus; 11. Auflage ")),
                CupertinoButton(
                    padding: const EdgeInsets.all(10.0),
                    child: const Icon(Icons.exit_to_app),
                    onPressed: () => assetManifest.SystemNavigator.pop())
              ],
            ),
            body: FractionallySizedBox(
                widthFactor: 1.0,
                heightFactor: 1.0,
                child: SingleChildScrollView(
                  reverse: false,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          //header for Radio Buttons
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 8.0, bottom: 0.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                    child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            "Filtern nach Substanzklasse:",
                                            style: const TextStyle(
                                                fontSize: 17.0,
                                                fontWeight: FontWeight.normal),
                                          ),
                                        )))
                              ],
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 0.0, bottom: 0.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                        value: classvalue,
                                        borderRadius: BorderRadius.circular(12),
                                        menuMaxHeight: 300,
                                        items: medications.map((String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: SizedBox(
                                              width: 200,
                                              child: Text(value) != 'Alle'
                                                  ? Text(value,
                                                      textAlign:
                                                          TextAlign.center,
                                                      overflow:
                                                          TextOverflow.visible,
                                                      style: TextStyle(
                                                          fontSize: 15))
                                                  : const Text("Alle",
                                                      textAlign:
                                                          TextAlign.center,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          fontSize: 15)),
                                            ),
                                          );
                                        }).toList(),
                                        onChanged: (String? value) {
                                          setState(() {
                                            if (value == 'Alle') {
                                              dropdownValue = null;
                                              textfield_hwz.text = '';
                                              textfield_tmin.text = '';
                                              dropdownItems = AllItems;
                                              classvalue = 'Alle';
                                            } else if (value ==
                                                'Antidepressiva') {
                                              dropdownValue = null;
                                              textfield_hwz.text = '';
                                              textfield_tmin.text = '';
                                              dropdownItems =
                                                  AntidepressivaItems;
                                              classvalue = 'Antidepressiva';
                                            } else if (value ==
                                                'Antipsychotika') {
                                              dropdownValue = null;
                                              textfield_hwz.text = '';
                                              textfield_tmin.text = '';
                                              dropdownItems =
                                                  AntpsychotikaItems;
                                              classvalue = 'Antipsychotika';
                                            } else if (value ==
                                                'Antikonvulsiva') {
                                              dropdownValue = null;
                                              textfield_hwz.text = '';
                                              textfield_tmin.text = '';
                                              dropdownItems =
                                                  AntikonvulsivaItems;
                                              classvalue = 'Antikonvulsiva';
                                            } else if (value == 'Anxiolytika') {
                                              dropdownValue = null;
                                              textfield_hwz.text = '';
                                              textfield_tmin.text = '';
                                              dropdownItems = AnxiolytikaItems;
                                              classvalue = 'Anxiolytika';
                                            } else if (value == 'Sucht-Med.') {
                                              dropdownValue = null;
                                              textfield_hwz.text = '';
                                              textfield_tmin.text = '';
                                              dropdownItems = SuchtItems;
                                              classvalue = 'Sucht-Med.';
                                            } else if (value == 'Sonstige') {
                                              dropdownValue = null;
                                              textfield_hwz.text = '';
                                              textfield_tmin.text = '';
                                              dropdownItems = SonstigeItems;
                                              classvalue = 'Sonstige';
                                            }
                                          });
                                        }))
                              ],
                            ),
                          ),
                          Padding(
                              padding:
                                  const EdgeInsets.only(top: 0.0, bottom: 8.0),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                        child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Align(
                                                alignment: Alignment.center,
                                                child: Text(
                                                  "Filtern nach Medikament:",
                                                  style: const TextStyle(
                                                    fontSize: 17.0,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                  ),
                                                ))))
                                  ])),
                          Padding(
                              padding:
                                  const EdgeInsets.only(top: 0.0, bottom: 8.0),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    DropdownButtonHideUnderline(
                                        child: DropdownButton(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            menuMaxHeight: 300,
                                            value: dropdownValue,
                                            items: dropdownItems
                                                .map((Medication? medication) {
                                              return DropdownMenuItem(
                                                  value: medication,
                                                  child: SizedBox(
                                                    width: 220,
                                                    child: medication != null
                                                        ? Text(medication.name,
                                                            textAlign: TextAlign
                                                                .center,
                                                            overflow:
                                                                TextOverflow
                                                                    .visible,
                                                            style: TextStyle(
                                                                fontSize: 15))
                                                        : const Text("Auswahl",
                                                            textAlign: TextAlign
                                                                .center,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                                fontSize: 15)),
                                                  ));
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
                                                          .toString();
                                                  textfield_tmin.text =
                                                      dropdownValue!.mintal
                                                          .toString();
                                                }
                                              });
                                            })),
                                  ])),
                          Row(children: [
                            Expanded(
                                child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 7.5, right: 7.5, bottom: 5),
                              child: InputTextBox(
                                controller: textfield_hwz,
                                maxlength: 3,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                onChanged: (p0) => setState(() {
                                  dropdownValue = null;
                                }),
                                inputFormatters: [
                                  assetManifest.FilteringTextInputFormatter
                                      .allow(RegExp(r"[0-9]"))
                                ],
                                name: 'Halbwertszeit',
                                unit: 'h',
                                infoname: "Halbwertszeit (HWZ)",
                                infotext:
                                    "Die Halbwertszeit (HWZ) gibt an, wie lange es dauert, bis sich die Konzentration eines Medikaments in der Blutbahn halbiert hat. Geben Sie eine eigene HWZ ein oder nutzen Sie die hinterlegte HWZ des Medikaments in Stunden (h).",
                              ),
                            ))
                          ]),
                          Row(
                            children: [
                              Expanded(
                                child: InputTextBox(
                                  controller: textfield_tmin,
                                  maxlength: 3,
                                  onChanged: (p0) => setState(() {}),
                                  inputFormatters: [
                                    assetManifest.FilteringTextInputFormatter
                                        .allow(RegExp(r"[0-9]"))
                                  ],
                                  name: 'Verabreichungsintervall',
                                  unit: 'h',
                                  infoname: "Verabreichungsintervall",
                                  infotext:
                                      "Das Verabreichungsintervall beschreibt den Abstand der Medikationsgaben. Dies entspricht dem Talspiegel-Zeitpunkt (tmin) in Stunden (h). Wenn Sie das Medikament z.B. einmal täglich geben, ist das Verabreichungsintervall (und somit tmin) mit 24h einzutragen.",
                                ),
                              ),
                              Expanded(
                                child: InputTextBox(
                                  controller: textfield_ct,
                                  maxlength: 5,
                                  onChanged: (p0) => setState(() {}),
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                          decimal: true),
                                  inputFormatters: [
                                    assetManifest.FilteringTextInputFormatter
                                        .allow(RegExp(r'(^\d*(\,|\.)?\d*)'))
                                  ],
                                  name: 'Konzentration bei Abnahme',
                                  unit: 'ng/ml',
                                  infoname: "Konzentration bei Abnahme",
                                  infotext:
                                      "Die Konzentration bei Abnahme in ng/ml ist die Konzentration, welche bei der Blutentnahme festegestellt wurde und auf deren Basis der theoretische Talspiegel berechnet wird.",
                                ),
                              ),
                            ],
                          ),
                          Row(children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 15.0, right: 15.0, top: 15.0),
                                child: TextField(
                                  controller: textfield_gabe,
                                  keyboardType: TextInputType.none,
                                  onChanged: (p0) => setState(() {}),
                                  onTap: () async {
                                    final date = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(2000),
                                      lastDate: DateTime(2100),
                                    );
                                    if (date == null)
                                      return; // user cancels date selection
                                    final time = await showTimePicker(
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
                                      if (dateTime.compareTo(abnahme) > 0) {
                                        textfield_gabe.text =
                                            DateFormat('dd/MM-kk:mm')
                                                .format(dateTime);
                                        setState(() {
                                          _gabeError = "Chronologie beachten!";
                                        });
                                        return;
                                      }
                                      textfield_gabe.text =
                                          DateFormat('dd/MM-kk:mm')
                                              .format(dateTime);
                                      setState(() {
                                        _gabeError = null;
                                        _abnahmeError = null;
                                      });
                                    });
                                  },
                                  decoration: InputDecoration(
                                      suffixIcon: IconButton(
                                        icon: const Icon(
                                          Icons.info_outline_rounded,
                                          size: 20,
                                        ),
                                        onPressed: () {
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  backgroundColor:
                                                      Color.fromARGB(
                                                          236, 149, 204, 252),
                                                  title:
                                                      Text("Medikationsgabe"),
                                                  content: Text(
                                                      "Tragen Sie hier den Zeitpunkt der Medikationsgabe ein! Die Medikationsgabe muss zeitlich VOR der Spiegelabnahme liegen. Aktuell sind nur Zeitpunkte innerhalb der letzten 30 Tage möglich."),
                                                  actions: [
                                                    TextButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: const Text(
                                                          "OK",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black),
                                                        ))
                                                  ],
                                                );
                                              });
                                        },
                                      ),
                                      enabledBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 1, color: Colors.black38)),
                                      label: Text('Medikationsgabe',
                                          style: const TextStyle(
                                              fontSize: 15,
                                              color: Colors.blueGrey)),
                                      errorText: _gabeError,
                                      errorStyle:
                                          const TextStyle(color: Colors.red)),
                                  style: TextStyle(fontSize: 15),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 15.0, right: 15.0, top: 15.0),
                                child: TextField(
                                  controller: textfield_abn,
                                  keyboardType: TextInputType.none,
                                  onChanged: (p0) => setState(() {}),
                                  onTap: () async {
                                    final date = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(2000),
                                      lastDate: DateTime(2100),
                                    );
                                    if (date == null)
                                      return; // user cancels date selection
                                    final time = await showTimePicker(
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
                                        _abnahmeError = null;
                                        _gabeError = null;
                                      });
                                    });
                                  },
                                  decoration: InputDecoration(
                                      suffixIcon: IconButton(
                                        icon: const Icon(
                                          Icons.info_outline_rounded,
                                          size: 20,
                                        ),
                                        onPressed: () {
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  backgroundColor:
                                                      Color.fromARGB(
                                                          236, 149, 204, 252),
                                                  title: Text("Spiegelabnahme"),
                                                  content: Text(
                                                      "Tragen Sie hier den Zeitpunkt der Spiegelabnahme ein! Die Spiegelabnahme muss zeitlich NACH der Medikationsgabe liegen. Aktuell sind nur Zeitpunkte innerhalb der letzten 30 Tage möglich."),
                                                  actions: [
                                                    TextButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: const Text(
                                                          "OK",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black),
                                                        ))
                                                  ],
                                                );
                                              });
                                        },
                                      ),
                                      enabledBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 1, color: Colors.black38)),
                                      label: Text('Spiegel-Abnahme',
                                          style: const TextStyle(
                                              fontSize: 15,
                                              color: Colors.blueGrey)),
                                      errorText: _abnahmeError,
                                      errorStyle:
                                          const TextStyle(color: Colors.red)),
                                  style: TextStyle(fontSize: 15),
                                ),
                              ),
                            ),
                          ]),
                          Row(
                            children: [
                              Expanded(
                                  child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                      "ZU BEACHTEN! Der Steady-State der Medikation ist nach 5 Halbwertszeiten (" +
                                          duration() +
                                          ") erreicht. Das Medikament sollte mindestens über diesen Zeitraum verabreicht worden sein."),
                                ),
                              ))
                            ],
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 30.0),
                        child: Text(
                          'Talspiegel: ${calculate()}',
                          style: const TextStyle(
                              fontSize: 25, fontWeight: FontWeight.normal),
                        ),
                      )
                    ],
                  ),
                ))),
      ),
    );
  }
}
