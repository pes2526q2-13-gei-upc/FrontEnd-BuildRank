// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Catalan Valencian (`ca`).
class AppLocalizationsCa extends AppLocalizations {
  AppLocalizationsCa([String locale = 'ca']) : super(locale);

  @override
  String get authLanguageLabel => 'Idioma';

  @override
  String get authLanguageCatalan => 'Català';

  @override
  String get authLanguageSpanish => 'Español';

  @override
  String get authLanguageEnglish => 'English';

  @override
  String get authLoginTab => 'Inicia sessió';

  @override
  String get authRegisterTab => 'Registra\'t';

  @override
  String authRegisterSuccessWithEmail(String email) {
    return 'Compte creat correctament. Ara pots iniciar sessió amb $email.';
  }

  @override
  String get loginWelcomeTitle => 'Benvingut a BuildRank';

  @override
  String get loginWelcomeSubtitle =>
      'Gestiona el teu edifici, consulta el rànquing energètic i segueix la teva evolució des d\'un únic lloc.';

  @override
  String get loginCardTitle => 'Inicia sessió';

  @override
  String get loginCardSubtitle =>
      'Accedeix amb el teu compte per veure la informació del teu edifici.';

  @override
  String get emailLabel => 'Correu electrònic';

  @override
  String get emailHint => 'nom@exemple.com';

  @override
  String get passwordLabel => 'Contrasenya';

  @override
  String get loginForgotPassword => 'Has oblidat la contrasenya?';

  @override
  String get loginButton => 'Entrar';

  @override
  String get loginGoogleButton => 'Continuar amb Google';

  @override
  String get loginMissingFieldsError =>
      'Has d\'omplir el correu i la contrasenya.';

  @override
  String get registerTitle => 'Crea un compte';

  @override
  String get registerSubtitle => 'Comença el seguiment del teu edifici avui';

  @override
  String get registerCardTitle => 'Registra\'t';

  @override
  String get registerCardSubtitle =>
      'Crea el teu compte per començar a gestionar edificis.';

  @override
  String get registerRoleHeader => 'SELECCIONA EL TEU ROL';

  @override
  String get registerRoleAdmin => 'Admin.\nfinca';

  @override
  String get registerRoleOwner => 'Propietari';

  @override
  String get registerRoleTenant => 'Llogater';

  @override
  String get firstNameLabel => 'Nom';

  @override
  String get lastNameLabel => 'Cognoms';

  @override
  String get confirmPasswordLabel => 'Confirmar contrasenya';

  @override
  String get registerAcceptTermsPrefix => 'Accepto els ';

  @override
  String get registerTermsOfService => 'Termes del Servei';

  @override
  String get registerAcceptTermsMiddle => ' i la ';

  @override
  String get registerPrivacyPolicy => 'Política de Privacitat';

  @override
  String get registerCreateAccountButton => 'Crea el compte de BuildRank';

  @override
  String get registerGoogleButton => 'Crear compte amb Google';

  @override
  String get registerMissingFieldsError => 'Has d\'omplir tots els camps.';

  @override
  String get registerPasswordsMismatchError =>
      'Les contrasenyes no coincideixen.';

  @override
  String get registerAcceptTermsError =>
      'Has d\'acceptar els termes i condicions.';

  @override
  String get registerSuccessInline =>
      'Compte creat correctament. Ara ja pots iniciar sessió.';

  @override
  String get registerSuccessSnackBar => 'Registre completat correctament.';

  @override
  String get passwordResetAppBarTitle => 'Recuperar contrasenya';

  @override
  String get passwordResetRequestTitle => 'Recupera la contrasenya';

  @override
  String get passwordResetConfirmTitle => 'Crea una nova contrasenya';

  @override
  String get passwordResetRequestSubtitle =>
      'Escriu el correu associat al teu compte i enganxa l\'enllaç rebut per email.';

  @override
  String get passwordResetConfirmSubtitle =>
      'Introdueix una nova contrasenya per al teu compte.';

  @override
  String get passwordResetSendInstructions => 'Enviar instruccions';

  @override
  String get passwordResetHaveLinkTitle => 'Ja tens l\'enllaç?';

  @override
  String get passwordResetHaveLinkBody =>
      'Enganxa aquí l\'enllaç rebut per email. BuildRank n\'extraurà automàticament el uid i el token.';

  @override
  String get passwordResetLinkLabel => 'Enllaç de recuperació';

  @override
  String get passwordResetLinkHint =>
      'https://.../reset-password?uid=...&token=...';

  @override
  String get passwordResetContinueWithLink => 'Continuar amb l\'enllaç';

  @override
  String get newPasswordLabel => 'Nova contrasenya';

  @override
  String get confirmNewPasswordLabel => 'Confirmar nova contrasenya';

  @override
  String get passwordResetSubmit => 'Restablir contrasenya';

  @override
  String get passwordResetPasteAnotherLink =>
      'Tornar a enganxar un altre enllaç';

  @override
  String get passwordResetEmailRequiredError =>
      'Introdueix el teu correu electrònic.';

  @override
  String get passwordResetRequestSuccess =>
      'Si el correu existeix, rebràs un enllaç per restablir la contrasenya. Enganxa\'l aquí quan el tinguis.';

  @override
  String get passwordResetLinkRequiredError =>
      'Enganxa l\'enllaç de recuperació rebut per email.';

  @override
  String get passwordResetInvalidLinkError =>
      'No s\'han pogut trobar els paràmetres uid i token dins l\'enllaç.';

  @override
  String get passwordResetLinkValidatedSuccess =>
      'Enllaç validat. Introdueix la nova contrasenya.';

  @override
  String get passwordResetPasswordRequiredError =>
      'Introdueix i confirma la nova contrasenya.';

  @override
  String get passwordResetSuccessSnackBar =>
      'Contrasenya restablerta correctament.';

  @override
  String get legalTermsTitle => 'Termes del Servei';

  @override
  String get legalPrivacyTitle => 'Política de Privacitat';

  @override
  String get legalTermsSubtitle => 'Condicions bàsiques d\'ús de BuildRank';

  @override
  String get legalPrivacySubtitle =>
      'Com BuildRank tracta les dades dins del MVP';

  @override
  String get legalInfoNotice =>
      'BuildRank és un projecte acadèmic en fase MVP. Aquest text resumeix les condicions i criteris de privacitat aplicables a la demo i a l\'ús del prototip.';

  @override
  String get legalTermsSection1Title => '1. Finalitat del servei';

  @override
  String get legalTermsSection1Body =>
      'BuildRank és una aplicació orientada a promoure un ús més responsable i sostenible de l\'energia en edificis residencials. Permet consultar informació d\'edificis, visualitzar indicadors, comparar resultats, simular millores i participar en funcionalitats comunitàries segons el rol de l\'usuari.';

  @override
  String get legalTermsSection2Title =>
      '2. Caràcter orientatiu de la informació';

  @override
  String get legalTermsSection2Body =>
      'Les puntuacions, rànquings, classificacions energètiques estimades, simulacions, Heat Risk Index i insígnies tenen finalitat informativa i orientativa. No constitueixen certificacions energètiques oficials, informes tècnics professionals ni recomanacions d\'enginyeria concloents.';

  @override
  String get legalTermsSection3Title => '3. Ús responsable de l\'aplicació';

  @override
  String get legalTermsSection3Body =>
      'L\'usuari es compromet a utilitzar BuildRank de manera responsable, a no introduir dades falses o de tercers sense autorització i a respectar les normes de convivència en votacions, xats i espais comunitaris.';

  @override
  String get legalTermsSection4Title => '4. Rols i permisos';

  @override
  String get legalTermsSection4Body =>
      'Les accions disponibles poden variar segons el rol de l\'usuari i la seva relació amb un edifici. Algunes accions, com gestionar edificis, validar sol·licituds, recalcular insígnies o administrar votacions, poden estar limitades a administradors autoritzats.';

  @override
  String get legalTermsSection5Title =>
      '5. Dades obertes, dades manuals i estimacions';

  @override
  String get legalTermsSection5Body =>
      'BuildRank pot combinar dades obertes, dades introduïdes manualment i resultats estimats. Quan una dada sigui incompleta, estimada o pendent de verificació, l\'aplicació intentarà indicar-ho de manera clara perquè l\'usuari pugui interpretar-la correctament.';

  @override
  String get legalTermsSection6Title => '6. Revisió humana i fonts oficials';

  @override
  String get legalTermsSection6Body =>
      'En cas de discrepància sobre dades energètiques, documentació, titularitat o permisos, la revisió humana i les fonts oficials prevalen sobre qualsevol resultat automàtic o estimat mostrat pel sistema.';

  @override
  String get legalPrivacySection1Title => '1. Dades tractades';

  @override
  String get legalPrivacySection1Body =>
      'BuildRank pot tractar dades de compte, rol d\'usuari, edificis associats, habitatges vinculats, sol·licituds, votacions, simulacions, notificacions i accions de validació o administració.';

  @override
  String get legalPrivacySection2Title => '2. Finalitat del tractament';

  @override
  String get legalPrivacySection2Body =>
      'Les dades es fan servir per autenticar usuaris, gestionar edificis, aplicar permisos, mostrar indicadors, facilitar participació comunitària, registrar accions sensibles i millorar la qualitat de les dades del sistema.';

  @override
  String get legalPrivacySection3Title => '3. Minimització de dades';

  @override
  String get legalPrivacySection3Body =>
      'BuildRank intenta mostrar només la informació necessària per a cada funcionalitat. Per exemple, les vistes generals com el mapa no haurien d\'exposar emails, documents, habitatges o dades personals innecessàries.';

