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

  Future<void> sendData() async {
    final url = Uri.parse("http://localhost:3000/data");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"nombre": "Luis", "edad": 30}),
    );

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
    sendData();
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

