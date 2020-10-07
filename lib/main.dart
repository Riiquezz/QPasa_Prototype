import 'package:QPasa_Prototype/menu.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import './utils/location.dart';

import 'login.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'QPasa',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        inputDecorationTheme: InputDecorationTheme(
          isCollapsed: true,
          contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
        ),
      ),
      home: MyLoginPage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _auth = FirebaseAuth.instance;
  final _cloudStorage = Firestore.instance;
  final dateFormat = DateFormat("dd/MM/yyyy");
  bool showProgress = false;

  String fullName,
      email,
      password,
      cpfNumber,
      gender,
      state,
      city,
      celularNumber;
  DateTime birthday;

  @override
  void initState() {
    getStateAndCityData();

    super.initState();
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
    return ModalProgressHUD(
      inAsyncCall: showProgress,
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image(
                      image: AssetImage('images/logo.png'),
                      width: 200.0,
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Text(
                      'CADASTRO PRODUTOR',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    TextField(
                      keyboardType: TextInputType.text,
                      textAlign: TextAlign.center,
                      onChanged: (value) {
                        fullName = value; //get the value entered by user.
                      },
                      decoration: InputDecoration(
                        hintText: "Nome Completo",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    TextField(
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      onChanged: (value) {
                        celularNumber = value; //get the value entered by user.
                      },
                      decoration: InputDecoration(
                        hintText: "Celular com DDD",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    TextField(
                      keyboardType: TextInputType.emailAddress,
                      textAlign: TextAlign.center,
                      onChanged: (value) {
                        email = value; //get the value entered by user.
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
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      onChanged: (value) {
                        cpfNumber = value; //get the value entered by user.
                      },
                      decoration: InputDecoration(
                        hintText: "CPF",
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
                        password = value; //get the value entered by user.
                      },
                      decoration: InputDecoration(
                        hintText: "Senha",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black38),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Column(
                        children: <Widget>[
                          Text(
                            'Gênero',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Radio(
                                value: 'F',
                                groupValue: gender,
                                onChanged: (String value) {
                                  setState(() {
                                    gender = value;
                                  });
                                },
                              ),
                              Text(
                                'Feminino',
                                style: TextStyle(fontSize: 16.0),
                              ),
                              Radio(
                                value: 'M',
                                groupValue: gender,
                                onChanged: (String value) {
                                  setState(() {
                                    gender = value;
                                  });
                                },
                              ),
                              Text(
                                'Masculino',
                                style: TextStyle(fontSize: 16.0),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    DateTimeField(
                      format: dateFormat,
                      textAlign: TextAlign.center,
                      onShowPicker: (context, currentValue) {
                        return showDatePicker(
                            context: context,
                            firstDate: DateTime(1900),
                            initialDate: currentValue ?? DateTime.now(),
                            lastDate: DateTime(2100));
                      },
                      onChanged: (value) {
                        birthday = value; //get the value entered by user.
                      },
                      decoration: InputDecoration(
                        hintText: "Data de nascimento",
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

                            final newUser =
                                await _auth.createUserWithEmailAndPassword(
                              email: email,
                              password: password,
                            );

                            if (newUser != null) {
                              var userData = {
                                'uid': newUser.user.uid,
                                'fullName': fullName,
                                'email': email,
                                'cpfOuCnpjNumber': cpfNumber,
                                'celularNumber': celularNumber,
                                'gender': gender,
                                'birthday': birthday,
                                'state': state,
                                'city': city,
                              };

                              _cloudStorage
                                  .collection('users')
                                  .document(newUser.user.uid)
                                  .setData(userData);

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MyLoginPage(),
                                ),
                              );

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

                              setState(() {
                                showProgress = false;
                              });
                            }
                          },
                          child: Text(
                            "AVANÇAR",
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
                      height: 15.0,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MyLoginPage()),
                        );
                      },
                      child: Text(
                        "Já é cadastrado? Ir para o login.",
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
