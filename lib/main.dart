import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';

void main() => runApp(MyApp());
dynamic favoritosGlobal;
dynamic usuario;
dynamic articulosGlobal;
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Store',
        debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => HomePage()),
        GetPage(name: '/second', page: () => FourthPage()),
        //GetPage(name: '/third', page: () => ThirdPage()),
      ],
    );
  }
}
class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  String _errorMessage = '';


  Future<void> _login() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();
    final response = await http.post(
      Uri.parse('http://learnpro.bucaramanga.upb.edu.co:3005/user/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'user': username, 'password': password}),
    );
    print(response.body);
    if (response.statusCode == 200) {
      print('Opcion1');
      final token = jsonDecode(response.body)['token'];
      print(token);
      final decodedToken = JwtDecoder.decode(token);
      print(decodedToken);
      print(decodedToken['userId']);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => SecondPage(userId: decodedToken['userId']),
        ),
      );
    } else {
      setState(() {
        _errorMessage = 'Invalid username or password';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Page'),automaticallyImplyLeading: false
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your username';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _login();
                  }
                },
                child: Text('Login'),
              ),
              if (_errorMessage.isNotEmpty)
                Text(
                  _errorMessage,
                  style: TextStyle(color: Colors.red),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/*class SecondPage extends StatelessWidget {
  final String userId;

  const SecondPage({required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Welcome, User # $userId!'),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
              },
              child: Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}*/
class SecondPage extends StatefulWidget {
  final String userId;

  const SecondPage({required this.userId});



  @override
  State<SecondPage> createState() => _SecondPageState();
}

class buttonStyle extends StatelessWidget {
  ThirdPage? api;
  final String imagen;
  final String nombre;
  final String vendedor;
  final String calificacion;


  buttonStyle(this.imagen, this.nombre, this.vendedor, this.calificacion);
  bool favorito=false;
  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
        onTap: () {
          print('Hola');
        },
        child: new Container(
          margin: new EdgeInsets.fromLTRB(10, 10, 10, 10),
          height: 150,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: new BoxDecoration(
              borderRadius: new BorderRadius.all(new Radius.circular(50.0)),
              color: Colors.white24),
          child: new Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(19),
                child: Image(
                  image: NetworkImage(
                      '$imagen'), //pubspec.yaml > assets: - assets/
                  height: 80,
                  width: 80,
                ),
              ),
              new Column(
                children: [
                  new Container(
                    margin: new EdgeInsets.fromLTRB(2, 35, 10, 10),
                    child: new Column(
                      children: [
                        new Text(
                          nombre,
                          style: new TextStyle(
                              color: Colors.white, fontSize: 20.0),
                        ),
                        new Text(
                          vendedor,
                          style: new TextStyle(
                              color: Colors.white, fontSize: 15.0),
                        ),
                        new Text(
                          calificacion,

                          style: new TextStyle(
                              color: Colors.white, fontSize: 19.0),
                        ),
                      ],
                    ),
                    
                  ),
                ],
              ),new Column(children: [IconButton(onPressed: esFavorito, icon: Icon(Icons.star))])
            ],
          ),
        ));
  }

  void primir(){
    print("Soy botoncito");
  }
  Map<String,dynamic> findItemByName(List<dynamic> itemList, String name) {
    dynamic itemGuardar;
    for (var item in itemList) {
      if (item['nombre'] == name) {
        return item;
      }
    }

    itemList.add(itemGuardar);
    return Map<String, dynamic>();
  }

  void esFavorito(){
    print(usuario);
    print('Tipo dato global');
    print(favoritosGlobal.runtimeType);
    print(favoritosGlobal);
    List favoritosJSON=jsonDecode(favoritosGlobal);
    print('Tipo dato interno');
    print(favoritosJSON.runtimeType);
    dynamic resultado= findItemByName(favoritosJSON, nombre);
    print(nombre);
    print(resultado);

    if(resultado.toString()!="{}"){
      print("Lo tienes");
      favoritosJSON.remove(resultado);
      //favoritosJSON.remove(resultado);
      updateFavorites(usuario, favoritosJSON.toString());
      print("El objeto fue retirado");
      print(favoritosJSON);
      //favoritosGlobal=favoritosJSON;
      //favoritosGlobal=favoritosJSON.toString();
      print(favoritosJSON);

    }
    else{
      print("No lo tienes");
      dynamic resultado1= findItemByName(articulosGlobal, nombre);
      print(resultado1);
      favoritosJSON.add(resultado1.toString());
      updateFavorites(usuario, favoritosJSON.toString());
      //favoritosJSON.add(resultado);
      print("El objeto fue agregado");

    }


  }
  Future<void> updateFavorites(String userId, String favorites) async {
    // construct the URL for the update request
    final url = Uri.parse('http://learnpro.bucaramanga.upb.edu.co:3005/user/updateProduct/$userId');
    String favoritesInterno = "favorites";
    // create a Map with the request body
    final favoritesEncode=jsonEncode(favorites);
    print("Mensaje a mandar:");
    print(favoritesEncode);
    final body = {"favorites": favoritesEncode};

    print("El cuerpo:");
    print(body);
    final bodyFinal=jsonEncode(body);
    print("bodyFinal:");
    print(bodyFinal);

    try {
      // send the PATCH request to the API
      final response = await http.patch(url,
          headers: {'Content-Type': 'application/json'}, body: bodyFinal);
      print("El fainal:");
      print(response);

      // check if the request was successful (status code 2xx)
      if (response.statusCode >= 200 && response.statusCode < 300) {
        // parse the JSON response and print it
        final jsonResponse = json.decode(response.body);
        print("Info BBDD:");
        print(jsonResponse);
      } else {
        // request failed, print the status code and message
        print('Request failed with status ${response.statusCode}: ${response.reasonPhrase}');
      }
    } catch (e) {
      // an error occurred while sending the request, print it
      print('An error occurred: $e');
    }
  }
  //To use this function, simply call it with the user ID and the new favorites string:
  //This should send a PATCH request to the API with the updated favorites for the specified user ID, and print the response from the API. Note that you'll need to have the http package installed in your project for this to work.






}
class _SecondPageState extends State<SecondPage> {

