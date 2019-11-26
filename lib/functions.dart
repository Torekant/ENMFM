import 'package:enmfm/classes.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'values.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

LaunchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

Future<Map> RetrieveCalendarEvents(BuildContext context) async{
  Values values = new Values();
  QuerySnapshot _snapshots;
  List<DocumentSnapshot> _documents;
  Map<DateTime, List<Event>> events = new Map();
  List<Event> _listEvent = new List();
  DateTime _lastDateTimeIteration;

  _snapshots = await values.firestoreReference.collection('events').getDocuments();
  _documents = _snapshots.documents;

  _documents.sort((a, b) => DateTime.parse(a['date']).compareTo(DateTime.parse(b['date'])));

  _documents.forEach((event){

    if(_lastDateTimeIteration == DateTime.parse(event['date'])){
      Event dummyEvent = new Event(event.documentID, event['title'], event['image'], event['place'], event['date'], event['time'], event['description'], event['type']);
      _listEvent.add(dummyEvent);
    }else{
      if(_listEvent.isEmpty){
        Event dummyEvent = new Event(event.documentID, event['title'], event['image'], event['place'], event['date'], event['time'], event['description'],  event['type']);
        _listEvent.add(dummyEvent);
        _lastDateTimeIteration = DateTime.parse(event['date']);
      }else{
        events[_lastDateTimeIteration] = _listEvent;
        _listEvent = [];
        Event dummyEvent = new Event(event.documentID, event['title'], event['image'], event['place'], event['date'], event['time'], event['description'], event['type']);
        _listEvent.add(dummyEvent);
        _lastDateTimeIteration = DateTime.parse(event['date']);
      }
    }

  });

  events[_lastDateTimeIteration] = _listEvent;

  return events;
}

Future<List> RetrieveListEvents(BuildContext context) async{
  Values values = new Values();
  QuerySnapshot _snapshots;
  List<DocumentSnapshot> _documents;
  List<Event> _list = new List();

  DateFormat df = new DateFormat('yyyy-MM-dd');
  String _todaysDate = df.format(DateTime.now().subtract(Duration(days: 6)));
  String _aWeekFromTodayDate = df.format(DateTime.now().add(Duration(days: 7)));

  _snapshots = await values.firestoreReference.collection('events').where('date', isGreaterThanOrEqualTo: _todaysDate).where('date', isLessThanOrEqualTo: _aWeekFromTodayDate).getDocuments();
  _documents = _snapshots.documents;

  _documents.sort((a, b) => DateTime.parse(a['date']).compareTo(DateTime.parse(b['date'])));
  _documents.sort((a, b) {
    if(a['date'] == b['date']){
      String _aTime = a['time'];
      String _part1 = _aTime.substring(0, 2);
      String _part2 = _aTime.substring(3, 5);
      _aTime = _part1 + _part2;
      String _bTime = b['time'];
      _part1 = _bTime.substring(0, 2);
      _part2 = _bTime.substring(3, 5);
      _bTime = _part1 + _part2;
      int _aIntTime = int.parse(_aTime);
      int _bIntTime = int.parse(_bTime);

      return _aIntTime.compareTo(_bIntTime);
    }
    return 0;
  });

  for(int i=0; i < _documents.length; i++){
    Event _event = new Event(_documents[i].documentID, _documents[i]['title'], _documents[i]['image'], _documents[i]['place'], _documents[i]['date'], _documents[i]['time'], _documents[i]['description'], _documents[i]['type']);
    _list.add(_event);
  }

  return _list;
}

