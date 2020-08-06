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
  Todo todo;
  TodoDetailState(this.todo);
  final _priorities = ["High", "Medium", "Low"];
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    String _priority = "Low";
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
              value: _priority,
              onChanged: (String newValue) {
                setState(() {
                  _priority = newValue;
                });
              },
            ))
          ],
        ),
      ) 
    );
  }
}