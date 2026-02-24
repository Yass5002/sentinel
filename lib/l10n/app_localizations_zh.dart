// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'SENTINEL';

  @override
  String get alertsSent => '警报已发送';

  @override
  String get cancelled => '已取消';

  @override
  String get pending => '待处理';

  @override
  String get recipients => '收件人';

  @override
  String get noContacts => '无联系人';

  @override
  String get details => '详细信息';

  @override
  String get cancelEvent => '取消事件';

  @override
  String get cancelEventTitle => '取消事件？';

  @override
  String get cancelEventBody => '这将取消该事件，并且不会发送任何警报。';

  @override
  String get keepButton => '保留';

  @override
  String get iAmSafe => '我很安全';

  @override
  String get returnToHome => '返回主页';

  @override
  String get tracking => '跟踪中';

  @override
  String get locationOff => '定位关闭';

  @override
  String get locationLimited => '受限';

  @override
  String get locationTrackingOffBanner => '位置跟踪已关闭。请在设置中启用。';

  @override
  String get locationDeniedBanner => '定位已关闭。您的联系人将无法收到您的位置信息。';

  @override
  String get locationLimitedBanner => '后台定位受到限制。您的联系人可能无法接收到您最新的位置信息。';

  @override
  String get openSettings => '打开设置';

  @override
  String get noMessage => '未提供消息。';

  @override
  String filesCount(int count) {
    return '$count 个文件';
  }

  @override
  String get settings => '设置';

  @override
  String get appLanguage => '应用语言';

  @override
  String get notifications => '通知';

  @override
  String get checkInReminders => '签到提醒';

  @override
  String get checkInRemindersSub => '在您的 SENTINEL 过期前 1 小时、15 分钟和 5 分钟收到警报。';

  @override
  String get location => '位置';

  @override
  String get locationTracking => '位置跟踪';

  @override
  String get locationTrackingSub => '在事件处于活动状态时与紧急联系人共享您的位置。';

  @override
  String get locationBlocked => '定位访问已被您的设备设置阻止';

  @override
  String get account => '账户';

  @override
  String get logOut => '登出';

  @override
  String get logOutConfirmBody => '您确定要登出吗？';

  @override
  String get dangerZone => '危险区域';

  @override
  String get deleteAccount => '删除账户';

  @override
  String get deleteAccountConfirmBody => '您确定要删除您的账户吗？此操作无法撤销，您的所有数据将被永久删除。';

  @override
  String get deleting => '删除中...';

  @override
  String get about => '关于';

  @override
  String get privacyPolicy => '隐私政策';

  @override
  String get termsOfService => '服务条款';

  @override
  String get neverMissCheckIn => '绝不会错过签到';

  @override
  String get notificationPrimer =>
      'SENTINEL 需要通知权限才能在您的 SENTINEL 过期前向您发出警报。如果没有这个权限，您将无法收到关键的 1 小时、15 分钟和 5 分钟倒计时警报。';

  @override
  String get notNow => '暂不';

  @override
  String get enableNotifications => '启用通知';

  @override
  String get shareLocationTitle => '与联系人共享您的位置';

  @override
  String get shareLocationBody =>
      '如果您不签到，SENTINEL 会将您最后已知的位置发送给您的紧急联系人，以便他们可以找到您。位置仅在您有活动事件时被跟踪。';

  @override
  String get enableLocation => '启用定位';

  @override
  String get allowBackgroundLocation => '允许后台定位';

  @override
  String get backgroundLocationBody =>
      '为了您的安全，请在下一个屏幕上允许“始终”访问位置。这确保即使在手机锁定时也会继续跟踪。';

  @override
  String get skip => '跳过';

  @override
  String get continueText => '继续';

  @override
  String get noEventCreated => '尚未创建任何事件';

  @override
  String get loadMore => '加载更多';

  @override
  String get cancel => '取消';

  @override
  String get loginTitle => '输入您的电子邮件以开始';

  @override
  String get emailHint => '电子邮件';

  @override
  String get emailRequired => '需要电子邮件';

  @override
  String get emailInvalid => '请输入有效的电子邮件';

  @override
  String get getStarted => '开始';

  @override
  String get checkEmail => '检查您的电子邮件';

  @override
  String codeSentTo(String email) {
    return '我们已将 6 位数代码发送至 $email';
  }

  @override
  String get verify => '验证';

  @override
  String get resendCode => '重新发送代码';

  @override
  String resendCodeIn(int seconds) {
    return '在 $seconds 秒后重新发送代码';
  }

  @override
  String get codeSent => '代码已发送';

  @override
  String get profile => '个人资料';

  @override
  String get memberSince => '会员自';

  @override
  String get editNameTitle => '编辑姓名';

  @override
  String get nameHint => '姓名';

  @override
  String get save => '保存';

  @override
  String get helpTitle => '帮助';

  @override
  String get helpQ1 => '什么是 SENTINEL？';

  @override
  String get helpA1 =>
      'SENTINEL 是您的个人安全伴侣。它允许您设置计时器，如果您在计时器到期前未签到，它会自动向您的紧急联系人发送包含您最后已知位置和自定义消息的警报。';

  @override
  String get helpQ2 => '如何创建新的 SENTINEL？';

  @override
  String get helpA2 =>
      '点击主屏幕上的“+”按钮。设置持续时间（例如 30 分钟），添加任何备注或文件，然后选择您的紧急联系人。点击“启动 SENTINEL”开始。';

  @override
  String get helpQ3 => '计时器到期时会发生什么？';

  @override
  String get helpA3 =>
      '当计时器归零时，SENTINEL 会立即通过短信/电子邮件通知您选择的所有紧急联系人。他们将收到您的自定义消息和在地图上查看您最后已知位置的链接。';

  @override
  String get helpQ4 => '什么是“签到”？';

  @override
  String get helpA4 => '签到会取消活动倒计时。一旦您安全或不再需要 SENTINEL，请执行此操作。如果您签到，将不会发送任何警报。';

  @override
  String get helpQ5 => '我可以延长活动计时器吗？';

  @override
  String get helpA5 => '可以！点击活动中的 SENTINEL，然后使用“延长”按钮在情况发生变化时添加更多时间。';

  @override
  String get helpQ6 => '谁是紧急联系人？';

  @override
  String get helpA6 =>
      '紧急联系人是您信任的人。您必须为每个 SENTINEL 事件至少选择一个联系人。您可以在从抽屉访问的“联系人”屏幕中管理您的联系人。';

  @override
  String get helpQ7 => 'SENTINEL 会跟踪我的位置吗？';

  @override
  String get helpA7 =>
      'SENTINEL 仅在计时器活动时跟踪您的位置。我们重视您的隐私，在应用闲置或没有 SENTINEL 运行时不会监控您的行动。';

  @override
  String get helpQ8 => '如果没有网络怎么办？';

  @override
  String get helpA8 =>
      'SENTINEL 需要互联网连接才能启动事件并上传数据。如果您在活动事件期间失去连接，除非您签到，否则我们服务器上的倒计时仍会触发警报。';

  @override
  String get helpQ9 => '我可以添加多少个联系人？';

  @override
  String get helpA9 => '每个 SENTINEL 事件最多可以添加 10 个紧急联系人。';

  @override
  String get helpQ10 => '我的数据安全吗？';

  @override
  String get helpA10 => '是的，您的个人数据和位置均已加密。只有您指定的紧急联系人才能在触发警报后查看到您的位置。';

  @override
  String get helpQ11 => '我可以添加照片或录音吗？';

  @override
  String get helpA11 =>
      '可以！创建 SENTINEL 时，您可以附加文件。如果触发警报，这些文件将与您的联系人共享，从而提供有关您情况的更多背景信息。';

  @override
  String get helpQ12 => '“我安全了”按钮是什么？';

  @override
  String get helpA12 => '这是您的签到按钮。点击它会告诉 SENTINEL 您很好，这会立即停止倒计时并防止发送任何警报。';

  @override
  String get helpQ13 => '应用需要一直打开吗？';

  @override
  String get helpA13 =>
      '不需要。SENTINEL 在我们的安全服务器上运行关键倒计时。即使您的手机没电、电量耗尽或损坏，计时器到期时仍会发送警报。';

  @override
  String get helpQ14 => '如何管理我的个人资料？';

  @override
  String get helpA14 => '您可以在应用抽屉访问的“个人资料”部分更新您的姓名并查看您的账户详情。';

  @override
  String get helpQ15 => '如果我不小心触发了警报怎么办？';

  @override
  String get helpA15 =>
      '如果发送了警报，您的联系人将收到通知。我们建议立即联系他们，让他们知道这是误报。务必尝试在计时器归零之前签到。';

  @override
  String get contactSupport => '联系支持';

  @override
  String get contactSupportText => '如果您有任何问题或建议，请联系我们：';

  @override
  String get loading => '正在加载...';

  @override
  String get home => '首页';

  @override
  String get contacts => '联系人';

  @override
  String get checkedIn => '已签到';

  @override
  String get created => '创建于';

  @override
  String get deleteEvent => '删除事件';

  @override
  String get deleteEventHistoryConfirm => '您确定要删除所有事件历史记录吗？';

  @override
  String get delete => '删除';

  @override
  String get failedToLoadEvents => '加载事件失败';

  @override
  String get failedToLoadEventDetails => '加载事件详情失败';

  @override
  String get messageTitle => '消息';

  @override
  String get attachments => '附件';

  @override
  String get newSentinel => '新 SENTINEL';

  @override
  String get eventName => '事件名称';

  @override
  String get timer => '计时器';

  @override
  String get enterMessage => '输入计时器到期时要发送的消息...';

  @override
  String get addFile => '添加文件';

  @override
  String get uploading => '正在上传...';

  @override
  String get initiateSentinel => '启动 SENTINEL';

  @override
  String get addContact => '添加联系人';

  @override
  String get selectContacts => '选择联系人';

  @override
  String get savedContacts => '保存的联系人';

  @override
  String contactsSelected(int count) {
    return '已选择联系人: $count';
  }

  @override
  String get searchContacts => '搜索联系人...';

  @override
  String get orEnterManually => '或手动输入';

  @override
  String get enterContactManually => '手动输入联系人';

  @override
  String get emailExample => 'email@example.com';

  @override
  String get contactNameOptional => '联系人姓名（可选）';

  @override
  String get selectAtLeastOneContact => '请至少选择一个联系人';

  @override
  String get maxContactsAllowed => '最多允许 10 个联系人';

  @override
  String get duration => '持续时间';

  @override
  String get date => '日期';

  @override
  String get noRecipients => '无收件人';

  @override
  String get safe => '安全';

  @override
  String get active => '活动';

  @override
  String failedToOpenFile(String message) {
    return '打开文件失败: $message';
  }

  @override
  String get failedToDownloadFile => '下载文件失败';

  @override
  String get failedToDeleteAccount => '删除账户失败';

  @override
  String get language => '语言';

  @override
  String get noEventCreatedYet => '尚未创建任何事件';

  @override
  String get somethingWentWrong => '出错了！';

  @override
  String get retry => '重试';

  @override
  String get english => '英语';

  @override
  String get french => '法语';

  @override
  String get spanish => '西班牙语';

  @override
  String get arabic => '阿拉伯语';

  @override
  String get chinese => '中文';

  @override
  String get unknown => '未知';

  @override
  String get none => '无';

  @override
  String get days => '天';

  @override
  String get notifTitle => 'SENTINEL';

  @override
  String get notifAlertTitle => 'SENTINEL 警报';

  @override
  String notifHourBody(Object eventName) {
    return '您的 SENTINEL \'$eventName\' 将在 1 小时后过期';
  }

  @override
  String notifFifteenMinBody(Object eventName) {
    return '您的 SENTINEL \'$eventName\' 将在 15 分钟后过期';
  }

  @override
  String notifFiveMinBody(Object eventName) {
    return '您的 SENTINEL \'$eventName\' 将在 5 分钟后过期。请现在签到。';
  }

  @override
  String notifFiredBody(Object eventName) {
    return 'SENTINEL \'$eventName\' 已触发。您的紧急联系人已收到通知。';
  }

  @override
  String get notifCountdownBody => '计时器归零时将触发紧急警报。点击签到。';

  @override
  String get notifTrackingTitle => '位置追踪';

  @override
  String get notifTrackingBody => 'SENTINEL 正在追踪您的位置';

  @override
  String get notifTrackingDesc => '显示 SENTINEL 何时正在追踪您的位置';

  @override
  String get notifCountdownChannelName => 'SENTINEL 倒计时';

  @override
  String get notifCountdownChannelDesc => '显示活动倒计时器';

  @override
  String get sentinelBrand => 'SENTINEL';

  @override
  String get contactNameHint => '联系人姓名';

  @override
  String get noSavedContacts => '没有保存的联系人';

  @override
  String get deleteContactTitle => '删除联系人';

  @override
  String get deleteContactConfirm => '将从您保存的联系人中移除。';

  @override
  String get failedToLoadContacts => '加载联系人失败';

  @override
  String get contactEmailLabel => '电子邮件';

  @override
  String get contactNameLabel => '姓名（可选）';

  @override
  String get contactAlreadyExists => '具有此电子邮件的联系人已存在';

  @override
  String get unableToLoadProfile => '无法加载个人资料';

  @override
  String get setYourName => '设置您的姓名';

  @override
  String get nameVisibleToContacts => '这是您的联系人在警报电子邮件中看到的姓名';

  @override
  String get failedToLoadProfile => '加载个人资料失败';

  @override
  String get nameRequired => '姓名为必填项';
}