  @override
  String get legalPrivacySection4Title => '4. Documents i verificacions';

  @override
  String get legalPrivacySection4Body =>
      'En processos de verificació, els documents aportats poden contenir informació sensible. Aquests fitxers s\'han d\'utilitzar només per revisar l\'evidència necessària i no per a finalitats alienes al procés de validació.';

  @override
  String get legalPrivacySection5Title => '5. Traçabilitat i auditoria';

  @override
  String get legalPrivacySection5Body =>
      'Les accions sensibles poden quedar registrades amb finalitats de seguretat, auditoria i integritat del sistema. Aquesta traçabilitat ajuda a explicar canvis rellevants sobre permisos, validacions, edificis, votacions o puntuacions.';

  @override
  String get legalPrivacySection6Title =>
      '6. Ús d\'IA i decisions automàtiques';

  @override
  String get legalPrivacySection6Body =>
      'Qualsevol suport automatitzat o basat en IA, si existeix, s\'ha d\'entendre com una ajuda per detectar incoherències o punts de revisió. No substitueix la revisió humana ni hauria d\'aprovar documents, assignar rols o modificar puntuacions de manera autònoma.';

  @override
  String get legalPrivacySection7Title => '7. Responsabilitat de l\'usuari';

  @override
  String get legalPrivacySection7Body =>
      'L\'usuari ha d\'evitar pujar informació innecessària o documents de tercers sense autorització. Les claus, tokens i credencials no s\'han de compartir ni introduir fora dels formularis previstos per l\'aplicació.';

  @override
  String get commonRetry => 'Torna-ho a provar';

  @override
  String get commonCancel => 'Cancel·lar';

  @override
  String get commonConfirm => 'Confirmar';

  @override
  String get commonBack => 'Torna';

  @override
  String get commonRefresh => 'Refrescar';

  @override
  String get commonHideForSession => 'Amagar durant aquesta sessió';

  @override
  String commonErrorWithValue(String error) {
    return 'Error: $error';
  }

  @override
  String get adminUserManagementTitle => 'Gestió d\'usuaris';

  @override
  String get adminUsersRefreshList => 'Actualitzar llistat';

  @override
  String get notificationsTitle => 'Notificacions';

  @override
  String get notificationsMarkAll => 'Marcar totes';

  @override
  String get notificationsLoadError =>
      'No s\'han pogut carregar les notificacions.';

  @override
  String get notificationsEmpty => 'No tens notificacions';

  @override
  String get notificationsNow => 'Ara mateix';

  @override
  String notificationsMinutesAgo(int count) {
    return 'Fa $count min';
  }

  @override
  String notificationsHoursAgo(int count) {
    return 'Fa $count h';
  }

  @override
  String notificationsDaysAgo(int count) {
    return 'Fa $count dies';
  }

  @override
  String get myChatsTitle => 'Els meus xats';

  @override
  String get myChatsConnectionError => 'No s\'ha pogut connectar al xat.';

  @override
  String get myChatsReconnect => 'Reconnectar';

  @override
  String get myChatsNoMessages => 'Sense missatges';

  @override
  String get myChatsEmpty => 'No tens cap xat actiu.';

  @override
  String get myChatsDirectDescription =>
      'Conversa directa o canal compartit entre administradors.';

  @override
  String get chatFallbackName => 'Xat';

  @override
  String get chatDirectDescription =>
      'Conversa directa entre administradors de finca.';

  @override
  String get chatUserNotConnectedError =>
      'Usuari no connectat. Tanca sessió i torna a entrar.';

  @override
  String chatConnectionError(String error) {
    return 'Error al connectar el xat:\n$error';
  }

  @override
  String get homeRankingTitle => 'Rànquing';

  @override
  String get homeProfileTitle => 'Perfil';

  @override
  String get homeGreeting => 'Bon dia';

  @override
  String get homeSummaryTitle => 'Resum del teu edifici';

  @override
  String get homeSummarySubtitle =>
      'Consulta l\'estat energètic actual, la teva posició a la lliga i les properes accions recomanades.';

  @override
  String get homeDemoBuildingName => 'Biblioteca Central';

  @override
  String get homeDemoBuildingSubtitle => 'Edifici monitoritzat aquesta setmana';

  @override
  String get homeMetricConsumption => 'Consum';

  @override
  String get homeMetricPosition => 'Posició';

  @override
  String get homeMetricImprovement => 'Millora';

  @override
  String get homeKeyIndicatorsTitle => 'Indicadors clau';

  @override
  String get homeTodayConsumptionTitle => 'Consum estimat d\'avui';

  @override
  String get homeTodayConsumptionSubtitle => '18 kWh · un 6% menys que ahir';

  @override
  String get homeLeaguePositionTitle => 'Posició a la lliga';

  @override
  String get homeLeaguePositionSubtitle => '3a posició de 12 edificis';

  @override
  String get homeRecommendationTitle => 'Recomanació principal';

  @override
  String get homeRecommendationSubtitle => 'Reduir la climatització a la tarda';

  @override
  String get homeQuickActionsTitle => 'Accions ràpides';

  @override
  String get homeBuildingTitle => 'Edifici';

  @override
  String get homeImprovementsTitle => 'Millores';

  @override
  String get homeCommunityTitle => 'Comunitat';

  @override
  String get homeWeeklyGoalTitle => 'Objectiu setmanal';

  @override
  String get homeWeeklyGoalBody =>
      'Manteniu el consum per sota de 130 kWh per consolidar-vos dins del top 3.';

  @override
  String get twinTitle => 'Twin Building';

  @override
  String get twinIntroTitle => 'Administradors d\'edificis comparables';

  @override
  String twinIntroBody(String buildingName) {
    return 'Contacta amb administradors de finca d\'edificis similars a $buildingName per compartir experiències sobre millores energètiques, votacions i gestió comunitària.';
  }

  @override
  String get twinEmptyTitle =>
      'No hi ha administradors comparables disponibles.';

  @override
  String get twinEmptyBody =>
      'Pot ser que l\'edifici encara no tingui grup comparable o que no hi hagi altres edificis administrats dins del mateix grup.';

  @override
  String twinChannelName(String address) {
    return 'Twin Building amb $address';
  }

  @override
  String twinChannelDescription(String adminName, String address) {
    return 'Conversa amb $adminName, administrador de $address.';
  }

  @override
  String twinPoints(String points) {
    return '$points pts';
  }

  @override
  String get twinTypologyFallback => 'Tipologia';

  @override
  String twinClimateZone(String zone) {
    return 'Zona $zone';
  }

  @override
  String twinAdminLine(String adminName) {
    return 'Admin: $adminName';
  }

  @override
  String get twinOpenChat => 'Obrir xat';

  @override
  String get editProfileTitle => 'Editar perfil';

  @override
  String get editProfilePersonalDataTitle => 'Dades personals';

  @override
  String get editProfilePersonalDataSubtitle =>
      'Actualitza la informació bàsica del teu compte. El rol no es pot modificar des d\'aquesta pantalla.';

  @override
  String get editProfileRoleLabel => 'Rol';

  @override
  String get editProfileSaving => 'Desant...';

  @override
  String get editProfileSaveChanges => 'Guardar canvis';

  @override
  String get editProfileFirstNameRequired => 'El nom és obligatori.';

  @override
  String get editProfileLastNameRequired => 'Els cognoms són obligatoris.';

  @override
  String get editProfileEmailRequired => 'El correu electrònic és obligatori.';

  @override
  String get editProfileEmailInvalid =>
      'Introdueix un correu electrònic vàlid.';

  @override
  String get editProfileSuccess => 'Perfil actualitzat correctament.';

  @override
  String get votesCreateTitle => 'Nova votació';

  @override
  String get votesCreateAction => 'Crear';

  @override
  String get votesTitleLabel => 'Títol';

  @override
  String get votesTitleHint => 'Títol de la votació';

  @override
  String get votesTitleRequiredError => 'El títol és obligatori.';

  @override
  String get votesTitleMinLengthError =>
      'El títol ha de tenir almenys 4 caràcters.';

  @override
  String get votesDescriptionOptionalLabel => 'Descripció (opcional)';

  @override
  String get votesDescriptionHint => 'Context de la votació...';

  @override
  String get votesDeadlineOptionalLabel => 'Data límit (opcional)';

  @override
  String get votesNoDeadline => 'Sense data límit';

  @override
  String get votesOptionsLabel => 'Opcions';

  @override
  String get votesOptionsLimitHint => 'Mínim 2 · Màxim 8';

  @override
  String get votesAddOption => 'Afegir opció';

  @override
  String votesOptionHint(int number) {
    return 'Opció $number';
  }

  @override
  String get votesOptionRequiredError => 'Aquesta opció no pot estar buida.';

  @override
  String get votesDuplicateOptionsError =>
      'Hi ha opcions duplicades. Revisa-les.';

  @override
  String get pendingRequestsTitle => 'Sol·licituds pendents';

  @override
  String pendingRequestsIntro(String buildingTitle) {
    return 'Aquí pots revisar i validar les sol·licituds d\'unió com a resident per a $buildingTitle.';
  }

  @override
  String pendingRequestsCount(int count) {
    return '$count pendents';
  }

  @override
  String get pendingRequestsEmptyTitle => 'No hi ha sol·licituds pendents';

  @override
  String get pendingRequestsEmptyBody =>
      'Quan altres usuaris demanin unir-se a aquest edifici, apareixeran aquí.';

