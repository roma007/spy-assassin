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
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ko'),
    Locale('zh')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Spy Assassin - Hidden Camera Detector'**
  String get appTitle;

  /// No description provided for @privacyPromiseBanner.
  ///
  /// In en, this message translates to:
  /// **'No account · no ads · no cloud upload · no data saved — all detection runs on-device'**
  String get privacyPromiseBanner;

  /// No description provided for @proTitle.
  ///
  /// In en, this message translates to:
  /// **'Pro'**
  String get proTitle;

  /// No description provided for @proSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Unlimited detections + PDF report export'**
  String get proSubtitle;

  /// No description provided for @proUnlock.
  ///
  /// In en, this message translates to:
  /// **'Unlock now'**
  String get proUnlock;

  /// No description provided for @proUnlocked.
  ///
  /// In en, this message translates to:
  /// **'Pro activated'**
  String get proUnlocked;

  /// No description provided for @proLimitTitle.
  ///
  /// In en, this message translates to:
  /// **'Daily free limit reached'**
  String get proLimitTitle;

  /// No description provided for @proUpgradePrompt.
  ///
  /// In en, this message translates to:
  /// **'Upgrade to Pro for unlimited use of all detection tools and PDF report export.'**
  String get proUpgradePrompt;

  /// No description provided for @proLater.
  ///
  /// In en, this message translates to:
  /// **'Not now'**
  String get proLater;

  /// No description provided for @proLimitLeft.
  ///
  /// In en, this message translates to:
  /// **'{count} free detection(s) left today'**
  String proLimitLeft(Object count);

  /// No description provided for @proPlanMonthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get proPlanMonthly;

  /// No description provided for @proPlanYearly.
  ///
  /// In en, this message translates to:
  /// **'Yearly'**
  String get proPlanYearly;

  /// No description provided for @proPlanMonthlySub.
  ///
  /// In en, this message translates to:
  /// **'Cancel anytime'**
  String get proPlanMonthlySub;

  /// No description provided for @proPlanYearlySub.
  ///
  /// In en, this message translates to:
  /// **'Best value, 2 months free'**
  String get proPlanYearlySub;

  /// No description provided for @proBestValue.
  ///
  /// In en, this message translates to:
  /// **'BEST VALUE'**
  String get proBestValue;

  /// No description provided for @proRestore.
  ///
  /// In en, this message translates to:
  /// **'Restore purchases'**
  String get proRestore;

  /// No description provided for @proRestoreEmpty.
  ///
  /// In en, this message translates to:
  /// **'No previous purchases found'**
  String get proRestoreEmpty;

  /// No description provided for @proPurchasing.
  ///
  /// In en, this message translates to:
  /// **'Processing…'**
  String get proPurchasing;

  /// No description provided for @proStoreUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Store is not available. Please try again later.'**
  String get proStoreUnavailable;

  /// No description provided for @proIapError.
  ///
  /// In en, this message translates to:
  /// **'Purchase failed. Please try again.'**
  String get proIapError;

  /// No description provided for @proActiveUntil.
  ///
  /// In en, this message translates to:
  /// **'Active until {date}'**
  String proActiveUntil(Object date);

  /// No description provided for @proLocalSimUnlock.
  ///
  /// In en, this message translates to:
  /// **'Developer · simulate unlock'**
  String get proLocalSimUnlock;

  /// No description provided for @navTabCheck.
  ///
  /// In en, this message translates to:
  /// **'Check'**
  String get navTabCheck;

  /// No description provided for @navTabIr.
  ///
  /// In en, this message translates to:
  /// **'IR'**
  String get navTabIr;

  /// No description provided for @navTabWifi.
  ///
  /// In en, this message translates to:
  /// **'WiFi'**
  String get navTabWifi;

  /// No description provided for @navTabMagnet.
  ///
  /// In en, this message translates to:
  /// **'Magnet'**
  String get navTabMagnet;

  /// No description provided for @navTabMore.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get navTabMore;

  /// No description provided for @tabTitleCheck.
  ///
  /// In en, this message translates to:
  /// **'Room Check'**
  String get tabTitleCheck;

  /// No description provided for @tabTitleIr.
  ///
  /// In en, this message translates to:
  /// **'IR Detection'**
  String get tabTitleIr;

  /// No description provided for @tabTitleWifi.
  ///
  /// In en, this message translates to:
  /// **'WiFi Scan'**
  String get tabTitleWifi;

  /// No description provided for @tabTitleMagnet.
  ///
  /// In en, this message translates to:
  /// **'Magnet Scan'**
  String get tabTitleMagnet;

  /// No description provided for @tabTitleMore.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get tabTitleMore;

  /// No description provided for @checkVisualTitle.
  ///
  /// In en, this message translates to:
  /// **'Visual Check'**
  String get checkVisualTitle;

  /// No description provided for @checkVisualDesc.
  ///
  /// In en, this message translates to:
  /// **'Inspect mirrors, smoke detectors, outlet holes, wall art, air-conditioning vents, digital clocks and other common hiding spots'**
  String get checkVisualDesc;

  /// No description provided for @checkStep1Min.
  ///
  /// In en, this message translates to:
  /// **'~1 min'**
  String get checkStep1Min;

  /// No description provided for @checkStep1_5Min.
  ///
  /// In en, this message translates to:
  /// **'~1.5 min'**
  String get checkStep1_5Min;

  /// No description provided for @checkIrTitle.
  ///
  /// In en, this message translates to:
  /// **'IR Scan'**
  String get checkIrTitle;

  /// No description provided for @checkIrDesc.
  ///
  /// In en, this message translates to:
  /// **'Turn off the lights, open \"IR Detection\" and slowly sweep every corner of the room'**
  String get checkIrDesc;

  /// No description provided for @checkNetTitle.
  ///
  /// In en, this message translates to:
  /// **'Network Scan'**
  String get checkNetTitle;

  /// No description provided for @checkNetDesc.
  ///
  /// In en, this message translates to:
  /// **'Connect to the room WiFi, open \"WiFi Scan\" to look for suspicious networked devices'**
  String get checkNetDesc;

  /// No description provided for @checkMagnetTitle.
  ///
  /// In en, this message translates to:
  /// **'Magnet Check'**
  String get checkMagnetTitle;

  /// No description provided for @checkMagnetDesc.
  ///
  /// In en, this message translates to:
  /// **'Use \"Magnet Scan\" close to suspicious chargers, clocks, smoke detectors and other objects'**
  String get checkMagnetDesc;

  /// No description provided for @checkDone.
  ///
  /// In en, this message translates to:
  /// **'Check complete. You can relax now.'**
  String get checkDone;

  /// No description provided for @checkInProgress.
  ///
  /// In en, this message translates to:
  /// **'Finish the 4 steps in order, about 4 minutes in total'**
  String get checkInProgress;

  /// No description provided for @checkSuspiciousFound.
  ///
  /// In en, this message translates to:
  /// **'Found {count} suspicious signal(s), check the next steps'**
  String checkSuspiciousFound(Object count);

  /// No description provided for @checkNextActions.
  ///
  /// In en, this message translates to:
  /// **'View next steps'**
  String get checkNextActions;

  /// No description provided for @checkStepN.
  ///
  /// In en, this message translates to:
  /// **'Step {n}'**
  String checkStepN(Object n);

  /// No description provided for @checkHideoutList.
  ///
  /// In en, this message translates to:
  /// **'Hiding spots list'**
  String get checkHideoutList;

  /// No description provided for @checkSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get checkSkip;

  /// No description provided for @checkMarkedSuspicious.
  ///
  /// In en, this message translates to:
  /// **'Marked suspicious'**
  String get checkMarkedSuspicious;

  /// No description provided for @checkMarkSuspicious.
  ///
  /// In en, this message translates to:
  /// **'Mark suspicious'**
  String get checkMarkSuspicious;

  /// No description provided for @checkAllFourDone.
  ///
  /// In en, this message translates to:
  /// **'All 4 steps complete'**
  String get checkAllFourDone;

  /// No description provided for @checkAllDoneTip.
  ///
  /// In en, this message translates to:
  /// **'If any step raised a suspicious signal, take photos as evidence and contact the front desk / landlord or call the police.'**
  String get checkAllDoneTip;

  /// No description provided for @quickScanTitle.
  ///
  /// In en, this message translates to:
  /// **'Quick Scan'**
  String get quickScanTitle;

  /// No description provided for @quickScanSubtitle.
  ///
  /// In en, this message translates to:
  /// **'IR → WiFi → Magnet, fully automated'**
  String get quickScanSubtitle;

  /// No description provided for @quickScanStart.
  ///
  /// In en, this message translates to:
  /// **'Start Quick Scan'**
  String get quickScanStart;

  /// No description provided for @quickScanRunning.
  ///
  /// In en, this message translates to:
  /// **'Running: {step}'**
  String quickScanRunning(Object step);

  /// No description provided for @quickScanStepIr.
  ///
  /// In en, this message translates to:
  /// **'IR scan (≈ 20s)'**
  String get quickScanStepIr;

  /// No description provided for @quickScanStepWifi.
  ///
  /// In en, this message translates to:
  /// **'WiFi scan (≈ 15s)'**
  String get quickScanStepWifi;

  /// No description provided for @quickScanStepMagnet.
  ///
  /// In en, this message translates to:
  /// **'Magnet scan (≈ 15s)'**
  String get quickScanStepMagnet;

  /// No description provided for @quickScanDone.
  ///
  /// In en, this message translates to:
  /// **'Quick scan complete. View verdict.'**
  String get quickScanDone;

  /// No description provided for @verdictTitle.
  ///
  /// In en, this message translates to:
  /// **'Scan Verdict'**
  String get verdictTitle;

  /// No description provided for @verdictSafe.
  ///
  /// In en, this message translates to:
  /// **'Safe: no suspicious signals found'**
  String get verdictSafe;

  /// No description provided for @verdictRisk.
  ///
  /// In en, this message translates to:
  /// **'Risk found: {count} suspicious items'**
  String verdictRisk(Object count);

  /// No description provided for @verdictHighRisk.
  ///
  /// In en, this message translates to:
  /// **'High risk: suspected hidden camera'**
  String get verdictHighRisk;

  /// No description provided for @verdictViewEvidence.
  ///
  /// In en, this message translates to:
  /// **'View evidence'**
  String get verdictViewEvidence;

  /// No description provided for @verdictExportPdf.
  ///
  /// In en, this message translates to:
  /// **'Export PDF'**
  String get verdictExportPdf;

  /// No description provided for @verdictNextActions.
  ///
  /// In en, this message translates to:
  /// **'Next actions'**
  String get verdictNextActions;

  /// No description provided for @verdictDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get verdictDone;

  /// No description provided for @nextActionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Camera found, what to do'**
  String get nextActionsTitle;

  /// No description provided for @nextActionsTip.
  ///
  /// In en, this message translates to:
  /// **'Stay calm, secure evidence first, do not dismantle anything. Personal safety comes first; leave the room immediately if necessary.'**
  String get nextActionsTip;

  /// No description provided for @nextAction1Title.
  ///
  /// In en, this message translates to:
  /// **'1. Photograph evidence (do this first)'**
  String get nextAction1Title;

  /// No description provided for @nextAction1Desc.
  ///
  /// In en, this message translates to:
  /// **'Use another phone to photograph the suspicious device from multiple angles, including its location and the whole room. Do not touch, dismantle or damage it; keep the scene untouched. This is key evidence for reporting and handling.'**
  String get nextAction1Desc;

  /// No description provided for @nextAction2Title.
  ///
  /// In en, this message translates to:
  /// **'2. Notify the venue manager'**
  String get nextAction2Title;

  /// No description provided for @nextAction2Desc.
  ///
  /// In en, this message translates to:
  /// **'Hotels/B&Bs: immediately inform the front desk or landlord, ask for a room change or on-site handling, and request a written record. Being secretly filmed is the venue\'s contractual or even legal liability; never negotiate privately without witnesses.'**
  String get nextAction2Desc;

  /// No description provided for @nextAction3Title.
  ///
  /// In en, this message translates to:
  /// **'3. Call the police'**
  String get nextAction3Title;

  /// No description provided for @nextAction3Desc.
  ///
  /// In en, this message translates to:
  /// **'Call 110 (China) or the local police number and say \"suspected secret filming\"; police will come to collect evidence. Law enforcement can perform forensic analysis; do not remove or destroy the device yourself.'**
  String get nextAction3Desc;

  /// No description provided for @nextActionsRightsTip.
  ///
  /// In en, this message translates to:
  /// **'Rights reminder: In China, the Personal Information Protection Law and local \"anti-voyeurism\" legislation explicitly prohibit installing cameras in private venues such as hotels. You may demand compensation and file complaints with 12315 or the local consumers association.'**
  String get nextActionsRightsTip;

  /// No description provided for @permissionDenial.
  ///
  /// In en, this message translates to:
  /// **'The {feature} permission is required for this feature. Please enable it in Settings.'**
  String permissionDenial(Object feature);

  /// No description provided for @permissionCameraName.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get permissionCameraName;

  /// No description provided for @goToSettings.
  ///
  /// In en, this message translates to:
  /// **'Open Settings'**
  String get goToSettings;

  /// No description provided for @irNoCamera.
  ///
  /// In en, this message translates to:
  /// **'No camera detected'**
  String get irNoCamera;

  /// No description provided for @irInitFailed.
  ///
  /// In en, this message translates to:
  /// **'Camera initialization failed: {error}'**
  String irInitFailed(Object error);

  /// No description provided for @irSustainedSummary.
  ///
  /// In en, this message translates to:
  /// **'Persistent suspected infrared light source (clear IR illuminator signature)'**
  String get irSustainedSummary;

  /// No description provided for @irOccasionalSummary.
  ///
  /// In en, this message translates to:
  /// **'Occasional infrared spot detected (may be a remote control / reflection)'**
  String get irOccasionalSummary;

  /// No description provided for @irGuidance.
  ///
  /// In en, this message translates to:
  /// **'Turn off the lights and draw the curtains. Slowly sweep smoke detectors, outlets, mirrors and other spots.'**
  String get irGuidance;

  /// No description provided for @torchOn.
  ///
  /// In en, this message translates to:
  /// **'Torch on'**
  String get torchOn;

  /// No description provided for @torchOff.
  ///
  /// In en, this message translates to:
  /// **'Torch on'**
  String get torchOff;

  /// No description provided for @irFlipTooltip.
  ///
  /// In en, this message translates to:
  /// **'Switch camera (front camera is more IR-sensitive)'**
  String get irFlipTooltip;

  /// No description provided for @irResTooltip.
  ///
  /// In en, this message translates to:
  /// **'Resolution (lower = higher frame rate)'**
  String get irResTooltip;

  /// No description provided for @irResLow.
  ///
  /// In en, this message translates to:
  /// **'Smooth (480p, highest frame rate)'**
  String get irResLow;

  /// No description provided for @irResMedium.
  ///
  /// In en, this message translates to:
  /// **'Standard (720p, recommended)'**
  String get irResMedium;

  /// No description provided for @irResHigh.
  ///
  /// In en, this message translates to:
  /// **'HD (1080p, lower frame rate)'**
  String get irResHigh;

  /// No description provided for @irPermTitle.
  ///
  /// In en, this message translates to:
  /// **'Camera permission required'**
  String get irPermTitle;

  /// No description provided for @irErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'IR detection unavailable'**
  String get irErrorTitle;

  /// No description provided for @irAlarmBanner.
  ///
  /// In en, this message translates to:
  /// **'Persistent suspected IR light source, move slowly and confirm from multiple angles'**
  String get irAlarmBanner;

  /// No description provided for @irAlertBanner.
  ///
  /// In en, this message translates to:
  /// **'Occasional spot detected — likely a TV remote (IR only when pressing buttons) or a reflection; only sustained spots are suspicious'**
  String get irAlertBanner;

  /// No description provided for @stabilityChip.
  ///
  /// In en, this message translates to:
  /// **'Device is moving, keep it steady'**
  String get stabilityChip;

  /// No description provided for @startingCamera.
  ///
  /// In en, this message translates to:
  /// **'Starting camera…'**
  String get startingCamera;

  /// No description provided for @lensInitFailed.
  ///
  /// In en, this message translates to:
  /// **'Camera initialization failed: {error}'**
  String lensInitFailed(Object error);

  /// No description provided for @lensConfirmedSummary.
  ///
  /// In en, this message translates to:
  /// **'Suspected lens reflection spot found, change angle to confirm'**
  String get lensConfirmedSummary;

  /// No description provided for @lensGuidance.
  ///
  /// In en, this message translates to:
  /// **'Keep the torch on with light coaxial to the lens, slowly pan across walls and objects'**
  String get lensGuidance;

  /// No description provided for @lensFlipTooltip.
  ///
  /// In en, this message translates to:
  /// **'Switch camera'**
  String get lensFlipTooltip;

  /// No description provided for @lensPermTitle.
  ///
  /// In en, this message translates to:
  /// **'Camera permission required'**
  String get lensPermTitle;

  /// No description provided for @lensErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Reflection scan unavailable'**
  String get lensErrorTitle;

  /// No description provided for @lensConfirmBanner.
  ///
  /// In en, this message translates to:
  /// **'Suspected lens reflection, change angle to confirm'**
  String get lensConfirmBanner;

  /// No description provided for @lensHintBanner.
  ///
  /// In en, this message translates to:
  /// **'Bright circular spot detected, keep scanning to confirm reflection (glass/metal can cause false positives)'**
  String get lensHintBanner;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @wifiNeedInfo.
  ///
  /// In en, this message translates to:
  /// **'Could not get current WiFi info, make sure you are connected to WiFi'**
  String get wifiNeedInfo;

  /// No description provided for @wifiHighCount.
  ///
  /// In en, this message translates to:
  /// **'{count} high-risk device(s)'**
  String wifiHighCount(Object count);

  /// No description provided for @wifiMediumCount.
  ///
  /// In en, this message translates to:
  /// **'{count} suspicious device(s)'**
  String wifiMediumCount(Object count);

  /// No description provided for @wifiNoOpenDevices.
  ///
  /// In en, this message translates to:
  /// **'No devices with open probe ports found'**
  String get wifiNoOpenDevices;

  /// No description provided for @wifiSummary.
  ///
  /// In en, this message translates to:
  /// **'WiFi {ssid}, {count} device(s) found. {detail}'**
  String wifiSummary(Object count, Object detail, Object ssid);

  /// No description provided for @wifiUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get wifiUnknown;

  /// No description provided for @wifiVerdictGw.
  ///
  /// In en, this message translates to:
  /// **'No devices with open probe ports found (gateway {gw} reachable). Make sure: the camera is on the same WiFi and AP isolation is off; some brands are cloud-only by default and need local access enabled in their official app.'**
  String wifiVerdictGw(Object gw);

  /// No description provided for @wifiVerdictInternet.
  ///
  /// In en, this message translates to:
  /// **'Public internet (1.1.1.1:80) is reachable but the LAN is not — your phone is isolated or blocked from LAN devices. Most common causes: 1) VPN/proxy is on (it blocks the LAN, please turn it off); 2) phone is on the router\'s \"guest network\" or \"device isolation/AP isolation\" is enabled; 3) iOS local network permission has not taken effect (Settings > Privacy & Security > Local Network, make sure \"Spy Assassin\" is green; if not, restart the phone and retry).'**
  String get wifiVerdictInternet;

  /// No description provided for @wifiVerdictNone.
  ///
  /// In en, this message translates to:
  /// **'Neither public internet nor LAN is reachable — check if Airplane Mode or a global VPN is on, or confirm the WiFi actually has internet.'**
  String get wifiVerdictNone;

  /// No description provided for @wifiDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'Note: only devices on the current WiFi can be found; offline or local-storage cameras are invisible. Results are for reference only, not legal evidence. Long-press a device to quickly mark it as \"my device\".'**
  String get wifiDisclaimer;

  /// No description provided for @wifiNotConnected.
  ///
  /// In en, this message translates to:
  /// **'Not connected to WiFi'**
  String get wifiNotConnected;

  /// No description provided for @wifiGettingInfo.
  ///
  /// In en, this message translates to:
  /// **'Getting network info…'**
  String get wifiGettingInfo;

  /// No description provided for @wifiGatewayMask.
  ///
  /// In en, this message translates to:
  /// **'Gateway {gateway} · Mask {mask}'**
  String wifiGatewayMask(Object gateway, Object mask);

  /// No description provided for @wifiScanning.
  ///
  /// In en, this message translates to:
  /// **'Scanning subnet…'**
  String get wifiScanning;

  /// No description provided for @wifiStartScan.
  ///
  /// In en, this message translates to:
  /// **'Scan LAN devices'**
  String get wifiStartScan;

  /// No description provided for @wifiResults.
  ///
  /// In en, this message translates to:
  /// **'Scan results'**
  String get wifiResults;

  /// No description provided for @wifiRiskCounts.
  ///
  /// In en, this message translates to:
  /// **'{high} high-risk · {medium} suspicious'**
  String wifiRiskCounts(Object high, Object medium);

  /// No description provided for @wifiMyDevices.
  ///
  /// In en, this message translates to:
  /// **'My devices (marked)'**
  String get wifiMyDevices;

  /// No description provided for @wifiPermTitle.
  ///
  /// In en, this message translates to:
  /// **'Location permission required'**
  String get wifiPermTitle;

  /// No description provided for @wifiPermDesc.
  ///
  /// In en, this message translates to:
  /// **'Android requires location permission to read WiFi info. Scan results stay on your device.'**
  String get wifiPermDesc;

  /// No description provided for @wifiDetailReason.
  ///
  /// In en, this message translates to:
  /// **'Risk: {reason}'**
  String wifiDetailReason(Object reason);

  /// No description provided for @wifiDetailIp.
  ///
  /// In en, this message translates to:
  /// **'IP address'**
  String get wifiDetailIp;

  /// No description provided for @wifiDetailHostname.
  ///
  /// In en, this message translates to:
  /// **'Device name'**
  String get wifiDetailHostname;

  /// No description provided for @wifiDetailMac.
  ///
  /// In en, this message translates to:
  /// **'MAC address'**
  String get wifiDetailMac;

  /// No description provided for @wifiDetailVendor.
  ///
  /// In en, this message translates to:
  /// **'Vendor match'**
  String get wifiDetailVendor;

  /// No description provided for @wifiDetailPorts.
  ///
  /// In en, this message translates to:
  /// **'Open ports'**
  String get wifiDetailPorts;

  /// No description provided for @wifiNone.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get wifiNone;

  /// No description provided for @wifiPortUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get wifiPortUnknown;

  /// No description provided for @wifiDetailUpnp.
  ///
  /// In en, this message translates to:
  /// **'UPnP discovery'**
  String get wifiDetailUpnp;

  /// No description provided for @wifiDetailRtsp.
  ///
  /// In en, this message translates to:
  /// **'RTSP fingerprint'**
  String get wifiDetailRtsp;

  /// No description provided for @wifiDetailHttp.
  ///
  /// In en, this message translates to:
  /// **'HTTP fingerprint'**
  String get wifiDetailHttp;

  /// No description provided for @wifiNoMacIos.
  ///
  /// In en, this message translates to:
  /// **'iOS cannot read the MAC address, so hardware vendor info is unavailable'**
  String get wifiNoMacIos;

  /// No description provided for @wifiStaleChip.
  ///
  /// In en, this message translates to:
  /// **'Likely sleeping'**
  String get wifiStaleChip;

  /// No description provided for @wifiStaleSection.
  ///
  /// In en, this message translates to:
  /// **'Sleeping / unreachable (history)'**
  String get wifiStaleSection;

  /// No description provided for @wifiStaleLastSeen.
  ///
  /// In en, this message translates to:
  /// **'Last online {time}'**
  String wifiStaleLastSeen(Object time);

  /// No description provided for @wifiStaleNote.
  ///
  /// In en, this message translates to:
  /// **'No response this time; may be sleeping. From the last scan.'**
  String get wifiStaleNote;

  /// No description provided for @wifiStaleCount.
  ///
  /// In en, this message translates to:
  /// **'{count} more sleeping / unreachable (history)'**
  String wifiStaleCount(Object count);

  /// No description provided for @wifiMarkedCancel.
  ///
  /// In en, this message translates to:
  /// **'My device (tap to unmark)'**
  String get wifiMarkedCancel;

  /// No description provided for @wifiMarkAsMine.
  ///
  /// In en, this message translates to:
  /// **'Mark as my device'**
  String get wifiMarkAsMine;

  /// No description provided for @wifiMyDeviceChip.
  ///
  /// In en, this message translates to:
  /// **'My device'**
  String get wifiMyDeviceChip;

  /// No description provided for @wifiPorts.
  ///
  /// In en, this message translates to:
  /// **'Port {text}'**
  String wifiPorts(Object text);

  /// No description provided for @wifiNoOpenPort.
  ///
  /// In en, this message translates to:
  /// **'No open port found'**
  String get wifiNoOpenPort;

  /// No description provided for @bleUnnamed.
  ///
  /// In en, this message translates to:
  /// **'Unnamed device'**
  String get bleUnnamed;

  /// No description provided for @bleSummary.
  ///
  /// In en, this message translates to:
  /// **'{count} Bluetooth device(s) nearby. {high} high-risk, {medium} suspicious. {names}'**
  String bleSummary(Object count, Object high, Object medium, Object names);

  /// No description provided for @bleDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'Note: Bluetooth cameras are uncommon, this tool is only a supplementary clue. Names containing camera/recorder keywords or unnamed devices are worth attention; connected earbuds, bands and speakers are normal devices.'**
  String get bleDisclaimer;

  /// No description provided for @bleOn.
  ///
  /// In en, this message translates to:
  /// **'Bluetooth on'**
  String get bleOn;

  /// No description provided for @bleTurningOn.
  ///
  /// In en, this message translates to:
  /// **'Turning on…'**
  String get bleTurningOn;

  /// No description provided for @bleOff.
  ///
  /// In en, this message translates to:
  /// **'Bluetooth off'**
  String get bleOff;

  /// No description provided for @bleOnDesc.
  ///
  /// In en, this message translates to:
  /// **'Ready to scan nearby devices'**
  String get bleOnDesc;

  /// No description provided for @bleOffDesc.
  ///
  /// In en, this message translates to:
  /// **'Bluetooth must be on to scan'**
  String get bleOffDesc;

  /// No description provided for @bleTurnOn.
  ///
  /// In en, this message translates to:
  /// **'Turn on'**
  String get bleTurnOn;

  /// No description provided for @bleScanning.
  ///
  /// In en, this message translates to:
  /// **'Scanning (about 5s)…'**
  String get bleScanning;

  /// No description provided for @bleStartScan.
  ///
  /// In en, this message translates to:
  /// **'Scan nearby Bluetooth devices'**
  String get bleStartScan;

  /// No description provided for @bleRiskHigh.
  ///
  /// In en, this message translates to:
  /// **'High risk'**
  String get bleRiskHigh;

  /// No description provided for @bleRiskMedium.
  ///
  /// In en, this message translates to:
  /// **'Suspicious'**
  String get bleRiskMedium;

  /// No description provided for @bleRiskLow.
  ///
  /// In en, this message translates to:
  /// **'Low risk'**
  String get bleRiskLow;

  /// No description provided for @magnetSummary.
  ///
  /// In en, this message translates to:
  /// **'Field delta {delta} µT above ambient, exceeds threshold of {threshold} µT'**
  String magnetSummary(Object delta, Object threshold);

  /// No description provided for @magnetUsageTitle.
  ///
  /// In en, this message translates to:
  /// **'Usage tips'**
  String get magnetUsageTitle;

  /// No description provided for @magnetTip1.
  ///
  /// In en, this message translates to:
  /// **'• Hold the phone 3~10 cm from the suspicious object and move slowly'**
  String get magnetTip1;

  /// No description provided for @magnetTip2.
  ///
  /// In en, this message translates to:
  /// **'• Magnetometer location: near the top-right corner on iPhone, near the top-center on most Android phones'**
  String get magnetTip2;

  /// No description provided for @magnetTip3.
  ///
  /// In en, this message translates to:
  /// **'• Only act when above the threshold line for over 1 second'**
  String get magnetTip3;

  /// No description provided for @magnetTip4.
  ///
  /// In en, this message translates to:
  /// **'• Dense electronics areas (outlet walls, near routers) cause more false positives'**
  String get magnetTip4;

  /// No description provided for @magnetCalibrating.
  ///
  /// In en, this message translates to:
  /// **'Calibrating ambient magnetic field (keep the phone still)…'**
  String get magnetCalibrating;

  /// No description provided for @magnetCalibrated.
  ///
  /// In en, this message translates to:
  /// **'Calibrated, you can start scanning suspicious objects'**
  String get magnetCalibrated;

  /// No description provided for @magnetRecalibrate.
  ///
  /// In en, this message translates to:
  /// **'Recalibrate'**
  String get magnetRecalibrate;

  /// No description provided for @magnetAlarm.
  ///
  /// In en, this message translates to:
  /// **'Magnetic anomaly detected, please confirm!'**
  String get magnetAlarm;

  /// No description provided for @magnetDelta.
  ///
  /// In en, this message translates to:
  /// **'Field delta vs ambient'**
  String get magnetDelta;

  /// No description provided for @magnetThresholdValue.
  ///
  /// In en, this message translates to:
  /// **'Threshold {value} µT'**
  String magnetThresholdValue(Object value);

  /// No description provided for @magnetThresholdTitle.
  ///
  /// In en, this message translates to:
  /// **'Alarm threshold'**
  String get magnetThresholdTitle;

  /// No description provided for @magnetThresholdHint.
  ///
  /// In en, this message translates to:
  /// **'Raise to reduce false positives (lower for more sensitive scenes)'**
  String get magnetThresholdHint;

  /// No description provided for @magnetChart.
  ///
  /// In en, this message translates to:
  /// **'Live chart'**
  String get magnetChart;

  /// No description provided for @moreTools.
  ///
  /// In en, this message translates to:
  /// **'Detection tools'**
  String get moreTools;

  /// No description provided for @moreLensTitle.
  ///
  /// In en, this message translates to:
  /// **'Lens reflection scan'**
  String get moreLensTitle;

  /// No description provided for @moreLensSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Coaxial torch light to find lens retro-reflection spots'**
  String get moreLensSubtitle;

  /// No description provided for @moreBleTitle.
  ///
  /// In en, this message translates to:
  /// **'Bluetooth scan'**
  String get moreBleTitle;

  /// No description provided for @moreBleSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Supplementary scan of nearby Bluetooth devices'**
  String get moreBleSubtitle;

  /// No description provided for @moreReportTitle.
  ///
  /// In en, this message translates to:
  /// **'Inspection report'**
  String get moreReportTitle;

  /// No description provided for @moreReportSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Summarize results and export as PDF'**
  String get moreReportSubtitle;

  /// No description provided for @moreHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Scan History'**
  String get moreHistoryTitle;

  /// No description provided for @moreHistorySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Saved inspection records and photos'**
  String get moreHistorySubtitle;

  /// No description provided for @moreGuide.
  ///
  /// In en, this message translates to:
  /// **'Hiding spots guide'**
  String get moreGuide;

  /// No description provided for @moreGuideSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Common hiding places and anti-voyeurism tips'**
  String get moreGuideSubtitle;

  /// No description provided for @guideTitle.
  ///
  /// In en, this message translates to:
  /// **'Inspection Guide'**
  String get guideTitle;

  /// No description provided for @guideIntro.
  ///
  /// In en, this message translates to:
  /// **'Check by eye first, then verify each spot with the tools. Below are the most common hiding places — go through them in order.'**
  String get guideIntro;

  /// No description provided for @guideCta.
  ///
  /// In en, this message translates to:
  /// **'Found something suspicious? See next steps'**
  String get guideCta;

  /// No description provided for @guideHow.
  ///
  /// In en, this message translates to:
  /// **'How to check: '**
  String get guideHow;

  /// No description provided for @guideHint.
  ///
  /// In en, this message translates to:
  /// **'Tip: '**
  String get guideHint;

  /// No description provided for @guideP1Title.
  ///
  /// In en, this message translates to:
  /// **'Smoke detector'**
  String get guideP1Title;

  /// No description provided for @guideP1Check.
  ///
  /// In en, this message translates to:
  /// **'Stand directly beneath it and look up / from the side; pinholes often hide at metal-plastic seams'**
  String get guideP1Check;

  /// No description provided for @guideP1Hint.
  ///
  /// In en, this message translates to:
  /// **'Black housings hide pinhole lenses easily — get close and check several angles'**
  String get guideP1Hint;

  /// No description provided for @guideP2Title.
  ///
  /// In en, this message translates to:
  /// **'Outlets & power strips'**
  String get guideP2Title;

  /// No description provided for @guideP2Check.
  ///
  /// In en, this message translates to:
  /// **'Look for unnatural holes or bulges on the panel; shine a flashlight inside'**
  String get guideP2Check;

  /// No description provided for @guideP2Hint.
  ///
  /// In en, this message translates to:
  /// **'USB ports, charger holes and power-strip sides are common hiding spots'**
  String get guideP2Hint;

  /// No description provided for @guideP3Title.
  ///
  /// In en, this message translates to:
  /// **'Mirror (two-way)'**
  String get guideP3Title;

  /// No description provided for @guideP3Check.
  ///
  /// In en, this message translates to:
  /// **'Press a fingernail to the glass: a gap means a normal mirror; no gap means caution'**
  String get guideP3Check;

  /// No description provided for @guideP3Hint.
  ///
  /// In en, this message translates to:
  /// **'A two-way mirror may hide a room behind it — but the mirror itself can also hold a micro lens'**
  String get guideP3Hint;

  /// No description provided for @guideP4Title.
  ///
  /// In en, this message translates to:
  /// **'Wall art & frames'**
  String get guideP4Title;

  /// No description provided for @guideP4Check.
  ///
  /// In en, this message translates to:
  /// **'Check the frame edges and the gap behind the painting for extra holes'**
  String get guideP4Check;

  /// No description provided for @guideP4Hint.
  ///
  /// In en, this message translates to:
  /// **'Hidden compartments behind frames are classic — gently press the frame to feel for oddities'**
  String get guideP4Hint;

  /// No description provided for @guideP5Title.
  ///
  /// In en, this message translates to:
  /// **'AC vents'**
  String get guideP5Title;

  /// No description provided for @guideP5Check.
  ///
  /// In en, this message translates to:
  /// **'Shine a flashlight into the vent and look for unusual reflections between the fins'**
  String get guideP5Check;

  /// No description provided for @guideP5Hint.
  ///
  /// In en, this message translates to:
  /// **'The gap above a wall-mounted AC and the wall can hide micro devices'**
  String get guideP5Hint;

  /// No description provided for @guideP6Title.
  ///
  /// In en, this message translates to:
  /// **'Bedside clock / lamp'**
  String get guideP6Title;

  /// No description provided for @guideP6Check.
  ///
  /// In en, this message translates to:
  /// **'Check the screen, button gaps and base for extra holes'**
  String get guideP6Check;

  /// No description provided for @guideP6Hint.
  ///
  /// In en, this message translates to:
  /// **'Devices right by the bed are both hidden and close to you — check them first'**
  String get guideP6Hint;

  /// No description provided for @guideP7Title.
  ///
  /// In en, this message translates to:
  /// **'Router / TV box'**
  String get guideP7Title;

  /// No description provided for @guideP7Check.
  ///
  /// In en, this message translates to:
  /// **'Look for extra LEDs or pinholes beyond the normal lights'**
  String get guideP7Check;

  /// No description provided for @guideP7Hint.
  ///
  /// In en, this message translates to:
  /// **'Routers are often repurposed as a \"legitimate\" disguise for a camera'**
  String get guideP7Hint;

  /// No description provided for @guideP8Title.
  ///
  /// In en, this message translates to:
  /// **'Plant pots'**
  String get guideP8Title;

  /// No description provided for @guideP8Check.
  ///
  /// In en, this message translates to:
  /// **'Check the pot and the foliage above the soil for foreign objects'**
  String get guideP8Check;

  /// No description provided for @guideP8Hint.
  ///
  /// In en, this message translates to:
  /// **'Micro lenses under foliage are hard to spot — combine with the IR scan'**
  String get guideP8Hint;

  /// No description provided for @guideP9Title.
  ///
  /// In en, this message translates to:
  /// **'Lights / smoke detector'**
  String get guideP9Title;

  /// No description provided for @guideP9Check.
  ///
  /// In en, this message translates to:
  /// **'Check inside lamp shades, chandelier joints and behind bedside wall lamps'**
  String get guideP9Check;

  /// No description provided for @guideP9Hint.
  ///
  /// In en, this message translates to:
  /// **'Glare near light sources fools the eye — the IR detector is more reliable here'**
  String get guideP9Hint;

  /// No description provided for @morePrivacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy policy'**
  String get morePrivacy;

  /// No description provided for @morePrivacySubtitle.
  ///
  /// In en, this message translates to:
  /// **'No account · no ads · no cloud upload · no data saved'**
  String get morePrivacySubtitle;

  /// No description provided for @moreAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get moreAbout;

  /// No description provided for @moreAboutSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Version 1.0.0'**
  String get moreAboutSubtitle;

  /// No description provided for @moreSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get moreSettings;

  /// No description provided for @moreSettingsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Language · local stats · data'**
  String get moreSettingsSubtitle;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @settingsLanguageSystem.
  ///
  /// In en, this message translates to:
  /// **'Follow system'**
  String get settingsLanguageSystem;

  /// No description provided for @settingsLanguageZh.
  ///
  /// In en, this message translates to:
  /// **'简体中文'**
  String get settingsLanguageZh;

  /// No description provided for @settingsLanguageEn.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get settingsLanguageEn;

  /// No description provided for @settingsLanguageKo.
  ///
  /// In en, this message translates to:
  /// **'한국어'**
  String get settingsLanguageKo;

  /// No description provided for @settingsStatsTitle.
  ///
  /// In en, this message translates to:
  /// **'Local stats'**
  String get settingsStatsTitle;

  /// No description provided for @statsCheckStarted.
  ///
  /// In en, this message translates to:
  /// **'Checks started'**
  String get statsCheckStarted;

  /// No description provided for @statsCheckDone.
  ///
  /// In en, this message translates to:
  /// **'Checks completed'**
  String get statsCheckDone;

  /// No description provided for @statsCompletionRate.
  ///
  /// In en, this message translates to:
  /// **'Completion rate'**
  String get statsCompletionRate;

  /// No description provided for @statsAvgDuration.
  ///
  /// In en, this message translates to:
  /// **'Avg. duration'**
  String get statsAvgDuration;

  /// No description provided for @statsTools.
  ///
  /// In en, this message translates to:
  /// **'Tool usage'**
  String get statsTools;

  /// No description provided for @statsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No data yet. Complete a room check or use a detection tool and it will be recorded here (on-device only).'**
  String get statsEmpty;

  /// No description provided for @statsDurationFormat.
  ///
  /// In en, this message translates to:
  /// **'{m}m {s}s'**
  String statsDurationFormat(Object m, Object s);

  /// No description provided for @settingsDataTitle.
  ///
  /// In en, this message translates to:
  /// **'Data'**
  String get settingsDataTitle;

  /// No description provided for @settingsClearStats.
  ///
  /// In en, this message translates to:
  /// **'Clear local stats'**
  String get settingsClearStats;

  /// No description provided for @settingsClearReport.
  ///
  /// In en, this message translates to:
  /// **'Clear check records'**
  String get settingsClearReport;

  /// No description provided for @settingsClearConfirm.
  ///
  /// In en, this message translates to:
  /// **'This cannot be undone. Continue?'**
  String get settingsClearConfirm;

  /// No description provided for @settingsClearDone.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get settingsClearDone;

  /// No description provided for @settingsCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get settingsCancel;

  /// No description provided for @settingsDataNote.
  ///
  /// In en, this message translates to:
  /// **'All stats are stored only on this device and never uploaded. Scan history is saved on-device; the free tier keeps the last 5 records.'**
  String get settingsDataNote;

  /// No description provided for @morePrivacyDesign.
  ///
  /// In en, this message translates to:
  /// **'Privacy-first design'**
  String get morePrivacyDesign;

  /// No description provided for @morePrivacyDesc.
  ///
  /// In en, this message translates to:
  /// **'All detection runs on-device: no account, no collection, no upload of any image or network data.'**
  String get morePrivacyDesc;

  /// No description provided for @reportTitle.
  ///
  /// In en, this message translates to:
  /// **'Inspection report'**
  String get reportTitle;

  /// No description provided for @reportHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Scan History'**
  String get reportHistoryTitle;

  /// No description provided for @reportOpenHistory.
  ///
  /// In en, this message translates to:
  /// **'View all'**
  String get reportOpenHistory;

  /// No description provided for @reportSeal.
  ///
  /// In en, this message translates to:
  /// **'Finish & save this check'**
  String get reportSeal;

  /// No description provided for @historyTitle.
  ///
  /// In en, this message translates to:
  /// **'Scan History'**
  String get historyTitle;

  /// No description provided for @historyEmpty.
  ///
  /// In en, this message translates to:
  /// **'No saved checks yet. Finish a check, then tap \"Finish & save this check\" on the Report screen to archive it.'**
  String get historyEmpty;

  /// No description provided for @historyProNote.
  ///
  /// In en, this message translates to:
  /// **'Free keeps the last {count} scan records. Upgrade to Pro for unlimited storage'**
  String historyProNote(Object count);

  /// No description provided for @historyProUnlimited.
  ///
  /// In en, this message translates to:
  /// **'Pro: unlimited scan history'**
  String get historyProUnlimited;

  /// No description provided for @historyPlace.
  ///
  /// In en, this message translates to:
  /// **'Place: {place}'**
  String historyPlace(Object place);

  /// No description provided for @historyOpen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get historyOpen;

  /// No description provided for @historyDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get historyDelete;

  /// No description provided for @historyDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete this scan record? Its details and photos will be removed permanently.'**
  String get historyDeleteConfirm;

  /// No description provided for @reportEmptyError.
  ///
  /// In en, this message translates to:
  /// **'No inspection records yet, complete at least one detection first'**
  String get reportEmptyError;

  /// No description provided for @reportShareCancelled.
  ///
  /// In en, this message translates to:
  /// **'Share cancelled'**
  String get reportShareCancelled;

  /// No description provided for @reportExportFailed.
  ///
  /// In en, this message translates to:
  /// **'Export failed: {error}'**
  String reportExportFailed(Object error);

  /// No description provided for @reportPlaceLabel.
  ///
  /// In en, this message translates to:
  /// **'Inspection place (optional, e.g. hotel / room no.)'**
  String get reportPlaceLabel;

  /// No description provided for @reportPlaceHint.
  ///
  /// In en, this message translates to:
  /// **'Only shown in the report, no location access'**
  String get reportPlaceHint;

  /// No description provided for @reportPhotos.
  ///
  /// In en, this message translates to:
  /// **'Photos'**
  String get reportPhotos;

  /// No description provided for @reportPhotosEmpty.
  ///
  /// In en, this message translates to:
  /// **'No photos yet. Photograph suspicious devices or spots; they will be included when you export.'**
  String get reportPhotosEmpty;

  /// No description provided for @reportAddPhoto.
  ///
  /// In en, this message translates to:
  /// **'Add photo'**
  String get reportAddPhoto;

  /// No description provided for @reportAddPhotoCamera.
  ///
  /// In en, this message translates to:
  /// **'Take photo'**
  String get reportAddPhotoCamera;

  /// No description provided for @reportAddPhotoGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from library'**
  String get reportAddPhotoGallery;

  /// No description provided for @reportPhotoFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to add photo, try again'**
  String get reportPhotoFailed;

  /// No description provided for @reportEmptyHint.
  ///
  /// In en, this message translates to:
  /// **'No records yet. Results are summarized here automatically after IR, reflection, WiFi, Bluetooth or magnet checks.'**
  String get reportEmptyHint;

  /// No description provided for @reportDetails.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get reportDetails;

  /// No description provided for @reportClear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get reportClear;

  /// No description provided for @reportExporting.
  ///
  /// In en, this message translates to:
  /// **'Generating PDF…'**
  String get reportExporting;

  /// No description provided for @reportExportPdf.
  ///
  /// In en, this message translates to:
  /// **'Export PDF & share'**
  String get reportExportPdf;

  /// No description provided for @reportLocalNote.
  ///
  /// In en, this message translates to:
  /// **'The report is generated on-device and shared through the system sheet; nothing is uploaded. This check is saved on-device (free keeps the last 5).'**
  String get reportLocalNote;

  /// No description provided for @reportSummary.
  ///
  /// In en, this message translates to:
  /// **'{count} check(s) · {riskCount} risk(s)/uncertain'**
  String reportSummary(Object count, Object riskCount);

  /// No description provided for @reportSummaryDesc.
  ///
  /// In en, this message translates to:
  /// **'Summary of this session\'s checks, exportable as PDF'**
  String get reportSummaryDesc;

  /// No description provided for @reportPdfTitle.
  ///
  /// In en, this message translates to:
  /// **'Spy Assassin · Inspection Report'**
  String get reportPdfTitle;

  /// No description provided for @reportPdfTime.
  ///
  /// In en, this message translates to:
  /// **'Generated at'**
  String get reportPdfTime;

  /// No description provided for @reportPdfPlace.
  ///
  /// In en, this message translates to:
  /// **'Inspection place'**
  String get reportPdfPlace;

  /// No description provided for @reportPdfPlaceEmpty.
  ///
  /// In en, this message translates to:
  /// **'Not specified'**
  String get reportPdfPlaceEmpty;

  /// No description provided for @reportPdfWifi.
  ///
  /// In en, this message translates to:
  /// **'WiFi'**
  String get reportPdfWifi;

  /// No description provided for @reportPdfWifiEmpty.
  ///
  /// In en, this message translates to:
  /// **'Not connected to WiFi'**
  String get reportPdfWifiEmpty;

  /// No description provided for @reportPdfPhotos.
  ///
  /// In en, this message translates to:
  /// **'Photos'**
  String get reportPdfPhotos;

  /// No description provided for @reportPdfSummary.
  ///
  /// In en, this message translates to:
  /// **'{count} check(s) in total, {risk} flagged as risk/uncertain. For reference only, not legal evidence.'**
  String reportPdfSummary(Object count, Object risk);

  /// No description provided for @reportPdfEmpty.
  ///
  /// In en, this message translates to:
  /// **'No inspection records in this session.'**
  String get reportPdfEmpty;

  /// No description provided for @reportPdfNext.
  ///
  /// In en, this message translates to:
  /// **'Suggested next steps'**
  String get reportPdfNext;

  /// No description provided for @reportPdfAction1.
  ///
  /// In en, this message translates to:
  /// **'Photograph the suspicious device\'s location and the room overview; do not touch or dismantle it'**
  String get reportPdfAction1;

  /// No description provided for @reportPdfAction2.
  ///
  /// In en, this message translates to:
  /// **'Inform the hotel front desk / landlord and request a written record or a room change'**
  String get reportPdfAction2;

  /// No description provided for @reportPdfAction3.
  ///
  /// In en, this message translates to:
  /// **'Call 110 (China) / local police for on-site forensics'**
  String get reportPdfAction3;

  /// No description provided for @reportPdfDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'Disclaimer: IR/reflection detection depends on the CMOS IR sensitivity of your phone; WiFi scanning only finds devices on the current LAN; magnet and Bluetooth checks are supplementary. This report is not legal evidence; rely on police forensics.'**
  String get reportPdfDisclaimer;

  /// No description provided for @reportPdfFooter.
  ///
  /// In en, this message translates to:
  /// **'Generated by \"Spy Assassin\" · processed on-device only'**
  String get reportPdfFooter;

  /// No description provided for @riskSafe.
  ///
  /// In en, this message translates to:
  /// **'Pass'**
  String get riskSafe;

  /// No description provided for @riskLow.
  ///
  /// In en, this message translates to:
  /// **'Uncertain'**
  String get riskLow;

  /// No description provided for @riskHigh.
  ///
  /// In en, this message translates to:
  /// **'Risk'**
  String get riskHigh;

  /// No description provided for @featureIr.
  ///
  /// In en, this message translates to:
  /// **'IR Detection'**
  String get featureIr;

  /// No description provided for @featureLens.
  ///
  /// In en, this message translates to:
  /// **'Lens Reflection Scan'**
  String get featureLens;

  /// No description provided for @featureWifi.
  ///
  /// In en, this message translates to:
  /// **'WiFi Network Scan'**
  String get featureWifi;

  /// No description provided for @featureBluetooth.
  ///
  /// In en, this message translates to:
  /// **'Bluetooth Scan'**
  String get featureBluetooth;

  /// No description provided for @featureMagnet.
  ///
  /// In en, this message translates to:
  /// **'Magnet Scan'**
  String get featureMagnet;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'ko', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'ko': return AppLocalizationsKo();
    case 'zh': return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
