import 'package:QPasa_Prototype/chat.dart';
import 'package:QPasa_Prototype/reportarProblema.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import './utils/firestore_helper.dart';
import 'package:nice_button/nice_button.dart';

import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';

class Menu extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  get fullName => fullName;
  var buttonColor = Color(0xff5b86e5);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text('Bem-vindo $fullName'),
      ),
      body: SafeArea(
        child: Container(
          child: Column(
            children: <Widget>[
              NiceButton(
                width: 255,
                elevation: 8.0,
                radius: 52.0,
                text: "Reportar problema",
                background: buttonColor,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ReportarProblema()),
                  );
                },
              ),
              SizedBox(
                height: 20.0,
              ),
              NiceButton(
                width: 255,
                elevation: 8.0,
                radius: 52.0,
                text: "Solicitações pelo Chat",
                background: buttonColor,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ChatBot()),
                  );
                },
              ),
              SizedBox(
                height: 20.0,
              ),
              NiceButton(
                radius: 40,
                padding: const EdgeInsets.all(15),
                text: "CONTATAR SUPORTE",
                icon: Icons.contact_phone,
                background: buttonColor,
                onPressed: () {
                  FlutterOpenWhatsapp.sendSingleMessage(
                      "NUMERO DO CARA", "PRÉ MENSAGEM");
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
