import 'package:flutter/material.dart';
import 'package:train_away/screens/confirmacion_reserva/confirmacion_reserva.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ConfirmacionReserva(
        origen: 'Estación norte de Madrid',
        destino: 'Estación sur de Barcelona',
        numeroPasajeros: 1,
        categoria: '1ª clase',
        opcionesViaje: [
          'Sin equipaje',
          'Con servicio restaurante',
          'Coche cama',
        ],
        fechaHoraViajeMs: DateTime(2026, 11, 20, 9, 30).millisecondsSinceEpoch,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
