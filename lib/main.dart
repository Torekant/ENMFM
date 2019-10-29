import 'package:flutter/material.dart';
import 'values.dart';
import 'dart:async';
import 'screens.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        // ... app-specific localization delegate[s] here
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('es'),
        const Locale('en')
      ],
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(title: 'ENMFM'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class SplashScreen extends StatefulWidget {
  SplashScreen({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _SplashScreen createState() => _SplashScreen();
}

class _SplashScreen extends State<SplashScreen> {

  static Values values = new Values();
  static Hues hue = new Hues();

  final FirebaseMessaging _messaging = FirebaseMessaging();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _messaging.getToken().then((token){
      print(token);
    });
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    Timer(Duration(seconds: values.defaultTimer), () {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomeScreen(),
              )
          );
    });
  }

  @override
  Widget build(BuildContext context) {

    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.

    double _screenWidth = MediaQuery.of(context).size.width; //lee el ancho de dispositivo
    //double _screenHeight = MediaQuery.of(context).size.height; //lee el largo del dispositivo
    double _symmetricPadding = values.defaultSymmetricPadding; //padding lateral de la pantalla

    _symmetricPadding =  _screenWidth * values.widthPaddingUnit; //Función que nos permite hacer un padding responsivo a cualquier resolución en ancho

    return Scaffold(
      appBar: AppBar(
        backgroundColor: hue.carmesi,
      ),
      backgroundColor: hue.background,
      body: new Container(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: _symmetricPadding / 1.5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: values.bigSizedBoxStandardHeight,
                child: Image.asset(
                  values.logoColored,
                  fit: BoxFit.contain,
                ),
              ),
            ],
          )
        ),
      )
    );
  }
}

