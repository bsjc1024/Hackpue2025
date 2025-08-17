import 'package:flutter/material.dart';

class EspanolScreen extends StatelessWidget {
  const EspanolScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Plan de estudio - Español")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Table(
          columnWidths: const {
            0: FlexColumnWidth(2),
            1: FlexColumnWidth(1),
          },
          children: const [
            TableRow(children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Temas", style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Horas por semana", style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ]),
            TableRow(children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Lectura y comprensión"),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("5"),
              ),
            ]),
            TableRow(children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Gramática y ortografía"),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("4"),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}
