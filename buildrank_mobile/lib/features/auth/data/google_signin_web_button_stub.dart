import 'package:flutter/widgets.dart';

/// Stub usat en plataformes que no són Web. Mai s'hauria de renderitzar
/// perquè les pantalles ja envolten l'ús amb `if (kIsWeb)`.
Widget renderGoogleSignInWebButton() => const SizedBox.shrink();