  @override
  String get pendingRequestsUnexpectedError =>
      'S\'ha produït un error inesperat.';

  @override
  String get pendingRequestsForbidden =>
      'Només l\'administrador de finca pot gestionar les sol·licituds pendents.';

  @override
  String pendingRequestsAccepted(String name) {
    return 'S\'ha acceptat la sol·licitud de $name.';
  }

  @override
  String pendingRequestsRejected(String name) {
    return 'S\'ha rebutjat la sol·licitud de $name.';
  }

  @override
  String get pendingRequestsResidentChip => 'Resident';

  @override
  String get pendingRequestsRequestTypeLabel => 'Tipus de sol·licitud';

  @override
  String get pendingRequestsResidentJoinType => 'Unió com a resident';

  @override
  String get pendingRequestsDateLabel => 'Data';

  @override
  String get pendingRequestsCadastralReferenceLabel => 'Referència cadastral';

  @override
  String get pendingRequestsHomeLabel => 'Habitatge';

  @override
  String get pendingRequestsSurfaceLabel => 'Superfície';

  @override
  String get pendingRequestsReject => 'Rebutjar';

  @override
  String get pendingRequestsAccept => 'Acceptar';

  @override
  String get pendingRequestsNotSpecified => 'No especificat';

  @override
  String pendingRequestsFloorDoor(String floor, String door) {
    return 'Planta $floor · Porta $door';
  }

  @override
  String pendingRequestsFloor(String floor) {
    return 'Planta $floor';
  }

  @override
  String pendingRequestsDoor(String door) {
    return 'Porta $door';
  }

  @override
  String get chatReasonOptionalHint => 'Motiu (opcional)';

  @override
  String get chatConfirmActionTitle => 'Confirmar acció';

  @override
  String get chatDurationLabel => 'Durada';

  @override
  String get chatDurationIndefinite => 'Indefinit';

  @override
  String get chatDuration30Minutes => '30 minuts';

  @override
  String get chatDuration1Hour => '1 hora';

  @override
  String get chatDuration6Hours => '6 hores';

  @override
  String get chatDuration24Hours => '24 hores';

  @override
  String get chatReportMessage => 'Reportar missatge';

  @override
  String get chatHideMessage => 'Ocultar missatge';

  @override
  String get chatDeleteMyMessage => 'Eliminar el meu missatge';

  @override
  String get chatDeleteMessage => 'Eliminar missatge';

  @override
  String get chatRestoreMessage => 'Restaurar missatge';

  @override
  String get chatDismissReport => 'Desestimar report';

  @override
  String get chatDeleteOwnMessageConfirm =>
      'Segur que vols eliminar el teu missatge?';

  @override
  String get chatDeleteOtherMessageConfirm =>
      'Eliminar el missatge d\'aquest usuari?';

  @override
  String get chatMessageReported => 'Missatge reportat.';

  @override
  String get chatMessageHidden => 'Missatge ocult.';

  @override
  String get chatMessageDeleted => 'Missatge eliminat.';

  @override
  String get chatMessageRestored => 'Missatge restaurat.';

  @override
  String get chatReportDismissed => 'Report desestimat.';

  @override
  String get chatWarnUser => 'Advertir usuari';

  @override
  String get chatMuteUser => 'Silenciar usuari';

  @override
  String get chatBanFromChannel => 'Expulsar del canal';

  @override
  String get chatGlobalBan => 'Expulsió global';

  @override
  String get chatShadowBan => 'Shadow ban';

  @override
  String get chatWarn => 'Advertir';

  @override
  String get chatMute => 'Silenciar';

  @override
  String get chatUnmute => 'Dessilenciar';

  @override
  String get chatReadmitToChannel => 'Readmetre al canal';

  @override
  String get chatLiftGlobalBan => 'Aixecar expulsió global';

  @override
  String get chatLiftShadowBan => 'Aixecar shadow ban';

  @override
  String get chatWarningSent => 'Advertència enviada.';

  @override
  String get chatUserMuted => 'Usuari silenciat.';

  @override
  String get chatUserUnmuted => 'Usuari dessilenciat.';

  @override
  String get chatUserBannedFromChannel => 'Usuari expulsat del canal.';

  @override
  String get chatUserUnbannedFromChannel => 'Usuari readmès al canal.';

  @override
  String get chatUserGloballyBanned => 'Usuari expulsat globalment.';

  @override
  String get chatGlobalUnbanConfirm =>
      'Aixecar l\'expulsió global d\'aquest usuari?';

  @override
  String get chatGlobalBanLifted => 'Expulsió global aixecada.';

  @override
  String get chatShadowBanApplied => 'Shadow ban aplicat.';

  @override
  String get chatShadowUnbanConfirm =>
      'Aixecar el shadow ban d\'aquest usuari?';

  @override
  String get chatShadowBanLifted => 'Shadow ban aixecat.';

  @override
  String chatCommunityTitle(String buildingName) {
    return 'Comunitat de $buildingName';
  }

  @override
  String get chatCommunitySubtitle =>
      'Parla amb els membres d\'aquest edifici sobre millores, incidències i propostes.';

  @override
  String get chatContactSimilarAdmins => 'Contactar admins similars';

  @override
  String get mapTitle => 'Mapa d\'edificis';

  @override
  String get mapSearchHint => 'Cerca per carrer, barri o codi postal';

  @override
  String get mapSearchTooltip => 'Cercar';

  @override
  String get mapFilterAll => 'Tots';

  @override
  String mapFilterMinScore(int score) {
    return '≥ $score';
  }

  @override
  String get mapNoValidCoordinates =>
      'No hi ha edificis amb coordenades vàlides per mostrar.';

  @override
  String mapShownOfCount(int shown, int count) {
    return '$shown de $count edificis mostrats';
  }

  @override
  String mapShownCount(int shown) {
    return '$shown edificis al mapa';
  }

  @override
  String get mapLoadError => 'No s\'ha pogut carregar el mapa.';

  @override
  String get profileUserFallback => 'Usuari';

  @override
  String get profileRoleAdmin => 'Administrador de finca';

  @override
  String get profileRoleOwner => 'Propietari';

  @override
  String get profileRoleTenant => 'Llogater';

  @override
  String get profileAdminBuildingsTitle => 'Edificis administrats';

  @override
  String get profileOwnerBuildingsTitle => 'Edificis dels meus habitatges';

  @override
  String get profileTenantBuildingsTitle => 'Edificis vinculats';

  @override
  String get profileAccessibleBuildingsTitle => 'Edificis accessibles';

  @override
  String get profileEmptyAdminBuildings =>
      'Encara no tens cap edifici assignat com a administrador de finca. Pots crear-ne un amb el formulari d\'alta.';

  @override
  String get profileEmptyOwnerBuildings =>
      'Encara no tens habitatges vinculats al teu compte. Quan un administrador t\'assigni un habitatge, aquí veuràs l\'edifici corresponent.';

  @override
  String get profileEmptyTenantBuildings =>
      'Encara no tens cap habitatge vinculat al teu compte. Quan siguis assignat a un habitatge, aquí veuràs l\'edifici corresponent.';

  @override
  String get profileEmptyAccessibleBuildings =>
      'Encara no hi ha edificis disponibles per a aquest compte.';

  @override
  String get profileBuildingCreated => 'Edifici creat correctament.';

  @override
  String get profileLogoutTooltip => 'Tancar sessió';

  @override
  String get profileReportsSoon =>
      'Els informes per a juntes encara no estan disponibles en aquest MVP.';

  @override
  String get profileCreateBuilding => 'Crear edifici';

  @override
  String get profileReports => 'Informes';

  @override
  String get profileNonAdminInfo =>
      'Aquest compte pot consultar els edificis vinculats als seus habitatges. La creació i administració d\'edificis queda reservada als administradors de finca.';

  @override
  String get profileMapSubtitle =>
      'Visualitza els edificis registrats i consulta\'n les estadístiques principals.';

  @override
  String get profileLinkNewBuilding => 'Vincular nou edifici';

  @override
  String get profileLoadError => 'No s\'ha pogut carregar el perfil.';

  @override
  String get profileMetricBuildings => 'EDIFICIS';

  @override
  String get profileMetricLinks => 'VINCLES';

  @override
  String get profileMetricAvgRanking => 'RÀNQUING MITJÀ';

  @override
  String get profileMetricProgress => 'PROGRÉS';

  @override
  String get profileSeasonRestart => 'Proper reinici de temporada';

  @override
  String profileSeasonDaysLeft(int days) {
    return 'Queden $days dies';
  }

  @override
  String get profileBadgesTitle => 'Insígnies d\'edificis';

  @override
  String get profileBadgesBody =>
      'Les insígnies reals es mostren dins de la fitxa de cada edifici. Quan un edifici compleixi criteris de puntuació, qualitat de dades o millora, apareixeran en el seu detall.';

  @override
  String profileBuildingNumber(int id) {
    return 'Edifici #$id';
  }

  @override
  String get profileLocationUnavailable => 'Localització no disponible';

  @override
  String get profileInactive => 'Inactiu';

  @override
  String get profileActive => 'Actiu';

  @override
  String get accountBlockedTitle => 'Compte bloquejat';

  @override
  String get accountBlockedBody =>
      'El teu compte ha estat bloquejat permanentment. Contacta amb l\'administrador per obtenir més informació.';

  @override
  String get accountSuspendedTitle => 'Compte suspès';

  @override
  String get accountSuspendedBody =>
      'El teu compte està suspès temporalment. Contacta amb l\'administrador per obtenir més informació.';

