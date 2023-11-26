class Todo {
  //properties
  final String title;
  final String? description;
  final bool isDone;

//contructor
  Todo({
    required this.title,
    this.description,
    this.isDone = false,
  });
}
