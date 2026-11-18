import 'package:flutter/material.dart';
import 'package:train_away/widgets/boton_inferior.dart';
import 'package:train_away/widgets/header.dart';

const _azul = Color(0xFF2A4252);
const _bordeBotonera = Color(0xFFE0E0E0);

const _estiloEtiqueta = TextStyle(
  fontFamily: 'DMSans',
  color: _azul,
  fontSize: 16,
  fontWeight: FontWeight.w700,
  height: 1.2,
);

const _estiloValor = TextStyle(
  fontFamily: 'DMSans',
  color: _azul,
  fontSize: 18,
  fontWeight: FontWeight.w700,
  height: 1.2,
);

/// Datos que el formulario entrega al pulsar «Reservar».
class DatosFormularioReserva {
  const DatosFormularioReserva({
    required this.origen,
    required this.destino,
    required this.numeroPasajeros,
    required this.categoria,
    required this.opcionesViaje,
  });

  final String origen;
  final String destino;
  final int numeroPasajeros;
  final String categoria;
  final List<String> opcionesViaje;
}

class FormularioReserva extends StatefulWidget {
  const FormularioReserva({super.key, required this.onReservar});

  final ValueChanged<DatosFormularioReserva> onReservar;

  static const estaciones = [
    'Estación Norte de Madrid',
    'Estación Sur de Madrid',
    'Estación Sur de Barcelona',
    'Estación Central de Valencia',
    'Estación de Sevilla',
  ];
  static const categorias = ['1ª Clase', '2ª Clase'];
  static const maxPasajeros = 8;

  static const opcionEquipaje = 'Con equipaje';
  static const opcionRestaurante = 'Con servicio de restaurante';
  static const opcionCocheCama = 'Coche cama';

  @override
  State<FormularioReserva> createState() => _FormularioReservaState();
}

class _FormularioReservaState extends State<FormularioReserva> {
  String _origen = 'Estación Norte de Madrid';
  String _destino = 'Estación Sur de Barcelona';
  int _numeroPasajeros = 1;
  String _categoria = '1ª Clase';
  bool _conEquipaje = false;
  bool _conRestaurante = false;
  bool _cocheCama = false;

  void _reservar() {
    widget.onReservar(
      DatosFormularioReserva(
        origen: _origen,
        destino: _destino,
        numeroPasajeros: _numeroPasajeros,
        categoria: _categoria,
        opcionesViaje: [
          if (_conEquipaje) FormularioReserva.opcionEquipaje,
          if (_conRestaurante) FormularioReserva.opcionRestaurante,
          if (_cocheCama) FormularioReserva.opcionCocheCama,
        ],
      ),
    );
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
                padding: const EdgeInsets.fromLTRB(15, 20, 15, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: 50,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      spacing: 18,
                      children: [
                        _Campo(
                          etiqueta: 'Origen',
                          desplegable: _Desplegable<String>(
                            valor: _origen,
                            opciones: FormularioReserva.estaciones,
                            texto: (estacion) => estacion,
                            onChanged: (valor) =>
                                setState(() => _origen = valor),
                          ),
                        ),
                        _Campo(
                          etiqueta: 'Destino',
                          desplegable: _Desplegable<String>(
                            valor: _destino,
                            opciones: FormularioReserva.estaciones,
                            texto: (estacion) => estacion,
                            onChanged: (valor) =>
                                setState(() => _destino = valor),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 32,
                      children: [
                        Expanded(
                          child: _Campo(
                            etiqueta: 'Pasajeros',
                            desplegable: _Desplegable<int>(
                              valor: _numeroPasajeros,
                              opciones: List.generate(
                                FormularioReserva.maxPasajeros,
                                (indice) => indice + 1,
                              ),
                              texto: (numero) => '$numero',
                              onChanged: (valor) =>
                                  setState(() => _numeroPasajeros = valor),
                            ),
                          ),
                        ),
                        Expanded(
                          child: _Campo(
                            etiqueta: 'Categoría',
                            desplegable: _Desplegable<String>(
                              valor: _categoria,
                              opciones: FormularioReserva.categorias,
                              texto: (categoria) => categoria,
                              onChanged: (valor) =>
                                  setState(() => _categoria = valor),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Opciones de viaje', style: _estiloValor),
                        const SizedBox(height: 17),
                        Padding(
                          padding: const EdgeInsets.only(left: 7),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 14,
                            children: [
                              _Casilla(
                                texto: FormularioReserva.opcionEquipaje,
                                marcada: _conEquipaje,
                                onChanged: (valor) =>
                                    setState(() => _conEquipaje = valor),
                              ),
                              _Casilla(
                                texto: FormularioReserva.opcionRestaurante,
                                marcada: _conRestaurante,
                                onChanged: (valor) =>
                                    setState(() => _conRestaurante = valor),
                              ),
                              _Casilla(
                                texto: FormularioReserva.opcionCocheCama,
                                marcada: _cocheCama,
                                onChanged: (valor) =>
                                    setState(() => _cocheCama = valor),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: _bordeBotonera)),
              ),
              child: Center(
                child: SizedBox(
                  width: 192,
                  child: BotonInferior(texto: 'Reservar', onPressed: _reservar),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Campo extends StatelessWidget {
  const _Campo({required this.etiqueta, required this.desplegable});

  final String etiqueta;
  final Widget desplegable;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 6,
      children: [
        Text(etiqueta, style: _estiloEtiqueta),
        desplegable,
      ],
    );
  }
}

class _Desplegable<T> extends StatelessWidget {
  const _Desplegable({
    required this.valor,
    required this.opciones,
    required this.texto,
    required this.onChanged,
  });

  final T valor;
  final List<T> opciones;
  final String Function(T opcion) texto;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(left: 14, right: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: _azul, width: 3),
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: valor,
          isExpanded: true,
          isDense: true,
          dropdownColor: Colors.white,
          borderRadius: BorderRadius.circular(10),
          style: _estiloValor,
          icon: const Icon(Icons.keyboard_arrow_down_rounded),
          iconEnabledColor: _azul,
          iconSize: 28,
          items: [
            for (final opcion in opciones)
              DropdownMenuItem<T>(
                value: opcion,
                child: Text(
                  texto(opcion),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
          ],
          onChanged: (seleccion) {
            if (seleccion != null) onChanged(seleccion);
          },
        ),
      ),
    );
  }
}

class _Casilla extends StatelessWidget {
  const _Casilla({
    required this.texto,
    required this.marcada,
    required this.onChanged,
  });

  final String texto;
  final bool marcada;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      checked: marcada,
      child: InkWell(
        onTap: () => onChanged(!marcada),
        borderRadius: BorderRadius.circular(6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 6,
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: marcada ? _azul : Colors.white,
                border: Border.all(color: _azul, width: 3),
                borderRadius: BorderRadius.circular(6),
              ),
              child: marcada
                  ? const Icon(Icons.check, size: 12, color: Colors.white)
                  : null,
            ),
            Text(texto, style: _estiloEtiqueta),
          ],
        ),
      ),
    );
  }
}
