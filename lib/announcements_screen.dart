import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'values.dart';
import 'classes.dart';
import 'functions.dart';
import 'package:intl/intl.dart';

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
  var _formKey; //la llave para identificar el form de los updates

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
    _formKey = GlobalKey<FormState>();
  }

  Widget inflateScreen(bool _contentFound, Orientation _orientation, List _list){

    _args = ModalRoute.of(context).settings.arguments;//lee el largo del dispositivo

    double _screenWidth = MediaQuery.of(context).size.width; //lee el ancho de dispositivo
    double _screenHeight = MediaQuery.of(context).size.height; //lee el largo del dispositivo
    Widget _builtScreen;

    if(_contentFound){
      if(_args.adminView){
        if(_editingMode){
          _orientation == Orientation.portrait ? _builtScreen = Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(height: _screenHeight / 100,),
              Container(
                padding: EdgeInsets.symmetric(horizontal: _screenWidth / 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      height: _screenHeight / 18,
                      width:  _screenWidth / 5,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(_values.standardBorderRadius * 2)),
                        color: _hue.ocean,
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.edit,
                          color: _hue.background,
                        ),
                        tooltip: "Editar",
                        onPressed: (){
                          setState(() {
                            Orientation _orientation = MediaQuery.of(context).orientation;
                            enterEditMode(_orientation, _list);
                          });
                        },
                      ),
                    )
                  ],
                ),
              ),
              ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: _screenWidth / 20),
                  controller: _scrollController,
                  shrinkWrap: true,
                  itemCount: _list.length,
                  itemBuilder: (BuildContext context, int index){
                    DateFormat df = new DateFormat('yyyy-MM-dd');
                    String _announcementDate = df.format(_list[index].timestamp);
                    _announcementDate = buildEventDayText(_announcementDate, 0);
                    return Stack(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.fromLTRB(0.0, _screenHeight / 50, 0.0, 0.0),
                          child: GestureDetector(
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
                                      padding: EdgeInsets.symmetric(horizontal: _screenWidth / 20),
                                      child: Text(
                                        _list[index].text,
                                        style: _values.subtitleTextStyle,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 0.0,
                          left: 0.0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Container(
                                height: _screenHeight / 18,
                                width:  _screenWidth / 9,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(_values.standardBorderRadius * 5)),
                                  color: _hue.carmesi,
                                ),
                                child: IconButton(
                                  icon: Icon(
                                    Icons.delete,
                                    color: _hue.background,
                                  ),
                                  tooltip: "Eliminar",
                                  onPressed: (){
                                    _list[index].deleteAnnouncement().then((result){
                                      if(result){
                                        if(_list.isNotEmpty){
                                          _list.removeAt(index);
                                        }
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
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    );
                  }
              )
            ],
          ) : _builtScreen = Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(height: _screenHeight / 100,),
              Container(
                padding: EdgeInsets.symmetric(horizontal: _screenWidth / 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      height: _screenHeight / 18,
                      width:  _screenWidth / 5,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(_values.standardBorderRadius * 2)),
                        color: _hue.ocean,
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.edit,
                          color: _hue.background,
                        ),
                        tooltip: "Editar",
                        onPressed: (){
                          setState(() {
                            Orientation _orientation = MediaQuery.of(context).orientation;
                            enterEditMode(_orientation, _list);
                          });
                        },
                      ),
                    )
                  ],
                ),
              ),
              ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: _screenWidth / 20),
                  controller: _scrollController,
                  shrinkWrap: true,
                  itemCount: _list.length,
                  itemBuilder: (BuildContext context, int index){
                    DateFormat df = new DateFormat('yyyy-MM-dd');
                    String _announcementDate = df.format(_list[index].timestamp);
                    _announcementDate = buildEventDayText(_announcementDate, 0);
                    return Stack(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.fromLTRB(0.0, _screenHeight / 50, 0.0, 0.0),
                          child: GestureDetector(
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
                                      padding: EdgeInsets.symmetric(horizontal: _screenWidth / 20),
                                      child: Text(
                                        _list[index].text,
                                        style: _values.subtitleTextStyle,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 0.0,
                          left: 0.0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Container(
                                height: _screenHeight / 18,
                                width:  _screenWidth / 9,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(_values.standardBorderRadius * 5)),
                                  color: _hue.carmesi,
                                ),
                                child: IconButton(
                                  icon: Icon(
                                    Icons.delete,
                                    color: _hue.background,
                                  ),
                                  tooltip: "Eliminar",
                                  onPressed: (){
                                    _list[index].deleteAnnouncement().then((result){
                                      if(result){
                                        if(_list.isNotEmpty){
                                          _list.removeAt(index);
                                        }
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
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    );
                  }
              )
            ],
          );
        }else{
          _builtScreen = Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(height: _screenHeight / 100,),
              Container(
                padding: EdgeInsets.symmetric(horizontal: _screenWidth / 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      height: _screenHeight / 18,
                      width:  _screenWidth / 5,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(_values.standardBorderRadius * 2)),
                        color: _hue.ocean,
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.edit,
                          color: _hue.background,
                        ),
                        tooltip: "Editar",
                        onPressed: (){
                          setState(() {
                            Orientation _orientation = MediaQuery.of(context).orientation;
                            enterEditMode(_orientation, _list);
                          });
                        },
                      ),
                    )
                  ],
                ),
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

                    return Stack(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.fromLTRB(0.0, _screenHeight / 50, 0.0, 0.0),
                          child: GestureDetector(
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
                                      padding: EdgeInsets.symmetric(horizontal: 10),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          SizedBox(height: _screenHeight / 30,),
                                          Form(
                                            key: _formKey,
                                            child: TextFormField(
                                              controller: _textController,
                                              decoration: new InputDecoration(
                                                  labelText: "Aviso",
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
                                              onEditingComplete: (){
                                                if (_formKey.currentState.validate()){

                                                  showDialog(
                                                      context: context,
                                                      builder: (context) => CustomLoadDialog()
                                                  );

                                                  _list[index].updateAnnouncement(_textController.text).then((returnedData){
                                                    setState(() {
                                                      _list[index].text = returnedData;
                                                      Orientation _orientation = MediaQuery.of(context).orientation;
                                                      enterEditMode(_orientation, _list);
                                                    });
                                                    Navigator.pop(context);
                                                  });
                                                }
                                              },
                                              keyboardType: TextInputType.emailAddress,
                                              style: _values.textFieldTextStyle,
                                            ),
                                          ),
                                          SizedBox(height: _screenHeight / 30,)
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 0.0,
                          left: 0.0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Container(
                                height: _screenHeight / 18,
                                width:  _screenWidth / 9,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(_values.standardBorderRadius * 5)),
                                  color: _hue.carmesi,
                                ),
                                child: IconButton(
                                  icon: Icon(
                                    Icons.delete,
                                    color: _hue.background,
                                  ),
                                  tooltip: "Eliminar",
                                  onPressed: (){
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
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    );
                  }
              )
            ],
          );
        }
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
                  return Container(
                    padding: EdgeInsets.fromLTRB(0.0, _screenHeight / 150, 0.0, 0.0),
                    child: GestureDetector(
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
                                padding: EdgeInsets.symmetric(horizontal: _screenWidth / 20),
                                child: Text(
                                  _list[index].text,
                                  style: _values.subtitleTextStyle,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }
            )
          ],
        );
      }
    }else{
      _builtScreen = Center(
        child: Image.asset(
            _values.noContentFound
        ),
      );
    }

    if(_args.adminView){
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
      _floatingActionButton = null;
    }

    return _builtScreen;
  }

  void enterEditMode(Orientation _orientationMode, List _list){

    if(_editingMode){
      Orientation _orientation = MediaQuery.of(context).orientation;
      _finalScreen = inflateScreen(true, _orientation, _list);
      _editingMode = false;
    }else{
      Orientation _orientation = MediaQuery.of(context).orientation;
      _finalScreen = inflateScreen(true, _orientation, _list);
      _editingMode = true;
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

    await retrieveAnnouncements(context).then((_list){
      Orientation _orientation = MediaQuery.of(context).orientation;
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