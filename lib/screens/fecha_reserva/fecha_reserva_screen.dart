import 'dart:ui' show PointMode;

import 'package:flutter/material.dart';
import 'package:train_away/screens/fecha_reserva/elementos_fecha_reserva.dart';
import 'package:train_away/widgets/header.dart';

const _azul = Color(0xFF2A4252);
const _secundario = Color(0xFF586D79);
const _contorno = Color(0xFFCFD9DF);
const _fondoSuave = Color(0xFFEDF4F7);
const _estilo = TextStyle(
  fontFamily: 'DMSans',
  color: _azul,
  fontSize: 16,
  fontWeight: FontWeight.w700,
  height: 1.2,
);
const _dias = [
  'Lunes',
  'Martes',
  'Miércoles',
  'Jueves',
  'Viernes',
  'Sábado',
  'Domingo',
];
const _meses = [
  'Enero',
  'Febrero',
  'Marzo',
  'Abril',
  'Mayo',
  'Junio',
  'Julio',
  'Agosto',
  'Septiembre',
  'Octubre',
  'Noviembre',
  'Diciembre',
];

String _fechaEnEspanol(DateTime fecha) {
  final mes = _meses[fecha.month - 1].toLowerCase();
  return '${_dias[fecha.weekday - 1]}, ${fecha.day} de $mes de ${fecha.year}';
}

String _formatearHora(TimeOfDay hora) {
  final horas = hora.hour.toString().padLeft(2, '0');
  final minutos = hora.minute.toString().padLeft(2, '0');
  return '$horas:$minutos';
}

class FechaReservaScreen extends StatefulWidget {
  const FechaReservaScreen({
    super.key,
    required this.origen,
    required this.destino,
    required this.onContinuar,
    this.fechaReferencia,
  });

  final String origen;
  final String destino;
  final ValueChanged<DateTime> onContinuar;

  /// Permite fijar el mes inicial de la vista previa.
  final DateTime? fechaReferencia;

  @override
  State<FechaReservaScreen> createState() => _FechaReservaScreenState();
}

class _FechaReservaScreenState extends State<FechaReservaScreen> {
  static const _horariosSimulados = [
    TimeOfDay(hour: 9, minute: 30),
    TimeOfDay(hour: 13, minute: 0),
    TimeOfDay(hour: 18, minute: 45),
  ];

  late final _referencia = DateUtils.dateOnly(
    widget.fechaReferencia ?? DateTime.now(),
  );
  late DateTime _mes = _referencia;
  DateTime? _dia;
  bool _horariosVisibles = false;
  TimeOfDay? _horaElegida;

  void _seleccionarDia(DateTime dia) {
    if (DateUtils.isSameDay(_dia, dia)) return;
    setState(() {
      _mes = dia;
      _dia = dia;
      _horaElegida = null;
      _horariosVisibles = false;
    });
  }

  Future<void> _mostrarCalendario() async {
    final fecha = await showDatePicker(
      context: context,
      initialDate: _dia,
      firstDate: DateTime(_referencia.year),
      lastDate: DateTime(_referencia.year + 2, 12, 31),
      helpText: 'Selecciona fecha',
      cancelText: 'Cancelar',
      confirmText: 'Aceptar',
    );
    if (mounted && fecha != null) _seleccionarDia(fecha);
  }

