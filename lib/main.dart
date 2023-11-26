// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:simple_todo_flutter_app/todo_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const TodoPage(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.black,
        ),
      ),
    );
  }
}

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});
  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  //controllers
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  bool showDone = false;

  //a List that contains objects of the todo class
  List<Todo> todoList = [];

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

//this will update the chekcbox on that index provided
  void updateTodo(int index, bool? value) {
    setState(() {
      todoList[index] = Todo(
        title: todoList[index].title,
        description: todoList[index].description,
        isDone: value!,
      );
    });
  }

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
                    print(todoList.removeAt(index));
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
