// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'SENTINEL';

  @override
  String get alertsSent => 'تم إرسال التنبيهات';

  @override
  String get cancelled => 'ملغي';

  @override
  String get pending => 'قيد الانتظار';

  @override
  String get recipients => 'المستلمون';

  @override
  String get noContacts => 'لا توجد جهات اتصال';

  @override
  String get details => 'التفاصيل';

  @override
  String get cancelEvent => 'إلغاء الحدث';

  @override
  String get cancelEventTitle => 'هل تريد إلغاء الحدث؟';

  @override
  String get cancelEventBody =>
      'سيؤدي هذا إلى إلغاء الحدث ولن يتم إرسال أي تنبيهات.';

  @override
  String get keepButton => 'احتفاظ';

  @override
  String get iAmSafe => 'أنا آمن';

  @override
  String get returnToHome => 'العودة إلى الرئيسية';

  @override
  String get tracking => 'تتبع';

  @override
  String get locationOff => 'الموقع متوقف';

  @override
  String get locationLimited => 'محدود';

  @override
  String get locationTrackingOffBanner =>
      'تتبع الموقع متوقف. قم بتمكينه في الإعدادات.';

  @override
  String get locationDeniedBanner =>
      'الموقع متوقف. لن تتلقى جهات الاتصال الخاصة بك موقعك.';

  @override
  String get locationLimitedBanner =>
      'الموقع في الخلفية محدود. قد لا تتلقى جهات الاتصال موقعك الأخير.';

  @override
  String get openSettings => 'فتح الإعدادات';

  @override
  String get noMessage => 'لا توجد رسالة.';

  @override
  String filesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ملف',
      many: '$count ملفًا',
      few: '$count ملفات',
      two: 'ملفان',
      one: 'ملف واحد',
      zero: 'لا توجد ملفات',
    );
    return '$_temp0';
  }

  @override
  String get settings => 'الإعدادات';

  @override
  String get appLanguage => 'لغة التطبيق';

  @override
  String get notifications => 'الإشعارات';

  @override
  String get checkInReminders => 'تذكيرات تسجيل الوصول';

  @override
  String get checkInRemindersSub =>
      'احصل على تنبيهات قبل ساعة و 15 دقيقة و 5 دقائق من انتهاء صلاحية المراقبين.';

  @override
  String get location => 'الموقع';

  @override
  String get locationTracking => 'تتبع الموقع';

  @override
  String get locationTrackingSub =>
      'شارك موقعك مع جهات اتصال الطوارئ أثناء تنشيط الأحداث.';

  @override
  String get locationBlocked =>
      'تم حظر الوصول إلى الموقع من خلال إعدادات جهازك';

  @override
  String get account => 'الحساب';

  @override
  String get logOut => 'تسجيل الخروج';

  @override
  String get logOutConfirmBody => 'هل أنت متأكد أنك تريد تسجيل الخروج؟';

  @override
  String get dangerZone => 'منطقة الخطر';

  @override
  String get deleteAccount => 'حذف الحساب';

  @override
  String get deleteAccountConfirmBody =>
      'هل أنت متأكد أنك تريد حذف حسابك؟ لا يمكن التراجع عن هذا الإجراء وستتم إزالة جميع بياناتك بشكل دائم.';

  @override
  String get deleting => 'جاري الحذف...';

  @override
  String get about => 'حول';

  @override
  String get privacyPolicy => 'سياسة الخصوصية';

  @override
  String get termsOfService => 'شروط الخدمة';

  @override
  String get neverMissCheckIn => 'لا تفوت أبدا تسجيل الوصول';

  @override
  String get notificationPrimer =>
      'يحتاج SENTINEL إلى أذونات الإشعارات لتنبيهك قبل انتهاء صلاحية المراقبين. بدون ذلك، لن تتلقى تنبيهات العد التنازلي الحاسمة لمدة ساعة و 15 دقيقة و 5 دقائق.';

  @override
  String get notNow => 'ليس الآن';

  @override
  String get enableNotifications => 'تمكين الإشعارات';

  @override
  String get shareLocationTitle => 'شارك موقعك مع جهات الاتصال';

  @override
  String get shareLocationBody =>
      'إذا لم تقم بتسجيل الوصول، يرسل SENTINEL آخر موقع معروف لك إلى جهات اتصال الطوارئ الخاصة بك حتى يتمكنوا من العثور عليك. يتم تتبع الموقع فقط أثناء وجود حدث نشط.';

  @override
  String get enableLocation => 'تمكين الموقع';

  @override
  String get allowBackgroundLocation => 'السماح بالموقع في الخلفية';

  @override
  String get backgroundLocationBody =>
      'من أجل سلامتك، اسمح بالوصول إلى الموقع \"طوال الوقت\" في الشاشة التالية. يضمن هذا استمرار التتبع حتى عندما يكون هاتفك مقفلاً.';

  @override
  String get skip => 'تخطي';

  @override
  String get continueText => 'متابعة';

  @override
  String get noEventCreated => 'لم يتم إنشاء أي حدث بعد';

  @override
  String get loadMore => 'تحميل المزيد';

  @override
  String get cancel => 'إلغاء';

  @override
  String get loginTitle => 'أدخل بريدك الإلكتروني للبدء';

  @override
  String get emailHint => 'البريد الإلكتروني';

  @override
  String get emailRequired => 'البريد الإلكتروني مطلوب';

  @override
  String get emailInvalid => 'رجاء إدخال بريد إلكتروني صحيح';

  @override
  String get getStarted => 'البدء';

  @override
  String get checkEmail => 'تحقق من بريدك الإلكتروني';

  @override
  String codeSentTo(String email) {
    return 'لقد أرسلنا رمزًا مكونًا من 6 أرقام إلى $email';
  }

  @override
  String get verify => 'تحقق';

  @override
  String get resendCode => 'إعادة إرسال الرمز';

  @override
  String resendCodeIn(int seconds) {
    return 'إعادة إرسال الرمز خلال $seconds ثانية';
  }

  @override
  String get codeSent => 'تم إرسال الرمز';

  @override
  String get profile => 'الملف الشخصي';

  @override
  String get memberSince => 'عضو منذ';

  @override
  String get editNameTitle => 'تعديل الاسم';

  @override
  String get nameHint => 'الاسم';

  @override
  String get save => 'حفظ';

  @override
  String get helpTitle => 'المساعدة';

  @override
  String get helpQ1 => 'ما هو SENTINEL؟';

  @override
  String get helpA1 =>
      'SENTINEL هو رفيق السلامة الشخصي الخاص بك. يتيح لك ضبط مؤقت، وإذا لم تقم بتسجيل الوصول قبل انتهاء صلاحيته، فإنه يقوم تلقائيًا بتنبيه جهات اتصال الطوارئ الخاصة بك مع آخر موقع معروف لك ورسالة مخصصة.';

  @override
  String get helpQ2 => 'كيف أقوم بإنشاء SENTINEL جديد؟';

  @override
  String get helpA2 =>
      'اضغط على الزر \'+\' على الشاشة الرئيسية. حدد مدة (على سبيل المثال، 30 دقيقة)، وأضف أي ملاحظات أو ملفات، واصحب جهات اتصال الطوارئ الخاصة بك. اضغط على \'بدء SENTINEL\' للبدء.';

  @override
  String get helpQ3 => 'ماذا يحدث عند انتهاء المؤقت؟';

  @override
  String get helpA3 =>
      'عندما يصل المؤقت إلى الصفر، يقوم SENTINEL على الفور بإخطار جميع جهات اتصال الطوارئ التي حددتها عبر الرسائل القصيرة/البريد الإلكتروني. سيتلقون رسالتك المخصصة ورابطاً لعرض آخر موقع معروف لك على الخريطة.';

  @override
  String get helpQ4 => 'ما هو \'تسجيل الوصول\'؟';

  @override
  String get helpA4 =>
      'يؤدي تسجيل الوصول إلى إلغاء العد التنازلي النشط. استخدم هذا بمجرد أن تصبح آمناً أو لم تعد بحاجة إلى SENTINEL. إذا قمت بتسجيل الوصول، فلن يتم إرسال أي تنبيهات.';

  @override
  String get helpQ5 => 'هل يمكنني تمديد المؤقت النشط؟';

  @override
  String get helpA5 =>
      'نعم! اضغط على SENTINEL النشط واستخدم زر \'تمديد\' لإضافة المزيد من الوقت إذا تغير وضعك.';

  @override
  String get helpQ6 => 'من هم جهات اتصال الطوارئ؟';

  @override
  String get helpA6 =>
      'جهات اتصال الطوارئ هم أشخاص تثق بهم. يجب عليك تحديد جهة اتصال واحدة على الأقل لكل SENTINEL. يمكنك إدارة جهات الاتصال الخاصة بك في شاشة \'جهات الاتصال\' التي يمكن الوصول إليها من الدرج.';

  @override
  String get helpQ7 => 'هل يتتبع SENTINEL موقعي؟';

  @override
  String get helpA7 =>
      'يتتبع SENTINEL موقعك فقط أثناء نشاط المؤقت. نحن نقدر خصوصيتك ولا نراقب تحركاتك عندما يكون التطبيق خاملاً أو عندما لا يكون هناك SENTINEL قيد التشغيل.';

  @override
  String get helpQ8 => 'ماذا لو لم يكن لدي إنترنت؟';

  @override
  String get helpA8 =>
      'يتطلب SENTINEL اتصالاً بالإنترنت لبدء حدث وتحميل البيانات. إذا فقدت الاتصال أثناء حدث نشط، فسيظل العد التنازلي على خوادمنا يطلق التنبيه ما لم تقم بتسجيل الوصول.';

  @override
  String get helpQ9 => 'كم عدد جهات الاتصال التي يمكنني إضافتها؟';

  @override
  String get helpA9 =>
      'يمكنك إضافة ما يصل إلى 10 جهات اتصال طوارئ لكل حدث SENTINEL.';

  @override
  String get helpQ10 => 'هل بياناتي آمنة؟';

  @override
  String get helpA10 =>
      'نعم، بياناتك الشخصية وموقعك مشفرة. يمكن فقط لجهات اتصال الطوارئ التي تحددها رؤية موقعك، وفقط بعد إطلاق التنبيه.';

  @override
  String get helpQ11 => 'هل يمكنني إضافة صور أو تسجيلات؟';

  @override
  String get helpA11 =>
      'نعم! عند إنشاء SENTINEL، يمكنك إرفاق ملفات. سيتم مشاركة هذه الملفات مع جهات الاتصال الخاصة بك إذا تم إطلاق التنبيه، مما يوفر المزيد من السياق حول وضعك.';

  @override
  String get helpQ12 => 'ما هو زر \'أنا بأمان\'؟';

  @override
  String get helpA12 =>
      'هذا هو زر تسجيل الوصول الخاص بك. الضغط عليه يخبر SENTINEL أنك بخير، مما يوقف العد التنازلي على الفور ويمنع إرسال أي تنبيهات.';

  @override
  String get helpQ13 => 'هل يجب أن يكون التطبيق مفتوحاً؟';

  @override
  String get helpA13 =>
      'لا. يقوم SENTINEL بتشغيل العد التنازلي الحرج الخاص به على خوادمنا الآمنة. حتى لو توقف هاتفك عن العمل أو نفدت بطاريته أو تم تدميره، فسيظل التنبيه يرسل عند انتهاء المؤقت.';

  @override
  String get helpQ14 => 'كيف أدير ملفي الشخصي؟';

  @override
  String get helpA14 =>
      'يمكنك تحديث اسمك ورؤية تفاصيل حسابك في قسم \'الملف الشخصي\'، الذي يمكن الوصول إليه من درج التطبيق.';

  @override
  String get helpQ15 => 'ماذا لو أطلقت تنبيهاً عن طريق الخطأ؟';

  @override
  String get helpA15 =>
      'إذا تم إرسال تنبيه، فسيتم إخطار جهات الاتصال الخاصة بك. نوصي بالاتصال بهم على الفور لإخبارهم أنه كان إنذاراً كاذباً. حاول دائماً تسجيل الوصول قبل أن يصل المؤقت إلى الصفر.';

  @override
  String get contactSupport => 'اتصل بالدعم';

  @override
  String get contactSupportText =>
      'إذا كان لديك أي مشاكل أو اقتراحات، يرجى الاتصال بنا على:';

  @override
  String get loading => 'جاري التحميل...';

  @override
  String get home => 'الرئيسية';

  @override
  String get contacts => 'جهات الاتصال';

  @override
  String get checkedIn => 'تم تسجيل الوصول';

  @override
  String get created => 'أنشئ في';

  @override
  String get deleteEvent => 'حذف الحدث';

  @override
  String get deleteEventHistoryConfirm =>
      'هل أنت متأكد من رغبتك في حذف كل تاريخ الأحداث؟';

  @override
  String get delete => 'حذف';

  @override
  String get failedToLoadEvents => 'فشل تحميل الأحداث';

  @override
  String get failedToLoadEventDetails => 'فشل تحميل تفاصيل الحدث';

  @override
  String get messageTitle => 'الرسالة';

  @override
  String get attachments => 'المرفقات';

  @override
  String get newSentinel => 'SENTINEL جديد';

  @override
  String get eventName => 'اسم الحدث';

  @override
  String get timer => 'المؤقت';

  @override
  String get enterMessage => 'أدخل الرسالة المراد إرسالها إذا انتهى المؤقت...';

  @override
  String get addFile => 'إضافة ملف';

  @override
  String get uploading => 'جاري الرفع...';

  @override
  String get initiateSentinel => 'بدء SENTINEL';

  @override
  String get addContact => 'إضافة جهة اتصال';

  @override
  String get selectContacts => 'اختيار جهات اتصال';

  @override
  String get savedContacts => 'جهات الاتصال المحفوظة';

  @override
  String contactsSelected(int count) {
    return 'جهات اتصال مختارة: $count';
  }

  @override
  String get searchContacts => 'البحث في جهات الاتصال...';

  @override
  String get orEnterManually => 'أو أدخل يدوياً';

  @override
  String get enterContactManually => 'أدخل جهة الاتصال يدوياً';

  @override
  String get emailExample => 'email@example.com';

  @override
  String get contactNameOptional => 'اسم جهة الاتصال (اختياري)';

  @override
  String get selectAtLeastOneContact => 'يرجى اختيار جهة اتصال واحدة على الأقل';

  @override
  String get maxContactsAllowed => 'يسمح بحد أقصى 10 جهات اتصال';

  @override
  String get duration => 'المدة';

  @override
  String get date => 'التاريخ';

  @override
  String get noRecipients => 'لا يوجد مستلمون';

  @override
  String get safe => 'آمن';

  @override
  String get active => 'نشط';

  @override
  String failedToOpenFile(String message) {
    return 'فشل فتح الملف: $message';
  }

  @override
  String get failedToDownloadFile => 'فشل تحميل الملف';

  @override
  String get failedToDeleteAccount => 'فشل حذف الحساب';

  @override
  String get language => 'اللغة';

  @override
  String get noEventCreatedYet => 'لم يتم إنشاء أحداث بعد';

  @override
  String get somethingWentWrong => 'حدث خطأ ما!';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get english => 'الإنجليزية';

  @override
  String get french => 'الفرنسية';

  @override
  String get spanish => 'الإسبانية';

  @override
  String get arabic => 'العربية';

  @override
  String get chinese => 'الصينية';

  @override
  String get unknown => 'غير معروف';

  @override
  String get none => 'لا يوجد';

  @override
  String get days => 'ي';

  @override
  String get notifTitle => 'SENTINEL';

  @override
  String get notifAlertTitle => 'تنبيه SENTINEL';

  @override
  String notifHourBody(Object eventName) {
    return 'ينتهي \'SENTINEL \'$eventName\' الخاص بك خلال ساعة واحدة';
  }

  @override
  String notifFifteenMinBody(Object eventName) {
    return 'ينتهي \'SENTINEL \'$eventName\' الخاص بك خلال 15 دقيقة';
  }

  @override
  String notifFiveMinBody(Object eventName) {
    return 'ينتهي \'SENTINEL \'$eventName\' الخاص بك خلال 5 دقائق. سجل حضورك الآن.';
  }

  @override
  String notifFiredBody(Object eventName) {
    return 'تم إطلاق SENTINEL \'$eventName\'. تم إخطار جهات اتصال الطوارئ الخاصة بك.';
  }

  @override
  String get notifCountdownBody =>
      'سيتم إطلاق تنبيهات الطوارئ عندما يصل المؤقت إلى الصفر. اضغط لتسجيل الحضور.';

  @override
  String get notifTrackingTitle => 'تتبع الموقع';

  @override
  String get notifTrackingBody => 'يقوم SENTINEL بتتبع موقعك';

  @override
  String get notifTrackingDesc => 'يظهر عندما يقوم SENTINEL بتتبع موقعك';

  @override
  String get notifCountdownChannelName => 'عد تنازلي SENTINEL';

  @override
  String get notifCountdownChannelDesc => 'يعرض مؤقت العد التنازلي النشط';

  @override
  String get sentinelBrand => 'SENTINEL';

  @override
  String get contactNameHint => 'اسم جهة الاتصال';

  @override
  String get noSavedContacts => 'لا توجد جهات اتصال محفوظة';

  @override
  String get deleteContactTitle => 'حذف جهة الاتصال';

  @override
  String get deleteContactConfirm =>
      'سيتم إزالتها من جهات الاتصال المحفوظة لديك.';

  @override
  String get failedToLoadContacts => 'فشل تحميل جهات الاتصال';

  @override
  String get contactEmailLabel => 'البريد الإلكتروني';

  @override
  String get contactNameLabel => 'الاسم (اختياري)';

  @override
  String get contactAlreadyExists =>
      'يوجد بالفعل جهة اتصال بهذا البريد الإلكتروني';

  @override
  String get unableToLoadProfile => 'تعذر تحميل الملف الشخصي';

  @override
  String get setYourName => 'حدد اسمك';

  @override
  String get nameVisibleToContacts =>
      'هذا هو الاسم الذي تراه جهات الاتصال الخاصة بك في رسائل التنبيه الإلكترونية';

  @override
  String get failedToLoadProfile => 'فشل تحميل الملف الشخصي';

  @override
  String get nameRequired => 'الاسم مطلوب';
}
