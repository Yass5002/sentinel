import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('zh'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'SENTINEL'**
  String get appTitle;

  /// No description provided for @alertsSent.
  ///
  /// In en, this message translates to:
  /// **'Alert Sent'**
  String get alertsSent;

  /// No description provided for @cancelled.
  ///
  /// In en, this message translates to:
  /// **'Canceled'**
  String get cancelled;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'PENDING'**
  String get pending;

  /// No description provided for @recipients.
  ///
  /// In en, this message translates to:
  /// **'RECIPIENTS'**
  String get recipients;

  /// No description provided for @noContacts.
  ///
  /// In en, this message translates to:
  /// **'NO CONTACTS'**
  String get noContacts;

  /// No description provided for @details.
  ///
  /// In en, this message translates to:
  /// **'DETAILS'**
  String get details;

  /// No description provided for @cancelEvent.
  ///
  /// In en, this message translates to:
  /// **'CANCEL EVENT'**
  String get cancelEvent;

  /// No description provided for @cancelEventTitle.
  ///
  /// In en, this message translates to:
  /// **'CANCEL EVENT?'**
  String get cancelEventTitle;

  /// No description provided for @cancelEventBody.
  ///
  /// In en, this message translates to:
  /// **'This will cancel the event and no alerts will be sent.'**
  String get cancelEventBody;

  /// No description provided for @keepButton.
  ///
  /// In en, this message translates to:
  /// **'KEEP'**
  String get keepButton;

  /// No description provided for @iAmSafe.
  ///
  /// In en, this message translates to:
  /// **'I AM SAFE'**
  String get iAmSafe;

  /// No description provided for @returnToHome.
  ///
  /// In en, this message translates to:
  /// **'RETURN TO HOME'**
  String get returnToHome;

  /// No description provided for @tracking.
  ///
  /// In en, this message translates to:
  /// **'Tracking'**
  String get tracking;

  /// No description provided for @locationOff.
  ///
  /// In en, this message translates to:
  /// **'Location off'**
  String get locationOff;

  /// No description provided for @locationLimited.
  ///
  /// In en, this message translates to:
  /// **'Limited'**
  String get locationLimited;

  /// No description provided for @locationTrackingOffBanner.
  ///
  /// In en, this message translates to:
  /// **'Location tracking is off. Enable it in Settings.'**
  String get locationTrackingOffBanner;

  /// No description provided for @locationDeniedBanner.
  ///
  /// In en, this message translates to:
  /// **'Location is off. Your contacts will not receive your location.'**
  String get locationDeniedBanner;

  /// No description provided for @locationLimitedBanner.
  ///
  /// In en, this message translates to:
  /// **'Background location is limited. Your contacts may not receive your latest location.'**
  String get locationLimitedBanner;

  /// No description provided for @openSettings.
  ///
  /// In en, this message translates to:
  /// **'Open settings'**
  String get openSettings;

  /// No description provided for @noMessage.
  ///
  /// In en, this message translates to:
  /// **'No message provided.'**
  String get noMessage;

  /// No description provided for @filesCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 File} other{{count} Files}}'**
  String filesCount(int count);

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'SETTINGS'**
  String get settings;

  /// No description provided for @appLanguage.
  ///
  /// In en, this message translates to:
  /// **'App Language'**
  String get appLanguage;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'NOTIFICATIONS'**
  String get notifications;

  /// No description provided for @checkInReminders.
  ///
  /// In en, this message translates to:
  /// **'Check-in reminders'**
  String get checkInReminders;

  /// No description provided for @checkInRemindersSub.
  ///
  /// In en, this message translates to:
  /// **'Get alerted 1h, 15m, and 5m before your SENTINELs expire.'**
  String get checkInRemindersSub;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'LOCATION'**
  String get location;

  /// No description provided for @locationTracking.
  ///
  /// In en, this message translates to:
  /// **'Location tracking'**
  String get locationTracking;

  /// No description provided for @locationTrackingSub.
  ///
  /// In en, this message translates to:
  /// **'Share your location with emergency contacts while events are active.'**
  String get locationTrackingSub;

  /// No description provided for @locationBlocked.
  ///
  /// In en, this message translates to:
  /// **'Location access is blocked by your device settings'**
  String get locationBlocked;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'ACCOUNT'**
  String get account;

  /// No description provided for @logOut.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logOut;

  /// No description provided for @logOutConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out?'**
  String get logOutConfirmBody;

  /// No description provided for @dangerZone.
  ///
  /// In en, this message translates to:
  /// **'DANGER ZONE'**
  String get dangerZone;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccount;

  /// No description provided for @deleteAccountConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete your account? This action cannot be undone and all your data will be permanently removed.'**
  String get deleteAccountConfirmBody;

  /// No description provided for @deleting.
  ///
  /// In en, this message translates to:
  /// **'Deleting...'**
  String get deleting;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'ABOUT'**
  String get about;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy policy'**
  String get privacyPolicy;

  /// No description provided for @termsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of service'**
  String get termsOfService;

  /// No description provided for @neverMissCheckIn.
  ///
  /// In en, this message translates to:
  /// **'Never Miss a Check-in'**
  String get neverMissCheckIn;

  /// No description provided for @notificationPrimer.
  ///
  /// In en, this message translates to:
  /// **'SENTINEL needs notification permissions to alert you before your SENTINELs expire. Without this, you won\'t receive the crucial 1hr, 15m, and 5m countdown alerts.'**
  String get notificationPrimer;

  /// No description provided for @notNow.
  ///
  /// In en, this message translates to:
  /// **'Not Now'**
  String get notNow;

  /// No description provided for @enableNotifications.
  ///
  /// In en, this message translates to:
  /// **'Enable Notifications'**
  String get enableNotifications;

  /// No description provided for @shareLocationTitle.
  ///
  /// In en, this message translates to:
  /// **'Share your location with contacts'**
  String get shareLocationTitle;

  /// No description provided for @shareLocationBody.
  ///
  /// In en, this message translates to:
  /// **'If you don\'t check in, SENTINEL sends your last known location to your emergency contacts so they can find you. Location is only tracked while you have an active event.'**
  String get shareLocationBody;

  /// No description provided for @enableLocation.
  ///
  /// In en, this message translates to:
  /// **'Enable location'**
  String get enableLocation;

  /// No description provided for @allowBackgroundLocation.
  ///
  /// In en, this message translates to:
  /// **'Allow background location'**
  String get allowBackgroundLocation;

  /// No description provided for @backgroundLocationBody.
  ///
  /// In en, this message translates to:
  /// **'For your safety, allow location access \"All the time\" on the next screen. This ensures tracking continues even when your phone is locked.'**
  String get backgroundLocationBody;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @continueText.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueText;

  /// No description provided for @noEventCreated.
  ///
  /// In en, this message translates to:
  /// **'NO EVENT CREATED YET'**
  String get noEventCreated;

  /// No description provided for @loadMore.
  ///
  /// In en, this message translates to:
  /// **'LOAD MORE'**
  String get loadMore;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your email to get started'**
  String get loginTitle;

  /// No description provided for @emailHint.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailHint;

  /// No description provided for @emailRequired.
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get emailRequired;

  /// No description provided for @emailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get emailInvalid;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'GET STARTED'**
  String get getStarted;

  /// No description provided for @checkEmail.
  ///
  /// In en, this message translates to:
  /// **'Check your email'**
  String get checkEmail;

  /// No description provided for @codeSentTo.
  ///
  /// In en, this message translates to:
  /// **'We sent a 6-digit code to {email}'**
  String codeSentTo(String email);

  /// No description provided for @verify.
  ///
  /// In en, this message translates to:
  /// **'VERIFY'**
  String get verify;

  /// No description provided for @resendCode.
  ///
  /// In en, this message translates to:
  /// **'Resend code'**
  String get resendCode;

  /// No description provided for @resendCodeIn.
  ///
  /// In en, this message translates to:
  /// **'Resend code in {seconds}s'**
  String resendCodeIn(int seconds);

  /// No description provided for @codeSent.
  ///
  /// In en, this message translates to:
  /// **'Code sent'**
  String get codeSent;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'PROFILE'**
  String get profile;

  /// No description provided for @memberSince.
  ///
  /// In en, this message translates to:
  /// **'MEMBER SINCE'**
  String get memberSince;

  /// No description provided for @editNameTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit name'**
  String get editNameTitle;

  /// No description provided for @nameHint.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get nameHint;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @helpTitle.
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get helpTitle;

  /// No description provided for @helpQ1.
  ///
  /// In en, this message translates to:
  /// **'What is SENTINEL?'**
  String get helpQ1;

  /// No description provided for @helpA1.
  ///
  /// In en, this message translates to:
  /// **'SENTINEL is your personal safety companion. It allows you to set a timer and if you don\'t check in before it expires, it automatically alerts your emergency contacts with your last known location and a custom message.'**
  String get helpA1;

  /// No description provided for @helpQ2.
  ///
  /// In en, this message translates to:
  /// **'How do I create a new SENTINEL?'**
  String get helpQ2;

  /// No description provided for @helpA2.
  ///
  /// In en, this message translates to:
  /// **'Tap the \'+\' button on the home screen. Set a duration (e.g., 30 minutes), add any notes or files, and select your emergency contacts. Tap \'Initiate SENTINEL\' to start.'**
  String get helpA2;

  /// No description provided for @helpQ3.
  ///
  /// In en, this message translates to:
  /// **'What happens when the timer expires?'**
  String get helpQ3;

  /// No description provided for @helpA3.
  ///
  /// In en, this message translates to:
  /// **'When the timer reaches zero, SENTINEL immediately notifies all your selected emergency contacts via SMS/Email. They will receive your custom message and a link to view your last known location on a map.'**
  String get helpA3;

  /// No description provided for @helpQ4.
  ///
  /// In en, this message translates to:
  /// **'What is a \'Check-In\'?'**
  String get helpQ4;

  /// No description provided for @helpA4.
  ///
  /// In en, this message translates to:
  /// **'Checking in cancels the active countdown. Use this once you are safe or no longer need the SENTINEL. If you check in, no alerts will be sent.'**
  String get helpA4;

  /// No description provided for @helpQ5.
  ///
  /// In en, this message translates to:
  /// **'Can I extend an active timer?'**
  String get helpQ5;

  /// No description provided for @helpA5.
  ///
  /// In en, this message translates to:
  /// **'Yes! Tap on your active SENTINEL and use the \'Extend\' button to add more time if your situation changes.'**
  String get helpA5;

  /// No description provided for @helpQ6.
  ///
  /// In en, this message translates to:
  /// **'Who are emergency contacts?'**
  String get helpQ6;

  /// No description provided for @helpA6.
  ///
  /// In en, this message translates to:
  /// **'Emergency contacts are people you trust. You must select at least one contact for every SENTINEL. You can manage your contacts in the \'Contacts\' screen accessible from the drawer.'**
  String get helpA6;

  /// No description provided for @helpQ7.
  ///
  /// In en, this message translates to:
  /// **'Does SENTINEL track my location?'**
  String get helpQ7;

  /// No description provided for @helpA7.
  ///
  /// In en, this message translates to:
  /// **'SENTINEL ONLY tracks your location while a timer is active. We value your privacy and do not monitor your movements when the app is idle or no SENTINELs are running.'**
  String get helpA7;

  /// No description provided for @helpQ8.
  ///
  /// In en, this message translates to:
  /// **'What if I have no internet?'**
  String get helpQ8;

  /// No description provided for @helpA8.
  ///
  /// In en, this message translates to:
  /// **'SENTINEL requires an internet connection to initiate an event and upload data. If you lose connection during an active event, the countdown on our servers will still trigger the alert unless you check in.'**
  String get helpA8;

  /// No description provided for @helpQ9.
  ///
  /// In en, this message translates to:
  /// **'How many contacts can I add?'**
  String get helpQ9;

  /// No description provided for @helpA9.
  ///
  /// In en, this message translates to:
  /// **'You can add up to 10 emergency contacts per SENTINEL event.'**
  String get helpA9;

  /// No description provided for @helpQ10.
  ///
  /// In en, this message translates to:
  /// **'Is my data secure?'**
  String get helpQ10;

  /// No description provided for @helpA10.
  ///
  /// In en, this message translates to:
  /// **'Yes, your personal data and location are encrypted. Only the emergency contacts you specify can see your location, and only after an alert is triggered.'**
  String get helpA10;

  /// No description provided for @helpQ11.
  ///
  /// In en, this message translates to:
  /// **'Can I add photos or recordings?'**
  String get helpQ11;

  /// No description provided for @helpA11.
  ///
  /// In en, this message translates to:
  /// **'Yes! When creating a SENTINEL, you can attach files. These will be shared with your contacts if the alert is triggered, providing more context about your situation.'**
  String get helpA11;

  /// No description provided for @helpQ12.
  ///
  /// In en, this message translates to:
  /// **'What is the \'I AM SAFE\' button?'**
  String get helpQ12;

  /// No description provided for @helpA12.
  ///
  /// In en, this message translates to:
  /// **'This is your check-in button. Tapping it tells SENTINEL that you are okay, which immediately stops the countdown and prevents any alerts from being sent.'**
  String get helpA12;

  /// No description provided for @helpQ13.
  ///
  /// In en, this message translates to:
  /// **'Does the app need to be open?'**
  String get helpQ13;

  /// No description provided for @helpA13.
  ///
  /// In en, this message translates to:
  /// **'No. SENTINEL runs its critical countdown on our secure servers. Even if your phone dies, loses battery, or is destroyed, the alert will still be sent when the timer expires.'**
  String get helpA13;

  /// No description provided for @helpQ14.
  ///
  /// In en, this message translates to:
  /// **'How do I manage my profile?'**
  String get helpQ14;

  /// No description provided for @helpA14.
  ///
  /// In en, this message translates to:
  /// **'You can update your name and see your account details in the \'Profile\' section, accessible from the app drawer.'**
  String get helpA14;

  /// No description provided for @helpQ15.
  ///
  /// In en, this message translates to:
  /// **'What if I trigger an alert by mistake?'**
  String get helpQ15;

  /// No description provided for @helpA15.
  ///
  /// In en, this message translates to:
  /// **'If an alert is sent, your contacts will be notified. We recommend contacting them immediately to let them know it was a false alarm. Always try to check in BEFORE the timer reaches zero.'**
  String get helpA15;

  /// No description provided for @contactSupport.
  ///
  /// In en, this message translates to:
  /// **'Contact Support'**
  String get contactSupport;

  /// No description provided for @contactSupportText.
  ///
  /// In en, this message translates to:
  /// **'If you have any issues or suggestions, please contact us at:'**
  String get contactSupportText;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @contacts.
  ///
  /// In en, this message translates to:
  /// **'Contacts'**
  String get contacts;

  /// No description provided for @checkedIn.
  ///
  /// In en, this message translates to:
  /// **'Checked In'**
  String get checkedIn;

  /// No description provided for @created.
  ///
  /// In en, this message translates to:
  /// **'Created'**
  String get created;

  /// No description provided for @deleteEvent.
  ///
  /// In en, this message translates to:
  /// **'Delete Event'**
  String get deleteEvent;

  /// No description provided for @deleteEventHistoryConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete all event history?'**
  String get deleteEventHistoryConfirm;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @failedToLoadEvents.
  ///
  /// In en, this message translates to:
  /// **'Failed to load events'**
  String get failedToLoadEvents;

  /// No description provided for @failedToLoadEventDetails.
  ///
  /// In en, this message translates to:
  /// **'Failed to load event details'**
  String get failedToLoadEventDetails;

  /// No description provided for @messageTitle.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get messageTitle;

  /// No description provided for @attachments.
  ///
  /// In en, this message translates to:
  /// **'Attachments'**
  String get attachments;

  /// No description provided for @newSentinel.
  ///
  /// In en, this message translates to:
  /// **'New SENTINEL'**
  String get newSentinel;

  /// No description provided for @eventName.
  ///
  /// In en, this message translates to:
  /// **'Event Name'**
  String get eventName;

  /// No description provided for @timer.
  ///
  /// In en, this message translates to:
  /// **'Timer'**
  String get timer;

  /// No description provided for @enterMessage.
  ///
  /// In en, this message translates to:
  /// **'Enter message to send if timer expires...'**
  String get enterMessage;

  /// No description provided for @addFile.
  ///
  /// In en, this message translates to:
  /// **'Add File'**
  String get addFile;

  /// No description provided for @uploading.
  ///
  /// In en, this message translates to:
  /// **'Uploading...'**
  String get uploading;

  /// No description provided for @initiateSentinel.
  ///
  /// In en, this message translates to:
  /// **'Initiate SENTINEL'**
  String get initiateSentinel;

  /// No description provided for @addContact.
  ///
  /// In en, this message translates to:
  /// **'Add Contact'**
  String get addContact;

  /// No description provided for @selectContacts.
  ///
  /// In en, this message translates to:
  /// **'Select Contacts'**
  String get selectContacts;

  /// No description provided for @savedContacts.
  ///
  /// In en, this message translates to:
  /// **'Saved Contacts'**
  String get savedContacts;

  /// No description provided for @contactsSelected.
  ///
  /// In en, this message translates to:
  /// **'Contacts Selected: {count}'**
  String contactsSelected(int count);

  /// No description provided for @searchContacts.
  ///
  /// In en, this message translates to:
  /// **'Search contacts...'**
  String get searchContacts;

  /// No description provided for @orEnterManually.
  ///
  /// In en, this message translates to:
  /// **'OR ENTER MANUALLY'**
  String get orEnterManually;

  /// No description provided for @enterContactManually.
  ///
  /// In en, this message translates to:
  /// **'ENTER CONTACT MANUALLY'**
  String get enterContactManually;

  /// No description provided for @emailExample.
  ///
  /// In en, this message translates to:
  /// **'email@example.com'**
  String get emailExample;

  /// No description provided for @contactNameOptional.
  ///
  /// In en, this message translates to:
  /// **'Contact Name (Optional)'**
  String get contactNameOptional;

  /// No description provided for @selectAtLeastOneContact.
  ///
  /// In en, this message translates to:
  /// **'Please select at least one contact'**
  String get selectAtLeastOneContact;

  /// No description provided for @maxContactsAllowed.
  ///
  /// In en, this message translates to:
  /// **'Max 10 contacts allowed'**
  String get maxContactsAllowed;

  /// No description provided for @duration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get duration;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @noRecipients.
  ///
  /// In en, this message translates to:
  /// **'No recipients'**
  String get noRecipients;

  /// No description provided for @safe.
  ///
  /// In en, this message translates to:
  /// **'Safe'**
  String get safe;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @failedToOpenFile.
  ///
  /// In en, this message translates to:
  /// **'Failed to open file: {message}'**
  String failedToOpenFile(String message);

  /// No description provided for @failedToDownloadFile.
  ///
  /// In en, this message translates to:
  /// **'Failed to download file'**
  String get failedToDownloadFile;

  /// No description provided for @failedToDeleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete account'**
  String get failedToDeleteAccount;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @noEventCreatedYet.
  ///
  /// In en, this message translates to:
  /// **'NO EVENT CREATED YET'**
  String get noEventCreatedYet;

  /// No description provided for @somethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong!'**
  String get somethingWentWrong;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @french.
  ///
  /// In en, this message translates to:
  /// **'French'**
  String get french;

  /// No description provided for @spanish.
  ///
  /// In en, this message translates to:
  /// **'Spanish'**
  String get spanish;

  /// No description provided for @arabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get arabic;

  /// No description provided for @chinese.
  ///
  /// In en, this message translates to:
  /// **'Chinese'**
  String get chinese;

  /// No description provided for @unknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// No description provided for @none.
  ///
  /// In en, this message translates to:
  /// **'NONE'**
  String get none;

  /// No description provided for @days.
  ///
  /// In en, this message translates to:
  /// **'d'**
  String get days;

  /// No description provided for @notifTitle.
  ///
  /// In en, this message translates to:
  /// **'SENTINEL'**
  String get notifTitle;

  /// No description provided for @notifAlertTitle.
  ///
  /// In en, this message translates to:
  /// **'SENTINEL Alert'**
  String get notifAlertTitle;

  /// No description provided for @notifHourBody.
  ///
  /// In en, this message translates to:
  /// **'Your SENTINEL \'{eventName}\' expires in 1 hour'**
  String notifHourBody(Object eventName);

  /// No description provided for @notifFifteenMinBody.
  ///
  /// In en, this message translates to:
  /// **'Your SENTINEL \'{eventName}\' expires in 15 minutes'**
  String notifFifteenMinBody(Object eventName);

  /// No description provided for @notifFiveMinBody.
  ///
  /// In en, this message translates to:
  /// **'Your SENTINEL \'{eventName}\' expires in 5 minutes. Check in now.'**
  String notifFiveMinBody(Object eventName);

  /// No description provided for @notifFiredBody.
  ///
  /// In en, this message translates to:
  /// **'SENTINEL \'{eventName}\' has fired. Emergency contacts have been notified.'**
  String notifFiredBody(Object eventName);

  /// No description provided for @notifCountdownBody.
  ///
  /// In en, this message translates to:
  /// **'Emergency alerts will trigger when the timer reaches zero. Tap to check in.'**
  String get notifCountdownBody;

  /// No description provided for @notifTrackingTitle.
  ///
  /// In en, this message translates to:
  /// **'Location tracking'**
  String get notifTrackingTitle;

  /// No description provided for @notifTrackingBody.
  ///
  /// In en, this message translates to:
  /// **'SENTINEL is tracking your location'**
  String get notifTrackingBody;

  /// No description provided for @notifTrackingDesc.
  ///
  /// In en, this message translates to:
  /// **'Shows when SENTINEL is tracking your location'**
  String get notifTrackingDesc;

  /// No description provided for @notifCountdownChannelName.
  ///
  /// In en, this message translates to:
  /// **'SENTINEL Countdown'**
  String get notifCountdownChannelName;

  /// No description provided for @notifCountdownChannelDesc.
  ///
  /// In en, this message translates to:
  /// **'Displays the active countdown timer'**
  String get notifCountdownChannelDesc;

  /// No description provided for @sentinelBrand.
  ///
  /// In en, this message translates to:
  /// **'SENTINEL'**
  String get sentinelBrand;

  /// No description provided for @contactNameHint.
  ///
  /// In en, this message translates to:
  /// **'Contact name'**
  String get contactNameHint;

  /// No description provided for @noSavedContacts.
  ///
  /// In en, this message translates to:
  /// **'No saved contacts'**
  String get noSavedContacts;

  /// No description provided for @deleteContactTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete contact'**
  String get deleteContactTitle;

  /// No description provided for @deleteContactConfirm.
  ///
  /// In en, this message translates to:
  /// **'will be removed from your saved contacts.'**
  String get deleteContactConfirm;

  /// No description provided for @failedToLoadContacts.
  ///
  /// In en, this message translates to:
  /// **'Failed to load contacts'**
  String get failedToLoadContacts;

  /// No description provided for @contactEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'EMAIL'**
  String get contactEmailLabel;

  /// No description provided for @contactNameLabel.
  ///
  /// In en, this message translates to:
  /// **'NAME (OPTIONAL)'**
  String get contactNameLabel;

  /// No description provided for @contactAlreadyExists.
  ///
  /// In en, this message translates to:
  /// **'A contact with this email already exists'**
  String get contactAlreadyExists;

  /// No description provided for @unableToLoadProfile.
  ///
  /// In en, this message translates to:
  /// **'Unable to load profile'**
  String get unableToLoadProfile;

  /// No description provided for @setYourName.
  ///
  /// In en, this message translates to:
  /// **'Set your name'**
  String get setYourName;

  /// No description provided for @nameVisibleToContacts.
  ///
  /// In en, this message translates to:
  /// **'This is the name your contacts see in alert emails'**
  String get nameVisibleToContacts;

  /// No description provided for @failedToLoadProfile.
  ///
  /// In en, this message translates to:
  /// **'Failed to load profile'**
  String get failedToLoadProfile;

  /// No description provided for @nameRequired.
  ///
  /// In en, this message translates to:
  /// **'Name is required'**
  String get nameRequired;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en', 'es', 'fr', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
