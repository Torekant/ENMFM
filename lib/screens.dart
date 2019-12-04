import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'values.dart';
import 'dart:async';
import 'classes.dart';
import 'package:flutter_parallax/flutter_parallax.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'functions.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".


  @override
  _HomeScreen createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen>{

  static Values _values;
  static Hues _hue;

  ScrollController _scrollController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _values  = new Values();
    _hue = new Hues();
    _scrollController = ScrollController();

  }

  @override
  Widget build(BuildContext context) {

    double _screenHeight = MediaQuery.of(context).size.height; //lee el largo del dispositivo

    double _responsiveHeight = _screenHeight / _values.defaultDivisionForResponsiveHeight; //Función para altura responsiva de cada card en la lista


    return OrientationBuilder(
      builder: (context, orientation){
        return orientation == Orientation.portrait
            ?
        Scaffold(
            appBar: AppBar(
              backgroundColor: _hue.carmesi,
              title: Text("Inicio"),
              actions: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.assignment_ind,
                    size: _values.toolbarIconSize,
                  ),
                  tooltip: 'Administrar',
                  onPressed: (){
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginScreen(),
                        )
                    );
                  },
                ),
                Container(
                  width: _values.containerWidth,
                )
              ],
            ),
            body: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Expanded(
                  child: Column(
                    children: <Widget>[
                      ListView.builder(
                          controller: _scrollController,
                          shrinkWrap: true,
                          itemCount: _values.menuOptions.length,
                          itemBuilder: (BuildContext context, int index){
                            return GestureDetector(
                              child: Card(
                                elevation: _values.cardElevation,
                                child: Container(
                                  height: _responsiveHeight / 5,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        _values.menuOptions[index],
                                        style: _values.titleTextStyle,
                                      ),
                                      Icon(Icons.arrow_forward_ios)
                                    ],
                                  ),
                                ),
                              ),
                              onTap: (){
                                switch(index){
                                  case 0:
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ScheduleScreen()
                                        )
                                    );
                                    break;
                                  case 1:
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => AgendaScreen()
                                        )
                                    );
                                    break;
                                  case 2:
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => AdministrationScreen()
                                        )
                                    );
                                    break;
                                  case 3:
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => GradesScreen()
                                        )
                                    );
                                    break;
                                  case 4:
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => AnnouncementsScreen(adminView: false,)
                                        )
                                    );
                                    break;
                                  case 5:
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => EventsScreen(adminView: false,)
                                        )
                                    );
                                    break;
                                  case 6:
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => NewsScreen(adminView: false,)
                                        )
                                    );
                                    break;
                                }
                              },
                            );
                          }
                      ),
                      SizedBox(height: _responsiveHeight / 10,),
                      FlatButton(
                        textColor: _hue.carmesi,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Ir a página web",
                              style: _values.launcherFlatButtonTextStyle,
                            ),
                            Icon(
                              Icons.launch,
                              color: _hue.carmesi,
                            )
                          ],
                        ),
                        onPressed: (){
                          LaunchURL(_values.urlWebPage);
                        },
                      )
                    ],
                  ),
                )
              ],
            )
        )
            :
        Scaffold(
            appBar: AppBar(
              backgroundColor: _hue.carmesi,
              title: Text("Inicio"),
              actions: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.assignment_ind,
                    size: _values.toolbarIconSize,
                  ),
                  tooltip: 'Administrar',
                  onPressed: (){
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginScreen(),
                        )
                    );
                  },
                ),
                Container(
                  width: _values.containerWidth,
                )
              ],
            ),
            body: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      ListView.builder(
                          controller: _scrollController,
                          shrinkWrap: true,
                          itemCount: _values.menuOptions.length,
                          itemBuilder: (BuildContext context, int index){
                            return GestureDetector(
                              child: Card(
                                elevation: _values.cardElevation,
                                child: Container(
                                  height: _responsiveHeight / 2.5,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        _values.menuOptions[index],
                                        style: _values.titleTextStyle,
                                      ),
                                      Icon(Icons.arrow_forward_ios)
                                    ],
                                  ),
                                ),
                              ),
                              onTap: (){
                                switch(index){
                                  case 0:
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ScheduleScreen()
                                        )
                                    );
                                    break;
                                  case 1:
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => AgendaScreen()
                                        )
                                    );
                                    break;
                                  case 2:
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => AdministrationScreen()
                                        )
                                    );
                                    break;
                                  case 3:
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => GradesScreen()
                                        )
                                    );
                                    break;
                                  case 4:
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => AnnouncementsScreen(adminView: false,)
                                        )
                                    );
                                    break;
                                  case 5:
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => EventsScreen(adminView: false,)
                                        )
                                    );
                                    break;
                                  case 6:
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => NewsScreen(adminView: false,)
                                        )
                                    );
                                    break;
                                }
                              },
                            );
                          }
                      ),
                      SizedBox(height: _responsiveHeight / 10,),
                      FlatButton(
                        textColor: _hue.carmesi,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Ir a página web",
                              style: _values.launcherFlatButtonTextStyle,
                            ),
                            Icon(
                              Icons.launch,
                              color: _hue.carmesi,
                            )
                          ],
                        ),
                        onPressed: (){
                          LaunchURL(_values.urlWebPage);
                        },
                      )
                    ],
                  )
                ],
              ),
            )
        );
      },
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _scrollController.dispose();
    super.dispose();
  }

}

class ScheduleScreen extends StatefulWidget {
  ScheduleScreen({Key key}) : super(key: key);

  @override
  _ScheduleScreen createState() => _ScheduleScreen();
}

class _ScheduleScreen extends State<ScheduleScreen>{

