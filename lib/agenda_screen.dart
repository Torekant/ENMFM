import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'values.dart';

class AgendaScreen extends StatefulWidget {
  AgendaScreen({Key key}) : super(key: key);

  @override
  _AgendaScreen createState() => _AgendaScreen();
}

class _AgendaScreen extends State<AgendaScreen>{

  static Values _values;
  static Hues _hue;
  ScrollController _scrollController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _values = new Values();
    _hue = new Hues();
    _scrollController = new ScrollController();
  }

  @override
  Widget build(BuildContext context) {

    double _screenWidth = MediaQuery.of(context).size.width; //lee el ancho de dispositivo
    double _screenHeight = MediaQuery.of(context).size.height; //lee el largo del dispositivo
    //double _symmetricPadding; //padding lateral de la pantalla

    //_symmetricPadding =  (_screenWidth * values.widthPaddingUnit) / 10; //Función que nos permite hacer un padding responsivo a cualquier resolución en ancho
    double _responsiveHeight = _screenHeight / _values.defaultDivisionForResponsiveHeight; //Función para altura responsiva de cada card en la lista
    double _responsiveWidth = _screenWidth / _values.defaultDivisionForResponsiveWidth; //Función para altura responsiva de cada card en la lista

    return OrientationBuilder(
      builder: (context, orientation){
        return orientation == Orientation.portrait
            ?
        Scaffold(
          backgroundColor: _hue.background,
          appBar: AppBar(
            backgroundColor: _hue.carmesi,
            title: Text("Agenda"),
          ),
          body: SingleChildScrollView(
            controller: _scrollController,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Text(
                      "Nuestros expertos en tecnología están trabajando muy duro para que está sección esté activa.",
                      style: _values.titleTextStyle,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Image.asset(
                    _values.screenOnWork,
                    height: _responsiveHeight / 1.5,
                    width: _responsiveWidth * 1.5,
                    fit: BoxFit.fill,
                  )
                ],
              ),
            ),
          ),
        )
            :
        Scaffold(
          backgroundColor: _hue.background,
          appBar: AppBar(
            backgroundColor: _hue.carmesi,
            title: Text("Agenda"),
          ),
          body: SingleChildScrollView(
            controller: _scrollController,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    child: Text(
                      "Nuestros expertos en tecnología están trabajando muy duro para que está sección esté activa.",
                      style: _values.titleTextStyle,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Image.asset(
                    _values.screenOnWork,
                    height: _responsiveHeight * 1.5,
                    width: _responsiveWidth,
                    fit: BoxFit.fill,
                  )
                ],
              ),
            ),
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