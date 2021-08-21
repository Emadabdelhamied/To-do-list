import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:to_do_list/shared/constants.dart';
import 'package:to_do_list/shared/cubit/cubit.dart';
import 'package:to_do_list/shared/cubit/states.dart';
import '../shared/component.dart';

class Tasks extends StatelessWidget {
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        if (state is AppInsertDatabaseState) {
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        AppCubit cubit = AppCubit.get(context);
        return Scaffold(
          key: scaffoldKey,
          backgroundColor: AppCubit.get(context).newTasks.length == 0
              ? Colors.white
              : primaryBackground,
          floatingActionButton: FloatingActionButton(
            child: Icon(cubit.FabIcon),
            backgroundColor: primaryColor,
            onPressed: () {
              if (cubit.isBottomSheetShown) {
                if (formKey.currentState.validate()) {
                  cubit.insertRecord(
                      title: titleController.text,
                      time: timeController.text,
                      date: dateController.text);
                  timeController.text = '';
                  titleController.text = '';
                  dateController.text = '';
                }
              } else {
                scaffoldKey.currentState
                    .showBottomSheet(
                      (context) => Padding(
                        padding: const EdgeInsets.only(
                          left: 12,
                          right: 12,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Form(
                            key: formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(height: 10),
                                Container(
                                  height: 8,
                                  width: 100,
                                  decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(250)),
                                ),
                                buildFormTask(
                                    controller: titleController,
                                    type: TextInputType.text,
                                    hint: 'Enter Task',
                                    validate: (String value) {
                                      if (value.isEmpty) {
                                        return 'You Should add Task';
                                      }
                                      return null;
                                    },
                                    label: 'Task',
                                    prefix: Icons.table_rows_rounded),
                                buildFormTask(
                                    controller: timeController,
                                    type: TextInputType.datetime,
                                    hint: 'Enter Time',
                                    validate: (String value) {
                                      if (value.isEmpty) {
                                        return 'You Should Set Time';
                                      }
                                      return null;
                                    },
                                    label: 'Time',
                                    prefix: Icons.watch_later_outlined,
                                    onTap: () {
                                      showTimePicker(
                                              context: context,
                                              initialTime: TimeOfDay.now())
                                          .then((value) {
                                        timeController.text =
                                            value.format(context).toString();
                                      });
                                    }),
                                buildFormTask(
                                    controller: dateController,
                                    type: TextInputType.datetime,
                                    hint: 'Enter Date',
                                    validate: (String value) {
                                      if (value.isEmpty) {
                                        return 'You Should Set Date';
                                      }
                                      return null;
                                    },
                                    label: 'Date',
                                    prefix: Icons.calendar_today_outlined,
                                    onTap: () {
                                      showDatePicker(
                                              context: context,
                                              initialDate: DateTime.now(),
                                              firstDate: DateTime.now(),
                                              lastDate:
                                                  DateTime.parse('2040-03-05'))
                                          .then((value) {
                                        dateController.text =
                                            DateFormat.yMMMd().format(value);
                                      });
                                    }),
                                SizedBox(
                                  height: 10,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      backgroundColor: primaryColor.withOpacity(0),
                    )
                    .closed
                    .then((value) {
                  cubit.changeFabIcon(isShow: false, icon: Icons.edit);
                  timeController.text = '';
                  titleController.text = '';
                  dateController.text = '';
                });
                cubit.changeFabIcon(isShow: true, icon: Icons.add);
              }
            },
          ),
          body: AppCubit.get(context).newTasks.length == 0
              ? emptyPage('assets/images/add_note.png')
              : Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: ListView.separated(
                    itemBuilder: (context, index) => buildTaskCard(
                        cubit.newTasks[index],
                        context,
                        [true, true, false, false]),
                    separatorBuilder: (context, index) => SizedBox(
                      height: 20,
                    ),
                    itemCount: cubit.newTasks.length,
                  ),
                ),
        );
      },
    );
  }
}
