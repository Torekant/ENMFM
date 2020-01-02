import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'login_screen.dart';
import 'news_screen.dart';
import 'events_screen.dart';
import 'announcements_screen.dart';
import 'grades_screen.dart';
import 'administration_screen.dart';
import 'agenda_screen.dart';
import 'schedule_screen.dart';
import 'values.dart';
import 'dart:async';
import 'classes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'functions.dart';

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
                                  height: _screenHeight / 11,
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
                                            builder: (context) => EventsScreen(adminView: false)
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
                      SizedBox(height: _screenHeight / 10,),
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
                          launchURL(_values.urlWebPage);
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
                                  height: _screenHeight / 5,
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
                                            builder: (context) => EventsScreen(adminView: false)
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
                      SizedBox(height: _screenHeight / 10,),
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
                          launchURL(_values.urlWebPage);
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

                                      admin.destroyAdmin(context).then((result){
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

                                      admin.destroyAdmin(context).then((result){
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
                                            widget.user.updateEmail(pass, _mailUpdateController.text).then((result){
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
                                              widget.user.updateEmail(pass, _mailUpdateController.text).then((result){
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