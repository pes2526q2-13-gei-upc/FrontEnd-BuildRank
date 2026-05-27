// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get authLanguageLabel => 'Idioma';

  @override
  String get authLanguageCatalan => 'Català';

  @override
  String get authLanguageSpanish => 'Español';

  @override
  String get authLanguageEnglish => 'English';

  @override
  String get authLoginTab => 'Iniciar sesión';

  @override
  String get authRegisterTab => 'Registrarse';

  @override
  String authRegisterSuccessWithEmail(String email) {
    return 'Cuenta creada correctamente. Ahora puedes iniciar sesión con $email.';
  }

  @override
  String get loginWelcomeTitle => 'Bienvenido a BuildRank';

  @override
  String get loginWelcomeSubtitle =>
      'Gestiona tu edificio, consulta el ranking energético y sigue tu evolución desde un único lugar.';

  @override
  String get loginCardTitle => 'Iniciar sesión';

  @override
  String get loginCardSubtitle =>
      'Accede con tu cuenta para ver la información de tu edificio.';

  @override
  String get emailLabel => 'Correo electrónico';

  @override
  String get emailHint => 'nombre@ejemplo.com';

  @override
  String get passwordLabel => 'Contraseña';

  @override
  String get loginForgotPassword => '¿Has olvidado la contraseña?';

  @override
  String get loginButton => 'Entrar';

  @override
  String get loginGoogleButton => 'Continuar con Google';

  @override
  String get loginMissingFieldsError =>
      'Debes rellenar el correo y la contraseña.';

  @override
  String get registerTitle => 'Crear una cuenta';

  @override
  String get registerSubtitle => 'Empieza hoy el seguimiento de tu edificio';

  @override
  String get registerCardTitle => 'Regístrate';

  @override
  String get registerCardSubtitle =>
      'Crea tu cuenta para empezar a gestionar edificios.';

  @override
  String get registerRoleHeader => 'SELECCIONA TU ROL';

  @override
  String get registerRoleAdmin => 'Admin.\nfinca';

  @override
  String get registerRoleOwner => 'Propietario';

  @override
  String get registerRoleTenant => 'Inquilino';

  @override
  String get firstNameLabel => 'Nombre';

  @override
  String get lastNameLabel => 'Apellidos';

  @override
  String get confirmPasswordLabel => 'Confirmar contraseña';

  @override
  String get registerAcceptTermsPrefix => 'Acepto los ';

  @override
  String get registerTermsOfService => 'Términos del Servicio';

  @override
  String get registerAcceptTermsMiddle => ' y la ';

  @override
  String get registerPrivacyPolicy => 'Política de Privacidad';

  @override
  String get registerCreateAccountButton => 'Crear la cuenta de BuildRank';

  @override
  String get registerGoogleButton => 'Crear cuenta con Google';

  @override
  String get registerMissingFieldsError => 'Debes rellenar todos los campos.';

  @override
  String get registerPasswordsMismatchError => 'Las contraseñas no coinciden.';

  @override
  String get registerAcceptTermsError =>
      'Debes aceptar los términos y condiciones.';

  @override
  String get registerSuccessInline =>
      'Cuenta creada correctamente. Ahora ya puedes iniciar sesión.';

  @override
  String get registerSuccessSnackBar => 'Registro completado correctamente.';

  @override
  String get passwordResetAppBarTitle => 'Recuperar contraseña';

  @override
  String get passwordResetRequestTitle => 'Recupera la contraseña';

  @override
  String get passwordResetConfirmTitle => 'Crea una nueva contraseña';

  @override
  String get passwordResetRequestSubtitle =>
      'Escribe el correo asociado a tu cuenta y pega el enlace recibido por email.';

  @override
  String get passwordResetConfirmSubtitle =>
      'Introduce una nueva contraseña para tu cuenta.';

  @override
  String get passwordResetSendInstructions => 'Enviar instrucciones';

  @override
  String get passwordResetHaveLinkTitle => '¿Ya tienes el enlace?';

  @override
  String get passwordResetHaveLinkBody =>
      'Pega aquí el enlace recibido por email. BuildRank extraerá automáticamente el uid y el token.';

  @override
  String get passwordResetLinkLabel => 'Enlace de recuperación';

  @override
  String get passwordResetLinkHint =>
      'https://.../reset-password?uid=...&token=...';

  @override
  String get passwordResetContinueWithLink => 'Continuar con el enlace';

  @override
  String get newPasswordLabel => 'Nueva contraseña';

  @override
  String get confirmNewPasswordLabel => 'Confirmar nueva contraseña';

  @override
  String get passwordResetSubmit => 'Restablecer contraseña';

  @override
  String get passwordResetPasteAnotherLink => 'Volver a pegar otro enlace';

  @override
  String get passwordResetEmailRequiredError =>
      'Introduce tu correo electrónico.';

  @override
  String get passwordResetRequestSuccess =>
      'Si el correo existe, recibirás un enlace para restablecer la contraseña. Pégalo aquí cuando lo tengas.';

  @override
  String get passwordResetLinkRequiredError =>
      'Pega el enlace de recuperación recibido por email.';

  @override
  String get passwordResetInvalidLinkError =>
      'No se han podido encontrar los parámetros uid y token dentro del enlace.';

  @override
  String get passwordResetLinkValidatedSuccess =>
      'Enlace validado. Introduce la nueva contraseña.';

  @override
  String get passwordResetPasswordRequiredError =>
      'Introduce y confirma la nueva contraseña.';

  @override
  String get passwordResetSuccessSnackBar =>
      'Contraseña restablecida correctamente.';

  @override
  String get legalTermsTitle => 'Términos del Servicio';

  @override
  String get legalPrivacyTitle => 'Política de Privacidad';

  @override
  String get legalTermsSubtitle => 'Condiciones básicas de uso de BuildRank';

  @override
  String get legalPrivacySubtitle =>
      'Cómo BuildRank trata los datos dentro del MVP';

  @override
  String get legalInfoNotice =>
      'BuildRank es un proyecto académico en fase MVP. Este texto resume las condiciones y criterios de privacidad aplicables a la demo y al uso del prototipo.';

  @override
  String get legalTermsSection1Title => '1. Finalidad del servicio';

  @override
  String get legalTermsSection1Body =>
      'BuildRank es una aplicación orientada a promover un uso más responsable y sostenible de la energía en edificios residenciales. Permite consultar información de edificios, visualizar indicadores, comparar resultados, simular mejoras y participar en funcionalidades comunitarias según el rol del usuario.';

  @override
  String get legalTermsSection2Title =>
      '2. Carácter orientativo de la información';

  @override
  String get legalTermsSection2Body =>
      'Las puntuaciones, rankings, clasificaciones energéticas estimadas, simulaciones, Heat Risk Index e insignias tienen finalidad informativa y orientativa. No constituyen certificaciones energéticas oficiales, informes técnicos profesionales ni recomendaciones de ingeniería concluyentes.';

  @override
  String get legalTermsSection3Title => '3. Uso responsable de la aplicación';

  @override
  String get legalTermsSection3Body =>
      'El usuario se compromete a utilizar BuildRank de manera responsable, a no introducir datos falsos o de terceros sin autorización y a respetar las normas de convivencia en votaciones, chats y espacios comunitarios.';

  @override
  String get legalTermsSection4Title => '4. Roles y permisos';

  @override
  String get legalTermsSection4Body =>
      'Las acciones disponibles pueden variar según el rol del usuario y su relación con un edificio. Algunas acciones, como gestionar edificios, validar solicitudes, recalcular insignias o administrar votaciones, pueden estar limitadas a administradores autorizados.';

  @override
  String get legalTermsSection5Title =>
      '5. Datos abiertos, datos manuales y estimaciones';

  @override
  String get legalTermsSection5Body =>
      'BuildRank puede combinar datos abiertos, datos introducidos manualmente y resultados estimados. Cuando un dato sea incompleto, estimado o pendiente de verificación, la aplicación intentará indicarlo de manera clara para que el usuario pueda interpretarlo correctamente.';

  @override
  String get legalTermsSection6Title =>
      '6. Revisión humana y fuentes oficiales';

  @override
  String get legalTermsSection6Body =>
      'En caso de discrepancia sobre datos energéticos, documentación, titularidad o permisos, la revisión humana y las fuentes oficiales prevalecen sobre cualquier resultado automático o estimado mostrado por el sistema.';

  @override
  String get legalPrivacySection1Title => '1. Datos tratados';

  @override
  String get legalPrivacySection1Body =>
      'BuildRank puede tratar datos de cuenta, rol de usuario, edificios asociados, viviendas vinculadas, solicitudes, votaciones, simulaciones, notificaciones y acciones de validación o administración.';

  @override
  String get legalPrivacySection2Title => '2. Finalidad del tratamiento';

  @override
  String get legalPrivacySection2Body =>
      'Los datos se utilizan para autenticar usuarios, gestionar edificios, aplicar permisos, mostrar indicadores, facilitar participación comunitaria, registrar acciones sensibles y mejorar la calidad de los datos del sistema.';

  @override
  String get legalPrivacySection3Title => '3. Minimización de datos';

  @override
  String get legalPrivacySection3Body =>
      'BuildRank intenta mostrar solo la información necesaria para cada funcionalidad. Por ejemplo, las vistas generales como el mapa no deberían exponer emails, documentos, viviendas o datos personales innecesarios.';

  @override
  String get legalPrivacySection4Title => '4. Documentos y verificaciones';

  @override
  String get legalPrivacySection4Body =>
      'En procesos de verificación, los documentos aportados pueden contener información sensible. Estos archivos deben utilizarse solo para revisar la evidencia necesaria y no para finalidades ajenas al proceso de validación.';

  @override
  String get legalPrivacySection5Title => '5. Trazabilidad y auditoría';

  @override
  String get legalPrivacySection5Body =>
      'Las acciones sensibles pueden quedar registradas con finalidades de seguridad, auditoría e integridad del sistema. Esta trazabilidad ayuda a explicar cambios relevantes sobre permisos, validaciones, edificios, votaciones o puntuaciones.';

  @override
  String get legalPrivacySection6Title =>
      '6. Uso de IA y decisiones automáticas';

  @override
  String get legalPrivacySection6Body =>
      'Cualquier soporte automatizado o basado en IA, si existe, debe entenderse como una ayuda para detectar incoherencias o puntos de revisión. No sustituye la revisión humana ni debería aprobar documentos, asignar roles o modificar puntuaciones de manera autónoma.';

  @override
  String get legalPrivacySection7Title => '7. Responsabilidad del usuario';

  @override
  String get legalPrivacySection7Body =>
      'El usuario debe evitar subir información innecesaria o documentos de terceros sin autorización. Las claves, tokens y credenciales no deben compartirse ni introducirse fuera de los formularios previstos por la aplicación.';

  @override
  String get commonRetry => 'Volver a intentarlo';

  @override
  String get commonCancel => 'Cancelar';

  @override
  String get commonConfirm => 'Confirmar';

  @override
  String get commonBack => 'Volver';

  @override
  String get commonRefresh => 'Actualizar';

  @override
  String get commonHideForSession => 'Ocultar durante esta sesión';

  @override
  String commonErrorWithValue(String error) {
    return 'Error: $error';
  }

  @override
  String get adminUserManagementTitle => 'Gestión de usuarios';

  @override
  String get adminUsersRefreshList => 'Actualizar lista';

  @override
  String get notificationsTitle => 'Notificaciones';

  @override
  String get notificationsMarkAll => 'Marcar todas';

  @override
  String get notificationsLoadError =>
      'No se han podido cargar las notificaciones.';

  @override
  String get notificationsEmpty => 'No tienes notificaciones';

  @override
  String get notificationsNow => 'Ahora mismo';

  @override
  String notificationsMinutesAgo(int count) {
    return 'Hace $count min';
  }

  @override
  String notificationsHoursAgo(int count) {
    return 'Hace $count h';
  }

  @override
  String notificationsDaysAgo(int count) {
    return 'Hace $count días';
  }

  @override
  String get myChatsTitle => 'Mis chats';

  @override
  String get myChatsConnectionError => 'No se ha podido conectar al chat.';

  @override
  String get myChatsReconnect => 'Reconectar';

  @override
  String get myChatsNoMessages => 'Sin mensajes';

  @override
  String get myChatsEmpty => 'No tienes ningún chat activo.';

  @override
  String get myChatsDirectDescription =>
      'Conversación directa o canal compartido entre administradores.';

  @override
  String get chatFallbackName => 'Chat';

  @override
  String get chatDirectDescription =>
      'Conversación directa entre administradores de finca.';

  @override
  String get chatUserNotConnectedError =>
      'Usuario no conectado. Cierra sesión y vuelve a entrar.';

  @override
  String chatConnectionError(String error) {
    return 'Error al conectar el chat:\n$error';
  }

  @override
  String get homeRankingTitle => 'Ranking';

  @override
  String get homeProfileTitle => 'Perfil';

  @override
  String get homeGreeting => 'Buenos días';

  @override
  String get homeSummaryTitle => 'Resumen de tu edificio';

  @override
  String get homeSummarySubtitle =>
      'Consulta el estado energético actual, tu posición en la liga y las próximas acciones recomendadas.';

  @override
  String get homeDemoBuildingName => 'Biblioteca Central';

  @override
  String get homeDemoBuildingSubtitle => 'Edificio monitorizado esta semana';

  @override
  String get homeMetricConsumption => 'Consumo';

  @override
  String get homeMetricPosition => 'Posición';

  @override
  String get homeMetricImprovement => 'Mejora';

  @override
  String get homeKeyIndicatorsTitle => 'Indicadores clave';

  @override
  String get homeTodayConsumptionTitle => 'Consumo estimado de hoy';

  @override
  String get homeTodayConsumptionSubtitle => '18 kWh · un 6% menos que ayer';

  @override
  String get homeLeaguePositionTitle => 'Posición en la liga';

  @override
  String get homeLeaguePositionSubtitle => '3.ª posición de 12 edificios';

  @override
  String get homeRecommendationTitle => 'Recomendación principal';

  @override
  String get homeRecommendationSubtitle =>
      'Reducir la climatización por la tarde';

  @override
  String get homeQuickActionsTitle => 'Acciones rápidas';

  @override
  String get homeBuildingTitle => 'Edificio';

  @override
  String get homeImprovementsTitle => 'Mejoras';

  @override
  String get homeCommunityTitle => 'Comunidad';

  @override
  String get homeWeeklyGoalTitle => 'Objetivo semanal';

  @override
  String get homeWeeklyGoalBody =>
      'Mantened el consumo por debajo de 130 kWh para consolidaros dentro del top 3.';

  @override
  String get twinTitle => 'Twin Building';

  @override
  String get twinIntroTitle => 'Administradores de edificios comparables';

  @override
  String twinIntroBody(String buildingName) {
    return 'Contacta con administradores de finca de edificios similares a $buildingName para compartir experiencias sobre mejoras energéticas, votaciones y gestión comunitaria.';
  }

  @override
  String get twinEmptyTitle =>
      'No hay administradores comparables disponibles.';

  @override
  String get twinEmptyBody =>
      'Puede que el edificio aún no tenga un grupo comparable o que no haya otros edificios administrados dentro del mismo grupo.';

  @override
  String twinChannelName(String address) {
    return 'Twin Building con $address';
  }

  @override
  String twinChannelDescription(String adminName, String address) {
    return 'Conversación con $adminName, administrador de $address.';
  }

  @override
  String twinPoints(String points) {
    return '$points pts';
  }

  @override
  String get twinTypologyFallback => 'Tipología';

  @override
  String twinClimateZone(String zone) {
    return 'Zona $zone';
  }

  @override
  String twinAdminLine(String adminName) {
    return 'Admin: $adminName';
  }

  @override
  String get twinOpenChat => 'Abrir chat';

  @override
  String get editProfileTitle => 'Editar perfil';

  @override
  String get editProfilePersonalDataTitle => 'Datos personales';

  @override
  String get editProfilePersonalDataSubtitle =>
      'Actualiza la información básica de tu cuenta.';

  @override
  String get editProfileSaving => 'Guardando...';

  @override
  String get editProfileSaveChanges => 'Guardar cambios';

  @override
  String get editProfileFirstNameRequired => 'El nombre es obligatorio.';

  @override
  String get editProfileLastNameRequired => 'Los apellidos son obligatorios.';

  @override
  String get editProfileEmailRequired =>
      'El correo electrónico es obligatorio.';

  @override
  String get editProfileEmailInvalid =>
      'Introduce un correo electrónico válido.';

  @override
  String get editProfileSuccess => 'Perfil actualizado correctamente.';

  @override
  String get votesCreateTitle => 'Nueva votación';

  @override
  String get votesCreateAction => 'Crear';

  @override
  String get votesTitleLabel => 'Título';

  @override
  String get votesTitleHint => 'Título de la votación';

  @override
  String get votesTitleRequiredError => 'El título es obligatorio.';

  @override
  String get votesTitleMinLengthError =>
      'El título debe tener al menos 4 caracteres.';

  @override
  String get votesDescriptionOptionalLabel => 'Descripción (opcional)';

  @override
  String get votesDescriptionHint => 'Contexto de la votación...';

  @override
  String get votesDeadlineOptionalLabel => 'Fecha límite (opcional)';

  @override
  String get votesNoDeadline => 'Sin fecha límite';

  @override
  String get votesOptionsLabel => 'Opciones';

  @override
  String get votesOptionsLimitHint => 'Mínimo 2 · Máximo 8';

  @override
  String get votesAddOption => 'Añadir opción';

  @override
  String votesOptionHint(int number) {
    return 'Opción $number';
  }

  @override
  String get votesOptionRequiredError => 'Esta opción no puede estar vacía.';

  @override
  String get votesDuplicateOptionsError =>
      'Hay opciones duplicadas. Revísalas.';

  @override
  String get pendingRequestsTitle => 'Solicitudes pendientes';

  @override
  String pendingRequestsIntro(String buildingTitle) {
    return 'Aquí puedes revisar y validar las solicitudes de unión como residente para $buildingTitle.';
  }

  @override
  String pendingRequestsCount(int count) {
    return '$count pendientes';
  }

  @override
  String get pendingRequestsEmptyTitle => 'No hay solicitudes pendientes';

  @override
  String get pendingRequestsEmptyBody =>
      'Cuando otros usuarios pidan unirse a este edificio, aparecerán aquí.';

  @override
  String get pendingRequestsUnexpectedError =>
      'Se ha producido un error inesperado.';

  @override
  String get pendingRequestsForbidden =>
      'Solo el administrador de finca puede gestionar las solicitudes pendientes.';

  @override
  String pendingRequestsAccepted(String name) {
    return 'Se ha aceptado la solicitud de $name.';
  }

  @override
  String pendingRequestsRejected(String name) {
    return 'Se ha rechazado la solicitud de $name.';
  }

  @override
  String get pendingRequestsResidentChip => 'Residente';

  @override
  String get pendingRequestsRequestedRoleLabel => 'Rol solicitado';

  @override
  String get pendingRequestsRoleOwner => 'Propietario';

  @override
  String get pendingRequestsRoleTenant => 'Inquilino';

  @override
  String get pendingRequestsRoleUnknown => 'Rol no especificado';

  @override
  String get pendingRequestsDateLabel => 'Fecha';

  @override
  String get pendingRequestsCadastralReferenceLabel => 'Referencia catastral';

  @override
  String get pendingRequestsHomeLabel => 'Vivienda';

  @override
  String get pendingRequestsSurfaceLabel => 'Superficie';

  @override
  String get pendingRequestsReject => 'Rechazar';

  @override
  String get pendingRequestsAccept => 'Aceptar';

  @override
  String get pendingRequestsNotSpecified => 'No especificado';

  @override
  String pendingRequestsFloorDoor(String floor, String door) {
    return 'Planta $floor · Puerta $door';
  }

  @override
  String pendingRequestsFloor(String floor) {
    return 'Planta $floor';
  }

  @override
  String pendingRequestsDoor(String door) {
    return 'Puerta $door';
  }

  @override
  String get chatReasonOptionalHint => 'Motivo (opcional)';

  @override
  String get chatConfirmActionTitle => 'Confirmar acción';

  @override
  String get chatDurationLabel => 'Duración';

  @override
  String get chatDurationIndefinite => 'Indefinido';

  @override
  String get chatDuration30Minutes => '30 minutos';

  @override
  String get chatDuration1Hour => '1 hora';

  @override
  String get chatDuration6Hours => '6 horas';

  @override
  String get chatDuration24Hours => '24 horas';

  @override
  String get chatReportMessage => 'Reportar mensaje';

  @override
  String get chatHideMessage => 'Ocultar mensaje';

  @override
  String get chatDeleteMyMessage => 'Eliminar mi mensaje';

  @override
  String get chatDeleteMessage => 'Eliminar mensaje';

  @override
  String get chatRestoreMessage => 'Restaurar mensaje';

  @override
  String get chatDismissReport => 'Descartar reporte';

  @override
  String get chatDeleteOwnMessageConfirm =>
      '¿Seguro que quieres eliminar tu mensaje?';

  @override
  String get chatDeleteOtherMessageConfirm =>
      '¿Eliminar el mensaje de este usuario?';

  @override
  String get chatMessageReported => 'Mensaje reportado.';

  @override
  String get chatMessageHidden => 'Mensaje ocultado.';

  @override
  String get chatMessageDeleted => 'Mensaje eliminado.';

  @override
  String get chatMessageRestored => 'Mensaje restaurado.';

  @override
  String get chatReportDismissed => 'Reporte descartado.';

  @override
  String get chatWarnUser => 'Advertir usuario';

  @override
  String get chatMuteUser => 'Silenciar usuario';

  @override
  String get chatBanFromChannel => 'Expulsar del canal';

  @override
  String get chatGlobalBan => 'Expulsión global';

  @override
  String get chatShadowBan => 'Shadow ban';

  @override
  String get chatWarn => 'Advertir';

  @override
  String get chatMute => 'Silenciar';

  @override
  String get chatUnmute => 'Quitar silencio';

  @override
  String get chatReadmitToChannel => 'Readmitir al canal';

  @override
  String get chatLiftGlobalBan => 'Levantar expulsión global';

  @override
  String get chatLiftShadowBan => 'Levantar shadow ban';

  @override
  String get chatWarningSent => 'Advertencia enviada.';

  @override
  String get chatUserMuted => 'Usuario silenciado.';

  @override
  String get chatUserUnmuted => 'Silencio retirado.';

  @override
  String get chatUserBannedFromChannel => 'Usuario expulsado del canal.';

  @override
  String get chatUserUnbannedFromChannel => 'Usuario readmitido en el canal.';

  @override
  String get chatUserGloballyBanned => 'Usuario expulsado globalmente.';

  @override
  String get chatGlobalUnbanConfirm =>
      '¿Levantar la expulsión global de este usuario?';

  @override
  String get chatGlobalBanLifted => 'Expulsión global levantada.';

  @override
  String get chatShadowBanApplied => 'Shadow ban aplicado.';

  @override
  String get chatShadowUnbanConfirm =>
      '¿Levantar el shadow ban de este usuario?';

  @override
  String get chatShadowBanLifted => 'Shadow ban levantado.';

  @override
  String chatCommunityTitle(String buildingName) {
    return 'Comunidad de $buildingName';
  }

  @override
  String get chatCommunitySubtitle =>
      'Habla con los miembros de este edificio sobre mejoras, incidencias y propuestas.';

  @override
  String get chatContactSimilarAdmins => 'Contactar admins similares';

  @override
  String get mapTitle => 'Mapa de edificios';

  @override
  String get mapSearchHint => 'Busca por calle, barrio o código postal';

  @override
  String get mapSearchTooltip => 'Buscar';

  @override
  String get mapFilterAll => 'Todos';

  @override
  String mapFilterMinScore(int score) {
    return '≥ $score';
  }

  @override
  String get mapNoValidCoordinates =>
      'No hay edificios con coordenadas válidas para mostrar.';

  @override
  String mapShownOfCount(int shown, int count) {
    return '$shown de $count edificios mostrados';
  }

  @override
  String mapShownCount(int shown) {
    return '$shown edificios en el mapa';
  }

  @override
  String get mapLoadError => 'No se ha podido cargar el mapa.';

  @override
  String get profileUserFallback => 'Usuario';

  @override
  String get profileRoleAdmin => 'Administrador de finca';

  @override
  String get profileRoleOwner => 'Propietario';

  @override
  String get profileRoleTenant => 'Inquilino';

  @override
  String get profileAdminBuildingsTitle => 'Edificios administrados';

  @override
  String get profileOwnerBuildingsTitle => 'Edificios de mis viviendas';

  @override
  String get profileTenantBuildingsTitle => 'Edificios vinculados';

  @override
  String get profileAccessibleBuildingsTitle => 'Edificios accesibles';

  @override
  String get profileEmptyAdminBuildings =>
      'Aún no tienes ningún edificio asignado como administrador de finca. Puedes crear uno con el formulario de alta.';

  @override
  String get profileEmptyOwnerBuildings =>
      'Aún no tienes viviendas vinculadas a tu cuenta. Cuando un administrador te asigne una vivienda, aquí verás el edificio correspondiente.';

  @override
  String get profileEmptyTenantBuildings =>
      'Aún no tienes ninguna vivienda vinculada a tu cuenta. Cuando se te asigne una vivienda, aquí verás el edificio correspondiente.';

  @override
  String get profileEmptyAccessibleBuildings =>
      'Aún no hay edificios disponibles para esta cuenta.';

  @override
  String get profileBuildingCreated => 'Edificio creado correctamente.';

  @override
  String get profileLogoutTooltip => 'Cerrar sesión';

  @override
  String get profileCreateBuilding => 'Crear edificio';

  @override
  String get profileNonAdminInfo =>
      'Esta cuenta puede consultar los edificios vinculados a sus viviendas. La creación y administración de edificios queda reservada a los administradores de finca.';

  @override
  String get profileMapSubtitle =>
      'Visualiza los edificios registrados y consulta sus estadísticas principales.';

  @override
  String get profileLinkNewBuilding => 'Vincular nuevo edificio';

  @override
  String get profileLoadError => 'No se ha podido cargar el perfil.';

  @override
  String get profileMetricBuildings => 'EDIFICIOS';

  @override
  String get profileMetricLinks => 'VÍNCULOS';

  @override
  String get profileBadgesTitle => 'Insignias de edificios';

  @override
  String get profileBadgesBody =>
      'Las insignias reales se muestran dentro de la ficha de cada edificio. Cuando un edificio cumpla criterios de puntuación, calidad de datos o mejora, aparecerán en su detalle.';

  @override
  String profileBuildingNumber(int id) {
    return 'Edificio #$id';
  }

  @override
  String get profileLocationUnavailable => 'Localización no disponible';

  @override
  String get profileInactive => 'Inactivo';

  @override
  String get profileActive => 'Activo';

  @override
  String get accountBlockedTitle => 'Cuenta bloqueada';

  @override
  String get accountBlockedBody =>
      'Tu cuenta ha sido bloqueada permanentemente. Contacta con el administrador para obtener más información.';

  @override
  String get accountSuspendedTitle => 'Cuenta suspendida';

  @override
  String get accountSuspendedBody =>
      'Tu cuenta está suspendida temporalmente. Contacta con el administrador para obtener más información.';

  @override
  String get accountBackToLogin => 'Volver al inicio de sesión';

  @override
  String get appName => 'BuildRank';

  @override
  String get commonUnavailable => 'No disponible';

  @override
  String get commonUnknownError => 'Error desconocido.';

  @override
  String get commonRequiredField => 'Campo obligatorio';

  @override
  String get commonInvalidNumber => 'Introduce un número válido';

  @override
  String get commonGreaterThanZero => 'Debe ser superior a 0';

  @override
  String get commonContinue => 'Continuar →';

  @override
  String get mainNavHome => 'Inicio';

  @override
  String get mainNavLeagues => 'Ligas';

  @override
  String get mainNavSimulate => 'Simula';

  @override
  String get mainNavChat => 'Chat';

  @override
  String get mainNavVotes => 'Votaciones';

  @override
  String get habitatgeCadastralReference => 'Referencia catastral';

  @override
  String get habitatgeFloor => 'Planta';

  @override
  String get habitatgeDoor => 'Puerta';

  @override
  String get habitatgeSurface => 'Superficie (m²)';

  @override
  String get addExistingAppBarTitle => 'Vincular edificio';

  @override
  String get addExistingTitle => 'Vincúlate a un edificio existente';

  @override
  String get addExistingAdminSubtitle =>
      'Cuando selecciones un edificio, se enviará una solicitud para vincularte como administrador de finca.';

  @override
  String get addExistingResidentSubtitle =>
      'Cuando selecciones un edificio, se enviará una solicitud de unión al administrador de finca para que pueda validarte como residente.';

  @override
  String get addExistingLocationSection => 'Ubicación';

  @override
  String get addExistingSearchHint => 'Escribe la calle de tu edificio...';

  @override
  String get addExistingMinSearch =>
      'Introduce al menos 3 caracteres para empezar la búsqueda.';

  @override
  String get addExistingResultsTitle => 'Resultados';

  @override
  String get addExistingNoResults =>
      'No se ha encontrado ningún edificio con esta dirección.';

  @override
  String addExistingSelectedBuilding(String buildingName, String role) {
    return 'Seleccionado: $buildingName · Rol solicitado: $role';
  }

  @override
  String get addExistingClosedRequests =>
      'Este edificio no admite nuevas solicitudes de unión en este momento.';

  @override
  String get addExistingHabitatgeTitle => 'Datos de la vivienda';

  @override
  String get addExistingHabitatgeSubtitle =>
      'Completa los datos de tu vivienda para enviar la solicitud de unión.';

  @override
  String get addExistingSubmit => 'Enviar solicitud';

  @override
  String get addExistingAdminRequestSent =>
      'Se ha enviado la solicitud para vincularte como administrador de finca.';

  @override
  String get addExistingResidentRequestSent =>
      'Se ha enviado la solicitud de unión al administrador de finca.';

  @override
  String get rankingLoadError => 'No se ha podido cargar el ranking.';

  @override
  String get rankingLoadMoreError =>
      'No se han podido cargar más competidores.';

  @override
  String get rankingProgressLoadError =>
      'No se ha podido cargar la evolución del progreso.';

  @override
  String get rankingScopeLeague => 'Mi liga';

  @override
  String get rankingScopeComparableLeague => 'Liga similar';

  @override
  String get rankingScopeComparableSeason => 'Temporada similar';

  @override
  String get rankingUnavailableTitle => 'Ranking no disponible';

  @override
  String get rankingLoadErrorTitle => 'No se ha podido cargar el ranking';

  @override
  String rankingActiveSeason(String seasonName) {
    return 'Temporada activa: $seasonName';
  }

  @override
  String rankingProgressToTop(int target) {
    return 'Progreso hacia el Top $target';
  }

  @override
  String rankingPointsProgress(String currentPoints, String targetPoints) {
    return '$currentPoints / $targetPoints puntos';
  }

  @override
  String get rankingSeasonPendingCalendar =>
      'Temporada pendiente de calendario.';

  @override
  String rankingCurrentPosition(int position) {
    return 'Posición actual: #$position';
  }

  @override
  String get rankingComparisonPeriod => 'Periodo de comparación';

  @override
  String rankingLastSeasons(int count) {
    return 'Últimas $count';
  }

  @override
  String rankingTopTarget(int target) {
    return 'Top $target';
  }

  @override
  String get rankingSearchHint => 'Buscar por calle...';

  @override
  String get rankingNoCompetitors =>
      'No se ha encontrado ningún competidor con estos filtros.';

  @override
  String get rankingLoadMore => 'Cargar más competidores';

  @override
  String get rankingNoProgressHistory =>
      'Todavía no hay historial de progreso para este edificio.';

  @override
  String get rankingSeasonProgressTitle => 'Progreso de temporadas';

  @override
  String rankingSeasonProgressSubtitle(int count) {
    return 'Evolución real durante las últimas $count temporadas disponibles.';
  }

  @override
  String rankingProgressForBuilding(String buildingName) {
    return 'Progreso de $buildingName';
  }

  @override
  String rankingProgressModalSubtitle(int count) {
    return 'Evolución de puntuación durante las últimas $count temporadas.';
  }

  @override
  String rankingAccumulatedImprovement(int delta) {
    return 'Mejora acumulada: +$delta puntos';
  }

  @override
  String rankingPointsRange(int startPoints, int currentPoints) {
    return '$startPoints → $currentPoints puntos';
  }

  @override
  String rankingDeltaPoints(String deltaText) {
    return '$deltaText pts';
  }

  @override
  String get rankingViewDetail => 'Ver detalle';

  @override
  String get buildingCardDetailLoadError =>
      'No se ha podido cargar el detalle del edificio.';

  @override
  String get buildingCardBadgesRecalculated =>
      'Insignias recalculadas correctamente.';

  @override
  String get buildingCardBadgesLoadError =>
      'No se han podido cargar las insignias.';

  @override
  String get buildingCardLoadError => 'No se ha podido cargar el edificio.';

  @override
  String buildingCardClimateZone(String zone) {
    return 'Zona climática $zone';
  }

  @override
  String get buildingCardScoreExcellent => 'EXCELENTE';

  @override
  String get buildingCardScoreGood => 'BUENO';

  @override
  String get buildingCardScoreImprove => 'MEJORABLE';

  @override
  String get buildingCardScorePriority => 'PRIORITARIO';

  @override
  String get buildingCardEstimatedRating => 'CALIFICACIÓN ESTIMADA';

  @override
  String buildingCardPendingData(String items) {
    return 'Datos pendientes: $items';
  }

  @override
  String get buildingCardBaseScore => 'Puntuación base BuildRank';

  @override
  String get buildingCardPerformance => 'RENDIMIENTO';

  @override
  String get buildingCardInitialData => 'Datos iniciales';

  @override
  String get buildingCardSurface => 'SUPERFICIE';

  @override
  String get buildingCardFloors => 'PLANTAS';

  @override
  String get buildingCardOrientation => 'ORIENTACIÓN';

  @override
  String get buildingCardBadgesTitle => 'INSIGNIAS DEL EDIFICIO';

  @override
  String get buildingCardRecalculate => 'Recalcular';

  @override
  String get buildingCardNoBadges =>
      'Este edificio todavía no tiene insignias asignadas. Se mostrarán cuando cumpla algún hito.';

  @override
  String get buildingCardRecommendedActions => 'ACCIONES RECOMENDADAS';

  @override
  String get buildingCardActionManageRequestsTitle =>
      'Gestionar solicitudes pendientes';

  @override
  String get buildingCardActionManageRequestsSubtitle =>
      'Revisa y valida nuevas peticiones de unión al edificio';

  @override
  String get buildingCardActionEditHabitatgeTitle => 'Editar mi vivienda';

  @override
  String get buildingCardActionEditHabitatgeSubtitle =>
      'Completa superficie, reforma y datos energéticos';

  @override
  String get buildingCardTabDetails => 'Detalles';

  @override
  String get buildingCardTabHistory => 'Historial';

  @override
  String get buildingCardTabDocuments => 'Documentos';

  @override
  String get buildingCardHistoryUnavailableTitle =>
      'Historial aún no disponible';

  @override
  String get buildingCardHistoryUnavailableBody =>
      'En esta sección se mostrarán cambios de puntuación, validaciones y simulaciones guardadas.';

  @override
  String get buildingCardDocumentsSoonTitle =>
      'Documentos e informes (próximamente)';

  @override
  String get buildingCardDocumentsSoonBody =>
      'Esta sección queda preparada para una futura integración documental. En este MVP no se muestran documentos ni informes generados.';

  @override
  String get buildingCardConstructionYear => 'AÑO DE CONSTRUCCIÓN';

  @override
  String buildingCardFloorsCount(String count) {
    return '$count plantas';
  }

  @override
  String get buildingCardTypology => 'TIPOLOGÍA';

  @override
  String get buildingCardRegulation => 'NORMATIVA';

  @override
  String get buildingCardNoLocation =>
      'Este edificio todavía no tiene ubicación asociada.';

  @override
  String buildingCardLocationSummary(
    String street,
    String number,
    String neighborhood,
    String postalCode,
  ) {
    return 'Ubicación: $street, $number · $neighborhood · $postalCode';
  }

  @override
  String get buildingFormStreetMinChars =>
      'Escribe al menos 2 caracteres para buscar la calle.';

  @override
  String buildingFormNoStreetFound(String query) {
    return 'No se ha encontrado ninguna calle con “$query”.';
  }

  @override
  String get buildingFormStreetSuggestionsError =>
      'No se han podido cargar las sugerencias de calles.';

  @override
  String get buildingFormPostalCodeRequired =>
      'El código postal es obligatorio.';

  @override
  String get buildingFormPostalCodeInvalid =>
      'El código postal debe tener 5 dígitos.';

  @override
  String get buildingFormNeighborhoodRequired =>
      'El campo barrio es obligatorio.';

  @override
  String get buildingFormStreetRequired =>
      'El nombre de la calle es obligatorio.';

  @override
  String get buildingFormStreetSelectionRequired =>
      'Selecciona una calle de la lista de sugerencias.';

  @override
  String get buildingFormNumberRequired => 'El número es obligatorio.';

  @override
  String get buildingFormNumberPositive =>
      'El número de la calle debe ser un entero positivo.';

  @override
  String buildingFormNumberOutOfRange(int minNumber, int maxNumber) {
    return 'El número no está dentro del rango permitido para esta calle ($minNumber-$maxNumber).';
  }

  @override
  String get buildingFormTypeRequired => 'Debes seleccionar una tipología.';

  @override
  String get buildingFormConstructionYearRequired =>
      'El año de construcción es obligatorio.';

  @override
  String get buildingFormConstructionYearInteger =>
      'El año de construcción debe ser un número entero.';

  @override
  String buildingFormConstructionYearRange(int currentYear) {
    return 'El año de construcción debe estar entre 1800 y $currentYear.';
  }

  @override
  String get buildingFormRegulationRequired =>
      'La normativa vigente es obligatoria.';

  @override
  String get buildingFormFloorsRequired =>
      'El número de plantas es obligatorio.';

  @override
  String get buildingFormFloorsPositive =>
      'El número de plantas debe ser un entero positivo.';

  @override
  String get buildingFormSurfaceRequired =>
      'La superficie total es obligatoria.';

  @override
  String get buildingFormSurfacePositive =>
      'La superficie total debe ser un número positivo.';

  @override
  String get buildingFormOrientationRequired =>
      'Debes seleccionar una orientación principal.';

  @override
  String get buildingFormDocumentsRequired =>
      'Hay que adjuntar al menos un documento de verificación.';

  @override
  String get buildingFormCreatedMissingId =>
      'El edificio se ha creado, pero la respuesta no contiene ningún identificador reconocible.';

  @override
  String get buildingFormSubmitSuccess =>
      'Edificio creado y documentación enviada. Queda pendiente de revisión.';

  @override
  String get buildingFormUnexpectedSaveError =>
      'Se ha producido un error inesperado al guardar el edificio.';

  @override
  String get buildingFormTypeResidential => 'Residencial';

  @override
  String get buildingFormTypeCommercial => 'Comercial';

  @override
  String get buildingFormTypeEducational => 'Educativo';

  @override
  String get buildingFormTypeHealthcare => 'Sanitario';

  @override
  String get buildingFormTypeMixed => 'Mixto';

  @override
  String get buildingFormTypeResidentialSubtitle => 'Unifamiliar o pisos';

  @override
  String get buildingFormTypeCommercialSubtitle => 'Oficinas, comercios...';

  @override
  String get buildingFormTypeEducationalSubtitle => 'Escuelas';

  @override
  String get buildingFormTypeHealthcareSubtitle => 'Hospitales';

  @override
  String get buildingFormTypeMixedSubtitle => 'Usos combinados';

  @override
  String get orientationNorth => 'Norte';

  @override
  String get orientationSouth => 'Sur';

  @override
  String get orientationEast => 'Este';

  @override
  String get orientationWest => 'Oeste';

  @override
  String get buildingFormNewBuildingChip => 'Nuevo edificio';

  @override
  String get buildingFormTitle => 'Registra el edificio';

  @override
  String get buildingFormStep1Subtitle =>
      'Empecemos por la ubicación del edificio.';

  @override
  String get buildingFormStep2Subtitle =>
      'Ahora completa la información general.';

  @override
  String get buildingFormStep3Subtitle => 'Añade los datos técnicos básicos.';

  @override
  String get buildingFormStep4Subtitle =>
      'Adjunta la documentación para validarte como administrador de finca.';

  @override
  String get buildingFormLocationSection => 'UBICACIÓN';

  @override
  String get buildingFormPostalCodeLabel => 'Código postal';

  @override
  String get buildingFormPostalCodeHint => 'p. ej., 08025';

  @override
  String get buildingFormOr => 'o';

  @override
  String get buildingFormNeighborhoodLabel => 'Barrio';

  @override
  String get buildingFormNeighborhoodHint => 'p. ej., Sagrada Família';

  @override
  String get buildingFormStreetLabel => 'Nombre de la calle';

  @override
  String get buildingFormStreetHint => 'Empieza a escribir la calle';

  @override
  String buildingFormStreetNumberRange(int minNumber, int maxNumber) {
    return 'Números $minNumber-$maxNumber';
  }

  @override
  String get buildingFormStreetRangeUnknown =>
      'Rango de numeración no informado';

  @override
  String get buildingFormNumberLabel => 'Número';

  @override
  String get buildingFormNumberHint => 'p. ej., 123';

  @override
  String get buildingFormLocationInfo =>
      'Selecciona una calle de la lista de sugerencias. Al guardar, BuildRank creará primero la ubicación y después el edificio vinculado a tu cuenta de administrador.';

  @override
  String get buildingFormGeneralSection => 'INFORMACIÓN GENERAL';

  @override
  String get buildingFormRegisteredLocation => 'Ubicación registrada';

  @override
  String get buildingFormAddressLabel => 'Dirección';

  @override
  String get buildingFormTypeLabel => 'Tipología del edificio';

  @override
  String get buildingFormConstructionYearLabel => 'Año de construcción';

  @override
  String get buildingFormConstructionYearHint => 'p. ej., 1998';

  @override
  String get buildingFormRegulationLabel => 'Normativa vigente';

  @override
  String get buildingFormRegulationHint => 'p. ej., CTE';

  @override
  String get buildingFormTechnicalSection => 'DATOS TÉCNICOS';

  @override
  String get buildingFormBuildingSummary => 'Resumen del edificio';

  @override
  String get buildingFormConstructionYearSummaryLabel => 'Año de construcción';

  @override
  String get buildingFormRegulationSummaryLabel => 'Normativa';

  @override
  String get buildingFormFloorsLabel => 'Número de plantas';

  @override
  String get buildingFormFloorsHint => 'p. ej., 6';

  @override
  String get buildingFormSurfaceLabel => 'Superficie total (m²)';

  @override
  String get buildingFormSurfaceHint => 'p. ej., 850';

  @override
  String get buildingFormOrientationLabel => 'Orientación principal';

  @override
  String get buildingFormOrientationHint => 'Selecciona una orientación';

  @override
  String get buildingFormDocumentationSection => 'DOCUMENTACIÓN';

  @override
  String get buildingFormBuildingToVerify => 'Edificio a verificar';

  @override
  String get buildingFormSubmittingDocuments => 'Enviando documentación...';

  @override
  String get buildingFormSubmit => 'Crear edificio y enviar verificación';

  @override
  String get editHabitatgeNoLinkedHome =>
      'No se ha encontrado ninguna vivienda vinculada a tu usuario en este edificio.';

  @override
  String get editHabitatgeNoneSelected =>
      'No se ha seleccionado ninguna vivienda para editar.';

  @override
  String get editHabitatgeMissingCadastralReference =>
      'La vivienda seleccionada no tiene referencia catastral.';

  @override
  String get editHabitatgeLoadError => 'No se ha podido cargar la vivienda.';

  @override
  String get editHabitatgeSelectorTitle => '¿Qué vivienda quieres editar?';

  @override
  String editHabitatgeSelectorFloorDoor(String floor, String door) {
    return 'Planta $floor · Puerta $door';
  }

  @override
  String get editHabitatgeEnergyRequired =>
      'Campo obligatorio si informas datos energéticos';

  @override
  String get editHabitatgeEnergyDateRequired =>
      'Debes informar la fecha de entrada si informas datos energéticos';

  @override
  String get editHabitatgeSaveWithEnergySuccess =>
      'Datos de la vivienda y datos energéticos actualizados.';

  @override
  String get editHabitatgeSaveSuccess => 'Datos de la vivienda actualizados.';

  @override
  String get editHabitatgeAppBarTitle => 'Editar vivienda';

  @override
  String get editHabitatgeCannotEditTitle => 'No se puede editar la vivienda';

  @override
  String get editHabitatgeSaveButton => 'Guardar datos';

  @override
  String get editHabitatgeIntroTitle => 'Completa los datos de tu vivienda';

  @override
  String get editHabitatgeIntroBody =>
      'Estos datos ayudarán a calcular mejor la calificación estimada y la puntuación BuildRank del edificio.';

  @override
  String get editHabitatgeHomeDataTitle => 'Datos de la vivienda';

  @override
  String get editHabitatgeHomeDataSubtitle =>
      'Información básica de la vivienda vinculada a tu cuenta.';

  @override
  String get editHabitatgeRenovationYear => 'Año de reforma';

  @override
  String get editHabitatgeInvalidYear => 'Introduce un año válido';

  @override
  String get editHabitatgeYearOutOfRange => 'El año no es válido';

  @override
  String get editHabitatgeEnergyDataTitle => 'Datos energéticos';

  @override
  String get editHabitatgeEnergyDataSubtitle =>
      'Añade la información disponible del certificado o estimación energética.';

  @override
  String get editHabitatgeEnergyOptionalNotice =>
      'Los datos energéticos son opcionales. Si informas cualquier campo de esta sección, deberás rellenar todos los campos obligatorios del certificado energético.';

  @override
  String get editHabitatgeGlobalRating => 'Calificación global';

  @override
  String get editHabitatgePrimaryEnergyConsumption =>
      'Consumo de energía primaria (kWh/(m²·año))';

  @override
  String get editHabitatgeFinalEnergyConsumption =>
      'Consumo de energía final (kWh/(m²·año))';

  @override
  String get editHabitatgeCo2Emissions => 'Emisiones CO₂ (kg CO₂/(m²·año))';

  @override
  String get editHabitatgeAnnualEnergyCost => 'Coste anual de energía (€)';

  @override
  String get editHabitatgeConsumptionByUse => 'Consumos por uso';

  @override
  String get editHabitatgeHeatingEnergy =>
      'Energía de calefacción (kWh/(m²·año))';

  @override
  String get editHabitatgeCoolingEnergy =>
      'Energía de refrigeración (kWh/(m²·año))';

  @override
  String get editHabitatgeAcsEnergy => 'Energía ACS (kWh/(m²·año))';

  @override
  String get editHabitatgeLightingEnergy =>
      'Energía de iluminación (kWh/(m²·año))';

  @override
  String get editHabitatgeEmissionsByUse => 'Emisiones por uso';

  @override
  String get editHabitatgeHeatingEmissions =>
      'Emisiones de calefacción (kg CO₂/(m²·año))';

  @override
  String get editHabitatgeCoolingEmissions =>
      'Emisiones de refrigeración (kg CO₂/(m²·año))';

  @override
  String get editHabitatgeAcsEmissions => 'Emisiones ACS (kg CO₂/(m²·año))';

  @override
  String get editHabitatgeLightingEmissions =>
      'Emisiones de iluminación (kg CO₂/(m²·año))';

  @override
  String get editHabitatgeCertificationEnvelope => 'Certificación y envolvente';

  @override
  String get editHabitatgeThermalInsulation => 'Aislamiento térmico (W/(m²·K))';

  @override
  String get editHabitatgeWindowValue => 'Valor de ventanas (W/(m²·K))';

  @override
  String get editHabitatgeCertificationTool => 'Herramienta de certificación';

  @override
  String get editHabitatgeCertificationReason => 'Motivo de certificación';

  @override
  String get editHabitatgeEnergyRenovation => 'Rehabilitación energética';

  @override
  String get editHabitatgeSelectEntryDate => 'Seleccionar fecha de entrada *';

  @override
  String editHabitatgeEntryDate(String date) {
    return 'Fecha de entrada: $date';
  }

  @override
  String get adminAuditTitle => 'Registro de auditoría';

  @override
  String get adminAuditEmpty => 'No se ha encontrado ningún registro.';

  @override
  String get adminAuditUserId => 'ID usuario';

  @override
  String get adminAuditMethod => 'Método';

  @override
  String get adminAuditResourceType => 'Tipo de recurso';

  @override
  String get adminAuditHttpCode => 'Código HTTP';

  @override
  String get adminAuditFromDate => 'Desde';

  @override
  String get adminAuditToDate => 'Hasta';

  @override
  String get adminAuditClear => 'Limpiar';

  @override
  String get adminAuditApplyFilters => 'Aplicar filtros';

  @override
  String get adminAuditAll => 'Todos';

  @override
  String adminAuditPageRange(int firstItem, int lastItem, int totalCount) {
    return '$firstItem-$lastItem de $totalCount';
  }

  @override
  String adminAuditPage(int page) {
    return 'Pág. $page';
  }

  @override
  String get adminAuditPreviousPage => 'Página anterior';

  @override
  String get adminAuditNextPage => 'Página siguiente';

  @override
  String get simulationCatalogLoadError =>
      'No se ha podido cargar el catálogo de mejoras.';

  @override
  String get simulationHistoryLoadError =>
      'No se ha podido cargar el historial de simulaciones.';

  @override
  String get simulationCalculateError =>
      'No se ha podido calcular la simulación.';

  @override
  String get simulationSaveError => 'No se ha podido guardar la simulación.';

  @override
  String get simulationSavedSnack => 'Simulación guardada correctamente.';

  @override
  String get simulationTitle => 'Simulador de mejoras';

  @override
  String get simulationCurrent => 'Actual';

  @override
  String get simulationSimulated => 'Simulado';

  @override
  String get simulationDisclaimer =>
      'Los resultados son estimaciones orientativas. No sustituyen una auditoría energética profesional.';

  @override
  String get simulationTabSimulate => 'Simular';

  @override
  String get simulationTabSaved => 'Guardadas';

  @override
  String get simulationTabImplemented => 'Aplicadas';

  @override
  String get simulationCatalogTitle => 'Catálogo de mejoras';

  @override
  String simulationSelectedCount(int count) {
    return '$count seleccionadas';
  }

  @override
  String get simulationSavedTitle => 'Simulaciones guardadas';

  @override
  String get simulationNoSaved =>
      'Todavía no hay simulaciones guardadas para este edificio. Calcula una previsualización y pulsa “Guardar simulación”.';

  @override
  String get simulationImplementedTitle => 'Mejoras aplicadas';

  @override
  String get simulationNoImplemented =>
      'Todavía no hay mejoras aplicadas registradas. Las simulaciones guardadas son escenarios; las aplicadas representan actuaciones realmente ejecutadas o en validación.';

  @override
  String get simulationCalculatingPreview => 'Calculando preview...';

  @override
  String get simulationCalculatePreview => 'Calcular preview';

  @override
  String get simulationSaving => 'Guardando simulación...';

  @override
  String get simulationSave => 'Guardar simulación';

  @override
  String get simulationReadOnlyRole =>
      'Este rol puede consultar la previsualización, pero la gestión formal de simulaciones queda reservada al administrador de finca.';

  @override
  String get simulationResultTitle => 'Resultado de la simulación';

  @override
  String get simulationAnnualConsumption => 'Consumo anual';

  @override
  String get simulationEstimatedAnnualCost => 'Coste anual estimado';

  @override
  String simulationSavings(String amount) {
    return 'Ahorro $amount';
  }

  @override
  String get simulationScore => 'Puntuación';

  @override
  String simulationPointsDelta(String points) {
    return '+$points puntos';
  }

  @override
  String simulationTotalCostAndEngine(String cost, String engine) {
    return 'Coste total estimado: $cost · Motor $engine';
  }

  @override
  String simulationDateAndEngine(String date, String engine) {
    return 'Fecha: $date · Motor $engine';
  }

  @override
  String simulationCost(String cost) {
    return 'Coste $cost';
  }

  @override
  String simulationRealCost(String cost) {
    return 'Coste real $cost';
  }

  @override
  String simulationExecutionDate(String date) {
    return 'Ejecución: $date';
  }

  @override
  String get simulationEmptyCatalog =>
      'Todavía no hay mejoras activas en el catálogo. Carga la semilla de mejoras en el backend.';

  @override
  String altSimulationPreparedSnack(int count) {
    return 'Simulación preparada para presentar a votación con $count mejora(s).';
  }

  @override
  String get altSimulationSelectUpdates => 'Seleccionar\nactualizaciones';

  @override
  String get altSimulationDetailedImpact => 'Impacto detallado';

  @override
  String get altSimulationPresentVote => 'Presentar a votación';

  @override
  String get altSimulationLive => 'SIMULACIÓN EN DIRECTO';

  @override
  String get altSimulationExpectedPerformance => 'Rendimiento previsto';

  @override
  String get altSimulationImpact => 'IMPACTO';

  @override
  String get altSimulationEstimatedCost => 'COSTE\nESTIM.';

  @override
  String get altSimulationOperationalForecast => 'PREVISIÓN OPERATIVA';

  @override
  String get altSimulationAnnualEnergyCost => 'Coste energético anual';

  @override
  String get altSimulationCarbonFootprint => 'Huella de carbono';

  @override
  String get altSimulationEnergyIntensity => 'Intensidad energética';

  @override
  String get altSimulationTotalInvestment => 'INVERSIÓN TOTAL';

  @override
  String get altSimulationAnnualSavings => 'AHORRO ANUAL';

  @override
  String get altSimulationPaybackPeriod => 'PERIODO DE RETORNO';

  @override
  String altSimulationYears(String years) {
    return '$years años';
  }

  @override
  String get altSimulationSolarTitle => 'Panel solar fotovoltaico';

  @override
  String get altSimulationSolarSubtitle => 'Cubierta de 10 kW';

  @override
  String get altSimulationGlazingTitle => 'Triple vidrio';

  @override
  String get altSimulationGlazingSubtitle => 'Alto rendimiento';

  @override
  String get altSimulationInsulationTitle => 'Aislamiento de pared';

  @override
  String get altSimulationInsulationSubtitle => 'Mineral exterior';

  @override
  String get altSimulationHeatPumpTitle => 'Bomba de calor';

  @override
  String get altSimulationHeatPumpSubtitle => 'Sistema eficiente aire-agua';

  @override
  String get votesStatusOpen => 'Abierta';

  @override
  String get votesStatusClosed => 'Cerrada';

  @override
  String get votesStatusArchived => 'Archivada';

  @override
  String get votesStatusCancelled => 'Cancelada';

  @override
  String get votesRetry => 'Volver a intentarlo';

  @override
  String votesCount(int count) {
    return '$count votos';
  }

  @override
  String votesCountSingular(int count) {
    return '$count voto';
  }

  @override
  String get votesSelectOptionSnack => 'Selecciona una opción para votar.';

  @override
  String get votesRegisteredSnack => 'Voto registrado correctamente.';

  @override
  String get votesDeleteTitle => 'Eliminar votación';

  @override
  String get votesDeleteBody =>
      '¿Seguro que quieres eliminar esta votación? Se borrarán todas las opciones y votos emitidos. Esta acción no se puede deshacer.';

  @override
  String get votesCancel => 'Cancelar';

  @override
  String get votesDelete => 'Eliminar';

  @override
  String get votesFallbackTitle => 'Votación';

  @override
  String get votesEdit => 'Editar';

  @override
  String votesUntilDate(String date) {
    return 'Hasta el $date';
  }

  @override
  String get votesSelectOption => 'Selecciona una opción';

  @override
  String get votesOptions => 'Opciones';

  @override
  String get votesPermissionOnlyOwners =>
      'Solo los propietarios y administradores de finca vinculados a este edificio pueden votar.';

  @override
  String get votesVote => 'Votar';

  @override
  String get votesViewResults => 'Ver resultados';

  @override
  String get votesResults => 'Resultados';

  @override
  String votesTotal(int count) {
    return 'Total: $count votos';
  }

  @override
  String votesTotalSingular(int count) {
    return 'Total: $count voto';
  }

  @override
  String get votesEditTitle => 'Editar votación';

  @override
  String get votesSave => 'Guardar';

  @override
  String get votesSaveChanges => 'Guardar cambios';

  @override
  String get votesMinimumOptionsSnack => 'Hace falta un mínimo de 2 opciones.';

  @override
  String get votesDuplicateOptionsSnack =>
      'Hay opciones duplicadas. Revísalas.';

  @override
  String get votesTitleRequired => 'El título es obligatorio.';

  @override
  String get votesTitleMinLength =>
      'El título debe tener al menos 4 caracteres.';

  @override
  String get votesDescriptionOptional => 'Descripción (opcional)';

  @override
  String get votesDeadline => 'Fecha límite';

  @override
  String get votesOptionsRange => 'Mínimo 2 · Máximo 8';

  @override
  String get votesOptionsWarning =>
      'Atención: modificar las opciones puede afectar a los votos existentes.';

  @override
  String get votesState => 'Estado';

  @override
  String get votesCancelledLocked =>
      'Una votación cancelada no se puede reabrir.';

  @override
  String get votesOptionRequired => 'Esta opción no puede estar vacía.';

  @override
  String get votesListTitle => 'Votación interna';

  @override
  String votesListSubtitle(String buildingName) {
    return 'Toma de decisiones para $buildingName';
  }

  @override
  String get votesGeneralSection => 'VOTACIONES GENERALES';

  @override
  String get votesSimulationSection => 'VOTACIONES DE SIMULACIÓN';

  @override
  String votesTabActive(int count) {
    return 'Activo ($count)';
  }

  @override
  String votesTabCompleted(int count) {
    return 'Completado ($count)';
  }

  @override
  String get votesTabMyProposals => 'Mis propuestas';

  @override
  String get votesTabMyVotes => 'Mis votaciones';

  @override
  String get votesEmptyActive => 'No hay votaciones activas ahora mismo.';

  @override
  String get votesEmptySection => 'No hay votaciones en esta sección.';

  @override
  String get votesEmptyBody =>
      'Cuando el administrador someta una simulación a votación, aparecerá aquí.';

  @override
  String get votesInfoCanVote =>
      'Puedes participar en las votaciones de la comunidad vinculadas a este edificio.';

  @override
  String get votesInfoCannotVote =>
      'Solo propietarios y administradores de finca vinculados al edificio pueden votar.';

  @override
  String get votesRegisteredFavor => 'Voto a favor registrado.';

  @override
  String get votesRegisteredAgainst => 'Voto en contra registrado.';

  @override
  String get votesActive => 'Activa';

  @override
  String get votesEndsToday => 'Finaliza hoy';

  @override
  String votesDaysRemaining(int days) {
    return 'Quedan $days días';
  }

  @override
  String get votesEnergyProposalFallback => 'Propuesta de mejora energética.';

  @override
  String get votesQuorumProgress => 'Progreso del quórum';

  @override
  String get votesQuorumReached => 'Quórum alcanzado';

  @override
  String get votesNeedMoreParticipation => 'Hace falta más participación';

  @override
  String get votesVoteSection => 'VOTA';

  @override
  String get votesFavor => 'A favor';

  @override
  String get votesAgainst => 'En contra';

  @override
  String votesEstimatedCostSaving(String cost, String saving) {
    return 'Coste estimado $cost € +$saving €/año';
  }

  @override
  String get votesKeepCurrentState => 'Mantener el estado actual';

  @override
  String votesYourVote(String vote) {
    return 'Tu voto: $vote';
  }

  @override
  String get votesPendingVote => 'Pendiente de voto';

  @override
  String get votesNotReported => 'no informado';

  @override
  String adminUsersSuspendTitle(String email) {
    return 'Suspender $email';
  }

  @override
  String get adminUsersReasonLabel => 'Motivo (opcional)';

  @override
  String get adminUsersReasonHint => 'Describe el motivo de la suspensión...';

  @override
  String get adminUsersEndDate => 'Fecha fin';

  @override
  String get adminUsersRemoveDate => 'Eliminar fecha';

  @override
  String get adminUsersConfirm => 'Confirmar';

  @override
  String get adminUsersTitle => 'Gestión de usuarios';

  @override
  String adminUsersCount(int count) {
    return '$count usuarios';
  }

  @override
  String get adminUsersEmpty => 'No hay usuarios.';

  @override
  String adminUsersReason(String reason) {
    return 'Motivo: $reason';
  }

  @override
  String get adminUsersSuspend => 'Suspender';

  @override
  String get adminHomeVerificationPending => 'Verificaciones pendientes';

  @override
  String get adminHomeSearchHint => 'Buscar edificios o usuarios...';

  @override
  String get adminHomeVerificationQueue => 'Cola de verificación documental';

  @override
  String adminHomePendingCount(int count) {
    return '$count pendientes';
  }

  @override
  String get adminHomeNoPendingVerifications =>
      'No hay verificaciones pendientes';

  @override
  String get adminHomeNoPendingVerificationsBody =>
      'Cuando una verificación termine el procesamiento de IA, aparecerá aquí.';

  @override
  String get adminHomeCreateSeason => 'Crear nueva temporada';

  @override
  String get adminHomeChatsBody =>
      'Accede a los chats de los edificios y aplica acciones de moderación.';

  @override
  String get adminHomeOpenBuildingChats =>
      'Acceder a los chats de los edificios';

  @override
  String get adminHomeUsersTitle => 'Gestión de usuarios';

  @override
  String get adminHomeUsersBody =>
      'Bloquea, suspende y gestiona las cuentas de los usuarios.';

  @override
  String get adminHomeOpenUsers => 'Acceder a la gestión de usuarios';

  @override
  String get adminHomeAnomalyBody =>
      '5 edificios de la categoría \"Comercial\" han presentado datos que superan los puntos de referencia históricos en más de un 20%. Hace falta una auditoría manual.';

  @override
  String get adminHomeUnexpectedVerificationError =>
      'Se ha producido un error inesperado al revisar la verificación.';

  @override
  String get buildingListScoreLabel => 'PUNTUACIÓN BUILDRANK';

  @override
  String get adminHomeChatsModerationTitle => 'Moderación de chats';

  @override
  String get adminHomeAuditButton => 'Auditoría';

  @override
  String get adminHomeLogoutButton => 'Cerrar sesión';

  @override
  String get adminHomeLoggingOut => 'Saliendo...';

  @override
  String get adminHomeNoAccessPermission =>
      'No tienes permisos para acceder al panel de administración del sistema.';

  @override
  String get adminHomeIntegrityAlertTitle => 'Alerta de integridad de datos';

  @override
  String get adminHomeRunAuditNow =>
      'Ejecutar la auditoría de integridad ahora';

  @override
  String get adminHomeRejectionReason => 'Motivo de rechazo';

  @override
  String get adminHomeRejectionHint =>
      'Explica brevemente por qué se rechaza...';

  @override
  String get adminHomeCancel => 'Cancelar';

  @override
  String get adminHomeReject => 'Rechazar';

  @override
  String get adminHomeFiltersPending =>
      'Filtros avanzados pendientes de integración.';

  @override
  String get adminHomeCreateSeasonPending =>
      'Creación de temporada pendiente de integración.';

  @override
  String get adminHomeRolesPending =>
      'Matriz de permisos pendiente de integración.';

  @override
  String get adminHomeApprove => 'Aprobar';

  @override
  String get adminHomeRejected => 'Rechazado';

  @override
  String get adminHomeApproved => 'Aprobado';

  @override
  String adminHomeSeasonStats(String range, int participants) {
    return '$range · $participants edificios';
  }

  @override
  String adminHomeRoleStats(int users, int permissions) {
    return '$users usuarios · $permissions permisos';
  }

  @override
  String adminUsersUntilDate(String date) {
    return 'Hasta: $date';
  }

  @override
  String get adminUsersBlock => 'Bloquear';

  @override
  String get adminUsersUnblock => 'Desbloquear';

  @override
  String get adminUsersUnsuspend => 'Levantar suspensión';

  @override
  String get adminHomePanelTitle => 'Panel de administración';

  @override
  String get adminHomeSeasonManagement => 'Gestión de temporadas';

  @override
  String adminUsersBlockedSnack(String email) {
    return '$email ha sido bloqueado.';
  }

  @override
  String adminUsersUnblockedSnack(String email) {
    return '$email ha sido desbloqueado.';
  }

  @override
  String adminUsersSuspendedSnack(String email) {
    return '$email ha sido suspendido.';
  }

  @override
  String adminUsersUnsuspendedSnack(String email) {
    return 'Se ha levantado la suspensión de $email.';
  }

  @override
  String get adminUsersIndefiniteSuspension => 'Suspensión indefinida';

  @override
  String adminHomeSeasonLabel(int seasonNumber) {
    return 'Temporada $seasonNumber';
  }

  @override
  String get adminHomeActiveUsers => 'Usuarios activos';

  @override
  String get adminHomeValidatedImprovements => 'Mejoras validadas';

  @override
  String get adminHomeIntegrityAlerts => 'Alertas de integridad';

  @override
  String get adminHomeNewTrend => 'Nuevo';

  @override
  String get adminHomeTasksTab => 'Tareas';

  @override
  String get adminHomeSeasonsTab => 'Temporadas';

  @override
  String get adminHomeRolesTab => 'Roles';

  @override
  String get adminHomeVerificationLoadError =>
      'No se han podido cargar las verificaciones';

  @override
  String get adminHomeRefreshVerifications => 'Actualizar verificaciones';

  @override
  String adminHomeRecordsCount(int count) {
    return '$count registros';
  }

  @override
  String adminHomeClosedSeasonsCount(int count) {
    return '$count cerradas';
  }

  @override
  String get adminHomeSeasonsLoading => 'Cargando';

  @override
  String get adminHomeCreateAndStartSeason => 'Crear e iniciar temporada';

  @override
  String get adminHomeCreatingAndStartingSeason =>
      'Creando e iniciando temporada...';

  @override
  String get adminHomeRefreshSeasonHistory => 'Actualizar historial';

  @override
  String get adminHomeRetryLoadSeasons => 'Reintentar cargar temporadas';

  @override
  String get adminHomeSeasonLoadErrorTitle =>
      'No se han podido cargar las temporadas';

  @override
  String get adminHomeSeasonUnexpectedLoadError =>
      'Se ha producido un error inesperado cargando temporadas.';

  @override
  String get adminHomeNoClosedSeasonsTitle => 'No hay temporadas cerradas';

  @override
  String get adminHomeNoClosedSeasonsBody =>
      'Cuando una temporada se cierre aparecerá en este historial.';

  @override
  String get adminHomeSeasonActivationTitle => 'Crear e iniciar temporada';

  @override
  String get adminHomeSeasonActivationBody =>
      'El backend cerrará automáticamente la temporada activa actual, si existe, creará la nueva temporada y actualizará puntuaciones y snapshots del ranking.';

  @override
  String get adminHomeSeasonNameLabel => 'Nombre de la temporada';

  @override
  String get adminHomeSeasonStartDateLabel => 'Fecha de inicio';

  @override
  String get adminHomeSeasonEndDateLabel => 'Fecha de fin';

  @override
  String get adminHomeSeasonSelectStartDate => 'Selecciona la fecha de inicio';

  @override
  String get adminHomeSeasonSelectEndDate => 'Selecciona la fecha de fin';

  @override
  String get adminHomeSeasonNameRequired =>
      'El nombre de la temporada es obligatorio';

  @override
  String get adminHomeSeasonStartDateRequired =>
      'La fecha de inicio es obligatoria';

  @override
  String get adminHomeSeasonEndDateRequired => 'La fecha de fin es obligatoria';

  @override
  String get adminHomeSeasonEndBeforeStart =>
      'La fecha de fin no puede ser anterior a la fecha de inicio';

  @override
  String get adminHomeSeasonActivationConfirm => 'Crear e iniciar';

  @override
  String get adminHomeSeasonActivationDefaultSummary =>
      'Temporada creada e iniciada correctamente.';

  @override
  String adminHomeSeasonActivationSuccess(String summary) {
    return 'Temporada iniciada: $summary';
  }

  @override
  String get adminHomeSeasonActivationUnexpectedError =>
      'Se ha producido un error inesperado creando la temporada.';

  @override
  String get adminHomeSeasonStatusActive => 'ACTIVA';

  @override
  String get adminHomeSeasonStatusClosed => 'CERRADA';

  @override
  String get adminHomeSeasonDatesUnavailable => 'Fechas no disponibles';

  @override
  String adminHomeSeasonStartedOn(String date) {
    return 'Desde $date';
  }

  @override
  String adminHomeSeasonEndedOn(String date) {
    return 'Hasta $date';
  }

  @override
  String get adminHomeRolesAndPermissions => 'Roles y permisos';

  @override
  String adminHomeRolesCount(int count) {
    return '$count roles';
  }

  @override
  String get adminHomeReviewPermissionsMatrix => 'Revisar matriz de permisos';

  @override
  String get adminVerificationDocumentsTitle =>
      'Documentación de administrador';

  @override
  String get adminVerificationDocumentsBody =>
      'Adjunta documentación que acredite que puedes actuar como administrador de finca de este edificio. La verificación quedará pendiente de revisión.';

  @override
  String get adminVerificationAttachDocuments => 'Adjuntar documentos';

  @override
  String get adminVerificationJpgOnly => 'Adjunta documentos en formato JPG.';

  @override
  String get adminVerificationRemoveDocument => 'Eliminar documento';

  @override
  String get adminVerificationDocumentType => 'Tipo de documento';

  @override
  String get weatherLoadError => 'No se ha podido cargar la meteorología.';

  @override
  String get weatherLoadingBarcelona =>
      'Cargando datos meteorológicos de Barcelona...';

  @override
  String weatherCurrentInCity(String city) {
    return 'Tiempo actual en $city';
  }

  @override
  String get weatherUpdatedByXema =>
      'Datos meteorológicos actualizados por el servicio XEMA.';

  @override
  String get rankingComingSoonButton => 'Próximamente: ver el ranking';

  @override
  String get weatherPrecipitationUnavailable => 'Precipitación no disponible';

  @override
  String weatherSolarIrradiance(String value) {
    return 'Irradiancia solar: $value W/m²';
  }

  @override
  String weatherCurrentTemperature(String value) {
    return 'Temperatura actual: $value°C';
  }

  @override
  String get weatherTemperatureUnavailable => 'Temperatura no disponible';

  @override
  String weatherPrecipitation(String value) {
    return 'Precipitación: $value mm';
  }

  @override
  String get weatherSolarIrradianceUnavailable =>
      'Irradiancia solar no disponible';

  @override
  String get adminHomeDashboardLoadError =>
      'No se han podido cargar las métricas del panel.';

  @override
  String get adminHomeTotalUsers => 'Usuarios totales';

  @override
  String get adminHomePendingImprovements => 'Mejoras pendientes';

  @override
  String get adminHomeManagedBuildings => 'Edificios gestionados';

  @override
  String get adminHomeImprovementsTab => 'Mejoras';

  @override
  String get adminHomeImprovementValidationQueue => 'Validación de mejoras';

  @override
  String get adminHomeImprovementLoadError =>
      'No se han podido cargar las mejoras pendientes';

  @override
  String get adminHomeNoPendingImprovements => 'No hay mejoras pendientes';

  @override
  String get adminHomeNoPendingImprovementsBody =>
      'Cuando un administrador de finca acredite una mejora implementada, aparecerá aquí para revisarla.';

  @override
  String get adminHomeRefreshImprovements => 'Actualizar mejoras';

  @override
  String get adminHomeApproveImprovement => 'Validar mejora';

  @override
  String get adminHomeRejectImprovement => 'Rechazar mejora';

  @override
  String get adminHomeImprovementApproved => 'Mejora validada correctamente.';

  @override
  String get adminHomeImprovementRejected => 'Mejora rechazada correctamente.';

  @override
  String get adminHomeUnexpectedImprovementError =>
      'Se ha producido un error inesperado revisando la mejora.';

  @override
  String get adminHomeImprovementCost => 'Coste';

  @override
  String get adminHomeImprovementDate => 'Fecha';

  @override
  String get adminHomeImprovementObservations => 'Observaciones';
}
