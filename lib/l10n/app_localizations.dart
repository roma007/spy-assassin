import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ko.dart';
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
    Locale('en'),
    Locale('ko'),
    Locale('zh'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In zh, this message translates to:
  /// **'隐私相机'**
  String get appTitle;

  /// No description provided for @privacyPromiseBanner.
  ///
  /// In zh, this message translates to:
  /// **'无账号 · 无广告 · 无云上传 · 数据不落盘，全程本地检测'**
  String get privacyPromiseBanner;

  /// No description provided for @proTitle.
  ///
  /// In zh, this message translates to:
  /// **'Pro 版'**
  String get proTitle;

  /// No description provided for @proSubtitle.
  ///
  /// In zh, this message translates to:
  /// **'无限次检测 + 导出 PDF 报告'**
  String get proSubtitle;

  /// No description provided for @proUnlock.
  ///
  /// In zh, this message translates to:
  /// **'立即解锁'**
  String get proUnlock;

  /// No description provided for @proUnlocked.
  ///
  /// In zh, this message translates to:
  /// **'Pro 已激活'**
  String get proUnlocked;

  /// No description provided for @proLimitTitle.
  ///
  /// In zh, this message translates to:
  /// **'已达每日免费次数上限'**
  String get proLimitTitle;

  /// No description provided for @proUpgradePrompt.
  ///
  /// In zh, this message translates to:
  /// **'升级 Pro 后可无限次使用全部检测工具，并解锁 PDF 报告导出。'**
  String get proUpgradePrompt;

  /// No description provided for @proLater.
  ///
  /// In zh, this message translates to:
  /// **'暂不升级'**
  String get proLater;

  /// No description provided for @proLimitLeft.
  ///
  /// In zh, this message translates to:
  /// **'今日剩余免费检测 {count} 次'**
  String proLimitLeft(Object count);

  /// No description provided for @navTabCheck.
  ///
  /// In zh, this message translates to:
  /// **'检查'**
  String get navTabCheck;

  /// No description provided for @navTabIr.
  ///
  /// In zh, this message translates to:
  /// **'红外'**
  String get navTabIr;

  /// No description provided for @navTabWifi.
  ///
  /// In zh, this message translates to:
  /// **'WiFi'**
  String get navTabWifi;

  /// No description provided for @navTabMagnet.
  ///
  /// In zh, this message translates to:
  /// **'磁力'**
  String get navTabMagnet;

  /// No description provided for @navTabMore.
  ///
  /// In zh, this message translates to:
  /// **'更多'**
  String get navTabMore;

  /// No description provided for @tabTitleCheck.
  ///
  /// In zh, this message translates to:
  /// **'房间检查'**
  String get tabTitleCheck;

  /// No description provided for @tabTitleIr.
  ///
  /// In zh, this message translates to:
  /// **'红外检测'**
  String get tabTitleIr;

  /// No description provided for @tabTitleWifi.
  ///
  /// In zh, this message translates to:
  /// **'WiFi 扫描'**
  String get tabTitleWifi;

  /// No description provided for @tabTitleMagnet.
  ///
  /// In zh, this message translates to:
  /// **'磁力检测'**
  String get tabTitleMagnet;

  /// No description provided for @tabTitleMore.
  ///
  /// In zh, this message translates to:
  /// **'更多'**
  String get tabTitleMore;

  /// No description provided for @checkVisualTitle.
  ///
  /// In zh, this message translates to:
  /// **'视觉排查'**
  String get checkVisualTitle;

  /// No description provided for @checkVisualDesc.
  ///
  /// In zh, this message translates to:
  /// **'检查镜面、烟雾报警器、插座孔、装饰画、空调出风口、电子钟等常见隐藏点'**
  String get checkVisualDesc;

  /// No description provided for @checkStep1Min.
  ///
  /// In zh, this message translates to:
  /// **'约 1 分钟'**
  String get checkStep1Min;

  /// No description provided for @checkStep1_5Min.
  ///
  /// In zh, this message translates to:
  /// **'约 1.5 分钟'**
  String get checkStep1_5Min;

  /// No description provided for @checkIrTitle.
  ///
  /// In zh, this message translates to:
  /// **'红外扫描'**
  String get checkIrTitle;

  /// No description provided for @checkIrDesc.
  ///
  /// In zh, this message translates to:
  /// **'关闭灯光后进入「红外检测」，缓慢扫描房间每个角落'**
  String get checkIrDesc;

  /// No description provided for @checkNetTitle.
  ///
  /// In zh, this message translates to:
  /// **'网络扫描'**
  String get checkNetTitle;

  /// No description provided for @checkNetDesc.
  ///
  /// In zh, this message translates to:
  /// **'连接房间 WiFi，进入「WiFi 扫描」查看是否有可疑联网设备'**
  String get checkNetDesc;

  /// No description provided for @checkMagnetTitle.
  ///
  /// In zh, this message translates to:
  /// **'磁力排查'**
  String get checkMagnetTitle;

  /// No description provided for @checkMagnetDesc.
  ///
  /// In zh, this message translates to:
  /// **'用「磁力检测」贴近可疑的充电器、时钟、烟雾报警器等物体'**
  String get checkMagnetDesc;

  /// No description provided for @checkDone.
  ///
  /// In zh, this message translates to:
  /// **'检查完成，已获得安心。'**
  String get checkDone;

  /// No description provided for @checkInProgress.
  ///
  /// In zh, this message translates to:
  /// **'按顺序完成 4 步检查，全程约 4 分钟'**
  String get checkInProgress;

  /// No description provided for @checkSuspiciousFound.
  ///
  /// In zh, this message translates to:
  /// **'发现 {count} 处可疑信号，建议查看下一步行动'**
  String checkSuspiciousFound(Object count);

  /// No description provided for @checkNextActions.
  ///
  /// In zh, this message translates to:
  /// **'查看下一步行动'**
  String get checkNextActions;

  /// No description provided for @checkStepN.
  ///
  /// In zh, this message translates to:
  /// **'第 {n} 步'**
  String checkStepN(Object n);

  /// No description provided for @checkHideoutList.
  ///
  /// In zh, this message translates to:
  /// **'查看藏匿点清单'**
  String get checkHideoutList;

  /// No description provided for @checkSkip.
  ///
  /// In zh, this message translates to:
  /// **'跳过'**
  String get checkSkip;

  /// No description provided for @checkMarkedSuspicious.
  ///
  /// In zh, this message translates to:
  /// **'已标记可疑'**
  String get checkMarkedSuspicious;

  /// No description provided for @checkMarkSuspicious.
  ///
  /// In zh, this message translates to:
  /// **'标记可疑'**
  String get checkMarkSuspicious;

  /// No description provided for @checkAllFourDone.
  ///
  /// In zh, this message translates to:
  /// **'4 步检查全部完成'**
  String get checkAllFourDone;

  /// No description provided for @checkAllDoneTip.
  ///
  /// In zh, this message translates to:
  /// **'若任一环节发现可疑信号，请拍照留存证据，并联系前台/房东或报警处理。'**
  String get checkAllDoneTip;

  /// No description provided for @nextActionsTitle.
  ///
  /// In zh, this message translates to:
  /// **'发现摄像头怎么办'**
  String get nextActionsTitle;

  /// No description provided for @nextActionsTip.
  ///
  /// In zh, this message translates to:
  /// **'先冷静、先取证、不拆机。人身安全优先，必要时立刻离开房间。'**
  String get nextActionsTip;

  /// No description provided for @nextAction1Title.
  ///
  /// In zh, this message translates to:
  /// **'1. 拍照取证（先做）'**
  String get nextAction1Title;

  /// No description provided for @nextAction1Desc.
  ///
  /// In zh, this message translates to:
  /// **'用另一台手机对可疑设备多角度拍照，拍下安装位置与房间全貌；不要触碰、拆卸或破坏设备，保持现场原样，这是报警和处理的关键证据。'**
  String get nextAction1Desc;

  /// No description provided for @nextAction2Title.
  ///
  /// In zh, this message translates to:
  /// **'2. 告知场所负责人'**
  String get nextAction2Title;

  /// No description provided for @nextAction2Desc.
  ///
  /// In zh, this message translates to:
  /// **'酒店/民宿：立刻告知前台或房东，要求换房或到场处理，并索要书面记录；被偷拍是场所的违约甚至违法责任，别在没人见证的情况下私下沟通。'**
  String get nextAction2Desc;

  /// No description provided for @nextAction3Title.
  ///
  /// In zh, this message translates to:
  /// **'3. 报警'**
  String get nextAction3Title;

  /// No description provided for @nextAction3Desc.
  ///
  /// In zh, this message translates to:
  /// **'拨打 110（中国）/ 当地报警电话，说明\"疑似被偷拍\"，警察会到场取证；警方可对设备进行司法鉴定，个人不要自行拆除或销毁可疑设备。'**
  String get nextAction3Desc;

  /// No description provided for @nextActionsRightsTip.
  ///
  /// In zh, this message translates to:
  /// **'维权提示：在中国，《个人信息保护法》与各地\"反偷拍\"立法明确禁止在酒店等隐私场所安装摄像头，你可以要求场所赔偿，并可向 12315 或当地消协投诉。'**
  String get nextActionsRightsTip;

  /// No description provided for @permissionDenial.
  ///
  /// In zh, this message translates to:
  /// **'需要 {feature} 权限才能使用此功能，请在设置中开启。'**
  String permissionDenial(Object feature);

  /// No description provided for @permissionCameraName.
  ///
  /// In zh, this message translates to:
  /// **'相机'**
  String get permissionCameraName;

  /// No description provided for @goToSettings.
  ///
  /// In zh, this message translates to:
  /// **'去设置开启'**
  String get goToSettings;

  /// No description provided for @irNoCamera.
  ///
  /// In zh, this message translates to:
  /// **'未检测到相机'**
  String get irNoCamera;

  /// No description provided for @irInitFailed.
  ///
  /// In zh, this message translates to:
  /// **'相机初始化失败：{error}'**
  String irInitFailed(Object error);

  /// No description provided for @irSustainedSummary.
  ///
  /// In zh, this message translates to:
  /// **'持续发现疑似红外光源（红外补光特征明显）'**
  String get irSustainedSummary;

  /// No description provided for @irOccasionalSummary.
  ///
  /// In zh, this message translates to:
  /// **'检测到偶发红外光点（可能是遥控器/反光）'**
  String get irOccasionalSummary;

  /// No description provided for @irGuidance.
  ///
  /// In zh, this message translates to:
  /// **'关闭灯光、拉上窗帘。缓慢扫描烟雾报警器、插座、镜子等位置。'**
  String get irGuidance;

  /// No description provided for @torchOn.
  ///
  /// In zh, this message translates to:
  /// **'手电已开'**
  String get torchOn;

  /// No description provided for @torchOff.
  ///
  /// In zh, this message translates to:
  /// **'打开手电'**
  String get torchOff;

  /// No description provided for @irFlipTooltip.
  ///
  /// In zh, this message translates to:
  /// **'切换摄像头（前摄对红外更敏感）'**
  String get irFlipTooltip;

  /// No description provided for @irResTooltip.
  ///
  /// In zh, this message translates to:
  /// **'画面分辨率（降低可提升帧率）'**
  String get irResTooltip;

  /// No description provided for @irResLow.
  ///
  /// In zh, this message translates to:
  /// **'流畅（480p，最高帧率）'**
  String get irResLow;

  /// No description provided for @irResMedium.
  ///
  /// In zh, this message translates to:
  /// **'标准（720p，推荐）'**
  String get irResMedium;

  /// No description provided for @irResHigh.
  ///
  /// In zh, this message translates to:
  /// **'高清（1080p，帧率较低）'**
  String get irResHigh;

  /// No description provided for @irPermTitle.
  ///
  /// In zh, this message translates to:
  /// **'需要相机权限'**
  String get irPermTitle;

  /// No description provided for @irErrorTitle.
  ///
  /// In zh, this message translates to:
  /// **'无法使用红外检测'**
  String get irErrorTitle;

  /// No description provided for @irAlarmBanner.
  ///
  /// In zh, this message translates to:
  /// **'持续发现疑似红外光源，请缓慢移动并从多角度确认'**
  String get irAlarmBanner;

  /// No description provided for @irAlertBanner.
  ///
  /// In zh, this message translates to:
  /// **'检测到偶发光点，可能是电视遥控器（仅在按键瞬间发红外）或反光，连续亮点才可疑'**
  String get irAlertBanner;

  /// No description provided for @stabilityChip.
  ///
  /// In zh, this message translates to:
  /// **'设备在移动，请保持稳定'**
  String get stabilityChip;

  /// No description provided for @startingCamera.
  ///
  /// In zh, this message translates to:
  /// **'正在启动相机…'**
  String get startingCamera;

  /// No description provided for @lensInitFailed.
  ///
  /// In zh, this message translates to:
  /// **'相机初始化失败：{error}'**
  String lensInitFailed(Object error);

  /// No description provided for @lensConfirmedSummary.
  ///
  /// In zh, this message translates to:
  /// **'发现疑似镜头反光光斑，请变换角度确认'**
  String get lensConfirmedSummary;

  /// No description provided for @lensGuidance.
  ///
  /// In zh, this message translates to:
  /// **'保持手电常亮、手机与光源同轴，缓慢横移扫描墙面与物体'**
  String get lensGuidance;

  /// No description provided for @lensFlipTooltip.
  ///
  /// In zh, this message translates to:
  /// **'切换摄像头'**
  String get lensFlipTooltip;

  /// No description provided for @lensPermTitle.
  ///
  /// In zh, this message translates to:
  /// **'需要相机权限'**
  String get lensPermTitle;

  /// No description provided for @lensErrorTitle.
  ///
  /// In zh, this message translates to:
  /// **'无法使用反光扫描'**
  String get lensErrorTitle;

  /// No description provided for @lensConfirmBanner.
  ///
  /// In zh, this message translates to:
  /// **'疑似镜头反光，请变换角度确认'**
  String get lensConfirmBanner;

  /// No description provided for @lensHintBanner.
  ///
  /// In zh, this message translates to:
  /// **'检测到高亮圆斑，持续扫描确认是否反光（玻璃/金属会误报）'**
  String get lensHintBanner;

  /// No description provided for @retry.
  ///
  /// In zh, this message translates to:
  /// **'重试'**
  String get retry;

  /// No description provided for @wifiNeedInfo.
  ///
  /// In zh, this message translates to:
  /// **'未能获取当前 WiFi 信息，请确认已连接 WiFi'**
  String get wifiNeedInfo;

  /// No description provided for @wifiHighCount.
  ///
  /// In zh, this message translates to:
  /// **'高风险设备 {count} 台'**
  String wifiHighCount(Object count);

  /// No description provided for @wifiMediumCount.
  ///
  /// In zh, this message translates to:
  /// **'可疑设备 {count} 台'**
  String wifiMediumCount(Object count);

  /// No description provided for @wifiNoOpenDevices.
  ///
  /// In zh, this message translates to:
  /// **'未发现开放探测端口的设备'**
  String get wifiNoOpenDevices;

  /// No description provided for @wifiSummary.
  ///
  /// In zh, this message translates to:
  /// **'WiFi {ssid}，共发现设备 {count} 台。{detail}'**
  String wifiSummary(Object count, Object detail, Object ssid);

  /// No description provided for @wifiUnknown.
  ///
  /// In zh, this message translates to:
  /// **'未知'**
  String get wifiUnknown;

  /// No description provided for @wifiVerdictGw.
  ///
  /// In zh, this message translates to:
  /// **'未发现开放探测端口的设备（网关 {gw} 连通正常）。请确认：摄像头与本机在同一 WiFi、未开 AP 隔离；部分品牌摄像头默认仅云端，需在官方 App 开启本地访问。'**
  String wifiVerdictGw(Object gw);

  /// No description provided for @wifiVerdictInternet.
  ///
  /// In zh, this message translates to:
  /// **'能访问公网(1.1.1.1:80)，但无法访问局域网——说明手机与局域网设备被隔离或屏蔽。最常见原因：① 手机开着 VPN/代理（会屏蔽局域网，请关闭）；② 手机连的是路由器的「访客网络」或开启了「设备隔离/AP 隔离」；③ iOS 本地网络权限仍未生效（设置 > 隐私与安全性 > 本地网络，确认「隐私相机」开关为绿色；不行就重启手机后重试）。'**
  String get wifiVerdictInternet;

  /// No description provided for @wifiVerdictNone.
  ///
  /// In zh, this message translates to:
  /// **'公网与局域网均不可达——请检查是否开了飞行模式、VPN 全局模式，或确认 WiFi 是否真的可上网。'**
  String get wifiVerdictNone;

  /// No description provided for @wifiDisclaimer.
  ///
  /// In zh, this message translates to:
  /// **'说明：仅检测当前 WiFi 下的联网设备，离线或本地存储的摄像头无法被发现；结果仅供参考，非执法证据。长按设备可快速标记为\"我的设备\"。'**
  String get wifiDisclaimer;

  /// No description provided for @wifiNotConnected.
  ///
  /// In zh, this message translates to:
  /// **'未连接 WiFi'**
  String get wifiNotConnected;

  /// No description provided for @wifiGettingInfo.
  ///
  /// In zh, this message translates to:
  /// **'正在获取网络信息…'**
  String get wifiGettingInfo;

  /// No description provided for @wifiGatewayMask.
  ///
  /// In zh, this message translates to:
  /// **'网关 {gateway} · 掩码 {mask}'**
  String wifiGatewayMask(Object gateway, Object mask);

  /// No description provided for @wifiScanning.
  ///
  /// In zh, this message translates to:
  /// **'正在扫描网段…'**
  String get wifiScanning;

  /// No description provided for @wifiStartScan.
  ///
  /// In zh, this message translates to:
  /// **'开始扫描局域网设备'**
  String get wifiStartScan;

  /// No description provided for @wifiResults.
  ///
  /// In zh, this message translates to:
  /// **'扫描结果'**
  String get wifiResults;

  /// No description provided for @wifiRiskCounts.
  ///
  /// In zh, this message translates to:
  /// **'高风险 {high} · 可疑 {medium}'**
  String wifiRiskCounts(Object high, Object medium);

  /// No description provided for @wifiMyDevices.
  ///
  /// In zh, this message translates to:
  /// **'我的设备（已标记）'**
  String get wifiMyDevices;

  /// No description provided for @wifiPermTitle.
  ///
  /// In zh, this message translates to:
  /// **'需要定位权限'**
  String get wifiPermTitle;

  /// No description provided for @wifiPermDesc.
  ///
  /// In zh, this message translates to:
  /// **'Android 系统要求定位权限才能读取 WiFi 信息。扫描结果仅在本地处理。'**
  String get wifiPermDesc;

  /// No description provided for @wifiDetailReason.
  ///
  /// In zh, this message translates to:
  /// **'风险判定：{reason}'**
  String wifiDetailReason(Object reason);

  /// No description provided for @wifiDetailIp.
  ///
  /// In zh, this message translates to:
  /// **'IP 地址'**
  String get wifiDetailIp;

  /// No description provided for @wifiDetailMac.
  ///
  /// In zh, this message translates to:
  /// **'MAC 地址'**
  String get wifiDetailMac;

  /// No description provided for @wifiDetailVendor.
  ///
  /// In zh, this message translates to:
  /// **'厂商匹配'**
  String get wifiDetailVendor;

  /// No description provided for @wifiDetailPorts.
  ///
  /// In zh, this message translates to:
  /// **'开放端口'**
  String get wifiDetailPorts;

  /// No description provided for @wifiNone.
  ///
  /// In zh, this message translates to:
  /// **'无'**
  String get wifiNone;

  /// No description provided for @wifiPortUnknown.
  ///
  /// In zh, this message translates to:
  /// **'未知'**
  String get wifiPortUnknown;

  /// No description provided for @wifiDetailUpnp.
  ///
  /// In zh, this message translates to:
  /// **'UPnP 发现'**
  String get wifiDetailUpnp;

  /// No description provided for @wifiMarkedCancel.
  ///
  /// In zh, this message translates to:
  /// **'我的设备（点击取消标记）'**
  String get wifiMarkedCancel;

  /// No description provided for @wifiMarkAsMine.
  ///
  /// In zh, this message translates to:
  /// **'标记为我的设备'**
  String get wifiMarkAsMine;

  /// No description provided for @wifiMyDeviceChip.
  ///
  /// In zh, this message translates to:
  /// **'我的设备'**
  String get wifiMyDeviceChip;

  /// No description provided for @wifiPorts.
  ///
  /// In zh, this message translates to:
  /// **'端口 {text}'**
  String wifiPorts(Object text);

  /// No description provided for @wifiNoOpenPort.
  ///
  /// In zh, this message translates to:
  /// **'未探到开放端口'**
  String get wifiNoOpenPort;

  /// No description provided for @bleUnnamed.
  ///
  /// In zh, this message translates to:
  /// **'未命名设备'**
  String get bleUnnamed;

  /// No description provided for @bleSummary.
  ///
  /// In zh, this message translates to:
  /// **'周边蓝牙设备共 {count} 个。高风险 {high}、可疑 {medium}。{names}'**
  String bleSummary(Object count, Object high, Object medium, Object names);

  /// No description provided for @bleDisclaimer.
  ///
  /// In zh, this message translates to:
  /// **'说明：蓝牙摄像头使用率低，本工具仅作辅助线索。名称含摄像头/录音关键词或未命名设备值得留意；已连接的耳机、手环、音箱等均为正常设备。'**
  String get bleDisclaimer;

  /// No description provided for @bleOn.
  ///
  /// In zh, this message translates to:
  /// **'蓝牙已开启'**
  String get bleOn;

  /// No description provided for @bleTurningOn.
  ///
  /// In zh, this message translates to:
  /// **'正在开启…'**
  String get bleTurningOn;

  /// No description provided for @bleOff.
  ///
  /// In zh, this message translates to:
  /// **'蓝牙未开启'**
  String get bleOff;

  /// No description provided for @bleOnDesc.
  ///
  /// In zh, this message translates to:
  /// **'可以开始扫描周边设备'**
  String get bleOnDesc;

  /// No description provided for @bleOffDesc.
  ///
  /// In zh, this message translates to:
  /// **'需要开启蓝牙才能扫描'**
  String get bleOffDesc;

  /// No description provided for @bleTurnOn.
  ///
  /// In zh, this message translates to:
  /// **'开启'**
  String get bleTurnOn;

  /// No description provided for @bleScanning.
  ///
  /// In zh, this message translates to:
  /// **'正在扫描（约 5 秒）…'**
  String get bleScanning;

  /// No description provided for @bleStartScan.
  ///
  /// In zh, this message translates to:
  /// **'开始扫描周边蓝牙设备'**
  String get bleStartScan;

  /// No description provided for @bleRiskHigh.
  ///
  /// In zh, this message translates to:
  /// **'高风险'**
  String get bleRiskHigh;

  /// No description provided for @bleRiskMedium.
  ///
  /// In zh, this message translates to:
  /// **'可疑'**
  String get bleRiskMedium;

  /// No description provided for @bleRiskLow.
  ///
  /// In zh, this message translates to:
  /// **'低风险'**
  String get bleRiskLow;

  /// No description provided for @magnetSummary.
  ///
  /// In zh, this message translates to:
  /// **'相对环境磁场增量 {delta} µT，超过阈值 {threshold} µT'**
  String magnetSummary(Object delta, Object threshold);

  /// No description provided for @magnetUsageTitle.
  ///
  /// In zh, this message translates to:
  /// **'使用提示'**
  String get magnetUsageTitle;

  /// No description provided for @magnetTip1.
  ///
  /// In zh, this message translates to:
  /// **'• 将手机贴近可疑物体 3~10cm 缓慢移动'**
  String get magnetTip1;

  /// No description provided for @magnetTip2.
  ///
  /// In zh, this message translates to:
  /// **'• 磁力传感器位置：iPhone 在机身右上角附近，多数 Android 在顶部中段'**
  String get magnetTip2;

  /// No description provided for @magnetTip3.
  ///
  /// In zh, this message translates to:
  /// **'• 超过阈值线并持续 1 秒以上，才值得进一步确认'**
  String get magnetTip3;

  /// No description provided for @magnetTip4.
  ///
  /// In zh, this message translates to:
  /// **'• 电子设备密集区域（插座墙、路由器旁）误报较多'**
  String get magnetTip4;

  /// No description provided for @magnetCalibrating.
  ///
  /// In zh, this message translates to:
  /// **'正在校准环境磁场（请保持手机静止）…'**
  String get magnetCalibrating;

  /// No description provided for @magnetCalibrated.
  ///
  /// In zh, this message translates to:
  /// **'已校准，可以开始贴近可疑物体扫描'**
  String get magnetCalibrated;

  /// No description provided for @magnetRecalibrate.
  ///
  /// In zh, this message translates to:
  /// **'重新校准'**
  String get magnetRecalibrate;

  /// No description provided for @magnetAlarm.
  ///
  /// In zh, this message translates to:
  /// **'检测到磁场异常，请确认！'**
  String get magnetAlarm;

  /// No description provided for @magnetDelta.
  ///
  /// In zh, this message translates to:
  /// **'相对环境磁场增量'**
  String get magnetDelta;

  /// No description provided for @magnetThresholdValue.
  ///
  /// In zh, this message translates to:
  /// **'阈值 {value} µT'**
  String magnetThresholdValue(Object value);

  /// No description provided for @magnetThresholdTitle.
  ///
  /// In zh, this message translates to:
  /// **'报警阈值'**
  String get magnetThresholdTitle;

  /// No description provided for @magnetThresholdHint.
  ///
  /// In zh, this message translates to:
  /// **'调高可减少误报（更灵敏的场景调低）'**
  String get magnetThresholdHint;

  /// No description provided for @magnetChart.
  ///
  /// In zh, this message translates to:
  /// **'实时曲线'**
  String get magnetChart;

  /// No description provided for @moreTools.
  ///
  /// In zh, this message translates to:
  /// **'检测工具'**
  String get moreTools;

  /// No description provided for @moreLensTitle.
  ///
  /// In zh, this message translates to:
  /// **'镜头反光扫描'**
  String get moreLensTitle;

  /// No description provided for @moreLensSubtitle.
  ///
  /// In zh, this message translates to:
  /// **'手电同轴光查找镜头回反射光斑'**
  String get moreLensSubtitle;

  /// No description provided for @moreBleTitle.
  ///
  /// In zh, this message translates to:
  /// **'蓝牙扫描'**
  String get moreBleTitle;

  /// No description provided for @moreBleSubtitle.
  ///
  /// In zh, this message translates to:
  /// **'辅助排查周边蓝牙设备'**
  String get moreBleSubtitle;

  /// No description provided for @moreReportTitle.
  ///
  /// In zh, this message translates to:
  /// **'检测报告'**
  String get moreReportTitle;

  /// No description provided for @moreReportSubtitle.
  ///
  /// In zh, this message translates to:
  /// **'汇总检测结论，导出 PDF 存档'**
  String get moreReportSubtitle;

  /// No description provided for @moreGuide.
  ///
  /// In zh, this message translates to:
  /// **'排查指南'**
  String get moreGuide;

  /// No description provided for @moreGuideSubtitle.
  ///
  /// In zh, this message translates to:
  /// **'常见隐藏位置与反偷拍技巧'**
  String get moreGuideSubtitle;

  /// No description provided for @morePrivacy.
  ///
  /// In zh, this message translates to:
  /// **'隐私政策'**
  String get morePrivacy;

  /// No description provided for @morePrivacySubtitle.
  ///
  /// In zh, this message translates to:
  /// **'无账号 · 无广告 · 无云上传 · 数据不落盘'**
  String get morePrivacySubtitle;

  /// No description provided for @moreAbout.
  ///
  /// In zh, this message translates to:
  /// **'关于'**
  String get moreAbout;

  /// No description provided for @moreAboutSubtitle.
  ///
  /// In zh, this message translates to:
  /// **'版本 1.0.0'**
  String get moreAboutSubtitle;

  /// No description provided for @moreSettings.
  ///
  /// In zh, this message translates to:
  /// **'设置'**
  String get moreSettings;

  /// No description provided for @moreSettingsSubtitle.
  ///
  /// In zh, this message translates to:
  /// **'语言 · 本地统计 · 数据'**
  String get moreSettingsSubtitle;

  /// No description provided for @settingsTitle.
  ///
  /// In zh, this message translates to:
  /// **'设置'**
  String get settingsTitle;

  /// No description provided for @settingsLanguage.
  ///
  /// In zh, this message translates to:
  /// **'语言'**
  String get settingsLanguage;

  /// No description provided for @settingsLanguageSystem.
  ///
  /// In zh, this message translates to:
  /// **'跟随系统'**
  String get settingsLanguageSystem;

  /// No description provided for @settingsLanguageZh.
  ///
  /// In zh, this message translates to:
  /// **'简体中文'**
  String get settingsLanguageZh;

  /// No description provided for @settingsLanguageEn.
  ///
  /// In zh, this message translates to:
  /// **'English'**
  String get settingsLanguageEn;

  /// No description provided for @settingsLanguageKo.
  ///
  /// In zh, this message translates to:
  /// **'한국어'**
  String get settingsLanguageKo;

  /// No description provided for @settingsStatsTitle.
  ///
  /// In zh, this message translates to:
  /// **'本地统计'**
  String get settingsStatsTitle;

  /// No description provided for @statsCheckStarted.
  ///
  /// In zh, this message translates to:
  /// **'开始检查次数'**
  String get statsCheckStarted;

  /// No description provided for @statsCheckDone.
  ///
  /// In zh, this message translates to:
  /// **'完成检查次数'**
  String get statsCheckDone;

  /// No description provided for @statsCompletionRate.
  ///
  /// In zh, this message translates to:
  /// **'完成率'**
  String get statsCompletionRate;

  /// No description provided for @statsAvgDuration.
  ///
  /// In zh, this message translates to:
  /// **'平均时长'**
  String get statsAvgDuration;

  /// No description provided for @statsTools.
  ///
  /// In zh, this message translates to:
  /// **'各工具使用次数'**
  String get statsTools;

  /// No description provided for @statsEmpty.
  ///
  /// In zh, this message translates to:
  /// **'暂无数据：完成一次房间检查或使用任一检测工具后，这里会记录（仅本机）。'**
  String get statsEmpty;

  /// No description provided for @statsDurationFormat.
  ///
  /// In zh, this message translates to:
  /// **'{m}分 {s}秒'**
  String statsDurationFormat(Object m, Object s);

  /// No description provided for @settingsDataTitle.
  ///
  /// In zh, this message translates to:
  /// **'数据'**
  String get settingsDataTitle;

  /// No description provided for @settingsClearStats.
  ///
  /// In zh, this message translates to:
  /// **'清除本地统计'**
  String get settingsClearStats;

  /// No description provided for @settingsClearReport.
  ///
  /// In zh, this message translates to:
  /// **'清空检测记录'**
  String get settingsClearReport;

  /// No description provided for @settingsClearConfirm.
  ///
  /// In zh, this message translates to:
  /// **'该操作不可撤销，确定继续？'**
  String get settingsClearConfirm;

  /// No description provided for @settingsClearDone.
  ///
  /// In zh, this message translates to:
  /// **'清除'**
  String get settingsClearDone;

  /// No description provided for @settingsCancel.
  ///
  /// In zh, this message translates to:
  /// **'取消'**
  String get settingsCancel;

  /// No description provided for @settingsDataNote.
  ///
  /// In zh, this message translates to:
  /// **'所有统计数据仅保存在本机，用于查看自己的使用情况，不会上传。检测报告与照片仅存于内存，重启应用后自动清空。'**
  String get settingsDataNote;

  /// No description provided for @morePrivacyDesign.
  ///
  /// In zh, this message translates to:
  /// **'隐私优先设计'**
  String get morePrivacyDesign;

  /// No description provided for @morePrivacyDesc.
  ///
  /// In zh, this message translates to:
  /// **'所有检测均在本机完成，无需账号，不收集、不上传任何图像或网络数据。'**
  String get morePrivacyDesc;

  /// No description provided for @reportTitle.
  ///
  /// In zh, this message translates to:
  /// **'检测报告'**
  String get reportTitle;

  /// No description provided for @reportEmptyError.
  ///
  /// In zh, this message translates to:
  /// **'暂无检测记录，请先完成至少一项检测'**
  String get reportEmptyError;

  /// No description provided for @reportShareCancelled.
  ///
  /// In zh, this message translates to:
  /// **'分享已取消'**
  String get reportShareCancelled;

  /// No description provided for @reportExportFailed.
  ///
  /// In zh, this message translates to:
  /// **'导出失败：{error}'**
  String reportExportFailed(Object error);

  /// No description provided for @reportPlaceLabel.
  ///
  /// In zh, this message translates to:
  /// **'检查地点（可选，如酒店名/房号）'**
  String get reportPlaceLabel;

  /// No description provided for @reportPlaceHint.
  ///
  /// In zh, this message translates to:
  /// **'仅用于报告展示，不涉及定位'**
  String get reportPlaceHint;

  /// No description provided for @reportPhotos.
  ///
  /// In zh, this message translates to:
  /// **'现场照片'**
  String get reportPhotos;

  /// No description provided for @reportPhotosEmpty.
  ///
  /// In zh, this message translates to:
  /// **'尚未添加照片。发现可疑设备或位置时可拍照存档，导出报告会一并包含。'**
  String get reportPhotosEmpty;

  /// No description provided for @reportAddPhoto.
  ///
  /// In zh, this message translates to:
  /// **'添加照片'**
  String get reportAddPhoto;

  /// No description provided for @reportAddPhotoCamera.
  ///
  /// In zh, this message translates to:
  /// **'拍照'**
  String get reportAddPhotoCamera;

  /// No description provided for @reportAddPhotoGallery.
  ///
  /// In zh, this message translates to:
  /// **'从相册选择'**
  String get reportAddPhotoGallery;

  /// No description provided for @reportPhotoFailed.
  ///
  /// In zh, this message translates to:
  /// **'照片添加失败，请重试'**
  String get reportPhotoFailed;

  /// No description provided for @reportEmptyHint.
  ///
  /// In zh, this message translates to:
  /// **'暂无检测记录。完成红外、反光、WiFi、蓝牙或磁力检测后，结论会自动汇总到这里。'**
  String get reportEmptyHint;

  /// No description provided for @reportDetails.
  ///
  /// In zh, this message translates to:
  /// **'检测明细'**
  String get reportDetails;

  /// No description provided for @reportClear.
  ///
  /// In zh, this message translates to:
  /// **'清空记录'**
  String get reportClear;

  /// No description provided for @reportExporting.
  ///
  /// In zh, this message translates to:
  /// **'正在生成 PDF…'**
  String get reportExporting;

  /// No description provided for @reportExportPdf.
  ///
  /// In zh, this message translates to:
  /// **'导出 PDF 并分享'**
  String get reportExportPdf;

  /// No description provided for @reportLocalNote.
  ///
  /// In zh, this message translates to:
  /// **'报告在本地生成并通过系统分享面板发送，不会上传到任何服务器。'**
  String get reportLocalNote;

  /// No description provided for @reportSummary.
  ///
  /// In zh, this message translates to:
  /// **'{count} 项检测 · {riskCount} 项风险/存疑'**
  String reportSummary(Object count, Object riskCount);

  /// No description provided for @reportSummaryDesc.
  ///
  /// In zh, this message translates to:
  /// **'本次会话的检测结论汇总，可导出为 PDF'**
  String get reportSummaryDesc;

  /// No description provided for @reportPdfTitle.
  ///
  /// In zh, this message translates to:
  /// **'隐私相机 · 检测报告'**
  String get reportPdfTitle;

  /// No description provided for @reportPdfTime.
  ///
  /// In zh, this message translates to:
  /// **'生成时间'**
  String get reportPdfTime;

  /// No description provided for @reportPdfPlace.
  ///
  /// In zh, this message translates to:
  /// **'检查地点'**
  String get reportPdfPlace;

  /// No description provided for @reportPdfPlaceEmpty.
  ///
  /// In zh, this message translates to:
  /// **'未填写'**
  String get reportPdfPlaceEmpty;

  /// No description provided for @reportPdfWifi.
  ///
  /// In zh, this message translates to:
  /// **'WiFi'**
  String get reportPdfWifi;

  /// No description provided for @reportPdfWifiEmpty.
  ///
  /// In zh, this message translates to:
  /// **'未连接 WiFi'**
  String get reportPdfWifiEmpty;

  /// No description provided for @reportPdfPhotos.
  ///
  /// In zh, this message translates to:
  /// **'现场照片'**
  String get reportPdfPhotos;

  /// No description provided for @reportPdfSummary.
  ///
  /// In zh, this message translates to:
  /// **'共 {count} 项检测，其中 {risk} 项提示风险/存疑。结果仅供参考，非执法证据。'**
  String reportPdfSummary(Object count, Object risk);

  /// No description provided for @reportPdfEmpty.
  ///
  /// In zh, this message translates to:
  /// **'本次会话暂无检测记录。'**
  String get reportPdfEmpty;

  /// No description provided for @reportPdfNext.
  ///
  /// In zh, this message translates to:
  /// **'下一步行动建议'**
  String get reportPdfNext;

  /// No description provided for @reportPdfAction1.
  ///
  /// In zh, this message translates to:
  /// **'拍照留存可疑设备位置与房间全貌，不触碰、不拆卸'**
  String get reportPdfAction1;

  /// No description provided for @reportPdfAction2.
  ///
  /// In zh, this message translates to:
  /// **'告知酒店前台 / 房东，并要求书面记录或换房'**
  String get reportPdfAction2;

  /// No description provided for @reportPdfAction3.
  ///
  /// In zh, this message translates to:
  /// **'拨打 110 报警，由警方到场取证与司法鉴定'**
  String get reportPdfAction3;

  /// No description provided for @reportPdfDisclaimer.
  ///
  /// In zh, this message translates to:
  /// **'免责声明：红外/反光检测依赖手机 CMOS 对红外光的敏感度，WiFi 扫描仅能发现当前局域网内联网设备，磁力与蓝牙检测仅作辅助。本报告不构成任何法律证据，请以警方取证为准。'**
  String get reportPdfDisclaimer;

  /// No description provided for @reportPdfFooter.
  ///
  /// In zh, this message translates to:
  /// **'由「隐私相机」生成 · 数据仅在本地处理'**
  String get reportPdfFooter;

  /// No description provided for @riskSafe.
  ///
  /// In zh, this message translates to:
  /// **'通过'**
  String get riskSafe;

  /// No description provided for @riskLow.
  ///
  /// In zh, this message translates to:
  /// **'存疑'**
  String get riskLow;

  /// No description provided for @riskHigh.
  ///
  /// In zh, this message translates to:
  /// **'风险'**
  String get riskHigh;

  /// No description provided for @featureIr.
  ///
  /// In zh, this message translates to:
  /// **'红外检测'**
  String get featureIr;

  /// No description provided for @featureLens.
  ///
  /// In zh, this message translates to:
  /// **'镜头反光扫描'**
  String get featureLens;

  /// No description provided for @featureWifi.
  ///
  /// In zh, this message translates to:
  /// **'WiFi 网络扫描'**
  String get featureWifi;

  /// No description provided for @featureBluetooth.
  ///
  /// In zh, this message translates to:
  /// **'蓝牙扫描'**
  String get featureBluetooth;

  /// No description provided for @featureMagnet.
  ///
  /// In zh, this message translates to:
  /// **'磁力检测'**
  String get featureMagnet;
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
      <String>['en', 'ko', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ko':
      return AppLocalizationsKo();
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
