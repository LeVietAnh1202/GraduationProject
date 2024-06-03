import 'package:flutter/material.dart';
import 'package:flutter_todo_app/dashboard.dart';
import 'package:flutter_todo_app/provider/account.dart';
import 'package:flutter_todo_app/provider/appState.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'loginPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  runApp(MyApp(
    token: prefs.getString('token'),
  ));
}

class MyApp extends StatefulWidget {
  final token;
  
  const MyApp({
    @required this.token,
    Key? key,
  }) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AccountProvider>(
            create: (_) => AccountProvider()),
        ChangeNotifierProvider<AppStateProvider>(
            create: (_) => AppStateProvider())
      ],
      child: MaterialApp(
          title: 'Attendance student using facial recognition',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primaryColor: Colors.black,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            // colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue)
          ),
          home: (widget.token != null &&
                  JwtDecoder.isExpired(widget.token) == false)
              ? Dashboard(token: widget.token)
              : SignInPage()),
    );
  }
}
