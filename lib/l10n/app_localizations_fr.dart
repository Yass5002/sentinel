// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'SENTINEL';

  @override
  String get alertsSent => 'ALERTES ENVOYÉES';

  @override
  String get cancelled => 'Annulé';

  @override
  String get pending => 'EN ATTENTE';

  @override
  String get recipients => 'DESTINATAIRES';

  @override
  String get noContacts => 'AUCUN CONTACT';

  @override
  String get details => 'DÉTAILS';

  @override
  String get cancelEvent => 'ANNULER L\'ÉVÉNEMENT';

  @override
  String get cancelEventTitle => 'ANNULER L\'ÉVÉNEMENT ?';

  @override
  String get cancelEventBody =>
      'Cela annulera l\'événement et aucune alerte ne sera envoyée.';

  @override
  String get keepButton => 'CONSERVER';

  @override
  String get iAmSafe => 'JE SUIS EN SÉCURITÉ';

  @override
  String get returnToHome => 'RETOUR À L\'ACCUEIL';

  @override
  String get tracking => 'Suivi';

  @override
  String get locationOff => 'Localisation désactivée';

  @override
  String get locationLimited => 'Limité';

  @override
  String get locationTrackingOffBanner =>
      'Le suivi de localisation est désactivé. Activez-le dans les paramètres.';

  @override
  String get locationDeniedBanner =>
      'La localisation est désactivée. Vos contacts ne recevront pas votre position.';

  @override
  String get locationLimitedBanner =>
      'La localisation en arrière-plan est limitée. Vos contacts pourraient ne pas recevoir votre dernière position.';

  @override
  String get openSettings => 'Ouvrir les paramètres';

  @override
  String get noMessage => 'Aucun message fourni.';

  @override
  String filesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count fichiers',
      one: '1 fichier',
    );
    return '$_temp0';
  }

  @override
  String get settings => 'PARAMÈTRES';

  @override
  String get appLanguage => 'Langue de l\'application';

  @override
  String get notifications => 'NOTIFICATIONS';

  @override
  String get checkInReminders => 'Rappels d\'enregistrement';

  @override
  String get checkInRemindersSub =>
      'Soyez alerté 1h, 15m et 5m avant l\'expiration de vos SENTINELles.';

  @override
  String get location => 'LOCALISATION';

  @override
  String get locationTracking => 'Suivi de localisation';

  @override
  String get locationTrackingSub =>
      'Partagez votre position avec vos contacts d\'urgence pendant les événements actifs.';

  @override
  String get locationBlocked =>
      'L\'accès à la localisation est bloqué par les paramètres de votre appareil';

  @override
  String get account => 'COMPTE';

  @override
  String get logOut => 'Se déconnecter';

  @override
  String get logOutConfirmBody => 'Êtes-vous sûr de vouloir vous déconnecter ?';

  @override
  String get dangerZone => 'ZONE DE DANGER';

  @override
  String get deleteAccount => 'Supprimer le compte';

  @override
  String get deleteAccountConfirmBody =>
      'Êtes-vous sûr de vouloir supprimer votre compte ? Cette action est irréversible et toutes vos données seront définitivement supprimées.';

  @override
  String get deleting => 'Suppression...';

  @override
  String get about => 'À PROPOS';

  @override
  String get privacyPolicy => 'Politique de confidentialité';

  @override
  String get termsOfService => 'Conditions d\'utilisation';

  @override
  String get neverMissCheckIn => 'Ne manquez jamais un enregistrement';

  @override
  String get notificationPrimer =>
      'SENTINEL a besoin des autorisations de notification pour vous alerter avant l\'expiration de vos SENTINELles. Sans cela, vous ne recevrez pas les alertes cruciales de 1h, 15m et 5m.';

  @override
  String get notNow => 'Pas maintenant';

  @override
  String get enableNotifications => 'Activer les notifications';

  @override
  String get shareLocationTitle => 'Partagez votre position avec vos contacts';

  @override
  String get shareLocationBody =>
      'Si vous ne vous enregistrez pas, SENTINEL envoie votre dernière position connue à vos contacts d\'urgence afin qu\'ils puissent vous trouver. La position n\'est suivie que pendant un événement actif.';

  @override
  String get enableLocation => 'Activer la localisation';

  @override
  String get allowBackgroundLocation =>
      'Autoriser la localisation en arrière-plan';

  @override
  String get backgroundLocationBody =>
      'Pour votre sécurité, autorisez l\'accès à la localisation \"Toujours\" sur l\'écran suivant. Cela garantit que le suivi se poursuit même lorsque votre téléphone est verrouillé.';

  @override
  String get skip => 'Ignorer';

  @override
  String get continueText => 'Continuer';

  @override
  String get noEventCreated => 'AUCUN ÉVÉNEMENT CRÉÉ';

  @override
  String get loadMore => 'CHARGER PLUS';

  @override
  String get cancel => 'Annuler';

  @override
  String get loginTitle => 'Entrez votre email pour commencer';

  @override
  String get emailHint => 'Email';

  @override
  String get emailRequired => 'L\'email est requis';

  @override
  String get emailInvalid => 'Veuillez entrer un email valide';

  @override
  String get getStarted => 'COMMENCER';

  @override
  String get checkEmail => 'Vérifiez votre email';

  @override
  String codeSentTo(String email) {
    return 'Nous avons envoyé un code à 6 chiffres à $email';
  }

  @override
  String get verify => 'VÉRIFIER';

  @override
  String get resendCode => 'Renvoyer le code';

  @override
  String resendCodeIn(int seconds) {
    return 'Renvoyer le code dans ${seconds}s';
  }

  @override
  String get codeSent => 'Code envoyé';

  @override
  String get profile => 'PROFIL';

  @override
  String get memberSince => 'MEMBRE DEPUIS';

  @override
  String get editNameTitle => 'Modifier le nom';

  @override
  String get nameHint => 'Nom';

  @override
  String get save => 'Enregistrer';

  @override
  String get helpTitle => 'Aide';

  @override
  String get helpQ1 => 'Qu\'est-ce que SENTINEL ?';

  @override
  String get helpA1 =>
      'SENTINEL est votre compagnon de sécurité personnelle. Il vous permet de régler un minuteur et si vous ne vous enregistrez pas avant son expiration, il alerte automatiquement vos contacts d\'urgence avec votre dernière position connue et un message personnalisé.';

  @override
  String get helpQ2 => 'Comment créer un nouveau SENTINEL ?';

  @override
  String get helpA2 =>
      'Appuyez sur le bouton \'+\' sur l\'écran d\'accueil. Réglez une durée (ex. 30 minutes), ajoutez des notes ou des fichiers, et sélectionnez vos contacts d\'urgence. Appuyez sur \'Initier SENTINEL\' pour commencer.';

  @override
  String get helpQ3 => 'Que se passe-t-il lorsque le minuteur expire ?';

  @override
  String get helpA3 =>
      'Lorsque le minuteur atteint zéro, SENTINEL avertit immédiatement tous vos contacts d\'urgence sélectionnés par SMS/Email. Ils recevront votre message personnalisé et un lien pour voir votre dernière position connue sur une carte.';

  @override
  String get helpQ4 => 'Qu\'est-ce qu\'un \'Enregistrement\' ?';

  @override
  String get helpA4 =>
      'L\'enregistrement annule le compte à rebours actif. Utilisez-le une fois que vous êtes en sécurité ou que vous n\'avez plus besoin du SENTINEL. Si vous vous enregistrez, aucune alerte ne sera envoyée.';

  @override
  String get helpQ5 => 'Puis-je prolonger un minuteur actif ?';

  @override
  String get helpA5 =>
      'Oui ! Appuyez sur votre SENTINEL actif et utilisez le bouton \'Prolonger\' pour ajouter plus de temps si votre situation change.';

  @override
  String get helpQ6 => 'Qui sont les contacts d\'urgence ?';

  @override
  String get helpA6 =>
      'Les contacts d\'urgence sont des personnes en qui vous avez confiance. Vous devez sélectionner au moins un contact pour chaque SENTINEL. Vous pouvez gérer vos contacts dans l\'écran \'Contacts\' accessible depuis le tiroir.';

  @override
  String get helpQ7 => 'SENTINEL suit-il ma position ?';

  @override
  String get helpA7 =>
      'SENTINEL suit UNIQUEMENT votre position lorsqu\'un minuteur est actif. Nous attachons de l\'importance à votre vie privée et ne surveillons pas vos déplacements lorsque l\'application est inactive ou qu\'aucun SENTINEL n\'est en cours.';

  @override
  String get helpQ8 => 'Et si je n\'ai pas Internet ?';

  @override
  String get helpA8 =>
      'SENTINEL nécessite une connexion Internet pour initier un événement et télécharger des données. Si vous perdez la connexion pendant un événement actif, le compte à rebours sur nos serveurs déclenchera toujours l\'alerte à moins que vous ne vous enregistriez.';

  @override
  String get helpQ9 => 'Combien de contacts puis-je ajouter ?';

  @override
  String get helpA9 =>
      'Vous pouvez ajouter jusqu\'à 10 contacts d\'urgence par événement SENTINEL.';

  @override
  String get helpQ10 => 'Mes données sont-elles sécurisées ?';

  @override
  String get helpA10 =>
      'Oui, vos données personnelles et votre position sont cryptées. Seuls les contacts d\'urgence que vous spécifiez peuvent voir votre position, et seulement après le déclenchement d\'une alerte.';

  @override
  String get helpQ11 => 'Puis-je ajouter des photos ou des enregistrements ?';

  @override
  String get helpA11 =>
      'Oui ! Lors de la création d\'un SENTINEL, vous pouvez joindre des fichiers. Ceux-ci seront partagés avec vos contacts si l\'alerte est déclenchée, fournissant plus de contexte sur votre situation.';

  @override
  String get helpQ12 => 'Qu\'est-ce que le bouton \'JE SUIS EN SÉCURITÉ\' ?';

  @override
  String get helpA12 =>
      'C\'est votre bouton d\'enregistrement. Appuyer dessus indique à SENTINEL que vous allez bien, ce qui arrête immédiatement le compte à rebours et empêche l\'envoi de toute alerte.';

  @override
  String get helpQ13 => 'L\'application doit-elle être ouverte ?';

  @override
  String get helpA13 =>
      'Non. SENTINEL exécute son compte à rebours critique sur nos serveurs sécurisés. Même si votre téléphone s\'éteint, n\'a plus de batterie ou est détruit, l\'alerte sera toujours envoyée à l\'expiration du minuteur.';

  @override
  String get helpQ14 => 'Comment gérer mon profil ?';

  @override
  String get helpA14 =>
      'Vous pouvez mettre à jour votre nom et voir les détails de votre compte dans la section \'Profil\', accessible depuis le tiroir de l\'application.';

  @override
  String get helpQ15 => 'Et si je déclenche une alerte par erreur ?';

  @override
  String get helpA15 =>
      'Si une alerte est envoyée, vos contacts seront informés. Nous vous recommandons de les contacter immédiatement pour leur faire savoir qu\'il s\'agissait d\'une fausse alerte. Essayez toujours de vous enregistrer AVANT que le minuteur n\'atteigne zéro.';

  @override
  String get contactSupport => 'Contacter le support';

  @override
  String get contactSupportText =>
      'Si vous avez des problèmes ou des suggestions, veuillez nous contacter à :';

  @override
  String get loading => 'Chargement...';

  @override
  String get home => 'Accueil';

  @override
  String get contacts => 'Contacts';

  @override
  String get checkedIn => 'Enregistré';

  @override
  String get created => 'Créé';

  @override
  String get deleteEvent => 'Supprimer l\'événement';

  @override
  String get deleteEventHistoryConfirm =>
      'Êtes-vous sûr de vouloir supprimer tout l\'historique des événements ?';

  @override
  String get delete => 'Supprimer';

  @override
  String get failedToLoadEvents => 'Échec du chargement des événements';

  @override
  String get failedToLoadEventDetails =>
      'Échec du chargement des détails de l\'événement';

  @override
  String get messageTitle => 'Message';

  @override
  String get attachments => 'Pièces jointes';

  @override
  String get newSentinel => 'Nouveau SENTINEL';

  @override
  String get eventName => 'Nom de l\'événement';

  @override
  String get timer => 'Minuteur';

  @override
  String get enterMessage =>
      'Entrez le message à envoyer si le minuteur expire...';

  @override
  String get addFile => 'Ajouter un fichier';

  @override
  String get uploading => 'Téléchargement...';

  @override
  String get initiateSentinel => 'Initier SENTINEL';

  @override
  String get addContact => 'Ajouter un contact';

  @override
  String get selectContacts => 'Sélectionner des contacts';

  @override
  String get savedContacts => 'Contacts enregistrés';

  @override
  String contactsSelected(int count) {
    return 'Contacts sélectionnés : $count';
  }

  @override
  String get searchContacts => 'Rechercher des contacts...';

  @override
  String get orEnterManually => 'OU SAISIR MANUELLEMENT';

  @override
  String get enterContactManually => 'SAISIR LE CONTACT MANUELLEMENT';

  @override
  String get emailExample => 'email@exemple.com';

  @override
  String get contactNameOptional => 'Nom du contact (optionnel)';

  @override
  String get selectAtLeastOneContact =>
      'Veuillez sélectionner au moins un contact';

  @override
  String get maxContactsAllowed => 'Maximum 10 contacts autorisés';

  @override
  String get duration => 'Durée';

  @override
  String get date => 'Date';

  @override
  String get noRecipients => 'Pas de destinataires';

  @override
  String get safe => 'Sain et sauf';

  @override
  String get active => 'Actif';

  @override
  String failedToOpenFile(String message) {
    return 'Échec de l\'ouverture du fichier : $message';
  }

  @override
  String get failedToDownloadFile => 'Échec du téléchargement du fichier';

  @override
  String get failedToDeleteAccount => 'Échec de la suppression du compte';

  @override
  String get language => 'Langue';

  @override
  String get noEventCreatedYet => 'AUCUN ÉVÉNEMENT CRÉÉ';

  @override
  String get somethingWentWrong => 'Quelque chose s\'est mal passé !';

  @override
  String get retry => 'Réessayer';

  @override
  String get english => 'Anglais';

  @override
  String get french => 'Français';

  @override
  String get spanish => 'Espagnol';

  @override
  String get arabic => 'Arabe';

  @override
  String get chinese => 'Chinois';

  @override
  String get unknown => 'Inconnu';

  @override
  String get none => 'AUCUN';

  @override
  String get days => 'j';

  @override
  String get notifTitle => 'SENTINEL';

  @override
  String get notifAlertTitle => 'Alerte SENTINEL';

  @override
  String notifHourBody(Object eventName) {
    return 'Votre SENTINEL \'$eventName\' expire dans 1 heure';
  }

  @override
  String notifFifteenMinBody(Object eventName) {
    return 'Votre SENTINEL \'$eventName\' expire dans 15 minutes';
  }

  @override
  String notifFiveMinBody(Object eventName) {
    return 'Votre SENTINEL \'$eventName\' expire dans 5 minutes. Enregistrez-vous maintenant.';
  }

  @override
  String notifFiredBody(Object eventName) {
    return 'Le SENTINEL \'$eventName\' a été déclenché. Vos contacts d’urgence ont été prévenus.';
  }

  @override
  String get notifCountdownBody =>
      'Les alertes d\'urgence se déclencheront lorsque le minuteur atteindra zéro. Appuyez pour vous enregistrer.';

  @override
  String get notifTrackingTitle => 'Suivi de localisation';

  @override
  String get notifTrackingBody => 'SENTINEL suit votre position';

  @override
  String get notifTrackingDesc => 'Indique quand SENTINEL suit votre position';

  @override
  String get notifCountdownChannelName => 'Compte à rebours SENTINEL';

  @override
  String get notifCountdownChannelDesc =>
      'Affiche le minuteur de compte à rebours actif';

  @override
  String get sentinelBrand => 'SENTINEL';

  @override
  String get contactNameHint => 'Nom du contact';

  @override
  String get noSavedContacts => 'Aucun contact enregistré';

  @override
  String get deleteContactTitle => 'Supprimer le contact';

  @override
  String get deleteContactConfirm =>
      'sera supprimé de vos contacts enregistrés.';

  @override
  String get failedToLoadContacts => 'Échec du chargement des contacts';
}
