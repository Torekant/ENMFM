import 'package:flutter/material.dart';
import 'announcements_screen.dart';
import 'events_screen.dart';
import 'news_screen.dart';
import 'values.dart';

class OptionTile extends StatefulWidget{
  OptionTile({
    Key key,
    this.cardElevation,
    @required this.height,
    this.alignment,
    @required this.text,
    this.textStyle,
    this.icon,
    this.index,
    @required this.verticalPadding,
    @required this.horizontalPadding,
    @required this.admin
  }) : super(key: key);

  final double cardElevation;
  final double height;
  final MainAxisAlignment alignment;
  final String text;
  final TextStyle textStyle;
  final Icon icon;
  final index;
  final double verticalPadding;
  final double horizontalPadding;
  final bool admin;

  @override
  _OptionTile createState() => _OptionTile();
}

class _OptionTile extends State<OptionTile>{

  Values _values = new Values();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GestureDetector(
      child: Card(
        elevation: widget.cardElevation,
        child: Container(
          height: widget.height,
          child: Row(
            mainAxisAlignment: widget.alignment,
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(vertical: widget.verticalPadding, horizontal: widget.horizontalPadding),
                child: Text(
                  widget.text,
                  style: widget.textStyle,
                ),
              ),
              widget.icon
            ],
          ),
        ),
      ),
      onTap: (){
        switch(widget.index){
          case 0:
            Navigator.pushNamed(
                context,
                _values.routeNames['schedule']
            );
            break;
          case 1:
            Navigator.pushNamed(
                context,
                _values.routeNames['agenda']
            );
            break;
          case 2:
            Navigator.pushNamed(
                context,
                _values.routeNames['administration']
            );
            break;
          case 3:
            Navigator.pushNamed(
                context,
                _values.routeNames['grades']
            );
            break;
          case 4:
            Navigator.pushNamed(
              context,
              _values.routeNames['announcements'],
              arguments: AnnouncementsScreen(
                adminView: widget.admin,
              )
            );
            break;
          case 5:
            Navigator.pushNamed(
                context,
                _values.routeNames['events'],
                arguments: EventsScreen(
                  adminView: widget.admin,
                )
            );
            break;
          case 6:
            Navigator.pushNamed(
                context,
                _values.routeNames['news'],
                arguments: NewsScreen(
                  adminView: widget.admin,
                )
            );
            break;
          default:
            print("no index");
            break;
        }
      },
    );
  }

}

class AnnouncementCard extends StatefulWidget{

  AnnouncementCard({
   Key key,
   @required this.height,
   @required this.width,
   @required this.text,
   @required this.date,
   this.editable : false,
   this.orientation : Orientation.portrait,
   this.onUpdate,
   this.onDestroy
  }) : super (key:key);

  final double height;
  final double width;
  String text;
  final String date;
  final bool editable;
  final Orientation orientation;

  final void Function(String) onUpdate;
  final VoidCallback onDestroy;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _AnnouncementCard();
  }
}

class _AnnouncementCard extends State<AnnouncementCard>{

  Values _values = new Values();
  Hues _hue = new Hues();
  ScrollController _scrollController = new ScrollController();
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  int _widthValue, _heightValue;

  @override
  Widget build(BuildContext context) {

    widget.orientation == Orientation.portrait ? {_widthValue = 9, _heightValue = 18} : { _widthValue = 18, _heightValue = 9};

    TextEditingController _textController = new TextEditingController(text: widget.text);

    // TODO: implement build
    return widget.editable || widget.editable == null ? Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.fromLTRB(0.0, widget.height / 50, 0.0, 0.0),
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
                        widget.date,
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
                          SizedBox(height: widget.height / 30,),
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
                                  widget.onUpdate(_textController.text);
                                }
                              },
                              keyboardType: TextInputType.text,
                              maxLines: null,
                              style: _values.textFieldTextStyle,
                            ),
                          ),
                          SizedBox(height: widget.height / 30,)
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
                height: widget.height / _heightValue,
                width:  widget.width / _widthValue,
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
                    widget.onDestroy();
                  },
                ),
              )
            ],
          ),
        ),
      ],
    ) : Container(
      padding: EdgeInsets.fromLTRB(0.0, widget.height / 150, 0.0, 0.0),
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
                    widget.date,
                    style: _values.subtitleTextStyle,
                  ),
                ),
                Container(
                  color: _hue.carmesi,
                  height: _values.lineSizedBoxHeight,
                ),
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal: widget.width / 20),
                  child: Text(
                    widget.text,
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

}