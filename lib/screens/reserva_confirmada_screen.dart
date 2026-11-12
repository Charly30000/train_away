import 'package:flutter/material.dart';

class ReservaConfirmadaScreen extends StatelessWidget {
  const ReservaConfirmadaScreen({
    super.key,
    this.origen = 'Madrid',
    this.destino = 'Barcelona',
    this.fecha = '20 nov 2026',
    this.hora = '09:30',
    this.pasajeros = 1,
    this.categoria = '1ª Clase',
    this.onFinish,
  });

  static const routeName = '/reserva-confirmada';

  static const _navy = Color(0xFF294858);
  static const _green = Color(0xFF188D70);
  static const _teal = Color(0xFF35AC9D);
  static const _muted = Color(0xFF60747F);
  static const _cardBackground = Color(0xFFF2F8F7);

  final String origen;
  final String destino;
  final String fecha;
  final String hora;
  final int pasajeros;
  final String categoria;
  final VoidCallback? onFinish;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const _TrainAwayHeader(),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(28, 28, 28, 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const Text(
                                'Reserva confirmada',
                                style: TextStyle(
                                  color: _navy,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 10),
                              const Align(
                                alignment: Alignment.centerLeft,
                                child: SizedBox(
                                  width: 48,
                                  child: Divider(
                                    color: _teal,
                                    height: 3,
                                    thickness: 3,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 34),
                              const _SuccessMessage(),
                              const SizedBox(height: 34),
                              _ReservationSummary(
                                origen: origen,
                                destino: destino,
                                fecha: fecha,
                                hora: hora,
                                pasajeros: pasajeros,
                                categoria: categoria,
                              ),
                              const SizedBox(height: 28),
                              const Text(
                                'Puedes cerrar esta pantalla con tranquilidad.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: _muted,
                                  fontSize: 13,
                                ),
                              ),
                              const Spacer(),
                              const SizedBox(height: 32),
                              SizedBox(
                                height: 56,
                                child: FilledButton(
                                  onPressed: () {
                                    if (onFinish != null) {
                                      onFinish!();
                                      return;
                                    }

                                    Navigator.of(context).popUntil(
                                      (route) => route.isFirst,
                                    );
                                  },
                                  style: FilledButton.styleFrom(
                                    backgroundColor: _green,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: const Text(
                                    'FINALIZAR',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _TrainAwayHeader extends StatelessWidget {
  const _TrainAwayHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 84,
      padding: const EdgeInsets.symmetric(horizontal: 28),
      alignment: Alignment.centerLeft,
      decoration: const BoxDecoration(
        color: ReservaConfirmadaScreen._navy,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(4)),
      ),
      child: const Text(
        'Train Away',
        style: TextStyle(
          color: Colors.white,
          fontSize: 23,
          fontWeight: FontWeight.w700,
          letterSpacing: 2.8,
        ),
      ),
    );
  }
}

class _SuccessMessage extends StatelessWidget {
  const _SuccessMessage();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 132,
          height: 132,
          decoration: const BoxDecoration(
            color: Color(0xFFE6F4F1),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.check_rounded,
            size: 82,
            color: ReservaConfirmadaScreen._green,
          ),
        ),
        const SizedBox(height: 22),
        const Text(
          '¡Viaje reservado!',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: ReservaConfirmadaScreen._navy,
            fontSize: 26,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'Tu reserva se ha realizado correctamente.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: ReservaConfirmadaScreen._muted,
            fontSize: 15,
          ),
        ),
      ],
    );
  }
}

class _ReservationSummary extends StatelessWidget {
  const _ReservationSummary({
    required this.origen,
    required this.destino,
    required this.fecha,
    required this.hora,
    required this.pasajeros,
    required this.categoria,
  });

  final String origen;
  final String destino;
  final String fecha;
  final String hora;
  final int pasajeros;
  final String categoria;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: ReservaConfirmadaScreen._cardBackground,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFD7E8E4)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14173445),
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'RESUMEN DE LA RESERVA',
              style: TextStyle(
                color: ReservaConfirmadaScreen._muted,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.6,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Text(
                    origen,
                    style: const TextStyle(
                      color: ReservaConfirmadaScreen._navy,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_rounded,
                  color: ReservaConfirmadaScreen._teal,
                  size: 28,
                ),
                Expanded(
                  child: Text(
                    destino,
                    textAlign: TextAlign.end,
                    style: const TextStyle(
                      color: ReservaConfirmadaScreen._navy,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 30, color: Color(0xFFD2E1DF)),
            _SummaryRow(label: 'Fecha y hora', value: '$fecha · $hora'),
            const SizedBox(height: 18),
            _SummaryRow(
              label: 'Pasajeros',
              value: pasajeros == 1 ? '1 pasajero' : '$pasajeros pasajeros',
            ),
            const SizedBox(height: 18),
            _SummaryRow(label: 'Categoría', value: categoria),
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              color: ReservaConfirmadaScreen._muted,
              fontSize: 12,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: const TextStyle(
              color: ReservaConfirmadaScreen._navy,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}
