import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import 'package:talspiegel/own_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'onboarding_screen.dart';

class Medication {
  String name;
  int mintal;
  int hlf;
  int id;

  Medication(
      {required this.name,
      required this.mintal,
      required this.hlf,
      this.id = 0});
}

final styleHeader = TextStyle(
  fontSize: 24,
  fontWeight: FontWeight.bold,
  color: Colors.black,
  fontFamily: GoogleFonts.outfit().fontFamily,
);
final borderSideColor = Color.fromRGBO(224, 227, 231, 1);
final focusBorderSideColor = Color(0xFF4DABF6);
final errorBorderSideColor = Colors.red;
final labelStyle = TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.normal,
  color: Color.fromARGB(255, 83, 83, 83),
  fontFamily: 'Readex Pro',
);
final textStyle = TextStyle(
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

final styleText = TextStyle(
  fontSize: 19,
  fontWeight: FontWeight.normal,
  color: Colors.black,
  fontFamily: GoogleFonts.outfit().fontFamily,
);

class OnBoardingInformationBox extends StatelessWidget {
  final String title;
  final String description;
  final String imagePath;

  OnBoardingInformationBox({
    required this.title,
    required this.description,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(12, 12, 12, 12),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 12),
            child: Text(
              title,
              style: styleHeader,
            ),
          ),
          Container(
            width: 500,
            height: 300,
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 12),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.white,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.black.withOpacity(0.3),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Image.asset(
                      imagePath,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.scaleDown,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(12, 4, 12, 0),
            child: Text(
              description,
              style: styleText,
            ),
          ),
        ],
      ),
    );
  }
}

class OnBoardingInformationBoxWithTwoImages extends StatelessWidget {
  final String title;
  final String description;
  final String imagepath1;
  final String imagepath2;

  OnBoardingInformationBoxWithTwoImages({
    required this.title,
    required this.description,
    required this.imagepath1,
    required this.imagepath2,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(12, 12, 12, 12),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 12),
            child: Text(
              title,
              style: styleHeader,
            ),
          ),
          Container(
            width: double.infinity,
            height: 300,
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 12),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.white,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.black.withOpacity(0.3),
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                          imagepath1,
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.scaleDown,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                          imagepath2,
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.scaleDown,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(12, 4, 12, 0),
            child: Text(
              description,
              style: styleText,
            ),
          ),
        ],
      ),
    );
  }
}

class CustomTextInputField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  final FocusNode? nextNode;
  final String labelText;
  final String hintText;
  final String suffixText;
  final String infoText;
  final int maxLength;
  final ValueChanged<String>? onChanged;
  final String regExp;
  String? errorText;

  CustomTextInputField({
    required this.controller,
    required this.labelText,
    required this.hintText,
    required this.suffixText,
    this.infoText = "",
    this.onChanged,
    this.maxLength = 20,
    this.regExp = r"[0-9]",
    this.focusNode,
    this.nextNode,
    this.errorText,
  });

  @override
  State<CustomTextInputField> createState() => _CustomTextInputFieldState();
}

class _CustomTextInputFieldState extends State<CustomTextInputField> {
  @override
  Widget build(BuildContext context) {
    dynamic borderColor = Color(0xFF4DABF6);
    return TextFormField(
        controller: widget.controller,
        focusNode: widget.focusNode,
        maxLength: widget.maxLength,
        onEditingComplete: () {
          if (widget.nextNode != null) {
            FocusScope.of(context).requestFocus(widget.nextNode);
          } else {
            FocusScope.of(context).unfocus();
          }
        },
        onChanged: (text) {
          if (text.isEmpty) {
            widget.controller.text = '';
          } else {
            widget.controller.text = text + ' ' + widget.suffixText;
            widget.controller.selection = TextSelection.fromPosition(
              TextPosition(
                offset: widget.controller.text.length -
                    (widget.suffixText.length + 1),
              ),
            );
          }
          setState(() {});
        },
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(widget.regExp)),
        ],
        decoration: InputDecoration(
          filled: true,
          errorText:
              widget.controller.text.isNotEmpty ? null : widget.errorText,
          counterText: "",
          fillColor: Colors.transparent,
          labelText: widget.labelText,
          labelStyle: textStyle,
          hintText: widget.hintText,
          hintStyle: hintStyle,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: widget.controller.text.isNotEmpty
                  ? borderColor
                  : borderSideColor,
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
              color: widget.controller.text.isNotEmpty
                  ? focusBorderSideColor
                  : errorBorderSideColor,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: widget.controller.text.isNotEmpty
                  ? focusBorderSideColor
                  : errorBorderSideColor,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          suffixIcon:
              createInfoIconButton(widget.labelText, widget.infoText, context),
          errorStyle: TextStyle(
            color: widget.controller.text.isNotEmpty
                ? focusBorderSideColor
                : errorBorderSideColor,
          ),
        ),
        style: textStyle,
        textAlign: TextAlign.center);
  }
}

