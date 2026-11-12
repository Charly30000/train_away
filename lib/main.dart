import 'package:flutter/material.dart';
import 'package:train_away/screens/confirmation-dialog/confirmation-dialog.dart';

void main() {
  runApp(const MainApp());
}

void _showConfirmationDialog(BuildContext context) {
  showDialog(
      context: context,
      builder: (context) =>
      const ConfirmationDialog(
          title: 'Vas a confirmar tu reserva',
          message: 'Una vez confirmada no podrá ser anulada. ¿Confirmas la reserva?'
      )
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen()
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
    Widget build(BuildContext context) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Hello World!'),
              FilledButton(onPressed: () => _showConfirmationDialog(context), child: Text('Mostrar modal'))
            ],
          ),
        ),
        backgroundColor: Colors.amber
      );
    }
}

