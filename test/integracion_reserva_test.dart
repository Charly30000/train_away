import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:train_away/main.dart';
import 'package:train_away/screens/confirmacion_reserva/confirmacion_reserva.dart';
import 'package:train_away/screens/fecha_reserva/fecha_reserva_screen.dart';
import 'package:train_away/screens/formulario_reserva/formulario_reserva.dart';
import 'package:train_away/screens/reserva_confirmada/reserva_confirmada_screen.dart';
import 'package:train_away/utils/dates.dart';

Future<void> _abrirAplicacion(WidgetTester tester) async {
  tester.view.physicalSize = const Size(360, 640);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.runAsync(() async {
    final dmSans = FontLoader('DMSans')
      ..addFont(
        rootBundle.load(
          'lib/screens/fecha_reserva/tipografia/DMSans-Medium.ttf',
        ),
      )
      ..addFont(
        rootBundle.load('lib/screens/fecha_reserva/tipografia/DMSans-Bold.ttf'),
      );
    final corinthia = FontLoader('Corinthia')
      ..addFont(
        rootBundle.load(
          'lib/screens/fecha_reserva/tipografia/Corinthia-Bold.ttf',
        ),
      );
    await Future.wait([dmSans.load(), corinthia.load()]);
  });
  await tester.pumpWidget(const MainApp());
  await tester.pumpAndSettle();
}

Future<void> _pulsar(WidgetTester tester, Finder objetivo) async {
  await tester.ensureVisible(objetivo);
  await tester.tap(objetivo);
  await tester.pumpAndSettle();
}

Future<void> _elegir<T>(
  WidgetTester tester,
  T valorActual,
  String nuevoTexto,
) async {
  final desplegable = find.byWidgetPredicate(
    (widget) => widget is DropdownButton<T> && widget.value == valorActual,
  );
  await _pulsar(tester, desplegable);
  await _pulsar(tester, find.text(nuevoTexto).last);
}