  @override
  void initState() {
    super.initState();
    generadorAPI();
    getUserFavorites(widget.userId);
    //usuario=widget.userId;
    //print("Impresion");
    //print(favoritos);
    //favoritosGlobal=getUserFavorites(widget.userId);
    print("Favoritos Global");
    print(favoritosGlobal);

  }
  ListView? lista;
  Map<String,dynamic>? favoritos;
  String favoritosString='';

  Future<dynamic> getUserFavorites(String objectId) async {
    final response = await http.get(Uri.parse('http://learnpro.bucaramanga.upb.edu.co:3005/user/get/$objectId'));
    usuario=objectId;
    if (response.statusCode == 200) {
      final decodedJson = json.decode(response.body);
      final favorites = decodedJson['favorites'];
      //print(favorites);
      //favoritos=favorites;
      //favoritosString=favorites;
      //print(favoritosString);
      //print(favorites);
      favoritosString=favorites.toString();
      //print(favoritosString);
      favoritosGlobal=favorites.toString();
      return favorites;
    } else {
      throw Exception('Failed to load user favorites');
    }
  }

  Future<dynamic> generadorAPIFavoritos() async {

    try {
      /*
      final requestResponse = await http.get(
        Uri.parse('http://learnpro.bucaramanga.upb.edu.co:3005/articles/get'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
      ).timeout(Duration(seconds: 3));

       */

     dynamic datosJSONAPI = favoritosGlobal;
      //dynamic datosJSONAPI = favoritos;
      //print(datosJSONAPI);
      if (datosJSONAPI.isNotEmpty) {
        lista = ListView.builder(
          itemCount: datosJSONAPI.length,
          itemBuilder: (context, index) {
            dynamic elemento = datosJSONAPI[index];
            return buttonStyle(
              elemento["imagen"],
              elemento["nombre"],
              elemento["vendedor"],
              elemento["calificacion"],
            );
          },
        );
        await Future.delayed(Duration(seconds: 1));
        setState(() {
          // Call setState to refresh the widget once
        });
      } else {
        generadorAPI();
      }
    } catch (e) {

      print('Error:' + e.toString());
    }
  }

