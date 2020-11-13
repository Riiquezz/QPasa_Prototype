import 'package:QPasa_Prototype/menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import './utils/location.dart';
import 'main.dart';

class MyLoginPage extends StatefulWidget {
  @override
  _MyLoginPageState createState() => _MyLoginPageState();
}

class _MyLoginPageState extends State<MyLoginPage> {
  final _auth = FirebaseAuth.instance;
  final storage = new FlutterSecureStorage();
  final _cloudStorage = FirebaseFirestore.instance;
  String state, city;
  bool showProgress = false;
  String email, password;

  bool userLogin = false;

  @override
  void initState() {
    getStateAndCityData();
    checkUserStatus();

    super.initState();
  }

  void checkUserStatus() async {
    String userId = await storage.read(key: 'userId');

    if (userId != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Menu(),
        ),
      );
    }
  }

  void getStateAndCityData() async {
    Location location = Location();
    await location.getCurrentPosition();

    await location.getCurrentPositionDataLatLong(
      location.latitude,
      location.longitude,
    );

    state = location.state;
    city = location.city;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [Colors.blue[400], Colors.blue[100]])),
        child: Center(
          child: ModalProgressHUD(
            inAsyncCall: showProgress,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image(
                  image: AssetImage('assets/EscritaQPasa.png'),
                  width: 300.0,
                ),
                SizedBox(
                  height: 20.0,
                ),
                TextField(
                  keyboardType: TextInputType.emailAddress,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    email = value; // get value from TextField
                  },
                  decoration: InputDecoration(
                    hintText: "Email",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                TextField(
                  obscureText: true,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    password = value; //get value from textField
                  },
                  decoration: InputDecoration(
                    hintText: "Senha",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Material(
                  elevation: 5,
                  color: Colors.lightBlue,
                  borderRadius: BorderRadius.circular(10.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: MaterialButton(
                      onPressed: () async {
                        setState(() {
                          showProgress = true;
                        });

                        try {
                          final newUser =
                              await _auth.signInWithEmailAndPassword(
                            email: email,
                            password: password,
                          );

                          if (newUser != null) {
                            await storage.write(
                              key: 'userId',
                              value: newUser.user.uid,
                            );

                            Fluttertoast.showToast(
                              msg: "Sucesso",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              backgroundColor: Colors.blueAccent,
                              textColor: Colors.white,
                              fontSize: 16.0,
                            );

                            setState(() {
                              showProgress = false;
                            });

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Menu(),
                              ),
                            );
                          } else {
                            Fluttertoast.showToast(
                              msg: "Opa! Tente novamente mais tarde.",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              backgroundColor: Colors.redAccent,
                              textColor: Colors.white,
                              fontSize: 16.0,
                            );
                            setState(() {
                              showProgress = false;
                            });
                          }
                        } catch (e) {
                          Fluttertoast.showToast(
                            msg: "Opa! Tente novamente mais tarde.",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            backgroundColor: Colors.redAccent,
                            textColor: Colors.white,
                            fontSize: 16.0,
                          );
                          setState(() {
                            showProgress = false;
                          });
                        }
                      },
                      child: Text(
                        "ENTRAR",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 20.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 40.0,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MyHomePage(),
                      ),
                    );
                  },
                  child: Card(
                    color: Colors.lightBlue,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Ainda não tem cadastro?\n           Cadastre-se!",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30.0,
                ),
                GestureDetector(
                  onTap: () async {
                    if (email != null) {
                      setState(() {
                        showProgress = true;
                      });

                      await _auth.sendPasswordResetEmail(email: email);

                      setState(() {
                        showProgress = false;
                      });
                    } else {
                      Fluttertoast.showToast(
                        msg: "Opa! Tente novamente mais tarde.",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        backgroundColor: Colors.redAccent,
                        textColor: Colors.white,
                        fontSize: 16.0,
                      );
                    }
                  },
                  child: Card(
                    color: Colors.lightBlue,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Esqueci minha senha :(",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
