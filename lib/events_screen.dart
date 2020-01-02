import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'values.dart';
import 'classes.dart';
import 'functions.dart';
import 'login_screen.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:unicorndial/unicorndial.dart';
import 'package:flutter_parallax/flutter_parallax.dart';
import 'package:intl/intl.dart';

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

  Widget _floatingActionButton;
  List _eventList;
  bool _eventsRetrieved;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _values  = new Values();
    _hue = new Hues();
    _scrollController = new ScrollController();
    _eventsRetrieved = false;

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
                builder: (context) => EventDetailsScreen(event: new Event(null, null, null, null, null, null, null, null, null), adminView: true, newEventDateTime: _calendarController.selectedDay,),
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
      _eventList = new List();
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
                  filterEvents('todos');
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
                  filterEvents('Administrativa');
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
                  filterEvents('Académica');
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
                  filterEvents('Innovación e Investigación');
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
                  filterEvents('Gestión Institucional');
                },
              ),
            )
          ]);
    }

  }

  void filterEvents(String _filter){
    double _screenHeight = MediaQuery.of(context).size.height; //lee el largo del dispositivo
    double _responsiveHeight = _screenHeight / _values.defaultDivisionForResponsiveHeight; //Función para altura responsiva de cada card en la lista

    switch(_filter){
      case 'todos':
        setState(() {
          _screenPortraitContent = Center(
            child: ListView.builder(
                controller: _scrollController,
                shrinkWrap: true,
                itemCount: _eventList.length,
                itemBuilder: (BuildContext context, int index){
                  String _dateText = buildEventDayText(_eventList[index].date, 0);
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
                                  imageUrl: _eventList[index].image,
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
                                  _dateText + " a las " + _eventList[index].time + "hrs.",
                                  style: _values.subtitleTextStyle,
                                ),
                              ],
                            ),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              controller: _scrollController,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Text(
                                    "Subdirección " + _eventList[index].department,
                                    style: _values.subtitleTextStyle,
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    onTap: (){
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EventDetailsScreen(event: _eventList[index], adminView: false,)
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
                itemCount: _eventList.length,
                itemBuilder: (BuildContext context, int index){
                  String _dateText = buildEventDayText(_eventList[index].date, 0);
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
                                  imageUrl: _eventList[index].image,
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
                                  _dateText + " a las " + _eventList[index].time + "hrs.",
                                  style: _values.subtitleTextStyle,
                                ),
                              ],
                            ),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              controller: _scrollController,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Text(
                                    "Subdirección" + _eventList[index].department,
                                    style: _values.subtitleTextStyle,
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    onTap: (){
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EventDetailsScreen(event: _eventList[index], adminView: false,)
                          )
                      );
                    },
                  );
                }
            ),
          );
        });
        break;
      case 'Gestión Institucional':
        setState(() {
          _screenPortraitContent = Center(
            child: ListView.builder(
                controller: _scrollController,
                shrinkWrap: true,
                itemCount: _eventList.length,
                itemBuilder: (BuildContext context, int index){
                  if(_eventList[index].department == _values.departments[4] || _eventList[index].department == _values.departments[0]){
                    String _dateText = buildEventDayText(_eventList[index].date, 0);
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
                                    imageUrl: _eventList[index].image,
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
                                    _dateText + " a las " + _eventList[index].time + "hrs.",
                                    style: _values.subtitleTextStyle,
                                  ),
                                ],
                              ),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                controller: _scrollController,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Text(
                                      "Subdirección " + _eventList[index].department,
                                      style: _values.subtitleTextStyle,
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      onTap: (){
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EventDetailsScreen(event: _eventList[index], adminView: false,)
                            )
                        );
                      },
                    );
                  }else{
                    return Container();
                  }
                }
            ),
          );
          _screenLandscapeContent = Center(
            child: ListView.builder(
                controller: _scrollController,
                shrinkWrap: true,
                itemCount: _eventList.length,
                itemBuilder: (BuildContext context, int index){
                  if(_eventList[index].department == _values.departments[4] || _eventList[index].department == _values.departments[0]){
                    String _dateText = buildEventDayText(_eventList[index].date, 0);
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
                                    imageUrl: _eventList[index].image,
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
                                    _dateText + " a las " + _eventList[index].time + "hrs.",
                                    style: _values.subtitleTextStyle,
                                  ),
                                ],
                              ),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                controller: _scrollController,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Text(
                                      "Subdirección" + _eventList[index].department,
                                      style: _values.subtitleTextStyle,
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      onTap: (){
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EventDetailsScreen(event: _eventList[index], adminView: false,)
                            )
                        );
                      },
                    );
                  }else{
                    return Container();
                  }
                }
            ),
          );
        });
        break;
      case 'Innovación e Investigación':
        setState(() {
          _screenPortraitContent = Center(
            child: ListView.builder(
                controller: _scrollController,
                shrinkWrap: true,
                itemCount: _eventList.length,
                itemBuilder: (BuildContext context, int index){
                  if(_eventList[index].department == _values.departments[3] || _eventList[index].department == _values.departments[0]){
                    String _dateText = buildEventDayText(_eventList[index].date, 0);
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
                                    imageUrl: _eventList[index].image,
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
                                    _dateText + " a las " + _eventList[index].time + "hrs.",
                                    style: _values.subtitleTextStyle,
                                  ),
                                ],
                              ),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                controller: _scrollController,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Text(
                                      "Subdirección " + _eventList[index].department,
                                      style: _values.subtitleTextStyle,
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      onTap: (){
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EventDetailsScreen(event: _eventList[index], adminView: false,)
                            )
                        );
                      },
                    );
                  }else{
                    return Container();
                  }
                }
            ),
          );
          _screenLandscapeContent = Center(
            child: ListView.builder(
                controller: _scrollController,
                shrinkWrap: true,
                itemCount: _eventList.length,
                itemBuilder: (BuildContext context, int index){
                  if(_eventList[index].department == _values.departments[3] || _eventList[index].department == _values.departments[0]){
                    String _dateText = buildEventDayText(_eventList[index].date, 0);
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
                                    imageUrl: _eventList[index].image,
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
                                    _dateText + " a las " + _eventList[index].time + "hrs.",
                                    style: _values.subtitleTextStyle,
                                  ),
                                ],
                              ),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                controller: _scrollController,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Text(
                                      "Subdirección" + _eventList[index].department,
                                      style: _values.subtitleTextStyle,
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      onTap: (){
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EventDetailsScreen(event: _eventList[index], adminView: false,)
                            )
                        );
                      },
                    );
                  }else{
                    return Container();
                  }
                }
            ),
          );
        });
        break;
      case 'Académica':
        setState(() {
          _screenPortraitContent = Center(
            child: ListView.builder(
                controller: _scrollController,
                shrinkWrap: true,
                itemCount: _eventList.length,
                itemBuilder: (BuildContext context, int index){
                  if(_eventList[index].department == _values.departments[2] || _eventList[index].department == _values.departments[0]){
                    String _dateText = buildEventDayText(_eventList[index].date, 0);
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
                                    imageUrl: _eventList[index].image,
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
                                    _dateText + " a las " + _eventList[index].time + "hrs.",
                                    style: _values.subtitleTextStyle,
                                  ),
                                ],
                              ),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                controller: _scrollController,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Text(
                                      "Subdirección " + _eventList[index].department,
                                      style: _values.subtitleTextStyle,
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      onTap: (){
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EventDetailsScreen(event: _eventList[index], adminView: false,)
                            )
                        );
                      },
                    );
                  }else{
                    return Container();
                  }
                }
            ),
          );
          _screenLandscapeContent = Center(
            child: ListView.builder(
                controller: _scrollController,
                shrinkWrap: true,
                itemCount: _eventList.length,
                itemBuilder: (BuildContext context, int index){
                  if(_eventList[index].department == _values.departments[2] || _eventList[index].department == _values.departments[0]){
                    String _dateText = buildEventDayText(_eventList[index].date, 0);
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
                                    imageUrl: _eventList[index].image,
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
                                    _dateText + " a las " + _eventList[index].time + "hrs.",
                                    style: _values.subtitleTextStyle,
                                  ),
                                ],
                              ),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                controller: _scrollController,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Text(
                                      "Subdirección" + _eventList[index].department,
                                      style: _values.subtitleTextStyle,
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      onTap: (){
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EventDetailsScreen(event: _eventList[index], adminView: false,)
                            )
                        );
                      },
                    );
                  }else{
                    return Container();
                  }
                }
            ),
          );
        });
        break;
      case 'Administrativa':
        setState(() {
          _screenPortraitContent = Center(
            child: ListView.builder(
                controller: _scrollController,
                shrinkWrap: true,
                itemCount: _eventList.length,
                itemBuilder: (BuildContext context, int index){
                  if(_eventList[index].department == _values.departments[1] || _eventList[index].department == _values.departments[0]){
                    String _dateText = buildEventDayText(_eventList[index].date, 0);
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
                                    imageUrl: _eventList[index].image,
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
                                    _dateText + " a las " + _eventList[index].time + "hrs.",
                                    style: _values.subtitleTextStyle,
                                  ),
                                ],
                              ),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                controller: _scrollController,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Text(
                                      "Subdirección " + _eventList[index].department,
                                      style: _values.subtitleTextStyle,
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      onTap: (){
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EventDetailsScreen(event: _eventList[index], adminView: false,)
                            )
                        );
                      },
                    );
                  }else{
                    return Container();
                  }
                }
            ),
          );
          _screenLandscapeContent = Center(
            child: ListView.builder(
                controller: _scrollController,
                shrinkWrap: true,
                itemCount: _eventList.length,
                itemBuilder: (BuildContext context, int index){
                  if(_eventList[index].department == _values.departments[1] || _eventList[index].department == _values.departments[0]){
                    String _dateText = buildEventDayText(_eventList[index].date, 0);
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
                                    imageUrl: _eventList[index].image,
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
                                    _dateText + " a las " + _eventList[index].time + "hrs.",
                                    style: _values.subtitleTextStyle,
                                  ),
                                ],
                              ),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                controller: _scrollController,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Text(
                                      "Subdirección" + _eventList[index].department,
                                      style: _values.subtitleTextStyle,
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      onTap: (){
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EventDetailsScreen(event: _eventList[index], adminView: false,)
                            )
                        );
                      },
                    );
                  }else{
                    return Container();
                  }
                }
            ),
          );
        });
        break;
      default:
        setState(() {
          _screenPortraitContent = Center(
            child: ListView.builder(
                controller: _scrollController,
                shrinkWrap: true,
                itemCount: _eventList.length,
                itemBuilder: (BuildContext context, int index){
                  String _dateText = buildEventDayText(_eventList[index].date, 0);
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
                                  imageUrl: _eventList[index].image,
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
                                  _dateText + " a las " + _eventList[index].time + "hrs.",
                                  style: _values.subtitleTextStyle,
                                ),
                              ],
                            ),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              controller: _scrollController,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Text(
                                    "Subdirección " + _eventList[index].department,
                                    style: _values.subtitleTextStyle,
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    onTap: (){
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EventDetailsScreen(event: _eventList[index], adminView: false,)
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
                itemCount: _eventList.length,
                itemBuilder: (BuildContext context, int index){
                  String _dateText = buildEventDayText(_eventList[index].date, 0);
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
                                  imageUrl: _eventList[index].image,
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
                                  _dateText + " a las " + _eventList[index].time + "hrs.",
                                  style: _values.subtitleTextStyle,
                                ),
                              ],
                            ),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              controller: _scrollController,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Text(
                                    "Subdirección" + _eventList[index].department,
                                    style: _values.subtitleTextStyle,
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    onTap: (){
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EventDetailsScreen(event: _eventList[index], adminView: false,)
                          )
                      );
                    },
                  );
                }
            ),
          );
        });
        break;
    }
  }

  @override
  void didChangeDependencies() async{
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();

    double _screenHeight = MediaQuery.of(context).size.height; //lee el largo del dispositivo

    double _responsiveHeight = _screenHeight / _values.defaultDivisionForResponsiveHeight; //Función para altura responsiva de cada card en la lista

    if(widget.adminView == true){

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
      if(_eventsRetrieved == false){
        retrieveListEvents(context).then((list){
          _eventList = list;
          if(list.isNotEmpty){
            setState(() {
              _screenPortraitContent = Center(
                child: ListView.builder(
                    controller: _scrollController,
                    shrinkWrap: true,
                    itemCount: _eventList.length,
                    itemBuilder: (BuildContext context, int index){
                      String _dateText = buildEventDayText(_eventList[index].date, 0);
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
                                      imageUrl: _eventList[index].image,
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
                                      _dateText + " a las " + _eventList[index].time + "hrs.",
                                      style: _values.subtitleTextStyle,
                                    ),
                                  ],
                                ),
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  controller: _scrollController,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Text(
                                        "Subdirección " + _eventList[index].department,
                                        style: _values.subtitleTextStyle,
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        onTap: (){
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EventDetailsScreen(event: _eventList[index], adminView: false,)
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
                    itemCount: _eventList.length,
                    itemBuilder: (BuildContext context, int index){
                      String _dateText = buildEventDayText(_eventList[index].date, 0);
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
                                      imageUrl: _eventList[index].image,
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
                                      _dateText + " a las " + _eventList[index].time + "hrs.",
                                      style: _values.subtitleTextStyle,
                                    ),
                                  ],
                                ),
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  controller: _scrollController,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Text(
                                        "Subdirección" + _eventList[index].department,
                                        style: _values.subtitleTextStyle,
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        onTap: (){
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EventDetailsScreen(event: _eventList[index], adminView: false,)
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
        _eventsRetrieved = true;
      }
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
          floatingActionButton: _floatingActionButton,
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
          body: _screenLandscapeContent,
          floatingActionButton: _floatingActionButton,
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
  Widget _floatingButton;
  Offset _position;
  var _imageNewEvent, _passedDependencies;
  var _formKey;
  Widget _widgetPortraitColumn;
  String _departmentSelected;
  Event _eventDetailed;

  @override
  void initState() {
    super.initState();
    _values = new Values();
    _hue = new Hues();
    _scrollController = new ScrollController();
    _position = Offset(20.0, 20.0);
    _passedDependencies = false;
    _formKey = GlobalKey<FormState>();
    _eventDetailed = widget.event;

    if(_eventDetailed.id == null){
      _eventDetailed.title = "";
      _eventDetailed.place = "";
      _eventDetailed.description = "";
      _eventDetailed.time = "00:00";
      DateFormat df = new DateFormat('yyyy-MM-dd');
      _eventDetailed.date = df.format(widget.newEventDateTime);
      _spanishFormattedText = buildEventDayText(df.format(widget.newEventDateTime), 1);
      _eventDetailed.department = _values.departments[0];
      _departmentSelected = _values.departments[0];
    }else{
      _spanishFormattedText = buildEventDayText(_eventDetailed.date, 1);
      _departmentSelected = _eventDetailed.department;
    }
  }

  @override
  void didChangeDependencies() async{
    super.didChangeDependencies();

    double _screenWidth = MediaQuery.of(context).size.width; //lee el ancho de dispositivo
    double _screenHeight = MediaQuery.of(context).size.height; //lee el largo del dispositivo

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
    //double _symmetricPadding; //padding lateral de la pantalla

    //_symmetricPadding =  (_screenWidth * values.widthPaddingUnit) / 10; //Función que nos permite hacer un padding responsivo a cualquier resolución en ancho
    double _responsiveHeight = _screenHeight / _values.defaultDivisionForResponsiveHeight; //Función para altura responsiva de cada card en la lista

    // TODO: implement build
    double _symmetricPadding = (_screenWidth * _values.widthPaddingUnit) / 10; //Función que nos permite hacer un padding responsivo a cualquier resolución en ancho

    if(widget.adminView == true){
      if(_eventDetailed.id != null){
        TextEditingController _titleTextController = new TextEditingController(text: _eventDetailed.title);
        TextEditingController _placeTextController = new TextEditingController(text: _eventDetailed.place);
        TextEditingController _descriptionTextController = new TextEditingController(text: _eventDetailed.description);


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
                if(result == true){
                  showDialog(
                      context: context,
                      builder: (BuildContext context) => CustomLoadDialog()
                  );

                  _eventDetailed.deleteEvent(context).then((result){
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
        TextEditingController _titleTextController = new TextEditingController(text: _eventDetailed.title);
        TextEditingController _placeTextController = new TextEditingController(text: _eventDetailed.place);
        TextEditingController _descriptionTextController = new TextEditingController(text: _eventDetailed.description);

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
                          currentTime: widget.newEventDateTime,
                          locale: LocaleType.es,
                          onConfirm: (date){
                            String format = date.toString().substring(0, 10);
                            setState(() {
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

                _eventDetailed.createEvent(context, _imageNewEvent).then((result){
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

    return Scaffold(
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
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _scrollController.dispose();
    super.dispose();
  }

}