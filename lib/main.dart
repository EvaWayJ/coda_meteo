import 'package:flutter/material.dart';

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
List<String> villes = ["Paris"];
String villeChoisie = null;
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
                          onPressed: (){

                      })
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
}