Future<FirebaseUser> AdminLogin(String mail, String password, BuildContext context) async{

  FirebaseUser user;

  try{
    AuthResult result = await FirebaseAuth.instance.signInWithEmailAndPassword(email: mail, password: password);
    user = result.user;
  }catch(e){
    Navigator.of(context).pop();
    if(Platform.isAndroid){
      switch(e.code){
        case 'ERROR_WRONG_PASSWORD':
          showDialog(
              context: context,
              builder: (BuildContext context) => CustomDialog(
                description: "Los datos son incorrectos.",
                acceptButtonText: "Aceptar",
              )
          );
          break;
        case 'ERROR_USER_NOT_FOUND':
          showDialog(
              context: context,
              builder: (BuildContext context) => CustomDialog(
                description: "Los datos son incorrectos.",
                acceptButtonText: "Aceptar",
              )
          );
          break;
        case 'FirebaseException':
          showDialog(
              context: context,
              builder: (BuildContext context) => CustomDialog(
                description: "Hubo un problema con la conexión, inténtelo más tarde.",
                acceptButtonText: "Aceptar",
              )
          );
          break;
        default:
          showDialog(
              context: context,
              builder: (BuildContext context) => CustomDialog(
                description: "Hubo un problema con la conexión, inténtelo más tarde.",
                acceptButtonText: "Aceptar",
              )
          );
          break;
      }
    }
    if(Platform.isIOS){
      switch(e.code){
        case 'Error 17011':
          showDialog(
              context: context,
              builder: (BuildContext context) => CustomDialog(
                description: "Los datos son incorrectos.",
                acceptButtonText: "Aceptar",
              )
          );
          break;
        case 'Error 17009':
          showDialog(
              context: context,
              builder: (BuildContext context) => CustomDialog(
                description: "Los datos son incorrectos.",
                acceptButtonText: "Aceptar",
              )
          );
          break;
        case 'Error 17020':
          showDialog(
              context: context,
              builder: (BuildContext context) => CustomDialog(
                description: "Hubo un problema con la conexión, inténtelo más tarde.",
                acceptButtonText: "Aceptar",
              )
          );
          break;
        default:
          showDialog(
              context: context,
              builder: (BuildContext context) => CustomDialog(
                description: "Hubo un problema con la conexión, inténtelo más tarde.",
                acceptButtonText: "Aceptar",
              )
          );
          break;
      }
    }
  }

  return user;

}

Future<String> PickImage(Event event, BuildContext context) async {
  var image = await ImagePicker.pickImage(source: ImageSource.gallery);

  String finalURL;

  showDialog(
    context: context,
    builder: (BuildContext context) => CustomLoadDialog()
  );

  try{
    String imageName = randomAlphaNumeric(20);
    imageName = imageName + DateTime.now().toString();
    finalURL = await event.ChangeImage(image, imageName);
  }catch(Exception){
    showDialog(
      context: context,
      builder: (BuildContext context) => CustomDialog(
        description: "Hubo un problema con la conexión: " + Exception.toString(),
        acceptButtonText: "Aceptar",
      )
    );
  }finally{
    Navigator.of(context).pop();
  }

  return finalURL;
}

String BuildEventDayText(String formattedDate, int mode){
  String dateText;

  String year = formattedDate.substring(0, 4);
  String month = formattedDate.substring(5, 7);

  switch(month){
    case "01":
      month = "Enero";
      break;
    case "02":
      month = "Febrero";
      break;
    case "03":
      month = "Marzo";
      break;
    case "04":
      month = "Abril";
      break;
    case "05":
      month = "Mayo";
      break;
    case "06":
      month = "Junio";
      break;
    case "07":
      month = "Julio";
      break;
    case "08":
      month = "Agosto";
      break;
    case "09":
      month = "Septiembre";
      break;
    case "10":
      month = "Octubre";
      break;
    case "11":
      month = "Noviembre";
      break;
    case "12":
      month = "Diciembre";
      break;
    default:

      break;
  }

  if(mode == 0){
    String day = formattedDate.substring(8);
    dateText = day + " de " + month;
  }else{
    String day = formattedDate.substring(8);
    dateText = day + " / " + month + " / " + year;
  }

  return dateText;
}

String BuildEventTimeText(String unformattedTime){

  String formattedTime = unformattedTime.substring(11, 16);

  return formattedTime;

}

Future<File> getImageFileFromAssets(String path) async {
  final byteData = await rootBundle.load('assets/$path');

  final file = File('${(await getTemporaryDirectory()).path}/$path');
  await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

  return file;
}