  static Values _values;
  static Hues _hue;
  ScrollController _scrollController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _values = new Values();
    _hue = new Hues();
    _scrollController = new ScrollController();
  }

  @override
  Widget build(BuildContext context) {

    double _screenWidth = MediaQuery.of(context).size.width; //lee el ancho de dispositivo
    double _screenHeight = MediaQuery.of(context).size.height; //lee el largo del dispositivo
    //double _symmetricPadding; //padding lateral de la pantalla

    //_symmetricPadding =  (_screenWidth * values.widthPaddingUnit) / 10; //Función que nos permite hacer un padding responsivo a cualquier resolución en ancho
    double _responsiveHeight = _screenHeight / _values.defaultDivisionForResponsiveHeight; //Función para altura responsiva de cada card en la lista
    double _responsiveWidth = _screenWidth / _values.defaultDivisionForResponsiveWidth; //Función para altura responsiva de cada card en la lista

    return OrientationBuilder(
      builder: (context, orientation){
        return orientation == Orientation.portrait
            ?
        Scaffold(
          backgroundColor: _hue.background,
          appBar: AppBar(
            backgroundColor: _hue.carmesi,
            title: Text("Horario"),
          ),
          body: SingleChildScrollView(
            controller: _scrollController,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Text(
                      "Nuestros expertos en tecnología están trabajando muy duro para que está sección esté activa.",
                      style: _values.titleTextStyle,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Image.asset(
                    _values.screenOnWork,
                    height: _responsiveHeight / 1.5,
                    width: _responsiveWidth * 1.5,
                    fit: BoxFit.fill,
                  )
                ],
              ),
            ),
          ),
        )
            :
        Scaffold(
          backgroundColor: _hue.background,
          appBar: AppBar(
            backgroundColor: _hue.carmesi,
            title: Text("Horario"),
          ),
          body: SingleChildScrollView(
            controller: _scrollController,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    child: Text(
                      "Nuestros expertos en tecnología están trabajando muy duro para que está sección esté activa.",
                      style: _values.titleTextStyle,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Image.asset(
                    _values.screenOnWork,
                    height: _responsiveHeight * 1.5,
                    width: _responsiveWidth,
                    fit: BoxFit.fill,
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _scrollController.dispose();
    super.dispose();
  }
}

class AgendaScreen extends StatefulWidget {
  AgendaScreen({Key key}) : super(key: key);

  @override
  _AgendaScreen createState() => _AgendaScreen();
}

class _AgendaScreen extends State<AgendaScreen>{

  static Values _values;
  static Hues _hue;
  ScrollController _scrollController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _values = new Values();
    _hue = new Hues();
    _scrollController = new ScrollController();
  }

  @override
  Widget build(BuildContext context) {

    double _screenWidth = MediaQuery.of(context).size.width; //lee el ancho de dispositivo
    double _screenHeight = MediaQuery.of(context).size.height; //lee el largo del dispositivo
    //double _symmetricPadding; //padding lateral de la pantalla

    //_symmetricPadding =  (_screenWidth * values.widthPaddingUnit) / 10; //Función que nos permite hacer un padding responsivo a cualquier resolución en ancho
    double _responsiveHeight = _screenHeight / _values.defaultDivisionForResponsiveHeight; //Función para altura responsiva de cada card en la lista
    double _responsiveWidth = _screenWidth / _values.defaultDivisionForResponsiveWidth; //Función para altura responsiva de cada card en la lista

    return OrientationBuilder(
      builder: (context, orientation){
        return orientation == Orientation.portrait
            ?
        Scaffold(
          backgroundColor: _hue.background,
          appBar: AppBar(
            backgroundColor: _hue.carmesi,
            title: Text("Agenda"),
          ),
          body: SingleChildScrollView(
            controller: _scrollController,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Text(
                      "Nuestros expertos en tecnología están trabajando muy duro para que está sección esté activa.",
                      style: _values.titleTextStyle,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Image.asset(
                    _values.screenOnWork,
                    height: _responsiveHeight / 1.5,
                    width: _responsiveWidth * 1.5,
                    fit: BoxFit.fill,
                  )
                ],
              ),
            ),
          ),
        )
            :
        Scaffold(
          backgroundColor: _hue.background,
          appBar: AppBar(
            backgroundColor: _hue.carmesi,
            title: Text("Agenda"),
          ),
          body: SingleChildScrollView(
            controller: _scrollController,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    child: Text(
                      "Nuestros expertos en tecnología están trabajando muy duro para que está sección esté activa.",
                      style: _values.titleTextStyle,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Image.asset(
                    _values.screenOnWork,
                    height: _responsiveHeight * 1.5,
                    width: _responsiveWidth,
                    fit: BoxFit.fill,
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _scrollController.dispose();
    super.dispose();
  }
}

class AdministrationScreen extends StatefulWidget {
  AdministrationScreen({Key key}) : super(key: key);

  @override
  _AdministrationScreen createState() => _AdministrationScreen();
}

class _AdministrationScreen extends State<AdministrationScreen>{

  static Values _values;
  static Hues _hue;
  ScrollController _scrollController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _values = new Values();
    _hue = new Hues();
    _scrollController = new ScrollController();
  }

  @override
  Widget build(BuildContext context) {

    double _screenWidth = MediaQuery.of(context).size.width; //lee el ancho de dispositivo
    double _screenHeight = MediaQuery.of(context).size.height; //lee el largo del dispositivo
    //double _symmetricPadding; //padding lateral de la pantalla

    //_symmetricPadding =  (_screenWidth * values.widthPaddingUnit) / 10; //Función que nos permite hacer un padding responsivo a cualquier resolución en ancho
    double _responsiveHeight = _screenHeight / _values.defaultDivisionForResponsiveHeight; //Función para altura responsiva de cada card en la lista
    double _responsiveWidth = _screenWidth / _values.defaultDivisionForResponsiveWidth; //Función para altura responsiva de cada card en la lista

    return OrientationBuilder(
      builder: (context, orientation){
        return orientation == Orientation.portrait
            ?
        Scaffold(
          backgroundColor: _hue.background,
          appBar: AppBar(
            backgroundColor: _hue.carmesi,
            title: Text("Administración"),
          ),
          body: SingleChildScrollView(
            controller: _scrollController,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Text(
                      "Nuestros expertos en tecnología están trabajando muy duro para que está sección esté activa.",
                      style: _values.titleTextStyle,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Image.asset(
                    _values.screenOnWork,
                    height: _responsiveHeight / 1.5,
                    width: _responsiveWidth * 1.5,
                    fit: BoxFit.fill,
                  )
                ],
              ),
            ),
          ),
        )
            :
        Scaffold(
          backgroundColor: _hue.background,
          appBar: AppBar(
            backgroundColor: _hue.carmesi,
            title: Text("Administración"),
          ),
          body: SingleChildScrollView(
            controller: _scrollController,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    child: Text(
                      "Nuestros expertos en tecnología están trabajando muy duro para que está sección esté activa.",
                      style: _values.titleTextStyle,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Image.asset(
                    _values.screenOnWork,
                    height: _responsiveHeight * 1.5,
                    width: _responsiveWidth,
                    fit: BoxFit.fill,
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _scrollController.dispose();
    super.dispose();
  }
}

class GradesScreen extends StatefulWidget {
  GradesScreen({Key key}) : super(key: key);

  @override
  _GradesScreen createState() => _GradesScreen();
}

class _GradesScreen extends State<GradesScreen>{

  static Values _values;
  static Hues _hue;
  ScrollController _scrollController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _values = new Values();
    _hue = new Hues();
    _scrollController = new ScrollController();
  }

  @override
  Widget build(BuildContext context) {

    double _screenWidth = MediaQuery.of(context).size.width; //lee el ancho de dispositivo
    double _screenHeight = MediaQuery.of(context).size.height; //lee el largo del dispositivo
    //double _symmetricPadding; //padding lateral de la pantalla

    //_symmetricPadding =  (_screenWidth * values.widthPaddingUnit) / 10; //Función que nos permite hacer un padding responsivo a cualquier resolución en ancho
    double _responsiveHeight = _screenHeight / _values.defaultDivisionForResponsiveHeight; //Función para altura responsiva de cada card en la lista
    double _responsiveWidth = _screenWidth / _values.defaultDivisionForResponsiveWidth; //Función para altura responsiva de cada card en la lista

    return OrientationBuilder(
      builder: (context, orientation){
        return orientation == Orientation.portrait
            ?
        Scaffold(
          backgroundColor: _hue.background,
          appBar: AppBar(
            backgroundColor: _hue.carmesi,
            title: Text("Calificaciones"),
          ),
          body: SingleChildScrollView(
            controller: _scrollController,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Text(
                      "Nuestros expertos en tecnología están trabajando muy duro para que está sección esté activa.",
                      style: _values.titleTextStyle,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Image.asset(
                    _values.screenOnWork,
                    height: _responsiveHeight / 1.5,
                    width: _responsiveWidth * 1.5,
                    fit: BoxFit.fill,
                  )
                ],
              ),
            ),
          ),
        )
            :
        Scaffold(
          backgroundColor: _hue.background,
          appBar: AppBar(
            backgroundColor: _hue.carmesi,
            title: Text("Calificaciones"),
          ),
          body: SingleChildScrollView(
            controller: _scrollController,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    child: Text(
                      "Nuestros expertos en tecnología están trabajando muy duro para que está sección esté activa.",
                      style: _values.titleTextStyle,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Image.asset(
                    _values.screenOnWork,
                    height: _responsiveHeight * 1.5,
                    width: _responsiveWidth,
                    fit: BoxFit.fill,
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _scrollController.dispose();
    super.dispose();
  }
}

class AnnouncementsScreen extends StatefulWidget {
  AnnouncementsScreen({Key key, this.adminView}) : super(key: key);

  final bool adminView;

  @override
  _AnnouncementsScreen createState() => _AnnouncementsScreen();
}

class _AnnouncementsScreen extends State<AnnouncementsScreen>{

  static Values _values;
  static Hues _hue;
  ScrollController _scrollController;

  FloatingActionButton _floatingActionButton;
  Offset _position;

  Widget _screenPortraitContent, _screenLandscapeContent;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _values = new Values();
    _hue = new Hues();
    _scrollController = new ScrollController();
    _screenPortraitContent = Center(
      child: Image.asset(
          _values.loadingAnimation
      ),
    );
    _screenLandscapeContent = Center(
      child: Image.asset(
          _values.loadingAnimation
      ),
    );

    if(widget.adminView == true){
      _floatingActionButton = FloatingActionButton(
        tooltip: "Crear aviso",
        backgroundColor: _hue.ocean,
        child: Icon(Icons.add),
        onPressed: (){
          showDialog(
              context: context,
              builder: (BuildContext context) => CustomFormDialog(
                description: "Escriba el nuevo aviso.",
                acceptButtonText: "Publicar",
                cancelButtonText: "Cancelar",
                dialogPurpose: _values.dialogPurposes["Crear aviso"],
              )
          ).then((result){
            if(result != false){
              showDialog(
                  context: context,
                  builder: (BuildContext context) => CustomLoadDialog()
              );
              CreateAnnouncement(context, result).then((result){
                Navigator.pop(context);
                  showDialog(
                      context: context,
                      builder: (BuildContext context) => CustomDialog(
                        description: "El aviso de ha publicado con éxito.",
                        acceptButtonText: "Genial",
                      )
                  );
              });
            }
          });
        },
      );
    }else{
      _position = Offset(0.0, 0.0);
      _floatingActionButton = null;
    }
  }

  @override
  void didChangeDependencies() async{
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    double _screenWidth = MediaQuery.of(context).size.width; //lee el ancho de dispositivo
    double _screenHeight = MediaQuery.of(context).size.height; //lee el largo del dispositivo

    double _responsivePadding = _screenWidth / _values.defaultSymmetricPadding; //lee el ancho de dispositivo

    if(widget.adminView == true){
      _position = Offset(_screenWidth / 1.2, _screenHeight / 1.2);
    }

    await RetrieveAnnouncements(context).then((list){
      if(list.isNotEmpty){
        setState(() {
          _screenPortraitContent = ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: _responsivePadding),
            controller: _scrollController,
            shrinkWrap: true,
            itemCount: list.length,
            itemBuilder: (BuildContext context, int index){
              DateFormat df = new DateFormat('dd-MM-yyyy');
              String _announcementDate = df.format(list[index].timestamp);
              return GestureDetector(
                child: Card(
                  elevation: _values.cardElevation,
                  child: Container(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          controller: _scrollController,
                          child: Text(
                            _announcementDate,
                            style: _values.subtitleTextStyle,
                          ),
                        ),
                        Container(
                          color: _hue.carmesi,
                          height: _values.lineSizedBoxHeight,
                        ),
                        Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(horizontal: _responsivePadding),
                          child: Text(
                            list[index].text,
                            style: _values.subtitleTextStyle,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            }
          );
          _screenLandscapeContent = ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: _responsivePadding),
              controller: _scrollController,
              shrinkWrap: true,
              itemCount: list.length,
              itemBuilder: (BuildContext context, int index){
                return GestureDetector(
                  child: Card(
                    elevation: _values.cardElevation,
                    child: Container(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            controller: _scrollController,
                            child: Text(
                              list[index].timestamp.toString(),
                              style: _values.subtitleTextStyle,
                            ),
                          ),
                          SizedBox(
                            height: _values.smallSizedBoxStandardHeight,
                          ),
                          Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(horizontal: _responsivePadding),
                            child: Text(
                              list[index].text,
                              style: _values.subtitleTextStyle,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              }
          );
        });
      }else{
        setState(() {
          _screenPortraitContent = Center(
            child: Image.asset(
                _values.noContentFound
            ),
          );
          _screenLandscapeContent = Center(
            child: Image.asset(
                _values.noContentFound
            ),
          );
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    return OrientationBuilder(
      builder: (context, orientation){
        return orientation == Orientation.portrait
            ?
        Scaffold(
          backgroundColor: _hue.background,
          appBar: AppBar(
            backgroundColor: _hue.carmesi,
            title: Text("Avisos"),
          ),
          body: _screenPortraitContent,
          floatingActionButton: Stack(
            children: <Widget>[
              Positioned(
                left: _position.dx,
                top:  _position.dy,
                child: Draggable(
                  feedback: Container(
                    child: _floatingActionButton,
                  ),
                  child: Container(
                    child: _floatingActionButton,
                  ),
                  childWhenDragging: Container(),
                  onDragEnd: (details){
                    setState(() {
                      _position = details.offset;
                    });
                  },
                ),
              )
            ],
          ),
        )
            :
        Scaffold(
          backgroundColor: _hue.background,
          appBar: AppBar(
            backgroundColor: _hue.carmesi,
            title: Text("Avisos"),
          ),
          body: _screenLandscapeContent,
          floatingActionButton: Stack(
            children: <Widget>[
              Positioned(
                left: _position.dx,
                top:  _position.dy,
                child: Draggable(
                  feedback: Container(
                    child: _floatingActionButton,
                  ),
                  child: Container(
                    child: _floatingActionButton,
                  ),
                  childWhenDragging: Container(),
                  onDragEnd: (details){
                    setState(() {
                      _position = details.offset;
                    });
                  },
                ),
              )
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _scrollController.dispose();
    super.dispose();
  }
}

class EventsScreen extends StatefulWidget {
  EventsScreen({Key key, this.adminView}) : super(key: key);

  final bool adminView;


  @override
  _EventsScreen createState() => _EventsScreen();
}

class _EventsScreen extends State<EventsScreen>{

  static Values _values;
  static Hues _hue;

  ScrollController _scrollController;
  Widget _screenPortraitContent, _screenLandscapeContent;

  CalendarController _calendarController;
  Map<DateTime, List<Event>> _calendarEvents;
  ListView _eventListView;

  FloatingActionButton _floatingActionButton;
  Offset _position;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _values  = new Values();
    _hue = new Hues();
    _scrollController = new ScrollController();

    if(widget.adminView == true){
      _calendarController = CalendarController();
      _calendarEvents = Map();
      _eventListView = ListView(shrinkWrap: true,);
      _floatingActionButton = FloatingActionButton(
        tooltip: "Crear evento",
        backgroundColor: _hue.ocean,
        child: Icon(Icons.add),
        onPressed: (){
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EventDetailsScreen(event: new Event(null, null, null, null, null, null, null, null), adminView: true, newEventDateTime: _calendarController.selectedDay,),
              )
          );
        },
      );
    }else{
      _screenPortraitContent = Center(
        child: Image.asset(
            _values.loadingAnimation
        ),
      );
      _screenLandscapeContent = Center(
        child: Image.asset(
            _values.loadingAnimation
        ),
      );
      _floatingActionButton = null;
      _position = Offset(0.0, 0.0);
    }

  }

  @override
  void didChangeDependencies() async{
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    double _screenHeight = MediaQuery.of(context).size.height; //lee el largo del dispositivo
    double _screenWidth = MediaQuery.of(context).size.width; //lee el ancho de dispositivo

    double _responsiveHeight = _screenHeight / _values.defaultDivisionForResponsiveHeight; //Función para altura responsiva de cada card en la lista

    if(widget.adminView == true){
      _position = Offset(_screenWidth / 1.2, _screenHeight / 1.2);

      await RetrieveCalendarEvents(context).then((map) {
        if (!map.containsKey(null)) {
          setState(() {
            _calendarEvents = map;

            DateFormat df = new DateFormat('yyyy-MM-dd');
            String _todaysDate = df.format(DateTime.now());
            if (_calendarEvents.containsKey(DateTime.parse(_todaysDate))) {
              _calendarEvents.forEach((dateTime, eventList) {
                if (dateTime == DateTime.parse(_todaysDate)) {
                  eventList.sort((a, b) => a.time.compareTo(b.time));

                  _eventListView = ListView.builder(
                      scrollDirection: Axis.vertical,
                      controller: _scrollController,
                      shrinkWrap: true,
                      itemCount: eventList.length,
                      itemBuilder: (context, index) {
                        Event ds = eventList[index];

                        Icon _eventIcon;

                        switch (ds.type) {
                          case 'ceremonia':
                            _eventIcon = new Icon(
                                Icons.event,
                                size: _values.toolbarIconSize,
                                color: _hue.outlines
                            );
                            break;
                          case 'exámen':
                            _eventIcon = new Icon(
                                Icons.description,
                                size: _values.toolbarIconSize,
                                color: _hue.outlines
                            );
                            break;
                          case 'entrega':
                            _eventIcon = new Icon(
                                Icons.assignment_turned_in,
                                size: _values.toolbarIconSize,
                                color: _hue.outlines
                            );
                            break;
                          default:
                            _eventIcon = new Icon(
                                Icons.event,
                                size: _values.toolbarIconSize,
                                color: _hue.outlines
                            );
                            break;
                        }

                        return new Container(
                          color: _hue.outlines,
                          padding: EdgeInsets.fromLTRB(0.0, 3.0, 0.0, 0.0),
                          child: Container(
                            color: _hue.background,
                            child: ListTile(
                              title: Container(
                                alignment: Alignment.centerLeft,
                                child: Text(ds.title),
                              ),
                              subtitle: Container(
                                alignment: Alignment.centerLeft,
                                child: Text(ds.type + ' - ' + ds.time + 'hrs.'),
                              ),
                              trailing: _eventIcon,
                              onTap: () {
                                if (ds.type == _values.eventType['ceremony']) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              EventDetailsScreen(
                                                event: ds, adminView: true,)
                                      )
                                  );
                                }
                              },
                            ),
                          ),
                        );
                      }
                  );
                }
              });
            }
          });
        }
      });

    }else{
      RetrieveListEvents(context).then((list){
        if(list.isNotEmpty){
          setState(() {
            _screenPortraitContent = Center(
              child: ListView.builder(
                  controller: _scrollController,
                  shrinkWrap: true,
                  itemCount: list.length,
                  itemBuilder: (BuildContext context, int index){
                    String _dateText = BuildEventDayText(list[index].date, 0);
                    return GestureDetector(
                      child: Card(
                        child: Container(
                          //height: _responsiveHeight * 1,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Parallax.inside(
                                  child: CachedNetworkImage(
                                    width: double.maxFinite,
                                    height: _responsiveHeight * 1,
                                    fit: BoxFit.cover,
                                    imageUrl: list[index].image,
                                    placeholder: (context, url) => Image.asset(_values.loadingAnimation, fit: BoxFit.fill, width: double.maxFinite, height: _responsiveHeight,),
                                    errorWidget: (context,url,error) => new Center(
                                      child: Icon(Icons.error),
                                    ),
                                  ),
                                  mainAxisExtent: _responsiveHeight / 1
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Text(
                                    _dateText + " a las " + list[index].time + "hrs.",
                                    style: _values.subtitleTextStyle,
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      onTap: (){
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EventDetailsScreen(event: list[index], adminView: false,)
                            )
                        );
                      },
                    );
                  }
              ),
            );
            _screenLandscapeContent = Center(
              child: ListView.builder(
                  controller: _scrollController,
                  shrinkWrap: true,
                  itemCount: list.length,
                  itemBuilder: (BuildContext context, int index){
                    String _dateText = BuildEventDayText(list[index].date, 0);
                    return GestureDetector(
                      child: Card(
                        child: Container(
                          //height: _responsiveHeight * 1,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Parallax.inside(
                                  child: CachedNetworkImage(
                                    width: double.maxFinite,
                                    height: _responsiveHeight * 1,
                                    fit: BoxFit.cover,
                                    imageUrl: list[index].image,
                                    placeholder: (context, url) => Image.asset(_values.loadingAnimation, fit: BoxFit.fill, width: double.maxFinite, height: _responsiveHeight,),
                                    errorWidget: (context,url,error) => new Center(
                                      child: Icon(Icons.error),
                                    ),
                                  ),
                                  mainAxisExtent: _responsiveHeight / 1
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Text(
                                    _dateText + " a las " + list[index].time + "hrs.",
                                    style: _values.subtitleTextStyle,
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      onTap: (){
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EventDetailsScreen(event: list[index], adminView: false,)
                            )
                        );
                      },
                    );
                  }
              ),
            );
          });
        }else{
          setState(() {
            _screenPortraitContent = Center(
              child: Image.asset(
                  _values.noContentFound
              ),
            );
            _screenLandscapeContent = Center(
              child: Image.asset(
                  _values.noContentFound
              ),
            );
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    if(widget.adminView == true){
      _screenPortraitContent = Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TableCalendar(
            startingDayOfWeek: StartingDayOfWeek.monday,
            initialCalendarFormat: CalendarFormat.month,
            formatAnimation: FormatAnimation.scale,
            calendarController: _calendarController,
            locale: 'es',
            initialSelectedDay: DateTime.now(),
            calendarStyle: CalendarStyle(
              canEventMarkersOverflow: false,
              markersAlignment: Alignment.bottomCenter,
              markersColor: _hue.carmesi,
              markersMaxAmount: 5,
              outsideDaysVisible: true,
              todayColor: _hue.ocean,
              weekdayStyle: _values.calendarDayTextStyle,
              weekendStyle: _values.calendarWeekendDayTextStyle,
            ),
            headerStyle: HeaderStyle(
                centerHeaderTitle: true,
                formatButtonShowsNext: false,
                titleTextStyle: _values.contentTextStyle,
                formatButtonVisible: false
            ),
            onDaySelected: (day, events){
              events.sort((a, b) => a.time.compareTo(b.time));
              setState(() {
                _eventListView = ListView.builder(
                    scrollDirection: Axis.vertical,
                    controller: _scrollController,
                    shrinkWrap: true,
                    itemCount: events.length,
                    itemBuilder: (context, index){
                      Event ds = events[index];

                      Icon _eventIcon;

                      switch(ds.type){
                        case 'ceremonia':
                          _eventIcon = new Icon(
                              Icons.event,
                              size: _values.toolbarIconSize,
                              color: _hue.outlines
                          );
                          break;
                        case 'exámen':
                          _eventIcon = new Icon(
                              Icons.description,
                              size: _values.toolbarIconSize,
                              color: _hue.outlines
                          );
                          break;
                        case 'entrega':
                          _eventIcon = new Icon(
                              Icons.assignment_turned_in,
                              size: _values.toolbarIconSize,
                              color: _hue.outlines
                          );
                          break;
                        default:
                          _eventIcon = new Icon(
                              Icons.event,
                              size: _values.toolbarIconSize,
                              color: _hue.outlines
                          );
                          break;
                      }

                      return new Container(
                        color: _hue.outlines,
                        padding: EdgeInsets.fromLTRB(0.0, 3.0, 0.0, 0.0),
                        child: Container(
                          color: _hue.background,
                          child: ListTile(
                            title: Container(
                              alignment: Alignment.centerLeft,
                              child: Text(ds.title),
                            ),
                            subtitle: Container(
                              alignment: Alignment.centerLeft,
                              child: Text(ds.type + ' - ' + ds.time + 'hrs.'),
                            ),
                            trailing: _eventIcon,
                            onTap: (){
                              if(ds.type == _values.eventType['ceremony']){
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => EventDetailsScreen(event: ds, adminView: true,)
                                    )
                                );
                              }
                            },
                          ),
                        ),
                      );
                    }
                );
              });
            },
            events: _calendarEvents,
          ),
          SizedBox(height: _values.mediumSizedBoxStandardHeight,),
          Expanded(child: _eventListView,),
        ],
      );
      _screenLandscapeContent = SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TableCalendar(
              startingDayOfWeek: StartingDayOfWeek.monday,
              initialCalendarFormat: CalendarFormat.week,
              formatAnimation: FormatAnimation.scale,
              calendarController: _calendarController,
              locale: 'es',
              initialSelectedDay: DateTime.now(),
              calendarStyle: CalendarStyle(
                canEventMarkersOverflow: false,
                markersAlignment: Alignment.bottomCenter,
                markersColor: _hue.carmesi,
                markersMaxAmount: 5,
                outsideDaysVisible: true,
                todayColor: _hue.ocean,
                weekdayStyle: _values.calendarDayTextStyle,
                weekendStyle: _values.calendarWeekendDayTextStyle,
              ),
              headerStyle: HeaderStyle(
                  centerHeaderTitle: true,
                  formatButtonShowsNext: false,
                  titleTextStyle: _values.contentTextStyle,
                  formatButtonVisible: false
              ),
              onDaySelected: (day, events){
                events.sort((a, b) => a.time.compareTo(b.time));
                setState(() {
                  _eventListView = ListView.builder(
                      scrollDirection: Axis.vertical,
                      controller: _scrollController,
                      shrinkWrap: true,
                      itemCount: events.length,
                      itemBuilder: (context, index){
                        Event ds = events[index];

                        Icon _eventIcon;

                        switch(ds.type){
                          case 'ceremonia':
                            _eventIcon = new Icon(
                                Icons.event,
                                size: _values.toolbarIconSize,
                                color: _hue.outlines
                            );
                            break;
                          case 'exámen':
                            _eventIcon = new Icon(
                                Icons.description,
                                size: _values.toolbarIconSize,
                                color: _hue.outlines
                            );
                            break;
                          case 'entrega':
                            _eventIcon = new Icon(
                                Icons.assignment_turned_in,
                                size: _values.toolbarIconSize,
                                color: _hue.outlines
                            );
                            break;
                          default:
                            _eventIcon = new Icon(
                                Icons.event,
                                size: _values.toolbarIconSize,
                                color: _hue.outlines
                            );
                            break;
                        }

                        return new Container(
                          color: _hue.outlines,
                          padding: EdgeInsets.fromLTRB(0.0, 3.0, 0.0, 0.0),
                          child: Container(
                            color: _hue.background,
                            child: ListTile(
                              title: Container(
                                alignment: Alignment.centerLeft,
                                child: Text(ds.title),
                              ),
                              subtitle: Container(
                                alignment: Alignment.centerLeft,
                                child: Text(ds.type + ' - ' + ds.time + 'hrs.'),
                              ),
                              trailing: _eventIcon,
                              onTap: (){
                                if(ds.type == _values.eventType['ceremony']){
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => EventDetailsScreen(event: ds, adminView: true,)
                                      )
                                  );
                                }
                              },
                            ),
                          ),
                        );
                      }
                  );
                });
              },
              events: _calendarEvents,
            ),
            SizedBox(height: _values.mediumSizedBoxStandardHeight,),
            _eventListView,
          ],
        ),
      );
    }

    return OrientationBuilder(
      builder: (context, orientation){
        return orientation == Orientation.portrait
            ?
        Scaffold(
          appBar: AppBar(
              backgroundColor: _hue.carmesi,
              title: Text("Eventos"),
              actions: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.assignment_ind,
                    size: _values.toolbarIconSize,
                  ),
                  tooltip: 'Administrar',
                  onPressed: (){
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginScreen(),
                        )
                    );
                  },
                ),
                Container(
                  width: _values.containerWidth,
                )
              ],
            ),
          body: _screenPortraitContent,
          floatingActionButton: Stack(
            children: <Widget>[
              Positioned(
                left: _position.dx,
                top:  _position.dy,
                child: Draggable(
                  feedback: Container(
                    child: _floatingActionButton,
                  ),
                  child: Container(
                    child: _floatingActionButton,
                  ),
                  childWhenDragging: Container(),
                  onDragEnd: (details){
                    setState(() {
                      _position = details.offset;
                    });
                  },
                ),
              )
            ],
          ),
        )
            :
        Scaffold(
          appBar: AppBar(
              backgroundColor: _hue.carmesi,
              title: Text("Eventos"),
              actions: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.assignment_ind,
                    size: _values.toolbarIconSize,
                  ),
                  tooltip: 'Administrar',
                  onPressed: (){
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginScreen(),
                        )
                    );
                  },
                ),
                Container(
                  width: _values.containerWidth,
                )
              ],
            ),
          body: _screenLandscapeContent
        );
      },
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    if(widget.adminView == true){
      _calendarController.dispose();
    }
    super.dispose();
  }

}

class EventDetailsScreen extends StatefulWidget {
  EventDetailsScreen({Key key, this.event, this.adminView, this.newEventDateTime}) : super(key: key);

  final Event event;
  final bool adminView;
  final DateTime newEventDateTime;

  @override
  _EventDetailsScreen createState() => _EventDetailsScreen();
}

class _EventDetailsScreen extends State<EventDetailsScreen>{

  static Values _values;
  static Hues _hue;

  ScrollController _scrollController;
  String _spanishFormattedText;
  Widget _floatingButton, _imageWidget;
  Offset _position;
  var _imageNewEvent, _passedDependencies;
  var _formKey;
  Widget _widgetPortraitColumn, _widgetLandscapeColumn;

  @override
  void initState() {
    super.initState();
    _values = new Values();
    _hue = new Hues();
    _scrollController = new ScrollController();
    _position = Offset(20.0, 20.0);
    _passedDependencies = false;
    _formKey = GlobalKey<FormState>();

    if(widget.event.id == null){
      widget.event.title = "";
      widget.event.place = "";
      widget.event.description = "";
      widget.event.time = "00:00";
      DateFormat df = new DateFormat('yyyy-MM-dd');
      widget.event.date = df.format(widget.newEventDateTime);
      _spanishFormattedText = BuildEventDayText(df.format(widget.newEventDateTime), 1);
    }else{
      _spanishFormattedText = BuildEventDayText(widget.event.date, 1);
    }
  }

  @override
  void didChangeDependencies() async{
    super.didChangeDependencies();

    double _screenWidth = MediaQuery.of(context).size.width; //lee el ancho de dispositivo
    double _screenHeight = MediaQuery.of(context).size.height; //lee el largo del dispositivo

    _position = Offset(_screenWidth / 1.2, _screenHeight / 1.2);

    if(widget.event.image == null){

      if(_passedDependencies == false){
        await getImageFileFromAssets("logo_gray.jpg").then((file){
          setState(() {
            _imageNewEvent = file;
          });
        });

        _passedDependencies = true;
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    double _screenWidth = MediaQuery.of(context).size.width; //lee el ancho de dispositivo
    double _screenHeight = MediaQuery.of(context).size.height; //lee el largo del dispositivo
    //double _symmetricPadding; //padding lateral de la pantalla

    //_symmetricPadding =  (_screenWidth * values.widthPaddingUnit) / 10; //Función que nos permite hacer un padding responsivo a cualquier resolución en ancho
    double _responsiveHeight = _screenHeight / _values.defaultDivisionForResponsiveHeight; //Función para altura responsiva de cada card en la lista

    // TODO: implement build
    double _symmetricPadding = (_screenWidth * _values.widthPaddingUnit) / 10; //Función que nos permite hacer un padding responsivo a cualquier resolución en ancho

    if(widget.adminView == true){
      if(widget.event.id != null){
        TextEditingController _titleTextController = new TextEditingController(text: widget.event.title);
        TextEditingController _placeTextController = new TextEditingController(text: widget.event.place);
        TextEditingController _descriptionTextController = new TextEditingController(text: widget.event.description);


        _widgetPortraitColumn = Column(
          children: <Widget>[
            Container(
                alignment: _values.centerAlignment,
                child: Stack(
                  children: <Widget>[
                    Parallax.inside(
                        child: CachedNetworkImage(
                          imageUrl: widget.event.image,
                          placeholder: (context, url) => Image.asset(_values.loadingAnimation, fit: BoxFit.fill, width: double.maxFinite, height: _responsiveHeight,),
                          errorWidget: (context,url,error) => new Icon(Icons.error),
                          width: double.maxFinite,
                          height: _responsiveHeight * 1.1,
                          fit: BoxFit.cover,
                        ),
                        mainAxisExtent: _responsiveHeight / 1.1
                    ),
                    Container(
                      color: _hue.background,
                      child: IconButton(
                          icon: Icon(
                            Icons.cached,
                            color: _hue.outlines,
                          ),
                          iconSize: _responsiveHeight / 11,
                          tooltip: _values.tooltipChangeEventImage,
                          onPressed: (){
                            Future<String> finalURL = PickImage(widget.event, context);
                            finalURL.then((val){
                              setState(() {
                                this.widget.event.image = val;
                              });
                            });
                          }
                      ),
                    )
                  ],
                )
            ),
            SizedBox(height: _responsiveHeight / 22,),
            Container(
              child: TextField(
                controller: _titleTextController,
                decoration: new InputDecoration(
                    labelText: "Título",
                    labelStyle: _values.textFieldTextStyle,
                    fillColor: Colors.white,
                    filled: true,
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(_values.standardBorderRadius),
                      borderSide: new BorderSide(
                      ),
                    ),
                    focusedBorder: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(_values.standardBorderRadius),
                        borderSide: _values.textFieldFocusBorderSide
                    )
                  //fillColor: Colors.green
                ),
                onEditingComplete: (){
                  widget.event.UpdateEvent(_titleTextController.text, 'title').then((updatedTitle){
                    setState(() {
                      widget.event.title = updatedTitle;
                    });
                  });
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                style: _values.textFieldTextStyle,
              ),
            ),
            SizedBox(height: _responsiveHeight / 22,),
            Container(
              alignment: Alignment.centerLeft,
              child: TextField(
                controller: _placeTextController,
                decoration: new InputDecoration(
                    labelText: "Lugar",
                    labelStyle: _values.textFieldTextStyle,
                    fillColor: Colors.white,
                    filled: true,
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(_values.standardBorderRadius),
                      borderSide: new BorderSide(
                      ),
                    ),
                    focusedBorder: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(_values.standardBorderRadius),
                        borderSide: _values.textFieldFocusBorderSide
                    )
                  //fillColor: Colors.green
                ),
                style: _values.textFieldTextStyle,
                onEditingComplete: (){
                  widget.event.UpdateEvent(_placeTextController.text, 'place').then((updatedPlace){
                    setState(() {
                      widget.event.place = updatedPlace;
                    });
                  });
                  FocusScope.of(context).requestFocus(FocusNode());
                },
              ),
            ),
            SizedBox(height: _responsiveHeight / 22,),
            Container(
                alignment: Alignment.centerLeft,
                child: new Row(
                  children: <Widget>[
                    Text(
                      "Día: " + _spanishFormattedText,
                      style: _values.subtitleTextStyle,
                    ),
                    IconButton(
                      tooltip: "Cambiar fecha",
                      icon: Icon(
                        Icons.calendar_today,
                        color: _hue.outlines,
                      ),
                      color: _hue.outlines,
                      onPressed: (){
                        DatePicker.showDatePicker(context,
                            showTitleActions: true,
                            minTime: DateTime.now(),
                            maxTime: DateTime.now().add(Duration(days: 500)),
                            onChanged: (date) {

                            },
                            onConfirm: (date) {
                              String format = date.toString().substring(0, 10);
                              widget.event.UpdateEvent(format, 'date').then((updatedDate){
                                setState(() {
                                  widget.event.date = updatedDate;
                                });
                              });
                            },
                            currentTime: DateTime.now(),
                            locale: LocaleType.es
                        );
                      },
                    )
                  ],
                )
            ),
            SizedBox(height: _responsiveHeight / 22,),
            Container(
              alignment: Alignment.centerLeft,
              child: Row(
                children: <Widget>[
                  Text(
                    "Hora: " + widget.event.time,
                    style: _values.subtitleTextStyle,
                  ),
                  IconButton(
                    tooltip: "Cambiar hora",
                    icon: Icon(Icons.access_time),
                    color: _hue.outlines,
                    onPressed: (){
                      DateTime now = DateTime.now();

                      DatePicker.showTimePicker(context,
                        showTitleActions: true,
                        currentTime: DateTime(now.hour, now.minute),
                        onChanged: (time){

                        },
                        onConfirm: (time){
                          String newTime = BuildEventTimeText(time.toString());
                          widget.event.UpdateEvent(newTime, 'time').then((updatedTime){
                            setState(() {
                              widget.event.time = updatedTime;
                            });
                          });
                        },
                        locale: LocaleType.es,
                      );
                    },
                  )
                ],
              ),
            ),
            SizedBox(height: _responsiveHeight / 22,),
            Container(
              alignment: _values.centerAlignment,
              child: TextField(
                controller: _descriptionTextController,
                maxLines: null,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
                decoration: new InputDecoration(
                    labelText: "Descripción",
                    labelStyle: _values.textFieldTextStyle,
                    fillColor: Colors.white,
                    filled: true,
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(_values.standardBorderRadius),
                      borderSide: new BorderSide(
                      ),
                    ),
                    focusedBorder: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(_values.standardBorderRadius),
                        borderSide: _values.textFieldFocusBorderSide
                    )
                  //fillColor: Colors.green
                ),
                style: _values.textFieldTextStyle,
                onEditingComplete: (){
                  widget.event.UpdateEvent(_descriptionTextController.text, 'description').then((updatedDescription){
                    setState(() {
                      widget.event.description = updatedDescription;
                    });
                  });
                  FocusScope.of(context).requestFocus(FocusNode());
                },
              ),
            )
          ],
        );
        _widgetLandscapeColumn = Column(
          children: <Widget>[
            Container(
                alignment: _values.centerAlignment,
                child: Stack(
                  children: <Widget>[
                    Parallax.inside(
                        child: CachedNetworkImage(
                          imageUrl: widget.event.image,
                          placeholder: (context, url) => Image.asset(_values.loadingAnimation, fit: BoxFit.fill, width: double.maxFinite, height: _responsiveHeight,),
                          errorWidget: (context,url,error) => new Icon(Icons.error),
                          width: double.maxFinite,
                          height: _responsiveHeight * 1.1,
                          fit: BoxFit.cover,
                        ),
                        mainAxisExtent: _responsiveHeight / 1.1
                    ),
                    Container(
                      color: _hue.background,
                      child: IconButton(
                          icon: Icon(
                            Icons.cached,
                            color: _hue.outlines,
                          ),
                          iconSize: _responsiveHeight / 5,
                          tooltip: _values.tooltipChangeEventImage,
                          onPressed: (){
                            Future<String> finalURL = PickImage(widget.event, context);
                            finalURL.then((val){
                              setState(() {
                                this.widget.event.image = val;
                              });
                            });
                          }
                      ),
                    )
                  ],
                )
            ),
            SizedBox(height: _responsiveHeight / 11,),
            Container(
              child: TextField(
                controller: _titleTextController,
                decoration: new InputDecoration(
                    labelText: "Título",
                    labelStyle: _values.textFieldTextStyle,
                    fillColor: Colors.white,
                    filled: true,
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(_values.standardBorderRadius),
                      borderSide: new BorderSide(
                      ),
                    ),
                    focusedBorder: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(_values.standardBorderRadius),
                        borderSide: _values.textFieldFocusBorderSide
                    )
                  //fillColor: Colors.green
                ),
                onEditingComplete: (){
                  widget.event.UpdateEvent(_titleTextController.text, 'title').then((updatedTitle){
                    setState(() {
                      widget.event.title = updatedTitle;
                    });
                  });
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                style: _values.textFieldTextStyle,
              ),
            ),
            SizedBox(height: _responsiveHeight / 11,),
            Container(
              alignment: Alignment.centerLeft,
              child: TextField(
                controller: _placeTextController,
                decoration: new InputDecoration(
                    labelText: "Lugar",
                    labelStyle: _values.textFieldTextStyle,
                    fillColor: Colors.white,
                    filled: true,
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(_values.standardBorderRadius),
                      borderSide: new BorderSide(
                      ),
                    ),
                    focusedBorder: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(_values.standardBorderRadius),
                        borderSide: _values.textFieldFocusBorderSide
                    )
                  //fillColor: Colors.green
                ),
                style: _values.textFieldTextStyle,
                onEditingComplete: (){
                  widget.event.UpdateEvent(_placeTextController.text, 'place').then((updatedPlace){
                    setState(() {
                      widget.event.place = updatedPlace;
                    });
                  });
                  FocusScope.of(context).requestFocus(FocusNode());
                },
              ),
            ),
            SizedBox(height: _responsiveHeight / 11,),
            Container(
                alignment: Alignment.centerLeft,
                child: new Row(
                  children: <Widget>[
                    Text(
                      "Día: " + _spanishFormattedText,
                      style: _values.subtitleTextStyle,
                    ),
                    IconButton(
                      tooltip: "Cambiar fecha",
                      icon: Icon(
                        Icons.calendar_today,
                        color: _hue.outlines,
                      ),
                      color: _hue.outlines,
                      onPressed: (){
                        DatePicker.showDatePicker(context,
                            showTitleActions: true,
                            minTime: DateTime.now(),
                            maxTime: DateTime.now().add(Duration(days: 500)),
                            onChanged: (date) {

                            },
                            onConfirm: (date) {
                              String format = date.toString().substring(0, 10);
                              widget.event.UpdateEvent(format, 'date').then((updatedDate){
                                setState(() {
                                  widget.event.date = updatedDate;
                                });
                              });
                            },
                            currentTime: DateTime.now(),
                            locale: LocaleType.es
                        );
                      },
                    )
                  ],
                )
            ),
            SizedBox(height: _responsiveHeight / 11,),
            Container(
              alignment: Alignment.centerLeft,
              child: Row(
                children: <Widget>[
                  Text(
                    "Hora: " + widget.event.time,
                    style: _values.subtitleTextStyle,
                  ),
                  IconButton(
                    tooltip: "Cambiar hora",
                    icon: Icon(Icons.access_time),
                    color: _hue.outlines,
                    onPressed: (){
                      DateTime now = DateTime.now();

                      DatePicker.showTimePicker(context,
                        showTitleActions: true,
                        currentTime: DateTime(now.hour, now.minute),
                        onChanged: (time){

                        },
                        onConfirm: (time){
                          String newTime = BuildEventTimeText(time.toString());
                          widget.event.UpdateEvent(newTime, 'time').then((updatedTime){
                            setState(() {
                              widget.event.time = updatedTime;
                            });
                          });
                        },
                        locale: LocaleType.es,
                      );
                    },
                  )
                ],
              ),
            ),
            SizedBox(height: _responsiveHeight / 11,),
            Container(
              alignment: _values.centerAlignment,
              child: TextField(
                controller: _descriptionTextController,
                maxLines: null,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
                decoration: new InputDecoration(
                    labelText: "Descripción",
                    labelStyle: _values.textFieldTextStyle,
                    fillColor: Colors.white,
                    filled: true,
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(_values.standardBorderRadius),
                      borderSide: new BorderSide(
                      ),
                    ),
                    focusedBorder: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(_values.standardBorderRadius),
                        borderSide: _values.textFieldFocusBorderSide
                    )
                  //fillColor: Colors.green
                ),
                style: _values.textFieldTextStyle,
                onEditingComplete: (){
                  widget.event.UpdateEvent(_descriptionTextController.text, 'description').then((updatedDescription){
                    setState(() {
                      widget.event.description = updatedDescription;
                    });
                  });
                  FocusScope.of(context).requestFocus(FocusNode());
                },
              ),
            )
          ],
        );

        _floatingButton = new FloatingActionButton(
          tooltip: "Eliminar evento",
          backgroundColor: _hue.carmesi,
          child: Icon(Icons.delete),
          onPressed: (){
            showDialog(
              context: context,
              builder: (BuildContext context) => CustomAlertDialog(
                description: "Este evento se borrará permanentemente ¿Está seguro?",
                acceptButtonText: "Si",
                cancelButtonText: "No",
              )
            ).then((result){
              if(result == true){
                showDialog(
                  context: context,
                  builder: (BuildContext context) => CustomLoadDialog()
                );

                widget.event.DeleteEvent(context).then((result){
                  if(result == true){
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  }
                });
              }
            });
          }
        );
      }else{
        TextEditingController _titleTextController = new TextEditingController(text: widget.event.title);
        TextEditingController _placeTextController = new TextEditingController(text: widget.event.place);
        TextEditingController _descriptionTextController = new TextEditingController(text: widget.event.description);

        if(_imageNewEvent == null){
          _imageWidget = new Image.asset(
            _values.defaultPlace,
            fit: BoxFit.cover,
            width: double.maxFinite,
            height: _responsiveHeight * 1.1,
          );
        }else{
          _imageWidget = new Image.file(
            _imageNewEvent,
            fit: BoxFit.cover,
            width: double.maxFinite,
            height: _responsiveHeight * 1.1,
          );
        }

        _widgetPortraitColumn = Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Container(
                  alignment: _values.centerAlignment,
                  child: Stack(
                    children: <Widget>[
                      Parallax.inside(
                          child: _imageWidget,
                          mainAxisExtent: _responsiveHeight / 1.1
                      ),
                      Container(
                        color: _hue.background,
                        child: IconButton(
                            icon: Icon(
                              Icons.cached,
                              color: _hue.outlines,
                            ),
                            iconSize: _responsiveHeight / 11,
                            tooltip: _values.tooltipChangeEventImage,
                            onPressed: ()async{
                              var image = await ImagePicker.pickImage(source: ImageSource.gallery);
                              setState((){
                                _imageNewEvent = image;
                              });
                            }
                        ),
                      )
                    ],
                  )
              ),
              SizedBox(height: _responsiveHeight / 22,),
              Container(
                child: TextFormField(
                  controller: _titleTextController,
                  decoration: new InputDecoration(
                      labelText: "Título",
                      labelStyle: _values.textFieldTextStyle,
                      fillColor: Colors.white,
                      filled: true,
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(_values.standardBorderRadius),
                        borderSide: new BorderSide(
                        ),
                      ),
                      focusedBorder: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(_values.standardBorderRadius),
                          borderSide: _values.textFieldFocusBorderSide
                      )
                  ),
                  validator: (val) {
                    if(val.length==0) {
                      return "Este campo no puede estar vacío.";
                    }else{
                      return null;
                    }
                  },
                  onEditingComplete: (){
                    setState(() {
                      widget.event.title = _titleTextController.text;
                    });
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                  onChanged: (content){
                    widget.event.title = _titleTextController.text;
                  },
                  style: _values.textFieldTextStyle,
                ),
              ),
              SizedBox(height: _responsiveHeight / 22,),
              Container(
                alignment: Alignment.centerLeft,
                child: TextFormField(
                  controller: _placeTextController,
                  decoration: new InputDecoration(
                      labelText: "Lugar",
                      labelStyle: _values.textFieldTextStyle,
                      fillColor: Colors.white,
                      filled: true,
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(_values.standardBorderRadius),
                        borderSide: new BorderSide(
                        ),
                      ),
                      focusedBorder: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(_values.standardBorderRadius),
                          borderSide: _values.textFieldFocusBorderSide
                      )
                  ),
                  validator: (val) {
                    if(val.length==0) {
                      return "Este campo no puede estar vacío.";
                    }else{
                      return null;
                    }
                  },
                  onEditingComplete: (){
                    setState(() {
                      widget.event.place = _placeTextController.text;
                    });
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                  onChanged: (content){
                    widget.event.place = _placeTextController.text;
                  },
                  style: _values.textFieldTextStyle,
                ),
              ),
              SizedBox(height: _responsiveHeight / 22,),
              Container(
                  alignment: Alignment.centerLeft,
                  child: new Row(
                    children: <Widget>[
                      Text(
                        "Día: " + _spanishFormattedText,
                        style: _values.subtitleTextStyle,
                      ),
                      IconButton(
                        tooltip: "Cambiar fecha",
                        icon: Icon(
                          Icons.calendar_today,
                          color: _hue.outlines,
                        ),
                        color: _hue.outlines,
                        onPressed: (){
                          DatePicker.showDatePicker(context,
                              showTitleActions: true,
                              minTime: DateTime.now(),
                              maxTime: DateTime.now().add(Duration(days: 500)),
                              onChanged: (date) {

                              },
                              onConfirm: (date) {
                                String format = date.toString().substring(0, 10);
                                setState(() {
                                  widget.event.date = format;
                                  _spanishFormattedText = BuildEventDayText(widget.event.date, 1);
                                });
                              },
                              currentTime: widget.newEventDateTime,
                              locale: LocaleType.es
                          );
                        },
                      )
                    ],
                  )
              ),
              SizedBox(height: _responsiveHeight / 22,),
              Container(
                alignment: Alignment.centerLeft,
                child: Row(
                  children: <Widget>[
                    Text(
                      "Hora: " + widget.event.time,
                      style: _values.subtitleTextStyle,
                    ),
                    IconButton(
                      tooltip: "Cambiar hora",
                      icon: Icon(Icons.access_time),
                      color: _hue.outlines,
                      onPressed: (){
                        DateTime now = DateTime.now();

                        DatePicker.showTimePicker(context,
                          showTitleActions: true,
                          currentTime: DateTime(now.hour, now.minute),
                          onChanged: (time){

                          },
                          onConfirm: (time){
                            String newTime = BuildEventTimeText(time.toString());
                            setState(() {
                              widget.event.time = newTime;
                            });
                          },
                          locale: LocaleType.es,
                        );
                      },
                    )
                  ],
                ),
              ),
              SizedBox(height: _responsiveHeight / 22,),
              Container(
                alignment: _values.centerAlignment,
                child: TextFormField(
                  controller: _descriptionTextController,
                  maxLines: null,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  decoration: new InputDecoration(
                      labelText: "Descripción",
                      labelStyle: _values.textFieldTextStyle,
                      fillColor: Colors.white,
                      filled: true,
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(_values.standardBorderRadius),
                        borderSide: new BorderSide(
                        ),
                      ),
                      focusedBorder: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(_values.standardBorderRadius),
                          borderSide: _values.textFieldFocusBorderSide
                      )
                  ),
                  validator: (val) {
                    if(val.length==0) {
                      return "Este campo no puede estar vacío.";
                    }else{
                      return null;
                    }
                  },
                  onEditingComplete: (){
                    setState(() {
                      widget.event.description = _descriptionTextController.text;
                    });
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                  onChanged: (content){
                    widget.event.description = _descriptionTextController.text;
                  },
                  style: _values.textFieldTextStyle,
                ),
              )
            ],
          )
        );
        _widgetLandscapeColumn = Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Container(
                    alignment: _values.centerAlignment,
                    child: Stack(
                      children: <Widget>[
                        Parallax.inside(
                            child: _imageWidget,
                            mainAxisExtent: _responsiveHeight / 1.1
                        ),
                        Container(
                          color: _hue.background,
                          child: IconButton(
                              icon: Icon(
                                Icons.cached,
                                color: _hue.outlines,
                              ),
                              iconSize: _responsiveHeight / 5,
                              tooltip: _values.tooltipChangeEventImage,
                              onPressed: ()async{
                                var image = await ImagePicker.pickImage(source: ImageSource.gallery);
                                setState((){
                                  _imageNewEvent = image;
                                });
                              }
                          ),
                        )
                      ],
                    )
                ),
                SizedBox(height: _responsiveHeight / 11,),
                Container(
                  child: TextFormField(
                    controller: _titleTextController,
                    decoration: new InputDecoration(
                        labelText: "Título",
                        labelStyle: _values.textFieldTextStyle,
                        fillColor: Colors.white,
                        filled: true,
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(_values.standardBorderRadius),
                          borderSide: new BorderSide(
                          ),
                        ),
                        focusedBorder: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(_values.standardBorderRadius),
                            borderSide: _values.textFieldFocusBorderSide
                        )
                    ),
                    validator: (val) {
                      if(val.length==0) {
                        return "Este campo no puede estar vacío.";
                      }else{
                        return null;
                      }
                    },
                    onEditingComplete: (){
                      setState(() {
                        widget.event.title = _titleTextController.text;
                      });
                      FocusScope.of(context).requestFocus(FocusNode());
                    },
                    onChanged: (content){
                      widget.event.title = _titleTextController.text;
                    },
                    style: _values.textFieldTextStyle,
                  ),
                ),
                SizedBox(height: _responsiveHeight / 11,),
                Container(
                  alignment: Alignment.centerLeft,
                  child: TextFormField(
                    controller: _placeTextController,
                    decoration: new InputDecoration(
                        labelText: "Lugar",
                        labelStyle: _values.textFieldTextStyle,
                        fillColor: Colors.white,
                        filled: true,
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(_values.standardBorderRadius),
                          borderSide: new BorderSide(
                          ),
                        ),
                        focusedBorder: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(_values.standardBorderRadius),
                            borderSide: _values.textFieldFocusBorderSide
                        )
                    ),
                    validator: (val) {
                      if(val.length==0) {
                        return "Este campo no puede estar vacío.";
                      }else{
                        return null;
                      }
                    },
                    onEditingComplete: (){
                      setState(() {
                        widget.event.place = _placeTextController.text;
                      });
                      FocusScope.of(context).requestFocus(FocusNode());
                    },
                    onChanged: (content){
                      widget.event.place = _placeTextController.text;
                    },
                    style: _values.textFieldTextStyle,
                  ),
                ),
                SizedBox(height: _responsiveHeight / 11,),
                Container(
                    alignment: Alignment.centerLeft,
                    child: new Row(
                      children: <Widget>[
                        Text(
                          "Día: " + _spanishFormattedText,
                          style: _values.subtitleTextStyle,
                        ),
                        IconButton(
                          tooltip: "Cambiar fecha",
                          icon: Icon(
                            Icons.calendar_today,
                            color: _hue.outlines,
                          ),
                          color: _hue.outlines,
                          onPressed: (){
                            DatePicker.showDatePicker(context,
                                showTitleActions: true,
                                minTime: DateTime.now(),
                                maxTime: DateTime.now().add(Duration(days: 500)),
                                onChanged: (date) {

                                },
                                onConfirm: (date) {
                                  String format = date.toString().substring(0, 10);
                                  setState(() {
                                    widget.event.date = format;
                                    _spanishFormattedText = BuildEventDayText(widget.event.date, 1);
                                  });
                                },
                                currentTime: widget.newEventDateTime,
                                locale: LocaleType.es
                            );
                          },
                        )
                      ],
                    )
                ),
                SizedBox(height: _responsiveHeight / 11,),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: <Widget>[
                      Text(
                        "Hora: " + widget.event.time,
                        style: _values.subtitleTextStyle,
                      ),
                      IconButton(
                        tooltip: "Cambiar hora",
                        icon: Icon(Icons.access_time),
                        color: _hue.outlines,
                        onPressed: (){
                          DateTime now = DateTime.now();

                          DatePicker.showTimePicker(context,
                            showTitleActions: true,
                            currentTime: DateTime(now.hour, now.minute),
                            onChanged: (time){

                            },
                            onConfirm: (time){
                              String newTime = BuildEventTimeText(time.toString());
                              setState(() {
                                widget.event.time = newTime;
                              });
                            },
                            locale: LocaleType.es,
                          );
                        },
                      )
                    ],
                  ),
                ),
                SizedBox(height: _responsiveHeight / 11,),
                Container(
                  alignment: _values.centerAlignment,
                  child: TextFormField(
                    controller: _descriptionTextController,
                    maxLines: null,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.done,
                    decoration: new InputDecoration(
                        labelText: "Descripción",
                        labelStyle: _values.textFieldTextStyle,
                        fillColor: Colors.white,
                        filled: true,
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(_values.standardBorderRadius),
                          borderSide: new BorderSide(
                          ),
                        ),
                        focusedBorder: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(_values.standardBorderRadius),
                            borderSide: _values.textFieldFocusBorderSide
                        )
                    ),
                    validator: (val) {
                      if(val.length==0) {
                        return "Este campo no puede estar vacío.";
                      }else{
                        return null;
                      }
                    },
                    onEditingComplete: (){
                      setState(() {
                        widget.event.description = _descriptionTextController.text;
                      });
                      FocusScope.of(context).requestFocus(FocusNode());
                    },
                    onChanged: (content){
                      widget.event.description = _descriptionTextController.text;
                    },
                    style: _values.textFieldTextStyle,
                  ),
                )
              ],
            )
        );

        _floatingButton = new FloatingActionButton(
          tooltip: "Guardar evento",
          backgroundColor: _hue.ocean,
          child: Icon(Icons.save),
          onPressed: (){
            if(_formKey.currentState.validate()){

              showDialog(
                  context: context,
                builder: (BuildContext context) => CustomLoadDialog()
              );

              widget.event.CreateEvent(context, _imageNewEvent).then((result){
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              });

            }
          }
        );
      }
    }else{
      _widgetPortraitColumn = Column(
        children: <Widget>[
          Container(
              alignment: _values.centerAlignment,
              child: Parallax.inside(
                  child: CachedNetworkImage(
                    width: double.maxFinite,
                    height: _responsiveHeight * 1,
                    fit: BoxFit.cover,
                    imageUrl: widget.event.image,
                    placeholder: (context, url) => Image.asset(_values.loadingAnimation, fit: BoxFit.fill, width: double.maxFinite, height: _responsiveHeight,),
                    errorWidget: (context,url,error) => new Center(
                      child: Icon(Icons.error),
                    ),
                  ),
                  mainAxisExtent: _responsiveHeight / 1
              )
          ),
          SizedBox(height: _responsiveHeight / 22,),
          Container(
            child: Text(
              widget.event.title,
              style: _values.titleTextStyle,
            ),
          ),
          SizedBox(height: _responsiveHeight / 22,),
          Container(
            color: _hue.outlines,
            padding: EdgeInsets.fromLTRB(_symmetricPadding * 15, 1.0, _symmetricPadding * 15, 1.0),
            child: SizedBox(height: _responsiveHeight / 150,),
          ),
          SizedBox(height: _responsiveHeight / 22,),
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              "Lugar: " + widget.event.place,
              style: _values.subtitleTextStyle,
            ),
          ),
          SizedBox(height: _responsiveHeight / 22,),
          Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "Día: " + _spanishFormattedText,
                style: _values.subtitleTextStyle,
              )
          ),
          SizedBox(height: _responsiveHeight / 22,),
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              "Hora: " + widget.event.time,
              style: _values.subtitleTextStyle,
            ),
          ),
          SizedBox(height: _responsiveHeight / 22,),
          Container(
            color: _hue.outlines,
            padding: EdgeInsets.fromLTRB(_symmetricPadding * 15, 1.0, _symmetricPadding * 15, 1.0),
            child: SizedBox(height: _responsiveHeight / 150,),
          ),
          SizedBox(height: _responsiveHeight / 22,),
          Container(
            alignment: _values.centerAlignment,
            child: Text(
              widget.event.description,
              style: _values.contentTextStyle,
            ),
          )
        ],
      );
      _widgetLandscapeColumn = Column(
        children: <Widget>[
          SizedBox(height: _responsiveHeight / 12,),
          Container(
              alignment: _values.centerAlignment,
              child: Stack(
                children: <Widget>[
                  Parallax.inside(
                      child: CachedNetworkImage(
                        imageUrl: widget.event.image,
                        placeholder: (context, url) => Image.asset(_values.loadingAnimation, fit: BoxFit.fill, width: double.maxFinite, height: _responsiveHeight,),
                        errorWidget: (context,url,error) => new Icon(Icons.error),
                        width: double.maxFinite,
                        height: _responsiveHeight * 1.1,
                        fit: BoxFit.cover,
                      ),
                      mainAxisExtent: _responsiveHeight / 1.1
                  ),
                ],
              )
          ),
          SizedBox(height: _responsiveHeight / 11,),
          Container(
            child: Text(
              widget.event.title,
              style: _values.titleTextStyle,
            ),
          ),
          SizedBox(height: _responsiveHeight / 11,),
          Container(
            color: _hue.outlines,
            padding: EdgeInsets.fromLTRB(_symmetricPadding * 15, 1.0, _symmetricPadding * 15, 1.0),
            child: SizedBox(height: _responsiveHeight / 100,),
          ),
          SizedBox(height: _responsiveHeight / 11,),
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              "Lugar: " + widget.event.place,
              style: _values.subtitleTextStyle,
            ),
          ),
          SizedBox(height: _responsiveHeight / 11,),
          Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "Día: " + _spanishFormattedText,
                style: _values.subtitleTextStyle,
              )
          ),
          SizedBox(height: _responsiveHeight / 11,),
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              "Hora: " + widget.event.time,
              style: _values.subtitleTextStyle,
            ),
          ),
          SizedBox(height: _responsiveHeight / 11,),
          Container(
            color: _hue.outlines,
            padding: EdgeInsets.fromLTRB(_symmetricPadding * 15, 1.0, _symmetricPadding * 15, 1.0),
            child: SizedBox(height: _responsiveHeight / 100,),
          ),
          SizedBox(height: _responsiveHeight / 11,),
          Container(
            alignment: _values.centerAlignment,
            child: Text(
              widget.event.description,
              style: _values.contentTextStyle,
            ),
          )
        ],
      );
    }

    return OrientationBuilder(
      builder: (context, orientation){
        return orientation == Orientation.portrait
            ?
        Scaffold(
            backgroundColor: _hue.background,
            appBar: AppBar(
              backgroundColor: _hue.carmesi,
              title: Text("Evento"),
            ),
            floatingActionButton: Stack(
              children: <Widget>[
                Positioned(
                  left: _position.dx,
                  top:  _position.dy,
                  child: Draggable(
                    feedback: Container(
                      child: _floatingButton,
                    ),
                    child: Container(
                      child: _floatingButton,
                    ),
                    childWhenDragging: Container(),
                    onDragEnd: (details){
                      setState(() {
                        _position = details.offset;
                      });
                    },
                  ),
                )
              ],
            ),
            body: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: _symmetricPadding),
              controller: _scrollController,
              child: ConstrainedBox(
                constraints: BoxConstraints(),
                child: _widgetPortraitColumn,
              ),
            )
        )
            :
        Scaffold(
            backgroundColor: _hue.background,
            appBar: AppBar(
              backgroundColor: _hue.carmesi,
              title: Text("Evento"),
            ),
            floatingActionButton: Stack(
              children: <Widget>[
                Positioned(
                  left: _position.dx,
                  top:  _position.dy,
                  child: Draggable(
                    feedback: Container(
                      child: _floatingButton,
                    ),
                    child: Container(
                      child: _floatingButton,
                    ),
                    childWhenDragging: Container(),
                    onDragEnd: (details){
                      setState(() {
                        _position = details.offset;
                      });
                    },
                  ),
                )
              ],
            ),
            body: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: _symmetricPadding),
              controller: _scrollController,
              child: ConstrainedBox(
                constraints: BoxConstraints(),
                child: _widgetLandscapeColumn,
              ),
            )
        );
      },
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _scrollController.dispose();
    super.dispose();
  }

}

