
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoApp/moules/archivedtasks/ArchivedTasks.dart';
import 'package:todoApp/moules/donetasks/DoneTasks.dart';
import 'package:todoApp/moules/newtasks/NewTasks.dart';
import 'package:todoApp/shared/cubit/AppStates.dart';
import 'package:sqflite/sqflite.dart';

class AppCubit extends Cubit<AppStates>
{
  int curIndx = 0;

  AppCubit() : super(InitAppState());

  static AppCubit get (context) => BlocProvider.of(context);

  List<Widget> screens = [
    NewTasks(),
    DoneTasks(),
    ArchivedTasks()
  ];

  List titles = [
    'New Tasks',
    'Done Tasks',
    'Archived Tasks',
  ];

  void curind (ind)
  {
    this.curIndx = ind;
    emit(BottomSheetNavBarState());

  }

  bool isBottomSheetActive = false;

  void isBottomSheetActivee (bool active)
  {
    isBottomSheetActive = active;
    emit(isBottomSheetActiveState());
  }

  Database database;


  void createDataBase()  {
    openDatabase(
      'todo.db',
      version: 1,
      onCreate: (db, version) {
        print('db created');

        db
            .execute(
            'create table tasks (id integer primary key , title text , date text , time text , state text)')
            .then((value) {
          print('table created');
        }).catchError((error) {
          print('error with creating table is ${error.toString()}');
        });
      },
      onOpen: (db) {

      },
    ).then((value) {
      database =value;
          emit(CreateDataBaseState());
      getDataFromDB(database);
    });
  }

  void insertIntoDataBase(String title, String date, String time)async {
    database.transaction((txn) {
      txn
          .execute(
          'insert into tasks(title,date,time,state) values ("$title","$date","$time","new")')
          .then((value) {
            emit(InsertinDataBaseState());
            getDataFromDB(database);
        print( 'record inserted successfuly');
      }).catchError((onError) {
        print( 'record inserted unsuccessfuly');
      });
      return null;
    });
  }

  List<Map>newtasks=[{'titles':'asd'}];
  List<Map>donetasks=[{'titles':'asd'}];
  List<Map>archivedtasks=[{'titles':'asd'}];

  void getDataFromDB(Database db)
  {

    newtasks=[];
    donetasks=[];
    archivedtasks=[];


    db.rawQuery('select * from tasks').then((value) {


      value.forEach((element) {
        if(element['state'] == 'new')
          newtasks.add(element) ;
        else if(element['state'] == 'done')
          donetasks.add(element) ;
        else archivedtasks.add(element);
      });

      emit(GetFromDataBaseState());
    });
  }

  void updateData (String state , int id)async
  {
    database.rawUpdate('update tasks set state = ? where id = ?',['$state',id])
        .then((value) {
          emit(UpdateFromDataBaseState());
      getDataFromDB(database);

    });

  }

  void deleteData (int id)async
  {
    database.rawDelete('delete from tasks where id = ?',[id])
        .then((value) {
      emit(DeleteFromDataBaseState());
      getDataFromDB(database);

    });

  }
}