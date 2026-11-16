String getDate(int ms) {
  final DateTime dt = DateTime.fromMillisecondsSinceEpoch(ms);
  const List<String> meses = [
    'ene', 'feb', 'mar', 'abr', 'may', 'jun',
    'jul', 'ago', 'sep', 'oct', 'nov', 'dic'
  ];
  final String dia = dt.day.toString().padLeft(2, '0');
  final String mes = meses[dt.month - 1];
  return '$dia $mes ${dt.year}'; // Ejemplo: '20 nov 2026'
}

String getHours(int ms) {
  final DateTime dt = DateTime.fromMillisecondsSinceEpoch(ms);
  final String hora = dt.hour.toString().padLeft(2, '0');
  final String minuto = dt.minute.toString().padLeft(2, '0');
  return '$hora:$minuto'; // Ejemplo: '09:30'
}