class NewsScreen extends StatefulWidget {
  NewsScreen({Key key, this.adminView}) : super(key: key);

  final bool adminView;

  @override
  _NewsScreen createState() => _NewsScreen();
}

class _NewsScreen extends State<NewsScreen>{

  static Values _values;
  static Hues _hue;
  ScrollController _scrollController;

  FloatingActionButton _floatingActionButton;
  Offset _position;
  Widget _finalScreen;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _values = new Values();
    _hue = new Hues();
    _scrollController = new ScrollController();
    _newsList = new List();
    _finalScreen = Center(
      child: Image.asset(
          _values.loadingAnimation
      ),
    );

    if(widget.adminView == true){
      _floatingActionButton = FloatingActionButton(
        tooltip: "Crear noticia",
        backgroundColor: _hue.ocean,
        child: Icon(Icons.add),
        onPressed: (){
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NewDetailsScreen(adminView: true,)
              )
          );
        },
      );
    }else{
      _position = Offset(0.0, 0.0);
      _floatingActionButton = null;
    }
  }

  @override
  void didChangeDependencies() async{
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    double _screenWidth = MediaQuery.of(context).size.width; //lee el ancho de dispositivo
    double _screenHeight = MediaQuery.of(context).size.height; //lee el largo del dispositivo
    //double _symmetricPadding; //padding lateral de la pantalla

    //_symmetricPadding =  (_screenWidth * values.widthPaddingUnit) / 10; //Función que nos permite hacer un padding responsivo a cualquier resolución en ancho

    if(widget.adminView == true){
      _position = Offset(_screenWidth / 1.2, _screenHeight / 1.2);
    }

    await RetrieveNews(context).then((list){
      if(list.isNotEmpty){
        setState(() {
          _finalScreen = SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: _screenWidth / _values.defaultSymmetricPadding),
            controller: _scrollController,
            child: ListView.builder(
              itemCount: list.length,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index){
                return GestureDetector(
                  child: Card(
                    elevation: _values.cardElevation,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(list[index].text, style: _values.contentTextStyle,),
                        Container(color: _hue.outlines, height: _values.lineSizedBoxHeight,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            FlatButton(
                              textColor: _hue.ocean,
                              child: Text("Galería", style: _values.flatButtonTextStyle,),
                              onPressed: (){

                              },
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                );
              }
            ),
          );
        });
      }else{
        setState(() {
          _finalScreen = Center(
            child: Image.asset(
                _values.noContentFound
            ),
          );
        });
      }
    });

  }

  @override
  Widget build(BuildContext context) {

    return OrientationBuilder(
      builder: (context, orientation){
        return orientation == Orientation.portrait
            ?
        Scaffold(
          backgroundColor: _hue.background,
          appBar: AppBar(
            backgroundColor: _hue.carmesi,
            title: Text("Noticias"),
          ),
          body: _finalScreen,
          floatingActionButton: Stack(
            children: <Widget>[
              Positioned(
                left: _position.dx,
                top:  _position.dy,
                child: Draggable(
                  feedback: Container(
                    child: _floatingActionButton,
                  ),
                  child: Container(
                    child: _floatingActionButton,
                  ),
                  childWhenDragging: Container(),
                  onDragEnd: (details){
                    setState(() {
                      _position = details.offset;
                    });
                  },
                ),
              )
            ],
          ),
        )
            :
        Scaffold(
          backgroundColor: _hue.background,
          appBar: AppBar(
            backgroundColor: _hue.carmesi,
            title: Text("Noticias"),
          ),
          body: SingleChildScrollView(
            controller: _scrollController,
            child: Text("Landscape mode"),
          ),
          floatingActionButton: Stack(
            children: <Widget>[
              Positioned(
                left: _position.dx,
                top:  _position.dy,
                child: Draggable(
                  feedback: Container(
                    child: _floatingActionButton,
                  ),
                  child: Container(
                    child: _floatingActionButton,
                  ),
                  childWhenDragging: Container(),
                  onDragEnd: (details){
                    setState(() {
                      _position = details.offset;
                    });
                  },
                ),
              )
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _scrollController.dispose();
    super.dispose();
  }
}

class NewDetailsScreen extends StatefulWidget {
  NewDetailsScreen({Key key, this.adminView}) : super(key: key);

  final bool adminView;

  @override
  _NewDetailsScreen createState() => _NewDetailsScreen();
}

class _NewDetailsScreen extends State<NewDetailsScreen>{

  static Values _values;
  static Hues _hue;
  ScrollController _scrollController;

  FloatingActionButton _floatingActionButton;
  Offset _position;

  Widget _screenPortraitContent, _screenLandscapeContent;

  TextEditingController _textEditingController;
  List<String> _imageUrlList;
  var _formKey;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _values = new Values();
    _hue = new Hues();
    _scrollController = new ScrollController();
    _screenPortraitContent = new Scaffold();
    _screenLandscapeContent = new Scaffold();
    _imageUrlList = new List();

    if(widget.adminView == true){
      _formKey = GlobalKey<FormState>();
      _floatingActionButton = FloatingActionButton(
        tooltip: "Guardar noticia",
        backgroundColor: _hue.ocean,
        child: Icon(Icons.save),
        onPressed: (){
          if(_formKey.currentState.validate()){
            showDialog(
              context: context,
              builder: (BuildContext context) => CustomLoadDialog()
            );

            CreateNew(context, _imageUrlList, _textEditingController.text).then((result){
                Navigator.pop(context);
                Navigator.pop(context);
            });
          }
        },
      );
      _textEditingController = new TextEditingController();
    }else{
      _position = Offset(0.0, 0.0);
      _floatingActionButton = null;
    }
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    double _screenWidth = MediaQuery.of(context).size.width; //lee el ancho de dispositivo
    double _screenHeight = MediaQuery.of(context).size.height; //lee el largo del dispositivo
    //double _symmetricPadding; //padding lateral de la pantalla

    //_symmetricPadding =  (_screenWidth * values.widthPaddingUnit) / 10; //Función que nos permite hacer un padding responsivo a cualquier resolución en ancho

    if(widget.adminView == true){
      _position = Offset(_screenWidth / 1.2, _screenHeight / 1.2);
    }

  }

  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width; //lee el ancho de dispositivo
    double _screenHeight = MediaQuery.of(context).size.height; //lee el largo del dispositivo
    //double _symmetricPadding; //padding lateral de la pantalla

    //_symmetricPadding =  (_screenWidth * values.widthPaddingUnit) / 10; //Función que nos permite hacer un padding responsivo a cualquier resolución en ancho

    if(widget.adminView == true){
      _screenPortraitContent = SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: _screenWidth / _values.defaultSymmetricPadding),
        controller: _scrollController,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(height: _values.toolbarGapSizedBox,),
            Form(
              key: _formKey,
              child: TextFormField(
                controller: _textEditingController,
                maxLines: null,
                decoration: new InputDecoration(
                    labelText: "Texto de la noticia",
                    labelStyle: _values.textFieldTextStyle,
                    fillColor: Colors.white,
                    filled: true,
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(_values.standardBorderRadius),
                      borderSide: new BorderSide(
                        color: _hue.outlines,
                      ),
                    ),
                    focusedBorder: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(_values.standardBorderRadius),
                        borderSide: new BorderSide(
                          color: _hue.outlines,
                        )
                    )
                ),
                validator: (val) {
                  if(val.length==0) {
                    return _values.emptyTextFieldMessage;
                  }else{
                    return null;
                  }
                },
                keyboardType: TextInputType.text,
                style: _values.textFieldTextStyle,
              ),
            ),
            SizedBox(height: _screenHeight / 15,),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.add_a_photo,
                    color: _hue.outlines,
                  ),
                  onPressed: () async{
                    var resultList = await MultiImagePicker.pickImages(
                      maxImages :  100,
                      enableCamera: true,
                    );

                    // The data selected here comes back in the list
                    for ( var imageFile in resultList) {
                      SaveNewsImageOnCloud(imageFile).then((downloadUrl) {
                        // Get the download URL
                        setState(() {
                          _imageUrlList.add(downloadUrl);
                        });
                      }).catchError((err) {
                        Navigator.pop(context);
                        print(err);
                      });
                    }
                  },
                )
              ],
            ),
            Row(
              children: <Widget>[
                Text(
                  "Galería",
                  style: _values.subtitleTextStyle,
                ),
                Expanded(
                  child: Container(
                    color: _hue.outlines,
                    height: _values.lineSizedBoxHeight,
                  ),
                )
              ],
            ),
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              children: List.generate(_imageUrlList.length, (index){
                return Center(
                  child: Stack(
                    children: <Widget>[
                      CachedNetworkImage(
                        imageUrl: _imageUrlList[index],
                        placeholder: (context, url) => Image.asset(_values.loadingAnimation, fit: BoxFit.fill, width: double.maxFinite, height: _screenHeight / 3,),
                        errorWidget: (context,url,error) => new Icon(Icons.error),
                        width: double.maxFinite,
                        height: _screenHeight / 3,
                        fit: BoxFit.cover,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(_values.standardBorderRadius * 5)),
                              color: _hue.carmesi
                            ),
                            child: IconButton(
                              icon: Icon(
                                Icons.delete,
                                color: _hue.background,
                              ),
                              tooltip: "Borrar",
                              onPressed: (){
                                DeleteOneNewsImage(_imageUrlList[index]);
                                setState(() {
                                  _imageUrlList.removeAt(index);
                                });
                              },
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                );
              }),
            )
          ],
        ),
      );
    }

    return OrientationBuilder(
      builder: (context, orientation){
        return orientation == Orientation.portrait
            ?
        WillPopScope(
          child: Scaffold(
            backgroundColor: _hue.background,
            appBar: AppBar(
              backgroundColor: _hue.carmesi,
              title: Text("Galería"),
            ),
            body: _screenPortraitContent,
            floatingActionButton: Stack(
              children: <Widget>[
                Positioned(
                  left: _position.dx,
                  top:  _position.dy,
                  child: Draggable(
                    feedback: Container(
                      child: _floatingActionButton,
                    ),
                    child: Container(
                      child: _floatingActionButton,
                    ),
                    childWhenDragging: Container(),
                    onDragEnd: (details){
                      setState(() {
                        _position = details.offset;
                      });
                    },
                  ),
                )
              ],
            ),
          ),
          onWillPop: (){
            return showDialog(
                context: context,
                builder: (BuildContext context) => CustomAlertDialog(description: "Si se va ahora no se guardará la noticia.", acceptButtonText: "Aceptar", cancelButtonText: "Cancelar",)
            ).then((result){
              if(result == true){
                DeleteNewsImageOnCloud(_imageUrlList);
                return true;
              }else{
                return false;
              }
            });
          },
        )
            :
        WillPopScope(
          child: Scaffold(
            backgroundColor: _hue.background,
            appBar: AppBar(
              backgroundColor: _hue.carmesi,
              title: Text("Galería"),
            ),
            body: _screenPortraitContent,
            floatingActionButton: Stack(
              children: <Widget>[
                Positioned(
                  left: _position.dx,
                  top:  _position.dy,
                  child: Draggable(
                    feedback: Container(
                      child: _floatingActionButton,
                    ),
                    child: Container(
                      child: _floatingActionButton,
                    ),
                    childWhenDragging: Container(),
                    onDragEnd: (details){
                      setState(() {
                        _position = details.offset;
                      });
                    },
                  ),
                )
              ],
            ),
          ),
          onWillPop: (){
            showDialog(
                context: context,
                builder: (BuildContext context) => CustomAlertDialog(description: "Si se va ahora no se guardará la noticia.", acceptButtonText: "Aceptar", cancelButtonText: "Cancelar",)
            ).then((result){
              if(result){
                DeleteNewsImageOnCloud(_imageUrlList).then((result){
                  Navigator.pop(context);
                });
              }
            });
          },
        );
      },
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _scrollController.dispose();
    super.dispose();
  }
}

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreen createState() => _LoginScreen();
}

