import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_12/home_cubit.dart';
import 'package:flutter_application_12/Login_screen.dart';
import 'package:flutter_application_12/create%24edit_todo.dart';

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
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        todo.id,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      BlocConsumer<HomeCubit, HomeState>(
                                        buildWhen: (previous, current) {
                                          if (current is DeleteTodoLoading ||
                                              current is DeleteTodoFailure ||
                                              current is DeleteTodoSuccess) {
                                            return true;
                                          }
                                          return false;
                                        },
                                        listener: (context, state) {
                                          if (state is DeleteTodoFailure) {
                                            showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                title: Text(
                                                  "Error",
                                                  style: TextStyle(
                                                    fontSize: 24,
                                                  ),
                                                ),
                                                content: Text(state.message),
                                                actions: [
                                                  ElevatedButton(
                                                    style:
                                                        ElevatedButton.styleFrom(
                                                          backgroundColor:
                                                              Colors.blueAccent,
                                                        ),
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: Text(
                                                      "Ok",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }
                                          if (state is DeleteTodoSuccess) {
                                            context
                                                .read<HomeCubit>()
                                                .fetchTodos();
                                          }
                                        },
                                        builder: (context, state) {
                                          print(state);
                                          if (state is DeleteTodoLoading) {
                                            return CircularProgressIndicator(
                                              color: Colors.white,
                                            );
                                          }

                                          return GestureDetector(
                                            onTap: () {
                                              // cubit
                                              context
                                                  .read<HomeCubit>()
                                                  .deleteTodo(todo.id);
                                            },
                                            child: Icon(
                                              Icons.delete,
                                              size: 34,
                                              color: Colors.white,
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
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
                                    showModalBottomSheet(
                                      context: context,
                                      builder: (context) => BlocProvider(
                                        create: (context) => HomeCubit(),
                                        child: CustomTodoCreation(
                                          isEditing: true,
                                          todo: todo,
                                        ),
                                      ),
                                      isScrollControlled: true,
                                    ).then((value) {
                                      context.read<HomeCubit>().fetchTodos();
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
                        showModalBottomSheet(
                          context: context,
                          builder: (_) {
                            return BlocProvider(
                              create: (_) => HomeCubit(),
                              child: CustomTodoCreation(),
                            );
                          },
                        );
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
