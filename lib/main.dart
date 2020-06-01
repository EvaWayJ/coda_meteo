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
List<String> ville = ["Paris"];
String vileChoisie = null;
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
            itemCount: ville.length,
            itemBuilder: (context,i){
              return new ListTile(
                title: new Text(ville[i]),
                onTap: (){
                  setState(() {
                    vileChoisie= ville[i];
                    Navigator.pop(context);
                  });
                },
              );
            },
          ),
        ),
      ),
      body: Center(
        child: new Text((vileChoisie==null)? "Ville actuelle": vileChoisie),
      )
    );
  }
}
