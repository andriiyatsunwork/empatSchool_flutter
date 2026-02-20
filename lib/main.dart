/*
 * @author Andrii Yatsun
 */

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/app_provider.dart';
import 'screens/main_profile_page.dart';
/**
 * ROOT Widget that controls application theme.
 */
void main() {
  runApp(
    // Підключаємо наше "сховище" до всього додатку
    ChangeNotifierProvider(
      create: (context) => AppProvider(),
      child: const InstagramProfileApp(),
    ),
  );
}

class InstagramProfileApp extends StatelessWidget {
  const InstagramProfileApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Consumer слухає AppProvider. Коли тема змінюється, він перемальовує MaterialApp
    return Consumer<AppProvider>(
      builder: (context, provider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            brightness: provider.isDarkMode ? Brightness.dark : Brightness.light,
            primaryColor: provider.isDarkMode ? Colors.black : Colors.white,
            scaffoldBackgroundColor: provider.isDarkMode ? Colors.black : Colors.white,
            appBarTheme: AppBarTheme(
              backgroundColor: provider.isDarkMode ? Colors.black : Colors.white,
              foregroundColor: provider.isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          home: const MainProfilePage(),
        );
      },
    );
  }
}