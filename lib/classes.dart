import 'package:connectivity/connectivity.dart';
import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'values.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:random_string/random_string.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyConnectivity {
  MyConnectivity._internal();

  static final MyConnectivity _instance = MyConnectivity._internal();

  static MyConnectivity get instance => _instance;

  Connectivity connectivity = Connectivity();

  StreamController controller = StreamController.broadcast();

  Stream get myStream => controller.stream;

  void initialise() async {
    ConnectivityResult result = await connectivity.checkConnectivity();
    _checkStatus(result);
    connectivity.onConnectivityChanged.listen((result) {
      _checkStatus(result);
    });
  }

  void _checkStatus(ConnectivityResult result) async {
    bool isOnline = false;
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        isOnline = true;
      } else
        isOnline = false;
    } on SocketException catch (_) {
      isOnline = false;
    }
    controller.sink.add({result: isOnline});
  }

  void disposeStream() => controller.close();
}

class CustomDialog extends StatelessWidget{
  final description, acceptButtonText;
  final values = new Values();
  final hue = new Hues();

  CustomDialog({
    @required this.description,
    @required this.acceptButtonText
  });

  @override
  Widget build(BuildContext context) {
    return  AlertDialog(
      titlePadding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, values.standardPaddingBottom),
      title: SizedBox(
          height: values.toolbarGapSizedBox,
          child: Container(color: hue.carmesi)
      ),
      content: Text(
        this.description,
        textAlign: TextAlign.center
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: (){
            Navigator.of(context).pop(true);
          },
          child: Text(this.acceptButtonText),
          textColor: hue.ocean
        ),
      ],
    );
  }
}

class CustomAlertDialog extends StatelessWidget{
  final description, acceptButtonText, cancelButtonText;
  final values = new Values();
  final hue = new Hues();

  CustomAlertDialog({
    @required this.description,
    @required this.acceptButtonText,
    @required this.cancelButtonText
  });

  @override
  Widget build(BuildContext context) {
    return  AlertDialog(
      titlePadding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, values.standardPaddingBottom),
      title: SizedBox(
          height: values.toolbarGapSizedBox,
          child: Container(color: hue.carmesi)
      ),
      content: Text(this.description, textAlign: TextAlign.center,),
      actions: <Widget>[
        FlatButton(
          onPressed: (){
            Navigator.of(context).pop(false);
          },
          child: Text(this.cancelButtonText),
          textColor: hue.ocean,
        ),
        FlatButton(
          onPressed: (){
            Navigator.of(context).pop(true);
          },
          child: Text(this.acceptButtonText),
          textColor: hue.ocean,
        ),
      ],
    );
  }
}

class CustomLoadDialog extends StatelessWidget{

  final Values values = Values();

  @override
  Widget build(BuildContext context) {

    final _screenWidth = MediaQuery.of(context).size.width;

    return new WillPopScope(
        child: AlertDialog(
          backgroundColor: Colors.transparent,
          content: Container(
            child: Image.asset(
              values.loadingAnimation,
              scale: _screenWidth / 100,
            ),
          ),
        ),
        onWillPop: () => Future.value(false)
    );
  }

}

class CustomFormDialog extends StatefulWidget{
  CustomFormDialog({Key key, this.description, this.acceptButtonText, this.cancelButtonText, this.dialogPurpose}) : super(key: key);

  final description, acceptButtonText, cancelButtonText, dialogPurpose;

  @override
  _CustomFormDialog createState() => _CustomFormDialog();
}

class _CustomFormDialog extends State<CustomFormDialog>{
  Values values = new Values();
  final hue = new Hues();
  static GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _nick = '', _email = '', _pass = '';
  Widget _formColumn, _acceptButton;

