

import 'package:flutter/material.dart';
import 'package:todomansour/shared/cubit/cubit.dart';

Widget buildTaskItem(Map tasks,context)=>Dismissible(
  key: Key(tasks['id'].toString()),
  onDismissed: (direction){
AppCubit.get(context).delete(id: tasks['id']);
  },
  child:   Padding(
  
    padding: const EdgeInsets.all(20.0),
  
    child: Row(
  
      children: [
  
        CircleAvatar(
  
          radius: 40,
  
          child: Text(tasks['time']),
  
  
  
        ),
  
        SizedBox(
  
          width: 15,
  
        ),
  
        Expanded(
  
          child: Column(
  
            mainAxisSize: MainAxisSize.min,
  
            crossAxisAlignment: CrossAxisAlignment.start,
  
            children: [
  
              Text(tasks['title'],style:  TextStyle(
  
                fontSize: 18,
  
                fontWeight: FontWeight.bold,
  
              ),),
  
              Text(tasks['date'] ,style:  TextStyle(
  
                fontWeight: FontWeight.bold,
  
                color: Colors.grey,
  
              ),),
  
            ],
  
          ),
  
        ),
  
        SizedBox(
  
          width: 15,
  
        ),
  
        IconButton(
  
            onPressed: (){
  
              AppCubit.get(context).update(status: 'done',id:tasks['id'] );
  
            }, icon: Icon(Icons.check_box,color: Colors.green,)),
  
        IconButton(
  
            onPressed: (){
  
              AppCubit.get(context).update(status: 'archived',id:tasks['id'] );
  
            }, icon: Icon(Icons.archive,color: Colors.black45,)),
  
  
  
      ],
  
  
  
    ),
  
  ),
);