import 'package:flutter/material.dart';

import 'models.dart';
import 'package:google_fonts/google_fonts.dart';
import 'enter_data.dart';
import 'enter_data_elimination.dart';

// Models

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
          image: AssetImage('assets/background.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.white.withOpacity(0.4),
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight),
            child: CustomAppBar(screenName: 'Auswahl')),
        body: Align(
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Wählen Sie eine Berechnung:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ChoiceBox(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EnterDataForm(),
                                  ));
                            },
                            headerText:
                                'Talspiegelberechnung - Halbwertszeit \n',
                            bodyText:
                                'Anhand der Consensus Guidelines for Therapeutic Drug Monitoring in Neuropsychopharmacology: Update 2017',
                          )),
                    ],
                  ),
                ),
                Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                    child: ChoiceBox(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Warnung'),
                              content: Text(
                                'Diese Funktion kann noch nicht verwendet werden!\nDies wird voraussichtlich nach der Veröffentlichung der neuen Consensus Guideline möglich sein. Für einen früheren Zugang kontaktieren Sie den Entwickler.',
                              ),
                              actions: <Widget>[
                                TextButton(
                                  child: Text('Cancel'),
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pop(); // Close the dialog
                                  },
                                ),
                                // TextButton(
                                //   child: Text('Continue'),
                                //   onPressed: () {
                                //     Navigator.of(context)
                                //         .pop(); // Close the dialog
                                //     Navigator.push(
                                //       context,
                                //       MaterialPageRoute(
                                //         builder: (context) =>
                                //             EnterDataForm_elimination(),
                                //       ),
                                //     );
                                //   },
                                // ),
                              ],
                            );
                          },
                        );
                      },
                      headerText: 'Talspiegelberechnung - Eliminationszeit \n',
                      bodyText:
                          " Experimentelle Berechnung anhand der Eliminationszeiten und HWZ. Voraussichtlich 2024 zugänglich..\n",
                    ))
              ],
            )),
          ),
        ),
      ),
    );
  }
}