  @override
  String get accountBackToLogin => 'Torna a l\'inici de sessió';

  @override
  String get appName => 'BuildRank';

  @override
  String get commonUnavailable => 'No disponible';

  @override
  String get commonUnknownError => 'Error desconegut.';

  @override
  String get commonRequiredField => 'Camp obligatori';

  @override
  String get commonInvalidNumber => 'Introdueix un número vàlid';

  @override
  String get commonGreaterThanZero => 'Ha de ser superior a 0';

  @override
  String get commonContinue => 'Continua →';

  @override
  String get mainNavHome => 'Inici';

  @override
  String get mainNavLeagues => 'Lligues';

  @override
  String get mainNavSimulate => 'Simula';

  @override
  String get mainNavChat => 'Xat';

  @override
  String get mainNavVotes => 'Votacions';

  @override
  String get habitatgeCadastralReference => 'Referència cadastral';

  @override
  String get habitatgeFloor => 'Planta';

  @override
  String get habitatgeDoor => 'Porta';

  @override
  String get habitatgeSurface => 'Superfície (m²)';

  @override
  String get addExistingAppBarTitle => 'Vincular edifici';

  @override
  String get addExistingTitle => 'Vincula\'t a un edifici ja existent';

  @override
  String get addExistingAdminSubtitle =>
      'Quan seleccionis un edifici, s\'enviarà una sol·licitud per vincular-te com a administrador de finca.';

  @override
  String get addExistingResidentSubtitle =>
      'Quan seleccionis un edifici, s\'enviarà una sol·licitud d\'unió a l\'administrador de finca perquè et pugui validar com a resident.';

  @override
  String get addExistingLocationSection => 'Localització';

  @override
  String get addExistingSearchHint => 'Escriu el carrer del teu edifici...';

  @override
  String get addExistingMinSearch =>
      'Introdueix almenys 3 caràcters per començar la cerca.';

  @override
  String get addExistingResultsTitle => 'Resultats';

  @override
  String get addExistingNoResults =>
      'No s\'ha trobat cap edifici amb aquesta adreça.';

  @override
  String addExistingSelectedBuilding(String buildingName, String role) {
    return 'Seleccionat: $buildingName · Rol sol·licitat: $role';
  }

  @override
  String get addExistingClosedRequests =>
      'Aquest edifici no admet noves sol·licituds d’unió en aquest moment.';

  @override
  String get addExistingHabitatgeTitle => 'Dades de l’habitatge';

  @override
  String get addExistingHabitatgeSubtitle =>
      'Completa les dades del teu habitatge per enviar la sol·licitud d’unió.';

  @override
  String get addExistingSubmit => 'Enviar sol·licitud';

  @override
  String get addExistingAdminRequestSent =>
      'S\'ha enviat la sol·licitud per vincular-te com a administrador de finca.';

  @override
  String get addExistingResidentRequestSent =>
      'S\'ha enviat la sol·licitud d\'unió a l\'administrador de finca.';

  @override
  String get rankingLoadError => 'No s’ha pogut carregar el rànquing.';

  @override
  String get rankingLoadMoreError => 'No s’han pogut carregar més competidors.';

  @override
  String get rankingProgressLoadError =>
      'No s’ha pogut carregar l’evolució de progrés.';

  @override
  String get rankingScopeLeague => 'La meva lliga';

  @override
  String get rankingScopeComparableLeague => 'Similars lliga';

  @override
  String get rankingScopeComparableSeason => 'Similars temporada';

  @override
  String get rankingUnavailableTitle => 'Rànquing no disponible';

  @override
  String get rankingLoadErrorTitle => 'No s’ha pogut carregar el rànquing';

  @override
  String rankingActiveSeason(String seasonName) {
    return 'Temporada activa: $seasonName';
  }

  @override
  String rankingProgressToTop(int target) {
    return 'Progrés cap al Top $target';
  }

  @override
  String rankingPointsProgress(String currentPoints, String targetPoints) {
    return '$currentPoints / $targetPoints punts';
  }

  @override
  String get rankingSeasonPendingCalendar => 'Temporada pendent de calendari.';

  @override
  String rankingCurrentPosition(int position) {
    return 'Posició actual: #$position';
  }

  @override
  String get rankingComparisonPeriod => 'Període de comparació';

  @override
  String rankingLastSeasons(int count) {
    return 'Últimes $count';
  }

  @override
  String rankingTopTarget(int target) {
    return 'Top $target';
  }

  @override
  String get rankingBadgesEarned => 'Insígnies aconseguides';

  @override
  String get rankingViewAll => 'Veure-ho tot';

  @override
  String get rankingBadgeSolarMaster => 'Mestre solar';

  @override
  String get rankingBadgeDateOct25 => 'Oct 25';

  @override
  String get rankingBadgeMaxSavings => 'Màxim estalvi';

  @override
  String get rankingBadgeDateNov25 => 'Nov 25';

  @override
  String get rankingBadgeResilient => 'Resilient';

  @override
  String get rankingBadgeDateDec25 => 'Dec 25';

  @override
  String get rankingBadgeTest => 'Prova';

  @override
  String get rankingBadgeDateJan26 => 'Gen 26';

  @override
  String get rankingSearchHint => 'Cerca per carrer...';

  @override
  String get rankingNoCompetitors =>
      'No s’ha trobat cap competidor amb aquests filtres.';

  @override
  String get rankingLoadMore => 'Carrega més competidors';

  @override
  String get rankingNoProgressHistory =>
      'Encara no hi ha historial de progrés per aquest edifici.';

  @override
  String get rankingSeasonProgressTitle => 'Progrés de temporades';

  @override
  String rankingSeasonProgressSubtitle(int count) {
    return 'Evolució real durant les últimes $count temporades disponibles.';
  }

  @override
  String rankingProgressForBuilding(String buildingName) {
    return 'Progrés de $buildingName';
  }

  @override
  String rankingProgressModalSubtitle(int count) {
    return 'Evolució de puntuació durant les últimes $count temporades.';
  }

  @override
  String rankingAccumulatedImprovement(int delta) {
    return 'Millora acumulada: +$delta punts';
  }

  @override
  String rankingPointsRange(int startPoints, int currentPoints) {
    return '$startPoints → $currentPoints punts';
  }

  @override
  String rankingDeltaPoints(String deltaText) {
    return '$deltaText pts';
  }

  @override
  String get rankingViewDetail => 'Veure detall';

  @override
  String get buildingCardDetailLoadError =>
      'No s’ha pogut carregar el detall de l’edifici.';

  @override
  String get buildingCardBadgesRecalculated =>
      'Insígnies recalculades correctament.';

  @override
  String get buildingCardBadgesLoadError =>
      'No s’han pogut carregar les insígnies.';

  @override
  String get buildingCardLoadError => 'No s’ha pogut carregar l’edifici.';

  @override
  String buildingCardClimateZone(String zone) {
    return 'Zona climàtica $zone';
  }

  @override
  String get buildingCardScoreExcellent => 'EXCEL·LENT';

  @override
  String get buildingCardScoreGood => 'BO';

  @override
  String get buildingCardScoreImprove => 'MILLORABLE';

  @override
  String get buildingCardScorePriority => 'PRIORITARI';

  @override
  String get buildingCardEstimatedRating => 'QUALIFICACIÓ ESTIMADA';

  @override
  String buildingCardPendingData(String items) {
    return 'Dades pendents: $items';
  }

  @override
  String get buildingCardBaseScore => 'Puntuació base BuildRank';

  @override
  String get buildingCardPerformance => 'RENDIMENT';

  @override
  String get buildingCardInitialData => 'Dades inicials';

  @override
  String get buildingCardSurface => 'SUPERFÍCIE';

  @override
  String get buildingCardFloors => 'PLANTES';

  @override
  String get buildingCardOrientation => 'ORIENTACIÓ';

  @override
  String get buildingCardBadgesTitle => 'INSÍGNIES DE L’EDIFICI';

  @override
  String get buildingCardRecalculate => 'Recalcular';

  @override
  String get buildingCardNoBadges =>
      'Aquest edifici encara no té insígnies assignades. Es mostraran quan compleixi alguna fita.';

  @override
  String get buildingCardRecommendedActions => 'ACCIONS RECOMANADES';

  @override
  String get buildingCardActionSimulationTitle => 'Executa simulació';

  @override
  String get buildingCardActionSimulationSubtitle =>
      'Prova escenaris de millora per aquest edifici';

  @override
  String get buildingCardActionVoteTitle => 'Votació de la comunitat';

  @override
  String get buildingCardActionVoteSubtitle =>
      'Funcionalitat preparada per futures propostes';

  @override
  String get buildingCardActionReportTitle => 'Informe de junta (properament)';

  @override
  String get buildingCardActionReportSubtitle =>
      'La generació d’informes encara no està disponible en aquest MVP';

  @override
  String get buildingCardActionManageRequestsTitle =>
      'Gestionar sol·licituds pendents';

  @override
  String get buildingCardActionManageRequestsSubtitle =>
      'Revisa i valida noves peticions d’unió a l’edifici';

  @override
  String get buildingCardActionEditHabitatgeTitle => 'Editar el meu habitatge';

  @override
  String get buildingCardActionEditHabitatgeSubtitle =>
      'Completa superfície, reforma i dades energètiques';

  @override
  String get buildingCardTabDetails => 'Detalls';

  @override
  String get buildingCardTabHistory => 'Historial';

  @override
  String get buildingCardTabDocuments => 'Documents';

