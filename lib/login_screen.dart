import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'values.dart';
import 'classes.dart';
import 'functions.dart';
import 'menu_screens.dart';

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

              adminLogin(_idTextController.text, _passwordTextController.text, context).then((fireUser) async{
                if(fireUser != null){
                  Navigator.of(context).pop();
                  values.firestoreReference.collection('admins').where('email', isEqualTo: fireUser.email).snapshots().listen((data){

                    User user = new User(fireUser.uid, data.documents[0].documentID, data.documents[0]['nickname'], data.documents[0]['email'], data.documents[0]['admin'], data.documents[0]['masterAdmin']);
                    Navigator.pushReplacementNamed(
                      context,
                      values.routeNames['admin_home'],
                      arguments: AdminScreen(
                        user: user,
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