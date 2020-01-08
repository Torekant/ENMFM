import 'package:flutter/material.dart';
import 'schedule_screen.dart';
import 'agenda_screen.dart';
import 'administration_screen.dart';
import 'grades_screen.dart';
import 'announcements_screen.dart';
import 'events_screen.dart';
import 'news_screen.dart';

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
                    builder: (context) => AnnouncementsScreen(adminView: widget.admin,)
                )
            );
            break;
          case 5:
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => EventsScreen(adminView: widget.admin)
                )
            );
            break;
          case 6:
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => NewsScreen(adminView: widget.admin,)
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