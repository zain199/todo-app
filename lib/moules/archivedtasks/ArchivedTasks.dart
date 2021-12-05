
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoApp/shared/components/components.dart';
import 'package:todoApp/shared/cubit/AppStates.dart';
import 'package:todoApp/shared/cubit/cubit.dart';

class ArchivedTasks extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener: (context, state) {

      },
      builder: (context, state) {
        return taskItemBuild(task :AppCubit.get(context).archivedtasks,context: context);
      },
    );
  }
}
