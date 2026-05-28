import 'package:flutter/widgets.dart';
import 'package:google_sign_in_web/web_only.dart' as web;

/// Renderitza el botó oficial de Google Identity Services. En clicar-lo,
/// Google obre el seu modal de selecció de compte i, en autenticar, emet
/// un esdeveniment al stream `GoogleSignIn.instance.authenticationEvents`
/// que les pantalles escolten per completar el login.
Widget renderGoogleSignInWebButton() => web.renderButton();
