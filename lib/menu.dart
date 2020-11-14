import 'package:QPasa_Prototype/chat.dart';
import 'package:QPasa_Prototype/kanban.dart';
import 'package:QPasa_Prototype/login.dart';
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
  var buttonColor = Color(0xff5b86e5);
  var appBar = Color(0xFF151026);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: appBar,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text('Menu'),
      ),
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [Colors.blue[900], Colors.blue[100]])),
        child: Center(
          child: Container(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 30.0,
                ),
                NiceButton(
                  radius: 30.0,
                  width: 400,
                  elevation: 20.0,
                  text: "\n\nREPORTAR PROBLEMA\n\n",
                  icon: Icons.report,
                  background: appBar,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ReportarProblema()),
                    );
                  },
                ),
                SizedBox(
                  height: 30.0,
                ),
                NiceButton(
                  radius: 30.0,
                  width: 400,
                  elevation: 8.0,
                  text: "\nAJUDA PELO CHAT\n",
                  icon: Icons.chat,
                  background: buttonColor,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ChatBot()),
                    );
                  },
                ),
                SizedBox(
                  height: 30.0,
                ),
                /*NiceButton(
                  width: 300,
                  elevation: 8.0,
                  padding: const EdgeInsets.all(15),
                  text: "KANBAN\nControle suas tarefas",
                  icon: Icons.copy_rounded,
                  background: buttonColor,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Kanban()),
                    );
                  },
                ),*/
                /*SizedBox(
                  height: 30.0,
                ),*/
                NiceButton(
                  radius: 30.0,
                  width: 400,
                  elevation: 8.0,
                  padding: const EdgeInsets.all(15),
                  text: "\nCONTATAR SUPORTE\n",
                  icon: Icons.people,
                  background: buttonColor,
                  onPressed: () {
                    FlutterOpenWhatsapp.sendSingleMessage(
                        "5554999164001", "Olá, preciso de ajuda!");
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