  @override
  String get buildingCardHistoryUnavailableTitle =>
      'Historial encara no disponible';

  @override
  String get buildingCardHistoryUnavailableBody =>
      'En aquesta secció es mostraran canvis de puntuació, validacions i simulacions guardades.';

  @override
  String get buildingCardDocumentsSoonTitle =>
      'Documents i informes (properament)';

  @override
  String get buildingCardDocumentsSoonBody =>
      'Aquesta secció queda preparada per a una futura integració documental. En aquest MVP no es mostren documents ni informes generats.';

  @override
  String get buildingCardConstructionYear => 'ANY DE CONSTRUCCIÓ';

  @override
  String buildingCardFloorsCount(String count) {
    return '$count plantes';
  }

  @override
  String get buildingCardTypology => 'TIPOLOGIA';

  @override
  String get buildingCardRegulation => 'REGLAMENT';

  @override
  String get buildingCardNoLocation =>
      'Aquest edifici encara no té localització associada.';

  @override
  String buildingCardLocationSummary(
    String street,
    String number,
    String neighborhood,
    String postalCode,
  ) {
    return 'Localització: $street, $number · $neighborhood · $postalCode';
  }

  @override
  String get buildingFormStreetMinChars =>
      'Escriu almenys 2 caràcters per cercar el carrer.';

  @override
  String buildingFormNoStreetFound(String query) {
    return 'No s’ha trobat cap carrer amb “$query”.';
  }

  @override
  String get buildingFormStreetSuggestionsError =>
      'No s’han pogut carregar els suggeriments de carrers.';

  @override
  String get buildingFormPostalCodeRequired => 'El codi postal és obligatori.';

  @override
  String get buildingFormPostalCodeInvalid =>
      'El codi postal ha de tenir 5 dígits.';

  @override
  String get buildingFormNeighborhoodRequired => 'El camp barri és obligatori.';

  @override
  String get buildingFormStreetRequired => 'El nom del carrer és obligatori.';

  @override
  String get buildingFormStreetSelectionRequired =>
      'Selecciona un carrer de la llista de suggeriments.';

  @override
  String get buildingFormNumberRequired => 'El número és obligatori.';

  @override
  String get buildingFormNumberPositive =>
      'El número del carrer ha de ser un enter positiu.';

  @override
  String buildingFormNumberOutOfRange(int minNumber, int maxNumber) {
    return 'El número no està dins del rang permès per aquest carrer ($minNumber-$maxNumber).';
  }

  @override
  String get buildingFormTypeRequired => 'Has de seleccionar una tipologia.';

  @override
  String get buildingFormConstructionYearRequired =>
      'L\'any de construcció és obligatori.';

  @override
  String get buildingFormConstructionYearInteger =>
      'L\'any de construcció ha de ser un número enter.';

  @override
  String buildingFormConstructionYearRange(int currentYear) {
    return 'L\'any de construcció ha d\'estar entre 1800 i $currentYear.';
  }

  @override
  String get buildingFormRegulationRequired =>
      'La normativa vigent és obligatòria.';

  @override
  String get buildingFormFloorsRequired =>
      'El nombre de plantes és obligatori.';

  @override
  String get buildingFormFloorsPositive =>
      'El nombre de plantes ha de ser un enter positiu.';

  @override
  String get buildingFormSurfaceRequired =>
      'La superfície total és obligatòria.';

  @override
  String get buildingFormSurfacePositive =>
      'La superfície total ha de ser un número positiu.';

  @override
  String get buildingFormOrientationRequired =>
      'Has de seleccionar una orientació principal.';

  @override
  String get buildingFormDocumentsRequired =>
      'Cal adjuntar almenys un document de verificació.';

  @override
  String get buildingFormCreatedMissingId =>
      'L’edifici s’ha creat però la resposta no conté cap identificador reconeixible.';

  @override
  String get buildingFormSubmitSuccess =>
      'Edifici creat i documentació enviada. Queda pendent de revisió.';

  @override
  String get buildingFormUnexpectedSaveError =>
      'S\'ha produït un error inesperat en desar l\'edifici.';

  @override
  String get buildingFormTypeResidential => 'Residencial';

  @override
  String get buildingFormTypeCommercial => 'Comercial';

  @override
  String get buildingFormTypeEducational => 'Educatiu';

  @override
  String get buildingFormTypeHealthcare => 'Sanitari';

  @override
  String get buildingFormTypeMixed => 'Mixt';

  @override
  String get buildingFormTypeResidentialSubtitle => 'Unifamiliar o pisos';

  @override
  String get buildingFormTypeCommercialSubtitle => 'Oficines, comerç...';

  @override
  String get buildingFormTypeEducationalSubtitle => 'Escoles';

  @override
  String get buildingFormTypeHealthcareSubtitle => 'Hospitals';

  @override
  String get buildingFormTypeMixedSubtitle => 'Usos combinats';

  @override
  String get orientationNorth => 'Nord';

  @override
  String get orientationSouth => 'Sud';

  @override
  String get orientationEast => 'Est';

  @override
  String get orientationWest => 'Oest';

  @override
  String get buildingFormNewBuildingChip => 'Nou Edifici';

  @override
  String get buildingFormTitle => 'Registra l\'edifici';

  @override
  String get buildingFormStep1Subtitle =>
      'Comencem per la ubicació de l\'edifici.';

  @override
  String get buildingFormStep2Subtitle => 'Ara completa la informació general.';

  @override
  String get buildingFormStep3Subtitle =>
      'Afegeix les dades tècniques bàsiques.';

  @override
  String get buildingFormStep4Subtitle =>
      'Adjunta la documentació per validar-te com a administrador de finca.';

  @override
  String get buildingFormLocationSection => 'UBICACIÓ';

  @override
  String get buildingFormPostalCodeLabel => 'Codi postal';

  @override
  String get buildingFormPostalCodeHint => 'p. ex., 08025';

  @override
  String get buildingFormOr => 'o';

  @override
  String get buildingFormNeighborhoodLabel => 'Barri';

  @override
  String get buildingFormNeighborhoodHint => 'p. ex., Sagrada Família';

  @override
  String get buildingFormStreetLabel => 'Nom del carrer';

  @override
  String get buildingFormStreetHint => 'Comença a escriure el carrer';

  @override
  String buildingFormStreetNumberRange(int minNumber, int maxNumber) {
    return 'Números $minNumber-$maxNumber';
  }

  @override
  String get buildingFormStreetRangeUnknown => 'Rang de numeració no informat';

  @override
  String get buildingFormNumberLabel => 'Número';

  @override
  String get buildingFormNumberHint => 'p. ex., 123';

  @override
  String get buildingFormLocationInfo =>
      'Selecciona un carrer de la llista de suggeriments. En desar, BuildRank crearà primer la localització i després l’edifici vinculat al teu compte d’administrador.';

  @override
  String get buildingFormGeneralSection => 'INFORMACIÓ GENERAL';

  @override
  String get buildingFormRegisteredLocation => 'Ubicació registrada';

  @override
  String get buildingFormAddressLabel => 'Adreça';

  @override
  String get buildingFormTypeLabel => 'Tipologia de l\'edifici';

  @override
  String get buildingFormConstructionYearLabel => 'Any de construcció';

  @override
  String get buildingFormConstructionYearHint => 'p. ex., 1998';

  @override
  String get buildingFormRegulationLabel => 'Normativa vigent';

  @override
  String get buildingFormRegulationHint => 'p. ex., CTE';

  @override
  String get buildingFormTechnicalSection => 'DADES TÈCNIQUES';

  @override
  String get buildingFormBuildingSummary => 'Resum de l’edifici';

  @override
  String get buildingFormConstructionYearSummaryLabel => 'Any construcció';

  @override
  String get buildingFormRegulationSummaryLabel => 'Normativa';

  @override
  String get buildingFormFloorsLabel => 'Nombre de plantes';

  @override
  String get buildingFormFloorsHint => 'p. ex., 6';

  @override
  String get buildingFormSurfaceLabel => 'Superfície total (m²)';

  @override
  String get buildingFormSurfaceHint => 'p. ex., 850';

  @override
  String get buildingFormOrientationLabel => 'Orientació principal';

  @override
  String get buildingFormOrientationHint => 'Selecciona una orientació';

  @override
  String get buildingFormDocumentationSection => 'DOCUMENTACIÓ';

  @override
  String get buildingFormBuildingToVerify => 'Edifici a verificar';

  @override
  String get buildingFormSubmittingDocuments => 'Enviant documentació...';

  @override
  String get buildingFormSubmit => 'Crear edifici i enviar verificació';

  @override
  String get editHabitatgeNoLinkedHome =>
      'No s’ha trobat cap habitatge vinculat al teu usuari en aquest edifici.';

  @override
  String get editHabitatgeNoneSelected =>
      'No s’ha seleccionat cap habitatge per editar.';

  @override
  String get editHabitatgeMissingCadastralReference =>
      'L’habitatge seleccionat no té referència cadastral.';

  @override
  String get editHabitatgeLoadError => 'No s’ha pogut carregar l’habitatge.';

  @override
  String get editHabitatgeSelectorTitle => 'Quin habitatge vols editar?';

  @override
  String editHabitatgeSelectorFloorDoor(String floor, String door) {
    return 'Planta $floor · Porta $door';
  }

  @override
  String get editHabitatgeEnergyRequired =>
      'Camp obligatori si informes dades energètiques';

  @override
  String get editHabitatgeEnergyDateRequired =>
      'Cal informar la data d’entrada si informes dades energètiques';

