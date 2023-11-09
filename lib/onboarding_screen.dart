import 'choice_screen2.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart'
    as smooth_page_indicator;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'asset_player.dart';
import 'models.dart';

class OnboardingWidget extends StatefulWidget {
  const OnboardingWidget({Key? key}) : super(key: key);

  @override
  _OnboardingWidgetState createState() => _OnboardingWidgetState();
}

class _OnboardingWidgetState extends State<OnboardingWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final styleHeader = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.black,
    fontFamily: GoogleFonts.outfit().fontFamily,
  );
  final styleText = TextStyle(
    fontSize: 19,
    fontWeight: FontWeight.normal,
    color: Colors.black,
    fontFamily: GoogleFonts.outfit().fontFamily,
  );
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    PageController pageController =
        PageController(initialPage: currentPageIndex);
    return GestureDetector(
      onTap: () => {
        if (FocusScope.of(context).hasPrimaryFocus)
          {FocusScope.of(context).unfocus()}
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
          body: SafeArea(
            top: true,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Container(
                    width: double.infinity,
                    height: 600,
                    child: Stack(
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 30),
                          child: PageView(
                            controller: pageController,
                            scrollDirection: Axis.horizontal,
                            onPageChanged: (index) {
                              setState(() {
                                currentPageIndex = index;
                              });
                            },
                            children: [
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    12, 78, 12, 12),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      height: 300,
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0, 0, 0, 12),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.white,
                                                width: 2,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              color:
                                                  Colors.black.withOpacity(0.3),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(15.0),
                                              child: Image.asset(
                                                'assets/icon.png',
                                                width: double.infinity,
                                                height: 300,
                                                fit: BoxFit.scaleDown,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          12, 0, 0, 0),
                                      child: Text(
                                          'Talspiegelberechnung von Medikamenten',
                                          style: styleHeader),
                                    ),
                                    Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            12, 4, 12, 0),
                                        child: Text(
                                          'Nicht zur medizinischen Diagnostik geeignet!\n',
                                          style: styleText,
                                        )),
                                  ],
                                ),
                              ),
                              OnBoardingInformationBox(
                                  title: "Medikamentenauswahl",
                                  description:
                                      "Wählen Sie ein Medikament aus der Liste. Halbwertszeit und Verabreichungsintervall werden automatisch ausgefüllt, können aber manuell angepasst werden.",
                                  imagePath: 'assets/Auswahl_Substanz.png'),
                              OnBoardingInformationBox(
                                  title:
                                      'Verabreichungsabstand und Halbwertszeit',
                                  description:
                                      'Angabe der Zeit in Stunden zwischen den Einnahmen des Medikaments (z.B. 24h bei einmaliger täglicher Einnahme). Angabe der HWZ.',
                                  imagePath:
                                      'assets/VerabreichungsIntervvall_HWZ.png'),
                              OnBoardingInformationBox(
                                  title: 'Medikametenspiegel bei Abnahme',
                                  description:
                                      'Gemessene Konzentration bei Abnahme.\n\n',
                                  imagePath: 'assets/Spiegel_ct.png'),
                              OnBoardingInformationBox(
                                  title:
                                      'Medikationsgabe- und Spiegelabnahmezeitpunkt',
                                  description:
                                      'Zeitauswahl für die Medikamentenverbreichung und Spiegelabnahme. Die Gabe MUSS vor der Abnahme liegen.\n',
                                  imagePath: 'assets/Zeiten.png'),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    12, 0, 12, 0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0, 0, 0, 12),
                                      child: Text(
                                        'Zeiteneingabefeld',
                                        style: styleHeader,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0, 0, 0, 12),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(0),
                                        child: Container(
                                          width: double.infinity,
                                          height: 300,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: Colors.white,
                                                  width: 2,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                color: Colors.black
                                                    .withOpacity(0.3),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(15.0),
                                                child: AssetPlayerWidget(
                                                    asset:
                                                        'assets/Zeitenauswahl.mp4'),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          6, 0, 6, 0),
                                      child: Text(
                                          'Darstellung der Zeitenauswahl. Die Medikamentengabe sollte VOR der Spiegelabnahme liegen\n',
                                          style: styleText),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    12, 0, 12, 0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0, 0, 0, 12),
                                      child: Text(
                                        'Ergebnisscreen',
                                        style: styleHeader,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0, 0, 0, 12),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(0),
                                        child: Container(
                                          width: double.infinity,
                                          height: 300,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: Colors.white,
                                                  width: 2,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                color: Colors.black
                                                    .withOpacity(0.3),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(15.0),
                                                child: AssetPlayerWidget(
                                                    asset:
                                                        'assets/Ergebnisscreen.mp4'),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          6, 0, 6, 0),
                                      child: Text(
                                          'Darstellung des Endscreens. Dieser reagiert auf Neueingaben.\n',
                                          style: styleText),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    12, 0, 12, 0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0, 0, 0, 12),
                                      child: Text(
                                        'Gesamt-Tutorial-Video',
                                        style: styleHeader,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0, 0, 0, 12),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(0),
                                        child: Container(
                                          width: double.infinity,
                                          height: 300,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: Colors.white,
                                                  width: 2,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                color: Colors.black
                                                    .withOpacity(0.3),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(15.0),
                                                child: AssetPlayerWidget(
                                                    asset:
                                                        'assets/tutorial.mp4'),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          6, 0, 6, 0),
                                      child: Text(
                                          'Gesamter-Workflow bis zum Talspiegel\n\n',
                                          style: styleText),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Align(
                          alignment: AlignmentDirectional(0.00, 1.00),
                          child: Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
                            child: smooth_page_indicator.SmoothPageIndicator(
                              controller: pageController,
                              count: 8,
                              axisDirection: Axis.horizontal,
                              onDotClicked: (i) async {
                                await pageController.animateToPage(
                                  i,
                                  duration: Duration(milliseconds: 500),
                                  curve: Curves.ease,
                                );
                              },
                              effect: smooth_page_indicator.ExpandingDotsEffect(
                                expansionFactor: 2,
                                spacing: 8,
                                radius: 16,
                                dotWidth: 16,
                                dotHeight: 4,
                                dotColor: Colors.grey,
                                activeDotColor: Colors.black,
                                paintStyle: PaintingStyle.fill,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(24, 24, 24, 24),
                  child: Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    alignment: WrapAlignment.start,
                    crossAxisAlignment: WrapCrossAlignment.start,
                    direction: Axis.horizontal,
                    runAlignment: WrapAlignment.start,
                    verticalDirection: VerticalDirection.down,
                    clipBehavior: Clip.none,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => ChoiceScreen()));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Colors.white, // Button background color
                          padding: EdgeInsets.symmetric(
                              vertical: 16,
                              horizontal: 32), // Adjust padding as needed
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                        ),
                        child: Text(
                          'Lass mich losrechnen',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Readex Pro',
                            color: Colors.black,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
