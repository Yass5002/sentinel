// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'SENTINEL';

  @override
  String get alertsSent => 'Alert Sent';

  @override
  String get cancelled => 'Canceled';

  @override
  String get pending => 'PENDING';

  @override
  String get recipients => 'RECIPIENTS';

  @override
  String get noContacts => 'NO CONTACTS';

  @override
  String get details => 'DETAILS';

  @override
  String get cancelEvent => 'CANCEL EVENT';

  @override
  String get cancelEventTitle => 'CANCEL EVENT?';

  @override
  String get cancelEventBody =>
      'This will cancel the event and no alerts will be sent.';

  @override
  String get keepButton => 'KEEP';

  @override
  String get iAmSafe => 'I AM SAFE';

  @override
  String get returnToHome => 'RETURN TO HOME';

  @override
  String get tracking => 'Tracking';

  @override
  String get locationOff => 'Location off';

  @override
  String get locationLimited => 'Limited';

  @override
  String get locationTrackingOffBanner =>
      'Location tracking is off. Enable it in Settings.';

  @override
  String get locationDeniedBanner =>
      'Location is off. Your contacts will not receive your location.';

  @override
  String get locationLimitedBanner =>
      'Background location is limited. Your contacts may not receive your latest location.';

  @override
  String get openSettings => 'Open settings';

  @override
  String get noMessage => 'No message provided.';

  @override
  String filesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Files',
      one: '1 File',
    );
    return '$_temp0';
  }

  @override
  String get settings => 'SETTINGS';

  @override
  String get appLanguage => 'App Language';

  @override
  String get notifications => 'NOTIFICATIONS';

  @override
  String get checkInReminders => 'Check-in reminders';

  @override
  String get checkInRemindersSub =>
      'Get alerted 1h, 15m, and 5m before your SENTINELs expire.';

  @override
  String get location => 'LOCATION';

  @override
  String get locationTracking => 'Location tracking';

  @override
  String get locationTrackingSub =>
      'Share your location with emergency contacts while events are active.';

  @override
  String get locationBlocked =>
      'Location access is blocked by your device settings';

  @override
  String get account => 'ACCOUNT';

  @override
  String get logOut => 'Log out';

  @override
  String get logOutConfirmBody => 'Are you sure you want to log out?';

  @override
  String get dangerZone => 'DANGER ZONE';

  @override
  String get deleteAccount => 'Delete Account';

  @override
  String get deleteAccountConfirmBody =>
      'Are you sure you want to delete your account? This action cannot be undone and all your data will be permanently removed.';

  @override
  String get deleting => 'Deleting...';

  @override
  String get about => 'ABOUT';

  @override
  String get privacyPolicy => 'Privacy policy';

  @override
  String get termsOfService => 'Terms of service';

  @override
  String get neverMissCheckIn => 'Never Miss a Check-in';

  @override
  String get notificationPrimer =>
      'SENTINEL needs notification permissions to alert you before your SENTINELs expire. Without this, you won\'t receive the crucial 1hr, 15m, and 5m countdown alerts.';

  @override
  String get notNow => 'Not Now';

  @override
  String get enableNotifications => 'Enable Notifications';

  @override
  String get shareLocationTitle => 'Share your location with contacts';

  @override
  String get shareLocationBody =>
      'If you don\'t check in, SENTINEL sends your last known location to your emergency contacts so they can find you. Location is only tracked while you have an active event.';

  @override
  String get enableLocation => 'Enable location';

  @override
  String get allowBackgroundLocation => 'Allow background location';

  @override
  String get backgroundLocationBody =>
      'For your safety, allow location access \"All the time\" on the next screen. This ensures tracking continues even when your phone is locked.';

  @override
  String get skip => 'Skip';

  @override
  String get continueText => 'Continue';

  @override
  String get noEventCreated => 'NO EVENT CREATED YET';

  @override
  String get loadMore => 'LOAD MORE';

  @override
  String get cancel => 'Cancel';

  @override
  String get loginTitle => 'Enter your email to get started';

  @override
  String get emailHint => 'Email';

  @override
  String get emailRequired => 'Email is required';

  @override
  String get emailInvalid => 'Please enter a valid email';

  @override
  String get getStarted => 'GET STARTED';

  @override
  String get checkEmail => 'Check your email';

  @override
  String codeSentTo(String email) {
    return 'We sent a 6-digit code to $email';
  }

  @override
  String get verify => 'VERIFY';

  @override
  String get resendCode => 'Resend code';

  @override
  String resendCodeIn(int seconds) {
    return 'Resend code in ${seconds}s';
  }

  @override
  String get codeSent => 'Code sent';

  @override
  String get profile => 'PROFILE';

  @override
  String get memberSince => 'MEMBER SINCE';

  @override
  String get editNameTitle => 'Edit name';

  @override
  String get nameHint => 'Name';

  @override
  String get save => 'Save';

  @override
  String get helpTitle => 'Help';

  @override
  String get helpQ1 => 'What is SENTINEL?';

  @override
  String get helpA1 =>
      'SENTINEL is your personal safety companion. It allows you to set a timer and if you don\'t check in before it expires, it automatically alerts your emergency contacts with your last known location and a custom message.';

  @override
  String get helpQ2 => 'How do I create a new SENTINEL?';

  @override
  String get helpA2 =>
      'Tap the \'+\' button on the home screen. Set a duration (e.g., 30 minutes), add any notes or files, and select your emergency contacts. Tap \'Initiate SENTINEL\' to start.';

  @override
  String get helpQ3 => 'What happens when the timer expires?';

  @override
  String get helpA3 =>
      'When the timer reaches zero, SENTINEL immediately notifies all your selected emergency contacts via SMS/Email. They will receive your custom message and a link to view your last known location on a map.';

  @override
  String get helpQ4 => 'What is a \'Check-In\'?';

  @override
  String get helpA4 =>
      'Checking in cancels the active countdown. Use this once you are safe or no longer need the SENTINEL. If you check in, no alerts will be sent.';

  @override
  String get helpQ5 => 'Can I extend an active timer?';

  @override
  String get helpA5 =>
      'Yes! Tap on your active SENTINEL and use the \'Extend\' button to add more time if your situation changes.';

  @override
  String get helpQ6 => 'Who are emergency contacts?';

  @override
  String get helpA6 =>
      'Emergency contacts are people you trust. You must select at least one contact for every SENTINEL. You can manage your contacts in the \'Contacts\' screen accessible from the drawer.';

  @override
  String get helpQ7 => 'Does SENTINEL track my location?';

  @override
  String get helpA7 =>
      'SENTINEL ONLY tracks your location while a timer is active. We value your privacy and do not monitor your movements when the app is idle or no SENTINELs are running.';

  @override
  String get helpQ8 => 'What if I have no internet?';

  @override
  String get helpA8 =>
      'SENTINEL requires an internet connection to initiate an event and upload data. If you lose connection during an active event, the countdown on our servers will still trigger the alert unless you check in.';

  @override
  String get helpQ9 => 'How many contacts can I add?';

  @override
  String get helpA9 =>
      'You can add up to 10 emergency contacts per SENTINEL event.';

  @override
  String get helpQ10 => 'Is my data secure?';

  @override
  String get helpA10 =>
      'Yes, your personal data and location are encrypted. Only the emergency contacts you specify can see your location, and only after an alert is triggered.';

  @override
  String get helpQ11 => 'Can I add photos or recordings?';

  @override
  String get helpA11 =>
      'Yes! When creating a SENTINEL, you can attach files. These will be shared with your contacts if the alert is triggered, providing more context about your situation.';

  @override
  String get helpQ12 => 'What is the \'I AM SAFE\' button?';

  @override
  String get helpA12 =>
      'This is your check-in button. Tapping it tells SENTINEL that you are okay, which immediately stops the countdown and prevents any alerts from being sent.';

  @override
  String get helpQ13 => 'Does the app need to be open?';

  @override
  String get helpA13 =>
      'No. SENTINEL runs its critical countdown on our secure servers. Even if your phone dies, loses battery, or is destroyed, the alert will still be sent when the timer expires.';

  @override
  String get helpQ14 => 'How do I manage my profile?';

  @override
  String get helpA14 =>
      'You can update your name and see your account details in the \'Profile\' section, accessible from the app drawer.';

  @override
  String get helpQ15 => 'What if I trigger an alert by mistake?';

  @override
  String get helpA15 =>
      'If an alert is sent, your contacts will be notified. We recommend contacting them immediately to let them know it was a false alarm. Always try to check in BEFORE the timer reaches zero.';

  @override
  String get contactSupport => 'Contact Support';

  @override
  String get contactSupportText =>
      'If you have any issues or suggestions, please contact us at:';

  @override
  String get loading => 'Loading...';

  @override
  String get home => 'Home';

  @override
  String get contacts => 'Contacts';

  @override
  String get checkedIn => 'Checked In';

  @override
  String get created => 'Created';

  @override
  String get deleteEvent => 'Delete Event';

  @override
  String get deleteEventHistoryConfirm =>
      'Are you sure you want to delete all event history?';

  @override
  String get delete => 'Delete';

  @override
  String get failedToLoadEvents => 'Failed to load events';

  @override
  String get failedToLoadEventDetails => 'Failed to load event details';

  @override
  String get messageTitle => 'Message';

  @override
  String get attachments => 'Attachments';

  @override
  String get newSentinel => 'New SENTINEL';

  @override
  String get eventName => 'Event Name';

  @override
  String get timer => 'Timer';

  @override
  String get enterMessage => 'Enter message to send if timer expires...';

  @override
  String get addFile => 'Add File';

  @override
  String get uploading => 'Uploading...';

  @override
  String get initiateSentinel => 'Initiate SENTINEL';

  @override
  String get addContact => 'Add Contact';

  @override
  String get selectContacts => 'Select Contacts';

  @override
  String get savedContacts => 'Saved Contacts';

  @override
  String contactsSelected(int count) {
    return 'Contacts Selected: $count';
  }

  @override
  String get searchContacts => 'Search contacts...';

  @override
  String get orEnterManually => 'OR ENTER MANUALLY';

  @override
  String get enterContactManually => 'ENTER CONTACT MANUALLY';

  @override
  String get emailExample => 'email@example.com';

  @override
  String get contactNameOptional => 'Contact Name (Optional)';

  @override
  String get selectAtLeastOneContact => 'Please select at least one contact';

  @override
  String get maxContactsAllowed => 'Max 10 contacts allowed';

  @override
  String get duration => 'Duration';

  @override
  String get date => 'Date';

  @override
  String get noRecipients => 'No recipients';

  @override
  String get safe => 'Safe';

  @override
  String get active => 'Active';

  @override
  String failedToOpenFile(String message) {
    return 'Failed to open file: $message';
  }

  @override
  String get failedToDownloadFile => 'Failed to download file';

  @override
  String get failedToDeleteAccount => 'Failed to delete account';

  @override
  String get language => 'Language';

  @override
  String get noEventCreatedYet => 'NO EVENT CREATED YET';

  @override
  String get somethingWentWrong => 'Something went wrong!';

  @override
  String get retry => 'Retry';

  @override
  String get english => 'English';

  @override
  String get french => 'French';

  @override
  String get spanish => 'Spanish';

  @override
  String get arabic => 'Arabic';

  @override
  String get chinese => 'Chinese';

  @override
  String get unknown => 'Unknown';

  @override
  String get none => 'NONE';

  @override
  String get days => 'd';

  @override
  String get notifTitle => 'SENTINEL';

  @override
  String get notifAlertTitle => 'SENTINEL Alert';

  @override
  String notifHourBody(Object eventName) {
    return 'Your SENTINEL \'$eventName\' expires in 1 hour';
  }

  @override
  String notifFifteenMinBody(Object eventName) {
    return 'Your SENTINEL \'$eventName\' expires in 15 minutes';
  }

  @override
  String notifFiveMinBody(Object eventName) {
    return 'Your SENTINEL \'$eventName\' expires in 5 minutes. Check in now.';
  }

  @override
  String notifFiredBody(Object eventName) {
    return 'SENTINEL \'$eventName\' has fired. Emergency contacts have been notified.';
  }

  @override
  String get notifCountdownBody =>
      'Emergency alerts will trigger when the timer reaches zero. Tap to check in.';

  @override
  String get notifTrackingTitle => 'Location tracking';

  @override
  String get notifTrackingBody => 'SENTINEL is tracking your location';

  @override
  String get notifTrackingDesc =>
      'Shows when SENTINEL is tracking your location';

  @override
  String get notifCountdownChannelName => 'SENTINEL Countdown';

  @override
  String get notifCountdownChannelDesc => 'Displays the active countdown timer';

  @override
  String get sentinelBrand => 'SENTINEL';

  @override
  String get contactNameHint => 'Contact name';

  @override
  String get noSavedContacts => 'No saved contacts';

  @override
  String get deleteContactTitle => 'Delete contact';

  @override
  String get deleteContactConfirm =>
      'will be removed from your saved contacts.';

  @override
  String get failedToLoadContacts => 'Failed to load contacts';
}
