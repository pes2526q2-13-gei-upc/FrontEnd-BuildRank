/// Dispatcher amb import condicional: en Web carrega la implementació real
/// que crida `web.renderButton()` de `google_sign_in_web`; en mòbil carrega
/// un stub que retorna un `SizedBox.shrink()`.
///
/// `google_sign_in` >=7.0 no permet la crida imperativa `authenticate()` en
/// Web — l'única forma d'iniciar el flux és renderitzant el botó oficial de
/// Google Identity Services. La credencial arriba pel stream
/// `GoogleSignIn.instance.authenticationEvents`.
library;

export 'google_signin_web_button_stub.dart'
    if (dart.library.html) 'google_signin_web_button_web.dart';
