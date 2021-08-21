import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:to_do_list/shared/cubit/states.dart';
import 'package:to_do_list/to_do/Archive.dart';
import 'package:to_do_list/to_do/Done.dart';
import 'package:to_do_list/to_do/Tasks.dart';

class AppCubit extends Cubit<AppStates>
{
  AppCubit() : super(AppInitialState());
  static AppCubit get(context)=>BlocProvider.of(context);
  var database;
  bool isBottomSheetShown = false;
  IconData FabIcon = Icons.add;
  int currentIndex = 1;
  List screens = [Done(), Tasks(), Archive()];
  List bars = ['Done', 'Tasks', 'Archive'];
  List<Map> newTasks=[];
  List<Map> doneTasks=[];
  List<Map> archiveTasks=[];
  void changeIndex(index){
    currentIndex=index;
    emit(AppChangeNavState());
  }
  void changeFabIcon({
  @required bool isShow,
    @required IconData icon
}){
    isBottomSheetShown=isShow;
    FabIcon=icon;
    emit(FabIconChangeState());
  }
  void createDatabase() {
    database= openDatabase(
        'to_do.db',
        version: 1,
        onCreate: (database,version){
          database.execute(
              'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time Text, status TEXT)'
          ).then((value){
            print('DB Created');
          }).catchError((error){print('Error on created ${error.toString()}');});
        },
        onOpen: (database){
          getDataFromDB(database);
        }
    ).then((value){
      database=value;
      emit(AppCreateDatabaseState());
    });
  }
  Future insertRecord({
    @required title,
    @required time,
    @required date,
  })async{
    return await database.transaction((txn){
      txn.rawInsert(
          'INSERT INTO tasks(title,date,time,status) VALUES("$title","$date","$time","new")'
      ).then((value){
        print('$value Is Inserted');
        emit(AppInsertDatabaseState());
        getDataFromDB(database);
      }).catchError((error){
        print('Error on created ${error.toString()}');
      });
    }
    );
  }

  void getDataFromDB(database)async{
    newTasks=[];
    doneTasks=[];
    archiveTasks=[];
    emit(AppLoadingState());
   database.rawQuery("SELECT * FROM tasks").then((value) {
     value.forEach((element)
     {
       if(element['status'] == 'new')
         newTasks.add(element);
       else if(element['status'] == 'done')
         doneTasks.add(element);
       else archiveTasks.add(element);
     });
     emit(AppGetDatabaseState());
   });

  }

  void updateRecord({
    @required String status,
    @required int id,
}){
    database.rawUpdate(
      'UPDATE tasks SET status = ? WHERE id = ?',
      ['$status',id],
    ).then((value){
      getDataFromDB(database);
      emit(AppUpdateDatabaseState());
    });
  }

  void deleteData({
    @required int id,
  }) async
  {
    database.rawDelete('DELETE FROM tasks WHERE id = ?', [id])
        .then((value)
    {
      getDataFromDB(database);
      emit(AppDeleteDatabaseState());
    });
  }
}