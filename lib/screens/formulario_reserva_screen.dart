import 'package:flutter/material.dart';

/// Datos que el formulario pasa a la siguiente pantalla (Fecha reserva).
class ReservaFormData {
  const ReservaFormData({
    required this.origen,
    required this.destino,
    required this.pasajeros,
    required this.categoria,
    required this.conEquipaje,
    required this.conRestaurante,
    required this.cocheCama,
  });

  final String origen;
  final String destino;
  final int pasajeros;
  final String categoria;
  final bool conEquipaje;
  final bool conRestaurante;
  final bool cocheCama;
}

class FormularioReservaScreen extends StatefulWidget {
  const FormularioReservaScreen({
    super.key,
    this.origenInicial = 'Estación Norte de Madrid',
    this.destinoInicial = 'Estación Sur de Barcelona',
    this.pasajerosIniciales = 1,
    this.categoriaInicial = '1ª Clase',
    this.onReservar,
  });

  static const routeName = '/formulario-reserva';
  static const nextRouteName = '/fecha-reserva';

  static const _navy = Color(0xFF294858);
  static const _green = Color(0xFF188D70);
  static const _teal = Color(0xFF35AC9D);
  static const _muted = Color(0xFF60747F);
  static const _cardBackground = Color(0xFFF2F8F7);
  static const _border = Color(0xFFD7E8E4);
  static const _error = Color(0xFFC0392B);

  static const estaciones = [
    'Estación Norte de Madrid',
    'Estación Sur de Madrid',
    'Estación Sur de Barcelona',
    'Estación Central de Valencia',
    'Estación de Sevilla',
  ];
  static const categorias = ['1ª Clase', '2ª Clase', 'Turista'];
  static const maxPasajeros = 8;

  final String origenInicial;
  final String destinoInicial;
  final int pasajerosIniciales;
  final String categoriaInicial;
  final ValueChanged<ReservaFormData>? onReservar;

  @override
  State<FormularioReservaScreen> createState() =>
      _FormularioReservaScreenState();
}

class _FormularioReservaScreenState extends State<FormularioReservaScreen> {
  late String _origen = widget.origenInicial;
  late String _destino = widget.destinoInicial;
  late int _pasajeros = widget.pasajerosIniciales;
  late String _categoria = widget.categoriaInicial;
  bool _conEquipaje = false;
  bool _conRestaurante = false;
  bool _cocheCama = false;

  bool get _mismaEstacion => _origen == _destino;

