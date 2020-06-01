import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Coda Météo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

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
                    title: textAvecStyle("Ma ville actuelle"),
                    onTap: (){
                      setState(() {
                        villeChoisie=null;
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
          child: new Text((villeChoisie==null)? "Ville actuelle": villeChoisie),
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

}
