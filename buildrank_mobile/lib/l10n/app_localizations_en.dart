// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get authLanguageLabel => 'Language';

  @override
  String get authLanguageCatalan => 'Català';

  @override
  String get authLanguageSpanish => 'Español';

  @override
  String get authLanguageEnglish => 'English';

  @override
  String get authLoginTab => 'Log in';

  @override
  String get authRegisterTab => 'Sign up';

  @override
  String authRegisterSuccessWithEmail(String email) {
    return 'Account created successfully. You can now log in with $email.';
  }

  @override
  String get loginWelcomeTitle => 'Welcome to BuildRank';

  @override
  String get loginWelcomeSubtitle =>
      'Manage your building, check the energy ranking, and track your progress from one place.';

  @override
  String get loginCardTitle => 'Log in';

  @override
  String get loginCardSubtitle =>
      'Access your account to view your building information.';

  @override
  String get emailLabel => 'Email';

  @override
  String get emailHint => 'name@example.com';

  @override
  String get passwordLabel => 'Password';

  @override
  String get loginForgotPassword => 'Forgot your password?';

  @override
  String get loginButton => 'Log in';

  @override
  String get loginGoogleButton => 'Continue with Google';

  @override
  String get loginMissingFieldsError =>
      'You must fill in both email and password.';

  @override
  String get registerTitle => 'Create an account';

  @override
  String get registerSubtitle => 'Start tracking your building today';

  @override
  String get registerCardTitle => 'Sign up';

  @override
  String get registerCardSubtitle =>
      'Create your account to start managing buildings.';

  @override
  String get registerRoleHeader => 'SELECT YOUR ROLE';

  @override
  String get registerRoleAdmin => 'Property\nadmin';

  @override
  String get registerRoleOwner => 'Owner';

  @override
  String get registerRoleTenant => 'Tenant';

  @override
  String get firstNameLabel => 'First name';

  @override
  String get lastNameLabel => 'Last name';

  @override
  String get confirmPasswordLabel => 'Confirm password';

  @override
  String get registerAcceptTermsPrefix => 'I accept the ';

  @override
  String get registerTermsOfService => 'Terms of Service';

  @override
  String get registerAcceptTermsMiddle => ' and the ';

  @override
  String get registerPrivacyPolicy => 'Privacy Policy';

  @override
  String get registerCreateAccountButton => 'Create BuildRank account';

  @override
  String get registerGoogleButton => 'Create account with Google';

  @override
  String get registerMissingFieldsError => 'You must fill in all fields.';

  @override
  String get registerPasswordsMismatchError => 'Passwords do not match.';

  @override
  String get registerAcceptTermsError =>
      'You must accept the terms and conditions.';

  @override
  String get registerSuccessInline =>
      'Account created successfully. You can now log in.';

  @override
  String get registerSuccessSnackBar => 'Registration completed successfully.';

  @override
  String get passwordResetAppBarTitle => 'Reset password';

  @override
  String get passwordResetRequestTitle => 'Recover your password';

  @override
  String get passwordResetConfirmTitle => 'Create a new password';

  @override
  String get passwordResetRequestSubtitle =>
      'Enter the email linked to your account and paste the link received by email.';

  @override
  String get passwordResetConfirmSubtitle =>
      'Enter a new password for your account.';

  @override
  String get passwordResetSendInstructions => 'Send instructions';

  @override
  String get passwordResetHaveLinkTitle => 'Already have the link?';

  @override
  String get passwordResetHaveLinkBody =>
      'Paste the link received by email here. BuildRank will automatically extract the uid and token.';

  @override
  String get passwordResetLinkLabel => 'Recovery link';

  @override
  String get passwordResetLinkHint =>
      'https://.../reset-password?uid=...&token=...';

  @override
  String get passwordResetContinueWithLink => 'Continue with link';

  @override
  String get newPasswordLabel => 'New password';

  @override
  String get confirmNewPasswordLabel => 'Confirm new password';

  @override
  String get passwordResetSubmit => 'Reset password';

  @override
  String get passwordResetPasteAnotherLink => 'Paste another link';

  @override
  String get passwordResetEmailRequiredError => 'Enter your email address.';

  @override
  String get passwordResetRequestSuccess =>
      'If the email exists, you will receive a link to reset your password. Paste it here when you have it.';

  @override
  String get passwordResetLinkRequiredError =>
      'Paste the recovery link received by email.';

  @override
  String get passwordResetInvalidLinkError =>
      'Could not find the uid and token parameters inside the link.';

  @override
  String get passwordResetLinkValidatedSuccess =>
      'Link validated. Enter the new password.';

  @override
  String get passwordResetPasswordRequiredError =>
      'Enter and confirm the new password.';

  @override
  String get passwordResetSuccessSnackBar => 'Password reset successfully.';

  @override
  String get legalTermsTitle => 'Terms of Service';

  @override
  String get legalPrivacyTitle => 'Privacy Policy';

  @override
  String get legalTermsSubtitle => 'Basic terms for using BuildRank';

  @override
  String get legalPrivacySubtitle =>
      'How BuildRank handles data within the MVP';

  @override
  String get legalInfoNotice =>
      'BuildRank is an academic project in MVP stage. This text summarizes the terms and privacy criteria that apply to the demo and use of the prototype.';

  @override
  String get legalTermsSection1Title => '1. Purpose of the service';

  @override
  String get legalTermsSection1Body =>
      'BuildRank is an application designed to promote more responsible and sustainable energy use in residential buildings. It lets users consult building information, view indicators, compare results, simulate improvements, and participate in community features according to the user\'s role.';

  @override
  String get legalTermsSection2Title =>
      '2. Informational nature of the information';

  @override
  String get legalTermsSection2Body =>
      'Scores, rankings, estimated energy ratings, simulations, Heat Risk Index, and badges are informational and indicative. They do not constitute official energy certifications, professional technical reports, or conclusive engineering recommendations.';

  @override
  String get legalTermsSection3Title => '3. Responsible use of the application';

  @override
  String get legalTermsSection3Body =>
      'The user agrees to use BuildRank responsibly, not to enter false data or third-party data without authorization, and to respect community rules in votes, chats, and shared spaces.';

  @override
  String get legalTermsSection4Title => '4. Roles and permissions';

  @override
  String get legalTermsSection4Body =>
      'Available actions may vary depending on the user\'s role and relationship with a building. Some actions, such as managing buildings, validating requests, recalculating badges, or administering votes, may be limited to authorized administrators.';

  @override
  String get legalTermsSection5Title =>
      '5. Open data, manual data, and estimates';

  @override
  String get legalTermsSection5Body =>
      'BuildRank may combine open data, manually entered data, and estimated results. When data is incomplete, estimated, or pending verification, the application will try to indicate this clearly so the user can interpret it correctly.';

  @override
  String get legalTermsSection6Title => '6. Human review and official sources';

  @override
  String get legalTermsSection6Body =>
      'In case of discrepancy regarding energy data, documentation, ownership, or permissions, human review and official sources prevail over any automatic or estimated result shown by the system.';

  @override
  String get legalPrivacySection1Title => '1. Data processed';

  @override
  String get legalPrivacySection1Body =>
      'BuildRank may process account data, user role, associated buildings, linked homes, requests, votes, simulations, notifications, and validation or administration actions.';

  @override
  String get legalPrivacySection2Title => '2. Purpose of processing';

  @override
  String get legalPrivacySection2Body =>
      'Data is used to authenticate users, manage buildings, apply permissions, show indicators, enable community participation, record sensitive actions, and improve the quality of system data.';

  @override
  String get legalPrivacySection3Title => '3. Data minimization';

  @override
  String get legalPrivacySection3Body =>
      'BuildRank tries to show only the information needed for each feature. For example, general views such as the map should not expose emails, documents, homes, or unnecessary personal data.';

  @override
  String get legalPrivacySection4Title => '4. Documents and verifications';

  @override
  String get legalPrivacySection4Body =>
      'In verification processes, uploaded documents may contain sensitive information. These files should be used only to review the necessary evidence and not for purposes unrelated to the validation process.';

  @override
  String get legalPrivacySection5Title => '5. Traceability and audit';

  @override
  String get legalPrivacySection5Body =>
      'Sensitive actions may be recorded for security, audit, and system integrity purposes. This traceability helps explain relevant changes to permissions, validations, buildings, votes, or scores.';

  @override
  String get legalPrivacySection6Title =>
      '6. Use of AI and automatic decisions';

  @override
  String get legalPrivacySection6Body =>
      'Any automated or AI-based support, if present, should be understood as an aid for detecting inconsistencies or review points. It does not replace human review and should not approve documents, assign roles, or modify scores autonomously.';

  @override
  String get legalPrivacySection7Title => '7. User responsibility';

  @override
  String get legalPrivacySection7Body =>
      'The user should avoid uploading unnecessary information or third-party documents without authorization. Keys, tokens, and credentials must not be shared or entered outside the forms provided by the application.';

  @override
  String get commonRetry => 'Try again';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonConfirm => 'Confirm';

  @override
  String get commonBack => 'Back';

  @override
  String get commonRefresh => 'Refresh';

  @override
  String get commonHideForSession => 'Hide for this session';

  @override
  String commonErrorWithValue(String error) {
    return 'Error: $error';
  }

  @override
  String get adminUserManagementTitle => 'User management';

  @override
  String get notificationsTitle => 'Notifications';

  @override
  String get notificationsMarkAll => 'Mark all';

  @override
  String get notificationsLoadError => 'Could not load notifications.';

  @override
  String get notificationsEmpty => 'You have no notifications';

  @override
  String get notificationsNow => 'Just now';

  @override
  String notificationsMinutesAgo(int count) {
    return '$count min ago';
  }

  @override
  String notificationsHoursAgo(int count) {
    return '$count h ago';
  }

  @override
  String notificationsDaysAgo(int count) {
    return '$count days ago';
  }

  @override
  String get myChatsTitle => 'My chats';

  @override
  String get myChatsConnectionError => 'Could not connect to chat.';

  @override
  String get myChatsReconnect => 'Reconnect';

  @override
  String get myChatsNoMessages => 'No messages';

  @override
  String get myChatsEmpty => 'You have no active chats.';

  @override
  String get myChatsDirectDescription =>
      'Direct conversation or shared channel between administrators.';

  @override
  String get chatFallbackName => 'Chat';

  @override
  String get chatDirectDescription =>
      'Direct conversation between property administrators.';

  @override
  String get chatUserNotConnectedError =>
      'User not connected. Sign out and sign back in.';

  @override
  String chatConnectionError(String error) {
    return 'Error connecting chat:\n$error';
  }

  @override
  String get homeRankingTitle => 'Ranking';

  @override
  String get homeProfileTitle => 'Profile';

  @override
  String get homeGreeting => 'Good morning';

  @override
  String get homeSummaryTitle => 'Your building summary';

  @override
  String get homeSummarySubtitle =>
      'Check the current energy status, your league position, and the next recommended actions.';

  @override
  String get homeDemoBuildingName => 'Central Library';

  @override
  String get homeDemoBuildingSubtitle => 'Building monitored this week';

  @override
  String get homeMetricConsumption => 'Consumption';

  @override
  String get homeMetricPosition => 'Position';

  @override
  String get homeMetricImprovement => 'Improvement';

  @override
  String get homeKeyIndicatorsTitle => 'Key indicators';

  @override
  String get homeTodayConsumptionTitle => 'Estimated consumption today';

  @override
  String get homeTodayConsumptionSubtitle => '18 kWh · 6% less than yesterday';

  @override
  String get homeLeaguePositionTitle => 'League position';

  @override
  String get homeLeaguePositionSubtitle => '3rd position out of 12 buildings';

  @override
  String get homeRecommendationTitle => 'Main recommendation';

  @override
  String get homeRecommendationSubtitle =>
      'Reduce air conditioning in the afternoon';

  @override
  String get homeQuickActionsTitle => 'Quick actions';

  @override
  String get homeBuildingTitle => 'Building';

  @override
  String get homeImprovementsTitle => 'Improvements';

  @override
  String get homeCommunityTitle => 'Community';

  @override
  String get homeWeeklyGoalTitle => 'Weekly goal';

  @override
  String get homeWeeklyGoalBody =>
      'Keep consumption below 130 kWh to consolidate your place in the top 3.';

  @override
  String get twinTitle => 'Twin Building';

  @override
  String get twinIntroTitle => 'Administrators of comparable buildings';

  @override
  String twinIntroBody(String buildingName) {
    return 'Contact property administrators of buildings similar to $buildingName to share experiences about energy improvements, votes, and community management.';
  }

  @override
  String get twinEmptyTitle => 'No comparable administrators are available.';

  @override
  String get twinEmptyBody =>
      'The building may not have a comparable group yet, or there may be no other administered buildings in the same group.';

  @override
  String twinChannelName(String address) {
    return 'Twin Building with $address';
  }

  @override
  String twinChannelDescription(String adminName, String address) {
    return 'Conversation with $adminName, administrator of $address.';
  }

  @override
  String twinPoints(String points) {
    return '$points pts';
  }

  @override
  String get twinTypologyFallback => 'Typology';

  @override
  String twinClimateZone(String zone) {
    return 'Zone $zone';
  }

  @override
  String twinAdminLine(String adminName) {
    return 'Admin: $adminName';
  }

  @override
  String get twinOpenChat => 'Open chat';

  @override
  String get editProfileTitle => 'Edit profile';

  @override
  String get editProfilePersonalDataTitle => 'Personal details';

  @override
  String get editProfilePersonalDataSubtitle =>
      'Update your account\'s basic information. The role cannot be changed from this screen.';

  @override
  String get editProfileRoleLabel => 'Role';

  @override
  String get editProfileSaving => 'Saving...';

  @override
  String get editProfileSaveChanges => 'Save changes';

  @override
  String get editProfileFirstNameRequired => 'First name is required.';

  @override
  String get editProfileLastNameRequired => 'Last name is required.';

  @override
  String get editProfileEmailRequired => 'Email is required.';

  @override
  String get editProfileEmailInvalid => 'Enter a valid email address.';

  @override
  String get editProfileSuccess => 'Profile updated successfully.';

  @override
  String get votesCreateTitle => 'New vote';

  @override
  String get votesCreateAction => 'Create';

  @override
  String get votesTitleLabel => 'Title';

  @override
  String get votesTitleHint => 'Voting title';

  @override
  String get votesTitleRequiredError => 'The title is required.';

  @override
  String get votesTitleMinLengthError =>
      'The title must be at least 4 characters long.';

  @override
  String get votesDescriptionOptionalLabel => 'Description (optional)';

  @override
  String get votesDescriptionHint => 'Voting context...';

  @override
  String get votesDeadlineOptionalLabel => 'Deadline (optional)';

  @override
  String get votesNoDeadline => 'No deadline';

  @override
  String get votesOptionsLabel => 'Options';

  @override
  String get votesOptionsLimitHint => 'Minimum 2 · Maximum 8';

  @override
  String get votesAddOption => 'Add option';

  @override
  String votesOptionHint(int number) {
    return 'Option $number';
  }

  @override
  String get votesOptionRequiredError => 'This option cannot be empty.';

  @override
  String get votesDuplicateOptionsError =>
      'There are duplicate options. Review them.';

  @override
  String get pendingRequestsTitle => 'Pending requests';

  @override
  String pendingRequestsIntro(String buildingTitle) {
    return 'Here you can review and validate resident join requests for $buildingTitle.';
  }

  @override
  String pendingRequestsCount(int count) {
    return '$count pending';
  }

  @override
  String get pendingRequestsEmptyTitle => 'No pending requests';

  @override
  String get pendingRequestsEmptyBody =>
      'When other users ask to join this building, they will appear here.';

  @override
  String get pendingRequestsUnexpectedError => 'An unexpected error occurred.';

  @override
  String get pendingRequestsForbidden =>
      'Only the property administrator can manage pending requests.';

  @override
  String pendingRequestsAccepted(String name) {
    return 'The request from $name has been accepted.';
  }

  @override
  String pendingRequestsRejected(String name) {
    return 'The request from $name has been rejected.';
  }

  @override
  String get pendingRequestsResidentChip => 'Resident';

  @override
  String get pendingRequestsRequestTypeLabel => 'Request type';

  @override
  String get pendingRequestsResidentJoinType => 'Resident join request';

  @override
  String get pendingRequestsDateLabel => 'Date';

  @override
  String get pendingRequestsCadastralReferenceLabel => 'Cadastral reference';

  @override
  String get pendingRequestsHomeLabel => 'Home';

  @override
  String get pendingRequestsSurfaceLabel => 'Surface';

  @override
  String get pendingRequestsReject => 'Reject';

  @override
  String get pendingRequestsAccept => 'Accept';

  @override
  String get pendingRequestsNotSpecified => 'Not specified';

  @override
  String pendingRequestsFloorDoor(String floor, String door) {
    return 'Floor $floor · Door $door';
  }

  @override
  String pendingRequestsFloor(String floor) {
    return 'Floor $floor';
  }

  @override
  String pendingRequestsDoor(String door) {
    return 'Door $door';
  }

  @override
  String get chatReasonOptionalHint => 'Reason (optional)';

  @override
  String get chatConfirmActionTitle => 'Confirm action';

  @override
  String get chatDurationLabel => 'Duration';

  @override
  String get chatDurationIndefinite => 'Indefinite';

  @override
  String get chatDuration30Minutes => '30 minutes';

  @override
  String get chatDuration1Hour => '1 hour';

  @override
  String get chatDuration6Hours => '6 hours';

  @override
  String get chatDuration24Hours => '24 hours';

  @override
  String get chatReportMessage => 'Report message';

  @override
  String get chatHideMessage => 'Hide message';

  @override
  String get chatDeleteMyMessage => 'Delete my message';

  @override
  String get chatDeleteMessage => 'Delete message';

  @override
  String get chatRestoreMessage => 'Restore message';

  @override
  String get chatDismissReport => 'Dismiss report';

  @override
  String get chatDeleteOwnMessageConfirm =>
      'Are you sure you want to delete your message?';

  @override
  String get chatDeleteOtherMessageConfirm => 'Delete this user\'s message?';

  @override
  String get chatMessageReported => 'Message reported.';

  @override
  String get chatMessageHidden => 'Message hidden.';

  @override
  String get chatMessageDeleted => 'Message deleted.';

  @override
  String get chatMessageRestored => 'Message restored.';

  @override
  String get chatReportDismissed => 'Report dismissed.';

  @override
  String get chatWarnUser => 'Warn user';

  @override
  String get chatMuteUser => 'Mute user';

  @override
  String get chatBanFromChannel => 'Ban from channel';

  @override
  String get chatGlobalBan => 'Global ban';

  @override
  String get chatShadowBan => 'Shadow ban';

  @override
  String get chatWarn => 'Warn';

  @override
  String get chatMute => 'Mute';

  @override
  String get chatUnmute => 'Unmute';

  @override
  String get chatReadmitToChannel => 'Readmit to channel';

  @override
  String get chatLiftGlobalBan => 'Lift global ban';

  @override
  String get chatLiftShadowBan => 'Lift shadow ban';

  @override
  String get chatWarningSent => 'Warning sent.';

  @override
  String get chatUserMuted => 'User muted.';

  @override
  String get chatUserUnmuted => 'User unmuted.';

  @override
  String get chatUserBannedFromChannel => 'User banned from channel.';

  @override
  String get chatUserUnbannedFromChannel => 'User readmitted to channel.';

  @override
  String get chatUserGloballyBanned => 'User globally banned.';

  @override
  String get chatGlobalUnbanConfirm => 'Lift this user\'s global ban?';

  @override
  String get chatGlobalBanLifted => 'Global ban lifted.';

  @override
  String get chatShadowBanApplied => 'Shadow ban applied.';

  @override
  String get chatShadowUnbanConfirm => 'Lift this user\'s shadow ban?';

  @override
  String get chatShadowBanLifted => 'Shadow ban lifted.';

  @override
  String chatCommunityTitle(String buildingName) {
    return '$buildingName community';
  }

  @override
  String get chatCommunitySubtitle =>
      'Talk with this building\'s members about improvements, incidents, and proposals.';

  @override
  String get chatContactSimilarAdmins => 'Contact similar admins';

  @override
  String get mapTitle => 'Building map';

  @override
  String get mapSearchHint => 'Search by street, neighborhood, or postal code';

  @override
  String get mapSearchTooltip => 'Search';

  @override
  String get mapFilterAll => 'All';

  @override
  String mapFilterMinScore(int score) {
    return '≥ $score';
  }

  @override
  String get mapNoValidCoordinates =>
      'There are no buildings with valid coordinates to show.';

  @override
  String mapShownOfCount(int shown, int count) {
    return '$shown of $count buildings shown';
  }

  @override
  String mapShownCount(int shown) {
    return '$shown buildings on the map';
  }

  @override
  String get mapLoadError => 'Could not load the map.';

  @override
  String get profileUserFallback => 'User';

  @override
  String get profileRoleAdmin => 'Property administrator';

  @override
  String get profileRoleOwner => 'Owner';

  @override
  String get profileRoleTenant => 'Tenant';

  @override
  String get profileAdminBuildingsTitle => 'Managed buildings';

  @override
  String get profileOwnerBuildingsTitle => 'Buildings for my homes';

  @override
  String get profileTenantBuildingsTitle => 'Linked buildings';

  @override
  String get profileAccessibleBuildingsTitle => 'Accessible buildings';

  @override
  String get profileEmptyAdminBuildings =>
      'You do not have any buildings assigned as a property administrator yet. You can create one with the registration form.';

  @override
  String get profileEmptyOwnerBuildings =>
      'You do not have any homes linked to your account yet. When an administrator assigns you a home, you will see the corresponding building here.';

  @override
  String get profileEmptyTenantBuildings =>
      'You do not have any home linked to your account yet. When you are assigned to a home, you will see the corresponding building here.';

  @override
  String get profileEmptyAccessibleBuildings =>
      'There are no buildings available for this account yet.';

  @override
  String get profileBuildingCreated => 'Building created successfully.';

  @override
  String get profileLogoutTooltip => 'Sign out';

  @override
  String get profileReportsSoon =>
      'Board meeting reports are not available yet in this MVP.';

  @override
  String get profileCreateBuilding => 'Create building';

  @override
  String get profileReports => 'Reports';

  @override
  String get profileNonAdminInfo =>
      'This account can view buildings linked to its homes. Building creation and administration are reserved for property administrators.';

  @override
  String get profileMapSubtitle =>
      'View registered buildings and check their main statistics.';

  @override
  String get profileLinkNewBuilding => 'Link new building';

  @override
  String get profileLoadError => 'Could not load the profile.';

  @override
  String get profileMetricBuildings => 'BUILDINGS';

  @override
  String get profileMetricLinks => 'LINKS';

  @override
  String get profileMetricAvgRanking => 'AVG RANKING';

  @override
  String get profileMetricProgress => 'PROGRESS';

  @override
  String get profileSeasonRestart => 'Next season restart';

  @override
  String profileSeasonDaysLeft(int days) {
    return '$days days left';
  }

  @override
  String get profileBadgesTitle => 'Building badges';

  @override
  String get profileBadgesBody =>
      'Real badges are shown inside each building profile. When a building meets score, data quality, or improvement criteria, they will appear in its details.';

  @override
  String profileBuildingNumber(int id) {
    return 'Building #$id';
  }

  @override
  String get profileLocationUnavailable => 'Location unavailable';

  @override
  String get profileInactive => 'Inactive';

  @override
  String get profileActive => 'Active';

  @override
  String get accountBlockedTitle => 'Account blocked';

  @override
  String get accountBlockedBody =>
      'Your account has been permanently blocked. Contact the administrator for more information.';

  @override
  String get accountSuspendedTitle => 'Account suspended';

  @override
  String get accountSuspendedBody =>
      'Your account is temporarily suspended. Contact the administrator for more information.';

  @override
  String get accountBackToLogin => 'Back to login';

  @override
  String get appName => 'BuildRank';

  @override
  String get commonUnavailable => 'No disponible';

  @override
  String get commonUnknownError => 'Error desconegut.';

  @override
  String get commonRequiredField => 'Camp obligatori';

  @override
  String get commonInvalidNumber => 'Enter a valid number';

  @override
  String get commonGreaterThanZero => 'Ha de ser superior a 0';

  @override
  String get commonContinue => 'Continue →';

  @override
  String get mainNavHome => 'Home';

  @override
  String get mainNavLeagues => 'Leagues';

  @override
  String get mainNavSimulate => 'Simulate';

  @override
  String get mainNavChat => 'Chat';

  @override
  String get mainNavVotes => 'Votes';

  @override
  String get habitatgeCadastralReference => 'Cadastral reference';

  @override
  String get habitatgeFloor => 'Planta';

  @override
  String get habitatgeDoor => 'Porta';

  @override
  String get habitatgeSurface => 'Area (m²)';

  @override
  String get addExistingAppBarTitle => 'Link building';

  @override
  String get addExistingTitle => 'Link yourself to an existing building';

  @override
  String get addExistingAdminSubtitle =>
      'When you select a building, a request will be sent to link you as the property manager.';

  @override
  String get addExistingResidentSubtitle =>
      'When you select a building, a join request will be sent to the property manager so they can validate you as a resident.';

  @override
  String get addExistingLocationSection => 'Location';

  @override
  String get addExistingSearchHint => 'Type your building street...';

  @override
  String get addExistingMinSearch =>
      'Enter at least 3 characters to start searching.';

  @override
  String get addExistingResultsTitle => 'Results';

  @override
  String get addExistingNoResults => 'No building was found at that address.';

  @override
  String addExistingSelectedBuilding(String buildingName, String role) {
    return 'Selected: $buildingName · Requested role: $role';
  }

  @override
  String get addExistingClosedRequests =>
      'This building is not accepting new join requests right now.';

  @override
  String get addExistingHabitatgeTitle => 'Home details';

  @override
  String get addExistingHabitatgeSubtitle =>
      'Complete your home details to send the join request.';

  @override
  String get addExistingSubmit => 'Send request';

  @override
  String get addExistingAdminRequestSent =>
      'The request to link you as property manager has been sent.';

  @override
  String get addExistingResidentRequestSent =>
      'The join request has been sent to the property manager.';

  @override
  String get rankingLoadError => 'Could not load the ranking.';

  @override
  String get rankingLoadMoreError => 'Could not load more competitors.';

  @override
  String get rankingProgressLoadError =>
      'Could not load the progress evolution.';

  @override
  String get rankingScopeLeague => 'My league';

  @override
  String get rankingScopeComparableLeague => 'Similar league';

  @override
  String get rankingScopeComparableSeason => 'Similar season';

  @override
  String get rankingUnavailableTitle => 'Ranking unavailable';

  @override
  String get rankingLoadErrorTitle => 'Could not load the ranking';

  @override
  String rankingActiveSeason(String seasonName) {
    return 'Active season: $seasonName';
  }

  @override
  String rankingProgressToTop(int target) {
    return 'Progress toward Top $target';
  }

  @override
  String rankingPointsProgress(String currentPoints, String targetPoints) {
    return '$currentPoints / $targetPoints points';
  }

  @override
  String get rankingSeasonPendingCalendar => 'Season pending calendar.';

  @override
  String rankingCurrentPosition(int position) {
    return 'Current position: #$position';
  }

  @override
  String get rankingComparisonPeriod => 'Comparison period';

  @override
  String rankingLastSeasons(int count) {
    return 'Last $count';
  }

  @override
  String rankingTopTarget(int target) {
    return 'Top $target';
  }

  @override
  String get rankingBadgesEarned => 'Badges earned';

  @override
  String get rankingViewAll => 'View all';

  @override
  String get rankingBadgeSolarMaster => 'Solar master';

  @override
  String get rankingBadgeDateOct25 => 'Oct 25';

  @override
  String get rankingBadgeMaxSavings => 'Maximum savings';

  @override
  String get rankingBadgeDateNov25 => 'Nov 25';

  @override
  String get rankingBadgeResilient => 'Resilient';

  @override
  String get rankingBadgeDateDec25 => 'Dec 25';

  @override
  String get rankingBadgeTest => 'Test';

  @override
  String get rankingBadgeDateJan26 => 'Jan 26';

  @override
  String get rankingSearchHint => 'Search by street...';

  @override
  String get rankingNoCompetitors =>
      'No competitor was found with these filters.';

  @override
  String get rankingLoadMore => 'Load more competitors';

  @override
  String get rankingNoProgressHistory =>
      'There is no progress history for this building yet.';

  @override
  String get rankingSeasonProgressTitle => 'Season progress';

  @override
  String rankingSeasonProgressSubtitle(int count) {
    return 'Real evolution during the last $count available seasons.';
  }

  @override
  String rankingProgressForBuilding(String buildingName) {
    return 'Progress for $buildingName';
  }

  @override
  String rankingProgressModalSubtitle(int count) {
    return 'Score evolution during the last $count seasons.';
  }

  @override
  String rankingAccumulatedImprovement(int delta) {
    return 'Accumulated improvement: +$delta points';
  }

  @override
  String rankingPointsRange(int startPoints, int currentPoints) {
    return '$startPoints · $currentPoints points';
  }

  @override
  String rankingDeltaPoints(String deltaText) {
    return '$deltaText pts';
  }

  @override
  String get rankingViewDetail => 'Veure detall';

  @override
  String get buildingCardDetailLoadError =>
      'Could not load the building details.';

  @override
  String get buildingCardBadgesRecalculated =>
      'Badges recalculated successfully.';

  @override
  String get buildingCardBadgesLoadError => 'Could not load the badges.';

  @override
  String get buildingCardLoadError => 'Could not load the building.';

  @override
  String buildingCardClimateZone(String zone) {
    return 'Climate zone $zone';
  }

  @override
  String get buildingCardScoreExcellent => 'EXCELLENT';

  @override
  String get buildingCardScoreGood => 'GOOD';

  @override
  String get buildingCardScoreImprove => 'NEEDS IMPROVEMENT';

  @override
  String get buildingCardScorePriority => 'PRIORITY';

  @override
  String get buildingCardEstimatedRating => 'ESTIMATED RATING';

  @override
  String buildingCardPendingData(String items) {
    return 'Pending data: $items';
  }

  @override
  String get buildingCardBaseScore => 'BuildRank base score';

  @override
  String get buildingCardPerformance => 'PERFORMANCE';

  @override
  String get buildingCardInitialData => 'Initial data';

  @override
  String get buildingCardSurface => 'AREA';

  @override
  String get buildingCardFloors => 'FLOORS';

  @override
  String get buildingCardOrientation => 'ORIENTATION';

  @override
  String get buildingCardBadgesTitle => 'BUILDING BADGES';

  @override
  String get buildingCardRecalculate => 'Recalculate';

  @override
  String get buildingCardNoBadges =>
      'This building does not have any badges yet. They will appear when it reaches a milestone.';

  @override
  String get buildingCardRecommendedActions => 'RECOMMENDED ACTIONS';

  @override
  String get buildingCardActionSimulationTitle => 'Run simulation';

  @override
  String get buildingCardActionSimulationSubtitle =>
      'Try improvement scenarios for this building';

  @override
  String get buildingCardActionVoteTitle => 'Community vote';

  @override
  String get buildingCardActionVoteSubtitle =>
      'Feature ready for future proposals';

  @override
  String get buildingCardActionReportTitle => 'Board report (coming soon)';

  @override
  String get buildingCardActionReportSubtitle =>
      'Report generation is not available in this MVP yet';

  @override
  String get buildingCardActionManageRequestsTitle => 'Manage pending requests';

  @override
  String get buildingCardActionManageRequestsSubtitle =>
      'Review and validate new building join requests';

  @override
  String get buildingCardActionEditHabitatgeTitle => 'Edit my home';

  @override
  String get buildingCardActionEditHabitatgeSubtitle =>
      'Complete area, renovation and energy details';

  @override
  String get buildingCardTabDetails => 'Details';

  @override
  String get buildingCardTabHistory => 'History';

  @override
  String get buildingCardTabDocuments => 'Documents';

  @override
  String get buildingCardHistoryUnavailableTitle => 'History not available yet';

  @override
  String get buildingCardHistoryUnavailableBody =>
      'This section will show score changes, validations and saved simulations.';

  @override
  String get buildingCardDocumentsSoonTitle =>
      'Documents and reports (coming soon)';

  @override
  String get buildingCardDocumentsSoonBody =>
      'This section is prepared for a future document integration. This MVP does not show generated documents or reports.';

  @override
  String get buildingCardConstructionYear => 'CONSTRUCTION YEAR';

  @override
  String buildingCardFloorsCount(String count) {
    return '$count floors';
  }

  @override
  String get buildingCardTypology => 'TYPOLOGY';

  @override
  String get buildingCardRegulation => 'REGULATION';

  @override
  String get buildingCardNoLocation =>
      'This building does not have an associated location yet.';

  @override
  String buildingCardLocationSummary(
    String street,
    String number,
    String neighborhood,
    String postalCode,
  ) {
    return 'Location: $street, $number · $neighborhood · $postalCode';
  }

  @override
  String get buildingFormStreetMinChars =>
      'Type at least 2 characters to search for the street.';

  @override
  String buildingFormNoStreetFound(String query) {
    return 'No street was found for \"$query\".';
  }

  @override
  String get buildingFormStreetSuggestionsError =>
      'Could not load street suggestions.';

  @override
  String get buildingFormPostalCodeRequired => 'Postal code is required.';

  @override
  String get buildingFormPostalCodeInvalid => 'Postal code must have 5 digits.';

  @override
  String get buildingFormNeighborhoodRequired => 'Neighborhood is required.';

  @override
  String get buildingFormStreetRequired => 'Street name is required.';

  @override
  String get buildingFormStreetSelectionRequired =>
      'Select a street from the suggestions list.';

  @override
  String get buildingFormNumberRequired => 'Street number is required.';

  @override
  String get buildingFormNumberPositive =>
      'Street number must be a positive integer.';

  @override
  String buildingFormNumberOutOfRange(int minNumber, int maxNumber) {
    return 'The number is outside the allowed range for this street ($minNumber-$maxNumber).';
  }

  @override
  String get buildingFormTypeRequired => 'You must select a typology.';

  @override
  String get buildingFormConstructionYearRequired =>
      'Construction year is required.';

  @override
  String get buildingFormConstructionYearInteger =>
      'Construction year must be an integer.';

  @override
  String buildingFormConstructionYearRange(int currentYear) {
    return 'Construction year must be between 1800 and $currentYear.';
  }

  @override
  String get buildingFormRegulationRequired =>
      'Current regulation is required.';

  @override
  String get buildingFormFloorsRequired => 'Number of floors is required.';

  @override
  String get buildingFormFloorsPositive =>
      'The number of floors must be a positive integer.';

  @override
  String get buildingFormSurfaceRequired => 'Total area is required.';

  @override
  String get buildingFormSurfacePositive =>
      'Total area must be a positive number.';

  @override
  String get buildingFormOrientationRequired => 'Select a main orientation.';

  @override
  String get buildingFormDocumentsRequired =>
      'Attach at least one verification document.';

  @override
  String get buildingFormCreatedMissingId =>
      'The building was created, but the response did not include a recognizable identifier.';

  @override
  String get buildingFormSubmitSuccess =>
      'Building created and documentation sent. It is pending review.';

  @override
  String get buildingFormUnexpectedSaveError =>
      'An unexpected error occurred while saving the building.';

  @override
  String get buildingFormTypeResidential => 'Residential';

  @override
  String get buildingFormTypeCommercial => 'Commercial';

  @override
  String get buildingFormTypeEducational => 'Educational';

  @override
  String get buildingFormTypeHealthcare => 'Healthcare';

  @override
  String get buildingFormTypeMixed => 'Mixed';

  @override
  String get buildingFormTypeResidentialSubtitle =>
      'Single-family or apartments';

  @override
  String get buildingFormTypeCommercialSubtitle => 'Offices, shops...';

  @override
  String get buildingFormTypeEducationalSubtitle => 'Schools';

  @override
  String get buildingFormTypeHealthcareSubtitle => 'Hospitals';

  @override
  String get buildingFormTypeMixedSubtitle => 'Combined uses';

  @override
  String get orientationNorth => 'North';

  @override
  String get orientationSouth => 'South';

  @override
  String get orientationEast => 'East';

  @override
  String get orientationWest => 'West';

  @override
  String get buildingFormNewBuildingChip => 'New building';

  @override
  String get buildingFormTitle => 'Register the building';

  @override
  String get buildingFormStep1Subtitle =>
      'Let\'s start with the building location.';

  @override
  String get buildingFormStep2Subtitle =>
      'Now complete the general information.';

  @override
  String get buildingFormStep3Subtitle => 'Add the basic technical data.';

  @override
  String get buildingFormStep4Subtitle =>
      'Attach documentation to validate yourself as property manager.';

  @override
  String get buildingFormLocationSection => 'LOCATION';

  @override
  String get buildingFormPostalCodeLabel => 'Postal code';

  @override
  String get buildingFormPostalCodeHint => 'e.g., 08025';

  @override
  String get buildingFormOr => 'o';

  @override
  String get buildingFormNeighborhoodLabel => 'Neighborhood';

  @override
  String get buildingFormNeighborhoodHint => 'e.g., Sagrada Família';

  @override
  String get buildingFormStreetLabel => 'Street name';

  @override
  String get buildingFormStreetHint => 'Start typing the street';

  @override
  String buildingFormStreetNumberRange(int minNumber, int maxNumber) {
    return 'Numbers $minNumber-$maxNumber';
  }

  @override
  String get buildingFormStreetRangeUnknown => 'Numbering range not provided';

  @override
  String get buildingFormNumberLabel => 'Number';

  @override
  String get buildingFormNumberHint => 'p. ex., 123';

  @override
  String get buildingFormLocationInfo =>
      'Select a street from the suggestions list. When saving, BuildRank will first create the location and then the building linked to your property manager account.';

  @override
  String get buildingFormGeneralSection => 'GENERAL INFORMATION';

  @override
  String get buildingFormRegisteredLocation => 'Registered location';

  @override
  String get buildingFormAddressLabel => 'Address';

  @override
  String get buildingFormTypeLabel => 'Building typology';

  @override
  String get buildingFormConstructionYearLabel => 'Construction year';

  @override
  String get buildingFormConstructionYearHint => 'e.g., 1998';

  @override
  String get buildingFormRegulationLabel => 'Current regulation';

  @override
  String get buildingFormRegulationHint => 'e.g., CTE';

  @override
  String get buildingFormTechnicalSection => 'TECHNICAL DATA';

  @override
  String get buildingFormBuildingSummary => 'Building summary';

  @override
  String get buildingFormConstructionYearSummaryLabel => 'Construction year';

  @override
  String get buildingFormRegulationSummaryLabel => 'Regulation';

  @override
  String get buildingFormFloorsLabel => 'Number of floors';

  @override
  String get buildingFormFloorsHint => 'e.g., 6';

  @override
  String get buildingFormSurfaceLabel => 'Total area (m�)';

  @override
  String get buildingFormSurfaceHint => 'e.g., 850';

  @override
  String get buildingFormOrientationLabel => 'Main orientation';

  @override
  String get buildingFormOrientationHint => 'Select an orientation';

  @override
  String get buildingFormDocumentationSection => 'DOCUMENTATION';

  @override
  String get buildingFormBuildingToVerify => 'Building to verify';

  @override
  String get buildingFormSubmittingDocuments => 'Sending documentation...';

  @override
  String get buildingFormSubmit => 'Create building and send verification';

  @override
  String get editHabitatgeNoLinkedHome =>
      'No home linked to your user was found in this building.';

  @override
  String get editHabitatgeNoneSelected => 'No home was selected to edit.';

  @override
  String get editHabitatgeMissingCadastralReference =>
      'The selected home has no cadastral reference.';

  @override
  String get editHabitatgeLoadError => 'Could not load the home.';

  @override
  String get editHabitatgeSelectorTitle => 'Which home do you want to edit?';

  @override
  String editHabitatgeSelectorFloorDoor(String floor, String door) {
    return 'Floor $floor · Door $door';
  }

  @override
  String get editHabitatgeEnergyRequired =>
      'Required if you provide energy data';

  @override
  String get editHabitatgeEnergyDateRequired =>
      'Entry date is required if you provide energy data';

  @override
  String get editHabitatgeSaveWithEnergySuccess =>
      'Home and energy data updated.';

  @override
  String get editHabitatgeSaveSuccess => 'Home data updated.';

  @override
  String get editHabitatgeAppBarTitle => 'Edit home';

  @override
  String get editHabitatgeCannotEditTitle => 'This home cannot be edited';

  @override
  String get editHabitatgeSaveButton => 'Save data';

  @override
  String get editHabitatgeIntroTitle => 'Complete your home details';

  @override
  String get editHabitatgeIntroBody =>
      'This data will help calculate the estimated rating and BuildRank score for the building more accurately.';

  @override
  String get editHabitatgeHomeDataTitle => 'Home data';

  @override
  String get editHabitatgeHomeDataSubtitle =>
      'Basic information about the home linked to your account.';

  @override
  String get editHabitatgeRenovationYear => 'Any reforma';

  @override
  String get editHabitatgeInvalidYear => 'Enter a valid year';

  @override
  String get editHabitatgeYearOutOfRange => 'The year is not valid';

  @override
  String get editHabitatgeEnergyDataTitle => 'Energy data';

  @override
  String get editHabitatgeEnergyDataSubtitle =>
      'Add the available information from the energy certificate or estimate.';

  @override
  String get editHabitatgeEnergyOptionalNotice =>
      'Energy data is optional. If you fill in any field in this section, you must complete all mandatory energy certificate fields.';

  @override
  String get editHabitatgeGlobalRating => 'Overall rating';

  @override
  String get editHabitatgePrimaryEnergyConsumption =>
      'Primary energy consumption';

  @override
  String get editHabitatgeFinalEnergyConsumption => 'Consum energia final';

  @override
  String get editHabitatgeCo2Emissions => 'CO₂ emissions';

  @override
  String get editHabitatgeAnnualEnergyCost => 'Annual energy cost (€)';

  @override
  String get editHabitatgeConsumptionByUse => 'Consumption by use';

  @override
  String get editHabitatgeHeatingEnergy => 'Heating energy';

  @override
  String get editHabitatgeCoolingEnergy => 'Cooling energy';

  @override
  String get editHabitatgeAcsEnergy => 'Energia ACS';

  @override
  String get editHabitatgeLightingEnergy => 'Energia enllumenament';

  @override
  String get editHabitatgeEmissionsByUse => 'Emissions by use';

  @override
  String get editHabitatgeHeatingEmissions => 'Heating emissions';

  @override
  String get editHabitatgeCoolingEmissions => 'Cooling emissions';

  @override
  String get editHabitatgeAcsEmissions => 'Emissions ACS';

  @override
  String get editHabitatgeLightingEmissions => 'Emissions enllumenament';

  @override
  String get editHabitatgeCertificationEnvelope => 'Certification and envelope';

  @override
  String get editHabitatgeThermalInsulation => 'Thermal insulation';

  @override
  String get editHabitatgeWindowValue => 'Valor finestres';

  @override
  String get editHabitatgeCertificationTool => 'Certification tool';

  @override
  String get editHabitatgeCertificationReason => 'Certification reason';

  @override
  String get editHabitatgeEnergyRenovation => 'Energy renovation';

  @override
  String get editHabitatgeSelectEntryDate => 'Select entry date *';

  @override
  String editHabitatgeEntryDate(String date) {
    return 'Entry date: $date';
  }

  @override
  String get adminAuditTitle => 'Audit log';

  @override
  String get adminAuditEmpty => 'No records found.';

  @override
  String get adminAuditUserId => 'User ID';

  @override
  String get adminAuditMethod => 'Method';

  @override
  String get adminAuditResourceType => 'Resource type';

  @override
  String get adminAuditHttpCode => 'HTTP code';

  @override
  String get adminAuditFromDate => 'From';

  @override
  String get adminAuditToDate => 'To';

  @override
  String get adminAuditClear => 'Clear';

  @override
  String get adminAuditApplyFilters => 'Apply filters';

  @override
  String get adminAuditAll => 'All';

  @override
  String adminAuditPageRange(int firstItem, int lastItem, int totalCount) {
    return '$firstItem-$lastItem of $totalCount';
  }

  @override
  String adminAuditPage(int page) {
    return 'Page $page';
  }

  @override
  String get adminAuditPreviousPage => 'Previous page';

  @override
  String get adminAuditNextPage => 'Next page';

  @override
  String get simulationCatalogLoadError =>
      'Could not load the improvement catalog.';

  @override
  String get simulationHistoryLoadError =>
      'Could not load the simulation history.';

  @override
  String get simulationCalculateError => 'Could not calculate the simulation.';

  @override
  String get simulationSaveError => 'Could not save the simulation.';

  @override
  String get simulationSavedSnack => 'Simulation saved successfully.';

  @override
  String get simulationTitle => 'Improvement simulator';

  @override
  String get simulationCurrent => 'Current';

  @override
  String get simulationSimulated => 'Simulated';

  @override
  String get simulationDisclaimer =>
      'Results are indicative estimates. They do not replace a professional energy audit.';

  @override
  String get simulationTabSimulate => 'Simulate';

  @override
  String get simulationTabSaved => 'Saved';

  @override
  String get simulationTabImplemented => 'Applied';

  @override
  String get simulationCatalogTitle => 'Improvement catalog';

  @override
  String simulationSelectedCount(int count) {
    return '$count selected';
  }

  @override
  String get simulationSavedTitle => 'Saved simulations';

  @override
  String get simulationNoSaved =>
      'There are no saved simulations for this building yet. Calculate a preview and tap \"Save simulation\".';

  @override
  String get simulationImplementedTitle => 'Applied improvements';

  @override
  String get simulationNoImplemented =>
      'There are no applied improvements registered yet. Saved simulations are scenarios; applied improvements represent work actually completed or under validation.';

  @override
  String get simulationCalculatingPreview => 'Calculating preview...';

  @override
  String get simulationCalculatePreview => 'Calculate preview';

  @override
  String get simulationSaving => 'Saving simulation...';

  @override
  String get simulationSave => 'Save simulation';

  @override
  String get simulationReadOnlyRole =>
      'This role can view the preview, but formal simulation management is reserved for the property manager.';

  @override
  String get simulationResultTitle => 'Simulation result';

  @override
  String get simulationAnnualConsumption => 'Annual consumption';

  @override
  String get simulationEstimatedAnnualCost => 'Estimated annual cost';

  @override
  String simulationSavings(String amount) {
    return 'Savings $amount';
  }

  @override
  String get simulationScore => 'Score';

  @override
  String simulationPointsDelta(String points) {
    return '+$points points';
  }

  @override
  String simulationTotalCostAndEngine(String cost, String engine) {
    return 'Estimated total cost: $cost · Engine $engine';
  }

  @override
  String simulationDateAndEngine(String date, String engine) {
    return 'Date: $date · Engine $engine';
  }

  @override
  String simulationCost(String cost) {
    return 'Cost $cost';
  }

  @override
  String simulationRealCost(String cost) {
    return 'Real cost $cost';
  }

  @override
  String simulationExecutionDate(String date) {
    return 'Execution: $date';
  }

  @override
  String get simulationEmptyCatalog =>
      'There are no active improvements in the catalog yet. Load the improvement seed in the backend.';

  @override
  String altSimulationPreparedSnack(int count) {
    return 'Simulation ready to submit to a vote with $count improvement(s).';
  }

  @override
  String get altSimulationSelectUpdates => 'Seleccioneu\nactualitzacions';

  @override
  String get altSimulationDetailedImpact => 'Impacte detallat';

  @override
  String get altSimulationPresentVote => 'Submit to vote';

  @override
  String get altSimulationLive => 'LIVE SIMULATION';

  @override
  String get altSimulationExpectedPerformance => 'Expected performance';

  @override
  String get altSimulationImpact => 'IMPACTE';

  @override
  String get altSimulationEstimatedCost => 'COST\nESTIM';

  @override
  String get altSimulationOperationalForecast => 'OPERATING FORECAST';

  @override
  String get altSimulationAnnualEnergyCost => 'Annual energy cost';

  @override
  String get altSimulationCarbonFootprint => 'Petjada de carboni';

  @override
  String get altSimulationEnergyIntensity => 'Energy intensity';

  @override
  String get altSimulationTotalInvestment => 'TOTAL INVESTMENT';

  @override
  String get altSimulationAnnualSavings => 'ESTALVI ANUAL';

  @override
  String get altSimulationPaybackPeriod => 'PAYBACK PERIOD';

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
  String get altSimulationGlazingSubtitle => 'High performance';

  @override
  String get altSimulationInsulationTitle => 'Wall insulation';

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
  String get votesStatusCancelled => 'Cancelled';

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
  String get votesSelectOptionSnack => 'Select an option to vote.';

  @override
  String get votesRegisteredSnack => 'Vot registrat correctament.';

  @override
  String get votesDeleteTitle => 'Delete vote';

  @override
  String get votesDeleteBody =>
      'Are you sure you want to delete this vote? All options and submitted votes will be deleted. This action cannot be undone.';

  @override
  String get votesCancel => 'Cancel';

  @override
  String get votesDelete => 'Eliminar';

  @override
  String get votesFallbackTitle => 'Vote';

  @override
  String get votesEdit => 'Editar';

  @override
  String votesUntilDate(String date) {
    return 'Fins al $date';
  }

  @override
  String get votesSelectOption => 'Select an option';

  @override
  String get votesOptions => 'Options';

  @override
  String get votesPermissionOnlyOwners =>
      'Only owners and property managers linked to this building can vote.';

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
  String get votesEditTitle => 'Edit vote';

  @override
  String get votesSave => 'Desar';

  @override
  String get votesSaveChanges => 'Desar canvis';

  @override
  String get votesMinimumOptionsSnack => 'At least 2 options are required.';

  @override
  String get votesDuplicateOptionsSnack =>
      'Hi ha opcions duplicades. Revisa\'ls.';

  @override
  String get votesTitleRequired => 'The title is required.';

  @override
  String get votesTitleMinLength =>
      'The title must be at least 4 characters long.';

  @override
  String get votesDescriptionOptional => 'Description (optional)';

  @override
  String get votesDeadline => 'Deadline';

  @override
  String get votesOptionsRange => 'Minimum 2 · Maximum 8';

  @override
  String get votesOptionsWarning =>
      'Warning: changing the options may affect existing votes.';

  @override
  String get votesState => 'Estat';

  @override
  String get votesCancelledLocked => 'A cancelled vote cannot be reopened.';

  @override
  String get votesOptionRequired => 'This option cannot be empty.';

  @override
  String get votesListTitle => 'Internal vote';

  @override
  String votesListSubtitle(String buildingName) {
    return 'Decision-making for $buildingName';
  }

  @override
  String get votesGeneralSection => 'GENERAL VOTES';

  @override
  String get votesSimulationSection => 'SIMULATION VOTES';

  @override
  String votesTabActive(int count) {
    return 'Active ($count)';
  }

  @override
  String votesTabCompleted(int count) {
    return 'Completed ($count)';
  }

  @override
  String get votesTabMyProposals => 'My proposals';

  @override
  String get votesTabMyVotes => 'My votes';

  @override
  String get votesEmptyActive => 'There are no active votes right now.';

  @override
  String get votesEmptySection => 'There are no votes in this section.';

  @override
  String get votesEmptyBody =>
      'When the administrator submits a simulation to a vote, it will appear here.';

  @override
  String get votesInfoCanVote =>
      'You can participate in community votes linked to this building.';

  @override
  String get votesInfoCannotVote =>
      'Only owners and property managers linked to the building can vote.';

  @override
  String get votesRegisteredFavor => 'Vote in favor registered.';

  @override
  String get votesRegisteredAgainst => 'Vote against registered.';

  @override
  String get votesActive => 'Active';

  @override
  String get votesEndsToday => 'Ends today';

  @override
  String votesDaysRemaining(int days) {
    return '$days days remaining';
  }

  @override
  String get votesEnergyProposalFallback => 'Energy improvement proposal.';

  @override
  String get votesQuorumProgress => 'Quorum progress';

  @override
  String get votesQuorumReached => 'Quorum reached';

  @override
  String get votesNeedMoreParticipation => 'More participation needed';

  @override
  String get votesVoteSection => 'VOTE';

  @override
  String get votesFavor => 'In favor';

  @override
  String get votesAgainst => 'Against';

  @override
  String votesEstimatedCostSaving(String cost, String saving) {
    return 'Estimated cost $cost € +$saving €/year';
  }

  @override
  String get votesKeepCurrentState => 'Keep current state';

  @override
  String votesYourVote(String vote) {
    return 'Your vote: $vote';
  }

  @override
  String get votesPendingVote => 'Pending vote';

  @override
  String get votesNotReported => 'not reported';

  @override
  String adminUsersSuspendTitle(String email) {
    return 'Suspend $email';
  }

  @override
  String get adminUsersReasonLabel => 'Reason (optional)';

  @override
  String get adminUsersReasonHint =>
      'Describe the reason for the suspension...';

  @override
  String get adminUsersEndDate => 'End date';

  @override
  String get adminUsersRemoveDate => 'Remove date';

  @override
  String get adminUsersConfirm => 'Confirm';

  @override
  String get adminUsersTitle => 'User management';

  @override
  String adminUsersCount(int count) {
    return '$count users';
  }

  @override
  String get adminUsersEmpty => 'There are no users.';

  @override
  String adminUsersReason(String reason) {
    return 'Reason: $reason';
  }

  @override
  String get adminUsersSuspend => 'Suspend';

  @override
  String get adminHomeVerificationPending => 'Pending verifications';

  @override
  String get adminHomeSearchHint => 'Search buildings or users...';

  @override
  String get adminHomeVerificationQueue => 'Document verification queue';

  @override
  String adminHomePendingCount(int count) {
    return '$count pending';
  }

  @override
  String get adminHomeNoPendingVerifications => 'No pending verifications';

  @override
  String get adminHomeNoPendingVerificationsBody =>
      'When a verification finishes AI processing, it will appear here.';

  @override
  String get adminHomeCreateSeason => 'Create new season';

  @override
  String get adminHomeChatsBody =>
      'Access building chats and apply moderation actions.';

  @override
  String get adminHomeOpenBuildingChats => 'Open building chats';

  @override
  String get adminHomeUsersTitle => 'User management';

  @override
  String get adminHomeUsersBody => 'Block, suspend, and manage user accounts.';

  @override
  String get adminHomeOpenUsers => 'Open user management';

  @override
  String get adminHomeAnomalyBody =>
      '5 buildings in the \"Commercial\" category submitted data more than 20% above historical benchmarks. A manual audit is required.';

  @override
  String get adminHomeUnexpectedVerificationError =>
      'An unexpected error occurred while reviewing the verification.';

  @override
  String get adminHomeRejectionReason => 'Rejection reason';

  @override
  String get adminHomeRejectionHint =>
      'Briefly explain why it is being rejected...';

  @override
  String get adminHomeCancel => 'Cancel';

  @override
  String get adminHomeReject => 'Reject';

  @override
  String get adminHomeFiltersPending => 'Advanced filters pending integration.';

  @override
  String get adminHomeCreateSeasonPending =>
      'Season creation pending integration.';

  @override
  String get adminHomeRolesPending => 'Permissions matrix pending integration.';

  @override
  String get adminHomeApprove => 'Approve';

  @override
  String get adminHomeRejected => 'Rejected';

  @override
  String get adminHomeApproved => 'Approved';

  @override
  String adminHomeSeasonStats(String range, int participants) {
    return '$range · $participants buildings';
  }

  @override
  String adminHomeRoleStats(int users, int permissions) {
    return '$users users · $permissions permissions';
  }

  @override
  String adminUsersUntilDate(String date) {
    return 'Until: $date';
  }

  @override
  String get adminUsersBlock => 'Block';

  @override
  String get adminUsersUnblock => 'Unblock';

  @override
  String get adminUsersUnsuspend => 'Lift suspension';

  @override
  String get adminHomePanelTitle => 'Administration panel';

  @override
  String get adminHomeSeasonManagement => 'Season management';

  @override
  String adminUsersBlockedSnack(String email) {
    return '$email has been blocked.';
  }

  @override
  String adminUsersUnblockedSnack(String email) {
    return '$email has been unblocked.';
  }

  @override
  String adminUsersSuspendedSnack(String email) {
    return '$email has been suspended.';
  }

  @override
  String adminUsersUnsuspendedSnack(String email) {
    return 'The suspension for $email has been lifted.';
  }

  @override
  String get adminUsersIndefiniteSuspension => 'Indefinite suspension';

  @override
  String adminHomeSeasonLabel(int seasonNumber) {
    return 'Season $seasonNumber';
  }

  @override
  String get adminHomeActiveUsers => 'Active users';

  @override
  String get adminHomeValidatedImprovements => 'Validated improvements';

  @override
  String get adminHomeIntegrityAlerts => 'Integrity alerts';

  @override
  String get adminHomeNewTrend => 'New';

  @override
  String get adminHomeTasksTab => 'Tasks';

  @override
  String get adminHomeSeasonsTab => 'Seasons';

  @override
  String get adminHomeRolesTab => 'Roles';

  @override
  String get adminHomeVerificationLoadError => 'Could not load verifications';

  @override
  String get adminHomeRefreshVerifications => 'Refresh verifications';

  @override
  String adminHomeRecordsCount(int count) {
    return '$count records';
  }

  @override
  String adminHomeClosedSeasonsCount(int count) {
    return '$count closed';
  }

  @override
  String get adminHomeSeasonsLoading => 'Loading';

  @override
  String get adminHomeCreateAndStartSeason => 'Create and start season';

  @override
  String get adminHomeCreatingAndStartingSeason =>
      'Creating and starting season...';

  @override
  String get adminHomeRefreshSeasonHistory => 'Refresh history';

  @override
  String get adminHomeRetryLoadSeasons => 'Retry loading seasons';

  @override
  String get adminHomeSeasonLoadErrorTitle => 'Could not load seasons';

  @override
  String get adminHomeSeasonUnexpectedLoadError =>
      'An unexpected error occurred while loading seasons.';

  @override
  String get adminHomeNoClosedSeasonsTitle => 'No closed seasons';

  @override
  String get adminHomeNoClosedSeasonsBody =>
      'When a season is closed, it will appear in this history.';

  @override
  String get adminHomeSeasonActivationTitle => 'Create and start season';

  @override
  String get adminHomeSeasonActivationBody =>
      'The backend will automatically close the current active season, if any, create the new season, and update ranking scores and snapshots.';

  @override
  String get adminHomeSeasonNameLabel => 'Season name';

  @override
  String get adminHomeSeasonStartDateLabel => 'Start date';

  @override
  String get adminHomeSeasonEndDateLabel => 'End date';

  @override
  String get adminHomeSeasonSelectStartDate => 'Select start date';

  @override
  String get adminHomeSeasonSelectEndDate => 'Select end date';

  @override
  String get adminHomeSeasonNameRequired => 'Season name is required';

  @override
  String get adminHomeSeasonStartDateRequired => 'Start date is required';

  @override
  String get adminHomeSeasonEndDateRequired => 'End date is required';

  @override
  String get adminHomeSeasonEndBeforeStart =>
      'End date cannot be before start date';

  @override
  String get adminHomeSeasonActivationConfirm => 'Create and start';

  @override
  String get adminHomeSeasonActivationDefaultSummary =>
      'Season created and started successfully.';

  @override
  String adminHomeSeasonActivationSuccess(String summary) {
    return 'Season started: $summary';
  }

  @override
  String get adminHomeSeasonActivationUnexpectedError =>
      'An unexpected error occurred while creating the season.';

  @override
  String get adminHomeSeasonStatusActive => 'ACTIVE';

  @override
  String get adminHomeSeasonStatusClosed => 'CLOSED';

  @override
  String get adminHomeSeasonDatesUnavailable => 'Dates unavailable';

  @override
  String adminHomeSeasonStartedOn(String date) {
    return 'From $date';
  }

  @override
  String adminHomeSeasonEndedOn(String date) {
    return 'Until $date';
  }

  @override
  String get adminHomeRolesAndPermissions => 'Roles and permissions';

  @override
  String adminHomeRolesCount(int count) {
    return '$count roles';
  }

  @override
  String get adminHomeReviewPermissionsMatrix => 'Review permissions matrix';

  @override
  String get adminVerificationDocumentsTitle => 'Administrator documentation';

  @override
  String get adminVerificationDocumentsBody =>
      'Attach documentation proving that you can act as property manager for this building. The verification will remain pending review.';

  @override
  String get adminVerificationAttachDocuments => 'Attach documents';

  @override
  String get adminVerificationJpgOnly => 'Attach documents in JPG format.';

  @override
  String get adminVerificationRemoveDocument => 'Delete document';

  @override
  String get adminVerificationDocumentType => 'Document type';

  @override
  String get weatherLoadError => 'Could not load weather data.';

  @override
  String get weatherLoadingBarcelona => 'Loading weather data for Barcelona...';

  @override
  String weatherCurrentInCity(String city) {
    return 'Current weather in $city';
  }

  @override
  String get weatherUpdatedByXema =>
      'Weather data updated by the XEMA service.';

  @override
  String leagueInfoBody(String currentLeague, String nextLeague) {
    return 'This building is currently in the $currentLeague. Improve its energy rating to move into the $nextLeague.';
  }

  @override
  String get rankingComingSoonButton => 'Coming soon: view ranking';

  @override
  String get weatherPrecipitationUnavailable => 'Precipitation unavailable';

  @override
  String weatherSolarIrradiance(String value) {
    return 'Solar irradiance: $value W/m²';
  }

  @override
  String weatherCurrentTemperature(String value) {
    return 'Current temperature: $value°C';
  }

  @override
  String get weatherTemperatureUnavailable => 'Temperature unavailable';

  @override
  String weatherPrecipitation(String value) {
    return 'Precipitation: $value mm';
  }

  @override
  String get weatherSolarIrradianceUnavailable =>
      'Solar irradiance unavailable';
}