  @override
  String get editHabitatgeSaveWithEnergySuccess =>
      'Dades de l’habitatge i dades energètiques actualitzades.';

  @override
  String get editHabitatgeSaveSuccess => 'Dades de l’habitatge actualitzades.';

  @override
  String get editHabitatgeAppBarTitle => 'Editar habitatge';

  @override
  String get editHabitatgeCannotEditTitle => 'No es pot editar l’habitatge';

  @override
  String get editHabitatgeSaveButton => 'Guardar dades';

  @override
  String get editHabitatgeIntroTitle => 'Completa les dades del teu habitatge';

  @override
  String get editHabitatgeIntroBody =>
      'Aquestes dades ajudaran a calcular millor la classificació estimada i la puntuació BuildRank de l’edifici.';

  @override
  String get editHabitatgeHomeDataTitle => 'Dades de l’habitatge';

  @override
  String get editHabitatgeHomeDataSubtitle =>
      'Informació bàsica de l’habitatge vinculat al teu compte.';

  @override
  String get editHabitatgeRenovationYear => 'Any reforma';

  @override
  String get editHabitatgeInvalidYear => 'Introdueix un any vàlid';

  @override
  String get editHabitatgeYearOutOfRange => 'L’any no és vàlid';

  @override
  String get editHabitatgeEnergyDataTitle => 'Dades energètiques';

  @override
  String get editHabitatgeEnergyDataSubtitle =>
      'Afegeix la informació disponible del certificat o estimació energètica.';

  @override
  String get editHabitatgeEnergyOptionalNotice =>
      'Les dades energètiques són opcionals. Si informes qualsevol camp d’aquesta secció, hauràs d’omplir tots els camps obligatoris del certificat energètic.';

  @override
  String get editHabitatgeGlobalRating => 'Qualificació global';

  @override
  String get editHabitatgePrimaryEnergyConsumption => 'Consum energia primària';

  @override
  String get editHabitatgeFinalEnergyConsumption => 'Consum energia final';

  @override
  String get editHabitatgeCo2Emissions => 'Emissions CO₂';

  @override
  String get editHabitatgeAnnualEnergyCost => 'Cost anual energia (€)';

  @override
  String get editHabitatgeConsumptionByUse => 'Consums per ús';

  @override
  String get editHabitatgeHeatingEnergy => 'Energia calefacció';

  @override
  String get editHabitatgeCoolingEnergy => 'Energia refrigeració';

  @override
  String get editHabitatgeAcsEnergy => 'Energia ACS';

  @override
  String get editHabitatgeLightingEnergy => 'Energia enllumenament';

  @override
  String get editHabitatgeEmissionsByUse => 'Emissions per ús';

  @override
  String get editHabitatgeHeatingEmissions => 'Emissions calefacció';

  @override
  String get editHabitatgeCoolingEmissions => 'Emissions refrigeració';

  @override
  String get editHabitatgeAcsEmissions => 'Emissions ACS';

  @override
  String get editHabitatgeLightingEmissions => 'Emissions enllumenament';

  @override
  String get editHabitatgeCertificationEnvelope => 'Certificació i envolupant';

  @override
  String get editHabitatgeThermalInsulation => 'Aïllament tèrmic';

  @override
  String get editHabitatgeWindowValue => 'Valor finestres';

  @override
  String get editHabitatgeCertificationTool => 'Eina certificació';

  @override
  String get editHabitatgeCertificationReason => 'Motiu certificació';

  @override
  String get editHabitatgeEnergyRenovation => 'Rehabilitació energètica';

  @override
  String get editHabitatgeSelectEntryDate => 'Seleccionar data d’entrada *';

  @override
  String editHabitatgeEntryDate(String date) {
    return 'Data d’entrada: $date';
  }

  @override
  String get adminAuditTitle => 'Registre d\'auditoria';

  @override
  String get adminAuditEmpty => 'Cap registre trobat.';

  @override
  String get adminAuditUserId => 'ID usuari';

  @override
  String get adminAuditMethod => 'Mètode';

  @override
  String get adminAuditResourceType => 'Tipus de recurs';

  @override
  String get adminAuditHttpCode => 'Codi HTTP';

  @override
  String get adminAuditFromDate => 'Des de';

  @override
  String get adminAuditToDate => 'Fins a';

  @override
  String get adminAuditClear => 'Netejar';

  @override
  String get adminAuditApplyFilters => 'Aplicar filtres';

  @override
  String get adminAuditAll => 'Tots';

  @override
  String adminAuditPageRange(int firstItem, int lastItem, int totalCount) {
    return '$firstItem-$lastItem de $totalCount';
  }

  @override
  String adminAuditPage(int page) {
    return 'Pàg. $page';
  }

  @override
  String get adminAuditPreviousPage => 'Pàgina anterior';

  @override
  String get adminAuditNextPage => 'Pàgina següent';

  @override
  String get simulationCatalogLoadError =>
      'No s\'ha pogut carregar el catàleg de millores.';

  @override
  String get simulationHistoryLoadError =>
      'No s\'ha pogut carregar l\'historial de simulacions.';

  @override
  String get simulationCalculateError =>
      'No s\'ha pogut calcular la simulació.';

  @override
  String get simulationSaveError => 'No s\'ha pogut guardar la simulació.';

  @override
  String get simulationSavedSnack => 'Simulació guardada correctament.';

  @override
  String get simulationTitle => 'Simulador de millores';

  @override
  String get simulationCurrent => 'Actual';

  @override
  String get simulationSimulated => 'Simulat';

  @override
  String get simulationDisclaimer =>
      'Els resultats són estimacions orientatives. No substitueixen una auditoria energètica professional.';

  @override
  String get simulationTabSimulate => 'Simular';

  @override
  String get simulationTabSaved => 'Guardades';

  @override
  String get simulationTabImplemented => 'Aplicades';

  @override
  String get simulationCatalogTitle => 'Catàleg de millores';

  @override
  String simulationSelectedCount(int count) {
    return '$count seleccionades';
  }

  @override
  String get simulationSavedTitle => 'Simulacions guardades';

  @override
  String get simulationNoSaved =>
      'Encara no hi ha simulacions guardades per aquest edifici. Calcula una previsualització i prem \"Guardar simulació\".';

  @override
  String get simulationImplementedTitle => 'Millores aplicades';

  @override
  String get simulationNoImplemented =>
      'Encara no hi ha millores aplicades registrades. Les simulacions guardades són escenaris; les aplicades representen actuacions realment executades o en validació.';

  @override
  String get simulationCalculatingPreview => 'Calculant preview...';

  @override
  String get simulationCalculatePreview => 'Calcular preview';

  @override
  String get simulationSaving => 'Guardant simulació...';

  @override
  String get simulationSave => 'Guardar simulació';

  @override
  String get simulationReadOnlyRole =>
      'Aquest rol pot consultar la previsualització, però la gestió formal de simulacions queda reservada a l\'administrador de finca.';

  @override
  String get simulationResultTitle => 'Resultat de la simulació';

  @override
  String get simulationAnnualConsumption => 'Consum anual';

  @override
  String get simulationEstimatedAnnualCost => 'Cost anual estimat';

  @override
  String simulationSavings(String amount) {
    return 'Estalvi $amount';
  }

  @override
  String get simulationScore => 'Puntuació';

  @override
  String simulationPointsDelta(String points) {
    return '+$points punts';
  }

  @override
  String simulationTotalCostAndEngine(String cost, String engine) {
    return 'Cost total estimat: $cost · Motor $engine';
  }

  @override
  String simulationDateAndEngine(String date, String engine) {
    return 'Data: $date · Motor $engine';
  }

  @override
  String simulationCost(String cost) {
    return 'Cost $cost';
  }

  @override
  String simulationRealCost(String cost) {
    return 'Cost real $cost';
  }

  @override
  String simulationExecutionDate(String date) {
    return 'Execució: $date';
  }

  @override
  String get simulationEmptyCatalog =>
      'Encara no hi ha millores actives al catàleg. Carrega el seed de millores al backend.';

  @override
  String altSimulationPreparedSnack(int count) {
    return 'Simulació preparada per presentar a votació amb $count millora/es.';
  }

  @override
  String get altSimulationSelectUpdates => 'Seleccioneu\nactualitzacions';

  @override
  String get altSimulationDetailedImpact => 'Impacte detallat';

  @override
  String get altSimulationPresentVote => 'Presentar a votació';

  @override
  String get altSimulationLive => 'SIMULACIÓ EN DIRECTE';

  @override
  String get altSimulationExpectedPerformance => 'Rendiment previst';

  @override
  String get altSimulationImpact => 'IMPACTE';

  @override
  String get altSimulationEstimatedCost => 'COST\nESTIM';

  @override
  String get altSimulationOperationalForecast => 'PREVISIÓ OPERATIVA';

  @override
  String get altSimulationAnnualEnergyCost => 'Cost energètic anual';

  @override
  String get altSimulationCarbonFootprint => 'Petjada de carboni';

  @override
  String get altSimulationEnergyIntensity => 'Intensitat energètica';

  @override
  String get altSimulationTotalInvestment => 'INVERSIÓ TOTAL';

  @override
  String get altSimulationAnnualSavings => 'ESTALVI ANUAL';

  @override
  String get altSimulationPaybackPeriod => 'PERÍODE DE RETORN';

  @override
  String altSimulationYears(String years) {
    return '$years anys';
  }

  @override
  String get altSimulationSolarTitle => 'Panell solar fotovoltaic';