  @override
  Widget build(BuildContext context) {
    final dia = _dia;
    final hora = _horaElegida;
    final String etiquetaHora;
    if (hora != null) {
      etiquetaHora = _formatearHora(hora);
    } else if (dia == null) {
      etiquetaHora = 'Selecciona un día';
    } else {
      etiquetaHora = 'Selecciona una hora';
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const Header(),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1100),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 30, 15, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Fecha de salida',
                      style: _estilo.copyWith(fontSize: 24),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '${widget.origen} → ${widget.destino}',
                      style: _estilo.copyWith(
                        color: _secundario,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 32),
                    const Text('Selecciona fecha', style: _estilo),
                    const SizedBox(height: 11),
                    _Calendario(
                      mes: _mes,
                      seleccion: dia,
                      onFecha: _seleccionarDia,
                      onAbrir: _mostrarCalendario,
                    ),
                    const SizedBox(height: 16),
                    ConstrainedBox(
                      constraints: const BoxConstraints(minHeight: 22),
                      child: dia == null
                          ? const SizedBox.shrink()
                          : Row(
                              children: [
                                const CircleAvatar(
                                  radius: 10,
                                  backgroundColor: _fondoSuave,
                                  child: SizedBox.square(
                                    dimension: 12,
                                    child: CustomPaint(
                                      painter: _TrazoIcono([
                                        Offset(1.5, 6.5),
                                        Offset(4.8, 9.5),
                                        Offset(10.5, 3),
                                      ]),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    _fechaEnEspanol(dia),
                                    style: _estilo,
                                  ),
                                ),
                              ],
                            ),
                    ),
                    const SizedBox(height: 24),
                    const Text('Hora de salida', style: _estilo),
                    const SizedBox(height: 8),
                    _CampoHora(
                      etiqueta: etiquetaHora,
                      expandido: _horariosVisibles,
                      onPressed: dia == null
                          ? null
                          : () => setState(
                              () => _horariosVisibles = !_horariosVisibles,
                            ),
                    ),
                    if (_horariosVisibles) ...[
                      const SizedBox(height: 7),
                      Material(
                        color: _fondoSuave,
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(color: _contorno),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            for (final salida in _horariosSimulados) ...[
                              if (salida != _horariosSimulados.first)
                                const Divider(
                                  height: 1,
                                  thickness: 1,
                                  color: _contorno,
                                ),
                              InkWell(
                                onTap: () => setState(() {
                                  _horaElegida = salida;
                                  _horariosVisibles = false;
                                }),
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  constraints: const BoxConstraints(
                                    minHeight: 44,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                  ),
                                  child: Text(
                                    _formatearHora(salida),
                                    style: _estilo.copyWith(fontSize: 18),
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: PieFechaReserva(
        onContinuar: dia != null && hora != null
            ? () => widget.onContinuar(
                DateTime(dia.year, dia.month, dia.day, hora.hour, hora.minute),
              )
            : null,
      ),
    );
  }
}

class _CampoHora extends StatelessWidget {
  const _CampoHora({
    required this.etiqueta,
    required this.expandido,
    required this.onPressed,
  });

  final String etiqueta;
  final bool expandido;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      enabled: onPressed != null,
      expanded: expandido,
      child: Material(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: _azul, width: 2.5),
          borderRadius: BorderRadius.circular(10),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          child: Container(
            constraints: const BoxConstraints(minHeight: 42),
            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
            child: Row(
              children: [
                Expanded(
                  child: Text(etiqueta, style: _estilo.copyWith(fontSize: 18)),
                ),
                const SizedBox(
                  width: 18,
                  height: 10,
                  child: CustomPaint(
                    painter: _TrazoIcono([
                      Offset(1, 1),
                      Offset(9, 9),
                      Offset(17, 1),
                    ]),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Calendario extends StatelessWidget {
  const _Calendario({
    required this.mes,
    required this.seleccion,
    required this.onFecha,
    required this.onAbrir,
  });

  final DateTime mes;
  final DateTime? seleccion;
  final ValueChanged<DateTime> onFecha;
  final VoidCallback onAbrir;

  @override
  Widget build(BuildContext context) {
    const iniciales = ['L', 'M', 'X', 'J', 'V', 'S', 'D'];
    const margenInterior = 23.0;
    const anchoBoton = 44.0;
    const tamanoIcono = 22.0;
    const margenDelBoton = margenInterior - (anchoBoton - tamanoIcono) / 2;
    final huecos = DateTime(mes.year, mes.month).weekday - DateTime.monday;
    final totalDias = DateUtils.getDaysInMonth(mes.year, mes.month);

    return Material(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: _contorno, width: 1.5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              margenInterior,
              11,
              margenDelBoton,
              0,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    '${_meses[mes.month - 1]} ${mes.year}',
                    style: _estilo.copyWith(fontSize: 18),
                  ),
                ),
                IconButton(
                  onPressed: onAbrir,
                  tooltip: 'Elegir otra fecha',
                  color: _azul,
                  icon: const SizedBox.square(
                    dimension: tamanoIcono,
                    child: CustomPaint(painter: _IconoCalendario()),
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints.tightFor(
                    width: anchoBoton,
                    height: 38,
                  ),
                  style: const ButtonStyle(
                    shape: WidgetStatePropertyAll(CircleBorder()),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              margenInterior,
              10,
              margenInterior,
              14,
            ),
            child: Column(
              children: [
                const Divider(height: 1, thickness: 1, color: _contorno),
                SizedBox(
                  height: 44,
                  child: Row(
                    children: [
                      for (var i = 0; i < iniciales.length; i++)
                        Expanded(
                          child: Center(
                            child: Semantics(
                              label: _dias[i],
                              excludeSemantics: true,
                              child: Text(
                                iniciales[i],
                                style: _estilo.copyWith(fontSize: 14),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                for (var semana = 0; semana < 6; semana++)
                  SizedBox(
                    height: 38,
                    child: Row(
                      children: [
                        for (var columna = 0; columna < 7; columna++)
                          Expanded(
                            child: _celda(
                              semana * 7 + columna + 1 - huecos,
                              totalDias,
                            ),
                          ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _celda(int numero, int totalDias) {
    if (numero < 1 || numero > totalDias) return const SizedBox.shrink();

    final fecha = DateTime(mes.year, mes.month, numero);
    final seleccionado = DateUtils.isSameDay(fecha, seleccion);
    void onTap() => onFecha(fecha);
    final borde = BorderRadius.circular(8);

    return Semantics(
      label: _fechaEnEspanol(fecha),
      button: true,
      selected: seleccionado,
      enabled: true,
      excludeSemantics: true,
      onTap: onTap,
      child: Center(
        child: SizedBox(
          width: 42,
          height: 34,
          child: Ink(
            decoration: BoxDecoration(
              color: seleccionado ? _azul : null,
              border: seleccionado
                  ? Border.all(color: _azul, width: 1.5)
                  : null,
              borderRadius: borde,
            ),
            child: InkWell(
              onTap: onTap,
              borderRadius: borde,
              child: Center(
                child: Text(
                  '$numero',
                  style: _estilo.copyWith(
                    color: seleccionado ? Colors.white : _secundario,
                    fontWeight: seleccionado
                        ? FontWeight.w700
                        : FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _IconoCalendario extends CustomPainter {
  const _IconoCalendario();

  @override
  void paint(Canvas canvas, Size size) {
    final pintura = Paint()
      ..color = _azul
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8
      ..strokeCap = StrokeCap.round;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTRB(1, 3, 21, 21),
        const Radius.circular(3),
      ),
      pintura,
    );
    canvas.drawLine(const Offset(6, 1), const Offset(6, 7), pintura);
    canvas.drawLine(const Offset(16, 1), const Offset(16, 7), pintura);
    canvas.drawLine(const Offset(1, 10), const Offset(21, 10), pintura);
  }

  @override
  bool shouldRepaint(_IconoCalendario oldDelegate) => false;
}

class _TrazoIcono extends CustomPainter {
  const _TrazoIcono(this.puntos);

  final List<Offset> puntos;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawPoints(
      PointMode.polygon,
      puntos,
      Paint()
        ..color = _azul
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(_TrazoIcono oldDelegate) => oldDelegate.puntos != puntos;
}
