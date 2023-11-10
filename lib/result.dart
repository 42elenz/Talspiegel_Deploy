import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'dart:async';

import 'own_widgets.dart';
import 'models.dart';

class ResultWidget extends StatefulWidget {
  final TextEditingController textfield_tmin;

  final TextEditingController textfield_ct;
  final TextEditingController textfield_hwz;
  final DateTime gabe_passed;

  final DateTime abnahme_passed;

  final String gabe_passed_string;
  final String abnahme_passed_string;

  const ResultWidget(
      {Key? key,
      required this.textfield_tmin,
      required this.textfield_ct,
      required this.textfield_hwz,
      required this.gabe_passed,
      required this.abnahme_passed,
      required this.gabe_passed_string,
      required this.abnahme_passed_string})
      : super(key: key);

  @override
  _ResultWidgetState createState() => _ResultWidgetState();
}

class _ResultWidgetState extends State<ResultWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationcontroller;
  double verticalDrag = 80;
  double t_spiegel = 0;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  String? _gabeError;
  String? _abnahmeError;
  double maxX = 0;
  double maxY = 0;
  double halflife = 1;
  double tmin = 0;
  double ct = 0;
  List<FlSpot> dataPoints = [];
  String calculatedTalspiegel = '';
  dynamic calculatedLineChartData;
  DateTime gabe = DateTime.now();
  DateTime abnahme = DateTime.now();
  String differenz = '0';
  TextEditingController textfield_gabe = TextEditingController();
  TextEditingController textfield_abn = TextEditingController();
  String floatingRegeEp = "[+-]?([0-9]+([.][0-9]*)?|[.][0-9]+)";
  TextEditingController ctController = TextEditingController();

  String? validateInput(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a value';
    }
    return null;
  }

  Future<void> calculateAndUpdate() async {
    String result = await calculate();
    Duration diff = abnahme.difference(gabe);
    int t = diff.inHours < 0 ? -1 : diff.inHours;
    t_spiegel = t.toDouble();
    String t_diff = t.toString();
    setState(() {
      calculatedTalspiegel = result;
      differenz = t_diff;
    });
  }

  Future<void> parsePassedControllers() async {
    gabe = widget.gabe_passed;
    abnahme = widget.abnahme_passed;
    ctController.text = widget.textfield_ct.text;
    List<String> halflife_string = widget.textfield_hwz.text.split(' ');
    if (halflife_string.length > 1) {
      halflife_string[0] = halflife_string[0].replaceAll(',', '.');
      halflife = double.tryParse(halflife_string[0]) ?? 1;
    }
    List<String> tmin_string = widget.textfield_tmin.text.split(' ');
    if (tmin_string.length > 1) {
      tmin_string[0] = tmin_string[0].replaceAll(',', '.');

      tmin = double.tryParse(tmin_string[0]) ?? 0;
    }
    List<String> ct_string = widget.textfield_ct.text.split(' ');
    if (ct_string.length > 1) {
      ct_string[0] = ct_string[0].replaceAll(',', '.');
      ct = double.tryParse(ct_string[0]) ?? 0;
    }
  }

  @override
  void initState() {
    super.initState();

    _animationcontroller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    Timer(Duration(milliseconds: 350), () => _animationcontroller.forward());

    parsePassedControllers();
    textfield_abn.text = widget.abnahme_passed_string;
    textfield_gabe.text = widget.gabe_passed_string;
    calculateLineChartData();
    calculateMinMax();
    calculateAndUpdate();

    ctController.addListener(() {
      List<String> ct_string = ctController.text.split(' ');
      if (ct_string.length > 1) {
        ct_string[0] = ct_string[0].replaceAll(',', '.');
        ct = double.tryParse(ct_string[0]) ?? 0;
      } else {
        ct = 0;
      }
      calculateLineChartData();
      calculateMinMax();
      calculateAndUpdate();
    });
  }

  Future<String> calculate() async {
    Duration diff = abnahme.difference(gabe);
    int t = diff.inHours < 0 ? -1 : diff.inHours;
    if (t == -1) return ('Zeiten kontrollieren');
    double negke = (ln2 / halflife) * -1;
    double result = ct * pow(e, (negke * (tmin - t)));
    if (result > 99999) return ("out of bound");
    return (result.toStringAsFixed(2) + ' ng/ml');
  }

  String duration() {
    //function to change return hours as a String in hours and days
    int hours = 5 * halflife.toInt();
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

  double calculateConcentration(
      double initialConcentration, double halfLife, double x) {
    // Calculate the decay constant (lambda)
    double lambda = ln2 / halfLife;

    // Calculate the concentration at time t using the exponential decay formula
    double concentration = initialConcentration * exp(-lambda * x);

    return concentration;
  }

  Future<List<FlSpot>> calculateDataPoints() async {
    dataPoints = [];
    Duration diff = abnahme.difference(gabe);
    int t = diff.inHours < 0 ? -1 : diff.inHours;
    int tmin_int = tmin.toInt();
    int timepoints_till_tmin = tmin_int - t;
    int timepoints_before_t = timepoints_till_tmin - tmin_int;

    for (double x = 0; x >= timepoints_before_t; x--) {
      double double_y = calculateConcentration(ct, halflife, x);
      String roundedy = double_y.toStringAsFixed(2);
      double y = double.parse(roundedy);
      double point = (-1 * timepoints_before_t) + x;
      dataPoints.add(FlSpot(point, y));
    }
    int count = dataPoints.length - 1;
    for (double x = 0; x <= timepoints_till_tmin; x++) {
      double double_y = calculateConcentration(ct, halflife, x);
      String roundedy = double_y.toStringAsFixed(2);
      double y = double.parse(roundedy);
      double neg_point = x + count;

      dataPoints.add(FlSpot(neg_point, y));
    }
    dataPoints.sort((a, b) => a.x.compareTo(b.x));
    if (dataPoints.isEmpty) {
      dataPoints.add(FlSpot(0, 0));
    }
    calculateMinMax();
    return (dataPoints);
  }

  void calculateMinMax() {
    getMaxX();
    getMaxY();
  }

  Future<double> getMaxX() async {
    maxX = dataPoints[0].x;
    for (FlSpot point in dataPoints) {
      if (point.x > maxX) {
        maxX = point.x;
      }
    }
    return maxX;
  }

  Future<double> getMaxY() async {
    maxY = dataPoints[0].y;
    for (FlSpot point in dataPoints) {
      if (point.y > maxY) {
        maxY = point.y;
      }
    }
    return maxY;
  }

  Future<LineChartBarData> calculateLineChartData() async {
    calculateDataPoints();
    calculatedLineChartData = LineChartBarData(
      spots: dataPoints,
      isCurved: true,
      color: Colors.blue,
      dotData: FlDotData(show: false),
      belowBarData: BarAreaData(show: false),
    );
    return calculatedLineChartData;
  }

  final styleHeaderAppBar = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.normal,
    color: Colors.black,
    fontFamily: GoogleFonts.outfit().fontFamily,
  );

  final headerStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.black,
    fontFamily: GoogleFonts.outfit().fontFamily,
  );

  final contentStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.normal,
    color: Colors.black,
    fontFamily: GoogleFonts.outfit().fontFamily,
  );

  final hintStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: Colors.black,
    fontFamily: 'Readex Pro',
  );

  final importanthintStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: Colors.black,
    fontFamily: 'Readex Pro',
  );

  final labelStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: Colors.black,
    fontFamily: 'Readex Pro',
  );

  final importantlabelStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: Colors.red,
    fontFamily: 'Readex Pro',
  );

  final borderSideColor = Color.fromRGBO(224, 227, 231, 1);
  final focusBorderSideColor = Color(0xFF4DABF6);
  final borderColorFilled = Color(0xFF4DABF6);
  final errorBorderSideColor = Colors.red;

  @override
  void dispose() {
    _animationcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (FocusManager.instance.primaryFocus?.hasFocus == false) {
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
              child: CustomAppBar(screenName: 'Ergebnis')),
          body: SafeArea(
            top: true,
            child: SingleChildScrollView(
              child: Center(
                child: SizedBox(
                  width: 800,
                  child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 10),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Falls nötig anpassen',
                                style: importanthintStyle,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsetsDirectional.fromSTEB(42.5, 5, 42.5, 5),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: textfield_gabe,
                                  keyboardType: TextInputType.none,
                                  onChanged: (value) {
                                    calculateLineChartData();
                                    calculateMinMax();
                                    calculateAndUpdate();
                                  },
                                  onTap: () async {
                                    final date = await showDatePicker(
                                      context: context,
                                      helpText: 'Medikationsgabe',
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime.now()
                                          .subtract(const Duration(days: 30)),
                                      lastDate: DateTime.now()
                                          .add(const Duration(days: 30)),
                                    );
                                    if (date == null)
                                      return; // user cancels date selection
                                    final time = await showTimePicker(
                                      helpText: 'Medikationsgabe',
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
                                        calculateLineChartData();
                                        calculateMinMax();
                                        calculateAndUpdate();
                                      });
                                    });
                                  },
                                  decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.transparent,
                                      suffixIcon: createInfoIconButton(
                                          "Medikationsgabe",
                                          "Tragen Sie hier den Zeitpunkt der Medikationsgabe ein! Die Medikationsgabe muss zeitlich VOR der Spiegelabnahme liegen. Achtung: Nutzen Sie in der Webversion das Mausrad oder Trackpad!",
                                          context),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: textfield_gabe.text.isEmpty
                                              ? borderSideColor
                                              : borderColorFilled,
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: focusBorderSideColor,
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: errorBorderSideColor,
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: errorBorderSideColor,
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      label: Text('Medikationsgabe-Zeitpunkt',
                                          style: const TextStyle(
                                              fontSize: 15,
                                              color: Colors.black)),
                                      errorText: _gabeError,
                                      errorStyle:
                                          const TextStyle(color: Colors.red)),
                                  style: TextStyle(fontSize: 15),
                                  textAlign: TextAlign.center,
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsetsDirectional.fromSTEB(42.5, 10, 42.5, 5),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                flex: 1,
                                child: TextFormField(
                                  controller: textfield_abn,
                                  keyboardType: TextInputType.none,
                                  onChanged: (value) {
                                    calculateLineChartData();
                                    getMaxY();
                                    calculateAndUpdate();
                                  },
                                  onTap: () async {
                                    final date = await showDatePicker(
                                      context: context,
                                      helpText: 'Spiegelabnahme',
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(2000),
                                      lastDate: DateTime(2100),
                                    );
                                    if (date == null)
                                      return; // user cancels date selection
                                    final time = await showTimePicker(
                                      helpText: 'Spiegelabnahme',
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
                                        abnahme = dateTime;
                                        calculateLineChartData();
                                        getMaxY();
                                        calculateAndUpdate();
                                      });
                                    });
                                  },
                                  decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.transparent,
                                      suffixIcon: createInfoIconButton(
                                          "Spiegelabnahme-Zeitpunkt",
                                          "Tragen Sie hier den Zeitpunkt der Spiegelabnahme ein! Die Spiegelabnahme muss zeitlich NACH der Medikationsgabe liegen. Achtung: Nutzen Sie in der Webversion das Mausrad oder Trackpad!",
                                          context),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: textfield_gabe.text.isEmpty
                                              ? borderSideColor
                                              : borderColorFilled,
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: focusBorderSideColor,
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: errorBorderSideColor,
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: errorBorderSideColor,
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      label: Text("Spiegelabnahme-Zeitpunkt",
                                          style: const TextStyle(
                                              fontSize: 15,
                                              color: Color.fromARGB(
                                                  255, 0, 0, 0))),
                                      errorText: _abnahmeError,
                                      errorStyle:
                                          const TextStyle(color: Colors.red)),
                                  style: TextStyle(fontSize: 15),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    42, 10, 42, 5),
                                child: CustomTextInputField(
                                  controller: ctController,
                                  labelText: 'Spiegel bei Abnahme',
                                  hintText: 'in ng/ml',
                                  suffixText: 'ng/ml',
                                  infoText:
                                      "Die Konzentration bei Abnahme in ng/ml ist die Konzentration, welche bei der Blutentnahme festegestellt wurde und auf deren Basis der theoretische Talspiegel berechnet wird.",
                                  maxLength: 3,
                                  regExp: floatingRegeEp,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SlideTransition(
                          position: Tween<Offset>(
                            begin: Offset(0, 0.2),
                            end: Offset.zero,
                          ).animate(_animationcontroller),
                          child: FadeTransition(
                            opacity: _animationcontroller,
                            child: Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(16, 12, 16, 0),
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 3,
                                      color: Color(0x33000000),
                                      offset: Offset(0, 1),
                                    )
                                  ],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0, 0, 0, 8),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0, 0, 12, 0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(16, 12, 12, 0),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Talspiegel',
                                                      style: headerStyle,
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  0, 4, 0, 0),
                                                      child: Text(
                                                          'Spiegel kurz vor erneuter Gabe',
                                                          style: hintStyle),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(16, 12, 0, 12),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.max,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    calculatedTalspiegel,
                                                    style: contentStyle,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SlideTransition(
                          position: Tween<Offset>(
                            begin: Offset(0, 0.4),
                            end: Offset.zero,
                          ).animate(_animationcontroller),
                          child: FadeTransition(
                            opacity: _animationcontroller,
                            child: Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(16, 12, 16, 0),
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 3,
                                      color: Color(0x33000000),
                                      offset: Offset(0, 1),
                                    )
                                  ],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0, 0, 0, 8),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0, 0, 12, 0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(16, 12, 12, 0),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Steady State',
                                                      style: headerStyle,
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  0, 4, 0, 0),
                                                      child: Text(
                                                        'Steady state erreicht nach',
                                                        style: hintStyle,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(16, 12, 0, 12),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.max,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(duration(),
                                                      style: contentStyle),
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(
                                                                0, 4, 0, 0),
                                                    child: Text(
                                                        'Hinweis: Das Medikament sollte min. 5 HWZ eingenommen worden sein.',
                                                        style: labelStyle),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SlideTransition(
                          position: Tween<Offset>(
                            begin: Offset(0, 0.6),
                            end: Offset.zero,
                          ).animate(_animationcontroller),
                          child: FadeTransition(
                            opacity: _animationcontroller,
                            child: Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(16, 12, 16, 0),
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 3,
                                      color: Color(0x33000000),
                                      offset: Offset(0, 1),
                                    )
                                  ],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0, 0, 0, 8),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(16, 12, 12, 0),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.max,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Gabe-Spiegel-Differenz',
                                                    style: headerStyle,
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(
                                                                0, 4, 0, 0),
                                                    child: Text(
                                                      'Stunden zwischen Einnahme und Spiegelbestimmung ',
                                                      style: hintStyle,
                                                      overflow:
                                                          TextOverflow.clip,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(16, 12, 0, 12),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.max,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(differenz + 'h',
                                                      style: contentStyle),
                                                  Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  0, 4, 0, 0),
                                                      child: Text(
                                                        (int.tryParse(differenz) ??
                                                                    0) >
                                                                (tmin)
                                                            ? "Achtung, die Zeitspanne zwischen Medikationsgabe und Spiegelabnahme ist größer gewählt, als das Verabreichungsintervall von ${widget.textfield_tmin.text}! Bitte kontrollieren!"
                                                            : "Das festgelegte Verabreichungsintervall beträgt ${widget.textfield_tmin.text}",
                                                        style: (int.tryParse(
                                                                        differenz) ??
                                                                    0) >
                                                                (tmin)
                                                            ? importantlabelStyle
                                                            : labelStyle,
                                                      )),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SlideTransition(
                          position: Tween<Offset>(
                            begin: Offset(0, 0.8),
                            end: Offset.zero,
                          ).animate(_animationcontroller),
                          child: FadeTransition(
                            opacity: _animationcontroller,
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  16, 12, 16, 16),
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 3,
                                      color: Color(0x33000000),
                                      offset: Offset(0, 1),
                                    )
                                  ],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0, 0, 0, 12),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            16, 12, 0, 0),
                                        child: Text(
                                            'Konzentrationsverlauf über Stunden nach Gabe',
                                            style: headerStyle),
                                      ),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            16, 4, 16, 0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Container(
                                                  child: Wrap(
                                                    spacing: 8,
                                                    runSpacing: 4,
                                                    children: [
                                                      IconTextRow(
                                                        iconColor: Colors.blue,
                                                        text: 'Konzentration',
                                                        icon: Icons.circle,
                                                      ),
                                                      IconTextRow(
                                                        iconColor: Colors.black,
                                                        text: 'Spiegelabnahme',
                                                      ),
                                                      IconTextRow(
                                                        iconColor: Colors.red,
                                                        text: 'Talspiegel',
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            16, 8, 16, 0),
                                        child: Container(
                                          width: double.infinity,
                                          height: 200,
                                          child: LineChart(LineChartData(
                                            lineTouchData: LineTouchData(
                                                touchTooltipData:
                                                    LineTouchTooltipData(
                                                        tooltipBgColor:
                                                            Colors.white)),
                                            extraLinesData: ExtraLinesData(
                                              verticalLines: [
                                                VerticalLine(
                                                  x: tmin,
                                                  color: Colors.red,
                                                  strokeWidth: 2,
                                                  dashArray: [5, 5],
                                                ),
                                                VerticalLine(
                                                  x: t_spiegel,
                                                  color: Colors.black,
                                                  strokeWidth: 2,
                                                  dashArray: [5, 5],
                                                ),
                                              ],
                                            ),
                                            titlesData: FlTitlesData(
                                              bottomTitles: AxisTitles(
                                                  sideTitles: SideTitles(
                                                showTitles: true,
                                                interval: 2,
                                                getTitlesWidget: (value, meta) {
                                                  int numberoflabel = 12;
                                                  int labelsteps =
                                                      (maxX / numberoflabel)
                                                          .round();
                                                  if (value % labelsteps == 0) {
                                                    return Text(
                                                      value.toStringAsFixed(0),
                                                      style: TextStyle(
                                                          fontSize: 10),
                                                    );
                                                  } else {
                                                    return Text('');
                                                  }
                                                },
                                              )),
                                              leftTitles: AxisTitles(
                                                  sideTitles: SideTitles(
                                                showTitles: true,
                                                interval: 2,
                                                getTitlesWidget: (value, meta) {
                                                  int numberoflabel = 10;
                                                  int labelsteps =
                                                      (maxY / numberoflabel)
                                                          .round();
                                                  if (value % labelsteps == 0) {
                                                    return Text(
                                                      value.toStringAsFixed(0),
                                                      style: TextStyle(
                                                          fontSize: 10),
                                                    );
                                                  } else {
                                                    return Text('');
                                                  }
                                                },
                                              )),
                                              topTitles: AxisTitles(
                                                  sideTitles: SideTitles(
                                                      showTitles: false)),
                                              rightTitles: AxisTitles(
                                                  sideTitles: SideTitles(
                                                      showTitles: false)),
                                            ),
                                            borderData: FlBorderData(
                                                border: const Border(
                                                    bottom: BorderSide(),
                                                    left: BorderSide())),
                                            gridData: FlGridData(
                                              show: false,
                                            ),
                                            minX: 0,
                                            maxX: maxX,
                                            minY: 0,
                                            maxY: maxY,
                                            lineBarsData: [
                                              calculatedLineChartData,
                                            ],
                                          )),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ]),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