  @override
  String get altSimulationSolarSubtitle => '10 kW teulada';

  @override
  String get altSimulationGlazingTitle => 'Triple vidre';

  @override
  String get altSimulationGlazingSubtitle => 'Alt rendiment';

  @override
  String get altSimulationInsulationTitle => 'Aïllament de paret';

  @override
  String get altSimulationInsulationSubtitle => 'Mineral exterior';

  @override
  String get altSimulationHeatPumpTitle => 'Bomba de calor';

  @override
  String get altSimulationHeatPumpSubtitle => 'Sistema eficient aire-aigua';

  @override
  String get votesStatusOpen => 'Oberta';

  @override
  String get votesStatusClosed => 'Tancada';

  @override
  String get votesStatusArchived => 'Arxivada';

  @override
  String get votesStatusCancelled => 'Cancel·lada';

  @override
  String get votesRetry => 'Torna-ho a provar';

  @override
  String votesCount(int count) {
    return '$count vots';
  }

  @override
  String votesCountSingular(int count) {
    return '$count vot';
  }

  @override
  String get votesSelectOptionSnack => 'Selecciona una opció per votar.';

  @override
  String get votesRegisteredSnack => 'Vot registrat correctament.';

  @override
  String get votesDeleteTitle => 'Eliminar votació';

  @override
  String get votesDeleteBody =>
      'Segur que vols eliminar aquesta votació? S\'esborraran totes les opcions i vots emesos. Aquesta acció no es pot desfer.';

  @override
  String get votesCancel => 'Cancel·lar';

  @override
  String get votesDelete => 'Eliminar';

  @override
  String get votesFallbackTitle => 'Votació';

  @override
  String get votesEdit => 'Editar';

  @override
  String votesUntilDate(String date) {
    return 'Fins al $date';
  }

  @override
  String get votesSelectOption => 'Selecciona una opció';

  @override
  String get votesOptions => 'Opcions';

  @override
  String get votesPermissionOnlyOwners =>
      'Només els propietaris i administradors de finca vinculats a aquest edifici poden emetre vot.';

  @override
  String get votesVote => 'Votar';

  @override
  String get votesViewResults => 'Veure resultats';

  @override
  String get votesResults => 'Resultats';

  @override
  String votesTotal(int count) {
    return 'Total: $count vots';
  }

  @override
  String votesTotalSingular(int count) {
    return 'Total: $count vot';
  }

  @override
  String get votesEditTitle => 'Editar votació';

  @override
  String get votesSave => 'Desar';

  @override
  String get votesSaveChanges => 'Desar canvis';

  @override
  String get votesMinimumOptionsSnack => 'Cal un mínim de 2 opcions.';

  @override
  String get votesDuplicateOptionsSnack =>
      'Hi ha opcions duplicades. Revisa\'ls.';

  @override
  String get votesTitleRequired => 'El títol és obligatori.';

  @override
  String get votesTitleMinLength => 'El títol ha de tenir almenys 4 caràcters.';

  @override
  String get votesDescriptionOptional => 'Descripció (opcional)';

  @override
  String get votesDeadline => 'Data límit';

  @override
  String get votesOptionsRange => 'Mínim 2 · Màxim 8';

  @override
  String get votesOptionsWarning =>
      'Atenció: modificar les opcions pot afectar els vots existents.';

  @override
  String get votesState => 'Estat';

  @override
  String get votesCancelledLocked =>
      'Una votació cancel·lada no es pot reobrir.';

  @override
  String get votesOptionRequired => 'Aquesta opció no pot estar buida.';

  @override
  String get votesListTitle => 'Votació interna';

  @override
  String votesListSubtitle(String buildingName) {
    return 'Presa de decisions per $buildingName';
  }

  @override
  String get votesGeneralSection => 'VOTACIONS GENERALS';

  @override
  String get votesSimulationSection => 'VOTACIONS DE SIMULACIÓ';

  @override
  String votesTabActive(int count) {
    return 'Actiu ($count)';
  }

  @override
  String votesTabCompleted(int count) {
    return 'Completat ($count)';
  }

  @override
  String get votesTabMyProposals => 'Les meves propostes';

  @override
  String get votesTabMyVotes => 'Les meves votacions';

  @override
  String get votesEmptyActive => 'No hi ha votacions actives ara mateix.';

  @override
  String get votesEmptySection => 'No hi ha votacions en aquesta secció.';

  @override
  String get votesEmptyBody =>
      'Quan l\'administrador sotmeti una simulació a votació, apareixerà aquí.';

  @override
  String get votesInfoCanVote =>
      'Pots participar en les votacions de la comunitat vinculades a aquest edifici.';

  @override
  String get votesInfoCannotVote =>
      'Només propietaris i administradors de finca vinculats a l\'edifici poden votar.';

  @override
  String get votesRegisteredFavor => 'Vot a favor registrat.';

  @override
  String get votesRegisteredAgainst => 'Vot en contra registrat.';

  @override
  String get votesActive => 'Activa';

  @override
  String get votesEndsToday => 'Finalitza avui';

  @override
  String votesDaysRemaining(int days) {
    return '$days dies restants';
  }

  @override
  String get votesEnergyProposalFallback => 'Proposta de millora energètica.';

  @override
  String get votesQuorumProgress => 'Progrés del quòrum';

  @override
  String get votesQuorumReached => 'Quòrum assolit';

  @override
  String get votesNeedMoreParticipation => 'Cal més participació';

  @override
  String get votesVoteSection => 'VOTA';

  @override
  String get votesFavor => 'A favor';

  @override
  String get votesAgainst => 'En contra';

  @override
  String votesEstimatedCostSaving(String cost, String saving) {
    return 'Cost estimat $cost € +$saving €/any';
  }

  @override
  String get votesKeepCurrentState => 'Mantenir l\'estat actual';

  @override
  String votesYourVote(String vote) {
    return 'El teu vot: $vote';
  }

  @override
  String get votesPendingVote => 'Pendent de vot';

  @override
  String get votesNotReported => 'no informat';

  @override
  String adminUsersSuspendTitle(String email) {
    return 'Suspendre $email';
  }

  @override
  String get adminUsersReasonLabel => 'Motiu (opcional)';

  @override
  String get adminUsersReasonHint => 'Descriu el motiu de la suspensió...';

  @override
  String get adminUsersEndDate => 'Data fi';

  @override
  String get adminUsersRemoveDate => 'Eliminar data';

  @override
  String get adminUsersConfirm => 'Confirmar';

  @override
  String get adminUsersTitle => 'Gestió d\'usuaris';

  @override
  String adminUsersCount(int count) {
    return '$count usuaris';
  }

  @override
  String get adminUsersEmpty => 'No hi ha usuaris.';

  @override
  String adminUsersReason(String reason) {
    return 'Motiu: $reason';
  }

  @override
  String get adminUsersSuspend => 'Suspendre';

  @override
  String get adminHomeVerificationPending => 'Verificacions pendents';

  @override
  String get adminHomeSearchHint => 'Cerca edificis o usuaris...';

  @override
  String get adminHomeVerificationQueue => 'Cua de verificació documental';

  @override
  String adminHomePendingCount(int count) {
    return '$count pendents';
  }

  @override
  String get adminHomeNoPendingVerifications =>
      'No hi ha verificacions pendents';

  @override
  String get adminHomeNoPendingVerificationsBody =>
      'Quan una verificació acabi el processament d\'IA apareixerà aquí.';

  @override
  String get adminHomeCreateSeason => 'Crear nova temporada';

  @override
  String get adminHomeChatsBody =>
      'Accedeix als xats dels edificis i aplica accions de moderació.';

  @override
  String get adminHomeOpenBuildingChats => 'Accedir als xats dels edificis';

  @override
  String get adminHomeUsersTitle => 'Gestió d\'usuaris';

  @override
  String get adminHomeUsersBody =>
      'Bloqueja, suspèn i gestiona els comptes dels usuaris.';

  @override
  String get adminHomeOpenUsers => 'Accedir a la gestió d\'usuaris';

  @override
  String get adminHomeAnomalyBody =>
      '5 edificis de la categoria \"Comercial\" han presentat dades que superen els punts de referència històrics en més d\'un 20%. Cal una auditoria manual.';

  @override
  String get adminHomeUnexpectedVerificationError =>
      'S\'ha produït un error inesperat revisant la verificació.';

  @override
  String get revisionCardNextReview => 'Propera revisió: 15 des. 2026';

  @override
  String get revisionCardDataComplete =>
      'Les dades de verificació estan completes al 75%.';

  @override
  String get buildingListScoreLabel => 'PUNTUACIÓ BUILDRANK';

  @override
  String get adminHomeChatsModerationTitle => 'Moderació de xats';

  @override
  String get adminHomeAuditButton => 'Auditoria';

  @override
  String get adminHomeLogoutButton => 'Tanca sessió';

  @override
  String get adminHomeLoggingOut => 'Sortint...';

  @override
  String get adminHomeNoAccessPermission =>
      'No tens permisos per accedir al panell d\'administració del sistema.';

  @override
  String get adminHomeIntegrityAlertTitle => 'Alerta d\'integritat de dades';

  @override
  String get adminHomeRunAuditNow => 'Executa l\'auditoria d\'integritat ara';

  @override
  String get adminHomeRejectionReason => 'Motiu de rebuig';

  @override
  String get adminHomeRejectionHint => 'Explica breument per què es rebutja...';

  @override
  String get adminHomeCancel => 'Cancel·la';

  @override
  String get adminHomeReject => 'Rebutja';

