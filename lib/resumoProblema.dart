import 'package:QPasa_Prototype/menu.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nice_button/NiceButton.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ResumoProblema extends StatefulWidget {
  @override
  _ResumoProblemaState createState() => _ResumoProblemaState();
}

class _ResumoProblemaState extends State<ResumoProblema> {
  var buttonColor = Color(0xff5b86e5);
  final FirebaseAuth auth = FirebaseAuth.instance;
  final storage = new FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    getPedido().then((results) {
      setState(() {
        querySnapshot = results;
      });
    });
  }

  QuerySnapshot querySnapshot;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _showDrivers(),
    );
  }

  //build widget as prefered
  //i'll be using a listview.builder
  Widget _showDrivers() {
    //check if querysnapshot is null
    if (querySnapshot != null) {
      return ListView.builder(
        primary: false,
        itemCount: querySnapshot.docs.length,
        padding: EdgeInsets.all(12),
        itemBuilder: (context, i) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 50.0,
                    ),
                    Text(
                      "Resumo do problema",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 50.0,
                    ),
                    Text("Número da reclamação: " +
                        "${querySnapshot.docs[i].data()['nrReclamacao']}"),
                    SizedBox(
                      height: 30.0,
                    ),
//load data into widgets
                    Text("Data da reclamação: " +
                        "${querySnapshot.docs[i].data()['dataReclamacao']}"),
                    SizedBox(
                      height: 30.0,
                    ),
                    Text("Descrição da reclamação: " +
                        "${querySnapshot.docs[i].data()['descReclamacao']}"),
                    SizedBox(
                      height: 30.0,
                    ),

                    Text("Tipo da reclamação: " +
                        "${querySnapshot.docs[i].data()['tipoReclamacao']}"),
                    SizedBox(
                      height: 30.0,
                    ),
                    Text("Enviada para: " +
                        "${querySnapshot.docs[i].data()['enviarReclamacao']}"),
                    SizedBox(
                      height: 30.0,
                    ),
                    NiceButton(
                      width: 255,
                      elevation: 8.0,
                      radius: 52.0,
                      text: "Voltar ao menu",
                      background: buttonColor,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Menu()),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    } else {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
  }

  //get firestore instance
  getPedido() async {
    String userId = await storage.read(key: 'userId');

    return await FirebaseFirestore.instance
        .collection('reportarProblema')
        .where('userId', isEqualTo: userId)
        .orderBy('nrReclamacao', descending: true)
        .limit(1)
        .get();
  }
}