class _LoginScreen extends State<LoginScreen>{

  Hues hue = new Hues();
  static Values values = new Values();

  TextEditingController _idTextController; //Los controladores de texto nos permiten controlar los valores en un inputfield
  TextEditingController _passwordTextController; //Los controladores de texto nos permiten controlar los valores en un inputfield
  var _formKey; //la llave para identificar el form de login

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _idTextController  = new TextEditingController();
    _passwordTextController = new TextEditingController();
    _formKey = GlobalKey<FormState>();
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    double _screenWidth = MediaQuery.of(context).size.width; //lee el ancho de dispositivo
    //double _screenHeight = MediaQuery.of(context).size.height; //lee el largo del dispositivo
    double _symmetricPadding = 30.0; //padding lateral de la pantalla
    _symmetricPadding =  (_screenWidth * values.widthPaddingUnit) / 10; //Función que nos permite hacer un padding responsivo a cualquier resolución en ancho

    final idField = new TextFormField(
      controller: _idTextController,
      decoration: new InputDecoration(
          labelText: "Usuario",
          labelStyle: values.textFieldTextStyle,
          fillColor: Colors.white,
          filled: true,
          border: new OutlineInputBorder(
            borderRadius: new BorderRadius.circular(values.standardBorderRadius),
            borderSide: new BorderSide(
              color: hue.outlines,
            ),
          ),
          focusedBorder: new OutlineInputBorder(
              borderRadius: new BorderRadius.circular(values.standardBorderRadius),
              borderSide: new BorderSide(
                color: hue.outlines,
              )
          )
      ),
      validator: (val) {
        if(val.length==0) {
          return values.emptyTextFieldMessage;
        }else{
          if(val.contains('@')){
            return null;
          }else{
            return values.notValidEmailMessage;
          }
        }
      },
      keyboardType: TextInputType.emailAddress,
      style: values.textFieldTextStyle,
    );