  @override
  String get adminHomeFiltersPending =>
      'Filtres avançats pendents d\'integració.';

  @override
  String get adminHomeCreateSeasonPending =>
      'Creació de temporada pendent d\'integració.';

  @override
  String get adminHomeRolesPending =>
      'Matriu de permisos pendent d\'integració.';

  @override
  String get adminHomeApprove => 'Aprova';

  @override
  String get adminHomeRejected => 'Rebutjat';

  @override
  String get adminHomeApproved => 'Aprovat';

  @override
  String adminHomeSeasonStats(String range, int participants) {
    return '$range · $participants edificis';
  }

  @override
  String adminHomeRoleStats(int users, int permissions) {
    return '$users usuaris · $permissions permisos';
  }

  @override
  String adminUsersUntilDate(String date) {
    return 'Fins: $date';
  }

  @override
  String get adminUsersBlock => 'Bloquejar';

  @override
  String get adminUsersUnblock => 'Desbloquejar';

  @override
  String get adminUsersUnsuspend => 'Aixecar suspensió';

  @override
  String get adminHomePanelTitle => 'Panell d\'administració';

  @override
  String get adminHomeSeasonManagement => 'Gestió de temporades';

  @override
  String adminUsersBlockedSnack(String email) {
    return '$email ha estat bloquejat.';
  }

  @override
  String adminUsersUnblockedSnack(String email) {
    return '$email ha estat desbloquejat.';
  }

  @override
  String adminUsersSuspendedSnack(String email) {
    return '$email ha estat suspès.';
  }

  @override
  String adminUsersUnsuspendedSnack(String email) {
    return 'La suspensió de $email ha estat aixecada.';
  }

  @override
  String get adminUsersIndefiniteSuspension => 'Suspensió indefinida';

  @override
  String adminHomeSeasonLabel(int seasonNumber) {
    return 'Temporada $seasonNumber';
  }

  @override
  String get adminHomeActiveUsers => 'Usuaris actius';

  @override
  String get adminHomeValidatedImprovements => 'Millores validades';

  @override
  String get adminHomeIntegrityAlerts => 'Alertes d\'integritat';

  @override
  String get adminHomeNewTrend => 'Nou';

  @override
  String get adminHomeTasksTab => 'Tasques';

  @override
  String get adminHomeSeasonsTab => 'Temporades';

  @override
  String get adminHomeRolesTab => 'Rols';

  @override
  String get adminHomeVerificationLoadError =>
      'No s\'han pogut carregar les verificacions';

  @override
  String get adminHomeRefreshVerifications => 'Actualitza verificacions';

  @override
  String adminHomeRecordsCount(int count) {
    return '$count registres';
  }

  @override
  String adminHomeClosedSeasonsCount(int count) {
    return '$count tancades';
  }

  @override
  String get adminHomeSeasonsLoading => 'Carregant';

  @override
  String get adminHomeCreateAndStartSeason => 'Crear i iniciar temporada';

  @override
  String get adminHomeCreatingAndStartingSeason =>
      'Creant i iniciant temporada...';

  @override
  String get adminHomeRefreshSeasonHistory => 'Actualitza historial';

  @override
  String get adminHomeRetryLoadSeasons => 'Reintenta carregar temporades';

  @override
  String get adminHomeSeasonLoadErrorTitle =>
      'No s\'han pogut carregar les temporades';

  @override
  String get adminHomeSeasonUnexpectedLoadError =>
      'S\'ha produït un error inesperat carregant temporades.';

  @override
  String get adminHomeNoClosedSeasonsTitle => 'No hi ha temporades tancades';

  @override
  String get adminHomeNoClosedSeasonsBody =>
      'Quan una temporada es tanqui apareixerà en aquest historial.';

  @override
  String get adminHomeSeasonActivationTitle => 'Crear i iniciar temporada';

  @override
  String get adminHomeSeasonActivationBody =>
      'El backend tancarà automàticament la temporada activa actual, si n\'hi ha, crearà la nova temporada i actualitzarà puntuacions i snapshots del rànquing.';

  @override
  String get adminHomeSeasonNameLabel => 'Nom de la temporada';

  @override
  String get adminHomeSeasonStartDateLabel => 'Data d’inici';

  @override
  String get adminHomeSeasonEndDateLabel => 'Data de fi';

  @override
  String get adminHomeSeasonSelectStartDate => 'Selecciona la data d’inici';

  @override
  String get adminHomeSeasonSelectEndDate => 'Selecciona la data de fi';

  @override
  String get adminHomeSeasonNameRequired =>
      'El nom de la temporada és obligatori';

  @override
  String get adminHomeSeasonStartDateRequired =>
      'La data d’inici és obligatòria';

  @override
  String get adminHomeSeasonEndDateRequired => 'La data de fi és obligatòria';

  @override
  String get adminHomeSeasonEndBeforeStart =>
      'La data de fi no pot ser anterior a la data d’inici';

  @override
  String get adminHomeSeasonActivationConfirm => 'Crear i iniciar';

  @override
  String get adminHomeSeasonActivationDefaultSummary =>
      'Temporada creada i iniciada correctament.';

  @override
  String adminHomeSeasonActivationSuccess(String summary) {
    return 'Temporada iniciada: $summary';
  }

  @override
  String get adminHomeSeasonActivationUnexpectedError =>
      'S\'ha produït un error inesperat creant la temporada.';

  @override
  String get adminHomeSeasonStatusActive => 'ACTIVA';

  @override
  String get adminHomeSeasonStatusClosed => 'TANCADA';

  @override
  String get adminHomeSeasonDatesUnavailable => 'Dates no disponibles';

  @override
  String adminHomeSeasonStartedOn(String date) {
    return 'Des de $date';
  }

  @override
  String adminHomeSeasonEndedOn(String date) {
    return 'Fins $date';
  }

  @override
  String get adminHomeRolesAndPermissions => 'Rols i permisos';

  @override
  String adminHomeRolesCount(int count) {
    return '$count rols';
  }

  @override
  String get adminHomeReviewPermissionsMatrix => 'Revisar matriu de permisos';

  @override
  String get adminVerificationDocumentsTitle => 'Documentació d\'administrador';

  @override
  String get adminVerificationDocumentsBody =>
      'Adjunta documentació que acrediti que pots actuar com a administrador de finca d\'aquest edifici. La verificació quedarà pendent de revisió.';

  @override
  String get adminVerificationAttachDocuments => 'Adjuntar documents';

  @override
  String get adminVerificationJpgOnly => 'Adjunta documents en format JPG.';

  @override
  String get adminVerificationRemoveDocument => 'Eliminar document';

  @override
  String get adminVerificationDocumentType => 'Tipus de document';

  @override
  String get weatherLoadError => 'No s\'ha pogut carregar la meteorologia.';

  @override
  String get weatherLoadingBarcelona =>
      'Carregant dades meteorològiques de Barcelona...';

  @override
  String weatherCurrentInCity(String city) {
    return 'Temps actual a $city';
  }

  @override
  String get weatherUpdatedByXema =>
      'Dades meteorològiques actualitzades pel servei XEMA.';

  @override
  String leagueInfoBody(String currentLeague, String nextLeague) {
    return 'Aquest edifici és actualment a la $currentLeague. Millora la qualificació energètica per passar a la $nextLeague.';
  }

  @override
  String get rankingComingSoonButton => 'Pròximament: veure el rànquing';

  @override
  String get weatherPrecipitationUnavailable => 'Precipitació no disponible';

  @override
  String weatherSolarIrradiance(String value) {
    return 'Irradiància solar: $value W/m²';
  }

  @override
  String weatherCurrentTemperature(String value) {
    return 'Temperatura actual: $value°C';
  }

  @override
  String get weatherTemperatureUnavailable => 'Temperatura no disponible';

  @override
  String weatherPrecipitation(String value) {
    return 'Precipitació: $value mm';
  }

  @override
  String get weatherSolarIrradianceUnavailable =>
      'Irradiància solar no disponible';

  @override
  String get adminHomeDashboardLoadError =>
      'No s’han pogut carregar les mètriques del panell.';

  @override
  String get adminHomeTotalUsers => 'Usuaris totals';

  @override
  String get adminHomePendingImprovements => 'Millores pendents';

  @override
  String get adminHomeManagedBuildings => 'Edificis gestionats';

  @override
  String get adminHomeImprovementsTab => 'Millores';

  @override
  String get adminHomeImprovementValidationQueue => 'Validació de millores';

  @override
  String get adminHomeImprovementLoadError =>
      'No s’han pogut carregar les millores pendents';

  @override
  String get adminHomeNoPendingImprovements => 'No hi ha millores pendents';

  @override
  String get adminHomeNoPendingImprovementsBody =>
      'Quan un administrador de finca acrediti una millora implementada, apareixerà aquí per revisar-la.';

  @override
  String get adminHomeRefreshImprovements => 'Actualitza millores';

  @override
  String get adminHomeApproveImprovement => 'Validar millora';

  @override
  String get adminHomeRejectImprovement => 'Rebutjar millora';

  @override
  String get adminHomeImprovementApproved => 'Millora validada correctament.';

  @override
  String get adminHomeImprovementRejected => 'Millora rebutjada correctament.';

  @override
  String get adminHomeUnexpectedImprovementError =>
      'S’ha produït un error inesperat revisant la millora.';

  @override
  String get adminHomeImprovementCost => 'Cost';

  @override
  String get adminHomeImprovementDate => 'Data';

  @override
  String get adminHomeImprovementObservations => 'Observacions';
}
