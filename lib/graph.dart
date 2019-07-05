import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'own_list.dart';
import 'data.dart';

class Graph extends StatefulWidget {
  String _graphType;
  Graph(this._graphType);
  @override
  _GraphState createState() => _GraphState(_graphType);
}

class _GraphState extends State<Graph> {
  String _graphType;
  String _txt = ' вес ';
  List<double> _listPoints;

  _GraphState(this._graphType);

  @override
  initState() {
    super.initState();
    _listPoints = List.generate(25, (_) => 0);
    _init();
  }

  _init() async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    List<String> list = pref.getStringList(_graphType) ?? List.generate(25, (_) => '');
    _listPoints = List(25);
    for(int i = 0; i <= 24; i++){
      if(list[i] != '') _listPoints[i] = double.tryParse(list[i]) ?? 0;
      else _listPoints[i] = 0;
    }
    setState(() {});
  }

  Widget _btn(String text){
    return Padding(
      padding: EdgeInsets.only(left: 16.0, top: 16.0),
      child: Ink(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black54),
          borderRadius: BorderRadius.all(Radius.circular(45.0)),
          boxShadow: [
            BoxShadow(blurRadius: 5, color: Colors.black26)
          ]
        ),
        child: InkWell(
          onTap: text == 'добавить' ? () async{
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => OwnList(_graphType))
            );
            _init();
          } : (){
            switch(_graphType){
              case 'boysLength': _graphType = 'boysWeight'; _txt = ' рост '; break;
              case 'boysWeight': _graphType = 'boysLength'; _txt = ' вес '; break;
              case 'girlsLength': _graphType = 'girlsWeight'; _txt = ' рост '; break;
              case 'girlsWeight': _graphType = 'girlsLength'; _txt = ' вес ';
            }
            _init();
          },
          highlightColor: Colors.black12,
          borderRadius: BorderRadius.all(Radius.circular(45.0)),
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              text,
              style: TextStyle(color: Colors.black54, fontSize: 20.0, fontFamily: 'Oswald'),
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
        child: Stack(
          children: <Widget>[
            CustomPaint(
              willChange: true,
              size: Size.infinite,
              painter: WHOGraph(_graphType, _listPoints),
            ),
            Positioned(
              bottom: 20.0,
              left: 4.0,
              child: Text(
                'месяц  >>',
                style: TextStyle(color: Colors.black54, fontSize: 18.0, fontFamily: 'Oswald'),
              ),
            ),
            Positioned(
              bottom: 24.0,
              right: 22.0,
              child: RotatedBox(
                quarterTurns: 3,
                child: Text(
                  _txt == ' вес ' ? 'рост, см  >>' : 'вес, кг  >>',
                  style: TextStyle(color: Colors.black54, fontSize: 18.0, fontFamily: 'Oswald'),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _btn('добавить'),
                _btn(_txt),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class WHOGraph extends CustomPainter{
  String _graphType;
  List<double> _listPoints;

  WHOGraph(this._graphType, this._listPoints);

  _unit(Canvas canvas, String unit, double x, double y){
    TextSpan span = TextSpan(
        style: TextStyle(color: Colors.black54, fontSize: 12.0, fontFamily: 'Oswald'),
        text: unit
    );
    TextPainter painter = TextPainter(
        text: span,
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr
    );
    painter.layout();
    painter.paint(canvas, Offset(x, y));
  }

  @override
  void paint(Canvas canvas, Size size) {
    double height = size.height-20;
    double width = size.width-20;
    Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    for(int i = 0; i <= 24; i++){
      canvas.drawLine(Offset(i*width/24, 0), Offset(i*width/24, height), paint..color = Colors.black12);
      _unit(canvas, i.toString(), i*width/24-5, height);
    }
    switch(_graphType){
      case 'boysLength':
      case 'girlsLength':
        for(int i = 0; i <= 30; i++){
          canvas.drawLine(Offset(0, i*height/30), Offset(width, i*height/30), paint..color = Colors.black12);
          if(i <= 15) _unit(canvas, (100-i*2*2).toString(), width+3, 2*i*height/30-12);
        } break;
      case 'boysWeight':
      case 'girlsWeight':
        for(int i = 1; i < 18; i++){
          canvas.drawLine(Offset(0, i*height/17), Offset(width, i*height/17), paint..color = Colors.black12);
          _unit(canvas, (18-i).toString(), width+3, i*height/17-12);
        }
    }
    for(int item = 0; item <= 6; item++){
      List<Offset> list = List();
      Path path = Path();
      Color color = Colors.green[800];
      switch(item){
        case 0:
        case 6: color = Colors.black; break;
        case 1:
        case 5: color = Colors.red[800]; break;
        case 2:
        case 4: color = Colors.yellow[800];
      }
      for(int i = 0; i <= 24; i++){
        switch(_graphType){
          case 'boysLength':
          case 'girlsLength': list.add(Offset(i*width/24, (100-Data().get(_graphType)[item][i])*height/60));
                              if(_listPoints[i] != 0) canvas.drawCircle(Offset(i*width/24, (100-_listPoints[i])*height/60), 5.0, Paint()..color = Colors.deepPurple);
                              break;
          case 'boysWeight':
          case 'girlsWeight': list.add(Offset(i*width/24, (18-Data().get(_graphType)[item][i])*height/17));
                              if(_listPoints[i] != 0) canvas.drawCircle(Offset(i*width/24, (18-_listPoints[i])*height/17), 5.0, Paint()..color = Colors.deepPurple);
        }
      }
      path.addPolygon(list, false);
      canvas.drawPath(path, paint..color = color);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}