import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todomansour/components.dart';
import 'package:todomansour/shared/constants.dart';
import 'package:todomansour/shared/cubit/cubit.dart';
import 'package:todomansour/shared/cubit/states.dart';

class DoneTasksScrean extends StatelessWidget {
  DoneTasksScrean({Key? key,}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return
      BlocConsumer<AppCubit,AppStates>(

        builder: (BuildContext context, state) {
          var tasks=AppCubit.get(context).DoneTasks;
          return  ListView.separated(
            itemBuilder: (context,index)=>buildTaskItem(tasks[index],context),
            separatorBuilder: (context,index)=>Container(
              width: double.infinity,
              height: 1,
              color: Colors.grey[300],
            ),
            itemCount: tasks.length,
          );
        }, listener: (BuildContext context, Object? state) {  },

      );
  }
}

