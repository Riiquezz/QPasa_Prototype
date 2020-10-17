import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:QPasa_Prototype/utils/firestore_helper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import './kanban/kanbanClasses.dart';
import './kanban/StoryWidget.dart';

class Kanban extends StatefulWidget {
  @override
  _KanbanState createState() => _KanbanState();
}

class _KanbanState extends State<Kanban> {
  Document doc;

  final FirestoreHelper firestoreHelper = FirestoreHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(child: _buildBody(context)),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            createNewStory(context);
          },
          child: Icon(Icons.add),
        ));
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('kanban').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();
        doc = Document.fromSnapshot(snapshot.data.documents[1]);
        return ListView.separated(
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StoryWidget(doc.stories[index], doc),
                  )),
              child: Card(
                child: Column(
                  children: <Widget>[
                    Text(doc.stories[index].title),
                    Text("${doc.stories[index].totalNumberOfTask()} items")
                  ],
                ),
              ),
              onLongPress: () {
                setState(() {
                  doc.stories.removeAt(index);
                });
                doc.updateRemote();
              },
            );
          },
          separatorBuilder: (context, index) => const Divider(),
          itemCount: doc.stories.length,
        );
      },
    );
  }

  void createNewStory(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final myController = TextEditingController();
    showDialog(
      context: context,
      builder: (cntx) {
        return AlertDialog(
          title: Text("Novo item"),
          content: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    controller: myController,
                    validator: (value) {
                      if (value.isEmpty)
                        return "Não válido, tente novamente";
                      else
                        return null;
                    },
                  ),
                  RaisedButton(
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        doc.stories.add(Story.empty(myController.text));
                        doc.updateRemote();
                        Navigator.pop(cntx);
                      }
                    },
                    child: Text("Adicionar"),
                  )
                ],
              )),
        );
      },
    );
  }
}
