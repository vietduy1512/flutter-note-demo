import 'package:flutter/material.dart';
import 'package:note_demo/model/todo.dart';
import 'package:note_demo/util/dbhelper.dart';
import 'package:note_demo/screens/tododetail.dart';

class TodoList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => TodoListState();
}

class TodoListState extends State {
  DbHelper helper = DbHelper();
  List<Todo> todos;
  int count = 0;

  @override
  Widget build(BuildContext context) {
    if (todos == null) {
      todos = List<Todo>();
      getData();
    }
    return Scaffold(
      body: todoListItems(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          navigateToDetail(Todo('', 3, ''));
        },
        tooltip: "Add new todo",
        child: Icon(Icons.add),
      ),
    );
  }

  ListView todoListItems() {
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: getColor(this.todos[position].priority),
              child: Text(this.todos[position].priority.toString())
            ),
            title: Text(this.todos[position].title),
            subtitle: Text(this.todos[position].date),
            onTap: () {
              debugPrint(this.todos[position].id.toString() + " is tapped.");
              navigateToDetail(this.todos[position]);
            },
            trailing: FlatButton(
              onPressed: () => delete(position),
              child: Icon(Icons.delete),
            )
          )
        );
      },
    );
  }

  void getData() {
    final dbFuture = helper.initializeDb();
    dbFuture.then((result) {
      final todosFuture = helper.getTodos();
      todosFuture.then((result) {
        List<Todo> todoList = List<Todo>();
        count = result.length;
        for (int i = 0; i < count; i++) {
          todoList.add(Todo.fromObject(result[i]));
          debugPrint(todoList[i].title);
        }
        setState(() {
          todos = todoList;
          count = count;
        });
        debugPrint("Items " + count.toString());
      });
    });
  }
  
  Color getColor(int priority) {
    switch (priority) {
      case 1:
        return Colors.red;
        break;
      case 2:
        return Colors.orange;
        break;
      case 3:
        return Colors.green;
        break;
      default:
        return Colors.grey;
    }
  }

  void navigateToDetail(Todo todo) async {
    bool result = await Navigator.push(context,
      MaterialPageRoute(builder: (context) => TodoDetail(todo))
    );
    if (result == true) {
      getData();
    }
  }

  void delete(int position) async {
    var result = await helper.deleteTodo(this.todos[position].id);
    if (result != 0) {
      AlertDialog alertDialog = AlertDialog(
        title: Text("Delete successfully"),
        content: Text(this.todos[position].title + " has been deleted")
      );
      showDialog(context: context, builder: (_) => alertDialog);
      getData();
    }
  }
}
