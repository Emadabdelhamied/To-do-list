import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_list/shared/constants.dart';
import 'package:to_do_list/shared/cubit/cubit.dart';
import 'package:to_do_list/shared/cubit/states.dart';
import '../shared/component.dart';

class Done extends StatelessWidget {
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppCubit.get(context).doneTasks.length == 0
              ? Colors.white
              : primaryBackground,
          body: AppCubit.get(context).doneTasks.length == 0
              ? emptyPage('assets/images/done.png')
              : Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: ListView.separated(
                    itemBuilder: (context, index) => buildTaskCard(
                        AppCubit.get(context).doneTasks[index],
                        context,
                        [false, false, true, false]),
                    separatorBuilder: (context, index) => SizedBox(
                      height: 20,
                    ),
                    itemCount: AppCubit.get(context).doneTasks.length,
                  ),
                ),
        );
      },
    );
  }
}
