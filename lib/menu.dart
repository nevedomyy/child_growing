import 'package:flutter/material.dart';
import 'graph.dart';

class Menu extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {

  Widget _btn(String text){
    return Expanded(
      child: Center(
        child: Ink(
          decoration: BoxDecoration(
            border: Border.all(color: text == 'МАЛЬЧИК' ? Colors.blue[300] : Colors.pink[300], width: 1.0),
            borderRadius: BorderRadius.all(Radius.circular(45.0)),
            boxShadow: [
              BoxShadow(blurRadius: 5, color: text == 'МАЛЬЧИК' ? Colors.blue[100] : Colors.pink[100])
            ]
          ),
          child: InkWell(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(
                builder: (context) => Graph(text == 'МАЛЬЧИК' ? 'boysLength' : 'girlsLength')
              ));
            },
            highlightColor: text == 'МАЛЬЧИК' ? Colors.blue[200] : Colors.pink[200],
            borderRadius: BorderRadius.all(Radius.circular(45.0)),
            child: Padding(
              padding: EdgeInsets.all(30.0),
              child: Text(
                text,
                style: TextStyle(color: Colors.black54, fontSize: 40.0, fontFamily: 'Oswald'),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: SafeArea(
        child: OrientationBuilder(
          builder: (context, orientation){
            if(orientation == Orientation.portrait){
              return Column(
                children: <Widget>[
                  _btn('МАЛЬЧИК'),
                  _btn('ДЕВОЧКА')
                ],
              );
            }else{
              return Row(
                children: <Widget>[
                  _btn('МАЛЬЧИК'),
                  _btn('ДЕВОЧКА')
                ],
              );
            }
          },
        ),
      )
    );
  }
}
