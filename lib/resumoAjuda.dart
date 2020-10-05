import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ResumoAjuda extends StatefulWidget {
  @override
  _ResumoAjudaState createState() => _ResumoAjudaState();
}

class _ResumoAjudaState extends State<ResumoAjuda> {
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
        itemCount: querySnapshot.documents.length,
        padding: EdgeInsets.all(12),
        itemBuilder: (context, i) {
          return Column(
            children: <Widget>[
//load data into widgets
              Text("${querySnapshot.documents[i].data['dtEntrega']}"),
              Text("${querySnapshot.documents[i].data['qtdDose']}"),
              Text("${querySnapshot.documents[i].data['rota']}"),
              Text("${querySnapshot.documents[i].data['tipoDose']}"),
              SizedBox(
                height: 20.0,
              ),
              Text(
                'Pedido agendado para: ',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text("${querySnapshot.documents[i].data['agendarPedido']}"),
            ],
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
    return await Firestore.instance.collection('fazerPedido').getDocuments();
  }
}
