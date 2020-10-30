import 'dart:ffi';

import 'package:QPasa_Prototype/resumoProblema.dart';
import 'package:QPasa_Prototype/utils/firestore_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:time_machine/time_machine.dart';

class ReportarProblema extends StatefulWidget {
  @override
  _ReportarProblemaState createState() => _ReportarProblemaState();
}

class _ReportarProblemaState extends State<ReportarProblema> {
  final FirestoreHelper firestoreHelper = FirestoreHelper();
  final _auth = FirebaseAuth.instance;
  final _cloudStorage = FirebaseFirestore.instance;
  final storage = new FlutterSecureStorage();
  final dateFormat = DateFormat("dd/MM/yyyy");
  bool showProgress = false;

  int number = 0;

  String tipoReclamacao,
      descReclamacao,
      dataReclamacao,
      enviarReclamacao,
      local;

  String email, password;

  int nrReclamacao;

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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'PREENCHA OS DADOS',
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
                  TextField(
                    keyboardType: TextInputType.emailAddress,
                    textAlign: TextAlign.center,
                    onChanged: (value) {
                      local = value; //get the value entered by user.
                    },
                    decoration: InputDecoration(
                      hintText: "Local",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  /*Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black38),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Column(
                      children: <Widget>[
                        Text(
                          'Enviar reclamação para quem?',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        DropdownButton<String>(
                          items: [
                            DropdownMenuItem<String>(
                              child: Text('Administradora do condomíńio'),
                              value: 'Administradora',
                            ),
                            DropdownMenuItem<String>(
                              child: Text('Síndico'),
                              value: 'Síndico',
                            ),
                          ],
                          onChanged: (String value) {
                            setState(() {
                              enviarReclamacao = value;
                            });
                          },
                          hint: Text('Selecione'),
                          value: enviarReclamacao,
                        ),
                      ],
                    ),
                  ),*/
                  SizedBox(
                    height: 20.0,
                  ),
                  Material(
                    elevation: 5,
                    color: Colors.lightBlue,
                    borderRadius: BorderRadius.circular(10.0),
                    child: SizedBox(
                      child: MaterialButton(
                        onPressed: () async {
                          setState(() {
                            showProgress = true;
                          });
                          var now = Instant.now();
                          initializeDateFormatting('pt_BR', null);

                          final lastNumber =
                              await firestoreHelper.getLastDocument(
                                  'reportarProblema', 'nrReclamacao');
                          int lastNumberId;

                          lastNumber.documents.forEach((number) {
                            lastNumberId = number['nrReclamacao'] + 1;
                          });

                          String userId = await storage.read(key: 'userId');

                          if (userId != null) {
                            var userData = {
                              'userUid': userId,
                              'tipoReclamacao': tipoReclamacao,
                              'descReclamacao': descReclamacao,
                              'enviarReclamacao': enviarReclamacao,
                              'dataReclamacao':
                                  DateFormat(DateFormat.YEAR_MONTH_DAY, 'pt_Br')
                                      .format(DateTime.now()),
                              'nrReclamacao': lastNumberId,
                              'local': local
                            };

                            _cloudStorage
                                .collection('reportarProblema')
                                .doc()
                                .set(userData);

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ResumoProblema(),
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
