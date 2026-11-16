import 'package:flutter/material.dart';

class BotonInferior extends StatelessWidget {
  const BotonInferior({
    super.key,
    required this.texto,
    required this.onPressed,
    this.altura = 42,
    this.estilo,
  });

  final String texto;
  final VoidCallback? onPressed;
  final double altura;
  final ButtonStyle? estilo;

  @override
  Widget build(BuildContext context) {
    final estiloBase = ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF2A4252),
      foregroundColor: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
    );

    return SizedBox(
      height: altura,
      child: ElevatedButton(
        onPressed: onPressed,
        style: estilo?.merge(estiloBase) ?? estiloBase,
        child: Text(texto),
      ),
    );
  }
}
