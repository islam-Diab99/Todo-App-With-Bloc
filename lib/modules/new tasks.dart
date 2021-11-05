
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todomansour/components.dart';
import 'package:todomansour/shared/constants.dart';
import 'package:todomansour/shared/cubit/cubit.dart';
import 'package:todomansour/shared/cubit/states.dart';

class NewTasksScrean extends StatelessWidget {
   NewTasksScrean({Key? key,}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return
      BlocConsumer<AppCubit,AppStates>(

        builder: (BuildContext context, state) {
          var tasks=AppCubit.get(context).newTasks;
        return tasks.length>0? ListView.separated(
            itemBuilder: (context,index)=>buildTaskItem(tasks[index],context),
            separatorBuilder: (context,index)=>Container(
              width: double.infinity,
              height: 1,
              color: Colors.grey[300],
            ),
            itemCount: tasks.length,
          ):Center(
            child: Column(

            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.edit_rounded,size: 30,color: Colors.grey,),
              SizedBox(height: 10,),

              Text('No tasks added yet, Please add some tasks',style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),),
            ],
        ),
          );
        }, listener: (BuildContext context, Object? state) {  },

      );
  }
}