  @override
  void initState() {
    super.initState();

    switch(widget.dialogPurpose){
      case 0:
        TextEditingController _mailTextController = new TextEditingController(text: _email);
        TextEditingController _passwordTextController = new TextEditingController(text:  _pass);
        TextEditingController _nickTextController = new TextEditingController(text:  _nick);

        _formColumn = Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(widget.description, textAlign: TextAlign.center,),
            SizedBox(height: values.smallSizedBoxStandardHeight,),
            TextFormField(
              controller: _nickTextController,
              decoration: new InputDecoration(
                  labelText: "Nombre",
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
                          color: hue.outlines
                      )
                  )
              ),
              validator: (val) {
                if(val.length==0) {
                  return values.emptyTextFieldMessage;
                }else{
                  return null;
                }
              },
              onEditingComplete: (){
                setState(() {
                  _nick = _nickTextController.text;
                });
                FocusScope.of(context).requestFocus(FocusNode());
              },
              keyboardType: TextInputType.emailAddress,
              style: values.textFieldTextStyle,
            ),
            SizedBox(height: values.smallSizedBoxStandardHeight,),
            TextFormField(
              controller: _mailTextController,
              decoration: new InputDecoration(
                  labelText: "Email",
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
                          color: hue.outlines
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
              onEditingComplete: (){
                setState(() {
                  _email = _mailTextController.text;
                });
                FocusScope.of(context).requestFocus(FocusNode());
              },
              keyboardType: TextInputType.emailAddress,
              style: values.textFieldTextStyle,
            ),
            SizedBox(height: values.smallSizedBoxStandardHeight,),
            TextFormField(
              controller: _passwordTextController,
              decoration: new InputDecoration(
                  labelText: "Contraseña",
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
                          color: hue.outlines
                      )
                  )
              ),
              validator: (val) {
                if(val.length==0) {
                  return values.emptyTextFieldMessage;
                }else{
                  return null;
                }
              },
              onEditingComplete: (){
                setState(() {
                  _pass = _passwordTextController.text;
                });
                FocusScope.of(context).requestFocus(FocusNode());
              },
              keyboardType: TextInputType.emailAddress,
              style: values.textFieldTextStyle,
            )
          ],
        );
        _acceptButton = FlatButton(
          onPressed: () async{
            if (_formKey.currentState.validate()) {
              User adminDummy = new User('', '', '', '', false, false);

              showDialog(
                context: context,
                builder: (BuildContext context) => CustomLoadDialog()
              );

              await adminDummy.CreateAdmin(_nickTextController.text, _mailTextController.text, _passwordTextController.text, context).then((result){
                Navigator.of(context).pop();
              });
              Navigator.of(context).pop(true);
            }
          },
          child: Text(widget.acceptButtonText),
          textColor: hue.ocean,
        );
        break;
      case 1:
        TextEditingController _mailTextController = new TextEditingController(text: _email);

        _formColumn = Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(widget.description, textAlign: TextAlign.center,),
            SizedBox(height: values.smallSizedBoxStandardHeight,),
            TextFormField(
              controller: _mailTextController,
              decoration: new InputDecoration(
                  labelText: "Email",
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
                  return values.emptyTextFieldMessage;
                }else{
                  if(val.contains('@')){
                    return null;
                  }else{
                    return values.notValidEmailMessage;
                  }
                }
              },
              onEditingComplete: (){
                setState(() {
                  _email = _mailTextController.text;
                });
                FocusScope.of(context).requestFocus(FocusNode());
              },
              keyboardType: TextInputType.emailAddress,
              style: values.textFieldTextStyle,
            )
          ],
        );
        _acceptButton = FlatButton(
          onPressed: () async{
            if (_formKey.currentState.validate()) {
              User adminDummy = new User('', '', '', '', false, false);
              await adminDummy.ResetPassword(_mailTextController.text);
              Navigator.of(context).pop(true);
            }
          },
          child: Text(widget.acceptButtonText),
          textColor: hue.ocean,
        );
        break;
      case 2:
        TextEditingController _mailTextController = new TextEditingController(text: _email);
        TextEditingController _passwordTextController = new TextEditingController(text:  _pass);

        _formColumn = Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(widget.description, textAlign: TextAlign.center,),
            SizedBox(height: values.smallSizedBoxStandardHeight,),
            TextFormField(
              controller: _passwordTextController,
              decoration: new InputDecoration(
                  labelText: "Contraseña",
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
                          color: hue.outlines
                      )
                  )
              ),
              validator: (val) {
                if(val.length==0) {
                  return values.emptyTextFieldMessage;
                }else{
                  return null;
                }
              },
              onEditingComplete: (){
                setState(() {
                  _pass = _mailTextController.text;
                });
                FocusScope.of(context).requestFocus(FocusNode());
              },
              obscureText: true,
              style: values.textFieldTextStyle,
            )
          ],
        );
        _acceptButton = FlatButton(
          onPressed: () async{
            if (_formKey.currentState.validate()) {
              Navigator.of(context).pop(_passwordTextController.text);
            }
          },
          child: Text(widget.acceptButtonText),
          textColor: hue.ocean,
        );
        break;
      case 3:
        TextEditingController _textController = new TextEditingController(text: _email);

        _formColumn = Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(widget.description, textAlign: TextAlign.center,),
            SizedBox(height: values.smallSizedBoxStandardHeight,),
            TextFormField(
              maxLines: null,
              controller: _textController,
              decoration: new InputDecoration(
                  labelText: "Aviso",
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
                          color: hue.outlines
                      )
                  )
              ),
              validator: (val) {
                if(val.length==0) {
                  return values.emptyTextFieldMessage;
                }else{
                  return null;
                }
              },
              onEditingComplete: (){
                setState(() {
                  _nick = _textController.text;
                });
                FocusScope.of(context).requestFocus(FocusNode());
              },
              keyboardType: TextInputType.text,
              style: values.textFieldTextStyle,
            ),
          ],
        );

        _acceptButton = FlatButton(
          onPressed: () async{
            if (_formKey.currentState.validate()) {
              Navigator.of(context).pop(_textController.text);
            }
          },
          child: Text(widget.acceptButtonText),
          textColor: hue.ocean,
        );
        break;
    }

  }


  @override
  Widget build(BuildContext context) {

    return AlertDialog(
      titlePadding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, values.standardPaddingBottom),
      title: SizedBox(
          height: values.toolbarGapSizedBox,
          child: Container(color: hue.carmesi)
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: _formColumn,
        ),
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: (){
            Navigator.of(context).pop(false);
          },
          child: Text(widget.cancelButtonText),
          textColor: hue.ocean,
        ),
        _acceptButton,
      ],
    );
  }
}

