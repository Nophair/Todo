import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo_list/shared/cubit/cubit.dart';
import 'package:todo_list/shared/cubit/states.dart';
import 'package:todo_list/shared/notification_services.dart';

class HomeLayout extends StatefulWidget
{

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  @override
  void initState() {
    AwesomeNotifications().setListeners(
      onActionReceivedMethod: NotificationService.onActionReceivedMethod,
      onNotificationDisplayedMethod: NotificationService.onNotificationDisplayedMethod,
      onDismissActionReceivedMethod: NotificationService.onDismissActionReceivedMethod,
      onNotificationCreatedMethod: NotificationService.onNotificationCreatedMethod,
    );
    super.initState();
  }
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();
  String? notifyTitle = '';
  String? notifyTime = '';
  String? notifyDate = '';
  int id = 0;
  late DateTime sD;
  late TimeOfDay sT;

  DateTime mergeDateAndTime(DateTime sD, TimeOfDay sT) {
    return DateTime(
      sD.year,
      sD.month,
      sD.day,
      sT.hour,
      sT.minute,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (BuildContext context, AppStates state){
          if(state is AppInsertDatabaseState)
          {
           Navigator.pop(context);
          }
        },
        builder: (BuildContext context, AppStates state)
        {
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
            backgroundColor: Colors.black,
            key: scaffoldKey,
            appBar: AppBar(
              backgroundColor: Colors.black,
              title: Center(
                child: Text(
                  cubit.titles[cubit.currentIndex],
                  style: TextStyle(
                    fontFamily: 'Havre',
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            body: ConditionalBuilder(
              condition: state is! AppGetDatabaseLoadingState,
              builder: (context) => cubit.screens[cubit.currentIndex],
              fallback: (context) => Center(child: CircularProgressIndicator()),
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: Color(0xFF2fe48d),
              onPressed: () {
                if (cubit.isBottomSheetShown)
                {
                  if (formKey.currentState!.validate()) {
                    notifyTitle = titleController.text;
                    notifyDate = dateController.text;
                    notifyTime = timeController.text;
                    cubit.insertToDatabase(
                        title: titleController.text,
                        time: timeController.text,
                        date: dateController.text,
                        notify: id,
                    ).then((value) {
                      AwesomeNotifications().createNotification(
                        content: NotificationContent(
                          id: id,
                          channelKey: 'high_importance_channel',
                          title: notifyTitle,
                          largeIcon: 'resource://drawable/tasks',
                          body: 'A reminder for this task was created on ${notifyDate} at ${notifyTime}.',
                        ),
                      ).then((value) {
                        AwesomeNotifications().createNotification(
                          content: NotificationContent(
                            id: id,
                            channelKey: 'schedule',
                            title: notifyTitle,
                            largeIcon: 'resource://drawable/tasks',
                            body: 'It\'s your task time, go and finish it 💪',
                            displayOnBackground: true,
                            displayOnForeground: true,
                          ),
                          schedule: NotificationCalendar(year: sD.year,month: sD.month,day: sD.day, hour: sT.hour,minute: sT.minute),
                        );
                        id += 1;
                      });
                    });
                    formKey.currentState?.reset();
                  }
                } else
                {
                  scaffoldKey.currentState!
                      .showBottomSheet(
                        (context) => Container(
                          decoration: BoxDecoration(
                            color: Color(0xFF2fe48d),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20.0),
                              topRight: Radius.circular(20.0),
                            ),
                          ),
                          padding: EdgeInsets.all(
                            10.0,
                          ),
                          child: Form(
                            key: formKey,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Color(0xFF2fe48d),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20.0),
                                  topRight: Radius.circular(20.0),
                                ),
                              ),
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextFormField(
                                      style: TextStyle(
                                        color: Colors.black,
                                      ),
                                      controller: titleController,
                                      keyboardType: TextInputType.text,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Title must not be empty';
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(20.0),
                                            borderSide: BorderSide(color: Colors.black,)
                                        ),
                                        labelText: 'Task Title',
                                        labelStyle: TextStyle(
                                          fontFamily: 'NoyhR',
                                          fontSize: 20.0,
                                          color: Colors.black45,
                                        ),
                                        prefixIcon: Icon(
                                          Icons.title,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 15.0,
                                    ),
                                    TextFormField(
                                      controller: timeController,
                                      keyboardType: TextInputType.none,
                                      onTap: () {
                                        showTimePicker(
                                          context: context,
                                          initialTime: TimeOfDay.now(),
                                        ).then((value) {
                                          sT = value!;
                                          timeController.text =
                                              value.format(context).toString();
                                        });
                                      },
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Time must not be empty';
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(20.0),
                                            borderSide: BorderSide(color: Colors.black,)
                                        ),
                                        labelText: 'Task Time',
                                        labelStyle: TextStyle(
                                          fontFamily: 'NoyhR',
                                          fontSize: 20.0,
                                          color: Colors.black45,
                                        ),
                                        prefixIcon: Icon(
                                          Icons.watch_later_outlined,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 15.0,
                                    ),
                                    TextFormField(
                                      controller: dateController,
                                      keyboardType: TextInputType.none,
                                      onTap: () {
                                        showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          lastDate: DateTime.parse('2050-12-31'),
                                          firstDate: DateTime.now(),
                                        ).then((value) {
                                          sD = value!;
                                          dateController.text =
                                              DateFormat.yMMMd().format(value);
                                        });
                                      },
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Date must not be empty';
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(20.0),
                                            borderSide: BorderSide(color: Colors.black,)
                                        ),
                                        labelText: 'Task Date',
                                        labelStyle: TextStyle(
                                          fontFamily: 'NoyhR',
                                          fontSize: 20.0,
                                          color: Colors.black45,
                                        ),
                                        prefixIcon: Icon(
                                          Icons.calendar_month,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                      .closed
                      .then((value) {
                    cubit.changeBottomSheetState(
                      isShow: false,
                      icon: Icons.edit,
                    );
                    formKey.currentState?.reset();
                  });
                  cubit.changeBottomSheetState(
                    isShow: true,
                      icon: Icons.add,
                  );
                }
              },
              child: Icon(
                cubit.fabIcon,
                color: Colors.black,
              ),
            ),
            bottomNavigationBar: Theme(
              data: ThemeData(
                splashColor: Colors.green,
                highlightColor: Colors.transparent,
              ),
              child: BottomNavigationBar(
                unselectedLabelStyle: TextStyle(fontFamily: 'NoyhR',fontSize: 13.0,),
                selectedLabelStyle: TextStyle(fontFamily: 'NoyhR',fontSize: 15.0,),
                fixedColor: Colors.black,
                backgroundColor: Color(0xFF2fe48d),
                type: BottomNavigationBarType.fixed,
                currentIndex: cubit.currentIndex,
                onTap: (index)
                {
                  cubit.changeIndex(index);
                },
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.menu,
                      color: Colors.black,
                    ),
                    label: 'Tasks',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.check_circle_outline,
                      color: Colors.black,
                    ),
                    label: 'Done',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.archive_outlined,
                      color: Colors.black,
                    ),
                    label: 'Archive',
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