    final passwordField = new TextFormField(
      controller: _passwordTextController,
      obscureText: true,
      decoration: new InputDecoration(
        labelText: "Contraseña",
        labelStyle: values.textFieldTextStyle,
        fillColor: Colors.white,
        filled: true,
        border: new OutlineInputBorder(
          borderRadius: new BorderRadius.circular(values.standardBorderRadius),
          borderSide: new BorderSide(
            color: hue.outlines
          ),
        ),
        focusedBorder: new OutlineInputBorder(
            borderRadius: new BorderRadius.circular(values.standardBorderRadius),
            borderSide: new BorderSide(
                color: hue.outlines
            )
        )
        //fillColor: Colors.green
      ),
      validator: (val) {
        if(val.length==0) {
          return values.emptyTextFieldMessage;
        }else{
          return null;
        }
      },
      style: values.textFieldTextStyle,
    );

    final loginButton = Material(
      elevation: values.buttonElevation,
      borderRadius: BorderRadius.circular(values.standardBorderRadius),
      color: hue.ocean,
      child: MaterialButton(
          minWidth: _screenWidth,
          padding: EdgeInsets.fromLTRB(values.standardPaddingLeft, values.standardPaddingTop, values.standardPaddingRight, values.standardPaddingBottom),
          child: Text(
            "Entrar",
            textAlign: TextAlign.center,
            style: values.materialButtonBoldTextStyle,
          ),
          onPressed: () {
            if (_formKey.currentState.validate()) {

              showDialog(
                  context: context,
                  builder: (BuildContext context) => CustomLoadDialog()
              );

              AdminLogin(_idTextController.text, _passwordTextController.text, context).then((fireUser) async{
                if(fireUser != null){
                  Navigator.of(context).pop();
                  values.firestoreReference.collection('admins').where('email', isEqualTo: fireUser.email).snapshots().listen((data){

                    User user = new User(fireUser.uid, data.documents[0].documentID, data.documents[0]['nickname'], data.documents[0]['email'], data.documents[0]['admin'], data.documents[0]['masterAdmin']);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AdminScreen(user: user,),
                        )
                    );

                  });
                }
              });
            }
          }
      ),
    );

    final resetPasswordButton = FlatButton(
        onPressed: (){
          showDialog(
            context: context,
            builder: (BuildContext context) => CustomFormDialog(
              description: "Ingrese el correo al que debemos envíar su contraseña.",
              acceptButtonText: "Enviar",
              cancelButtonText: "Cancelar",
              dialogPurpose: values.dialogPurposes["Recuperar contraseña"],
            )
          );
        },
        child: Text(
          "Cambiar contraseña",
          textAlign: TextAlign.center,
          style: values.flatButtonTextStyle
        ),
    );

    return new Scaffold(
      backgroundColor: hue.background,
      appBar: AppBar(
        backgroundColor: hue.carmesi,
        title: Text('Administrar'),
      ),
      body: new Container(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: _symmetricPadding),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
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
                  SizedBox(height: values.smallSizedBoxStandardHeight,),
                  idField,
                  SizedBox(height: values.smallSizedBoxStandardHeight,),
                  passwordField,
                  SizedBox(height: values.smallSizedBoxStandardHeight,),
                  loginButton,
                  SizedBox(height: values.smallSizedBoxStandardHeight,),
                  resetPasswordButton
                ],
              ),
            ),
          ),
        ),
      )
    );
  }

}

