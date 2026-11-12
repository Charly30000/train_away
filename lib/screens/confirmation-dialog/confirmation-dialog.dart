import 'package:flutter/material.dart';

_closeConfirmationDialog(context) => Navigator.pop(context);
_confirmBookingDialog(context)  {
  _closeConfirmationDialog(context);
  print("redireccion hecha");
}

class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String message;

  const ConfirmationDialog({
    super.key,
    required this.title,
    required this.message
  });

  @override
    Widget build(BuildContext context) {
    return Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
              padding: const EdgeInsetsGeometry.only(top: 10),
                child: Column(
                  children: [
                    Container(
                        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(color: Colors.black, width: 1)
                            )
                        ),
                        child: Column(
                          spacing: 12,
                          children: [
                            Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            Text(message, textAlign:TextAlign.center)
                          ],
                        )
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  right: BorderSide(color: Colors.black, width: 1)
                                )
                              ),
                              child: TextButton(onPressed: () => _closeConfirmationDialog(context), child: Text('No', style: TextStyle(fontWeight: FontWeight.bold)))),
                            ),
                        Expanded(child: TextButton(onPressed: () => _closeConfirmationDialog(context), child: Text('Si', style: TextStyle(fontWeight: FontWeight.bold))))
                      ],
                    )
                  ]
              )
          )
        ],
      ),
    );
  }
}