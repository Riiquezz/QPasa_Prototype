import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ResumoProblema extends StatefulWidget {
  @override
  _ResumoProblemaState createState() => _ResumoProblemaState();
}

class _ResumoProblemaState extends State<ResumoProblema> {
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
              Text("${querySnapshot.documents[i].data['dataReclamacao']}"),
              Text("${querySnapshot.documents[i].data['nrReclamacao']}"),
              Text("${querySnapshot.documents[i].data['descReclamacao']}"),
              Text("${querySnapshot.documents[i].data['tipoReclamacao']}"),
              SizedBox(
                height: 20.0,
              ),
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
    return await Firestore.instance
        .collection('reportarProblema')
        .getDocuments();
  }
}