  Future<dynamic> generadorAPI() async {

    try {
      final requestResponse = await http.get(
        Uri.parse('http://learnpro.bucaramanga.upb.edu.co:3005/articles/get'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
      ).timeout(Duration(seconds: 3));


      dynamic datosJSONAPI = jsonDecode(utf8.decode(requestResponse.bodyBytes));
      articulosGlobal=datosJSONAPI;
      //print(datosJSONAPI);
      if (datosJSONAPI.isNotEmpty) {
        lista = ListView.builder(
          itemCount: datosJSONAPI.length,
          itemBuilder: (context, index) {
            dynamic elemento = datosJSONAPI[index];
            return buttonStyle(
              elemento["imagen"],
              elemento["nombre"],
              elemento["vendedor"],
              elemento["calificacion"],
            );
          },
        );
        await Future.delayed(Duration(seconds: 1));
        setState(() {
          // Call setState to refresh the widget once
        });
      } else {
        generadorAPI();
      }
    } catch (e) {

      print('Error:' + e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    generadorAPI();
    return Scaffold(
      appBar: AppBar(
        title: Text("Productos"),
        leading: IconButton(
        icon: Icon(Icons.exit_to_app),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        },
      ),
          actions: [IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () {
              Get.to(() => ThirdPage(userId: favoritosString));
              print(favoritosString);
            },
          )],
      ),

      body: Container(
          height: double.infinity,
          width: double.infinity,
          color:Colors.blue,
          child:
          lista

      )
      ,
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
class FourthPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fourth Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: Text('Go to Third Page'),
              onPressed: () => Get.toNamed('/third'),
            ),
          ],
        ),
      ),
    );
  }
}
/*
class ThirdPage extends StatelessWidget {

  final String? userId;

  const ThirdPage({required this.userId});

  void funcion(String user){
    print(userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Third Page'),
      ),
      body: Center(
        child: Text('This is the Third Page'),
      ),
    );
  }

}

 */


class ThirdPage extends StatefulWidget{
  final String userId;

  const ThirdPage({required this.userId});

  @override
  _ThirdPageState createState() => _ThirdPageState();
}

class _ThirdPageState extends State<ThirdPage>{
  ListView? lista;
  @override
  void initState() {
    super.initState();
    print(widget.userId);
    //favoritosGlobal=jsonDecode(widget.userId);
  }
/*
  List<Widget>generador(){

    dynamic jsonExcelente = widget.userId;
    dynamic elementos = jsonExcelente;
    List<Widget> listaWidgets = <Widget>[];
    for (int i = 0; i < elementos.length; i ++){
      dynamic oItem = elementos[i];
      listaWidgets.add(
          buttonStyle(oItem["imagen"], oItem["nombre"], oItem["vendedor"], oItem["calificacion"])
      );
    }
    return listaWidgets;
  }

 */
  Future<dynamic> generadorAPI() async {

    try {
      /*
      final requestResponse = await http.get(
        Uri.parse('http://learnpro.bucaramanga.upb.edu.co:3005/articles/get'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
      ).timeout(Duration(seconds: 3));



       */
      print(widget.userId);
      dynamic datosJSONAPI = jsonDecode(widget.userId);
      //print(datosJSONAPI);
      if (datosJSONAPI.isNotEmpty) {
        lista = ListView.builder(
          itemCount: datosJSONAPI.length,
          itemBuilder: (context, index) {
            dynamic elemento = datosJSONAPI[index];
            return buttonStyle(
              elemento["imagen"],
              elemento["nombre"],
              elemento["vendedor"],
              elemento["calificacion"],
            );
          },
        );
        await Future.delayed(Duration(seconds: 1));
        setState(() {
          // Call setState to refresh the widget once
        });
      } else {
        generadorAPI();
      }
    } catch (e) {

      print('Error:' + e.toString());
    }
  }
  Future<dynamic> generadorAPIMONGO() async {

    try {
      /*
      final requestResponse = await http.get(
        Uri.parse('http://learnpro.bucaramanga.upb.edu.co:3005/articles/get'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
      ).timeout(Duration(seconds: 3));



       */
      print(widget.userId);
      print(favoritosGlobal.runtimeType);
      //List<dynamic> datosJSONAPI = jsonDecode(favoritosGlobal);
      //final miString = favoritosGlobal.substring(1, favoritosGlobal.length - 1);
      //String datosJSONAPI = JsonEncoder.withIndent('  ').convert(miString);
      List<dynamic> datosJSONAPI = json.decode(favoritosGlobal);
      print("Datos convertidos");
      print(datosJSONAPI);
      //dynamic datosJSONAPI = favoritosGlobal.toString();
      //print(datosJSONAPI);
      if (datosJSONAPI.isNotEmpty) {
        lista = ListView.builder(
          itemCount: datosJSONAPI.length,
          itemBuilder: (context, index) {
            dynamic elemento = datosJSONAPI[index];
            return buttonStyle(
              elemento["imagen"],
              elemento["nombre"],
              elemento["vendedor"],
              elemento["calificacion"],
            );
          },
        );
        await Future.delayed(Duration(seconds: 1));
        setState(() {
          // Call setState to refresh the widget once
        });
      } else {
        generadorAPI();
      }
    } catch (e) {

      print('Error:' + e.toString());
    }
  }
  @override
  Widget build(BuildContext context) {
    generadorAPIMONGO();
    return Scaffold(
      appBar: AppBar(
        title: Text("Favoritos"),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color:Colors.blue,
        child:
        lista

    ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

