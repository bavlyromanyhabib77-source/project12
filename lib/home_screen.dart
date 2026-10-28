import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_12/home_cubit.dart';
import 'package:flutter_application_12/Login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();

  @override
  void initState() {
    context.read<HomeCubit>().fetchTodos();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "My To-Do List",
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.black,
            fontSize: 20,
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 100),
              Expanded(
                child: BlocBuilder<HomeCubit, HomeState>(
                  builder: (context, state) {
                    print(state);
                    if (state is GetTodosLoading) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (state is GetTodosError) {
                      return Center(
                        child: Text(
                          state.message,
                          style: TextStyle(color: Colors.red),
                        ),
                      );
                    }

                    if (state is GetTodosSuccess) {
                      var todos = state.todos;
                      return ListView.separated(
                        separatorBuilder: (context, index) =>
                            SizedBox(height: 10),
                        itemCount: todos.length,
                        itemBuilder: (context, index) {
                          var todo = todos[index];
                          return Container(
                            height: 290,
                            width: 500,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.blueAccent,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  todo.id,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  todo.title,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  todo.body,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  "${todo.createdAt.year}-${todo.createdAt.month}-${todo.createdAt.day}",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),

                                ElevatedButton(
                                  onPressed: () {
                                    var firestore = FirebaseFirestore.instance;
                                    firestore
                                        .collection('todos')
                                        .doc(todo.id)
                                        .update({
                                          "title": "Dr.Mohamad",
                                          "body": "Flutter Developer",
                                          "createdAt": DateTime.now(),
                                        });
                                  },
                                  child: Text("Edit"),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    }
                    return SizedBox();
                  },
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut().then(
                    (value) => Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                      (route) {
                        return false;
                      },
                    ),
                  );
                },
                child: Text("Sign Out "),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) {
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
                        hintText: "Discreption",
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

                        var doc = firestore.collection("todos").doc();

                        doc.set({
                          "id": doc.id,
                          "title": _titleController.text,
                          "body": _bodyController.text,
                          "createdAt": DateTime.now(),
                        });
                      },
                      child: Text(
                        "Save Todo",
                        style: TextStyle(color: Colors.green),
                      ),
                    ),
                  ],
                ),
              );
            },
            isScrollControlled: true,
          );
        },
        child: Icon(Icons.add, size: 31, color: Colors.blueAccent),
      ),
    );
  }
}