class ChoiceBox extends StatefulWidget {
  final String headerText;
  final String bodyText;
  final VoidCallback? onTap;

  ChoiceBox(
      {required this.headerText, required this.bodyText, required this.onTap});

  @override
  _ChoiceBoxState createState() => _ChoiceBoxState();
}

class _ChoiceBoxState extends State<ChoiceBox> {
  bool isHovered = false;
  double maxwidth = 400;
  double maxheight = 350;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      onHover: (val) {
        setState(() {
          isHovered = val;
        });
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8 < maxwidth
            ? MediaQuery.of(context).size.width * 0.8
            : maxwidth,
        height: MediaQuery.of(context).size.width * 0.5 < maxheight
            ? MediaQuery.of(context).size.width * 0.5
            : maxheight,
        decoration: BoxDecoration(
          color: isHovered
              ? Color.fromARGB(255, 205, 228, 247)
              : Colors.white, // Change color on hover
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  widget.headerText,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.clip,
                ),
              ),
              Flexible(
                child: Text(
                  widget.bodyText,
                  style: TextStyle(color: Colors.black, fontSize: 14),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.clip,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomAppBar extends StatelessWidget {
  final String screenName;

  CustomAppBar({required this.screenName});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      scrolledUnderElevation: 0,
      backgroundColor: Colors.white,
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              child: Icon(
                Icons.arrow_left,
                color: Colors.black,
                size: 40,
              ),
            ),
          ),
          Image.asset('assets/logo.png', width: 50, height: 50),
          SizedBox(width: 8),
          Text(
            screenName,
            style: styleHeaderAppBar,
          ),
        ],
      ),
      actions: [
        CupertinoButton(
          padding: const EdgeInsets.all(5.0),
          child: Tooltip(
            message: 'Tutorial anzeigen',
            child: const Icon(Icons.help_outline),
          ),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('Tutorial anzeigen'),
                  content: Text('Wollen Sie das Tutorial anschauen?'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        // Handle the confirmation to go back to the tutorial screen here
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OnboardingWidget(),
                            ));
                      },
                      child: Text('Ja', style: TextStyle(color: Colors.black)),
                    ),
                    TextButton(
                      onPressed: () {
                        // Handle cancel
                        Navigator.pop(context);
                      },
                      child:
                          Text('Nein', style: TextStyle(color: Colors.black)),
                    ),
                  ],
                );
              },
            );
          },
        ),
        CupertinoButton(
          padding: const EdgeInsets.all(5.0),
          child: Tooltip(
              message: 'Impressum',
              child: const Icon(Icons.info_outline_rounded)),
          onPressed: () => showAboutDialog(
            context: context,
            //applicationIcon: ,
            applicationVersion:
                "V1.0; \nDr.med.Esra Lenz \n Support by Paul Geeser",
            applicationLegalese:
                "This app is free to use. Sources: 'Kompendium der Psychiatrischen Pharmakotherapie', O.Benkert, H.Hippus; 11. Auflage ",
          ),
        ),
        /* CupertinoButton(
          padding: const EdgeInsets.all(5.0),
          child: Tooltip(message: 'Exit', child: const Icon(Icons.exit_to_app)),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('Exit bestätigen'),
                  content: Text('Wollen Sie die App verlassen?'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the dialog
                        SystemNavigator.pop(); // Exit the app
                      },
                      child: Text('Ja', style: TextStyle(color: Colors.red)),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the dialog
                      },
                      child:
                          Text('Nein', style: TextStyle(color: Colors.black)),
                    ),
                  ],
                );
              },
            );
          },
        ), */
      ],
    );
  }
}

class IconTextRow extends StatelessWidget {
  final Color iconColor;
  final String text;
  final icon;

  IconTextRow({
    required this.iconColor,
    required this.text,
    this.icon = Icons.linear_scale,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Icon(
          icon,
          color: iconColor,
          size: 18,
        ),
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(8, 0, 0, 0),
          child: Text(
            text,
            style: textStyle,
          ),
        ),
      ],
    );
  }
}
