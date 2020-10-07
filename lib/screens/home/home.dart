import 'package:flutter/material.dart';
import 'package:texture_app/screens/home/exportscreen.dart';
import 'package:texture_app/screens/home/addsample.dart';
import 'package:texture_app/screens/home/managescreen.dart';
import 'package:texture_app/services/auth.dart';
import 'package:texture_app/services/site_database.dart';
import 'package:texture_app/models/site.dart';
import 'package:texture_app/models/common_keys.dart';


class Home extends StatelessWidget {

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {


//    Site iSite = Site(
//        name: "Heph Paddock",
//        classification: "aus",
//        rawSamples: []
//    );
//    bool alreadySite = saveSite(iSite);
//    if (alreadySite){
//      print("Cant use this name; already exists");
//    }
    List<Site> allSites =  getSites();
    print(allSites);
    List<dynamic> allSitesNames = allSites.map((s) => s.name).toList();
    print(allSitesNames);

    return Container(
      child: Scaffold(
        backgroundColor: Colors.lightBlue,
        appBar: AppBar(
          title: Text("Home"),
          backgroundColor: Colors.blue,
          elevation: 0.0,
          actions: <Widget>[
            FlatButton.icon(onPressed: () async {
              await _auth.signOut();
            },
                icon: Icon(Icons.person),
                label: Text("Logout"))
          ],
        ),
        body: ListView.builder(
            itemCount: allSites.length,
            itemBuilder: (context, index){
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 4.0),
                child: Card(
                  child: ListTile(
                    onTap: () {

                    },
                    // title: Text(locations[index].location),
                    title: Text(allSites[index].name),
                    /*leading: Text('1') CircleAvatar(
                      backgroundImage: AssetImage('assets/${locations[index].flag}'),
                    ),*/
                  ),
                ),
              );
            }
        ),
        bottomNavigationBar: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            FlatButton.icon(
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyHomePage()),
                  );
                },
                icon: Icon(Icons.add),
                label: Text('Add'),
            ),
            FlatButton.icon(
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ExportScreen()),
                  );
                },
                icon: Icon(Icons.file_upload),
                label: Text('Export')),
            FlatButton.icon(
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ManageScreen()),
                  );
                },
                icon: Icon(Icons.insert_drive_file),
                label: Text('Manage')),
            FlatButton.icon(
                onPressed: (){},
                icon: Icon(Icons.more_vert),
                label: Text(''))
          ],
        ),
      )
    );
  }
}
