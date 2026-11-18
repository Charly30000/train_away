import 'package:flutter/material.dart';
import 'package:train_away/screens/confirmacion_reserva/confirmacion_reserva.dart';
import 'package:train_away/screens/fecha_reserva/fecha_reserva_screen.dart';
import 'package:train_away/screens/formulario_reserva/formulario_reserva.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  void _mostrarFechaReserva(
    BuildContext context,
    DatosFormularioReserva datos,
  ) {
    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (context) => FechaReservaScreen(
          origen: datos.origen,
          destino: datos.destino,
          onContinuar: (fechaHora) =>
              _mostrarConfirmacion(context, datos, fechaHora),
        ),
      ),
    );
  }

  void _mostrarConfirmacion(
    BuildContext context,
    DatosFormularioReserva datos,
    DateTime fechaHora,
  ) {
    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => ConfirmacionReserva(
          origen: datos.origen,
          destino: datos.destino,
          numeroPasajeros: datos.numeroPasajeros,
          categoria: datos.categoria,
          opcionesViaje: datos.opcionesViaje,
          fechaHoraViajeMs: fechaHora.millisecondsSinceEpoch,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Builder(
        builder: (context) => FormularioReserva(
          onReservar: (datos) => _mostrarFechaReserva(context, datos),
        ),
      ),
    );
  }
}