class Event{

  String id;
  String image;
  String place;
  String date;
  String time;
  String title;
  String description;
  String type;

  Event(String id, String title, String image, String place, String date, String time, String description, String type){
    this.id = id;
    this.title = title;
    this.image = image;
    this.place = place;
    this.date = date;
    this.time = time;
    this.description = description;
    this.type = type;
  }

  Future<String> ChangeImage(var image, String newImageName) async{
    Values values = new Values();

    String finalURL = "https://i.all3dp.com/cdn-cgi/image/fit=cover,w=1284,h=722,gravity=0.5x0.5,format=auto/wp-content/uploads/2018/12/28144052/background-images-can-come-in-handy-when-modeling-tian-ooi-all3dp-181228.jpg";

    StorageUploadTask uploadTask =  values.storageReference.child("events").child(newImageName + "/").putFile(image);
    await uploadTask.onComplete;

    await values.storageReference.child("events").child(newImageName).getDownloadURL().then((fileURL){
      values.firestoreReference.collection("events").document(this.id).updateData({"image": fileURL});
      finalURL = fileURL;
      values.storageReference.getStorage().getReferenceFromUrl(this.image).then((ref){
        ref.delete();
      });
    });

    return finalURL;
  }

  Future<String> UpdateEvent(String data, String field) async{

    Values values = new Values();

    switch(field){
      case 'title':
         await values.firestoreReference.collection("events").document(this.id).updateData({"title": data});
          return data;
        break;
      case 'place':
        await values.firestoreReference.collection("events").document(this.id).updateData({"place": data});
        return data;
        break;
      case 'date':
        await values.firestoreReference.collection('events').document(this.id).updateData({'date': data});
        return data;
        break;
      case 'time':
        await values.firestoreReference.collection('events').document(this.id).updateData({'time': data});
        return data;
        break;
      case 'host':
        await values.firestoreReference.collection("events").document(this.id).updateData({'host': data});
        return data;
        break;
      case 'description':
        await values.firestoreReference.collection('events').document(this.id).updateData({'description': data});
        return data;
        break;
    }

  }

