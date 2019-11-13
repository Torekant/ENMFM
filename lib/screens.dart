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

  bool readConnectivityFlag = false;

  static Values values = new Values();
  static Hues hue = new Hues();

  ScrollController _scrollController;

  CalendarController _calendarController;
  Map<DateTime, List<Event>> _calendarEvents;
  ListView _eventListView;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _calendarController = CalendarController();
    _scrollController = new ScrollController();
    _calendarEvents = new Map();
    _eventListView = ListView(shrinkWrap: true,);

  }

  @override
  void didChangeDependencies() async{
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    Event dummyEvent = new Event('', '', '', '', '', '', '', '', '');
    await dummyEvent.RetrieveEvents(context).then((map){
     setState(() {
       _calendarEvents = map;

       DateFormat df = new DateFormat('yyyy-MM-dd');
       String _todaysDate = df.format(DateTime.now());
       if(_calendarEvents.containsKey(DateTime.parse(_todaysDate))){
         _calendarEvents.forEach((dateTime, eventList){
           if(dateTime == DateTime.parse(_todaysDate)){
             _eventListView = ListView.builder(
                 scrollDirection: Axis.vertical,
                 controller: _scrollController,
                 shrinkWrap: true,
                 itemCount: eventList.length,
                 itemBuilder: (context, index){
                   Event ds = eventList[index];

                   Icon _eventIcon;

                   switch(ds.type){
                     case 'ceremonia':
                       _eventIcon = new Icon(
                           Icons.event,
                           size: values.toolbarIconSize,
                           color: hue.outlines
                       );
                       break;
                     case 'exámen':
                       _eventIcon = new Icon(
                           Icons.description,
                           size: values.toolbarIconSize,
                           color: hue.outlines
                       );
                       break;
                     case 'entrega':
                       _eventIcon = new Icon(
                           Icons.assignment_turned_in,
                           size: values.toolbarIconSize,
                           color: hue.outlines
                       );
                       break;
                     default:
                       _eventIcon = new Icon(
                           Icons.event,
                           size: values.toolbarIconSize,
                           color: hue.outlines
                       );
                       break;
                   }

                   return new Container(
                     color: hue.outlines,
                     padding: EdgeInsets.fromLTRB(0.0, 3.0, 0.0, 0.0),
                     child: Container(
                       color: hue.background,
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
                           if(ds.type == values.eventType['ceremony']){
                             Navigator.push(
                                 context,
                                 MaterialPageRoute(
                                     builder: (context) => EventScreen(event: ds, adminView: false,)
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
    });
  }

  @override
  Widget build(BuildContext context) {

    double _screenWidth = MediaQuery.of(context).size.width; //lee el ancho de dispositivo
    double _screenHeight = MediaQuery.of(context).size.height; //lee el largo del dispositivo

    double _responsiveHeight = _screenHeight / values.defaultDivisionForResponsiveHeight; //Función para altura responsiva de cada card en la lista


    return WillPopScope( //Este widget nos permite describir el proceso de stack de las pantallas, principalmente el que pueda o no salir del stack de la aplicación
        child: DefaultTabController(
          length: 2,
          child: OrientationBuilder(
            builder: (context, orientation){
              return orientation == Orientation.portrait
                  ?
              Scaffold(
                  appBar: AppBar(
                    backgroundColor: hue.carmesi,
                    title: Text("Inicio"),
                    bottom: TabBar(
                      tabs: <Widget>[
                        Tab(text: 'ENMFM',),
                        Tab(text: 'Calendario',)
                      ],
                    ),
                    actions: <Widget>[
                      IconButton(
                        icon: Icon(
                          Icons.assignment_ind,
                          size: values.toolbarIconSize,
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
                        width: values.containerWidth,
                      )
                    ],
                  ),
                  body: TabBarView(
                    children: <Widget>[
                      SingleChildScrollView(
                        controller: _scrollController,
                        scrollDirection: Axis.vertical,
                        child: Column(
                          children: <Widget>[
                            Image.asset(
                              values.enmfmBuilding,
                              fit: BoxFit.cover,
                              height: _responsiveHeight / 1.3,
                            ),
                            SizedBox(height: values.smallSizedBoxStandardHeight,),
                            Container(
                              width: _screenWidth / 1.2,
                              child: Text(
                                values.welcomeText,
                                style: values.plainTextStyle,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(height: values.smallSizedBoxStandardHeight,),
                            /*MaterialButton(
                          elevation: values.buttonElevation,
                          minWidth: _screenWidth / 1.5,
                          padding: EdgeInsets.fromLTRB(values.standardPaddingLeft, values.standardPaddingTop, values.standardPaddingRight, values.standardPaddingBottom),
                          color: Colors.transparent,
                          textColor: hue.carmesi,
                          child: Text(
                            "Ir a página web",
                            textAlign: TextAlign.center,
                            style: values.materialButtonBoldTextStyle,
                          ),
                          onPressed: (){
                            LaunchURL(values.urlWebPage);
                          },
                        )*/
                            FlatButton(
                              textColor: hue.carmesi,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text("Ir a página web"),
                                  Icon(
                                    Icons.launch,
                                    color: hue.carmesi,
                                  )
                                ],
                              ),
                              onPressed: (){
                                LaunchURL(values.urlWebPage);
                              },
                            )
                          ],
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          TableCalendar(
                            startingDayOfWeek: StartingDayOfWeek.monday,
                            formatAnimation: FormatAnimation.scale,
                            calendarController: _calendarController,
                            locale: 'es',
                            initialSelectedDay: DateTime.now(),
                            calendarStyle: CalendarStyle(
                              canEventMarkersOverflow: false,
                              markersAlignment: Alignment.bottomCenter,
                              markersColor: hue.carmesi,
                              markersMaxAmount: 5,
                              outsideDaysVisible: true,
                              todayColor: hue.ocean,
                              weekdayStyle: values.calendarDayTextStyle,
                              weekendStyle: values.calendarWeekendDayTextStyle,
                            ),
                            headerStyle: HeaderStyle(
                                centerHeaderTitle: true,
                                formatButtonShowsNext: false,
                                titleTextStyle: values.contentTextStyle,
                                formatButtonVisible: false
                            ),
                            onDaySelected: (day, events){
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
                                              size: values.toolbarIconSize,
                                              color: hue.outlines
                                          );
                                          break;
                                        case 'exámen':
                                          _eventIcon = new Icon(
                                              Icons.description,
                                              size: values.toolbarIconSize,
                                              color: hue.outlines
                                          );
                                          break;
                                        case 'entrega':
                                          _eventIcon = new Icon(
                                              Icons.assignment_turned_in,
                                              size: values.toolbarIconSize,
                                              color: hue.outlines
                                          );
                                          break;
                                        default:
                                          _eventIcon = new Icon(
                                              Icons.event,
                                              size: values.toolbarIconSize,
                                              color: hue.outlines
                                          );
                                          break;
                                      }

                                      return new Container(
                                        color: hue.outlines,
                                        padding: EdgeInsets.fromLTRB(0.0, 3.0, 0.0, 0.0),
                                        child: Container(
                                          color: hue.background,
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
                                              if(ds.type == values.eventType['ceremony']){
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) => EventScreen(event: ds, adminView: false,)
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
                          SizedBox(height: values.mediumSizedBoxStandardHeight,),
                          Expanded(child: _eventListView,)
                        ],
                      )
                    ],
                  )
              )
                  :
              Scaffold(
                  appBar: AppBar(
                    backgroundColor: hue.carmesi,
                    title: Text("Inicio"),
                    bottom: TabBar(
                      tabs: <Widget>[
                        Tab(text: 'ENMFM',),
                        Tab(text: 'Calendario',)
                      ],
                    ),
                    actions: <Widget>[
                      IconButton(
                        icon: Icon(
                          Icons.assignment_ind,
                          size: values.toolbarIconSize,
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
                        width: values.containerWidth,
                      )
                    ],
                  ),
                  body: TabBarView(
                    children: <Widget>[
                      SingleChildScrollView(
                        controller: _scrollController,
                        scrollDirection: Axis.vertical,
                        child: Column(
                          children: <Widget>[
                            Parallax.inside(
                              child: Image.asset(
                                values.enmfmBuilding,
                                fit: BoxFit.cover,
                                height: _responsiveHeight / 1.1,
                                width: _screenWidth,
                              ),
                              mainAxisExtent: _responsiveHeight / 1.3),
                            SizedBox(height: values.smallSizedBoxStandardHeight,),
                            Container(
                              width: _screenWidth / 1.2,
                              child: Text(
                                values.welcomeText,
                                style: values.plainTextStyle,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(height: values.smallSizedBoxStandardHeight,),
                            /*MaterialButton(
                          elevation: values.buttonElevation,
                          minWidth: _screenWidth / 1.5,
                          padding: EdgeInsets.fromLTRB(values.standardPaddingLeft, values.standardPaddingTop, values.standardPaddingRight, values.standardPaddingBottom),
                          color: Colors.transparent,
                          textColor: hue.carmesi,
                          child: Text(
                            "Ir a página web",
                            textAlign: TextAlign.center,
                            style: values.materialButtonBoldTextStyle,
                          ),
                          onPressed: (){
                            LaunchURL(values.urlWebPage);
                          },
                        )*/
                            FlatButton(
                              textColor: hue.carmesi,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text("Ir a página web"),
                                  Icon(
                                    Icons.launch,
                                    color: hue.carmesi,
                                  )
                                ],
                              ),
                              onPressed: (){
                                LaunchURL(values.urlWebPage);
                              },
                            )
                          ],
                        ),
                      ),
                      SingleChildScrollView(
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
                                markersColor: hue.carmesi,
                                markersMaxAmount: 5,
                                outsideDaysVisible: true,
                                todayColor: hue.ocean,
                                weekdayStyle: values.calendarDayTextStyle,
                                weekendStyle: values.calendarWeekendDayTextStyle,
                              ),
                              headerStyle: HeaderStyle(
                                  centerHeaderTitle: true,
                                  formatButtonShowsNext: false,
                                  titleTextStyle: values.contentTextStyle,
                                  formatButtonVisible: false
                              ),
                              onDaySelected: (day, events){
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
                                                size: values.toolbarIconSize,
                                                color: hue.outlines
                                            );
                                            break;
                                          case 'exámen':
                                            _eventIcon = new Icon(
                                                Icons.description,
                                                size: values.toolbarIconSize,
                                                color: hue.outlines
                                            );
                                            break;
                                          case 'entrega':
                                            _eventIcon = new Icon(
                                                Icons.assignment_turned_in,
                                                size: values.toolbarIconSize,
                                                color: hue.outlines
                                            );
                                            break;
                                          default:
                                            _eventIcon = new Icon(
                                                Icons.event,
                                                size: values.toolbarIconSize,
                                                color: hue.outlines
                                            );
                                            break;
                                        }

                                        return new Container(
                                          color: hue.outlines,
                                          padding: EdgeInsets.fromLTRB(0.0, 3.0, 0.0, 0.0),
                                          child: Container(
                                            color: hue.background,
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
                                                if(ds.type == values.eventType['ceremony']){
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) => EventScreen(event: ds, adminView: false,)
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
                            SizedBox(height: values.mediumSizedBoxStandardHeight,),
                            _eventListView
                          ],
                        ),
                      )
                    ],
                  )
              );
            },
          ),
        ),
        onWillPop: () => Future.value(false) //Esta línea es la que previene que una pantalla pueda regresar a la anterior
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _calendarController.dispose();
    super.dispose();
  }

}

class EventScreen extends StatefulWidget {
  EventScreen({Key key, this.event, this.adminView, this.newEventDateTime}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final Event event;
  final bool adminView;
  final DateTime newEventDateTime;

  @override
  _EventScreen createState() => _EventScreen();
}

class _EventScreen extends State<EventScreen>{

  static Values values = new Values();
  static Hues hue = new Hues();

  ScrollController _scrollController = new ScrollController();

  String spanishFormattedText = " ", dateNewEvent, timeNewEvent;

  Widget floatingButton, imageWidget;
  Offset _position = Offset(20.0, 20.0);

  var imageNewEvent, passedDependencies = false;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if(widget.event.id == null){
      widget.event.title = "";
      widget.event.place = "";
      widget.event.host = "";
      widget.event.description = "";
      widget.event.time = "00:00";
      DateFormat df = new DateFormat('yyyy-MM-dd');
      widget.event.date = df.format(DateTime.now());
      spanishFormattedText = BuildEventDayText(df.format(widget.newEventDateTime));
    }
  }

  @override
  void didChangeDependencies() async{
    super.didChangeDependencies();

    double _screenWidth = MediaQuery.of(context).size.width; //lee el ancho de dispositivo
    double _screenHeight = MediaQuery.of(context).size.height; //lee el largo del dispositivo

    _position = Offset(_screenWidth / 1.2, _screenHeight / 1.1);

    if(widget.event.image == null){

      if(passedDependencies == false){
        await getImageFileFromAssets("place.jpg").then((file){
          setState(() {
            imageNewEvent = file;
          });
        });

        passedDependencies = true;
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    double _screenWidth = MediaQuery.of(context).size.width; //lee el ancho de dispositivo
    double _screenHeight = MediaQuery.of(context).size.height; //lee el largo del dispositivo
    //double _symmetricPadding; //padding lateral de la pantalla

    //_symmetricPadding =  (_screenWidth * values.widthPaddingUnit) / 10; //Función que nos permite hacer un padding responsivo a cualquier resolución en ancho
    double _responsiveheight = _screenHeight / 2.2; //Función para altura responsiva de cada card en la lista

    // TODO: implement build
    double _symmetricPadding = 30.0; //padding lateral de la pantalla

    _symmetricPadding =  (_screenWidth * values.widthPaddingUnit) / 10; //Función que nos permite hacer un padding responsivo a cualquier resolución en ancho

    if(widget.event.id != null){
      spanishFormattedText = BuildEventDayText(widget.event.date);
    }

    Widget widgetColumn;

    if(widget.adminView == true){
      if(widget.event.id != null){
        TextEditingController _titleTextController = new TextEditingController(text: widget.event.title);
        TextEditingController _placeTextController = new TextEditingController(text: widget.event.place);
        TextEditingController _hostTextController = new TextEditingController(text: widget.event.host);
        TextEditingController _descriptionTextController = new TextEditingController(text: widget.event.description);


        widgetColumn = Column(
          children: <Widget>[
            Container(
                alignment: values.centerAlignment,
                child: Stack(
                  children: <Widget>[
                    Parallax.inside(
                        child: CachedNetworkImage(
                          imageUrl: widget.event.image,
                          placeholder: (context, url) => Image.asset(values.loadingAnimation, fit: BoxFit.fill, width: double.maxFinite, height: _responsiveheight,),
                          errorWidget: (context,url,error) => new Icon(Icons.error),
                          width: double.maxFinite,
                          height: _responsiveheight * 1.1,
                          fit: BoxFit.cover,
                        ),
                        mainAxisExtent: _responsiveheight / 1.1
                    ),
                    Container(
                      color: hue.background,
                      child: IconButton(
                          icon: Icon(
                            Icons.cached,
                            color: hue.outlines,
                          ),
                          iconSize: 30.0,
                          tooltip: values.tooltipChangeEventImage,
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
            SizedBox(height: values.smallSizedBoxStandardHeight,),
            Container(
              child: TextField(
                controller: _titleTextController,
                decoration: new InputDecoration(
                    labelText: "Título",
                    labelStyle: values.textFieldTextStyle,
                    fillColor: Colors.white,
                    filled: true,
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(values.standardBorderRadius),
                      borderSide: new BorderSide(
                      ),
                    ),
                    focusedBorder: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(values.standardBorderRadius),
                        borderSide: values.textFieldFocusBorderSide
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
                style: values.textFieldTextStyle,
              ),
            ),
            SizedBox(height: values.smallSizedBoxStandardHeight,),
            Container(
              alignment: Alignment.centerLeft,
              child: TextField(
                controller: _placeTextController,
                decoration: new InputDecoration(
                    labelText: "Lugar",
                    labelStyle: values.textFieldTextStyle,
                    fillColor: Colors.white,
                    filled: true,
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(values.standardBorderRadius),
                      borderSide: new BorderSide(
                      ),
                    ),
                    focusedBorder: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(values.standardBorderRadius),
                        borderSide: values.textFieldFocusBorderSide
                    )
                  //fillColor: Colors.green
                ),
                style: values.textFieldTextStyle,
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
            SizedBox(height: values.smallSizedBoxStandardHeight,),
            Container(
                alignment: Alignment.centerLeft,
                child: new Row(
                  children: <Widget>[
                    Text(
                      "Día: " + spanishFormattedText,
                      style: values.subtitleTextStyle,
                    ),
                    IconButton(
                      tooltip: "Cambiar fecha",
                      icon: Icon(
                        Icons.calendar_today,
                        color: hue.outlines,
                      ),
                      color: hue.outlines,
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
            SizedBox(height: values.smallSizedBoxStandardHeight,),
            Container(
              alignment: Alignment.centerLeft,
              child: Row(
                children: <Widget>[
                  Text(
                    "Hora: " + widget.event.time,
                    style: values.subtitleTextStyle,
                  ),
                  IconButton(
                    tooltip: "Cambiar hora",
                    icon: Icon(Icons.access_time),
                    color: hue.outlines,
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
            SizedBox(height: values.smallSizedBoxStandardHeight,),
            Container(
              alignment: values.centerAlignment,
              child: TextField(
                controller: _hostTextController,
                decoration: new InputDecoration(
                    labelText: "Maestro de ceremonias",
                    labelStyle: values.textFieldTextStyle,
                    fillColor: Colors.white,
                    filled: true,
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(values.standardBorderRadius),
                      borderSide: new BorderSide(
                      ),
                    ),
                    focusedBorder: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(values.standardBorderRadius),
                        borderSide: values.textFieldFocusBorderSide
                    )
                  //fillColor: Colors.green
                ),
                style: values.textFieldTextStyle,
                onEditingComplete: (){
                  widget.event.UpdateEvent(_hostTextController.text, 'host').then((updatedHost){
                    setState(() {
                      widget.event.host = updatedHost;
                    });
                  });
                  FocusScope.of(context).requestFocus(FocusNode());
                },
              ),
            ),
            SizedBox(height: values.smallSizedBoxStandardHeight,),
            Container(
              alignment: values.centerAlignment,
              child: TextField(
                controller: _descriptionTextController,
                maxLines: null,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
                decoration: new InputDecoration(
                    labelText: "Descripción",
                    labelStyle: values.textFieldTextStyle,
                    fillColor: Colors.white,
                    filled: true,
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(values.standardBorderRadius),
                      borderSide: new BorderSide(
                      ),
                    ),
                    focusedBorder: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(values.standardBorderRadius),
                        borderSide: values.textFieldFocusBorderSide
                    )
                  //fillColor: Colors.green
                ),
                style: values.textFieldTextStyle,
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

        floatingButton = new FloatingActionButton(
          tooltip: "Eliminar evento",
          backgroundColor: hue.carmesi,
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
        TextEditingController _hostTextController = new TextEditingController(text: widget.event.host);
        TextEditingController _descriptionTextController = new TextEditingController(text: widget.event.description);

        if(imageNewEvent == null){
          imageWidget = new Image.asset(
            values.defaultPlace,
            fit: BoxFit.cover,
            width: double.maxFinite,
            height: _responsiveheight * 1.1,
          );
        }else{
          imageWidget = new Image.file(
            imageNewEvent,
            fit: BoxFit.cover,
            width: double.maxFinite,
            height: _responsiveheight * 1.1,
          );
        }

        widgetColumn = Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Container(
                  alignment: values.centerAlignment,
                  child: Stack(
                    children: <Widget>[
                      Parallax.inside(
                          child: imageWidget,
                          mainAxisExtent: _responsiveheight / 1.1
                      ),
                      Container(
                        color: hue.background,
                        child: IconButton(
                            icon: Icon(
                              Icons.cached,
                              color: hue.outlines,
                            ),
                            iconSize: 30.0,
                            tooltip: values.tooltipChangeEventImage,
                            onPressed: ()async{
                              var image = await ImagePicker.pickImage(source: ImageSource.gallery);
                              setState((){
                                imageNewEvent = image;
                              });
                            }
                        ),
                      )
                    ],
                  )
              ),
              SizedBox(height: values.smallSizedBoxStandardHeight,),
              Container(
                child: TextFormField(
                  controller: _titleTextController,
                  decoration: new InputDecoration(
                      labelText: "Título",
                      labelStyle: values.textFieldTextStyle,
                      fillColor: Colors.white,
                      filled: true,
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(values.standardBorderRadius),
                        borderSide: new BorderSide(
                        ),
                      ),
                      focusedBorder: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(values.standardBorderRadius),
                          borderSide: values.textFieldFocusBorderSide
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
                    _titleTextController.selection = TextSelection.collapsed(offset: _titleTextController.text.length);
                    widget.event.title = _titleTextController.text;
                  },
                  style: values.textFieldTextStyle,
                ),
              ),
              SizedBox(height: values.smallSizedBoxStandardHeight,),
              Container(
                alignment: Alignment.centerLeft,
                child: TextFormField(
                  controller: _placeTextController,
                  decoration: new InputDecoration(
                      labelText: "Lugar",
                      labelStyle: values.textFieldTextStyle,
                      fillColor: Colors.white,
                      filled: true,
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(values.standardBorderRadius),
                        borderSide: new BorderSide(
                        ),
                      ),
                      focusedBorder: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(values.standardBorderRadius),
                          borderSide: values.textFieldFocusBorderSide
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
                    _placeTextController.selection = TextSelection.collapsed(offset: _placeTextController.text.length);
                    widget.event.place = _placeTextController.text;
                  },
                  style: values.textFieldTextStyle,
                ),
              ),
              SizedBox(height: values.smallSizedBoxStandardHeight,),
              Container(
                  alignment: Alignment.centerLeft,
                  child: new Row(
                    children: <Widget>[
                      Text(
                        "Día: " + spanishFormattedText,
                        style: values.subtitleTextStyle,
                      ),
                      IconButton(
                        tooltip: "Cambiar fecha",
                        icon: Icon(
                          Icons.calendar_today,
                          color: hue.outlines,
                        ),
                        color: hue.outlines,
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
                                  spanishFormattedText = BuildEventDayText(widget.event.date);
                                  dateNewEvent = format;
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
              SizedBox(height: values.smallSizedBoxStandardHeight,),
              Container(
                alignment: Alignment.centerLeft,
                child: Row(
                  children: <Widget>[
                    Text(
                      "Hora: " + widget.event.time,
                      style: values.subtitleTextStyle,
                    ),
                    IconButton(
                      tooltip: "Cambiar hora",
                      icon: Icon(Icons.access_time),
                      color: hue.outlines,
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
                              timeNewEvent = newTime;
                            });
                          },
                          locale: LocaleType.es,
                        );
                      },
                    )
                  ],
                ),
              ),
              SizedBox(height: values.smallSizedBoxStandardHeight,),
              Container(
                alignment: values.centerAlignment,
                child: TextFormField(
                  controller: _hostTextController,
                  decoration: new InputDecoration(
                      labelText: "Maestro de ceremonias",
                      labelStyle: values.textFieldTextStyle,
                      fillColor: Colors.white,
                      filled: true,
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(values.standardBorderRadius),
                        borderSide: new BorderSide(
                        ),
                      ),
                      focusedBorder: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(values.standardBorderRadius),
                          borderSide: values.textFieldFocusBorderSide
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
                      widget.event.host = _hostTextController.text;
                    });
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                  onChanged: (content){
                    _hostTextController.selection = TextSelection.collapsed(offset: _hostTextController.text.length);
                    widget.event.host = _hostTextController.text;
                  },
                  style: values.textFieldTextStyle,
                ),
              ),
              SizedBox(height: values.smallSizedBoxStandardHeight,),
              Container(
                alignment: values.centerAlignment,
                child: TextFormField(
                  controller: _descriptionTextController,
                  maxLines: null,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  decoration: new InputDecoration(
                      labelText: "Descripción",
                      labelStyle: values.textFieldTextStyle,
                      fillColor: Colors.white,
                      filled: true,
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(values.standardBorderRadius),
                        borderSide: new BorderSide(
                        ),
                      ),
                      focusedBorder: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(values.standardBorderRadius),
                          borderSide: values.textFieldFocusBorderSide
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
                    _descriptionTextController.selection = TextSelection.collapsed(offset: _descriptionTextController.text.length);
                    widget.event.description = _descriptionTextController.text;
                  },
                  style: values.textFieldTextStyle,
                ),
              )
            ],
          )
        );

        floatingButton = new FloatingActionButton(
          tooltip: "Guardar evento",
          backgroundColor: hue.ocean,
          child: Icon(Icons.save),
          onPressed: (){
            if(_formKey.currentState.validate()){

              showDialog(
                  context: context,
                builder: (BuildContext context) => CustomLoadDialog()
              );

              widget.event.CreateEvent(context, imageNewEvent).then((result){
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              });

            }
          }
        );
      }
    }else{
      widgetColumn = Column(
        children: <Widget>[
          Container(
              alignment: values.centerAlignment,
              child: Stack(
                children: <Widget>[
                  Parallax.inside(
                      child: CachedNetworkImage(
                        imageUrl: widget.event.image,
                        placeholder: (context, url) => Image.asset(values.loadingAnimation, fit: BoxFit.fill, width: double.maxFinite, height: _responsiveheight,),
                        errorWidget: (context,url,error) => new Icon(Icons.error),
                        width: double.maxFinite,
                        height: _responsiveheight * 1.1,
                        fit: BoxFit.cover,
                      ),
                      mainAxisExtent: _responsiveheight / 1.1
                  ),
                ],
              )
          ),
          SizedBox(height: values.smallSizedBoxStandardHeight,),
          Container(
            child: Text(
              widget.event.title,
              style: values.titleTextStyle,
            ),
          ),
          SizedBox(height: values.smallSizedBoxStandardHeight,),
          Container(
            color: hue.outlines,
            padding: EdgeInsets.fromLTRB(_symmetricPadding * 15, 1.0, _symmetricPadding * 15, 1.0),
            child: SizedBox(height: values.lineSizedBoxHeight,),
          ),
          SizedBox(height: values.smallSizedBoxStandardHeight,),
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              "Lugar: " + widget.event.place,
              style: values.subtitleTextStyle,
            ),
          ),
          SizedBox(height: values.smallSizedBoxStandardHeight,),
          Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "Día: " + spanishFormattedText,
                style: values.subtitleTextStyle,
              )
          ),
          SizedBox(height: values.smallSizedBoxStandardHeight,),
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              "Hora: " + widget.event.time,
              style: values.subtitleTextStyle,
            ),
          ),
          SizedBox(height: values.smallSizedBoxStandardHeight,),
          Container(
            alignment: values.centerAlignment,
            child: Text(
              "Maestro de ceremonias",
              style: values.subtitleTextStyle,
            ),
          ),
          SizedBox(height: values.lineSizedBoxHeight,),
          Container(
            alignment: values.centerAlignment,
            child: Text(
              widget.event.host,
              style: values.subtitleTextStyle,
            ),
          ),
          SizedBox(height: values.smallSizedBoxStandardHeight,),
          Container(
            color: hue.outlines,
            padding: EdgeInsets.fromLTRB(_symmetricPadding * 15, 1.0, _symmetricPadding * 15, 1.0),
            child: SizedBox(height: values.lineSizedBoxHeight,),
          ),
          SizedBox(height: values.smallSizedBoxStandardHeight,),
          Container(
            alignment: values.centerAlignment,
            child: Text(
              widget.event.description,
              style: values.contentTextStyle,
            ),
          )
        ],
      );
    }

    return new Scaffold(
      backgroundColor: hue.background,
      appBar: AppBar(
        backgroundColor: hue.carmesi,
        title: Text("Evento"),
      ),
      floatingActionButton: Stack(
        children: <Widget>[
          Positioned(
            left: _position.dx,
            top:  _position.dy,
            child: Draggable(
              feedback: Container(
                child: floatingButton,
              ),
              child: Container(
                child: floatingButton,
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
          child: widgetColumn,
        ),
      )
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

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  _LoginScreen createState() => _LoginScreen();
}

class _LoginScreen extends State<LoginScreen>{

  Hues hue = new Hues();
  static Values values = new Values();

  TextEditingController idTextController = new TextEditingController(); //Los controladores de texto nos permiten controlar los valores en un inputfield
  TextEditingController passwordTextController = new TextEditingController(); //Los controladores de texto nos permiten controlar los valores en un inputfield
  final _formKey = GlobalKey<FormState>(); //la llave para identificar el form de login


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    double _screenWidth = MediaQuery.of(context).size.width; //lee el ancho de dispositivo
    //double _screenHeight = MediaQuery.of(context).size.height; //lee el largo del dispositivo
    double _symmetricPadding = 30.0; //padding lateral de la pantalla
    _symmetricPadding =  (_screenWidth * values.widthPaddingUnit) / 10; //Función que nos permite hacer un padding responsivo a cualquier resolución en ancho

    final idField = new TextFormField(
      controller: idTextController,
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
      controller: passwordTextController,
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
              Admin user = new Admin('', '', '', '', false, false);

              showDialog(
                  context: context,
                  builder: (BuildContext context) => CustomLoadDialog()
              );

              user.AdminLogin(idTextController.text, passwordTextController.text, context).then((fireUser) async{
                if(fireUser != null){
                  Navigator.of(context).pop();
                  user.idAuth = fireUser.uid;
                  values.firestoreReference.collection('admins').where('email', isEqualTo: fireUser.email).snapshots().listen((data){
                    user.idDB = data.documents[0].documentID;
                    user.nickname = data.documents[0]['nickname'];
                    user.email = data.documents[0]['email'];
                    if(data.documents[0]['masterAdmin'] == true){
                      user.masterAdmin = true;
                      user.admin = false;
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AdminScreen(user: user,),
                          )
                      );
                    }else{
                      user.masterAdmin = false;
                      user.admin = true;
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AdminScreen(user: user,),
                          )
                      );
                    }
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

  final Admin user;

  @override
  _AdminScreen createState() => _AdminScreen();
}

class _AdminScreen extends State<AdminScreen> with SingleTickerProviderStateMixin{

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  static Values values = new Values();
  static Hues hue = new Hues();

  ScrollController _scrollController = new ScrollController();

  int _tabIndex = 0;

   List<Widget> _tabs, _tabViews;
   Widget _eventListTab; //inicialización con columna vacía

  TabController _tabController;

  FloatingActionButton _floatingActionButton;
  Offset _position = Offset(20.0, 20.0);

  Widget _mailUpdateEntry;
  TextEditingController _mailUpdateController = new TextEditingController();
  bool _editingMailState = false;

  CalendarController _calendarController;
  Map<DateTime, List<Event>> _calendarEvents = Map();
  ListView _eventListView = ListView(shrinkWrap: true,);

  @override
  void initState() {
    super.initState();
    if(widget.user.masterAdmin == true){
      _tabController = TabController(vsync: this, length: values.numberOfAdminTabs + 1);
      _floatingActionButton = null;
    }
    if(widget.user.admin == true){
      _tabController = TabController(vsync: this, length: values.numberOfAdminTabs);
      _floatingActionButton = FloatingActionButton(
        backgroundColor: hue.ocean,
        child: Icon(Icons.add),
        onPressed: (){
          switch(_tabIndex){
            case 0:
              Event _event = new Event(null, null, null, null, null, null, null, null, null);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EventScreen(event: _event, adminView: true, newEventDateTime: _calendarController.selectedDay,),
                  )
              );
              break;
          }
        },
      );
    }

    _tabController.addListener(_handleTabSelection);
    _mailUpdateController.text = widget.user.email;
    _mailUpdateEntry = Text(
      _mailUpdateController.text,
      textAlign: TextAlign.center,
      style: values.contentTextStyle,
    );

    _calendarController = CalendarController();

  }

  @override
  void didChangeDependencies() async{
    super.didChangeDependencies();

    double _screenWidth = MediaQuery.of(context).size.width; //lee el ancho de dispositivo
    double _screenHeight = MediaQuery.of(context).size.height; //lee el largo del dispositivo

    _position = Offset(_screenWidth / 1.2, _screenHeight / 1.1);

    Event dummyEvent = new Event('', '', '', '', '', '', '', '', '');
    await dummyEvent.RetrieveEvents(context).then((map){
      setState(() {
        _calendarEvents = map;

        DateFormat df = new DateFormat('yyyy-MM-dd');
        String _todaysDate = df.format(DateTime.now());
        if(_calendarEvents.containsKey(DateTime.parse(_todaysDate))){
          _calendarEvents.forEach((dateTime, eventList){
            if(dateTime == DateTime.parse(_todaysDate)){
              _eventListView = ListView.builder(
                  scrollDirection: Axis.vertical,
                  controller: _scrollController,
                  shrinkWrap: true,
                  itemCount: eventList.length,
                  itemBuilder: (context, index){
                    Event ds = eventList[index];

                    Icon _eventIcon;

                    switch(ds.type){
                      case 'ceremonia':
                        _eventIcon = new Icon(
                            Icons.event,
                            size: values.toolbarIconSize,
                            color: hue.outlines
                        );
                        break;
                      case 'exámen':
                        _eventIcon = new Icon(
                            Icons.description,
                            size: values.toolbarIconSize,
                            color: hue.outlines
                        );
                        break;
                      case 'entrega':
                        _eventIcon = new Icon(
                            Icons.assignment_turned_in,
                            size: values.toolbarIconSize,
                            color: hue.outlines
                        );
                        break;
                      default:
                        _eventIcon = new Icon(
                            Icons.event,
                            size: values.toolbarIconSize,
                            color: hue.outlines
                        );
                        break;
                    }

                    return new Container(
                      color: hue.outlines,
                      padding: EdgeInsets.fromLTRB(0.0, 3.0, 0.0, 0.0),
                      child: Container(
                        color: hue.background,
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
                            if(ds.type == values.eventType['ceremony']){
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => EventScreen(event: ds, adminView: false,)
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
    });

  }

  @override
  Widget build(BuildContext context) {

    _eventListTab = Column(
      children: <Widget>[
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TableCalendar(
                calendarController: _calendarController,
                locale: 'es',
                initialSelectedDay: DateTime.now(),
                calendarStyle: CalendarStyle(
                  canEventMarkersOverflow: false,
                  markersAlignment: Alignment.bottomCenter,
                  markersColor: hue.carmesi,
                  markersMaxAmount: 5,
                  outsideDaysVisible: true,
                  todayColor: hue.ocean,
                  weekdayStyle: values.calendarDayTextStyle,
                  weekendStyle: values.calendarWeekendDayTextStyle,
                ),
                headerStyle: HeaderStyle(
                    centerHeaderTitle: true,
                    formatButtonShowsNext: false,
                    titleTextStyle: values.contentTextStyle,
                    formatButtonVisible: false
                ),
                onDaySelected: (day, events){
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
                                  size: values.toolbarIconSize,
                                  color: hue.outlines
                              );
                              break;
                            case 'exámen':
                              _eventIcon = new Icon(
                                  Icons.description,
                                  size: values.toolbarIconSize,
                                  color: hue.outlines
                              );
                              break;
                            case 'entrega':
                              _eventIcon = new Icon(
                                  Icons.assignment_turned_in,
                                  size: values.toolbarIconSize,
                                  color: hue.outlines
                              );
                              break;
                            default:
                              _eventIcon = new Icon(
                                  Icons.event,
                                  size: values.toolbarIconSize,
                                  color: hue.outlines
                              );
                              break;
                          }

                          return new Container(
                            color: hue.outlines,
                            padding: EdgeInsets.fromLTRB(0.0, 3.0, 0.0, 0.0),
                            child: Container(
                              color: hue.background,
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
                                  if(ds.type == values.eventType['ceremony']){
                                    if(widget.user.admin == true && widget.user.masterAdmin == false){
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => EventScreen(event: ds, adminView: true,)
                                          )
                                      );
                                    }else{
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => EventScreen(event: ds, adminView: false,)
                                          )
                                      );
                                    }
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
              SizedBox(height: values.mediumSizedBoxStandardHeight,),
              Expanded(child: _eventListView,),
            ],
          ),
        )
      ],
    );

    if(widget.user.masterAdmin == true){
      _tabs = [
        Tab(text: 'Eventos'),
        Tab(text: 'Administradores',)
      ];

      _tabViews = [
        _eventListTab,
        StreamBuilder(
          stream: values.firestoreReference.collection('admins').where('admin', isEqualTo: true).snapshots(),
          builder: (context, snapshot){
            if(!snapshot.hasData){
              return Image.asset(
                  values.loadingAnimation
              );
            }
            return new ListView.builder(
                controller: _scrollController,
                shrinkWrap: false,
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index){
                  DocumentSnapshot ds = snapshot.data.documents[index];

                  return new Container(
                    color: hue.outlines,
                    padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 3.0),
                    child: Container(
                      color: hue.background,
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
                                  color: hue.carmesi,
                                  borderRadius: BorderRadius.circular(values.standardBorderRadius)
                              ),
                              child: IconButton(
                                icon: Icon(
                                  Icons.delete,
                                  color: hue.background,
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
                                      Admin admin = new Admin(ds['idAuth'], ds.documentID, ds['nickname'], ds['email'], ds['admin'], ds['masterAdmin']);

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
        Tab(text: 'Eventos'),
      ];

      _tabViews = [
        _eventListTab,
      ];
    }

    return new WillPopScope(
        child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            leading: IconButton(
                icon: Icon(
                  Icons.list,
                  color: hue.background,
                  size: values.toolbarIconSize,
                ),
                onPressed: (){
                  _scaffoldKey.currentState.openDrawer();
                },
              tooltip: 'Opciones'
            ),
            backgroundColor: hue.carmesi,
            title: Text('Administrador'),
            bottom: TabBar(
              controller: _tabController,
              tabs: _tabs,
            ),
            actions: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.close,
                  size: values.toolbarIconSize,
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
                      Text(
                        widget.user.nickname,
                        textAlign: TextAlign.center,
                        style: values.titleTextStyle,
                      ),
                      SizedBox(height: values.smallSizedBoxStandardHeight,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          _mailUpdateEntry,
                          IconButton(
                            icon: Icon(
                              Icons.edit,
                              color: hue.outlines,
                            ),
                            tooltip: "Editar correo",
                            onPressed: (){
                              if(_editingMailState){
                                FocusScope.of(context).requestFocus(FocusNode());
                                setState(() {
                                  _mailUpdateEntry = Text(
                                    _mailUpdateController.text,
                                    textAlign: TextAlign.center,
                                    style: values.contentTextStyle,
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
                                          labelStyle: TextStyle(color: hue.outlines),
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
                                                  color: hue.outlines
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
                                            dialogPurpose: values.dialogPurposes['Cambiar correo']
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
                                                  style: values.contentTextStyle,
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
                        color: hue.carmesi,
                        width: 3.0,
                      )
                    )
                  ),
                ),
                ListTile(
                  leading: Text(
                    "Cerrar sesión",
                    style: values.contentTextStyle,
                  ),
                  trailing: Icon(
                    Icons.close,
                    color: hue.outlines,
                  ),
                  onTap: (){
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  leading: Text(
                    "Cerrar menú",
                    style: values.contentTextStyle,
                  ),
                  trailing: Icon(
                    Icons.keyboard_return,
                    color: hue.outlines,
                  ),
                  onTap: (){
                    Navigator.of(context).pop();
                  },
                )
              ],
            ),
          ),
          backgroundColor: hue.background,
          body: TabBarView(
            controller: _tabController,
            children: _tabViews,
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
        ),
        onWillPop: () => Future.value(false)
    );
  }

  _handleTabSelection() {
      setState(() {
        _tabIndex = _tabController.index;

        if(widget.user.masterAdmin == true){
          switch(_tabIndex){
            case 0:
              _floatingActionButton = null;
              break;
            case 1:
              _floatingActionButton = FloatingActionButton(
                backgroundColor: hue.ocean,
                child: Icon(Icons.add),
                onPressed: (){
                  switch(_tabIndex){
                    case 1:
                      showDialog(
                          context: context,
                          builder: (BuildContext context) => CustomFormDialog(
                            description: "Introduzca los datos del nuevo administrador.",
                            acceptButtonText: "Registrar",
                            cancelButtonText: "Cancelar",
                            dialogPurpose: values.dialogPurposes["Crear administrador"],
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
                      break;
                  }
                },
              );
              break;
          }
        }
      });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _calendarController.dispose();
    super.dispose();
  }

}