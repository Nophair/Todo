import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_list/modules/archived_tasks/archived_tasks_screen.dart';
import 'package:todo_list/modules/done_tasks/done_tasks_screen.dart';
import 'package:todo_list/modules/new_tasks/new_tasks_screen.dart';
import 'package:todo_list/shared/cubit/states.dart';

class AppCubit extends Cubit<AppStates>
{
  AppCubit() : super(AppInitialState());
  static AppCubit get(context) => BlocProvider.of(context);
  int currentIndex = 0;

  List<Widget> screens = [
    NewTasksScreen(),
    DoneTasksScreen(),
    ArchivedTasksScreen(),
  ];

  List<String> titles = [
    'NEW TASKS',
    'DONE TASKS',
    'ARCHIVED TASKS',
  ];
  void changeIndex(int index)
  {
    currentIndex = index;
    emit(AppChangeBottomNavBarState());
  }

  Database? database;
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];

  void createDatabase()
  {
    openDatabase(
      'todo.db',
      version: 1,
      onCreate: (database, version) {
        print('database created');
        database
            .execute(
            'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT,description TEXT, notify INTEGER)')
            .then((value) {
          print('table created');
        }).catchError((error) {
          print('Error When Creating Table ${error.toString()}');
        });
      },
      onOpen: (database) {
        getDataFromDatabase(database);
        print('database opened');
      },
    ).then((value)
    {
      database = value;
      emit(AppCreateDatabaseState());
    });
  }

  Future<void>insertToDatabase({
    required String title,
    required String time,
    required String date,
    required String description,
    required int notify,
  }) async {
    await database?.transaction((txn) => txn.rawInsert(
                'INSERT INTO tasks(title, date, time, status,description, notify) VALUES("$title", "$date", "$time", "new","$description", "$notify")').then((value)
        {
          print('$value inserted successfully');
          emit(AppInsertDatabaseState());
          getDataFromDatabase(database);
        }).catchError((error)
        {
          print('Error When Inserting New Record ${error.toString()}');
        }));
  }

  void updateData({
    required String status,
    required int id,
}) async
  {
    database!.rawUpdate(
        'UPDATE tasks SET status = ? WHERE id = ?',
        ['$status', id],
    ).then((value)
    {
      getDataFromDatabase(database);
      emit(AppUpdateDatabaseState());
    });
  }

  Future<void> updateDescription({
    required String? description,
    required int id,
  }) async {
    database!.rawUpdate(
      'UPDATE tasks SET description = ? WHERE id = ?',
      [description, id],
    ).then((value) {
      getDataFromDatabase(database);
      emit(AppUpdateDesState());
    });
  }

  Future<void> deleteData({
    required int id,
  }) async
  {
    database?.rawDelete(
      'DELETE FROM Tasks WHERE id = ?', [id])
        .then((value)
    {
      getDataFromDatabase(database);
      emit(AppDeleteDatabaseState());
    });
  }

  void getDataFromDatabase(database)
  {
    newTasks = [];
    doneTasks = [];
    archivedTasks = [];

    emit(AppGetDatabaseLoadingState());
    database!.rawQuery('SELECT * FROM tasks').then((value) {

      value.forEach((element)
      {
        if(element['status'] == 'new')
          newTasks.add(element);
        else if(element['status'] == 'done')
          doneTasks.add(element);
        else archivedTasks.add(element);
      });
      emit(AppGetDatabaseState());
    });
  }

  bool isBottomSheetShown = false;
  IconData fabIcon = Icons.edit;
  void changeBottomSheetState({
    required bool isShow,
    required IconData icon,
  })
  {
    isBottomSheetShown = isShow;
    fabIcon = icon;
    emit(AppChangeBottomSheetState());
  }

  void refreshApp() {
    emit(AppGetRefreshState());
  }
}

