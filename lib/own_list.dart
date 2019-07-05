import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class OwnList extends StatefulWidget{
  String _graphType;
  OwnList(this._graphType);
  @override
  _OwnList createState() => _OwnList(_graphType);
}

class _OwnList extends State<OwnList>{
  List<TextEditingController> _controller;
  String _graphType;
  String _txt = '';

  _OwnList(this._graphType);

  @override
  void initState() {
    super.initState();
    _controller = List.generate(25, (_) => TextEditingController());
    _init();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.forEach((controller) => controller.dispose());
  }

  _init() async{
    switch(_graphType){
      case 'boysLength':
      case 'girlsLength': _txt = 'рост, см'; break;
      case 'boysWeight':
      case 'girlsWeight': _txt = 'вес, кг';
    }
    SharedPreferences pref = await SharedPreferences.getInstance();
    List<String> list = pref.getStringList(_graphType) ?? List.generate(25, (_) => '');
    for(int i = 0; i <= 24; i++){
      if(list[i] != '') _controller[i].text = list[i];
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Expanded(
                child: ScrollConfiguration(
                  behavior: Behavior(),
                  child: ListView.separated(
                    itemCount: 25,
                    separatorBuilder: (context, index){
                      return Divider(
                        color: Colors.black12,
                      );
                    },
                    itemBuilder: (context, index){
                      return Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Row(
                          children: <Widget>[
                            Text(
                              'месяц $index',
                              style: TextStyle(color: Colors.black54, fontSize: 16.0, fontFamily: 'Oswald'),
                            ),
                            Expanded(
                              child: TextField(
                                onChanged: (text) async{
                                  SharedPreferences pref = await SharedPreferences.getInstance();
                                  List<String> list = pref.getStringList(_graphType) ?? List.generate(25, (_) => '');
                                  list[index] = _controller[index].text;
                                  pref.setStringList(_graphType, list);
                                },
                                controller: _controller[index],
                                keyboardType: TextInputType.number,
                                textDirection: TextDirection.rtl,
                                cursorColor: Colors.black54,
                                style: TextStyle(color: Colors.black54, fontSize: 18.0, fontFamily: 'Oswald'),
                                decoration: InputDecoration.collapsed(hintText: null)
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              Row(
                children: <Widget>[
                  Ink(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black54),
                        borderRadius: BorderRadius.all(Radius.circular(45.0)),
                        boxShadow: [
                          BoxShadow(blurRadius: 5, color: Colors.black26)
                        ]
                    ),
                    child: InkWell(
                      onTap:(){Navigator.pop(context);},
                      highlightColor: Colors.black12,
                      borderRadius: BorderRadius.all(Radius.circular(45.0)),
                      child: Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          'закрыть',
                          style: TextStyle(color: Colors.black54, fontSize: 20.0, fontFamily: 'Oswald'),
                        ),
                      ),
                    ),
                  ),
                  Spacer(),
                  Text(
                    _txt,
                    style: TextStyle(color: Colors.black54, fontSize: 20.0, fontFamily: 'Oswald', fontWeight: FontWeight.bold),
                  )
                ],
              )
            ],
          ),
        )
      ),
    );
  }
}

class Behavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(BuildContext context, Widget child, AxisDirection axisDirection){
    return child;
  }
}