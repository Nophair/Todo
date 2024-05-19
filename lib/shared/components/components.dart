import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:todo_list/shared/cubit/cubit.dart';

Widget buildNewTaskItem(Map model, context) {
  AppCubit cubit = AppCubit.get(context);
  var desController = TextEditingController(text: '${model['description']}');
  return InkWell(
    onTap: (){
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            contentPadding: const EdgeInsets.all(10),
            titlePadding: const EdgeInsets.all(10),
            actionsPadding: const EdgeInsets.all(10),

            scrollable: true,
            title: Row(
              children: [
                SizedBox(
                  width: 230,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('${model['title']}',maxLines: 1,style: const TextStyle(overflow: TextOverflow.ellipsis,),),
                  ),
                ),
                const Spacer(),
                IconButton(
                    onPressed: () {
                      cubit.refreshApp();
                      return Navigator.pop(context);
                    },
                    icon: const Icon(
                      size: 30,
                      Icons.highlight_remove,
                      color: Color(0xFF2fe48d),
                    )),
              ],
            ),
            content: SizedBox(
              width: 300,
              child: TextFormField(
                scrollPadding: const EdgeInsets.all(5),
                maxLength: 500,
                maxLengthEnforcement: MaxLengthEnforcement.enforced,
                controller: desController,
                maxLines: 5,
                style: const TextStyle(
                  color: Colors.black,
                ),
                keyboardType: TextInputType.text,
                cursorColor: const Color(0xFF2fe48d),
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                    const BorderSide(color: Color(0xFF2fe48d), width: 2.0),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),
            actions: [
              Row(
                children: [
                  MaterialButton(
                    onPressed: () {
                      cubit.deleteData(id: model['id']);
                      AwesomeNotifications().cancel(model['notify']);
                      return Navigator.pop(context);
                    },
                    color: const Color(0xFF2fe48d),
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: const Text('Delete the task',style: TextStyle(color: Colors.black),),
                  ),
                  const Spacer(),
                  MaterialButton(
                    onPressed: () {
                      cubit.updateDescription(
                        id: model['id'],
                        description: desController.text,
                      ).then((value) {
                        showToast(text: 'Updated successfully', state: ToastStates.success);
                      });
                      return cubit.refreshApp();
                    },
                    color: const Color(0xFF2fe48d),
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: const Text('Update description',style: TextStyle(color: Colors.black,),),
                  ),
                ],
              ),
            ],
          );
        },
      ).then((value) => cubit.refreshApp());
    },
    child: Dismissible(
      key: Key(model['id'].toString()),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Container(
          width: double.infinity,
          child: Row(
            children: [
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: Color(0xFF2fe48d),
                ),
                child: Center(child: Text(
                  '${model['time']}',
                  style: TextStyle(fontFamily: 'NoyhR',fontSize: 17.0,),
                ),
                ),
              ),
              SizedBox(
                width: 15.0,
              ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${model['title']}',
                      maxLines: 1,
                      style: TextStyle(
                        overflow: TextOverflow.ellipsis,
                        fontFamily: 'NoyhR',
                        color: Colors.white,
                        fontSize: 23.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${model['date']}',
                      style: TextStyle(
                        fontFamily: 'NoyhR',
                        fontSize: 15.0,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: ()
                {
                  AppCubit.get(context).updateData(
                    id: model['id'],
                    status: 'done',
                  );
                },
                icon:  Icon(
                  Icons.check_box_outline_blank ,
                  color: Colors.green,
                ),
              ),
              IconButton(
                onPressed: ()
                {
                  AppCubit.get(context).updateData(
                    id: model['id'],
                    status: 'archive',
                  );
                },
                icon: Icon(
                  Icons.archive_outlined,
                  color: Color(0xFF2fe48d),
                ),
              ),
            ],
          ),
        ),
      ),
      onDismissed: (direction)
      {
        AppCubit.get(context).deleteData(id: model['id'],);
        AwesomeNotifications().cancel(model['notify']);
      },
    ),
  );
}
Widget buildDoneTaskItem(Map model, context) {
  AppCubit cubit = AppCubit.get(context);
  var desController = TextEditingController(text: '${model['description']}');
  return InkWell(
    onTap: (){
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            contentPadding: const EdgeInsets.all(10),
            titlePadding: const EdgeInsets.all(10),
            actionsPadding: const EdgeInsets.all(10),

            scrollable: true,
            title: Row(
              children: [
                SizedBox(
                  width: 230,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('${model['title']}',maxLines: 1,style: const TextStyle(overflow: TextOverflow.ellipsis,),),
                  ),
                ),
                const Spacer(),
                IconButton(
                    onPressed: () {
                      cubit.refreshApp();
                      return Navigator.pop(context);
                    },
                    icon: const Icon(
                      size: 30,
                      Icons.highlight_remove,
                      color: Color(0xFF2fe48d),
                    )),
              ],
            ),
            content: SizedBox(
              width: 300,
              child: TextFormField(
                scrollPadding: const EdgeInsets.all(5),
                maxLength: 500,
                maxLengthEnforcement: MaxLengthEnforcement.enforced,
                controller: desController,
                maxLines: 5,
                style: const TextStyle(
                  color: Colors.black,
                ),
                keyboardType: TextInputType.text,
                cursorColor: const Color(0xFF2fe48d),
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                    const BorderSide(color: Color(0xFF2fe48d), width: 2.0),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),
            actions: [
              Row(
                children: [
                  MaterialButton(
                    onPressed: () {
                      cubit.deleteData(id: model['id']);
                      AwesomeNotifications().cancel(model['notify']);
                      return Navigator.pop(context);
                    },
                    color: const Color(0xFF2fe48d),
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: const Text('Delete the task',style: TextStyle(color: Colors.black),),
                  ),
                  const Spacer(),
                  MaterialButton(
                    onPressed: () {
                      cubit.updateDescription(
                        id: model['id'],
                        description: desController.text,
                      ).then((value) {
                        showToast(text: 'Updated successfully', state: ToastStates.success);
                      });
                      return cubit.refreshApp();
                    },
                    color: const Color(0xFF2fe48d),
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: const Text('Update description',style: TextStyle(color: Colors.black,),),
                  ),
                ],
              ),
            ],
          );
        },
      ).then((value) => cubit.refreshApp());
    },
  child: Dismissible(
    key: Key(model['id'].toString()),
    child: Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        width: double.infinity,
        child: Row(
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: Color(0xFF2fe48d),
              ),
              child: Center(child: Text(
                '${model['time']}',
                style: TextStyle(fontFamily: 'NoyhR',fontSize: 17.0,),
              ),
              ),
            ),
            SizedBox(
              width: 15.0,
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${model['title']}',
                    maxLines: 1,
                    style: TextStyle(
                      overflow: TextOverflow.ellipsis,
                      decoration: TextDecoration.lineThrough,
                      decorationStyle: TextDecorationStyle.wavy,
                      decorationColor: Color(0xFF2fe48d),
                      decorationThickness: 3.0,
                      fontFamily: 'NoyhR',
                      color: Colors.white,
                      fontSize: 23.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${model['date']}',
                    style: TextStyle(
                      fontFamily: 'NoyhR',
                      fontSize: 15.0,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: ()
              {
                AppCubit.get(context).updateData(
                  id: model['id'],
                  status: 'new',
                );
              },
              icon:  Icon(
                Icons.check_box,
                color: Colors.green,
              ),
            ),
          ],
        ),
      ),
    ),
    onDismissed: (direction)
    {
      AppCubit.get(context).deleteData(id: model['id'],);
      AwesomeNotifications().cancel(model['notify']);
    },
  ),
);
}
Widget buildArchivedTaskItem(Map model, context) {
  AppCubit cubit = AppCubit.get(context);
  var desController = TextEditingController(text: '${model['description']}');
  return InkWell(
    onTap: (){
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            contentPadding: const EdgeInsets.all(10),
            titlePadding: const EdgeInsets.all(10),
            actionsPadding: const EdgeInsets.all(10),

            scrollable: true,
            title: Row(
              children: [
                SizedBox(
                  width: 230,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('${model['title']}',maxLines: 1,style: const TextStyle(overflow: TextOverflow.ellipsis,),),
                  ),
                ),
                const Spacer(),
                IconButton(
                    onPressed: () {
                      cubit.refreshApp();
                      return Navigator.pop(context);
                    },
                    icon: const Icon(
                      size: 30,
                      Icons.highlight_remove,
                      color: Color(0xFF2fe48d),
                    )),
              ],
            ),
            content: SizedBox(
              width: 300,
              child: TextFormField(
                scrollPadding: const EdgeInsets.all(5),
                maxLength: 500,
                maxLengthEnforcement: MaxLengthEnforcement.enforced,
                controller: desController,
                maxLines: 5,
                style: const TextStyle(
                  color: Colors.black,
                ),
                keyboardType: TextInputType.text,
                cursorColor: const Color(0xFF2fe48d),
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                    const BorderSide(color: Color(0xFF2fe48d), width: 2.0),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),
            actions: [
              Row(
                children: [
                  MaterialButton(
                    onPressed: () {
                      cubit.deleteData(id: model['id']);
                      AwesomeNotifications().cancel(model['notify']);
                      return Navigator.pop(context);
                    },
                    color: const Color(0xFF2fe48d),
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: const Text('Delete the task',style: TextStyle(color: Colors.black),),
                  ),
                  const Spacer(),
                  MaterialButton(
                    onPressed: () {
                      cubit.updateDescription(
                        id: model['id'],
                        description: desController.text,
                      ).then((value) {
                        showToast(text: 'Updated successfully', state: ToastStates.success);
                      });
                      return cubit.refreshApp();
                    },
                    color: const Color(0xFF2fe48d),
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: const Text('Update description',style: TextStyle(color: Colors.black,),),
                  ),
                ],
              ),
            ],
          );
        },
      ).then((value) => cubit.refreshApp());
    },
    child: Dismissible(
      key: Key(model['id'].toString()),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Container(
          width: double.infinity,
          child: Row(
            children: [
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: Color(0xFF2fe48d),
                ),
                child: Center(child: Text(
                  '${model['time']}',
                  style: TextStyle(fontFamily: 'NoyhR',fontSize: 17.0,),
                ),
                ),
              ),
              SizedBox(
                width: 15.0,
              ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${model['title']}',
                      maxLines: 1,
                      style: TextStyle(
                        overflow: TextOverflow.ellipsis,
                        fontFamily: 'NoyhR',
                        color: Colors.white,
                        fontSize: 23.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${model['date']}',
                      style: TextStyle(
                        fontFamily: 'NoyhR',
                        fontSize: 15.0,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: ()
                {
                  AppCubit.get(context).updateData(
                    id: model['id'],
                    status: 'done',
                  );
                },
                icon:  Icon(
                  Icons.check_box_outline_blank ,
                  color: Colors.green,
                ),
              ),
              IconButton(
                onPressed: ()
                {
                  AppCubit.get(context).updateData(
                      id: model['id'],
                      status: 'new'
                  );
                },
                icon: Icon(
                  Icons.arrow_circle_left_outlined,
                  color: Color(0xFF2fe48d),
                ),
              ),
            ],
          ),
        ),
      ),
      onDismissed: (direction)
      {
        AppCubit.get(context).deleteData(id: model['id'],);
        AwesomeNotifications().cancel(model['notify']);
      },
    ),
  );
}
void navigatTo(context, widget) =>
    Navigator.push(context, MaterialPageRoute(builder: (context) => widget));

void showToast({
  required String text,
  required ToastStates state,
}) => Fluttertoast.showToast(
  msg: text,
  toastLength: Toast.LENGTH_LONG,
  gravity: ToastGravity.BOTTOM,
  timeInSecForIosWeb: 5,
  backgroundColor: chooseToastClr(state),
  textColor: Colors.white,
  fontSize: 16.0,
);

enum ToastStates {success, error, warning}

Color chooseToastClr(ToastStates state)
{
  Color color;
  switch(state)
  {
    case ToastStates.success:
      color = Colors.green;
      break;
    case ToastStates.error:
      color = Colors.red;
      break;
    case ToastStates.warning:
      color = Colors.yellow;
      break;
  }
  return color;
}