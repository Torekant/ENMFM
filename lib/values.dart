import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Values{
  static Hues hue = new Hues();

  //TextStyles
  TextStyle titleTextStyle = TextStyle(fontFamily: 'Montserrat', color: hue.outlines, fontSize: 25.0);
  TextStyle subtitleTextStyle = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0, color: hue.outlines, fontWeight: FontWeight.normal);
  TextStyle contentTextStyle = TextStyle(fontFamily: 'Montserrat', color: hue.outlines, fontSize: 17.5);
  TextStyle boldSubtitleTextStyle = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0, fontWeight: FontWeight.bold);
  TextStyle materialButtonBoldTextStyle = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0, color: hue.background, fontWeight: FontWeight.bold);
  TextStyle textFieldTextStyle = TextStyle(fontFamily: 'Montserrat', color: hue.outlines, fontWeight: FontWeight.normal);
  TextStyle flatButtonTextStyle = TextStyle(fontFamily: 'Montserrat', color: hue.outlines, fontWeight: FontWeight.normal, fontSize: 15.0);
  TextStyle plainTextStyle = TextStyle(fontFamily: 'Montserrat', color: hue.outlines, fontSize: 16.0);
  TextStyle calendarDayTextStyle = TextStyle(fontFamily: 'Montserrat', color: hue.outlines, fontSize: 15.0);
  TextStyle calendarWeekendDayTextStyle = TextStyle(fontFamily: 'Montserrat', color: hue.carmesi, fontSize: 15.0);

  //size values
  double standardPaddingLeft = 20.0, standardPaddingTop = 15.0, standardPaddingRight = 20.0, standardPaddingBottom = 15.0, standardBorderRadius = 10.0;
  double bigSizedBoxStandardHeight = 250.0, mediumSizedBoxStandardHeight = 50.0, smallSizedBoxStandardHeight = 15.0, toolbarGapSizedBox = 23.0, lineSizedBoxHeight = 2.0;
  double cardSizedBox = 300.0;

  double widthPaddingUnit = 0.325;

  double dialogPadding = 16.0;
  double avatarRadius = 66.0;

  //strings
  static String assetsPath = "assets/";
  String tooltipChangeEventImage = "Cambiar imagen";
  String emptyTextFieldMessage = "Este campo no puede estar vacio";
  String notValidEmailMessage = "El contenido debe ser un correo válido";
  String welcomeText = "La necesidad de una formación para los maestros irrumpe, históricamente, al mismo tiempo que inicia México su vida independiente, es entonces cuando las primeras Escuelas Normales se conciben con la intención de formar y elevar la capacitación de los docentes, con el propósito de empezar a ofrecer una educación popular.";

  //bytes
  int maxImageSize = 7 * 1024 * 1024;

  //Firebase references
  var storageReference = FirebaseStorage.instance.ref();
  var firestoreReference = Firestore.instance;

  //alignment
  Alignment centerAlignment = new Alignment(0.0, 0.0);

  //urls
  String urlWebPage = 'http://www.enmfm.edu.mx';

  //amounts
  int numberOfAdminTabs = 1;

  //maps
  Map<String, int> dialogPurposes = {"Crear administrador": 0, "Recuperar contraseña": 1, "Cambiar correo": 2};
  Map<String, String> eventType = {'ceremony': 'ceremonia', 'exam': 'exámen', 'delivery': 'entrega'};

  //timer
  int defaultTimer = 5;

  //padding
  double defaultSymmetricPadding = 30.0;

  //assets
  String logoColored = assetsPath + "logo_color.jpg";
  String enmfmBuilding = assetsPath + "enmfm.jpg";
  String loadingAnimation = assetsPath + "loading.gif";
  String retrievingListAnimation = assetsPath + "retrieving.gif";
  String defaultPlace = assetsPath + "logo_gray.jpg";

  //responsive
  double defaultDivisionForResponsiveHeight = 2.2;
  double defaultDivisionForResponsiveWidth = 2.2;

  //icons defaults
  double toolbarIconSize = 35.0;

  //container defaults
  double containerWidth = 15.0;

  //buttons defaults
  double buttonElevation = 5.0;

  //textfields defaults
  BorderSide textFieldFocusBorderSide = new BorderSide(color: hue.chicken);
}

class Hues{

 Color background = Color(0xFFffffff);
 Color carmesi = Color(0xFFed1c22);
 Color outlines = Color(0xFF242021);
 Color ocean = Color(0xFF2e3192);
 Color chicken = Color(0xFFfdf202);

}