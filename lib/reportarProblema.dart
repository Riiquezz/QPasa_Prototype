import 'dart:ffi';

import 'package:QPasa_Prototype/menu.dart';
import 'package:QPasa_Prototype/resumoProblema.dart';
import 'package:QPasa_Prototype/solicitacaoEnviada.dart';
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

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

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

  var appBar = Color(0xFF151026);

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showProgress,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          backgroundColor: appBar,
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text('Preencha os dados'),
        ),
        body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [Colors.blue[300], Colors.blue[100]])),
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
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
                    height: 30.0,
                  ),
                  new TextFormField(
                    decoration: new InputDecoration(
                      labelText: "Descrição da Reclamação",
                      fillColor: Colors.white,
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(25.0),
                        borderSide: new BorderSide(),
                      ),
                      //fillColor: Colors.green
                    ),
                    validator: (val) {
                      if (val.length == 0) {
                        return "Precisamos de uma descrição para poder te ajudar :)";
                      } else {
                        return null;
                      }
                    },
                    keyboardType: TextInputType.text,
                    onChanged: (value) {
                      descReclamacao = value; //get the value entered by user.
                    },
                    style: new TextStyle(
                      fontFamily: "Poppins",
                    ),
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  new TextFormField(
                    decoration: new InputDecoration(
                      labelText: "Local",
                      fillColor: Colors.white,
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(25.0),
                        borderSide: new BorderSide(),
                      ),
                      //fillColor: Colors.green
                    ),
                    validator: (val) {
                      if (val.length == 0) {
                        return "Precisamos do local para poder te ajudar :)";
                      } else {
                        return null;
                      }
                    },
                    keyboardType: TextInputType.text,
                    onChanged: (value) {
                      local = value; //get the value entered by user.
                    },
                    style: new TextStyle(
                      fontFamily: "Poppins",
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
                    height: 40.0,
                  ),
                  Material(
                    elevation: 5,
                    color: Colors.lightBlue,
                    borderRadius: BorderRadius.circular(10.0),
                    child: SizedBox(
                      child: MaterialButton(
                        minWidth: 400.0,
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
                                builder: (context) => SolicitacaoEnviada(),
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
