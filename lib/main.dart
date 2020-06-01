import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:location/location.dart';
import 'package:geocoder/geocoder.dart';
import 'package:http/http.dart' as http;

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  Location location = new  Location();
  LocationData position;
  bool _serviceEnabled;
  PermissionStatus _permissionGranted;

  _serviceEnabled = await location.serviceEnabled();
  if (!_serviceEnabled) {
    _serviceEnabled = await location.requestService();
    if (!_serviceEnabled) {
      return;
    }
  }

  _permissionGranted = await location.hasPermission();
  if (_permissionGranted == PermissionStatus.denied) {
    _permissionGranted = await location.requestPermission();
    if (_permissionGranted != PermissionStatus.granted) {
      return;
    }
  }
  try{
    position = await location.getLocation();
  }on PlatformException catch (e){
    print(("Erreur: $e"));
  }
  if(position!=null){
    print(position);
    final latitude = position.latitude;
    final longitude = position.longitude;
    final Coordinates coordinates = new Coordinates(latitude, longitude);
    final ville = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    if(ville != null){
      print(ville.first.locality);
      runApp(MyApp(ville.first.locality));
    }
  }
}

class MyApp extends StatelessWidget {

  String ville;

  MyApp(String ville){
    this.ville = ville;
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(ville,title: 'Coda Météo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage(String ville,{Key key, this.title}) : super(key: key){
    this.villeDeUtilisateur = ville;
  }
   String villeDeUtilisateur;
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String key = "villes";
  List<String> villes = ["Paris"];
  String villeChoisie = null;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    obtenir();
    appelApi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(widget.title),
        ),
        drawer: new Drawer(
          child: new Container(
            color: Colors.blue,
            child: new ListView.builder(
              itemCount: villes.length + 2,
              itemBuilder: (context,i){
                if(i == 0){
                  return DrawerHeader(
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        textAvecStyle("Mes Villes", fontSize: 22.0),
                        new RaisedButton(
                            child: textAvecStyle("Ajouter une ville", color: Colors.blue),
                            elevation: 8.0,
                            color: Colors.white,
                            onPressed: ajoutVille
                        ),
                      ],
                    ),
                  );
                }else if (i==1){
                  return new ListTile(
                    title: textAvecStyle(widget.villeDeUtilisateur),
                    onTap: (){
                      setState(() {
                        villeChoisie=null;
                        appelApi();
                        Navigator.pop(context);
                      });
                    },
                  );
                } else{
                  String ville = villes[i - 2];
                  return new ListTile(
                    title: textAvecStyle(ville),
                    trailing: new IconButton(
                        icon: new Icon(Icons.delete, color: Colors.white,),
                        onPressed: (() => supprimer(ville))),
                    onTap: (){
                      setState(() {
                        villeChoisie = ville;
                        appelApi();
                        Navigator.pop(context);
                      });
                    },
                  );
                }
              },
            ),
          ),
        ),
        body: Center(
          child: new Text((villeChoisie==null)? widget.villeDeUtilisateur: villeChoisie),
        )
    );
  }

  Text textAvecStyle(String data, {color: Colors.white, fontSize: 17.0, fontStyle: FontStyle.italic, textAlign : TextAlign.center}){
    return new Text(data,
      textAlign: textAlign,
      style: new TextStyle(
          fontSize: fontSize,
          fontStyle: fontStyle,
          color: color
      ),);
  }

  Future<Null> ajoutVille()async{
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext buildContext){
          return new SimpleDialog(
            contentPadding: EdgeInsets.all(20.0),
            title: textAvecStyle("Ajouter une ville", fontSize: 22.0, color: Colors.blue),
            children: <Widget>[
              new TextField(
                decoration: new InputDecoration(labelText: "ville: "),
                onSubmitted: (String str){
                  ajouter(str);
                  Navigator.pop(buildContext);
                },
              )
            ],
          );
        }
    );
  }

  void obtenir()async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    List <String> liste = await sharedPreferences.getStringList(key);
    if (liste != null) {
      setState(() {
        villes = liste;
      });
    }
  }
    void ajouter(String str)async{
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      villes.add(str);
      await sharedPreferences.setStringList(key, villes);
      obtenir();
    }

    void supprimer(String str)async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    villes.remove(str);
    await sharedPreferences.setStringList(key, villes);
    obtenir();
    }

    void appelApi()async{
      String str;
      if(villeChoisie == null){
        str = widget.villeDeUtilisateur;
      }else{
        str = villeChoisie;
      }
      List<Address> coord = await Geocoder.local.findAddressesFromQuery(str);
      if(coord != null){
        final lat = coord.first.coordinates.latitude;
        final lon = coord.first.coordinates.longitude;
        String lang = Localizations.localeOf(context).languageCode;
        final key = "577372432a77f2fe86a8a2018ba0ad1d";

        String urlAPI = "http://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&units=metric&lang&APPID=$key";
        final reponse = await http.get(urlAPI);
        if(reponse.statusCode==200){
          print(reponse.body);
        }

      }
    }
}
