import 'package:flutter/material.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart' as assetManifest;
import 'enter_data.dart';
import 'enter_data_elimination.dart';
import 'package:google_fonts/google_fonts.dart';

// Models
import 'onboarding_screen.dart';

final styleHeaderAppBar = TextStyle(
  fontSize: 24,
  fontWeight: FontWeight.normal,
  color: Colors.black,
  fontFamily: GoogleFonts.outfit().fontFamily,
);

class ChoiceScreen extends StatelessWidget {
  final ButtonStyle flatButtonStyle = TextButton.styleFrom(
    foregroundColor: Colors.white,
    minimumSize: const Size(88, 36),
    padding: EdgeInsets.symmetric(horizontal: 16.0),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(2.0)),
    ),
    backgroundColor: Colors.blue,
  );
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('background.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.white.withOpacity(0.4),
        appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              Image.asset('logo.png', width: 50, height: 50),
              SizedBox(width: 8),
              Text(
                'Auswahl',
                style: styleHeaderAppBar,
              ),
            ],
          ),
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
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Wählen Sie eine Berechnung:        ',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  child: Text(
                    'Talspiegelberechnung - Halbwertszeit',
                    style: TextStyle(color: Colors.black),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EnterDataForm(),
                      ),
                    );
                  },
                ),
                IconButton(
                    icon: Icon(Icons.info_outline_rounded),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              backgroundColor:
                                  Color.fromARGB(236, 149, 204, 252),
                              title: Text(
                                "Talspiegelberechnung - Halbwertszeit",
                              ),
                              content: Text(
                                  "Berechnen Sie sie den Talspiegel anhand der Halbwertszeit. Dies ist die Formel aus der Consensus Guidelines for Therapeutic Drug Monitoring in Neuropsychopharmacology: Update 2017"),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text("OK",
                                        style: TextStyle(color: Colors.black)))
                              ],
                            );
                          });
                    })
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  child: Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Text(
                        'Talspiegelberechnung - Eliminationszeit \n(experimentell)',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black)),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EnterDataForm_elimination(),
                      ),
                    );
                  },
                ),
                IconButton(
                    icon: Icon(Icons.info_outline_rounded),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              backgroundColor:
                                  Color.fromARGB(236, 149, 204, 252),
                              title: Text(
                                  "Talspiegelberechnung - Eliminationszeit"),
                              content: Text(
                                  "Berechnen Sie sie den Talspiegel anhand der Eliminationszeiten und HWZ. Dies ist eine experimentelle Formel, welche aktuell noch in keiner Guideline zu finden ist."),
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
                    })
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  child: Text('Zum Tutorial',
                      style: TextStyle(color: Colors.black)),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OnboardingWidget(),
                      ),
                    );
                  },
                ),
                IconButton(
                    icon: Icon(Icons.info_outline_rounded),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              backgroundColor:
                                  Color.fromARGB(236, 149, 204, 252),
                              title: Text("Tutorial"),
                              content: Text(
                                  "Zurück zum Tutorial. Für weitere Fragen klicke die durch bis zum Ende!"),
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
                    })
              ],
            ),
          ],
        )),
      ),
    );
  }
}
