import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_list/shared/constants.dart';
import 'package:to_do_list/shared/cubit/cubit.dart';
import 'package:to_do_list/shared/cubit/states.dart';
import '../shared/component.dart';

class Archive extends StatelessWidget {
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppCubit.get(context).archiveTasks.length == 0
              ? Colors.white
              : primaryBackground,
          body: AppCubit.get(context).archiveTasks.length == 0
              ? emptyPage('assets/images/archive.png')
              : Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: ListView.separated(
                    itemBuilder: (context, index) => buildTaskCard(
                        AppCubit.get(context).archiveTasks[index],
                        context,
                        [false, false, false, true]),
                    separatorBuilder: (context, index) => SizedBox(
                      height: 20,
                    ),
                    itemCount: AppCubit.get(context).archiveTasks.length,
                  ),
                ),
        );
      },
    );
  }
}
