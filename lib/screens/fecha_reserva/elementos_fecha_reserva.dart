import 'package:flutter/material.dart';
import 'package:train_away/widgets/boton_inferior.dart';
import 'package:train_away/widgets/header.dart';

const _azul = Color(0xFF2A4252);
const _bordePie = Color(0xFFE0E0E0);

const barraFechaReserva = Header(
  espacioTitulo: 22,
  estiloTitulo: TextStyle(
    color: Color(0xF7752B3C),
    fontFamily: 'Corinthia',
    fontSize: 36,
    fontWeight: FontWeight.w700,
    height: 1.2,
    letterSpacing: 0,
  ),
  iconoMenu: _IconoMenu(),
  fondo: SafeArea(
    bottom: false,
    child: CustomPaint(painter: _BordeDeBarra(), child: SizedBox.expand()),
  ),
);

class _IconoMenu extends StatelessWidget {
  const _IconoMenu();

  @override
  Widget build(BuildContext context) {
    const lineaMenu = SizedBox(
      width: 38,
      height: 3,
      child: ColoredBox(color: _azul),
    );

    return const Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        lineaMenu,
        SizedBox(height: 8),
        lineaMenu,
        SizedBox(height: 8),
        lineaMenu,
      ],
    );
  }
}

class _BordeDeBarra extends CustomPainter {
  const _BordeDeBarra();

  @override
  void paint(Canvas canvas, Size size) {
    const grosorBorde = 3.0;
    // El trazo de Penpot está centrado en la arista de la cabecera.
    canvas.save();
    canvas.clipRect(
      Rect.fromLTWH(0, 0, size.width, size.height + grosorBorde / 2),
    );
    canvas.drawRect(
      Offset.zero & size,
      Paint()
        ..color = _azul
        ..strokeWidth = grosorBorde
        ..style = PaintingStyle.stroke,
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _BordeDeBarra oldDelegate) => false;
}

class PieFechaReserva extends StatelessWidget {
  const PieFechaReserva({super.key, this.onContinuar});

  final VoidCallback? onContinuar;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: _bordePie),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 22.5, horizontal: 15),
          child: Center(
            heightFactor: 1,
            child: SizedBox(
              width: 195,
              child: BotonInferior(
                texto: 'Continuar',
                onPressed: onContinuar,
                altura: 45,
                estilo: ElevatedButton.styleFrom(
                  backgroundColor: _azul,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: _azul,
                  disabledForegroundColor: const Color(0xFF8A97A0),
                  surfaceTintColor: Colors.transparent,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: VisualDensity.standard,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(11.5),
                  ),
                  textStyle: const TextStyle(
                    fontFamily: 'DMSans',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    height: 1.2,
                    letterSpacing: 0,
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
