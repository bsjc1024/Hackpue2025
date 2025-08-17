import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  State<MyApp> createState() => _MyAppState();

}

class _MyAppState extends State<MyApp> {
  String serverMessage = "Waiting for server response...";

  Future<void> fetchMessage() async {
    final url = Uri.parse("http://localhost:3000/");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        serverMessage = data['message'];
      });
    } else {
      setState(() {
        serverMessage = "Error: ${response.statusCode}";
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchMessage();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text("Flutter + Node.js Example")),
        body: Center(child: Text(serverMessage)),
      ),
    );
  }
}

