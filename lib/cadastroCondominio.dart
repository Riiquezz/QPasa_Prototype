import 'dart:convert';

import 'package:QPasa_Prototype/menu.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import './utils/location.dart';

import 'login.dart';

class CadastroCondominio extends StatefulWidget {
  @override
  _CadastroCondominioState createState() => _CadastroCondominioState();
}

class _CadastroCondominioState extends State<CadastroCondominio> {
  final _auth = FirebaseAuth.instance;
  final _cloudStorage = FirebaseFirestore.instance;
  final storage = new FlutterSecureStorage();
  final dateFormat = DateFormat("dd/MM/yyyy");
  bool showProgress = false;

  String condominio, apartamento, bloco;

  String email, password;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showProgress,
      child: Scaffold(
        resizeToAvoidBottomInset: false, // set it to false
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 20.0,
                    ),
                    Text(
                      'CADASTRO DE CONDOMINIO',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w400,
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
                            'Qual seu condomínio?',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          DropdownButton<String>(
                            items: [
                              DropdownMenuItem<String>(
                                child: Text('Morada dos Silvestres'),
                                value: 'morada dos silvestres',
                              ),
                              DropdownMenuItem<String>(
                                child: Text('Vivência Jardim'),
                                value: 'Vivencia Jardim',
                              ),
                            ],
                            onChanged: (String value) {
                              setState(() {
                                condominio = value;
                              });
                            },
                            hint: Text('Selecione'),
                            value: condominio,
                          ),
                        ],
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
                            "Qual bloco você mora?\n(Marque A se houver apenas um)",
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          DropdownButton<String>(
                            items: [
                              DropdownMenuItem<String>(
                                child: Text('A'),
                                value: 'A',
                              ),
                              DropdownMenuItem<String>(
                                child: Text('B'),
                                value: 'B',
                              ),
                            ],
                            onChanged: (String value) {
                              setState(() {
                                bloco = value;
                              });
                            },
                            hint: Text('Selecione'),
                            value: bloco,
                          ),
                        ],
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
                            "Qual seu apartamento?",
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          DropdownButton<String>(
                            items: [
                              DropdownMenuItem<String>(
                                child: Text('101'),
                                value: '101',
                              ),
                              DropdownMenuItem<String>(
                                child: Text('102'),
                                value: '102',
                              ),
                            ],
                            onChanged: (String value) {
                              setState(() {
                                apartamento = value;
                              });
                            },
                            hint: Text('Selecione'),
                            value: apartamento,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.00),
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

                            String userId = await storage.read(key: 'userId');

                            if (userId != null) {
                              var userData = {
                                'userUID': userId,
                                'apartamento': apartamento,
                                'bloco': bloco,
                                'condominio': condominio,
                              };

                              _cloudStorage
                                  .collection('users')
                                  .doc()
                                  .set(userData);

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Menu(),
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
                            "CONFIRMAR",
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
