import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:task_list/data/data.dart';
import 'package:task_list/data/repo/repository.dart';
import 'package:task_list/data/source/hive_task_source.dart';
import 'package:task_list/screens/home/bloc/home_bloc.dart';

import 'package:task_list/screens/home/home.dart';

const taskBoxName = 'task';
void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(TaskAdapter());
  Hive.registerAdapter(PriorityAdapter());
  await Hive.openBox<Task>(taskBoxName);
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: primaryVariantColor));
  runApp(
    ChangeNotifierProvider<Repository<Task>>(
      create: (context) => Repository<Task>(
        HiveTaskDataSource(
          Hive.box(taskBoxName),
        ),
      ),
      child: const MyApp(),
    ),
  );
}

const Color primaryColor = Color(0xff794cff);
const Color primaryVariantColor = Color(0xff5c0aff);
const Color secondaryTextColor = Color(0xffafbed0);
const Color normalPriority = Color(0xfff09819);
const Color lowPriority = Color(0xff3be1f1);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryTextColor = Color(0xff1d2830);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(
          const TextTheme(
            headline6: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
            labelStyle: TextStyle(
              color: secondaryTextColor,
            ),
            iconColor: secondaryTextColor,
            border: InputBorder.none,
            floatingLabelBehavior: FloatingLabelBehavior.never),
        colorScheme: const ColorScheme.light(
            primary: primaryColor,
            onPrimary: Colors.white,
            primaryVariant: primaryVariantColor,
            background: Color(0xfff3f5f8),
            onSurface: primaryTextColor,
            onBackground: primaryTextColor,
            secondary: primaryColor,
            onSecondary: Colors.white),
      ),
      home: BlocProvider(
        create: (context) => HomeBloc(context.read<Repository<Task>>()),
        child: HomeScreen(),
      ),
    );
  }
}
