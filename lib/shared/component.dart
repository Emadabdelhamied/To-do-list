import 'package:flutter/material.dart';
import 'package:to_do_list/shared/constants.dart';
import 'cubit/cubit.dart';

bool startEndDirection = true;
bool endStartDirection = true;
Widget buildTaskCard(Map model, context, List<bool> icons) => Dismissible(
      key: Key(model['id'].toString()),
      child: Container(
        width: double.infinity,
        height: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 10,
            ),
            CircleAvatar(
              backgroundColor: Color(0xffd0efff),
              radius: 30,
              child: Text(
                '${model['time']}',
                style: TextStyle(color: Colors.black),
              ),
            ),
            SizedBox(
              width: 20,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    '${model['title']}',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text('${model['date']}'),
                  SizedBox(
                    height: 15,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            icons[1]
                ? IconButton(
                    icon: Icon(
                      Icons.archive_rounded,
                      color: primaryColor,
                    ),
                    onPressed: () {
                      AppCubit.get(context).updateRecord(
                        status: 'archive',
                        id: model['id'],
                      );
                    })
                : SizedBox(
                    width: 0,
                  ),
            SizedBox(
              height: 10,
            ),
            icons[0]
                ? IconButton(
                    icon: Icon(
                      Icons.cloud_done,
                      color: primaryColor,
                    ),
                    onPressed: () {
                      AppCubit.get(context).updateRecord(
                        status: 'done',
                        id: model['id'],
                      );
                    })
                : SizedBox(width: 0),
            SizedBox(
              width: 10,
            ),
            icons[3]
                ? IconButton(
                    icon: Icon(
                      Icons.unarchive_rounded,
                      color: primaryColor,
                    ),
                    onPressed: () {
                      AppCubit.get(context).updateRecord(
                        status: 'new',
                        id: model['id'],
                      );
                    })
                : SizedBox(width: 0),
            SizedBox(
              width: 10,
            ),
            icons[2]
                ? IconButton(
                    icon: Icon(
                      Icons.cloud_done_outlined,
                      color: primaryColor,
                    ),
                    onPressed: () {
                      AppCubit.get(context).updateRecord(
                        status: 'new',
                        id: model['id'],
                      );
                    })
                : SizedBox(width: 0),
          ],
        ),
      ),
      onDismissed: (direction) {
        AppCubit.get(context).deleteData(id: model['id']);
      },
    );

Widget buildFormTask({
  @required TextEditingController controller,
  @required TextInputType type,
  @required String hint,
  Function onChange,
  Function onTap,
  @required validate,
  @required String label,
  @required IconData prefix,
}) =>
    Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: TextFormField(
          maxLength: 16,
          decoration: new InputDecoration(
            prefixIcon: Icon(
              prefix,
              color: primaryColor,
            ),
            labelText: label,
            hintText: hint,
            fillColor: Colors.white,
            filled: true,
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25.0),
              borderSide: BorderSide(
                color: primaryColor,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25.0),
              borderSide: BorderSide(
                color: Colors.black26,
              ),
            ),
            border: new OutlineInputBorder(
              borderRadius: new BorderRadius.circular(25.0),
              borderSide: BorderSide(
                color: Colors.black26,
              ),
            ),
          ),
          controller: controller,
          keyboardType: type,
          validator: validate,
          onTap: onTap,
          onChanged: onChange,
        ),
      ),
    );

Widget emptyPage(String path) => Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: double.infinity,
          height: 250,
          child: Image.asset(path),
        ),
      ],
    );
