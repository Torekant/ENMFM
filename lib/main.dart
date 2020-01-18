import 'package:enmfm/announcements_screen.dart';
import 'package:enmfm/events_screen.dart';
import 'package:enmfm/login_screen.dart';
import 'package:enmfm/news_screen.dart';
import 'package:flutter/material.dart';
import 'values.dart';
import 'dart:async';
import 'menu_screens.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    Values _values = new Values();

    return MaterialApp(
      routes: <String, WidgetBuilder>{
        _values.routeNames['user_home']: (context) => HomeScreen(),
        _values.routeNames['login']: (context) => LoginScreen(),
        _values.routeNames['admin_home']: (context) => AdminScreen(),
        _values.routeNames['announcements']: (context) => AnnouncementsScreen(),
        _values.routeNames['events']: (context) => EventsScreen(),
        _values.routeNames['event_details']: (context) => EventDetailsScreen(),
        _values.routeNames['news']: (context) => NewsScreen(),
        _values.routeNames['new_details']: (context) => NewDetailsScreen()
      },
      localizationsDelegates: [
        // ... app-specific localization delegate[s] here
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('es', 'MX'),
        const Locale('en', 'US'),
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

  final String title;

  @override
  _SplashScreen createState() => _SplashScreen();
}

class _SplashScreen extends State<SplashScreen> {

  static Values _values;
  static Hues hue;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _values = new Values();
    hue  = new Hues();

    //Inicio de timer para esperar a pasar a la pantalla principal
    Timer(Duration(seconds: _values.defaultTimer), () {
      Navigator.pushReplacementNamed(
        context,
        _values.routeNames['user_home'],
      );
    });
  }

  @override
  Widget build(BuildContext context) {

    double _screenWidth = MediaQuery.of(context).size.width; //Ancho de pantalla

    return Scaffold(
        appBar: AppBar(
          backgroundColor: hue.carmesi,
        ),
        backgroundColor: hue.background,
        body: Center(
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: _screenWidth / 10),
            child: Image.asset(
              _values.logoColored,
              fit: BoxFit.contain,
            ),
          ),
        )
    );
  }
}

