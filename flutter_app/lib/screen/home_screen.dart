import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bum Soo Jang"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/espanol');
              },
              child: Container(
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.blue[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Español", style: TextStyle(fontSize: 18)),
                    Text("-1%", style: TextStyle(fontSize: 18)),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/biologia');
              },
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.green[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Biología", style: TextStyle(fontSize: 18)),
                    Text("-1%", style: TextStyle(fontSize: 18)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
