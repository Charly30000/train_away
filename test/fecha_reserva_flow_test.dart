import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:train_away/screens/fecha_reserva/elementos_fecha_reserva.dart';
import 'package:train_away/screens/fecha_reserva/fecha_reserva_screen.dart';
import 'package:train_away/widgets/boton_inferior.dart';
import 'package:train_away/widgets/header.dart';

void main() {
  testWidgets('Elegir fecha y hora permite continuar con la salida elegida', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final salidas = <DateTime>[];
    await tester.pumpWidget(
      MaterialApp(
        home: FechaReservaScreen(
          origen: 'Madrid',
          destino: 'Barcelona',
          fechaReferencia: DateTime(2026, 11, 20),
          onContinuar: salidas.add,
        ),
      ),
    );

    Future<void> pulsar(String texto) async {
      final objetivo = find.text(texto);
      await tester.ensureVisible(objetivo);
      await tester.tap(objetivo);
      await tester.pumpAndSettle();
    }

    VoidCallback? accionContinuar() => tester
        .widget<ElevatedButton>(
          find.widgetWithText(ElevatedButton, 'Continuar'),
        )
        .onPressed;

    BoxDecoration decoracionDia(String dia) {
      final celda = tester.widget<Ink>(
        find.ancestor(of: find.text(dia), matching: find.byType(Ink)),
      );
      return celda.decoration! as BoxDecoration;
    }

    expect(find.byType(Header), findsOneWidget);
    final cabecera = tester.widget<Header>(find.byType(Header));
    expect(cabecera.estiloTitulo, isNull);
    expect(cabecera.iconoMenu, isNull);
    expect(cabecera.fondo, isNull);
    expect(cabecera.espacioTitulo, 20);
    expect(find.byType(BotonInferior), findsOneWidget);
    expect(find.text('Madrid → Barcelona'), findsOneWidget);
    expect(find.text('Noviembre 2026'), findsOneWidget);
    final campoInicial = tester.widget<InkWell>(
      find.widgetWithText(InkWell, 'Selecciona un día'),
    );
    expect(campoInicial.onTap, isNull);
    expect(accionContinuar(), isNull);

    final decoracionNeutra = decoracionDia('1');
    final estiloNeutro = tester.widget<Text>(find.text('1')).style;
    expect(decoracionNeutra.color, isNull);
    expect(decoracionNeutra.border, isNull);
    for (var dia = 1; dia <= 30; dia++) {
      final celda = tester.widget<InkWell>(
        find.widgetWithText(InkWell, '$dia'),
      );
      expect(
        celda.onTap,
        isNotNull,
        reason: 'El día $dia debe ser seleccionable',
      );
      expect(decoracionDia('$dia'), decoracionNeutra);
      expect(tester.widget<Text>(find.text('$dia')).style, estiloNeutro);
    }

    final botonCalendario = find.byWidgetPredicate(
      (widget) => widget is IconButton && widget.tooltip == 'Elegir otra fecha',
    );
    final iconoCalendario = find.descendant(
      of: find.byWidget(tester.widget<IconButton>(botonCalendario).icon),
      matching: find.byType(CustomPaint),
      matchRoot: true,
    );
    expect(tester.getSize(botonCalendario), const Size(44, 38));
    expect(tester.getSize(iconoCalendario), const Size(22, 22));
    expect(
      (tester.getCenter(botonCalendario) - tester.getCenter(iconoCalendario))
          .distance,
      closeTo(0, 0.01),
      reason: 'El icono y el efecto del botón deben compartir centro',
    );

    await tester.tap(botonCalendario);
    await tester.pumpAndSettle();
    expect(
      tester
          .widget<DatePickerDialog>(find.byType(DatePickerDialog))
          .initialDate,
      isNull,
    );
    await pulsar('Cancelar');

    await pulsar('5');
    expect(decoracionDia('5').color, const Color(0xFF2A4252));
    expect(decoracionDia('20'), decoracionNeutra);
    expect(tester.widget<Text>(find.text('5')).style?.color, Colors.white);
    expect(find.text('Jueves, 5 de noviembre de 2026'), findsOneWidget);
    expect(find.text('Selecciona una hora'), findsOneWidget);
    expect(find.text('09:30'), findsNothing);
    expect(accionContinuar(), isNull);

    await pulsar('Selecciona una hora');
    expect(find.text('Selecciona una hora'), findsOneWidget);
    expect(find.text('09:30'), findsOneWidget);
    expect(find.text('13:00'), findsOneWidget);
    expect(find.text('18:45'), findsOneWidget);
    expect(accionContinuar(), isNull);

    await pulsar('09:30');
    expect(find.text('Selecciona una hora'), findsNothing);
    expect(find.text('09:30'), findsOneWidget);
    expect(accionContinuar(), isNotNull);

    await pulsar('19');
    expect(decoracionDia('5'), decoracionNeutra);
    expect(decoracionDia('19').color, const Color(0xFF2A4252));
    expect(find.text('Jueves, 19 de noviembre de 2026'), findsOneWidget);
    expect(find.text('Selecciona una hora'), findsOneWidget);
    expect(find.text('09:30'), findsNothing);
    expect(accionContinuar(), isNull);
    expect(salidas, isEmpty);

    await pulsar('Selecciona una hora');
    await pulsar('18:45');
    await pulsar('Continuar');
    expect(salidas, [DateTime(2026, 11, 19, 18, 45)]);
  });

  testWidgets('En una ventana ancha solo se acota el formulario', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1280, 720);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final salidas = <DateTime>[];
    await tester.pumpWidget(
      MaterialApp(
        home: FechaReservaScreen(
          origen: 'Madrid',
          destino: 'Barcelona',
          fechaReferencia: DateTime(2026, 11, 20),
          onContinuar: salidas.add,
        ),
      ),
    );

    expect(tester.getSize(find.byType(Header)).width, 1280);
    expect(tester.getSize(find.byType(PieFechaReserva)).width, 1280);
    final titulo = tester.getRect(find.text('Fecha de salida'));
    expect(titulo.width, 1070);
    expect(titulo.center.dx, 640);

    await tester.tap(find.text('20'));
    await tester.pumpAndSettle();
    final campoHora = find.text('Selecciona una hora');
    await tester.ensureVisible(campoHora);
    await tester.tap(campoHora);
    await tester.pumpAndSettle();
    final hora = find.text('13:00');
    await tester.ensureVisible(hora);
    await tester.tap(hora);
    await tester.pumpAndSettle();
    final continuar = find.widgetWithText(ElevatedButton, 'Continuar');
    expect(tester.widget<ElevatedButton>(continuar).onPressed, isNotNull);
    await tester.tap(continuar);
    await tester.pumpAndSettle();
    expect(salidas, [DateTime(2026, 11, 20, 13)]);
  });
}