void main() {
  testWidgets('El flujo conserva los datos al volver, confirmar y finalizar', (
    tester,
  ) async {
    const origen = 'Estación Central de Valencia';
    const destino = 'Estación de Sevilla';
    const categoria = '2ª Clase';
    const opciones = [
      FormularioReserva.opcionEquipaje,
      FormularioReserva.opcionRestaurante,
      FormularioReserva.opcionCocheCama,
    ];
    final referencia = DateTime.now();
    await _abrirAplicacion(tester);
    expect(find.byType(FormularioReserva), findsOneWidget);

    await _elegir(tester, 'Estación Norte de Madrid', origen);
    await _elegir(tester, 'Estación Sur de Barcelona', destino);
    await _elegir(tester, 1, '3');
    await _elegir(tester, '1ª Clase', categoria);
    for (final opcion in opciones) {
      await _pulsar(tester, find.text(opcion));
    }
    await _pulsar(tester, find.text('Reservar'));

    final pantallaFecha = tester.widget<FechaReservaScreen>(
      find.byType(FechaReservaScreen),
    );
    expect(pantallaFecha.origen, origen);
    expect(pantallaFecha.destino, destino);
    final continuar = find.widgetWithText(ElevatedButton, 'Continuar');
    expect(tester.widget<ElevatedButton>(continuar).onPressed, isNull);
    await _pulsar(tester, find.text('19'));
    await _pulsar(tester, find.text('Selecciona una hora'));
    await _pulsar(tester, find.text('18:45'));
    await _pulsar(tester, continuar);

    final primeraConfirmacion = tester.widget<ConfirmacionReserva>(
      find.byType(ConfirmacionReserva),
    );
    final primeraFecha = DateTime(
      referencia.year,
      referencia.month,
      19,
      18,
      45,
    );
    expect(primeraConfirmacion.origen, origen);
    expect(primeraConfirmacion.destino, destino);
    expect(primeraConfirmacion.numeroPasajeros, 3);
    expect(primeraConfirmacion.categoria, categoria);
    expect(primeraConfirmacion.opcionesViaje, opciones);
    expect(
      primeraConfirmacion.fechaHoraViajeMs,
      primeraFecha.millisecondsSinceEpoch,
    );

    // El encabezado oculta la flecha. Volver usa la acción del sistema.
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.byType(FechaReservaScreen), findsOneWidget);
    expect(find.text('18:45'), findsOneWidget);
    expect(tester.widget<ElevatedButton>(continuar).onPressed, isNotNull);

    await _pulsar(tester, find.text('20'));
    expect(find.text('18:45'), findsNothing);
    expect(find.text('Selecciona una hora'), findsOneWidget);
    expect(tester.widget<ElevatedButton>(continuar).onPressed, isNull);
    await _pulsar(tester, find.text('Selecciona una hora'));
    await _pulsar(tester, find.text('13:00'));
    await _pulsar(tester, continuar);

    final fechaElegida = DateTime(referencia.year, referencia.month, 20, 13);
    final segundaConfirmacion = tester.widget<ConfirmacionReserva>(
      find.byType(ConfirmacionReserva),
    );
    expect(segundaConfirmacion.origen, origen);
    expect(segundaConfirmacion.destino, destino);
    expect(segundaConfirmacion.numeroPasajeros, 3);
    expect(segundaConfirmacion.categoria, categoria);
    expect(segundaConfirmacion.opcionesViaje, opciones);
    expect(
      segundaConfirmacion.fechaHoraViajeMs,
      fechaElegida.millisecondsSinceEpoch,
    );
    await _pulsar(tester, find.text('Confirmar'));
    await _pulsar(tester, find.text('No'));
    expect(find.byType(ConfirmacionReserva), findsOneWidget);
    expect(find.byType(ReservaConfirmadaScreen), findsNothing);
    await _pulsar(tester, find.text('Confirmar'));
    await _pulsar(tester, find.text('Sí'));

    final reservaFinal = tester.widget<ReservaConfirmadaScreen>(
      find.byType(ReservaConfirmadaScreen),
    );
    expect(reservaFinal.origen, origen);
    expect(reservaFinal.destino, destino);
    expect(reservaFinal.pasajeros, 3);
    expect(reservaFinal.categoria, categoria);
    expect(reservaFinal.opcionesViaje, opciones);
    expect(reservaFinal.fecha, getDate(fechaElegida.millisecondsSinceEpoch));
    expect(reservaFinal.hora, '13:00');

    await _pulsar(tester, find.text('Finalizar'));
    expect(find.byType(FormularioReserva), findsOneWidget);
    expect(find.byType(ConfirmacionReserva), findsNothing);
    expect(find.byType(FechaReservaScreen), findsNothing);
    final estaciones = tester
        .widgetList<DropdownButton<String>>(find.byType(DropdownButton<String>))
        .map((campo) => campo.value);
    expect(estaciones, containsAll([origen, destino, categoria]));
    expect(
      tester
          .widget<DropdownButton<int>>(find.byType(DropdownButton<int>))
          .value,
      3,
    );
    // Una nueva reserva conserva también las tres casillas marcadas.
    await _pulsar(tester, find.text('Reservar'));
    await _pulsar(tester, find.text('20'));
    await _pulsar(tester, find.text('Selecciona una hora'));
    await _pulsar(tester, find.text('13:00'));
    await _pulsar(tester, continuar);
    expect(
      tester
          .widget<ConfirmacionReserva>(find.byType(ConfirmacionReserva))
          .opcionesViaje,
      opciones,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('Una reserva sin opciones mantiene la lista vacía', (
    tester,
  ) async {
    await _abrirAplicacion(tester);
    await _pulsar(tester, find.text('Reservar'));
    await _pulsar(tester, find.text('19'));
    await _pulsar(tester, find.text('Selecciona una hora'));
    await _pulsar(tester, find.text('09:30'));
    await _pulsar(tester, find.text('Continuar'));
    expect(
      tester
          .widget<ConfirmacionReserva>(find.byType(ConfirmacionReserva))
          .opcionesViaje,
      isEmpty,
    );
    await _pulsar(tester, find.text('Confirmar'));
    await _pulsar(tester, find.text('Sí'));
    expect(
      tester
          .widget<ReservaConfirmadaScreen>(find.byType(ReservaConfirmadaScreen))
          .opcionesViaje,
      isEmpty,
    );
    expect(find.text('Sin opciones adicionales'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
