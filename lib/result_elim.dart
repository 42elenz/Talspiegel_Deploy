import 'dart:core';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'models.dart';

import 'own_widgets.dart';

class ResultWidget extends StatefulWidget {
  final TextEditingController textfield_intervall;
  final TextEditingController textfield_abshwz;
  final TextEditingController textfield_eliminations_hwz;
  final TextEditingController textfield_verteilungsvol;
  final TextEditingController textfield_gewicht;
  final TextEditingController textfield_dosis;
  final TextEditingController textfield_bioverfuegbarkeit;
  final DateTime gabe_passed;
  final DateTime abnahme_passed;
  final double verteilungsvol_max;
  final double verteilungsvol_min;

  const ResultWidget({
    Key? key,
    required this.textfield_intervall,
    required this.gabe_passed,
    required this.abnahme_passed,
    required this.textfield_abshwz,
    required this.textfield_eliminations_hwz,
    required this.textfield_verteilungsvol,
    required this.textfield_gewicht,
    required this.textfield_dosis,
    required this.textfield_bioverfuegbarkeit,
    required this.verteilungsvol_min,
    required this.verteilungsvol_max,
  }) : super(key: key);

  @override
  _ResultWidgetState createState() => _ResultWidgetState();
}

class _ResultWidgetState extends State<ResultWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationcontroller;
  double verticalDrag = 80;
  TextEditingController textfield_abn = TextEditingController();
  TextEditingController textfield_gabe = TextEditingController();

  final scaffoldKey = GlobalKey<ScaffoldState>();

  String? _gabeError;
  String? _abnahmeError;
  double maxX = 0;
  double maxY = 0;
  List<FlSpot> dataPoints = [];
  List<FlSpot> dataPoints_min = [];
  List<FlSpot> dataPoints_max = [];
  List<FlSpot> dataPoints_real = [];
  String calculatedTalspiegel = '';
  dynamic calculatedLineChartData = LineChartBarData(
      spots: [FlSpot(0, 0)],
      isCurved: true,
      color: Colors.blue,
      dotData: FlDotData(show: false),
      belowBarData: BarAreaData(show: false),
      dashArray: [5, 5]);
  dynamic calculatedLineChartData_min = LineChartBarData(
      spots: [FlSpot(0, 0)],
      isCurved: true,
      color: Colors.blue,
      dotData: FlDotData(show: false),
      belowBarData: BarAreaData(show: false),
      dashArray: [5, 5]);
  dynamic calculatedLineChartData_max = LineChartBarData(
      spots: [FlSpot(0, 0)],
      isCurved: true,
      color: Colors.blue,
      dotData: FlDotData(show: false),
      belowBarData: BarAreaData(show: false),
      dashArray: [5, 5]);
  dynamic calculatedLineChartData_real = LineChartBarData(
      spots: [FlSpot(0, 0)],
      isCurved: true,
      color: Colors.blue,
      dotData: FlDotData(show: false),
      belowBarData: BarAreaData(show: false),
      dashArray: [5, 5]);
  DateTime gabe = DateTime.now();
  DateTime abnahme = DateTime.now();
  String differenz = '0';
  String floatingRegeEp = "[+-]?([0-9]+([.][0-9]*)?|[.][0-9]+)";

  double verabreichungsintervall = 0;
  double halflife_absorb = 1;
  double halflife_elim = 1;
  double dosis = 0;
  double bioverfuegbarkeit = 0;
  double Ka = 0;
  double Ke = 0;
  double verteilungsvolumen = 1;
  double t_spiegel = 0;
  double gewicht = 1;
  final borderColorFilled = Color(0xFF4DABF6);

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
      calculatedTalspiegel = result + ' ng/ml';
      differenz = t_diff;
    });
  }

  Future<void> parsePassedControllers() async {
    gabe = widget.gabe_passed;
    abnahme = widget.abnahme_passed;
    List<String> halflife_string = widget.textfield_abshwz.text.split(' ');
    if (halflife_string.length > 1) {
      halflife_string[0] = halflife_string[0].replaceAll(',', '.');
      halflife_absorb = double.tryParse(halflife_string[0]) ?? 1;
    }
    List<String> halflife_elim_string =
        widget.textfield_eliminations_hwz.text.split(' ');
    if (halflife_elim_string.length > 1) {
      halflife_elim_string[0] = halflife_elim_string[0].replaceAll(',', '.');
      halflife_elim = double.tryParse(halflife_elim_string[0]) ?? 1;
    }
    List<String> dosis_string = widget.textfield_dosis.text.split(' ');
    if (dosis_string.length > 1) {
      dosis_string[0] = dosis_string[0].replaceAll(',', '.');
      dosis = double.tryParse(dosis_string[0]) ?? 0;
      dosis *= 1000;
    }
    List<String> bioverfuegbarkeit_string =
        widget.textfield_bioverfuegbarkeit.text.split(' ');
    if (bioverfuegbarkeit_string.length > 1) {
      bioverfuegbarkeit_string[0] =
          bioverfuegbarkeit_string[0].replaceAll(',', '.');
      bioverfuegbarkeit =
          (double.tryParse(bioverfuegbarkeit_string[0]) ?? 0) / 100;
    }
    List<String> verteilungsvol_string =
        widget.textfield_verteilungsvol.text.split(' ');
    if (verteilungsvol_string.length > 1) {
      verteilungsvol_string[0] = verteilungsvol_string[0].replaceAll(',', '.');
      verteilungsvolumen = double.tryParse(verteilungsvol_string[0]) ?? 1;
    }
    List<String> verabreichungsintervall_string =
        widget.textfield_intervall.text.split(' ');
    if (verabreichungsintervall_string.length > 1) {
      verabreichungsintervall_string[0] =
          verabreichungsintervall_string[0].replaceAll(',', '.');
      verabreichungsintervall =
          double.tryParse(verabreichungsintervall_string[0]) ?? 0;
    }
    List<String> gewicht_string = widget.textfield_gewicht.text.split(' ');
    if (gewicht_string.length > 1) {
      gewicht_string[0] = gewicht_string[0].replaceAll(',', '.');
      gewicht = double.tryParse(gewicht_string[0]) ?? 0;
    }
  }

  void setterFunctions() async {
    parsePassedControllers();
    await calculateLineChartData();
    calculateMinMax();
    await calculateAndUpdate();
  }

  @override
  void initState() {
    super.initState();
    _animationcontroller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    Timer(Duration(milliseconds: 350), () => _animationcontroller.forward());
    gabe = widget.gabe_passed;
    abnahme = widget.abnahme_passed;
    textfield_abn.text = DateFormat('dd/MM-kk:mm').format(abnahme);
    textfield_gabe.text = DateFormat('dd/MM-kk:mm').format(gabe);
    setterFunctions();
  }

  Future<String> calculate() async {
    double talspiegel = 0;
    for (FlSpot point in dataPoints) {
      if (point.x == verabreichungsintervall) {
        talspiegel = point.y;
      }
    }
    return (talspiegel.toString());
  }

  String duration() {
    int hours = 5 * halflife_elim.toInt();
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
      double bioverfuegbarkeit,
      double dosis,
      double Ka,
      double Ke,
      double verteilungsvolumen,
      double gewicht,
      double x) {
    // Calculate the concentration at time t using the exponential decay formula
    double concentration = ((bioverfuegbarkeit * dosis * Ka) /
            (verteilungsvolumen * gewicht * (Ka - Ke))) *
        (exp(-Ke * x) - exp(-Ka * x));

    return concentration;
  }

  Future<List<FlSpot>> calculateDataPoints() async {
    dataPoints = [];
    dataPoints_min = [];
    dataPoints_max = [];
    dataPoints_real = [];

    if (halflife_absorb != halflife_elim) {
      int t = verabreichungsintervall.toInt();

      double Ka = ln2 / halflife_absorb;
      double Ke = ln2 / halflife_elim;
      for (double x = 0; x <= t; x++) {
        double double_y = calculateConcentration(
            bioverfuegbarkeit, dosis, Ka, Ke, verteilungsvolumen, gewicht, x);
        double y = double.parse(double_y.toStringAsFixed(2));
        dataPoints.add(FlSpot(x, y));

        if (widget.verteilungsvol_min != -99 &&
            widget.verteilungsvol_max != -99) {
          double_y = calculateConcentration(bioverfuegbarkeit, dosis, Ka, Ke,
              widget.verteilungsvol_min, gewicht, x);
          y = double.parse(double_y.toStringAsFixed(2));
          dataPoints_min.add(FlSpot(x, y));

          double_y = calculateConcentration(bioverfuegbarkeit, dosis, Ka, Ke,
              widget.verteilungsvol_max, gewicht, x);
          y = double.parse(double_y.toStringAsFixed(2));
          dataPoints_max.add(FlSpot(x, y));
        }
      }
      //Calculate "RealDistrib"

      calculateMinMax();
    } else {
      dataPoints_max.add(FlSpot(0, 0));
      dataPoints_min.add(FlSpot(0, 0));
      dataPoints.add(FlSpot(0, 0));
      dataPoints_real.add(FlSpot(0, 0));
    }

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
    if (widget.verteilungsvol_max != -99 && widget.verteilungsvol_min != -99) {
      maxY = dataPoints_max[0].y;
      for (FlSpot point in dataPoints_max) {
        if (point.y > maxY) {
          maxY = point.y;
        }
      }
      for (FlSpot point in dataPoints_real) {
        if (point.y > maxY) {
          maxY = point.y;
        }
      }
    } else {
      maxY = dataPoints[0].y;
      for (FlSpot point in dataPoints) {
        if (point.y > maxY) {
          maxY = point.y;
        }
      }
    }
    return maxY;
  }

  Future<LineChartBarData> calculateLineChartData() async {
    await calculateDataPoints();
    calculatedLineChartData = await LineChartBarData(
        spots: dataPoints,
        isCurved: true,
        color: Colors.blue,
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(show: false),
        dashArray: [5, 5]);

    calculatedLineChartData_min = await LineChartBarData(
        spots: dataPoints_min,
        isCurved: true,
        color: Color.fromARGB(255, 50, 114, 52),
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(show: false),
        dashArray: [5, 5]);

    calculatedLineChartData_max = await LineChartBarData(
        spots: dataPoints_max,
        isCurved: true,
        color: Color.fromARGB(255, 247, 161, 3),
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(show: false),
        dashArray: [5, 5]);

    calculatedLineChartData_real = await LineChartBarData(
      spots: dataPoints_real,
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
              child: CustomAppBar(screenName: ' Ergebnis')),
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
                              EdgeInsetsDirectional.fromSTEB(42.5, 10, 42.5, 5),
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
                                    calculateMinMax();
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
                                        calculateMinMax();
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
                                  controller: widget.textfield_dosis,
                                  labelText: 'Dosis',
                                  hintText: 'in mg',
                                  suffixText: 'mg',
                                  infoText: "Dosis des Medikaments in mg.",
                                  onChanged: (p0) => setState(() {}),
                                  maxLength: 8,
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
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(16, 12, 12, 0),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.max,
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
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(16, 12, 12, 0),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.max,
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
                                                                (verabreichungsintervall)
                                                            ? "Achtung, die Zeitspanne zwischen Medikationsgabe und Spiegelabnahme ist größer gewählt, als das Verabreichungsintervall von ${widget.textfield_intervall.text}! Bitte kontrollieren!"
                                                            : "Das festgelegte Verabreichungsintervall beträgt ${widget.textfield_intervall.text}",
                                                        style: (int.tryParse(
                                                                        differenz) ??
                                                                    0) >
                                                                (verabreichungsintervall)
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
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(8, 0, 12, 10),
                                                child: Wrap(
                                                  spacing: 8,
                                                  runSpacing: 4,
                                                  children: [
                                                    IconTextRow(
                                                      iconColor: Colors.black,
                                                      text: 'Spiegelabnahme',
                                                    ),
                                                    IconTextRow(
                                                      iconColor: Colors.red,
                                                      text: 'Talspiegel',
                                                    ),
                                                    IconTextRow(
                                                      iconColor: Color.fromARGB(
                                                          255, 247, 161, 3),
                                                      text:
                                                          'Maximales Verteilungsvolumen',
                                                      icon: Icons.circle,
                                                    ),
                                                    IconTextRow(
                                                      iconColor: Colors.blue,
                                                      text:
                                                          'Mittleres Verteilungsvolumen',
                                                      icon: Icons.circle,
                                                    ),
                                                    IconTextRow(
                                                      iconColor:
                                                          const Color.fromARGB(
                                                              255, 50, 114, 52),
                                                      text:
                                                          'Minimales Verteilungsvolumen',
                                                      icon: Icons.circle,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            16, 16, 16, 0),
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
                                                  x: verabreichungsintervall,
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
                                                  return (Text(
                                                      value.toStringAsFixed(0),
                                                      style: TextStyle(
                                                          fontSize: 10)));
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
                                              calculatedLineChartData_real,
                                              calculatedLineChartData_min,
                                              calculatedLineChartData_max,
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
