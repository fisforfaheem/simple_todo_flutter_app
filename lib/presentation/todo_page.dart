import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_todo_flutter_app/model/todo_model.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});
  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  //this will be used to store the data locally
  late SharedPreferences prefs;

  //controllers
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  bool showDone = false;

  //a List that contains objects of the todo class
  List<Todo> todoList = [];

  @override
  void initState() {
    super.initState();
    retrieveTodos();
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  retrieveTodos() async {
    prefs = await SharedPreferences.getInstance();
    final String? todoString = prefs.getString('todoList');
    if (todoString != null) {
      setState(() {
        todoList = (jsonDecode(todoString) as List)
            .map((todo) => Todo.fromJson(todo))
            .toList();
      });
    }
  }

  //this will get the todos from the shared preferences
  saveTodos() async {
    prefs = await SharedPreferences.getInstance();
    await prefs.setString('todoList', jsonEncode(todoList));
  }

//this will update the chekcbox on that index provided
  void updateTodo(int index, bool? value) {
    setState(() {
      todoList[index] = Todo(
        title: todoList[index].title,
        description: todoList[index].description,
        isDone: value!,
      );
      saveTodos();
    });
  }

//this will add a todo to the todoList
  void addTodo() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add Todo"),
          content: Column(
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  hintText: "Title",
                ),
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  hintText: "Description",
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  todoList.add(
                    Todo(
                      title: titleController.text,
                      description: descriptionController.text,
                      isDone: false,
                    ),
                  );
                  saveTodos();
                  titleController.clear();
                  descriptionController.clear();
                  Navigator.pop(context);
                });
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

//this will delete a todo from the todoList
  void deleteTodo(int index) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Delete Todo"),
            content: const Text("Are you sure you want to delete this todo?"),
            actions: [
              TextButton(
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    print('Removed:${todoList.removeAt(index).title}');
                    saveTodos();
                    Navigator.pop(context);
                  });
                },
                child: const Text("Delete"),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "TODO APP ",
        ),
        actions: [
          // Check if there are any completed tasks in the todoList
          if (todoList.any((element) => element.isDone))
            // If there are completed tasks, add a TextButton to the actions
            TextButton(
              // When the button is pressed, toggle the 'showDone' state
              onPressed: () {
                setState(() {
                  showDone = !showDone;
                });
              },
              // The button's label changes based on the 'showDone' state
              child: Text(
                showDone ? 'Hide Done' : 'Show Done',
              ),
            ),
        ],
      ),
      body: Center(
        child: ListView.builder(
          itemCount: todoList.length,
          itemBuilder: (context, index) {
            //check if there is any done todo
            if (todoList[index].isDone && !showDone) return const SizedBox();
            return ListTile(
              title: Text(todoList[index].title),
              subtitle: Text(todoList[index].description ?? ''),
              trailing: Checkbox(
                value: todoList[index].isDone,
                onChanged: (bool? value) {
                  updateTodo(index, value);
                },
              ),
              onLongPress: () => deleteTodo(index),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addTodo,
        child: const Icon(Icons.add),
      ),
    );
  }
}