  Future<bool> CreateEvent(BuildContext context, var image) async{
    Values values = new Values();

    String imageName = randomAlphaNumeric(20);
    imageName = imageName + DateTime.now().toString();

    try{
      StorageUploadTask uploadTask =  values.storageReference.child("events").child(imageName + "/").putFile(image);
      await uploadTask.onComplete;

      await values.storageReference.child("events").child(imageName).getDownloadURL().then((fileURL){
        this.image = fileURL;
      });

      await values.firestoreReference.collection('events').add({
        'title': this.title,
        'place': this.place,
        'date': this.date,
        'time': this.time,
        'description': this.description,
        'image': this.image,
        'type': values.eventType['ceremony']
      });

      return true;
    }catch(e){
      Navigator.of(context).pop();
      if(Platform.isAndroid){
        Navigator.of(context).pop();
        switch(e.code){
          case 'ERROR_WRONG_PASSWORD':
            showDialog(
                context: context,
                builder: (BuildContext context) => CustomDialog(
                  description: "Los datos son incorrectos.",
                  acceptButtonText: "Aceptar",
                )
            );
            break;
          case 'ERROR_USER_NOT_FOUND':
            showDialog(
                context: context,
                builder: (BuildContext context) => CustomDialog(
                  description: "Los datos son incorrectos.",
                  acceptButtonText: "Aceptar",
                )
            );
            break;
          case 'FirebaseException':
            showDialog(
                context: context,
                builder: (BuildContext context) => CustomDialog(
                  description: "Hubo un problema con la conexión, inténtelo más tarde.",
                  acceptButtonText: "Aceptar",
                )
            );
            break;
          default:
            showDialog(
                context: context,
                builder: (BuildContext context) => CustomDialog(
                  description: "Hubo un problema con la conexión, inténtelo más tarde.",
                  acceptButtonText: "Aceptar",
                )
            );
            break;
        }
      }
      if(Platform.isIOS){
        switch(e.code){
          case 'Error 17011':
            showDialog(
                context: context,
                builder: (BuildContext context) => CustomDialog(
                  description: "Los datos son incorrectos.",
                  acceptButtonText: "Aceptar",
                )
            );
            break;
          case 'Error 17009':
            showDialog(
                context: context,
                builder: (BuildContext context) => CustomDialog(
                  description: "Los datos son incorrectos.",
                  acceptButtonText: "Aceptar",
                )
            );
            break;
          case 'Error 17020':
            showDialog(
                context: context,
                builder: (BuildContext context) => CustomDialog(
                  description: "Hubo un problema con la conexión, inténtelo más tarde.",
                  acceptButtonText: "Aceptar",
                )
            );
            break;
          default:
            showDialog(
                context: context,
                builder: (BuildContext context) => CustomDialog(
                  description: "Hubo un problema con la conexión, inténtelo más tarde.",
                  acceptButtonText: "Aceptar",
                )
            );
            break;
        }
      }
      return false;
    }
  }

