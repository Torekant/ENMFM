import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'values.dart';
import 'classes.dart';
import 'functions.dart';
import 'package:intl/intl.dart';
import 'widgets.dart';

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

  Widget _finalScreen;

  bool _editingMode;
  List<GlobalKey<FormState>> _formKeys; //la llave para identificar el form de los updates

  AnnouncementsScreen _args;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _values = new Values();
    _hue = new Hues();
    _scrollController = new ScrollController();
    _finalScreen = Center(
      child: Image.asset(
          _values.loadingAnimation
      ),
    );
    _editingMode = false;
    _formKeys = List();
  }

  Widget inflateScreen(bool _contentFound, Orientation _orientation, List _list){

    _args = ModalRoute.of(context).settings.arguments;//lee el largo del dispositivo

    double _screenWidth = MediaQuery.of(context).size.width; //lee el ancho de dispositivo
    double _screenHeight = MediaQuery.of(context).size.height; //lee el largo del dispositivo
    Widget _builtScreen;

    if(_contentFound){
      if(_args.adminView){
        _orientation == Orientation.portrait ? _builtScreen = Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(height: _screenHeight / 100,),
            PillButton(
              height: _screenHeight,
              width: _screenWidth,
              orientation: _orientation,
              buttonTooltip: "Editar",
              onPressed: (){
                setState(() {
                  Orientation _orientation = MediaQuery.of(context).orientation;
                  enterEditMode(_orientation, _list);
                });
              },
            ),
            ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 10),
                controller: _scrollController,
                shrinkWrap: true,
                itemCount: _list.length,
                itemBuilder: (BuildContext context, int index){
                  DateFormat df = new DateFormat('yyyy-MM-dd');
                  String _announcementDate = df.format(_list[index].timestamp);
                  _announcementDate = buildEventDayText(_announcementDate, 0);

                  return AnnouncementCard(
                    height: _screenHeight,
                    width: _screenWidth,
                    text: _list[index].text,
                    date: _announcementDate,
                    orientation: _orientation,
                    editable: _editingMode,
                    onUpdate: (text){
                      showDialog(
                          context: context,
                          builder: (context) => CustomLoadDialog()
                      );

                      _list[index].updateAnnouncement(text).then((returnedData){
                        setState(() {
                          _list[index].text = returnedData;
                          Orientation _orientation = MediaQuery.of(context).orientation;
                          enterEditMode(_orientation, _list);
                        });
                        Navigator.pop(context);
                      });
                    },
                    onDestroy: (){
                      _list[index].deleteAnnouncement().then((result){
                        if(result){
                          _list.removeAt(index);
                          setState(() {
                            if(_list.isEmpty){
                              _finalScreen = inflateScreen(false, _orientation, _list);
                            }else{
                              Orientation _orientation = MediaQuery.of(context).orientation;
                              _finalScreen = inflateScreen(true, _orientation, _list);
                            }
                          });
                          showDialog(
                              context: context,
                              builder: (context) => CustomDialog(description: "El anunció se ha borrado exitosamente.", acceptButtonText: "Aceptar",)
                          );
                        }else{
                          showDialog(
                              context: context,
                              builder: (context) => CustomDialog(description: "Sucedió un problema inesperado, intente más tarde.", acceptButtonText: "Aceptar",)
                          );
                        }
                      });
                    },
                  );
                }
            )
          ],
        ) : _builtScreen = Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(height: _screenHeight / 100,),
            PillButton(
              height: _screenHeight,
              width: _screenWidth,
              orientation: _orientation,
              buttonTooltip: "Editar",
              onPressed: (){
                setState(() {
                  Orientation _orientation = MediaQuery.of(context).orientation;
                  enterEditMode(_orientation, _list);
                });
              },
            ),
            ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 10),
                controller: _scrollController,
                shrinkWrap: true,
                itemCount: _list.length,
                itemBuilder: (BuildContext context, int index){
                  DateFormat df = new DateFormat('yyyy-MM-dd');
                  String _announcementDate = df.format(_list[index].timestamp);
                  _announcementDate = buildEventDayText(_announcementDate, 0);

                  TextEditingController _textController = new TextEditingController(text: _list[index].text);
                  _textController.selection = TextSelection.fromPosition(TextPosition(offset: _textController.text.length));
                  if(_formKeys.length <= index){
                    _formKeys.add(GlobalKey<FormState>());
                  }

                  return AnnouncementCard(
                    height: _screenHeight,
                    width: _screenWidth,
                    text: _list[index].text,
                    date: _announcementDate,
                    orientation: _orientation,
                    editable: _editingMode,
                    onUpdate: (text){
                      showDialog(
                          context: context,
                          builder: (context) => CustomLoadDialog()
                      );

                      _list[index].updateAnnouncement(text).then((returnedData){
                        setState(() {
                          _list[index].text = returnedData;
                          Orientation _orientation = MediaQuery.of(context).orientation;
                          enterEditMode(_orientation, _list);
                        });
                        Navigator.pop(context);
                      });
                    },
                    onDestroy: (){
                      _list[index].deleteAnnouncement().then((result){
                        if(result){
                          _list.removeAt(index);
                          setState(() {
                            if(_list.isEmpty){
                              _finalScreen = inflateScreen(false, _orientation, _list);
                            }else{
                              Orientation _orientation = MediaQuery.of(context).orientation;
                              _finalScreen = inflateScreen(true, _orientation, _list);
                            }
                          });
                          showDialog(
                              context: context,
                              builder: (context) => CustomDialog(description: "El anunció se ha borrado exitosamente.", acceptButtonText: "Aceptar",)
                          );
                        }else{
                          showDialog(
                              context: context,
                              builder: (context) => CustomDialog(description: "Sucedió un problema inesperado, intente más tarde.", acceptButtonText: "Aceptar",)
                          );
                        }
                      });
                    },
                  );
                }
            )
          ],
        );
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
                createAnnouncement(context, result).then((result){
                  Navigator.pop(context);
                  setState(() {
                    updateScreen();
                  });
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
        _builtScreen = Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(height: _screenHeight / 100,),
            ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: _screenWidth / 20),
                controller: _scrollController,
                shrinkWrap: true,
                itemCount: _list.length,
                itemBuilder: (BuildContext context, int index){
                  DateFormat df = new DateFormat('yyyy-MM-dd');
                  String _announcementDate = df.format(_list[index].timestamp);
                  _announcementDate = buildEventDayText(_announcementDate, 0);
                  return AnnouncementCard(
                    height: _screenHeight,
                    width: _screenWidth,
                    text: _list[index].text,
                    date: _announcementDate,
                  );
                }
            )
          ],
        );
        _floatingActionButton = null;
      }
    }else{
      _builtScreen = Center(
        child: Image.asset(
            _values.noContentFound
        ),
      );
    }

    return _builtScreen;
  }

  void enterEditMode(Orientation _orientationMode, List _list){

    Orientation _orientation = MediaQuery.of(context).orientation;

    if(_editingMode){
      _editingMode = false;
      _finalScreen = inflateScreen(true, _orientation, _list);
    }else{
      _editingMode = true;
      _finalScreen = inflateScreen(true, _orientation, _list);
    }
  }

  void updateScreen() async{
    await retrieveAnnouncements(context).then((_list){
      if(_list.isNotEmpty){
        if(_args.adminView == true){
          Orientation _orientation = MediaQuery.of(context).orientation;
          setState(() {
            _finalScreen = inflateScreen(true, _orientation, _list);
          });
        }else{
          setState(() {
            _finalScreen = inflateScreen(true, null, _list);
          });
        }
      }else{
        setState(() {
          _finalScreen = inflateScreen(false, null, _list);
        });
      }
    });
  }

  @override
  void didChangeDependencies() async{
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();

    Orientation _orientation = MediaQuery.of(context).orientation;

    await retrieveAnnouncements(context).then((_list){
      if(_list.isNotEmpty){
        setState(() {
          _finalScreen = inflateScreen(true, _orientation, _list);
        });
      }else{
        setState(() {
          _finalScreen = inflateScreen(false, _orientation, _list);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: _hue.background,
      appBar: AppBar(
        backgroundColor: _hue.carmesi,
        title: Text("Avisos"),
      ),
      body: _finalScreen,
      floatingActionButton: _floatingActionButton,
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _scrollController.dispose();
    super.dispose();
  }
}