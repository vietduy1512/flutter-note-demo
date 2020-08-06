import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:note_demo/util/dbhelper.dart';
import 'package:note_demo/model/todo.dart';

class TodoDetail extends StatefulWidget {
  final Todo todo;
  TodoDetail(this.todo);

  @override
  State<StatefulWidget> createState() => TodoDetailState(todo);
}

class TodoDetailState extends State {
  DbHelper helper = DbHelper();
  Todo todo;
  TodoDetailState(this.todo);
  final _priorities = ["High", "Medium", "Low"];
  String _priority = "Low";
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    titleController.text = todo.title;
    descriptionController.text = todo.description;
    TextStyle textStyle = Theme.of(context).textTheme.headline6;
    return Scaffold(
      appBar: AppBar(
        title: Text(todo.title),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
        child: Column(
          children: <Widget>[
            TextField(
              onChanged: (_) => updateTitle(),
              controller: titleController,
              style: textStyle,
              decoration: InputDecoration(
                labelText: "Title",
                labelStyle: textStyle,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0)
                )
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: TextField(
                onChanged: (_) => updateDescription(),
                controller: descriptionController,
                style: textStyle,
                decoration: InputDecoration(
                  labelText: "Description",
                  labelStyle: textStyle,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0)
                  )
                ),
              ),
            ),
            ListTile(title: DropdownButton<String>(
              items: _priorities.map((String value) {
                return DropdownMenuItem<String> (
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              style: textStyle,
              value: retrievePriority(todo.priority),
              onChanged: (value) => updatePriority(value),
            ))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => save(),
        tooltip: "Save todo",
        backgroundColor: Colors.green,
        child: Icon(Icons.done),
      )
    );
  }

  void save() {
    todo.date = new DateFormat.yMd().format(DateTime.now());
    if (todo.id == null) {
      helper.insertTodo(todo);
    } else {
      helper.updateTodo(todo);
    }
    Navigator.pop(context, true);
  }

  void updatePriority(String value) {
    switch (value) {
      case "High":
        todo.priority = 1;
        break;
      case "Medium":
        todo.priority = 2;
        break;
      case "Low":
        todo.priority = 3;
        break;
    }
    setState(() {
      _priority = value;
    });
  }

  String retrievePriority(int value) {
    return _priorities[value-1];
  }

  void updateTitle() {
    todo.title = titleController.text;
  }

  void updateDescription() {
    todo.description = descriptionController.text;
  }
}