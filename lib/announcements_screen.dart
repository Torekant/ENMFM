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
  Offset _position;

  Widget _finalPortraitScreen, _finalLandscapeScreen;

  bool _editingMode;
  double _pastScreenWidth;
  var _formKey; //la llave para identificar el form de los updates

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _values = new Values();
    _hue = new Hues();
    _scrollController = new ScrollController();
    _finalPortraitScreen = Center(
      child: Image.asset(
          _values.loadingAnimation
      ),
    );
    _finalLandscapeScreen = Center(
      child: Image.asset(
          _values.loadingAnimation
      ),
    );
    _editingMode = false;
    _pastScreenWidth = 0;
    _formKey = GlobalKey<FormState>();

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
              createAnnouncement(context, result).then((result){
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

  void updateListView(int _orientationMode, List _list){
    double _screenWidth = MediaQuery.of(context).size.width; //lee el ancho de dispositivo
    double _screenHeight = MediaQuery.of(context).size.height; //lee el largo del dispositivo
    double _responsivePadding = _screenWidth / _values.defaultSymmetricPadding; //lee el ancho de dispositivo

    _orientationMode == 0 ? _finalPortraitScreen = Column(
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

                  },
                ),
              )
            ],
          ),
        ),
        ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: _responsivePadding),
            controller: _scrollController,
            shrinkWrap: true,
            itemCount: _list.length,
            itemBuilder: (BuildContext context, int index){
              DateFormat df = new DateFormat('dd-MM-yyyy');
              String _announcementDate = df.format(_list[index].timestamp);
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
                                padding: EdgeInsets.symmetric(horizontal: _responsivePadding),
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
                                  _list.removeAt(index);
                                  setState(() {
                                    if(_list.isEmpty){
                                      _finalPortraitScreen = Center(
                                        child: Image.asset(
                                            _values.noContentFound
                                        ),
                                      );
                                    }else{
                                      updateListView(0, _list);
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
    ) : _finalLandscapeScreen = Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox(height: _screenHeight / 100,),
        Container(
          padding: EdgeInsets.symmetric(horizontal: _screenWidth / 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Container(
                height: _screenHeight / 10,
                width:  _screenWidth / 10,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(_values.standardBorderRadius * 2)),
                  color: _hue.ocean,
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.edit,
                    color: _hue.background,
                    size: _screenHeight / 18,
                  ),
                  tooltip: "Editar",
                  onPressed: (){

                  },
                ),
              )
            ],
          ),
        ),
        ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: _responsivePadding),
            controller: _scrollController,
            shrinkWrap: true,
            itemCount: _list.length,
            itemBuilder: (BuildContext context, int index){
              DateFormat df = new DateFormat('dd-MM-yyyy');
              String _announcementDate = df.format(_list[index].timestamp);
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
                                padding: EdgeInsets.symmetric(horizontal: _responsivePadding),
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
                          height: _screenHeight / 10,
                          width:  _screenWidth / 20,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(_values.standardBorderRadius * 5)),
                            color: _hue.carmesi,
                          ),
                          child: IconButton(
                            icon: Icon(
                              Icons.delete,
                              color: _hue.background,
                              size: _screenHeight / 18,
                            ),
                            tooltip: "Eliminar",
                            onPressed: (){
                              _list[index].deleteAnnouncement().then((result){
                                if(result){
                                  setState(() {
                                    _list.removeAt(index);
                                    if(_list.isEmpty){
                                      _finalLandscapeScreen = Center(
                                        child: Image.asset(
                                            _values.noContentFound
                                        ),
                                      );
                                    }else{
                                      updateListView(1, _list);
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

  void enterEditMode(int _orientationMode, List _list){
    double _screenWidth = MediaQuery.of(context).size.width; //lee el ancho de dispositivo
    double _screenHeight = MediaQuery.of(context).size.height; //lee el largo del dispositivo
    double _responsivePadding = _screenWidth / _values.defaultSymmetricPadding; //lee el ancho de dispositivo

    if(_editingMode){
      _orientationMode == 0 ? _finalPortraitScreen = Column(
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
                        enterEditMode(0, _list);
                      });
                    },
                  ),
                )
              ],
            ),
          ),
          ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: _responsivePadding),
              controller: _scrollController,
              shrinkWrap: true,
              itemCount: _list.length,
              itemBuilder: (BuildContext context, int index){
                DateFormat df = new DateFormat('dd-MM-yyyy');
                String _announcementDate = df.format(_list[index].timestamp);
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
                                  padding: EdgeInsets.symmetric(horizontal: _responsivePadding),
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
                                    _list.removeAt(index);
                                    setState(() {
                                      if(_list.isEmpty){
                                        _finalPortraitScreen = Center(
                                          child: Image.asset(
                                              _values.noContentFound
                                          ),
                                        );
                                      }else{
                                        updateListView(0, _list);
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
      ) : _finalLandscapeScreen = Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(height: _screenHeight / 100,),
          Container(
            padding: EdgeInsets.symmetric(horizontal: _screenWidth / 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Container(
                  height: _screenHeight / 10,
                  width:  _screenWidth / 10,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(_values.standardBorderRadius * 2)),
                    color: _hue.ocean,
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.edit,
                      color: _hue.background,
                      size: _screenHeight / 18,
                    ),
                    tooltip: "Editar",
                    onPressed: (){
                      setState(() {
                        enterEditMode(1, _list);
                      });
                    },
                  ),
                )
              ],
            ),
          ),
          ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: _responsivePadding),
              controller: _scrollController,
              shrinkWrap: true,
              itemCount: _list.length,
              itemBuilder: (BuildContext context, int index){
                DateFormat df = new DateFormat('dd-MM-yyyy');
                String _announcementDate = df.format(_list[index].timestamp);
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
                                  padding: EdgeInsets.symmetric(horizontal: _responsivePadding),
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
                            height: _screenHeight / 10,
                            width:  _screenWidth / 20,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(_values.standardBorderRadius * 5)),
                              color: _hue.carmesi,
                            ),
                            child: IconButton(
                              icon: Icon(
                                Icons.delete,
                                color: _hue.background,
                                size: _screenHeight / 18,
                              ),
                              tooltip: "Eliminar",
                              onPressed: (){
                                _list[index].deleteAnnouncement().then((result){
                                  if(result){
                                    setState(() {
                                      _list.removeAt(index);
                                      if(_list.isEmpty){
                                        _finalLandscapeScreen = Center(
                                          child: Image.asset(
                                              _values.noContentFound
                                          ),
                                        );
                                      }else{
                                        updateListView(1, _list);
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
      _editingMode = false;
    }else{
      _orientationMode == 0 ? _finalPortraitScreen = Column(
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
                        enterEditMode(0, _list);
                      });
                    },
                  ),
                )
              ],
            ),
          ),
          ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: _responsivePadding),
              controller: _scrollController,
              shrinkWrap: true,
              itemCount: _list.length,
              itemBuilder: (BuildContext context, int index){
                DateFormat df = new DateFormat('dd-MM-yyyy');
                String _announcementDate = df.format(_list[index].timestamp);

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
                                  padding: EdgeInsets.symmetric(horizontal: _responsivePadding),
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
                                                  enterEditMode(0, _list);
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
                                        _finalPortraitScreen = Center(
                                          child: Image.asset(
                                              _values.noContentFound
                                          ),
                                        );
                                      }else{
                                        updateListView(0, _list);
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
      ) : _finalLandscapeScreen = Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(height: _screenHeight / 100,),
          Container(
            padding: EdgeInsets.symmetric(horizontal: _screenWidth / 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Container(
                  height: _screenHeight / 10,
                  width:  _screenWidth / 10,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(_values.standardBorderRadius * 2)),
                    color: _hue.ocean,
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.edit,
                      color: _hue.background,
                      size: _screenHeight / 18,
                    ),
                    tooltip: "Editar",
                    onPressed: (){
                      setState(() {
                        enterEditMode(1, _list);
                      });
                    },
                  ),
                )
              ],
            ),
          ),
          ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: _responsivePadding),
              controller: _scrollController,
              shrinkWrap: true,
              itemCount: _list.length,
              itemBuilder: (BuildContext context, int index){
                DateFormat df = new DateFormat('dd-MM-yyyy');
                String _announcementDate = df.format(_list[index].timestamp);

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
                                  padding: EdgeInsets.symmetric(horizontal: _responsivePadding),
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
                                                  enterEditMode(1, _list);
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
                            height: _screenHeight / 10,
                            width:  _screenWidth / 20,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(_values.standardBorderRadius * 5)),
                              color: _hue.carmesi,
                            ),
                            child: IconButton(
                              icon: Icon(
                                Icons.delete,
                                color: _hue.background,
                                size: _screenHeight / 18,
                              ),
                              tooltip: "Eliminar",
                              onPressed: (){
                                _list[index].deleteAnnouncement().then((result){
                                  if(result){
                                    setState(() {
                                      _list.removeAt(index);
                                      if(_list.isEmpty){
                                        _finalLandscapeScreen = Center(
                                          child: Image.asset(
                                              _values.noContentFound
                                          ),
                                        );
                                      }else{
                                        updateListView(1, _list);
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
      _editingMode = true;
    }
  }

  @override
  void didChangeDependencies() async{
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();

    double _screenWidth = MediaQuery.of(context).size.width; //lee el ancho de dispositivo
    double _screenHeight = MediaQuery.of(context).size.height; //lee el largo del dispositivo

    if(widget.adminView == true){
      _position = Offset(_screenWidth / 1.2, _screenHeight / 1.2);
    }

    //Stating flags on orientation change
    if(_pastScreenWidth != _screenWidth){
      _editingMode = false;
      _pastScreenWidth = _screenWidth;

      await retrieveAnnouncements(context).then((list){
        if(list.isNotEmpty){
          if(widget.adminView == true){
            setState(() {
              _finalPortraitScreen = Column(
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
                                enterEditMode(0, list);
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
                      itemCount: list.length,
                      itemBuilder: (BuildContext context, int index){
                        DateFormat df = new DateFormat('dd-MM-yyyy');
                        String _announcementDate = df.format(list[index].timestamp);
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
                                            list[index].text,
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
                                        list[index].deleteAnnouncement().then((result){
                                          if(result){
                                            list.removeAt(index);
                                            setState(() {
                                              if(list.isEmpty){
                                                _finalPortraitScreen = Center(
                                                  child: Image.asset(
                                                      _values.noContentFound
                                                  ),
                                                );
                                              }else{
                                                updateListView(0, list);
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
              _finalLandscapeScreen = Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(height: _screenHeight / 100,),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: _screenWidth / 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          height: _screenHeight / 10,
                          width:  _screenWidth / 10,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(_values.standardBorderRadius * 2)),
                            color: _hue.ocean,
                          ),
                          child: IconButton(
                            icon: Icon(
                              Icons.edit,
                              color: _hue.background,
                              size: _screenHeight / 18,
                            ),
                            tooltip: "Editar",
                            onPressed: (){
                              setState(() {
                                enterEditMode(1, list);
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
                      itemCount: list.length,
                      itemBuilder: (BuildContext context, int index){
                        DateFormat df = new DateFormat('dd-MM-yyyy');
                        String _announcementDate = df.format(list[index].timestamp);
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
                                            list[index].text,
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
                                    height: _screenHeight / 10,
                                    width:  _screenWidth / 20,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(_values.standardBorderRadius * 5)),
                                      color: _hue.carmesi,
                                    ),
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.delete,
                                        color: _hue.background,
                                        size: _screenHeight / 18,
                                      ),
                                      tooltip: "Eliminar",
                                      onPressed: (){
                                        list[index].deleteAnnouncement().then((result){
                                          if(result){
                                            setState(() {
                                              list.removeAt(index);
                                              if(list.isEmpty){
                                                _finalLandscapeScreen = Center(
                                                  child: Image.asset(
                                                      _values.noContentFound
                                                  ),
                                                );
                                              }else{
                                                updateListView(1, list);
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
            });
          }else{
            setState(() {
              _finalPortraitScreen = Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(height: _screenHeight / 100,),
                  ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: _screenWidth / 20),
                      controller: _scrollController,
                      shrinkWrap: true,
                      itemCount: list.length,
                      itemBuilder: (BuildContext context, int index){
                        DateFormat df = new DateFormat('dd-MM-yyyy');
                        String _announcementDate = df.format(list[index].timestamp);
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
                                        list[index].text,
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
              _finalLandscapeScreen = Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(height: _screenHeight / 100,),
                  ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: _screenWidth / 20),
                      controller: _scrollController,
                      shrinkWrap: true,
                      itemCount: list.length,
                      itemBuilder: (BuildContext context, int index){
                        DateFormat df = new DateFormat('dd-MM-yyyy');
                        String _announcementDate = df.format(list[index].timestamp);
                        return Container(
                          padding: EdgeInsets.fromLTRB(0.0, _screenHeight / 100, 0.0, 0.0),
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
                                        list[index].text,
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
            });
          }
        }else{
          setState(() {
            _finalPortraitScreen = Center(
              child: Image.asset(
                  _values.noContentFound
              ),
            );
            _finalLandscapeScreen = Center(
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
          body: _finalPortraitScreen,
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
          body: _finalLandscapeScreen,
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