class AdminScreen extends StatefulWidget {
  AdminScreen({Key key, this.user}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final User user;

  @override
  _AdminScreen createState() => _AdminScreen();
}

class _AdminScreen extends State<AdminScreen> with SingleTickerProviderStateMixin{

  GlobalKey<ScaffoldState> _scaffoldKey;
  static Values _values;
  static Hues _hue;

  ScrollController _scrollController;

  int _tabIndex;

  List<Widget> _tabs;

  TabController _tabController;

  FloatingActionButton _floatingActionButton;
  Offset _position;

  Widget _mailUpdateEntry;
  TextEditingController _mailUpdateController;
  bool _editingMailState;

  @override
  void initState() {
    super.initState();
    _values = new Values();
    _hue = new Hues();
    _scaffoldKey = new GlobalKey<ScaffoldState>();
    _scrollController = new ScrollController();
    _mailUpdateController = new TextEditingController();
    _mailUpdateController.text = widget.user.email;
    _editingMailState = false;
    _mailUpdateEntry = Text(
      _mailUpdateController.text,
      textAlign: TextAlign.center,
      style: _values.contentTextStyle,
    );
    _tabIndex = 0;
    _floatingActionButton = null;

    if(widget.user.masterAdmin == true){
      _tabController = TabController(vsync: this, length: _values.numberOfAdminTabs + 1);
    }
    if(widget.user.admin == true){
      _tabController = TabController(vsync: this, length: _values.numberOfAdminTabs);
    }

    _tabController.addListener(_handleTabSelection);
  }

