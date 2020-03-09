import 'package:enmfm/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'values.dart';
import 'classes.dart';
import 'functions.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:unicorndial/unicorndial.dart';
import 'package:intl/intl.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';

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

  CalendarController _calendarController;
  Map<DateTime, List<Event>> _calendarEvents;
  ListView _eventListView;

  Widget _floatingActionButton;
  List _eventList;
  bool _eventsRetrieved;

  Widget _finalScreen;
  bool _contentFound;

  EventsScreen args;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _values  = new Values();
    _hue = new Hues();
    _scrollController = new ScrollController();
    _calendarController = CalendarController();
    _eventsRetrieved = false;
    _calendarEvents = Map();
    _eventListView = ListView(shrinkWrap: true,);
    _eventList = new List();
    _finalScreen = Center(
      child: Image.asset(_values.loadingAnimation),
    );
    _contentFound = false;
    BackButtonInterceptor.add(backPressInterceptor);
  }

  bool backPressInterceptor(bool stopDefaultButtonEvent) {
    Navigator.pop(context); // Do some stuff.
    return true;
  }

  void retrievingCalendarEventsProcess() async{
    await retrieveCalendarEvents(context).then((map) {
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

                      return new EventTile(
                        event: ds,
                        eventIcon: _eventIcon,
                        onReturnedFromDetails: (response){
                          if(response){
                            setState(() {
                              _eventsRetrieved = false;
                            });
                          }
                          inflateScreen(_contentFound, null);
                        },
                      );
                    }
                );
              }
            });
          }
        });
      }else{
        setState(() {
          _calendarEvents = {};
          _eventListView = ListView(shrinkWrap: true,);
        });
      }
      setState(() {
        _eventsRetrieved = true;
        _contentFound = true;
        _finalScreen = inflateScreen(_contentFound, null);
      });
    });
  }

  void retrievingListEventsProcess() async{
    await retrieveListEvents(context).then((list){
      _eventList = list;
      _eventsRetrieved = true;
      if(list.isNotEmpty){
        setState(() {
          _contentFound = true;
          _finalScreen = inflateScreen(_contentFound, null);
        });
      }else{
        setState(() {
          _contentFound = false;
          _finalScreen = inflateScreen(_contentFound, null);
        });
      }
    });
  }

  Widget inflateScreen(bool contentFound, String eventFilter){
    args = ModalRoute.of(context).settings.arguments;
    double _screenHeight = MediaQuery.of(context).size.height;
    double _screenWidth = MediaQuery.of(context).size.width;
    Widget builtScreen;

    Orientation _orientation = MediaQuery.of(context).orientation;

    if(args.adminView){
      if(!_eventsRetrieved){
        retrievingCalendarEventsProcess();
        _floatingActionButton = FloatingActionButton(
          tooltip: "Crear evento",
          backgroundColor: _hue.ocean,
          child: Icon(Icons.add),
          onPressed: ()async{
            await Navigator.pushNamed(
                context,
                _values.routeNames['event_details'],
                arguments: EventDetailsScreen(
                  event: new Event(null, null, null, null, null, null, null, null, null),
                  adminView: true,
                  newEventDateTime: _calendarController.selectedDay,
                )
            ).then((response){
              if(response){
                setState(() {
                  _eventsRetrieved = false;
                });
              }
              inflateScreen(_contentFound, null);
            });
          },
        );
      }else{
        _orientation == Orientation.portrait ? builtScreen = Column(
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

                        return new EventTile(
                          event: ds,
                          eventIcon: _eventIcon,
                          onReturnedFromDetails: (response){
                            if(response){
                              setState(() {
                                _eventsRetrieved = false;
                              });
                            }
                            inflateScreen(_contentFound, null);
                          },
                        );
                      }
                  );
                  _finalScreen = inflateScreen(_contentFound, null);
                });
              },
              events: _calendarEvents,
            ),
            SizedBox(height: _values.mediumSizedBoxStandardHeight,),
            Expanded(child: _eventListView,),
          ],
        ) : builtScreen = SingleChildScrollView(
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

                          return new EventTile(
                            event: ds,
                            eventIcon: _eventIcon,
                            onReturnedFromDetails: (response){
                              if(response){
                                setState(() {
                                  _eventsRetrieved = false;
                                });
                              }
                              inflateScreen(_contentFound, null);
                            },
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
    }else{
      if(!_eventsRetrieved){
        retrievingListEventsProcess();
        _floatingActionButton = UnicornDialer(
            backgroundColor: Color.fromRGBO(255, 255, 255, 0.6),
            parentButtonBackground: _hue.ocean,
            orientation: UnicornOrientation.VERTICAL,
            parentButton: Icon(Icons.add),
            childButtons: [
              UnicornButton(
                hasLabel: true,
                labelText: "Todos",
                currentButton: FloatingActionButton(
                  backgroundColor: _hue.ocean,
                  heroTag: "Todos",
                  mini: true,
                  child: Icon(Icons.list),
                  onPressed: (){
                    setState(() {
                      _finalScreen = inflateScreen(_contentFound ,'todos');
                    });
                  },
                ),
              ),
              UnicornButton(
                hasLabel: true,
                labelText: _values.speedDialLabels[0],
                currentButton: FloatingActionButton(
                  backgroundColor: _hue.ocean,
                  heroTag: _values.speedDialLabels[0],
                  mini: true,
                  child: Icon(Icons.insert_drive_file),
                  onPressed: (){
                    setState(() {
                      _finalScreen = inflateScreen(_contentFound, 'Administrativa');
                    });
                  },
                ),
              ),
              UnicornButton(
                hasLabel: true,
                labelText: _values.speedDialLabels[1],
                currentButton: FloatingActionButton(
                  backgroundColor: _hue.ocean,
                  heroTag: _values.speedDialLabels[1],
                  mini: true,
                  child: Icon(Icons.school),
                  onPressed: (){
                    setState(() {
                      _finalScreen = inflateScreen(_contentFound, 'Académica');
                    });
                  },
                ),
              ),
              UnicornButton(
                hasLabel: true,
                labelText: _values.speedDialLabels[2],
                currentButton: FloatingActionButton(
                  backgroundColor: _hue.ocean,
                  heroTag: _values.speedDialLabels[2],
                  mini: true,
                  child: Icon(Icons.laptop),
                  onPressed: (){
                    setState(() {
                      _finalScreen = inflateScreen(_contentFound, 'Innovación e Investigación');
                    });
                  },
                ),
              ),
              UnicornButton(
                hasLabel: true,
                labelText: _values.speedDialLabels[3],
                currentButton: FloatingActionButton(
                  backgroundColor: _hue.ocean,
                  heroTag: _values.speedDialLabels[3],
                  mini: true,
                  child: Icon(Icons.settings),
                  onPressed: (){
                    setState(() {
                      _finalScreen = inflateScreen(_contentFound, 'Gestión Institucional');
                    });
                  },
                ),
              )
            ]);
      }else{
        if(contentFound){
          switch(eventFilter){
            case 'todos':
              builtScreen = Center(
                child: ListView.builder(
                    controller: _scrollController,
                    shrinkWrap: true,
                    itemCount: _eventList.length,
                    itemBuilder: (BuildContext context, int index){
                      String _dateText = buildEventDayText(_eventList[index].date, 0);
                      return EventCard(
                          height: _screenHeight,
                          width: _screenWidth,
                          orientation: _orientation,
                          date: _dateText,
                          image: _eventList[index].image,
                          time: _eventList[index].time,
                          department: _eventList[index].department,
                          onTap: (){
                            Navigator.pushReplacementNamed(
                                context,
                                _values.routeNames['event_details'],
                                arguments: EventDetailsScreen(
                                  event: _eventList[index],
                                  adminView: false,
                                )
                            );
                          }
                      );
                    }
                ),
              );
              break;
            case 'Gestión Institucional':
              builtScreen = Center(
                child: ListView.builder(
                    controller: _scrollController,
                    shrinkWrap: true,
                    itemCount: _eventList.length,
                    itemBuilder: (BuildContext context, int index){
                      if(_eventList[index].department == _values.departments[4] || _eventList[index].department == _values.departments[0]){
                        String _dateText = buildEventDayText(_eventList[index].date, 0);
                        return EventCard(
                            height: _screenHeight,
                            width: _screenWidth,
                            orientation: _orientation,
                            date: _dateText,
                            image: _eventList[index].image,
                            time: _eventList[index].time,
                            department: _eventList[index].department,
                            onTap: (){
                              Navigator.pushReplacementNamed(
                                  context,
                                  _values.routeNames['event_details'],
                                  arguments: EventDetailsScreen(
                                    event: _eventList[index],
                                    adminView: false,
                                  )
                              );
                            }
                        );
                      }else{
                        return Container();
                      }
                    }
                ),
              );
              break;
            case 'Innovación e Investigación':
              builtScreen = Center(
                child: ListView.builder(
                    controller: _scrollController,
                    shrinkWrap: true,
                    itemCount: _eventList.length,
                    itemBuilder: (BuildContext context, int index){
                      if(_eventList[index].department == _values.departments[3] || _eventList[index].department == _values.departments[0]){
                        String _dateText = buildEventDayText(_eventList[index].date, 0);
                        return EventCard(
                            height: _screenHeight,
                            width: _screenWidth,
                            orientation: _orientation,
                            date: _dateText,
                            image: _eventList[index].image,
                            time: _eventList[index].time,
                            department: _eventList[index].department,
                            onTap: (){
                               Navigator.pushReplacementNamed(
                                  context,
                                  _values.routeNames['event_details'],
                                  arguments: EventDetailsScreen(
                                    event: _eventList[index],
                                    adminView: false,
                                  )
                              );
                            }
                        );
                      }else{
                        return Container();
                      }
                    }
                ),
              );
              break;
            case 'Académica':
              builtScreen = Center(
                child: ListView.builder(
                    controller: _scrollController,
                    shrinkWrap: true,
                    itemCount: _eventList.length,
                    itemBuilder: (BuildContext context, int index){
                      if(_eventList[index].department == _values.departments[2] || _eventList[index].department == _values.departments[0]){
                        String _dateText = buildEventDayText(_eventList[index].date, 0);
                        return EventCard(
                            height: _screenHeight,
                            width: _screenWidth,
                            orientation: _orientation,
                            date: _dateText,
                            image: _eventList[index].image,
                            time: _eventList[index].time,
                            department: _eventList[index].department,
                            onTap: (){
                              Navigator.pushReplacementNamed(
                                  context,
                                  _values.routeNames['event_details'],
                                  arguments: EventDetailsScreen(
                                    event: _eventList[index],
                                    adminView: false,
                                  )
                              );
                            }
                        );
                      }else{
                        return Container();
                      }
                    }
                ),
              );
              break;
            case 'Administrativa':
              builtScreen = Center(
                child: ListView.builder(
                    controller: _scrollController,
                    shrinkWrap: true,
                    itemCount: _eventList.length,
                    itemBuilder: (BuildContext context, int index){
                      if(_eventList[index].department == _values.departments[1] || _eventList[index].department == _values.departments[0]){
                        String _dateText = buildEventDayText(_eventList[index].date, 0);
                        return EventCard(
                            height: _screenHeight,
                            width: _screenWidth,
                            orientation: _orientation,
                            date: _dateText,
                            image: _eventList[index].image,
                            time: _eventList[index].time,
                            department: _eventList[index].department,
                            onTap: (){
                              Navigator.pushReplacementNamed(
                                  context,
                                  _values.routeNames['event_details'],
                                  arguments: EventDetailsScreen(
                                    event: _eventList[index],
                                    adminView: false,
                                  )
                              );
                            }
                        );
                      }else{
                        return Container();
                      }
                    }
                ),
              );
              break;
            default:
              builtScreen = Center(
                child: ListView.builder(
                    controller: _scrollController,
                    shrinkWrap: true,
                    itemCount: _eventList.length,
                    itemBuilder: (BuildContext context, int index){
                      String _dateText = buildEventDayText(_eventList[index].date, 0);
                      return EventCard(
                          height: _screenHeight,
                          width: _screenWidth,
                          orientation: _orientation,
                          date: _dateText,
                          image: _eventList[index].image,
                          time: _eventList[index].time,
                          department: _eventList[index].department,
                          onTap: (){
                            Navigator.pushReplacementNamed(
                                context,
                                _values.routeNames['event_details'],
                                arguments: EventDetailsScreen(
                                  event: _eventList[index],
                                  adminView: false,
                                )
                            );
                          }
                      );
                    }
                ),
              );
              break;
          }
        }else{
          builtScreen = Center(
            child: Image.asset(
                _values.noContentFound
            ),
          );
        }
      }
    }

    return builtScreen;
  }

  @override
  void didChangeDependencies(){
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _finalScreen = inflateScreen(_contentFound, null);
    if(!_eventsRetrieved){
      _finalScreen = Center(
        child: Image.asset(_values.loadingAnimation),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          backgroundColor: _hue.carmesi,
          title: Text("Eventos"),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: (){
              Navigator.pop(context);
            },
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.assignment_ind,
                size: _values.toolbarIconSize,
              ),
              tooltip: 'Administrar',
              onPressed: (){
                Navigator.pushNamed(
                    context,
                    _values.routeNames['login']
                );
              },
            ),
            Container(
              width: _values.containerWidth,
            )
          ],
        ),
        body: _finalScreen,
        floatingActionButton: _floatingActionButton,
      ),
      onWillPop: () => Future.value(false),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    BackButtonInterceptor.remove(backPressInterceptor);
    if(args.adminView){
      _calendarController.dispose();
    }
    super.dispose();
  }

}

