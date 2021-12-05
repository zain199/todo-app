import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:todoApp/shared/cubit/cubit.dart';

Widget DefButton({

  double width = double.infinity,
  Color color = Colors.amber,
  @required Widget child,
  @required Function fun ,
}) => MaterialButton(

  minWidth:width ,
  color: color,
  child: child,
  onPressed: fun

);

Widget DefTextForm(
{
  @required TextInputType type ,
  @required TextEditingController controller ,
  Icon prefixicon ,
  String hint ,
  bool isPassword = false,
  IconData suffixicon ,
  Function sufOnPressed,
  Function validate,
  Function ontap,
  bool enabled=true,

}
)
{
  return TextFormField(

    enabled:enabled ,
    validator:validate ,
    obscureText:isPassword ,
    keyboardType: type,
    controller:controller ,
    decoration: InputDecoration(
      suffixIcon: IconButton(
          icon: Icon(suffixicon),
        onPressed: sufOnPressed,

      ),
      prefixIcon:prefixicon,
      hintText: hint,
      border: OutlineInputBorder(

        borderRadius: BorderRadius.circular(4.0),
      ),

    ),

    onTap: ontap,
  );
}


Widget taskItemBuild({@required List<Map> task,@required BuildContext context})
{
  return ConditionalBuilder(

    condition: (task.length > 0),
    builder: (context) =>   ListView.separated(
        padding: EdgeInsets.all(20.0),
        itemBuilder: (context, index) {
          Map tasks = task[index];
          return Dismissible(
            key: Key('dissssmissss'),
            onDismissed: (direction) {
              AppCubit.get(context).deleteData(tasks['id']);
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.amber[800],
                  radius:35.0,
                  child: Text(tasks["time"].toString(),
                  style: TextStyle(
                    color: Colors.white
                  ),),
                ),
                SizedBox(width: 15.0,),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${tasks['title']}',
                        style: TextStyle(
                          fontSize: 20.0
                          ,fontWeight: FontWeight.bold,
                        ),),
                      SizedBox(width: 10.0,),
                      Text('${tasks['date']}',
                        style: TextStyle(
                          fontSize: 15.0
                          ,
                        ),),
                    ],
                  ),
                ),

                IconButton(icon: Icon(Icons.cloud_done), onPressed: (){
                  AppCubit.get(context).updateData('done', tasks['id']);
                },
                color: Colors.amber[800],),

                IconButton(icon: Icon(Icons.archive_outlined), onPressed: (){
                  AppCubit.get(context).updateData('archived', tasks['id']);
                },
                  color: Colors.amber[800],
                ),

              ],
            ),
          );
        },

        separatorBuilder: (context, index) {
          return SizedBox(height: 10.0,);
        },
        itemCount:  task.length > 0 ? task.length :0
    ),
    fallback:(context) => Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon (Icons.menu
          ,size: 40.0,),
          SizedBox(height: 10.0,),
          Text(
            'No Tasks Yet, Add Some Tasks'
          ),
        ],
      ),
    ) ,
  );
}
