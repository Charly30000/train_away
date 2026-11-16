import 'package:flutter/material.dart';

class Header extends StatelessWidget implements PreferredSizeWidget {
  const Header({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(70);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: preferredSize.height,
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      automaticallyImplyLeading: false,
      centerTitle: false,
      titleSpacing: 20,
      title: const Text(
        'Train Away',
        style: TextStyle(
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
          child: IconButton(
            onPressed: null,
            tooltip: 'Menú',
            disabledColor: const Color(0xFF2A4252),
            iconSize: 38,
            icon: const Icon(Icons.menu),
          ),
        ),
      ],
    );
  }
}
