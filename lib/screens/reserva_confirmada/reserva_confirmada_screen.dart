import 'package:flutter/material.dart';
import 'package:train_away/widgets/boton_inferior.dart';
import 'package:train_away/widgets/header.dart';

class ReservaConfirmadaScreen extends StatelessWidget {
  const ReservaConfirmadaScreen({
    super.key,
    required this.origen,
    required this.destino,
    required this.pasajeros,
    required this.fecha,
    required this.hora,
    required this.categoria,
    required this.opcionesViaje,
    this.onFinish,
  });

  static const routeName = '/reserva-confirmada';

  static const _azul = Color(0xFF2A4252);
  static const _verde = Color(0xFF188D70);
  static const _textoSecundario = Color(0xFF60747F);
  static const _fondoTarjeta = Color(0xFFF2F8F7);

  final String origen;
  final String destino;
  final int pasajeros;
  final String fecha;
  final String hora;
  final String categoria;
  final List<String> opcionesViaje;
  final VoidCallback? onFinish;

  void _finalizar(BuildContext context) {
    if (onFinish != null) {
      onFinish!();
      return;
    }
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const Header(),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
                child: Column(
                  children: [
                    Container(
                      width: 112,
                      height: 112,
                      decoration: const BoxDecoration(
                        color: Color(0xFFE6F4F1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check_rounded,
                        size: 72,
                        color: _verde,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      '¡Reserva confirmada!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: _azul,
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Tu reserva se ha realizado correctamente.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: _textoSecundario,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 28),
                    _ResumenReserva(
                      origen: origen,
                      destino: destino,
                      pasajeros: pasajeros,
                      fecha: fecha,
                      hora: hora,
                      categoria: categoria,
                      opcionesViaje: opcionesViaje,
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Color(0xFFE0E0E0))),
              ),
              child: Center(
                child: SizedBox(
                  width: 192,
                  child: BotonInferior(
                    texto: 'Finalizar',
                    onPressed: () => _finalizar(context),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ResumenReserva extends StatelessWidget {
  const _ResumenReserva({
    required this.origen,
    required this.destino,
    required this.pasajeros,
    required this.fecha,
    required this.hora,
    required this.categoria,
    required this.opcionesViaje,
  });

  final String origen;
  final String destino;
  final int pasajeros;
  final String fecha;
  final String hora;
  final String categoria;
  final List<String> opcionesViaje;

  @override
  Widget build(BuildContext context) {
    final opciones = opcionesViaje.isEmpty
        ? 'Sin opciones adicionales'
        : opcionesViaje.join(', ');

    return DecoratedBox(
      decoration: BoxDecoration(
        color: ReservaConfirmadaScreen._fondoTarjeta,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFD7E8E4)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'RESUMEN DE LA RESERVA',
              style: TextStyle(
                color: ReservaConfirmadaScreen._textoSecundario,
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: Text(
                    origen,
                    style: const TextStyle(
                      color: ReservaConfirmadaScreen._azul,
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Icon(
                    Icons.arrow_forward_rounded,
                    color: ReservaConfirmadaScreen._verde,
                  ),
                ),
                Expanded(
                  child: Text(
                    destino,
                    textAlign: TextAlign.end,
                    style: const TextStyle(
                      color: ReservaConfirmadaScreen._azul,
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 30, color: Color(0xFFD2E1DF)),
            _FilaResumen(etiqueta: 'Fecha y hora', valor: '$fecha · $hora'),
            const SizedBox(height: 16),
            _FilaResumen(
              etiqueta: 'Pasajeros',
              valor: pasajeros == 1 ? '1 pasajero' : '$pasajeros pasajeros',
            ),
            const SizedBox(height: 16),
            _FilaResumen(etiqueta: 'Categoría', valor: categoria),
            const SizedBox(height: 16),
            _FilaResumen(etiqueta: 'Opciones de viaje', valor: opciones),
          ],
        ),
      ),
    );
  }
}

class _FilaResumen extends StatelessWidget {
  const _FilaResumen({required this.etiqueta, required this.valor});

  final String etiqueta;
  final String valor;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            etiqueta,
            style: const TextStyle(
              color: ReservaConfirmadaScreen._textoSecundario,
              fontSize: 12,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Flexible(
          child: Text(
            valor,
            textAlign: TextAlign.end,
            style: const TextStyle(
              color: ReservaConfirmadaScreen._azul,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}
