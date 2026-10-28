import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:flutter_application_12/todo_model.dart';
part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  void fetchTodos() async {
    var firestore = FirebaseFirestore.instance;
    emit(GetTodosLoading());

    try {
      var collection = await firestore.collection("todos").get();

      var docs = collection.docs.map((e) {
        return Todo.fromJson(e.data());
      }).toList();
      emit(GetTodosSuccess(docs));
    } catch (e) {
      if (e is TypeError) {
        print(e.stackTrace);
      }
      emit(GetTodosError(e.toString()));
    }
  }
}
