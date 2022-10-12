import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:RecetApp/screens/screens.dart';
import 'package:RecetApp/services/services.dart';

void main() => runApp(const AppState());

class AppState extends StatelessWidget {
  const AppState({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => RecepiesService()),
        ChangeNotifierProvider(create: (_) => RecepiesService()),
        ChangeNotifierProvider(create: (_) => FollowService()),
        ChangeNotifierProvider(create: (_) => UserService()),
      ],
      child: MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recetas app',
      debugShowCheckedModeBanner: false,
      initialRoute: 'checking',
      routes: {
        'checking': (_) => CheckAuthScreen(),
        'home': (_) => HomeScreen(),
        'myRecepies': (_) => MyRecepiesScreen(),
        'recepie': (_) => RecepieEditScreen(),
        'readRecepie': (_) => ReadRecepieScreen(),
        'login': (_) => LoginScreen(),
        'register': (_) => RegisterScreen(),
        'profile': (_) => ProfileScreen(),
        'messages': (_) => ListMessagesScreen(),
      },
      scaffoldMessengerKey: NotificationService.messengerKey,
      theme: ThemeData.light().copyWith(
          scaffoldBackgroundColor: Colors.grey[300],
          appBarTheme: AppBarTheme(
            elevation: 0,
            color: Colors.indigo,
          ),
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: Colors.indigo,
            elevation: 0,
          )),
    );
  }
}
