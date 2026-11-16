import 'package:flutter/material.dart';

class Header extends StatelessWidget implements PreferredSizeWidget {
  const Header({
    super.key,
    this.estiloTitulo,
    this.espacioTitulo = 20,
    this.iconoMenu,
    this.fondo,
  });

  final TextStyle? estiloTitulo;
  final double espacioTitulo;
  final Widget? iconoMenu;
  final Widget? fondo;

  @override
  Size get preferredSize => const Size.fromHeight(70);

  @override
  Widget build(BuildContext context) {
    final menu = iconoMenu;
    return AppBar(
      toolbarHeight: preferredSize.height,
      backgroundColor: Colors.white,
      flexibleSpace: fondo,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      automaticallyImplyLeading: false,
      centerTitle: false,
      titleSpacing: espacioTitulo,
      title: Text(
        'Train Away',
        style:
            estiloTitulo ??
            const TextStyle(
              color: Color(0xFF752B3C),
              fontSize: 32,
              fontWeight: FontWeight.w700,
              fontStyle: FontStyle.italic,
              fontFamily: 'serif',
            ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 20),
          child: menu == null
              ? const IconButton(
                  onPressed: null,
                  tooltip: 'Menú',
                  disabledColor: Color(0xFF2A4252),
                  iconSize: 38,
                  icon: Icon(Icons.menu),
                )
              : Center(child: menu),
        ),
      ],
    );
  }
}
