import 'package:QPasa_Prototype/menu.dart';
import 'package:QPasa_Prototype/resumoProblema.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'utils/location.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'login.dart';

import 'package:time_machine/time_machine.dart';
import 'package:time_machine/time_machine_text_patterns.dart';

class ReportarProblema extends StatefulWidget {
  @override
  _ReportarProblemaState createState() => _ReportarProblemaState();
}

class _ReportarProblemaState extends State<ReportarProblema> {
  final _auth = FirebaseAuth.instance;
  final _cloudStorage = Firestore.instance;
  final storage = new FlutterSecureStorage();
  final dateFormat = DateFormat("dd/MM/yyyy");
  bool showProgress = false;

  int _n = 0;

  String tipoReclamacao, descReclamacao, nrReclamacao, dataReclamacao;
  String email, password;

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
                      'Preencha os dados',
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
                            'Tipo da reclamação',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          DropdownButton<String>(
                            items: [
                              DropdownMenuItem<String>(
                                child: Text('Sujeira'),
                                value: 'Sujeira',
                              ),
                              DropdownMenuItem<String>(
                                child: Text('Item quebrado'),
                                value: 'Item quebrado',
                              ),
                              DropdownMenuItem<String>(
                                child: Text('Problema com vizinho'),
                                value: 'Problema com vizinho',
                              ),
                              DropdownMenuItem<String>(
                                child: Text('Barulho'),
                                value: 'Barulho',
                              ),
                            ],
                            onChanged: (String value) {
                              setState(() {
                                tipoReclamacao = value;
                              });
                            },
                            hint: Text('Selecione'),
                            value: tipoReclamacao,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    TextField(
                      keyboardType: TextInputType.emailAddress,
                      textAlign: TextAlign.center,
                      onChanged: (value) {
                        descReclamacao = value; //get the value entered by user.
                      },
                      decoration: InputDecoration(
                        hintText: "Descrição da Reclamação",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
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
                            var now = Instant.now();

                            //Verificar se FIREBASE está armazenando corretamente
                            String userId = await storage.read(key: 'userId');

                            void addNumber() {
                              setState(() {
                                _n++;
                              });
                            }

                            if (userId != null) {
                              var userData = {
                                'userUid': userId,
                                'tipoReclamacao': tipoReclamacao,
                                'descReclamacao': descReclamacao,
                                'dataReclamacao': now
                                    .inLocalZone()
                                    .toString('dddd yyyy-MM-dd HH:mm'),
                                'nrReclamacao': _n
                              };

                              _cloudStorage
                                  .collection('reportarProblema')
                                  .document()
                                  .setData(userData);

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
                              builder: (context) => ResumoProblema()),
                        );
                      },
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