class EventDetailsScreen extends StatefulWidget {
  EventDetailsScreen({Key key, this.event, this.adminView, this.newEventDateTime}) : super(key: key);

  final Event event;
  final bool adminView;
  DateTime newEventDateTime;

  @override
  _EventDetailsScreen createState() => _EventDetailsScreen();
}

class _EventDetailsScreen extends State<EventDetailsScreen>{

  static Values _values;
  static Hues _hue;

  ScrollController _scrollController;
  String _spanishFormattedText;
  Widget _floatingButton;
  Offset _position;
  var _imageNewEvent, _passedDependencies, _imagechanged;
  var _formKey;
  Widget _widgetPortraitColumn;
  String _departmentSelected;
  Event _eventDetailed;

  EventDetailsScreen args;

  @override
  void initState() {
    super.initState();
    _values = new Values();
    _hue = new Hues();
    _scrollController = new ScrollController();
    _position = Offset(20.0, 20.0);
    _passedDependencies = false;
    _imagechanged = false;
    _formKey = GlobalKey<FormState>();
    BackButtonInterceptor.add(backPressInterceptor);
  }

  bool backPressInterceptor(bool stopDefaultButtonEvent) {

    Navigator.pop(
      context,
      false
    );

    return true;
  }

  @override
  void didChangeDependencies() async{
    super.didChangeDependencies();

    double _screenWidth = MediaQuery.of(context).size.width; //lee el ancho de dispositivo
    double _screenHeight = MediaQuery.of(context).size.height; //lee el largo del dispositivo

    args = ModalRoute.of(context).settings.arguments;

    _eventDetailed = args.event;

    if(_eventDetailed.id == null && (_eventDetailed.title == null && _eventDetailed.place == null && _eventDetailed.description == null)){
      _eventDetailed.title = "";
      _eventDetailed.place = "";
      _eventDetailed.description = "";
      _eventDetailed.time = "00:00";
      _eventDetailed.department = _values.departments[0];
      _departmentSelected = _values.departments[0];
    }else{
      _spanishFormattedText = buildEventDayText(_eventDetailed.date, 1);
      _departmentSelected = _eventDetailed.department;
    }

    _position = Offset(_screenWidth / 1.2, _screenHeight / 1.1);

    if(_eventDetailed.image == null){

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

    //_symmetricPadding =  (_screenWidth * values.widthPaddingUnit) / 10; //Función que nos permite hacer un padding responsivo a cualquier resolución en ancho
    double _responsiveHeight = _screenHeight / _values.defaultDivisionForResponsiveHeight; //Función para altura responsiva de cada card en la lista

    // TODO: implement build
    double _symmetricPadding = (_screenWidth * _values.widthPaddingUnit) / 10; //Función que nos permite hacer un padding responsivo a cualquier resolución en ancho

    if(args.adminView == true){
      if(_eventDetailed.id != null){
        TextEditingController _titleTextController = new TextEditingController(text: _eventDetailed.title);
        TextEditingController _placeTextController = new TextEditingController(text: _eventDetailed.place);
        TextEditingController _descriptionTextController = new TextEditingController(text: _eventDetailed.description);

        _titleTextController.selection = TextSelection.fromPosition(TextPosition(offset: _titleTextController.text.length));
        _placeTextController.selection = TextSelection.fromPosition(TextPosition(offset: _placeTextController.text.length));

        _widgetPortraitColumn = Column(
          children: <Widget>[
            Container(
                alignment: _values.centerAlignment,
                child: Stack(
                  children: <Widget>[
                    GestureDetector(
                      child: Center(
                        child: CachedNetworkImage(
                          imageUrl: _eventDetailed.image,
                          placeholder: (context, url) => Image.asset(_values.loadingAnimation, fit: BoxFit.fill, width: double.maxFinite, height: _screenHeight / 3,),
                          errorWidget: (context,url,error) => new Icon(Icons.error),
                          width: double.maxFinite,
                          height: _screenHeight / 3,
                          fit: BoxFit.cover,
                        ),
                      ),
                      onTap: (){
                        showDialog(
                            context: context,
                            builder: (BuildContext context) => ExpandedImageDialog(url: _eventDetailed.image,)
                        );
                      },
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
                            Future<String> finalURL = pickImage(_eventDetailed, context);
                            finalURL.then((val){
                              if(val != null){
                                setState(() {
                                  _eventDetailed.image = val;
                                });
                              }
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
                  _eventDetailed.updateEvent(_titleTextController.text, 'title').then((updatedTitle){
                    setState(() {
                      _eventDetailed.title = updatedTitle;
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
                  _eventDetailed.updateEvent(_placeTextController.text, 'place').then((updatedPlace){
                    setState(() {
                      _eventDetailed.place = updatedPlace;
                    });
                  });
                  FocusScope.of(context).requestFocus(FocusNode());
                },
              ),
            ),
            SizedBox(height: _responsiveHeight / 22,),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Subdirección",
                  style: _values.plainTextStyle,
                ),
                SizedBox(width: _screenWidth / 25,),
                Expanded(
                  child: DropdownButton(
                    isExpanded: true,
                    value: _departmentSelected,
                    icon: Icon(Icons.keyboard_arrow_down),
                    elevation: 5,
                    onChanged: (value){
                      _eventDetailed.updateEvent(value, 'department').then((returned){
                        _eventDetailed.department = returned;
                        setState(() {
                          _departmentSelected = returned;
                        });
                      });
                    },
                    items: _values.departments.map((String value){
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                )
              ],
            ),
            SizedBox(height: _responsiveHeight / 22,),
            Container(
                alignment: Alignment.centerLeft,
                child: new Row(
                  children: <Widget>[
                    Text(
                      "Día: " + _eventDetailed.date,
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
                              _eventDetailed.updateEvent(format, 'date').then((updatedDate){
                                setState(() {
                                  _eventDetailed.date = updatedDate;
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
                    "Hora: " + _eventDetailed.time,
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
                          String newTime = buildEventTimeText(time.toString());
                          _eventDetailed.updateEvent(newTime, 'time').then((updatedTime){
                            setState(() {
                              _eventDetailed.time = updatedTime;
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
                  _eventDetailed.updateEvent(_descriptionTextController.text, 'description').then((updatedDescription){
                    setState(() {
                      _eventDetailed.description = updatedDescription;
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
                if(result){
                  showDialog(
                      context: context,
                      builder: (BuildContext context) => CustomLoadDialog()
                  );

                  _eventDetailed.deleteEvent(context).then((result){
                    if(result){
                      Navigator.pop(context);
                      Navigator.pop(
                        context,
                        true
                      );
                    }
                  });
                }
              });
            }
        );
      }else{
        TextEditingController _titleTextController = new TextEditingController(text: _eventDetailed.title);
        TextEditingController _placeTextController = new TextEditingController(text: _eventDetailed.place);
        TextEditingController _descriptionTextController = new TextEditingController(text: _eventDetailed.description);

        DateFormat df = new DateFormat('yyyy-MM-dd');
        _eventDetailed.date = df.format(args.newEventDateTime);
        _spanishFormattedText = buildEventDayText(df.format(args.newEventDateTime), 1);

        if(_eventDetailed.image == null){
          _eventDetailed.image = _values.grayLogo;
        }

        _widgetPortraitColumn = Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                child: Stack(
                  children: <Widget>[
                    GestureDetector(
                      child: Center(
                        child: CachedNetworkImage(
                          imageUrl: _eventDetailed.image,
                          placeholder: (context, url) => Image.asset(_values.loadingAnimation, fit: BoxFit.fill, width: double.maxFinite, height: _screenHeight / 3,),
                          errorWidget: (context,url,error) => new Icon(Icons.error),
                          width: double.maxFinite,
                          height: _screenHeight / 3,
                          fit: BoxFit.cover,
                        ),
                      ),
                      onTap: (){
                        showDialog(
                            context: context,
                            builder: (BuildContext context) => ExpandedImageDialog(url: _eventDetailed.image,)
                        );
                      },
                    ),
                    Container(
                      color: _hue.background,
                      child: IconButton(
                        icon: Icon(Icons.cached, color: _hue.outlines,),
                        iconSize: _responsiveHeight / 11,
                        tooltip: _values.tooltipChangeEventImage,
                        onPressed: () async{
                          Future<String> finalURL = pickImage(_eventDetailed, context);
                          finalURL.then((val){
                            if(val != null){
                              setState(() {
                                _eventDetailed.image = val;
                              });
                              _imagechanged = true;
                            }
                          });
                        },
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: _responsiveHeight / 22,),
              Container(
                child: TextFormField(
                  controller: _titleTextController,
                  decoration: InputDecoration(
                      labelText: "Título",
                      labelStyle: _values.textFieldTextStyle,
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(_values.standardBorderRadius),
                          borderSide: BorderSide()
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(_values.standardBorderRadius),
                          borderSide: _values.textFieldFocusBorderSide
                      )
                  ),
                  validator: (val){
                    if(val.length == 0){
                      return "Este campo no puede estar vacío.";
                    }else{
                      return null;
                    }
                  },
                  onEditingComplete: (){
                    setState(() {
                      _eventDetailed.title = _titleTextController.text;
                    });
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                  onChanged: (content){
                    _eventDetailed.title = _titleTextController.text;
                  },
                  style: _values.textFieldTextStyle,
                ),
              ),
              SizedBox(height: _responsiveHeight / 22,),
              Container(
                alignment: Alignment.centerLeft,
                child: TextFormField(
                  controller: _placeTextController,
                  decoration: InputDecoration(
                      labelText: "Lugar",
                      labelStyle: _values.textFieldTextStyle,
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(_values.standardBorderRadius),
                        borderSide: BorderSide(),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(_values.standardBorderRadius),
                          borderSide: _values.textFieldFocusBorderSide
                      )
                  ),
                  validator: (val){
                    if(val.length == 0){
                      return "Este campo no puede estar vacío.";
                    }else{
                      return null;
                    }
                  },
                  onEditingComplete: (){
                    setState(() {
                      _eventDetailed.place = _placeTextController.text;
                    });
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                  onChanged: (content){
                    _eventDetailed.place = _placeTextController.text;
                  },
                  style: _values.textFieldTextStyle,
                ),
              ),
              SizedBox(height: _responsiveHeight / 22,),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Subdirección",
                    style: _values.plainTextStyle,
                  ),
                  SizedBox(width: _screenWidth / 25,),
                  Expanded(
                    child: DropdownButton(
                      isExpanded: true,
                      value: _departmentSelected,
                      icon: Icon(Icons.keyboard_arrow_down),
                      elevation: 5,
                      onChanged: (value){
                        _eventDetailed.department = value;
                        setState(() {
                          _departmentSelected = value;
                        });
                      },
                      items: _values.departments.map((String value){
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  )
                ],
              ),
              SizedBox(height: _responsiveHeight / 22,),
              Container(
                alignment: Alignment.centerLeft,
                child: Row(
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
                        DatePicker.showDatePicker(
                          context,
                          showTitleActions: true,
                          minTime: DateTime.now(),
                          maxTime: DateTime.now().add(Duration(days: 500)),
                          currentTime: args.newEventDateTime,
                          locale: LocaleType.es,
                          onConfirm: (date){
                            String format = date.toString().substring(0, 10);
                            setState(() {
                              args.newEventDateTime = date;
                              _eventDetailed.date = format;
                              _spanishFormattedText = buildEventDayText(_eventDetailed.date, 1);
                            });
                          },
                        );
                      },
                    )
                  ],
                ),
              ),
              SizedBox(height: _responsiveHeight / 22,),
              Container(
                alignment: Alignment.centerLeft,
                child: Row(
                  children: <Widget>[
                    Text(
                      "Hora: " + _eventDetailed.time.toString(),
                      style: _values.subtitleTextStyle,
                    ),
                    IconButton(
                      tooltip: "Cambiar hora",
                      icon: Icon(Icons.access_time),
                      color: _hue.outlines,
                      onPressed: (){
                        DateTime now = DateTime.now();

                        DatePicker.showTimePicker(
                            context,
                            showTitleActions: true,
                            currentTime: DateTime(now.hour, now.minute),
                            locale: LocaleType.es,
                            onConfirm: (time){
                              String newTime = buildEventTimeText(time.toString());
                              setState(() {
                                _eventDetailed.time = newTime;
                              });
                            }
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
                      _eventDetailed.description = _descriptionTextController.text;
                    });
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                  onChanged: (content){
                    _eventDetailed.description = _descriptionTextController.text;
                  },
                  style: _values.textFieldTextStyle,
                ),
              )
            ],
          ),
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

                _eventDetailed.createEvent(context, _imageNewEvent, _imagechanged).then((result){
                  Navigator.pop(context);

                  Navigator.pop(
                    context,
                    true
                  );
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
              child: GestureDetector(
                child: Center(
                  child: CachedNetworkImage(
                    imageUrl: _eventDetailed.image,
                    placeholder: (context, url) => Image.asset(_values.loadingAnimation, fit: BoxFit.fill, width: double.maxFinite, height: _screenHeight / 3,),
                    errorWidget: (context,url,error) => new Icon(Icons.error),
                    width: double.maxFinite,
                    height: _screenHeight / 3,
                    fit: BoxFit.cover,
                  ),
                ),
                onTap: (){
                  showDialog(
                      context: context,
                      builder: (BuildContext context) => ExpandedImageDialog(url: _eventDetailed.image,)
                  );
                },
              )
          ),
          SizedBox(height: _responsiveHeight / 22,),
          Container(
            child: Text(
              _eventDetailed.title,
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
              "Lugar: " + _eventDetailed.place,
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
              "Hora: " + _eventDetailed.time,
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
              _eventDetailed.description,
              style: _values.contentTextStyle,
            ),
          )
        ],
      );
    }

    return WillPopScope(
      child: Scaffold(
          backgroundColor: _hue.background,
          appBar: AppBar(
            backgroundColor: _hue.carmesi,
            title: Text("Evento"),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: (){
                Navigator.pop(
                      context,
                      false
                  );
              },
            ),
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
      ),
      onWillPop: () => Future.value(false),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _scrollController.dispose();
    BackButtonInterceptor.remove(backPressInterceptor);
    super.dispose();
  }

}