  Future<bool> DeleteEvent(BuildContext context) async{
    Values values = new Values();

    try{
      await values.storageReference.getStorage().getReferenceFromUrl(this.image).then((ref){
        ref.delete();
      });

      await values.firestoreReference.collection('events').document(this.id).delete();

      return true;
    }catch(e){
      Navigator.of(context).pop();
      if(Platform.isAndroid){
        Navigator.of(context).pop();
        switch(e.code){
          case 'ERROR_WRONG_PASSWORD':
            showDialog(
                context: context,
                builder: (BuildContext context) => CustomDialog(
                  description: "Los datos son incorrectos.",
                  acceptButtonText: "Aceptar",
                )
            );
            break;
          case 'ERROR_USER_NOT_FOUND':
            showDialog(
                context: context,
                builder: (BuildContext context) => CustomDialog(
                  description: "Los datos son incorrectos.",
                  acceptButtonText: "Aceptar",
                )
            );
            break;
          case 'FirebaseException':
            showDialog(
                context: context,
                builder: (BuildContext context) => CustomDialog(
                  description: "Hubo un problema con la conexión, inténtelo más tarde.",
                  acceptButtonText: "Aceptar",
                )
            );
            break;
          default:
            showDialog(
                context: context,
                builder: (BuildContext context) => CustomDialog(
                  description: "Hubo un problema con la conexión, inténtelo más tarde.",
                  acceptButtonText: "Aceptar",
                )
            );
            break;
        }
      }
      if(Platform.isIOS){
        switch(e.code){
          case 'Error 17011':
            showDialog(
                context: context,
                builder: (BuildContext context) => CustomDialog(
                  description: "Los datos son incorrectos.",
                  acceptButtonText: "Aceptar",
                )
            );
            break;
          case 'Error 17009':
            showDialog(
                context: context,
                builder: (BuildContext context) => CustomDialog(
                  description: "Los datos son incorrectos.",
                  acceptButtonText: "Aceptar",
                )
            );
            break;
          case 'Error 17020':
            showDialog(
                context: context,
                builder: (BuildContext context) => CustomDialog(
                  description: "Hubo un problema con la conexión, inténtelo más tarde.",
                  acceptButtonText: "Aceptar",
                )
            );
            break;
          default:
            showDialog(
                context: context,
                builder: (BuildContext context) => CustomDialog(
                  description: "Hubo un problema con la conexión, inténtelo más tarde.",
                  acceptButtonText: "Aceptar",
                )
            );
            break;
        }
      }

      return false;
    }

  }
}

class User{

  String idAuth;
  String idDB;
  String nickname;
  String email;
  bool admin;
  bool masterAdmin;

  User(String idAuth, String idDB, String nickname, String email, bool admin, bool masterAdmin){
    this.idAuth = idAuth;
    this.idDB = idDB;
    this.nickname = nickname;
    this.email = email;
    this.admin = admin;
    this.masterAdmin = masterAdmin;
  }