  void _reservar() {
    final data = ReservaFormData(
      origen: _origen,
      destino: _destino,
      pasajeros: _pasajeros,
      categoria: _categoria,
      conEquipaje: _conEquipaje,
      conRestaurante: _conRestaurante,
      cocheCama: _cocheCama,
    );

    if (widget.onReservar != null) {
      widget.onReservar!(data);
      return;
    }

    Navigator.of(context).pushNamed(
      FormularioReservaScreen.nextRouteName,
      arguments: data,
    );
  }

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
                                'Reserva tu billete',
                                style: TextStyle(
                                  color: FormularioReservaScreen._navy,
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
                                    color: FormularioReservaScreen._teal,
                                    height: 3,
                                    thickness: 3,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 34),
                              _FormField(
                                label: 'ORIGEN',
                                child: _Selector<String>(
                                  icon: Icons.trip_origin_rounded,
                                  value: _origen,
                                  items: FormularioReservaScreen.estaciones,
                                  itemLabel: (estacion) => estacion,
                                  onChanged: (value) =>
                                      setState(() => _origen = value),
                                ),
                              ),
                              const SizedBox(height: 20),
                              _FormField(
                                label: 'DESTINO',
                                child: _Selector<String>(
                                  icon: Icons.place_rounded,
                                  value: _destino,
                                  items: FormularioReservaScreen.estaciones,
                                  itemLabel: (estacion) => estacion,
                                  hasError: _mismaEstacion,
                                  onChanged: (value) =>
                                      setState(() => _destino = value),
                                ),
                              ),
                              if (_mismaEstacion) ...[
                                const SizedBox(height: 8),
                                const Text(
                                  'El origen y el destino no pueden ser '
                                  'la misma estación.',
                                  style: TextStyle(
                                    color: FormularioReservaScreen._error,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                              const SizedBox(height: 20),
                              Row(
                                children: [
                                  Expanded(
                                    child: _FormField(
                                      label: 'PASAJEROS',
                                      child: _Selector<int>(
                                        icon: Icons.person_outline_rounded,
                                        value: _pasajeros,
                                        items: List.generate(
                                          FormularioReservaScreen.maxPasajeros,
                                          (index) => index + 1,
                                        ),
                                        itemLabel: (n) => '$n',
                                        onChanged: (value) =>
                                            setState(() => _pasajeros = value),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: _FormField(
                                      label: 'CATEGORÍA',
                                      child: _Selector<String>(
                                        icon: Icons.event_seat_outlined,
                                        value: _categoria,
                                        items:
                                            FormularioReservaScreen.categorias,
                                        itemLabel: (categoria) => categoria,
                                        onChanged: (value) =>
                                            setState(() => _categoria = value),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 28),
                              _TravelOptions(
                                conEquipaje: _conEquipaje,
                                conRestaurante: _conRestaurante,
                                cocheCama: _cocheCama,
                                onEquipajeChanged: (value) =>
                                    setState(() => _conEquipaje = value),
                                onRestauranteChanged: (value) =>
                                    setState(() => _conRestaurante = value),
                                onCocheCamaChanged: (value) =>
                                    setState(() => _cocheCama = value),
                              ),
                              const Spacer(),
                              const SizedBox(height: 32),
                              SizedBox(
                                height: 56,
                                child: FilledButton(
                                  onPressed: _mismaEstacion ? null : _reservar,
                                  style: FilledButton.styleFrom(
                                    backgroundColor:
                                        FormularioReservaScreen._green,
                                    foregroundColor: Colors.white,
                                    disabledBackgroundColor:
                                        const Color(0xFFB9CCC7),
                                    disabledForegroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: const Text(
                                    'RESERVAR',
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
        color: FormularioReservaScreen._navy,
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

class _FormField extends StatelessWidget {
  const _FormField({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: FormularioReservaScreen._muted,
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.6,
          ),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}

class _Selector<T> extends StatelessWidget {
  const _Selector({
    required this.icon,
    required this.value,
    required this.items,
    required this.itemLabel,
    required this.onChanged,
    this.hasError = false,
  });

  final IconData icon;
  final T value;
  final List<T> items;
  final String Function(T item) itemLabel;
  final ValueChanged<T> onChanged;
  final bool hasError;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      padding: const EdgeInsets.only(left: 14, right: 8),
      decoration: BoxDecoration(
        color: FormularioReservaScreen._cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: hasError
              ? FormularioReservaScreen._error
              : FormularioReservaScreen._border,
        ),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: FormularioReservaScreen._teal),
          const SizedBox(width: 10),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<T>(
                value: value,
                isExpanded: true,
                borderRadius: BorderRadius.circular(12),
                dropdownColor: Colors.white,
                icon: const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: FormularioReservaScreen._teal,
                ),
                style: const TextStyle(
                  color: FormularioReservaScreen._navy,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
                items: [
                  for (final item in items)
                    DropdownMenuItem<T>(
                      value: item,
                      child: Text(
                        itemLabel(item),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                ],
                onChanged: (selected) {
                  if (selected != null) onChanged(selected);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TravelOptions extends StatelessWidget {
  const _TravelOptions({
    required this.conEquipaje,
    required this.conRestaurante,
    required this.cocheCama,
    required this.onEquipajeChanged,
    required this.onRestauranteChanged,
    required this.onCocheCamaChanged,
  });

  final bool conEquipaje;
  final bool conRestaurante;
  final bool cocheCama;
  final ValueChanged<bool> onEquipajeChanged;
  final ValueChanged<bool> onRestauranteChanged;
  final ValueChanged<bool> onCocheCamaChanged;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: FormularioReservaScreen._cardBackground,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: FormularioReservaScreen._border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14173445),
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 12, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'OPCIONES DE VIAJE',
              style: TextStyle(
                color: FormularioReservaScreen._muted,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.6,
              ),
            ),
            const SizedBox(height: 8),
            _OptionRow(
              icon: Icons.luggage_outlined,
              label: 'Con equipaje',
              value: conEquipaje,
              onChanged: onEquipajeChanged,
            ),
            const Divider(height: 1, color: Color(0xFFD2E1DF)),
            _OptionRow(
              icon: Icons.restaurant_outlined,
              label: 'Con servicio de restaurante',
              value: conRestaurante,
              onChanged: onRestauranteChanged,
            ),
            const Divider(height: 1, color: Color(0xFFD2E1DF)),
            _OptionRow(
              icon: Icons.bed_outlined,
              label: 'Coche cama',
              value: cocheCama,
              onChanged: onCocheCamaChanged,
            ),
          ],
        ),
      ),
    );
  }
}

class _OptionRow extends StatelessWidget {
  const _OptionRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () => onChanged(!value),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Icon(icon, size: 20, color: FormularioReservaScreen._teal),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  color: FormularioReservaScreen._navy,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Checkbox(
              value: value,
              activeColor: FormularioReservaScreen._green,
              side: const BorderSide(
                color: FormularioReservaScreen._muted,
                width: 1.5,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              onChanged: (checked) => onChanged(checked ?? false),
            ),
          ],
        ),
      ),
    );
  }
}
