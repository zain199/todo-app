import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoApp/moules/archivedtasks/ArchivedTasks.dart';
import 'package:todoApp/moules/donetasks/DoneTasks.dart';
import 'package:todoApp/moules/newtasks/NewTasks.dart';
import 'package:todoApp/shared/components/components.dart';
import 'package:todoApp/shared/cubit/AppStates.dart';
import 'package:todoApp/shared/cubit/cubit.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:toast/toast.dart';

class TodoLayout extends StatelessWidget {



  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formkey = GlobalKey<FormState>();

  TextEditingController titlecon = TextEditingController();
  TextEditingController datecon = TextEditingController();
  TextEditingController timecon = TextEditingController();



  @override
  Widget build(BuildContext context) {


    return Center(
      child: BlocProvider(
        create: (context) => AppCubit()..createDataBase(),
        child: BlocConsumer<AppCubit,AppStates>(
          listener: (context, state) {
            if(state is InsertinDataBaseState)
              {
                //Navigator.pop(context);
              }
          },
          builder: (context, state) {
            AppCubit cubit = AppCubit.get(context);
            return Scaffold(
              appBar: AppBar(
                title: Text(cubit.titles[cubit.curIndx],style: TextStyle(color: Colors.black),),
                backgroundColor: Colors.amber,
              ),
              key: scaffoldKey,
              floatingActionButton: FloatingActionButton
                (backgroundColor: Colors.amber[800],
                child: cubit.isBottomSheetActive ? Icon(Icons.add) : Icon(Icons.edit),
                onPressed: () {

                  cubit.isBottomSheetActivee(!cubit.isBottomSheetActive);

                  if (cubit.isBottomSheetActive) {
                    scaffoldKey.currentState.showBottomSheet((contextt) {
                      return Container(
                        padding: EdgeInsets.all(10.0),
                        child: Form(
                          key: formkey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              DefTextForm(

                                  validate: (value) {
                                    if(value.isEmpty)
                                    {
                                      return 'needed';
                                    }
                                    return null;
                                  },
                                  type: TextInputType.text,
                                  controller: titlecon,
                                  prefixicon: Icon(Icons.menu),
                                  hint: 'Task Title'),
                              SizedBox(
                                height: 10.0,
                              ),
                              GestureDetector(
                                onTap: () {
                                  showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now())
                                      .then((value) {
                                    timecon.text = value.format(context).toString();
                                  });
                                },
                                child: DefTextForm(
                                  enabled: false,
                                  type: TextInputType.number,
                                  controller: timecon,
                                  prefixicon: Icon(Icons.watch_later_outlined),
                                  hint: 'Time Task',
                                  validate: (value) {
                                    if(value.isEmpty)
                                    {
                                      return 'needed';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              GestureDetector(
                                onTap: () {
                                  showDatePicker(
                                      context: context,
                                      initialDate: DateTime(2022),
                                      firstDate: DateTime(2021),
                                      lastDate: DateTime(2030))
                                      .then((value) {
                                    datecon.text = DateFormat.yMd().format(value);
                                  });
                                },
                                child: DefTextForm(
                                    enabled: false,
                                    validate: (String value) {
                                      if(value.isEmpty)
                                      {
                                        return 'needed';
                                      }
                                      return null;
                                    },
                                    type: TextInputType.text,
                                    controller: datecon,
                                    prefixicon: Icon(Icons.calendar_today_outlined),
                                    hint: 'Date Task'),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).closed.then((value) {
                      AppCubit.get(context).isBottomSheetActivee(false);
                    });
                  } else {
                    if (formkey.currentState.validate()) {
                      Navigator.pop(scaffoldKey.currentContext);
                      cubit.insertIntoDataBase(titlecon.text, datecon.text, timecon.text);
                      Toast.show('inserted successfuly', context);
                      titlecon.text="";
                      datecon.text="";
                      timecon.text="";
                    }else
                    {
                      cubit.isBottomSheetActivee(true);
                    }

                  }
                },
              ),
              bottomNavigationBar: BottomNavigationBar(
                selectedItemColor: Colors.amber,
                onTap: (ind) {
                  cubit.curind(ind) ;
                },
                currentIndex: cubit.curIndx,
                items: [
                  BottomNavigationBarItem(label: 'Tasks', icon: Icon(Icons.menu)),
                  BottomNavigationBarItem(label: 'Done', icon: Icon(Icons.done_all)),
                  BottomNavigationBarItem(
                      label: 'Archived', icon: Icon(Icons.archive_outlined)),
                ],
              ),
              body: cubit.screens[cubit.curIndx],
            );
          },

        ),
      ),
    );
  }

}