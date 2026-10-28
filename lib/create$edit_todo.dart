import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_12/home_cubit.dart';
import 'package:flutter_application_12/todo_model.dart';

class CustomTodoCreation extends StatefulWidget {
  CustomTodoCreation({super.key, this.isEditing = false, this.todo});

  final bool? isEditing;

  final Todo? todo;

  @override
  State<CustomTodoCreation> createState() => _CustomTodoCreationState();
}

class _CustomTodoCreationState extends State<CustomTodoCreation> {
  late TextEditingController _titleController;

  late TextEditingController _bodyController;

  @override
  void initState() {
    if (widget.isEditing!) {
      _titleController = TextEditingController(text: widget.todo!.title);
      _bodyController = TextEditingController(text: widget.todo!.body);
    } else {
      _titleController = TextEditingController();
      _bodyController = TextEditingController();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 700,
      child: Column(
        children: [
          SizedBox(height: 14),

          Container(
            width: 54,
            height: 4,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 100),
          TextFormField(
            controller: _titleController,
            decoration: InputDecoration(
              hintText: "Title",
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          SizedBox(height: 24),
          TextFormField(
            controller: _bodyController,
            decoration: InputDecoration(
              hintText: "body",
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            maxLines: 16,
          ),

          ElevatedButton(
            onPressed: () async {
              var firestore = FirebaseFirestore.instance;

              if (widget.isEditing!) {
                var x = context.read<HomeCubit>().editTodo(
                  todo: widget.todo!,
                  title: _titleController.text,
                  body: _bodyController.text,
                );

                if (x) {
                  Navigator.pop(context);
                }
              } else {
                var x = context.read<HomeCubit>().createTodo(
                  title: _titleController.text,
                  body: _bodyController.text,
                );

                if (x) {
                  Navigator.pop(context);
                }
              }
            },
            child: Text("Add Todo", style: TextStyle(color: Colors.green)),
          ),
        ],
      ),
    );
  }
}
