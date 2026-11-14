import 'package:flutter/material.dart';
import 'package:train_away/constants/constants.dart';
import 'package:train_away/screens/confirmation-dialog/confirmation-dialog.dart';
import 'package:train_away/screens/confirmacion_reserva/widgets/dato_reserva.dart';
import 'package:train_away/widgets/boton_intefrior.dart';
import 'package:train_away/widgets/header.dart';

class ConfirmacionReserva extends StatelessWidget {
  const ConfirmacionReserva({
    super.key,
    required this.origen,
    required this.destino,
    required this.numeroPasajeros,
    required this.categoria,
    required this.opcionesViaje,
    required this.fechaHoraViajeMs,
  });

  final String origen;
  final String destino;
  final int numeroPasajeros;
  final String categoria;
  final List<String> opcionesViaje;

  final int fechaHoraViajeMs;

  Future<void> _confirmarReserva(BuildContext context) async {
    final confirmado = await showDialog<bool>(
      context: context,
      builder: (context) => const ConfirmationDialog(
        title: 'Confirmar reserva',
        message: '¿Quieres confirmar la reserva de tu viaje?',
      ),
    );

    if (confirmado == true) {
      _realizarReserva();
    }
  }

  void _realizarReserva() {
    // TODO: Implementar la logica para realizar la reserva del viaje.
  }

  String _formatearFecha(DateTime fecha) {
    return '${dias[fecha.weekday - 1]}, ${fecha.day} de '
        '${meses[fecha.month - 1]} de ${fecha.year}';
  }

  @override
  Widget build(BuildContext context) {
    final fechaHora = DateTime.fromMillisecondsSinceEpoch(fechaHoraViajeMs);
    final fechaViaje = _formatearFecha(fechaHora);
    final horaViaje =
        '${fechaHora.hour.toString().padLeft(2, '0')}:'
        '${fechaHora.minute.toString().padLeft(2, '0')}';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const Header(),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(15, 20, 15, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: 16,
                  children: [
                    DatoReserva(titulo: 'Origen', elementos: [origen]),
                    DatoReserva(titulo: 'Destino', elementos: [destino]),
                    DatoReserva(
                      titulo: 'Número de pasajeros',
                      elementos: [numeroPasajeros.toString()],
                    ),
                    DatoReserva(titulo: 'Categoría', elementos: [categoria]),
                    DatoReserva(
                      titulo: 'Opciones de viaje',
                      elementos: opcionesViaje,
                    ),
                    DatoReserva(
                      titulo: 'Fecha del viaje',
                      elementos: [fechaViaje, horaViaje],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: BotonInferior(
                texto: 'Confirmar',
                onPressed: () => _confirmarReserva(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
