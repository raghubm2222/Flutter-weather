import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import "dart:core";

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Homepage(),
    );
  }
}

class Homepage extends StatefulWidget {
  const Homepage({
    Key key,
  }) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  String main;
  String city;
  double temperature;
  double windeSpeed;
  @override
  void initState() {
    getData();
    super.initState();
  }

  void getData() async {
    await Geolocator.requestPermission();
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    var latitude = position.latitude;
    var longitude = position.longitude;
    var data = await http.read(
        'https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=3cb72a591f6387693e456a2e95d80261');
    final jsonData = jsonDecode(data);
    setState(() {
      main = jsonData['weather'][0]['main'];
      city = jsonData['name'];
      windeSpeed = jsonData['wind']['speed'];
      temperature = jsonData['main']['temp'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff6ff8e7),
      body: main == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(
                          Icons.pin_drop,
                        ),
                        Text(
                          city,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.calendar_today_outlined,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Column(
                      children: [
                        Text(main),
                        Text(temperature.toString()),
                        Text(windeSpeed.toString())
                      ],
                    ),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          bottom: 35.0, left: 10, right: 10),
                      child: Row(
                        children: [
                          Datecontainer(),
                          Datecontainer(),
                          Datecontainer(),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
    );
  }
}

class Datecontainer extends StatelessWidget {
  const Datecontainer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      width: 120,
      height: 180,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15), color: Colors.white38),
    );
  }
}

//  onPressed: () async {