  Future<FirebaseUser> CreateAdmin(String nickname, String mail, String password, BuildContext context) async{

    Values values = new Values();
    FirebaseUser user;

    try{
      AuthResult result = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: mail, password: password);
      user = result.user;
      values.firestoreReference.collection('admins').add({
        'idAuth': user.uid,
        'nickname': nickname,
        'admin': true,
        'email': user.email,
        'masterAdmin': false
      });

    }catch(e){
      Navigator.of(context).pop();
      if(Platform.isAndroid){
        switch(e.code){
          case 'ERROR_WRONG_PASSWORD':
            showDialog(
                context: context,
                builder: (BuildContext context) => CustomDialog(
                  description: "Los datos son incorrectos.",
                  acceptButtonText: "Aceptar",
                )
            );
            break;
          case 'ERROR_USER_NOT_FOUND':
            showDialog(
                context: context,
                builder: (BuildContext context) => CustomDialog(
                  description: "Los datos son incorrectos.",
                  acceptButtonText: "Aceptar",
                )
            );
            break;
          case 'FirebaseException':
            showDialog(
                context: context,
                builder: (BuildContext context) => CustomDialog(
                  description: "Hubo un problema con la conexión, inténtelo más tarde.",
                  acceptButtonText: "Aceptar",
                )
            );
            break;
        }
      }
      if(Platform.isIOS){
        switch(e.code){
          case 'Error 17011':
            showDialog(
                context: context,
                builder: (BuildContext context) => CustomDialog(
                  description: "Los datos son incorrectos.",
                  acceptButtonText: "Aceptar",
                )
            );
            break;
          case 'Error 17009':
            showDialog(
                context: context,
                builder: (BuildContext context) => CustomDialog(
                  description: "Los datos son incorrectos.",
                  acceptButtonText: "Aceptar",
                )
            );
            break;
          case 'Error 17020':
            showDialog(
                context: context,
                builder: (BuildContext context) => CustomDialog(
                  description: "Hubo un problema con la conexión, inténtelo más tarde.",
                  acceptButtonText: "Aceptar",
                )
            );
            break;
        }
      }
    }

    return user;

  }

  Future<bool> DestroyAdmin(BuildContext context) async{
    Values values = new Values();

    try{
      await values.firestoreReference.collection('admins').document(this.idDB).delete();
      return true;
    }catch(e){
      Navigator.of(context).pop();
      if(Platform.isAndroid){
        switch(e.code){
          case 'ERROR_WRONG_PASSWORD':
            showDialog(
                context: context,
                builder: (BuildContext context) => CustomDialog(
                  description: "Los datos son incorrectos.",
                  acceptButtonText: "Aceptar",
                )
            );
            break;
          case 'ERROR_USER_NOT_FOUND':
            showDialog(
                context: context,
                builder: (BuildContext context) => CustomDialog(
                  description: "Los datos son incorrectos.",
                  acceptButtonText: "Aceptar",
                )
            );
            break;
          case 'FirebaseException':
            showDialog(
                context: context,
                builder: (BuildContext context) => CustomDialog(
                  description: "Hubo un problema con la conexión, inténtelo más tarde.",
                  acceptButtonText: "Aceptar",
                )
            );
            break;
        }
      }
      if(Platform.isIOS){
        switch(e.code){
          case 'Error 17011':
            showDialog(
                context: context,
                builder: (BuildContext context) => CustomDialog(
                  description: "Los datos son incorrectos.",
                  acceptButtonText: "Aceptar",
                )
            );
            break;
          case 'Error 17009':
            showDialog(
                context: context,
                builder: (BuildContext context) => CustomDialog(
                  description: "Los datos son incorrectos.",
                  acceptButtonText: "Aceptar",
                )
            );
            break;
          case 'Error 17020':
            showDialog(
                context: context,
                builder: (BuildContext context) => CustomDialog(
                  description: "Hubo un problema con la conexión, inténtelo más tarde.",
                  acceptButtonText: "Aceptar",
                )
            );
            break;
        }
      }
      return false;
    }

  }
  
  Future<bool> ResetPassword(String mail) async{
    try{
      await FirebaseAuth.instance.sendPasswordResetEmail(email: mail);
    }catch(e){
      print(e);
    }
  }

  Future<bool> UpdateEmail(String password, String newMail) async{

    Values values = new Values();

    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: this.email, password: password).then((credential){
        credential.user.updateEmail(newMail);
      });
      await values.firestoreReference.collection('admins').document(this.idDB).updateData({'email': newMail});
      return true;
    }catch(e){
      return false;
    }

  }
}

class Announcement{
  String id;
  String text;
  DateTime timestamp;

  Announcement(String id, String text, DateTime timestamp){
    this.id = id;
    this.text = text;
    this.timestamp = timestamp;
  }
}