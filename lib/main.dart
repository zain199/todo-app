import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:todoApp/layout/todolayout.dart';
import 'shared/blocobserver.dart';

void main() {

    Bloc.observer = MyBlocObserver();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
    debugShowCheckedModeBanner: false,

      home: TodoLayout(),
    );
  }
}
