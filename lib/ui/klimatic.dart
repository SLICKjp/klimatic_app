import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../util/utils.dart' as util;
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Klimatic extends StatefulWidget {
  @override
  _KlimaticState createState() => _KlimaticState();
}

class _KlimaticState extends State<Klimatic> {
  String _cityEntered;
  Future _goToNextScreen(BuildContext context) async {
    Map result = await Navigator.of(context)
        .push(new MaterialPageRoute(builder: (BuildContext context) {
      return new ChangeCity();
    }));
    if (result != null && result.containsKey('info')) {
      _cityEntered= result['info'];
    //  print(result['info'].toString());
    }
  }

  void showStuff() async {
    Map data = await getWeather(util.appid, util.defaultCity);
    print(data.toString());
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Klimatic'),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
        actions: <Widget>[
          new IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                _goToNextScreen(context);
              }),
        ],
      ),
      body: new Stack(
        children: <Widget>[
          Center(
            child: Image.asset(
              'images/umbrella.png',
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.fill,
            ),
          ),
          new Container(
            alignment: Alignment.topRight,
            child: Text(
              '$_cityEntered',
              style: new TextStyle(
                fontStyle: FontStyle.normal,
                color: Colors.white,
                fontSize: 15.3,
              ),
            ),
          ),
          new Container(
            alignment: Alignment.center,
            child: Image.asset('images/light_rain.png'),
          ),
          new Container(
              margin: const EdgeInsets.fromLTRB(30.0, 250.0, 0.0, 0.0),
              child: updateTempWidget(_cityEntered==null ? util.defaultCity:_cityEntered)),
        ],
      ),
    );
  }

  Future<Map> getWeather(String appid, String city) async {
    String apiUrl =
        "http://api.openweathermap.org/data/2.5/weather?q=$city,&appid=${util.appid}&units=metric";
    http.Response response = await http.get(apiUrl);
    return jsonDecode(response.body);
  }

  Widget updateTempWidget(String city) {
    return FutureBuilder(
        future: getWeather(util.appid, city==null? util.defaultCity : city),
        // ignore: missing_return
        builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
          if (snapshot.hasData) {
            Map content = snapshot.data;
            return Container(
              child: Column(
                children: <Widget>[
                  new ListTile(
                    title: Text(
                      content['main']['temp'].toString()+"°C",
                      style: TextStyle(
                        fontSize: 49.9,
                        color: Colors.white,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        });
  }
}

class ChangeCity extends StatelessWidget {
  var _cityController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text('Change City'),
        centerTitle: true,
      ),
      body: new Stack(
        children: <Widget>[
          new Center(
            child: new Image.asset(
              'images/white_snow.png',
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.fill ,
            ),
          ),
       new Container(
         child: new ListTile(
           title: new TextField(
             controller: _cityController,
             keyboardType: TextInputType.text,
             decoration: new InputDecoration(
               hintText: 'Enter your city'
             ),
           ),
         ),
       ),

       new Container(
          margin: EdgeInsets.fromLTRB(0, 55, 0, 0),
          child: new ListTile(
            title: new FlatButton(
                onPressed: (){
                   Navigator.pop(context,{
                     'info': _cityController.text
                   });
                },
                textColor: Colors.white70,
                color: Colors.red,
                child: new Text('Get Weather')),
          ),
       )



        ],
      ),
    );
  }
}
