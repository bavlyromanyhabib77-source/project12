import 'package:cloud_firestore/cloud_firestore.dart';

class Todo {
  final String id;
  final String title;
  final String body;
  final DateTime createdAt;

  Todo({
    required this.id,
    required this.title,
    required this.body,
    required this.createdAt,
  });

  factory Todo.fromJson(Map<String, dynamic> json) => Todo(
    id: json["id"]??"-1",
    title: json["title"],
    body: json["body"],
    createdAt: ((json["createdAt"] ?? Timestamp.now()) as Timestamp).toDate(),
  );
}
