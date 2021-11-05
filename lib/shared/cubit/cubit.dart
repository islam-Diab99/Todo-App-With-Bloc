import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todomansour/modules/Archived%20tasks.dart';
import 'package:todomansour/modules/done%20tasks.dart';
import 'package:todomansour/modules/new%20tasks.dart';
import 'package:todomansour/shared/cubit/states.dart';

class AppCubit extends Cubit<AppStates>
{
  List<Map> newTasks=[];
  List<Map> DoneTasks=[];
  List<Map> ArchivedTasks=[];
  AppCubit() : super(AppInitialState());
  static AppCubit get(context)=>BlocProvider.of(context);
  int currentIndex=0;
  bool isBottomShown=false;
  List screans=[
    NewTasksScrean(),
    DoneTasksScrean(),
    ArchivedTasksScrean(),
  ];
  List titles=[
    'New Tasks',
    'Done Tasks',
    'Archived Tasks',

  ];
 void changeIndex(int index)
 {
   currentIndex=index;
   emit(AppChangeBottomNavBarState());
 }
  late Database database;
  void createDataBase ()

  {
    openDatabase(
        'todo.db',
        version: 1,
        onCreate:(database,version)
        {
          print('database created');
          database.execute('CREATE TABLE tasks (id INTEGER PRIMARY KEY,title TEXT,date TEXT,time TEXT,status TEXT)').then((value) => {
            print('table created'),

          }).catchError((error){
            print('error on create table is ${error.toString()}');
          });

        },
        onOpen: (database)
        {
          getDataFromDatabase(database);

          print('database opened');
          emit(AppCreatDatabaseState());
        }
    ).then((value) {
      database=value;

    });
  }
  void update({@required String status='',
  @required int id=0})async{


    database.rawUpdate(
        'UPDATE tasks SET status = ?WHERE id = ?',
        ['$status', id]).then((value) {
      getDataFromDatabase(database);

          emit(AppUpdateDatabaseState());


    });
  }
  Future insertToDataBase({required String time,
    required String title,
    required String date,}) async{

    return await database.transaction((txn) {
      txn.rawInsert('INSERT INTO tasks(title,date,time,status)VALUES("$title","$date","$time","new")').then((value) {
        emit(AppInsertDatabaseState());
        print('${value}insert suceesdded');
        getDataFromDatabase(database);

      });

      return Future(() => null);
    });
  }
  void delete({required id}){
    database
        .rawDelete('DELETE FROM tasks WHERE id= ?', [id]).then((value) {
      getDataFromDatabase(database);

      emit(AppDeleteDatabaseState());
    });

  }
  void getDataFromDatabase(Database database){
    newTasks=[];
    DoneTasks=[];
    ArchivedTasks=[];
    emit(AppGetDatabaseLoadingState());
     database.rawQuery('SELECT * FROM tasks').then((value) {

       value.forEach((element) {
         if(element['status']=='new')
           {
             newTasks.add(element);
           }
         else if (element['status']=='done'){
           DoneTasks.add(element);
         }
         else  {
           ArchivedTasks.add(element);
         };
       });
       emit(AppGetDatabaseState());

     });;

  }
  void changeBottomSheetState({required isShow}){
isBottomShown=isShow;
emit(AppChangeBottomSheetState());
  }
}