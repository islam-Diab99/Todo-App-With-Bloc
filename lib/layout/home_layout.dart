

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todomansour/modules/Archived%20tasks.dart';
import 'package:todomansour/modules/done%20tasks.dart';
import 'package:todomansour/modules/new%20tasks.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todomansour/shared/constants.dart';
import 'package:todomansour/shared/cubit/cubit.dart';
import 'package:todomansour/shared/cubit/states.dart';

class HomeLayout extends StatelessWidget {
   HomeLayout({Key? key}) : super(key: key);


  var scaffoldKey=GlobalKey<ScaffoldState>();
  var formKey=GlobalKey<FormState>();
  var titleController=TextEditingController();
  var timeController=TextEditingController();
  var dateController=TextEditingController();



  @override
  Widget build(BuildContext context) {

    return BlocProvider(
      create: (BuildContext context) =>AppCubit()..createDataBase(),

      child: BlocConsumer<AppCubit,AppStates>(

        listener: (BuildContext context, state) {
          if(state is AppChangeBottomNavBarState) print('change');
          if(state is AppInsertDatabaseState)
            {
              Navigator.pop(context);
            };

        },
        builder: (BuildContext context, Object? state) {
          AppCubit cubit=AppCubit.get(context);
        return  Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text(cubit.titles[cubit.currentIndex],),
            ),

            body:state is! AppGetDatabaseLoadingState?

            cubit.screans[cubit.currentIndex]

             :
        Center(child: CircularProgressIndicator(),),

            floatingActionButton: FloatingActionButton(
              onPressed: (){
                if(cubit.isBottomShown){
                  if (formKey.currentState!.validate())
                  {
                   cubit.insertToDataBase(time: timeController.text, title: titleController.text, date: dateController.text);

                  }

                }
                else
                {
                  scaffoldKey.currentState!.showBottomSheet((
                      context) =>Container(
                    color: Colors.grey[200],
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Form(
                        key: formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            defaulfFormField(

                              controller:titleController ,
                              inputType: TextInputType.text,
                              validate: ( Value){
                                if (Value!.isEmpty)
                                {
                                  return 'Title must not be empty';
                                }
                                return null;
                              },
                              labelText: 'Task title',
                              prifix: Icons.title,


                            ),
                            SizedBox(height: 15,),
                            defaulfFormField(
                                controller: timeController,
                                validate: (String? value){
                                  if(value!.isEmpty)
                                  {
                                    return 'Time must be not empty';
                                  }
                                },
                                inputType: TextInputType.none,
                                labelText: 'Task time',
                                prifix: Icons.watch_later_outlined,
                                onTap: (){
                                  showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now(),
                                  ).then((value) => {

                                    timeController.text=value!.format(context).toString(),

                                  });
                                }



                            ),
                            SizedBox(height: 15,),
                            defaulfFormField(
                                controller: dateController,
                                validate: (String? value){
                                  if(value!.isEmpty)
                                  {
                                    return 'Time must be not empty';
                                  }
                                },
                                inputType: TextInputType.none,
                                labelText: 'Task date',
                                prifix: Icons.calendar_today,
                                onTap: (){
                                  showDatePicker(
                                    context: context,
                                    initialDate:DateTime.now() ,
                                    firstDate: DateTime.now() ,
                                    lastDate: DateTime.parse('2021-12-03'),
                                  ).then((value) => {
                                    dateController.text=DateFormat.yMMMd().format(value!),

                                  });
                                }



                            )
                          ],
                        ),
                      ),
                    ),
                  ),

                    elevation: 80,
                  ).closed.then((value)  {
                    cubit.changeBottomSheetState(isShow: false);


                  });
                  cubit.changeBottomSheetState(isShow: true);



                }

              },
              child: Icon(

                  cubit.isBottomShown?Icons.add:Icons.edit
              ),

            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex:AppCubit.get(context).currentIndex ,

              onTap: (index){
                AppCubit.get(context).changeIndex(index);

              },
              items: [
                BottomNavigationBarItem(
                    icon: Icon(
                        Icons.menu
                    ),
                    label: 'Tasks'
                ),
                BottomNavigationBarItem(
                    icon: Icon(
                        Icons.check_circle_outline
                    ),
                    label: 'Done'
                ),
                BottomNavigationBarItem(
                    icon: Icon(
                        Icons.archive_outlined
                    ),
                    label: 'Archived'
                ),
              ],

            ),
          );
        },

      ),
    );
  }

  Widget defaulfFormField({
    required TextEditingController controller,
    @required TextInputType? inputType,
    var onSubmit,
    var onChange,
    var onTap,
    String? labelText,

    required String? validate(String? value)?,
    IconData? prifix,}){


    return TextFormField(
      controller:  controller,
      keyboardType: inputType,
      onFieldSubmitted:onSubmit ,
      onChanged: onChange,
      validator: validate,
      onTap: onTap,
      decoration: InputDecoration(
        labelText:labelText,
        prefixIcon: Icon(
            prifix
        ),
        border: OutlineInputBorder(),

      ),
      focusNode:FocusNode() ,
    );
  }

}


