import 'package:flutter/material.dart';
import 'package:train_away/widgets/boton_inferior.dart';

const _azul = Color(0xFF2A4252);
const _bordePie = Color(0xFFE0E0E0);

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
