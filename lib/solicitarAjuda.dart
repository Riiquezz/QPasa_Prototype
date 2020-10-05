import 'package:QPasa_Prototype/resumoAjuda.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import './utils/location.dart';

import 'login.dart';

import 'package:time_machine/time_machine.dart';
import 'package:time_machine/time_machine_text_patterns.dart';

class SolicitarAjuda extends StatefulWidget {
  @override
  _SolicitarAjudaState createState() => _SolicitarAjudaState();
}

class _SolicitarAjudaState extends State<SolicitarAjuda> {
  final _auth = FirebaseAuth.instance;
  final _cloudStorage = Firestore.instance;
  final dateFormat = DateFormat("dd/MM/yyyy");
  bool showProgress = false;

  int _n = 0;

  String tipoDose,
      qtdDose,
      rota,
      dtEntrega,
      agendarPedido,
      statusPedido,
      dataPedido,
      nrPedido;
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
                      'PEDIDO',
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
                            'Tipo de dose',
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
                                value: '45 ml',
                                groupValue: tipoDose,
                                onChanged: (String value) {
                                  setState(() {
                                    tipoDose = value;
                                  });
                                },
                              ),
                              Text(
                                '45 ml',
                                style: TextStyle(fontSize: 16.0),
                              ),
                              Radio(
                                value: '80 ml',
                                groupValue: tipoDose,
                                onChanged: (String value) {
                                  setState(() {
                                    tipoDose = value;
                                  });
                                },
                              ),
                              Text(
                                '80 ml',
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
                    TextField(
                      keyboardType: TextInputType.emailAddress,
                      textAlign: TextAlign.center,
                      onChanged: (value) {
                        rota = value; //get the value entered by user.
                      },
                      decoration: InputDecoration(
                        hintText: "Rota (Endereço de entrega)",
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
                        dtEntrega = value; //get the value entered by user.
                      },
                      decoration: InputDecoration(
                        hintText: "Data da entrega",
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
                            'Agendar esse pedido para: ',
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
                                value: 'A cada semana',
                                groupValue: agendarPedido,
                                onChanged: (String value) {
                                  setState(() {
                                    agendarPedido = value;
                                  });
                                },
                              ),
                              Text(
                                'A cada semana',
                                style: TextStyle(fontSize: 16.0),
                              ),
                              Radio(
                                value: 'A cada duas semanas',
                                groupValue: agendarPedido,
                                onChanged: (String value) {
                                  setState(() {
                                    agendarPedido = value;
                                  });
                                },
                              ),
                              Text(
                                'A cada duas semanas',
                                style: TextStyle(fontSize: 16.0),
                              ),
                              Radio(
                                value: 'A cada três semanas',
                                groupValue: agendarPedido,
                                onChanged: (String value) {
                                  setState(() {
                                    agendarPedido = value;
                                  });
                                },
                              ),
                              Text(
                                'A cada três semanas',
                                style: TextStyle(fontSize: 16.0),
                              ),
                              Radio(
                                value: 'Mensal',
                                groupValue: agendarPedido,
                                onChanged: (String value) {
                                  setState(() {
                                    agendarPedido = value;
                                  });
                                },
                              ),
                              Text(
                                'Mensal',
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

                            //statusPedido = "NAOO";
                            //if (statusPedido = null) {
                            //var userData = {};
                            //}

                            //Verificar se FIREBASE está armazenando corretamente
                            final SolicitarAjuda =
                                await _auth.createUserWithEmailAndPassword(
                              email: email,
                              password: password,
                            );

                            void addNumber() {
                              setState(() {
                                _n++;
                              });
                            }

                            if (SolicitarAjuda != null) {
                              var userData = {
                                'uid': SolicitarAjuda.user.uid,
                                'tipoDose': tipoDose,
                                'qtdDose': qtdDose,
                                'rota': rota,
                                'dtEntrega': dtEntrega,
                                'agendarPedido': agendarPedido,
                                'statusPedido':
                                    statusPedido, //NECESSARIO VERIFICAR COMO VAI FUNCIONAR O STATUS (FALAR COM SANDRO)
                                'dataPedido': now
                                    .inLocalZone()
                                    .toString('dddd yyyy-MM-dd HH:mm'),
                                'nrPedido': _n
                              };

                              _cloudStorage
                                  .collection('SolicitarAjuda')
                                  .document(SolicitarAjuda.user.uid)
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
                              builder: (context) => ResumoAjuda()),
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
