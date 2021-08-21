import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:to_do_list/shared/constants.dart';
import 'package:to_do_list/shared/cubit/cubit.dart';
import 'package:to_do_list/shared/cubit/states.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class HomePage extends StatelessWidget {
  var database;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context)=>AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit,AppStates>(
        listener: (context,state){},
        builder: (context,state){
          AppCubit cubit=AppCubit.get(context);
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              title: Center(
                  child: Text(
                    cubit.bars[cubit.currentIndex],
                    style: TextStyle(color: Colors.black, fontSize: 30),
                  )),
            ),
            bottomNavigationBar: CurvedNavigationBar(
              color: Colors.white,
              buttonBackgroundColor: Colors.white,
              backgroundColor: primaryColor,
              animationCurve: Curves.easeInOut,
              animationDuration: Duration(milliseconds: 600),
              onTap: (index) {
               cubit.changeIndex(index);
              },
              index: cubit.currentIndex,
              items: [
                Icon(
                  Icons.cloud_done,
                  color: primaryColor,
                ),
                Icon(
                  Icons.table_rows_rounded,
                  color: primaryColor,
                ),
                Icon(
                  Icons.archive,
                  color: primaryColor,
                ),
              ],
            ),
            body: ConditionalBuilder(
              condition: state is! AppLoadingState,
              builder: (context) => cubit.screens[cubit.currentIndex],
              fallback: (context) => Center(child: CircularProgressIndicator()),
            ),
          );
        },
      )
    );
  }

  void createDatabase() async {
    database = await openDatabase('to_do.db', version: 1,
        onCreate: (database, version) {
      database
          .execute(
              'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time Text, status TEXT)')
          .then((value) {
        print('DB Created');
      }).catchError((error) {
        print('Error on created ${error.toString()}');
      });
    }, onOpen: (database) {
      print('DB Opened');
    });
  }

  Future insertRecord({
    @required title,
    @required time,
    @required date,
  }) async {
    return await database.transaction((txn) {
      txn
          .rawInsert(
              'INSERT INTO tasks(title,date,time,status) VALUES("$title","$date","$time","new")')
          .then((value) {
        print('$value Is Inserted');
      }).catchError((error) {
        print('Error on created ${error.toString()}');
      });
    });
  }
}
