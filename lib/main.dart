import 'package:flutter/material.dart';
import 'package:game_app/router/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

Future<void> fetchData() async {
  final prefs = await SharedPreferences.getInstance();
  final response = await http.get(Uri.parse('https://lst.waysapp.com/api/app'));
  if (response.statusCode == 200) {
    prefs.setString("api_sections", response.body);
  } else {
    print('Error: ${response.statusCode}');
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await fetchData();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
      ),
      initialRoute: "/",
      routes: appRoutes,
    );
  }
}
