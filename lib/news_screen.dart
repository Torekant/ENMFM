import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'values.dart';
import 'classes.dart';
import 'functions.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:expandable/expandable.dart';
import 'package:cached_network_image/cached_network_image.dart';

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
    _finalScreen = Center(
      child: Image.asset(
          _values.loadingAnimation
      ),
    );
  }

  @override
  void didChangeDependencies() async{
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();

    final NewsScreen args = ModalRoute.of(context).settings.arguments;

    double _screenWidth = MediaQuery.of(context).size.width; //lee el ancho de dispositivo
    double _screenHeight = MediaQuery.of(context).size.height; //lee el largo del dispositivo
    //double _symmetricPadding; //padding lateral de la pantalla

    //_symmetricPadding =  (_screenWidth * values.widthPaddingUnit) / 10; //Función que nos permite hacer un padding responsivo a cualquier resolución en ancho

    if(args.adminView == true){
      _floatingActionButton = FloatingActionButton(
        tooltip: "Crear noticia",
        backgroundColor: _hue.ocean,
        child: Icon(Icons.add),
        onPressed: (){
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => NewDetailsScreen(adminView: true, notice: new New(null, null, null, null, null, null),)
              )
          );
        },
      );
    }else{
      _position = Offset(0.0, 0.0);
      _floatingActionButton = null;
    }

    if(args.adminView == true){
      _position = Offset(_screenWidth / 1.2, _screenHeight / 1.2);
    }

    await retrieveNews(context).then((list){
      if(list.isNotEmpty){
        if(args.adminView){
          setState(() {
            _finalScreen = SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: _screenWidth / _values.defaultSymmetricPadding),
              controller: _scrollController,
              child: ListView.builder(
                  itemCount: list.length,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index){

                    return Card(
                      elevation: _values.cardElevation,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ExpandablePanel(
                            collapsed: Text(list[index].title, style: _values.contentTextStyle, softWrap: true, maxLines: 2, overflow: TextOverflow.ellipsis,),
                            expanded: Text(list[index].text, style: _values.contentTextStyle, softWrap: true,),
                            hasIcon: true,
                            tapBodyToCollapse: true,
                          ),
                          Container(color: _hue.outlines, height: _values.lineSizedBoxHeight,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              FlatButton(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      "Editar",
                                      style: _values.galleryFlatButtonTextStyle,
                                    ),
                                    Icon(
                                      Icons.edit,
                                      color: _hue.ocean,
                                    )
                                  ],
                                ),
                                onPressed: (){
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) => NewDetailsScreen(adminView: args.adminView, notice: list[index],)
                                      )
                                  );
                                },
                              )
                            ],
                          )
                        ],
                      ),
                    );
                  }
              ),
            );
          });
        }else{
          setState(() {
            _finalScreen = SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: _screenWidth / _values.defaultSymmetricPadding),
              controller: _scrollController,
              child: ListView.builder(
                  itemCount: list.length,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index){

                    Widget _galleryButton;
                    if(list[index].hasGallery){
                      _galleryButton = FlatButton(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Galería",
                              style: _values.galleryFlatButtonTextStyle,
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: _hue.ocean,
                            )
                          ],
                        ),
                        onPressed: (){
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) => NewDetailsScreen(adminView: args.adminView, notice: list[index],)
                              )
                          );
                        },
                      );
                    }else{
                      _galleryButton = SizedBox(height: _values.toolbarIconSize,);
                    }

                    return Card(
                      elevation: _values.cardElevation,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ExpandablePanel(
                            collapsed: Text(list[index].title, style: _values.contentTextStyle, softWrap: true, maxLines: 2, overflow: TextOverflow.ellipsis,),
                            expanded: Text(list[index].text, style: _values.contentTextStyle, softWrap: true,),
                            hasIcon: true,
                            tapBodyToCollapse: true,
                          ),
                          Container(color: _hue.outlines, height: _values.lineSizedBoxHeight,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              _galleryButton
                            ],
                          )
                        ],
                      ),
                    );
                  }
              ),
            );
          });
        }
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
  NewDetailsScreen({Key key, this.adminView, this.notice}) : super(key: key);

  final bool adminView;
  final New notice;

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

  TextEditingController _textEditingController, _titleEditingController;
  List<dynamic> _imageUrlList;
  var _formKey;
  String _newFinalText, _showMoreButtonText;
  Widget _showMoreFlatButton;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _values = new Values();
    _hue = new Hues();
    _scrollController = new ScrollController();
    _screenPortraitContent = new Scaffold();
    _screenLandscapeContent = new Scaffold();
    BackButtonInterceptor.add(backInterceptor);
    _showMoreButtonText = "Ver más";
    _imageUrlList = new List();

    if(widget.notice.imageList != null){
      _imageUrlList.addAll(widget.notice.imageList);
    }

    if(widget.adminView == true){
      _formKey = GlobalKey<FormState>();
      if(widget.notice.text == null){
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

              createNew(context, _imageUrlList, _textEditingController.text, _titleEditingController.text).then((result){
                Navigator.pop(context);
                Navigator.pop(context);
              });
            }
          },
        );
      }else{
        _floatingActionButton = FloatingActionButton(
          tooltip: "Eliminar noticia",
          backgroundColor: _hue.carmesi,
          child: Icon(Icons.delete),
          onPressed: (){

            showDialog(
                context: context,
                builder: (context) => CustomAlertDialog(description: "Se borrará la noticia y su galería permanentemente ¿Quiere continuar?", acceptButtonText: "Si", cancelButtonText: "No",)
            ).then((result){
              if(result){
                showDialog(
                    context: context,
                    builder: (context) => CustomLoadDialog()
                );

                deleteNewsImageOnCloud(_imageUrlList);
                widget.notice.destroyNew().then((result){
                  Navigator.pop(context);
                  Navigator.pop(context);
                });
              }
            });
          },
        );
      }

      if(widget.notice.text != null){
        _textEditingController = new TextEditingController(text: widget.notice.text);
        _titleEditingController = new TextEditingController(text: widget.notice.title);
      }else{
        _textEditingController = new TextEditingController();
        _titleEditingController = new TextEditingController();
      }
    }else{
      _position = Offset(0.0, 0.0);
      _floatingActionButton = null;
    }
  }

  bool backInterceptor(bool stopDefaultButtonEvent){
    if(widget.adminView == true && widget.notice.id == null){
      showDialog(
          context: context,
          builder: (BuildContext context) => CustomAlertDialog(description: "Si se va ahora no se guardará la noticia.", acceptButtonText: "Aceptar", cancelButtonText: "Cancelar",)
      ).then((result){
        if(result == true){
          deleteNewsImageOnCloud(_imageUrlList);
          Navigator.pop(context);
          return false;
        }else{
          return true;
        }
      });
    }else{
      return false;
    }
  }

  void _setShowMoreButton(){
    setState(() {
      _showMoreFlatButton = FlatButton(
        child: Text(
          _showMoreButtonText,
          style: _values.galleryFlatButtonTextStyle,
        ),
        onPressed: (){
          if(_showMoreButtonText == 'Ver más'){
            setState(() {
              _newFinalText = widget.notice.text;
              _showMoreButtonText = "Ver menos";
            });
            _setShowMoreButton();
          }else{
            setState(() {
              _newFinalText = widget.notice.text.substring(0, 100) + "...";
              _showMoreButtonText = "Ver más";
            });
            _setShowMoreButton();
          }
        },
      );
    });
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    double _screenWidth = MediaQuery.of(context).size.width; //lee el ancho de dispositivo
    double _screenHeight = MediaQuery.of(context).size.height; //lee el largo del dispositivo

    if(widget.adminView == true){
      _position = Offset(_screenWidth / 1.2, _screenHeight / 1.2);
    }else{
      if(widget.notice.text.length > 100){
        _newFinalText = widget.notice.text.substring(0, 100) + "...";
        _showMoreFlatButton = FlatButton(
          child: Text(
            _showMoreButtonText,
            style: _values.galleryFlatButtonTextStyle,
          ),
          onPressed: (){
            if(_showMoreButtonText == 'Ver más'){
              setState(() {
                _newFinalText = widget.notice.text;
                _showMoreButtonText = "Ver menos";
              });
              _setShowMoreButton();
            }else{
              setState(() {
                _newFinalText = widget.notice.text.substring(0, 100) + "...";
                _showMoreButtonText = "Ver más";
              });
              _setShowMoreButton();
            }
          },
        );
      }else{
        _newFinalText = widget.notice.text;
        _showMoreFlatButton = Container();
      }
    }

  }

  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width; //lee el ancho de dispositivo
    double _screenHeight = MediaQuery.of(context).size.height; //lee el largo del dispositivo

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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                    controller: _titleEditingController,
                    maxLines: null,
                    decoration: new InputDecoration(
                        labelText: "Título",
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
                      showDialog(
                          context: context,
                          builder: (context) => CustomLoadDialog()
                      );

                      widget.notice.updateNew('title', _titleEditingController.text).then((response){
                        setState(() {
                          widget.notice.title = response;
                        });
                        Navigator.pop(context);
                      });
                    },
                    keyboardType: TextInputType.text,
                    style: _values.textFieldTextStyle,
                  ),
                  SizedBox(height: _screenHeight / 30,),
                  TextFormField(
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
                    onEditingComplete: (){
                      showDialog(
                          context: context,
                          builder: (context) => CustomLoadDialog()
                      );

                      widget.notice.updateNew('text', _textEditingController.text).then((response){
                        setState(() {
                          widget.notice.text = response;
                        });
                        Navigator.pop(context);
                      });
                    },
                    keyboardType: TextInputType.text,
                    style: _values.textFieldTextStyle,
                  )
                ],
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
                      saveNewsImageOnCloud(imageFile).then((downloadUrl) {
                        // Get the download URL
                        setState(() {
                          _imageUrlList.add(downloadUrl);
                        });

                        //Si estamos añadiendo o borrando imágenes a una noticia existente, actualizamos la lista de imágenes en la BD
                        if(widget.notice.id != null){
                          widget.notice.updateImages(_imageUrlList);
                        }
                      }).catchError((err) {
                        Navigator.pop(context);
                        print("Error:" + err.toString());
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
              scrollDirection: Axis.vertical,
              physics: ScrollPhysics(),
              shrinkWrap: true,
              crossAxisCount: 2,
              children: List.generate(_imageUrlList.length, (index){
                return Center(
                  child: Stack(
                    children: <Widget>[
                      GestureDetector(
                        child: Center(
                          child: CachedNetworkImage(
                            imageUrl: _imageUrlList[index],
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
                              builder: (BuildContext context) => ExpandedImageDialog(url: _imageUrlList[index],)
                          );
                        },
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
                                deleteOneNewsImage(_imageUrlList[index]);
                                setState(() {
                                  _imageUrlList.removeAt(index);
                                });

                                //Si estamos añadiendo o borrando imágenes a una noticia existente, actualizamos la lista de imágenes en la BD
                                if(widget.notice.id != null){
                                  widget.notice.updateImages(_imageUrlList);
                                }
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
      _screenLandscapeContent = SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: _screenWidth / _values.defaultSymmetricPadding),
        controller: _scrollController,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(height: _values.toolbarGapSizedBox,),
            Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                    controller: _titleEditingController,
                    maxLines: null,
                    decoration: new InputDecoration(
                        labelText: "Título",
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
                      showDialog(
                          context: context,
                          builder: (context) => CustomLoadDialog()
                      );

                      widget.notice.updateNew('title', _titleEditingController.text).then((response){
                        setState(() {
                          widget.notice.title = response;
                        });
                        Navigator.pop(context);
                      });
                    },
                    keyboardType: TextInputType.text,
                    style: _values.textFieldTextStyle,
                  ),
                  SizedBox(height: _screenHeight / 30,),
                  TextFormField(
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
                    onEditingComplete: (){
                      showDialog(
                          context: context,
                          builder: (context) => CustomLoadDialog()
                      );

                      widget.notice.updateNew('text', _textEditingController.text).then((response){
                        setState(() {
                          widget.notice.text = response;
                        });
                        Navigator.pop(context);
                      });
                    },
                    keyboardType: TextInputType.text,
                    style: _values.textFieldTextStyle,
                  )
                ],
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
                      saveNewsImageOnCloud(imageFile).then((downloadUrl) {
                        // Get the download URL
                        setState(() {
                          _imageUrlList.add(downloadUrl);
                        });

                        //Si estamos añadiendo o borrando imágenes a una noticia existente, actualizamos la lista de imágenes en la BD
                        if(widget.notice.id != null){
                          widget.notice.updateImages(_imageUrlList);
                        }
                      }).catchError((err) {
                        Navigator.pop(context);
                        print("Error:" + err.toString());
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
              scrollDirection: Axis.vertical,
              physics: ScrollPhysics(),
              shrinkWrap: true,
              crossAxisCount: 5,
              children: List.generate(_imageUrlList.length, (index){
                return Center(
                  child: Stack(
                    children: <Widget>[
                      GestureDetector(
                        child: Center(
                          child: CachedNetworkImage(
                            imageUrl: _imageUrlList[index],
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
                              builder: (BuildContext context) => ExpandedImageDialog(url: _imageUrlList[index], width: _screenWidth, height: _screenHeight,)
                          );
                        },
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
                                deleteOneNewsImage(_imageUrlList[index]);
                                setState(() {
                                  _imageUrlList.removeAt(index);
                                });

                                //Si estamos añadiendo o borrando imágenes a una noticia existente, actualizamos la lista de imágenes en la BD
                                if(widget.notice.id != null){
                                  widget.notice.updateImages(_imageUrlList);
                                }
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
    }else{
      _screenPortraitContent = SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: _screenWidth / _values.defaultSymmetricPadding),
        controller: _scrollController,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(height: _values.toolbarGapSizedBox,),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Text(
                widget.notice.title,
                style: _values.titleTextStyle,
              ),
            ),
            SizedBox(height: _screenHeight / 50,),
            Container(color: _hue.outlines, height: _values.lineSizedBoxHeight,),
            SizedBox(height: _screenHeight / 50,),
            Text(
              _newFinalText,
              style: _values.contentTextStyle,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                _showMoreFlatButton
              ],
            ),
            SizedBox(height: _screenHeight / 15,),
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
              scrollDirection: Axis.vertical,
              physics: ScrollPhysics(),
              shrinkWrap: true,
              crossAxisCount: 2,
              children: List.generate(_imageUrlList.length, (index){
                return GestureDetector(
                  child: Center(
                    child: CachedNetworkImage(
                      imageUrl: _imageUrlList[index],
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
                        builder: (BuildContext context) => ExpandedImageDialog(url: _imageUrlList[index],)
                    );
                  },
                );
              }),
            )
          ],
        ),
      );
      _screenLandscapeContent =  SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: _screenWidth / _values.defaultSymmetricPadding),
        controller: _scrollController,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(height: _values.toolbarGapSizedBox,),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Text(
                widget.notice.title,
                style: _values.titleTextStyle,
              ),
            ),
            SizedBox(height: _screenHeight / 50,),
            Container(color: _hue.outlines, height: _values.lineSizedBoxHeight,),
            SizedBox(height: _screenHeight / 50,),
            Text(
              _newFinalText,
              style: _values.contentTextStyle,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                _showMoreFlatButton
              ],
            ),
            SizedBox(height: _screenHeight / 15,),
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
              scrollDirection: Axis.vertical,
              physics: ScrollPhysics(),
              shrinkWrap: true,
              crossAxisCount: 5,
              children: List.generate(_imageUrlList.length, (index){
                return GestureDetector(
                  child: Center(
                    child: CachedNetworkImage(
                      imageUrl: _imageUrlList[index],
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
                        builder: (BuildContext context) => ExpandedImageDialog(url: _imageUrlList[index], height: _screenHeight, width: _screenWidth,)
                    );
                  },
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
        Scaffold(
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
        )
            :
        Scaffold(
          backgroundColor: _hue.background,
          appBar: AppBar(
            backgroundColor: _hue.carmesi,
            title: Text("Galería"),
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
    BackButtonInterceptor.remove(backInterceptor);
    super.dispose();
  }
}