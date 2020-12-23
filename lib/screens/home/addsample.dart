import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:texture_app/models/texture_models.dart';
import 'package:texture_app/services/app_hive.dart';
import 'package:texture_app/models/sample.dart';
import 'package:texture_app/models/common_keys.dart';
import 'package:texture_app/models/site.dart';
import 'package:texture_app/models/sample.dart';
import 'package:texture_app/services/site_database.dart';

import 'date.dart';

void main() => runApp(MyApp());


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Maps',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),

      home: MyHomePage(title: 'Add Sample'),
    );
  }
}

class MyHomePage extends StatefulWidget {

  MyHomePage({Key key, this.title = 'Add Sample'}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  StreamSubscription _locationSubscription;
  Location _locationTracker = Location();
  Marker marker;
  Circle circle;
  GoogleMapController _controller;
  double sampledLat = 37.42796133580664;
  double sampledLon = -122.085749655962;
  List<Sample> samples = [];
  int depthUpper = 0;
  int depthLower = 10;
  Site site;




  Future<Uint8List> getMarker() async {
    ByteData byteData = await DefaultAssetBundle.of(context).load("assets/car_icon.png");
    return byteData.buffer.asUint8List();
  }

  Future<Map<String,double>> getCurrentLocation() async {
    double lat = sampledLat;
    double lon = sampledLon;

    try {

//      Uint8List imageData = await getMarker();
      var location = await _locationTracker.getLocation();
      lon = location.longitude;
      lat = location.latitude;



    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        debugPrint("Permission Denied");
      }
    }
    return {LAT:lat, LON: lon};
  }

  @override
  void dispose() {
    if (_locationSubscription != null) {
      _locationSubscription.cancel();
    }
    super.dispose();
  }


  List<Site> allSites = [];
  bool dataLoaded = false;
  String baseSiteKey =  "BaseSite";
  List<Sample> baseSamples = [];

  @override
  Widget build(BuildContext context) {

    Site iSite = Site(
        name: baseSiteKey,
        classification: "aus",
        rawSamples: []
    );


    Future<void> loadData() async {
      bool alreadySite = await saveSite(iSite);
      if (alreadySite){
        print("Cant use this name; already exists");
      }
      this.allSites = await getSites();
      dataLoaded = true;
      List<dynamic> baseSiteList = allSites.where((s) => s.name == baseSiteKey).toList();
      Site baseSite = baseSiteList[0];
      site = baseSite;
      baseSamples = baseSite.samples;
      print(baseSamples);
      setState(() {});
    }
    if (!dataLoaded){
      print("trying to load");
      loadData();
    }


    var txt2 = TextEditingController();
    txt2.text = depthUpper.toString();
    txt2.selection = TextSelection.fromPosition(TextPosition(offset: depthUpper.toString().length));

    var txt3 = TextEditingController();
    txt3.text = depthLower.toString();
    txt3.selection = TextSelection.fromPosition(TextPosition(offset: depthLower.toString().length));

    AusClassification ausClassification = AusClassification();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text('Texture Class'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FlatButton(
                  color: Colors.grey[300],
                  onPressed: () {  },
                  child: Text(ausClassification.sandyLoam.name),
                ),
                FlatButton(
                  color: Colors.grey[300],
                  onPressed: () {  },
                  child: Text(ausClassification.loam.name),
                ),
                FlatButton(
                  color: Colors.grey[300],
                  onPressed: () {  },
                  child: Text(ausClassification.sandyClay.name),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FlatButton(
                  color: Colors.grey[300],
                  onPressed: () {  },
                  child: Text(ausClassification.clay.name),
                ),
                FlatButton(
                  color: Colors.grey[300],
                  onPressed: () {  },
                  child: Text(ausClassification.siltyClay.name),
                ),
                FlatButton(
                  color: Colors.grey[300],
                  onPressed: () {  },
                  child: Text(ausClassification.siltyLoam.name),
                )
              ],
            ),
            Row(
              children: [
                Text('Depth Range '),
                ConstrainedBox(
                  constraints: BoxConstraints.tight(Size(55, 55)),
                  child: TextFormField(
                    maxLength: 3,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        counterText: ''
                    ),
                    style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Oswald',
                      color: Color(0xB3383838),
                    ),
                    // initialValue: att.toString(),
                    controller: txt2,
                    // inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                    autovalidate: true,
                    keyboardType: TextInputType.number,
                    onChanged: (val){
                      setState(() {
                        depthUpper = int.parse(val);
                        print(depthUpper);
                      });

                    },
                  ),
                ),
                Text('to'),
                ConstrainedBox(
                  constraints: BoxConstraints.tight(Size(55, 55)),
                  child: TextFormField(
                    maxLength: 3,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        counterText: ''
                    ),
                    style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Oswald',
                      color: Color(0xB3383838),
                    ),
                    // initialValue: att.toString(),
                    controller: txt3,
                    // inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                    autovalidate: true,
                    keyboardType: TextInputType.number,
                    onChanged: (val){
                      setState(() {
                        depthLower = int.parse(val);
                        print(depthLower);
                      });

                    },
                  ),
                ),
                Text(' cm'),
              ],
            ),
            FlatButton(
              color: Colors.blue,
              child: Text('Date'),
              onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DatePickerDemo()),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.location_searching),
          onPressed: () {
            print("Pressed");
            print(sampledLat);
            print(sampledLon);
            Future<Map<String,double>> currentLocation =  getCurrentLocation();
            currentLocation.then((Map<String,double> locationDict){
              setState(() {
                print(locationDict.toString());
                if (locationDict[LAT] != null){
                  sampledLat = locationDict[LAT];
                  sampledLon = locationDict[LON];
                  Sample s = Sample(
                      lat: sampledLon,
                      lon: sampledLon,
                    textureClass: "lome",
                    depthShallow: 2,
                    depthDeep: 10,
                    sand: 20,
                    silt: 30,
                    clay: 50
                  );
                  print(s.getData().toString());
                  site.addSample(s);
                  print(site.samples.map((e) => e.textureClass));
                  overrideSite(site);

                }


              });
            });

          }),
    );
  }
}