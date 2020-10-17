import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import './kanbanClasses.dart';

class StoryWidget extends StatefulWidget {
  Story story;
  final Document doc;

  StoryWidget(this.story, this.doc);

  @override
  _StoryWidgetState createState() => _StoryWidgetState();
}

class _StoryWidgetState extends State<StoryWidget> {
  Map<int, String> sectionList = {0: 'to_do', 1: 'in_progress', 2: 'done'};

  _StoryWidgetState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.story.title),
      ),
      body: SafeArea(
          child: Column(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: initContainer(context, Colors.blue, 0),
          ),
          Expanded(
            flex: 1,
            child: initContainer(context, Colors.green, 1),
          ),
          Expanded(
            flex: 1,
            child: initContainer(context, Colors.yellow, 2),
          ),
          Expanded(
            flex: 1,
            child: initContainer(context, Colors.black, 3),
          ),
        ],
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          createNewTask(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget initContainer(BuildContext context, Color color, int section) {
    return Container(
      color: color,
      child: taskView(context, section),
    );
  }

  Widget taskView(BuildContext context, int section) {
    List<String> tasks = widget.story.map[sectionList[section]];
    return ListView.separated(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          var task = tasks[index];
          return GestureDetector(
            onTap: () => moveTaskToNextSection(section, index),
            child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: 100.0),
              child: Card(
                child: Text(task),
              ),
            ),
            onLongPress: () {
              setState(() {
                tasks.removeAt(index);
              });
              widget.doc.updateRemote();
            },
          );
        },
        separatorBuilder: (context, index) => const Divider(),
        itemCount: tasks.length);
  }

  void moveTaskToNextSection(int originSection, int originIndex) {
    List<String> originTaskList = widget.story.map[sectionList[originSection]];
    List<String> arrivalTaskList =
        widget.story.map[sectionList[(originSection + 1) % 4]];
    setState(() {
      var task = originTaskList.removeAt(originIndex);
      arrivalTaskList.add(task);
    });
    widget.doc.updateRemote();
  }

  createNewTask(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final myController = TextEditingController();
    showDialog(
      context: context,
      builder: (cntx) {
        return AlertDialog(
          title: Text("New task"),
          content: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    controller: myController,
                    validator: (value) {
                      if (value.isEmpty)
                        return "Not Valid";
                      else
                        return null;
                    },
                  ),
                  RaisedButton(
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        setState(() {
                          widget.story.toDo.add(myController.text);
                        });
                        widget.doc.updateRemote();
                        Navigator.pop(cntx);
                      }
                    },
                    child: Text("Add"),
                  )
                ],
              )),
        );
      },
    );
  }
}
