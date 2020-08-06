import 'package:flutter/material.dart';
import 'package:note_demo/util/dbhelper.dart';
import 'package:note_demo/model/todo.dart';
import 'package:note_demo/screens/todolist.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    init();
    return MaterialApp(
      title: 'Todo Note',
      theme: ThemeData(primaryColor: Colors.green),
      home: HomePage(title: 'Todo Note'),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: TodoList(),
    );
  }
}

void init() async {
  DbHelper helper = DbHelper();
  await helper.initializeDb();
  var todos = await helper.getTodos();
  seedData();
}

void seedData() {
  DbHelper helper = DbHelper();
  Todo todo1 = Todo("Finish deadline", 1,
    DateTime.now().toString(),
    "Finish all your projects before deadline");
  Todo todo2 = Todo("Sleep", 2,
    DateTime.now().toString(),
    "Get some sleep");
  helper.clearAllTodos();
  helper.insertTodo(todo1);
  helper.insertTodo(todo2);
}