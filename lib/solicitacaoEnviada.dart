import 'package:QPasa_Prototype/chat.dart';
import 'package:QPasa_Prototype/kanban.dart';
import 'package:QPasa_Prototype/menu.dart';
import 'package:QPasa_Prototype/reportarProblema.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import './utils/firestore_helper.dart';
import 'package:nice_button/nice_button.dart';

import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';

class SolicitacaoEnviada extends StatefulWidget {
  @override
  _SolicitacaoEnviadaState createState() => _SolicitacaoEnviadaState();
}

class _SolicitacaoEnviadaState extends State<SolicitacaoEnviada> {
  var buttonColor = Color(0xff5b86e5);
  var appBar = Color(0xFF151026);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Menu()),
            );
          },
        ),
        backgroundColor: appBar,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text('Obrigado pelo relato!'),
      ),
      body: Container(
        decoration: BoxDecoration(
            gradient:
                LinearGradient(colors: [Colors.blue[300], Colors.blue[100]])),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 100.0,
                  ),
                  Text(
                    'Vamos trabalhar para resolver :)',
                    style: TextStyle(fontSize: 20.0),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  
                  Image(
                    image: AssetImage('assets/logoAgeew.png'),
                    width: 300.0,
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