  @override
  void didChangeDependencies(){
    super.didChangeDependencies();

    double _screenWidth = MediaQuery.of(context).size.width; //lee el ancho de dispositivo
    double _screenHeight = MediaQuery.of(context).size.height; //lee el largo del dispositivo

    _position = Offset(_screenWidth / 1.2, _screenHeight / 1.2);

  }

  @override
  Widget build(BuildContext context) {
    double _screenHeight = MediaQuery.of(context).size.height; //lee el largo del dispositivo
    double _responsiveHeight = _screenHeight / _values.defaultDivisionForResponsiveHeight; //Función para altura responsiva de cada card en la lista

    List<Widget> _portraitScreenWidgets = List(), _landscapeScreenWidgets = List();

    if(widget.user.masterAdmin == true){
      _tabs = [
        Tab(text: 'Menú'),
        Tab(text: 'Administradores',)
      ];

      _portraitScreenWidgets = [
        SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Column(
                children: <Widget>[
                  ListView.builder(
                      controller: _scrollController,
                      shrinkWrap: true,
                      itemCount: _values.menuOptions.length,
                      itemBuilder: (BuildContext context, int index){
                        return GestureDetector(
                          child: Card(
                            elevation: _values.cardElevation,
                            child: Container(
                              height: _responsiveHeight / 5,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    _values.menuOptions[index],
                                    style: _values.titleTextStyle,
                                  ),
                                  Icon(Icons.arrow_forward_ios)
                                ],
                              ),
                            ),
                          ),
                          onTap: (){
                            switch(index){
                              case 0:
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ScheduleScreen()
                                    )
                                );
                                break;
                              case 1:
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AgendaScreen()
                                    )
                                );
                                break;
                              case 2:
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AdministrationScreen()
                                    )
                                );
                                break;
                              case 3:
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => GradesScreen()
                                    )
                                );
                                break;
                              case 4:
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AnnouncementsScreen(adminView: true,)
                                    )
                                );
                                break;
                              case 5:
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => EventsScreen(adminView: true,)
                                    )
                                );
                                break;
                              case 6:
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => NewsScreen(adminView: true,)
                                    )
                                );
                                break;
                            }
                          },
                        );
                      }
                  ),
                ],
              )
            ],
          ),
        ),
        StreamBuilder(
          stream: _values.firestoreReference.collection('admins').where('admin', isEqualTo: true).snapshots(),
          builder: (context, snapshot){
            if(!snapshot.hasData){
              return Image.asset(
                  _values.loadingAnimation
              );
            }
            return new ListView.builder(
                controller: _scrollController,
                shrinkWrap: false,
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index){
                  DocumentSnapshot ds = snapshot.data.documents[index];

                  return new Container(
                    color: _hue.outlines,
                    padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 3.0),
                    child: Container(
                      color: _hue.background,
                      child: ListTile(
                        title: Container(
                          alignment: Alignment.centerLeft,
                          child: Text(ds['nickname']),
                        ),
                        subtitle: Container(
                          alignment: Alignment.centerLeft,
                          child: Text(ds['email']),
                        ),
                        trailing: Column(
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                  color: _hue.carmesi,
                                  borderRadius: BorderRadius.circular(_values.standardBorderRadius)
                              ),
                              child: IconButton(
                                icon: Icon(
                                  Icons.delete,
                                  color: _hue.background,
                                ),
                                onPressed: (){
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) => CustomAlertDialog(
                                        description: ds['nickname'] + " se eliminará de forma permanente como administrador ¿Está seguro?",
                                        acceptButtonText: "Sí",
                                        cancelButtonText: "No",
                                      )
                                  ).then((response){
                                    if(response){
                                      User admin = new User(ds['idAuth'], ds.documentID, ds['nickname'], ds['email'], ds['admin'], ds['masterAdmin']);

                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) => CustomLoadDialog()
                                      );

                                      admin.DestroyAdmin(context).then((result){
                                        if(result){
                                          Navigator.of(context).pop();
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) => CustomDialog(
                                                description: "El administrador se ha eliminado exitosamente.",
                                                acceptButtonText: "Genial",
                                              )
                                          );
                                        }
                                      });
                                    }
                                  });
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                }
            );
          },
        )
      ];

      _landscapeScreenWidgets = [
        SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Column(
                children: <Widget>[
                  ListView.builder(
                      controller: _scrollController,
                      shrinkWrap: true,
                      itemCount: _values.menuOptions.length,
                      itemBuilder: (BuildContext context, int index){
                        return GestureDetector(
                          child: Card(
                            elevation: _values.cardElevation,
                            child: Container(
                              height: _responsiveHeight / 2.5,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    _values.menuOptions[index],
                                    style: _values.titleTextStyle,
                                  ),
                                  Icon(Icons.arrow_forward_ios)
                                ],
                              ),
                            ),
                          ),
                          onTap: (){
                            switch(index){
                              case 0:
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ScheduleScreen()
                                    )
                                );
                                break;
                              case 1:
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AgendaScreen()
                                    )
                                );
                                break;
                              case 2:
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AdministrationScreen()
                                    )
                                );
                                break;
                              case 3:
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => GradesScreen()
                                    )
                                );
                                break;
                              case 4:
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AnnouncementsScreen(adminView: true,)
                                    )
                                );
                                break;
                              case 5:
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => EventsScreen(adminView: true,)
                                    )
                                );
                                break;
                              case 6:
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => NewsScreen(adminView: true,)
                                    )
                                );
                                break;
                            }
                          },
                        );
                      }
                  ),
                ],
              )
            ],
          ),
        ),
        StreamBuilder(
          stream: _values.firestoreReference.collection('admins').where('admin', isEqualTo: true).snapshots(),
          builder: (context, snapshot){
            if(!snapshot.hasData){
              return Image.asset(
                  _values.loadingAnimation
              );
            }
            return new ListView.builder(
                controller: _scrollController,
                shrinkWrap: false,
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index){
                  DocumentSnapshot ds = snapshot.data.documents[index];

                  return new Container(
                    color: _hue.outlines,
                    padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 3.0),
                    child: Container(
                      color: _hue.background,
                      child: ListTile(
                        title: Container(
                          alignment: Alignment.centerLeft,
                          child: Text(ds['nickname']),
                        ),
                        subtitle: Container(
                          alignment: Alignment.centerLeft,
                          child: Text(ds['email']),
                        ),
                        trailing: Column(
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                  color: _hue.carmesi,
                                  borderRadius: BorderRadius.circular(_values.standardBorderRadius)
                              ),
                              child: IconButton(
                                icon: Icon(
                                  Icons.delete,
                                  color: _hue.background,
                                ),
                                onPressed: (){
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) => CustomAlertDialog(
                                        description: ds['nickname'] + " se eliminará de forma permanente como administrador ¿Está seguro?",
                                        acceptButtonText: "Sí",
                                        cancelButtonText: "No",
                                      )
                                  ).then((response){
                                    if(response){
                                      User admin = new User(ds['idAuth'], ds.documentID, ds['nickname'], ds['email'], ds['admin'], ds['masterAdmin']);

                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) => CustomLoadDialog()
                                      );

                                      admin.DestroyAdmin(context).then((result){
                                        if(result){
                                          Navigator.of(context).pop();
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) => CustomDialog(
                                                description: "El administrador se ha eliminado exitosamente.",
                                                acceptButtonText: "Genial",
                                              )
                                          );
                                        }
                                      });
                                    }
                                  });
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                }
            );
          },
        )
      ];
    }

    if(widget.user.admin == true){
      _tabs = [
        Tab(text: 'Menú'),
      ];

      _portraitScreenWidgets = [
        SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Column(
                children: <Widget>[
                  ListView.builder(
                      controller: _scrollController,
                      shrinkWrap: true,
                      itemCount: _values.menuOptions.length,
                      itemBuilder: (BuildContext context, int index){
                        return GestureDetector(
                          child: Card(
                            elevation: _values.cardElevation,
                            child: Container(
                              height: _responsiveHeight / 5,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    _values.menuOptions[index],
                                    style: _values.titleTextStyle,
                                  ),
                                  Icon(Icons.arrow_forward_ios)
                                ],
                              ),
                            ),
                          ),
                          onTap: (){
                            switch(index){
                              case 0:
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ScheduleScreen()
                                    )
                                );
                                break;
                              case 1:
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AgendaScreen()
                                    )
                                );
                                break;
                              case 2:
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AdministrationScreen()
                                    )
                                );
                                break;
                              case 3:
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => GradesScreen()
                                    )
                                );
                                break;
                              case 4:
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AnnouncementsScreen(adminView: true,)
                                    )
                                );
                                break;
                              case 5:
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => EventsScreen(adminView: true,)
                                    )
                                );
                                break;
                              case 6:
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => NewsScreen(adminView: true,)
                                    )
                                );
                                break;
                            }
                          },
                        );
                      }
                  ),
                ],
              )
            ],
          ),
        )
      ];

      _landscapeScreenWidgets = [
        SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Column(
                children: <Widget>[
                  ListView.builder(
                      controller: _scrollController,
                      shrinkWrap: true,
                      itemCount: _values.menuOptions.length,
                      itemBuilder: (BuildContext context, int index){
                        return GestureDetector(
                          child: Card(
                            elevation: _values.cardElevation,
                            child: Container(
                              height: _responsiveHeight / 2.5,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    _values.menuOptions[index],
                                    style: _values.titleTextStyle,
                                  ),
                                  Icon(Icons.arrow_forward_ios)
                                ],
                              ),
                            ),
                          ),
                          onTap: (){
                            switch(index){
                              case 0:
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ScheduleScreen()
                                    )
                                );
                                break;
                              case 1:
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AgendaScreen()
                                    )
                                );
                                break;
                              case 2:
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AdministrationScreen()
                                    )
                                );
                                break;
                              case 3:
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => GradesScreen()
                                    )
                                );
                                break;
                              case 4:
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AnnouncementsScreen(adminView: true,)
                                    )
                                );
                                break;
                              case 5:
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => EventsScreen(adminView: true,)
                                    )
                                );
                                break;
                              case 6:
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => NewsScreen(adminView: true,)
                                    )
                                );
                                break;
                            }
                          },
                        );
                      }
                  ),
                ],
              )
            ],
          ),
        )
      ];
    }

    return new WillPopScope(
        child: OrientationBuilder(
          builder: (context, orientation){
            return orientation == Orientation.portrait
                ?
            Scaffold(
              key: _scaffoldKey,
              appBar: AppBar(
                leading: IconButton(
                    icon: Icon(
                      Icons.list,
                      color: _hue.background,
                      size: _values.toolbarIconSize,
                    ),
                    onPressed: (){
                      _scaffoldKey.currentState.openDrawer();
                    },
                    tooltip: 'Opciones'
                ),
                backgroundColor: _hue.carmesi,
                title: Text('Administrador'),
                bottom: TabBar(
                  controller: _tabController,
                  tabs: _tabs,
                ),
                actions: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.close,
                      size: _values.toolbarIconSize,
                    ),
                    tooltip: 'Cerrar sesión',
                    onPressed: (){
                      Navigator.pop(context);
                    },
                  ),
                  Container(
                    width: 15.0,
                  )
                ],
              ),
              drawer: Drawer(
                child: ListView(
                  children: <Widget>[
                    DrawerHeader(
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              widget.user.nickname,
                              textAlign: TextAlign.center,
                              style: _values.titleTextStyle,
                            ),
                          ),
                          SizedBox(height: _values.smallSizedBoxStandardHeight,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                child: _mailUpdateEntry,
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.edit,
                                  color: _hue.outlines,
                                ),
                                tooltip: "Editar correo",
                                onPressed: (){
                                  if(_editingMailState){
                                    FocusScope.of(context).requestFocus(FocusNode());
                                    setState(() {
                                      _mailUpdateEntry = Text(
                                        _mailUpdateController.text,
                                        textAlign: TextAlign.center,
                                        style: _values.contentTextStyle,
                                      );
                                      _editingMailState = false;
                                    });
                                  }else{
                                    setState(() {
                                      _mailUpdateEntry = TextFormField(
                                        controller: _mailUpdateController,
                                        decoration: new InputDecoration(
                                            labelText: "Correo",
                                            labelStyle: TextStyle(color: _hue.outlines),
                                            fillColor: Colors.white,
                                            filled: true,
                                            border: new OutlineInputBorder(
                                              borderRadius: new BorderRadius.circular(_values.standardBorderRadius),
                                              borderSide: new BorderSide(
                                                color: _hue.outlines,
                                              ),
                                            ),
                                            focusedBorder: new OutlineInputBorder(
                                                borderRadius: new BorderRadius.circular(_values.standardBorderRadius),
                                                borderSide: new BorderSide(
                                                    color: _hue.outlines
                                                )
                                            )
                                        ),
                                        validator: (val) {
                                          if(val.length==0) {
                                            return "Este campo no puede estar vacío.";
                                          }else{
                                            return null;
                                          }
                                        },
                                        keyboardType: TextInputType.emailAddress,
                                        style: new TextStyle(
                                          fontFamily: "Poppins",
                                        ),
                                        onEditingComplete: (){
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) => CustomFormDialog(
                                                  description: "Por términos de seguridad, introduzca su contraseña.",
                                                  acceptButtonText: "Cambiar",
                                                  cancelButtonText: "Cancelar",
                                                  dialogPurpose: _values.dialogPurposes['Cambiar correo']
                                              )
                                          ).then((pass){
                                            widget.user.UpdateEmail(pass, _mailUpdateController.text).then((result){
                                              if(result){
                                                showDialog(
                                                    context: context,
                                                    builder: (BuildContext context) => CustomDialog(
                                                      description: "Su correo se a actualizado con éxito.",
                                                      acceptButtonText: "Genial",
                                                    )
                                                );
                                                setState(() {
                                                  widget.user.email = _mailUpdateController.text;
                                                });
                                              }else{
                                                showDialog(
                                                    context: context,
                                                    builder: (BuildContext context) => CustomDialog(
                                                      description: "Ocurrió un problema con la actualización, intente más tarde",
                                                      acceptButtonText: "Aceptar",
                                                    )
                                                );
                                                setState(() {
                                                  _mailUpdateController.text = widget.user.email;
                                                });
                                              }
                                              setState(() {
                                                _mailUpdateEntry = Text(
                                                  _mailUpdateController.text,
                                                  textAlign: TextAlign.center,
                                                  style: _values.contentTextStyle,
                                                );
                                                _editingMailState = false;
                                              });
                                            });
                                          });
                                        },
                                      );
                                      _editingMailState = true;
                                    });
                                  }
                                },
                              )
                            ],
                          )
                        ],
                      ),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                color: _hue.carmesi,
                                width: 3.0,
                              )
                          )
                      ),
                    ),
                    ListTile(
                      leading: Text(
                        "Cerrar sesión",
                        style: _values.contentTextStyle,
                      ),
                      trailing: Icon(
                        Icons.close,
                        color: _hue.outlines,
                      ),
                      onTap: (){
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      },
                    ),
                    ListTile(
                      leading: Text(
                        "Cerrar menú",
                        style: _values.contentTextStyle,
                      ),
                      trailing: Icon(
                        Icons.keyboard_return,
                        color: _hue.outlines,
                      ),
                      onTap: (){
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                ),
              ),
              backgroundColor: _hue.background,
              body: TabBarView(
                controller: _tabController,
                children: _portraitScreenWidgets,
              ),
              floatingActionButton: Stack(
                children: <Widget>[
                  Positioned(
                    left: _position.dx,
                    top:  _position.dy,
                    child: Draggable(
                      feedback: Container(
                        child: _floatingActionButton,
                      ),
                      child: Container(
                        child: _floatingActionButton,
                      ),
                      childWhenDragging: Container(),
                      onDragEnd: (details){
                        setState(() {
                          _position = details.offset;
                        });
                      },
                    ),
                  )
                ],
              ),
            )
                :
            Scaffold(
              key: _scaffoldKey,
              appBar: AppBar(
                leading: IconButton(
                    icon: Icon(
                      Icons.list,
                      color: _hue.background,
                      size: _values.toolbarIconSize,
                    ),
                    onPressed: (){
                      _scaffoldKey.currentState.openDrawer();
                    },
                    tooltip: 'Opciones'
                ),
                backgroundColor: _hue.carmesi,
                title: Text('Administrador'),
                bottom: TabBar(
                  controller: _tabController,
                  tabs: _tabs,
                ),
                actions: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.close,
                      size: _values.toolbarIconSize,
                    ),
                    tooltip: 'Cerrar sesión',
                    onPressed: (){
                      Navigator.pop(context);
                    },
                  ),
                  Container(
                    width: 15.0,
                  )
                ],
              ),
              drawer: Drawer(
                child: ListView(
                  children: <Widget>[
                    DrawerHeader(
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              widget.user.nickname,
                              textAlign: TextAlign.center,
                              style: _values.titleTextStyle,
                            ),
                          ),
                          SizedBox(height: _values.smallSizedBoxStandardHeight,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                child: _mailUpdateEntry,
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.edit,
                                  color: _hue.outlines,
                                ),
                                tooltip: "Editar correo",
                                onPressed: (){
                                  if(_editingMailState){
                                    FocusScope.of(context).requestFocus(FocusNode());
                                    setState(() {
                                      _mailUpdateEntry = Text(
                                        _mailUpdateController.text,
                                        textAlign: TextAlign.center,
                                        style: _values.contentTextStyle,
                                      );
                                      _editingMailState = false;
                                    });
                                  }else{
                                    setState(() {
                                      _mailUpdateEntry = Expanded(
                                        flex: 1,
                                        child: TextFormField(
                                          controller: _mailUpdateController,
                                          decoration: new InputDecoration(
                                              labelText: "Correo",
                                              labelStyle: TextStyle(color: _hue.outlines),
                                              fillColor: Colors.white,
                                              filled: true,
                                              border: new OutlineInputBorder(
                                                borderRadius: new BorderRadius.circular(_values.standardBorderRadius),
                                                borderSide: new BorderSide(
                                                  color: _hue.outlines,
                                                ),
                                              ),
                                              focusedBorder: new OutlineInputBorder(
                                                  borderRadius: new BorderRadius.circular(_values.standardBorderRadius),
                                                  borderSide: new BorderSide(
                                                      color: _hue.outlines
                                                  )
                                              )
                                          ),
                                          validator: (val) {
                                            if(val.length==0) {
                                              return "Este campo no puede estar vacío.";
                                            }else{
                                              return null;
                                            }
                                          },
                                          keyboardType: TextInputType.emailAddress,
                                          style: new TextStyle(
                                            fontFamily: "Poppins",
                                          ),
                                          onEditingComplete: (){
                                            showDialog(
                                                context: context,
                                                builder: (BuildContext context) => CustomFormDialog(
                                                    description: "Por términos de seguridad, introduzca su contraseña.",
                                                    acceptButtonText: "Cambiar",
                                                    cancelButtonText: "Cancelar",
                                                    dialogPurpose: _values.dialogPurposes['Cambiar correo']
                                                )
                                            ).then((pass){
                                              widget.user.UpdateEmail(pass, _mailUpdateController.text).then((result){
                                                if(result){
                                                  showDialog(
                                                      context: context,
                                                      builder: (BuildContext context) => CustomDialog(
                                                        description: "Su correo se a actualizado con éxito.",
                                                        acceptButtonText: "Genial",
                                                      )
                                                  );
                                                  setState(() {
                                                    widget.user.email = _mailUpdateController.text;
                                                  });
                                                }else{
                                                  showDialog(
                                                      context: context,
                                                      builder: (BuildContext context) => CustomDialog(
                                                        description: "Ocurrió un problema con la actualización, intente más tarde",
                                                        acceptButtonText: "Aceptar",
                                                      )
                                                  );
                                                  setState(() {
                                                    _mailUpdateController.text = widget.user.email;
                                                  });
                                                }
                                                setState(() {
                                                  _mailUpdateEntry = Text(
                                                    _mailUpdateController.text,
                                                    textAlign: TextAlign.center,
                                                    style: _values.contentTextStyle,
                                                  );
                                                  _editingMailState = false;
                                                });
                                              });
                                            });
                                          },
                                        ),
                                      );
                                      _editingMailState = true;
                                    });
                                  }
                                },
                              )
                            ],
                          )
                        ],
                      ),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                color: _hue.carmesi,
                                width: 3.0,
                              )
                          )
                      ),
                    ),
                    ListTile(
                      leading: Text(
                        "Cerrar sesión",
                        style: _values.contentTextStyle,
                      ),
                      trailing: Icon(
                        Icons.close,
                        color: _hue.outlines,
                      ),
                      onTap: (){
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      },
                    ),
                    ListTile(
                      leading: Text(
                        "Cerrar menú",
                        style: _values.contentTextStyle,
                      ),
                      trailing: Icon(
                        Icons.keyboard_return,
                        color: _hue.outlines,
                      ),
                      onTap: (){
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                ),
              ),
              backgroundColor: _hue.background,
              body: TabBarView(
                controller: _tabController,
                children: _landscapeScreenWidgets,
              ),
              floatingActionButton: Stack(
                children: <Widget>[
                  Positioned(
                    left: _position.dx,
                    top:  _position.dy,
                    child: Draggable(
                      feedback: Container(
                        child: _floatingActionButton,
                      ),
                      child: Container(
                        child: _floatingActionButton,
                      ),
                      childWhenDragging: Container(),
                      onDragEnd: (details){
                        setState(() {
                          _position = details.offset;
                        });
                      },
                    ),
                  )
                ],
              ),
            );
          },
        ),
        onWillPop: () => Future.value(false)
    );
  }

  _handleTabSelection() {
      setState(() {
        _tabIndex = _tabController.index; //pasamos el index del tab en el que se encuentra el usuario en ese momento, así le presentamos información específica de cada tab

        switch(_tabIndex){
          case 0:
            _floatingActionButton = null;
            break;
          case 1:
            _floatingActionButton = FloatingActionButton(
              backgroundColor: _hue.ocean,
              child: Icon(Icons.add),
              onPressed: (){
                showDialog(
                    context: context,
                    builder: (BuildContext context) => CustomFormDialog(
                      description: "Introduzca los datos del nuevo administrador.",
                      acceptButtonText: "Registrar",
                      cancelButtonText: "Cancelar",
                      dialogPurpose: _values.dialogPurposes["Crear administrador"],
                    )
                ).then((result){
                  if(result){
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => CustomDialog(
                          description: "Administrador registrado con éxito.",
                          acceptButtonText: "Genial",
                        )
                    );
                  }
                });
              },
            );
            break;
        }

      });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

}