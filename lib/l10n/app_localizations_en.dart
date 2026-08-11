// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Privacy Camera';

  @override
  String get privacyPromiseBanner =>
      'No account · no ads · no cloud upload · no data saved — all detection runs on-device';

  @override
  String get proTitle => 'Pro';

  @override
  String get proSubtitle => 'Unlimited detections + PDF report export';

  @override
  String get proUnlock => 'Unlock now';

  @override
  String get proUnlocked => 'Pro activated';

  @override
  String get proLimitTitle => 'Daily free limit reached';

  @override
  String get proUpgradePrompt =>
      'Upgrade to Pro for unlimited use of all detection tools and PDF report export.';

  @override
  String get proLater => 'Not now';

  @override
  String proLimitLeft(Object count) {
    return '$count free detection(s) left today';
  }

  @override
  String get navTabCheck => 'Check';

  @override
  String get navTabIr => 'IR';

  @override
  String get navTabWifi => 'WiFi';

  @override
  String get navTabMagnet => 'Magnet';

  @override
  String get navTabMore => 'More';

  @override
  String get tabTitleCheck => 'Room Check';

  @override
  String get tabTitleIr => 'IR Detection';

  @override
  String get tabTitleWifi => 'WiFi Scan';

  @override
  String get tabTitleMagnet => 'Magnet Scan';

  @override
  String get tabTitleMore => 'More';

  @override
  String get checkVisualTitle => 'Visual Check';

  @override
  String get checkVisualDesc =>
      'Inspect mirrors, smoke detectors, outlet holes, wall art, air-conditioning vents, digital clocks and other common hiding spots';

  @override
  String get checkStep1Min => '~1 min';

  @override
  String get checkStep1_5Min => '~1.5 min';

  @override
  String get checkIrTitle => 'IR Scan';

  @override
  String get checkIrDesc =>
      'Turn off the lights, open \"IR Detection\" and slowly sweep every corner of the room';

  @override
  String get checkNetTitle => 'Network Scan';

  @override
  String get checkNetDesc =>
      'Connect to the room WiFi, open \"WiFi Scan\" to look for suspicious networked devices';

  @override
  String get checkMagnetTitle => 'Magnet Check';

  @override
  String get checkMagnetDesc =>
      'Use \"Magnet Scan\" close to suspicious chargers, clocks, smoke detectors and other objects';

  @override
  String get checkDone => 'Check complete. You can relax now.';

  @override
  String get checkInProgress =>
      'Finish the 4 steps in order, about 4 minutes in total';

  @override
  String checkSuspiciousFound(Object count) {
    return 'Found $count suspicious signal(s), check the next steps';
  }

  @override
  String get checkNextActions => 'View next steps';

  @override
  String checkStepN(Object n) {
    return 'Step $n';
  }

  @override
  String get checkHideoutList => 'Hiding spots list';

  @override
  String get checkSkip => 'Skip';

  @override
  String get checkMarkedSuspicious => 'Marked suspicious';

  @override
  String get checkMarkSuspicious => 'Mark suspicious';

  @override
  String get checkAllFourDone => 'All 4 steps complete';

  @override
  String get checkAllDoneTip =>
      'If any step raised a suspicious signal, take photos as evidence and contact the front desk / landlord or call the police.';

  @override
  String get nextActionsTitle => 'Camera found, what to do';

  @override
  String get nextActionsTip =>
      'Stay calm, secure evidence first, do not dismantle anything. Personal safety comes first; leave the room immediately if necessary.';

  @override
  String get nextAction1Title => '1. Photograph evidence (do this first)';

  @override
  String get nextAction1Desc =>
      'Use another phone to photograph the suspicious device from multiple angles, including its location and the whole room. Do not touch, dismantle or damage it; keep the scene untouched. This is key evidence for reporting and handling.';

  @override
  String get nextAction2Title => '2. Notify the venue manager';

  @override
  String get nextAction2Desc =>
      'Hotels/B&Bs: immediately inform the front desk or landlord, ask for a room change or on-site handling, and request a written record. Being secretly filmed is the venue\'s contractual or even legal liability; never negotiate privately without witnesses.';

  @override
  String get nextAction3Title => '3. Call the police';

  @override
  String get nextAction3Desc =>
      'Call 110 (China) or the local police number and say \"suspected secret filming\"; police will come to collect evidence. Law enforcement can perform forensic analysis; do not remove or destroy the device yourself.';

  @override
  String get nextActionsRightsTip =>
      'Rights reminder: In China, the Personal Information Protection Law and local \"anti-voyeurism\" legislation explicitly prohibit installing cameras in private venues such as hotels. You may demand compensation and file complaints with 12315 or the local consumers association.';

  @override
  String permissionDenial(Object feature) {
    return 'The $feature permission is required for this feature. Please enable it in Settings.';
  }

  @override
  String get permissionCameraName => 'Camera';

  @override
  String get goToSettings => 'Open Settings';

  @override
  String get irNoCamera => 'No camera detected';

  @override
  String irInitFailed(Object error) {
    return 'Camera initialization failed: $error';
  }

  @override
  String get irSustainedSummary =>
      'Persistent suspected infrared light source (clear IR illuminator signature)';

  @override
  String get irOccasionalSummary =>
      'Occasional infrared spot detected (may be a remote control / reflection)';

  @override
  String get irGuidance =>
      'Turn off the lights and draw the curtains. Slowly sweep smoke detectors, outlets, mirrors and other spots.';

  @override
  String get torchOn => 'Torch on';

  @override
  String get torchOff => 'Torch on';

  @override
  String get irFlipTooltip =>
      'Switch camera (front camera is more IR-sensitive)';

  @override
  String get irResTooltip => 'Resolution (lower = higher frame rate)';

  @override
  String get irResLow => 'Smooth (480p, highest frame rate)';

  @override
  String get irResMedium => 'Standard (720p, recommended)';

  @override
  String get irResHigh => 'HD (1080p, lower frame rate)';

  @override
  String get irPermTitle => 'Camera permission required';

  @override
  String get irErrorTitle => 'IR detection unavailable';

  @override
  String get irAlarmBanner =>
      'Persistent suspected IR light source, move slowly and confirm from multiple angles';

  @override
  String get irAlertBanner =>
      'Occasional spot detected — likely a TV remote (IR only when pressing buttons) or a reflection; only sustained spots are suspicious';

  @override
  String get stabilityChip => 'Device is moving, keep it steady';

  @override
  String get startingCamera => 'Starting camera…';

  @override
  String lensInitFailed(Object error) {
    return 'Camera initialization failed: $error';
  }

  @override
  String get lensConfirmedSummary =>
      'Suspected lens reflection spot found, change angle to confirm';

  @override
  String get lensGuidance =>
      'Keep the torch on with light coaxial to the lens, slowly pan across walls and objects';

  @override
  String get lensFlipTooltip => 'Switch camera';

  @override
  String get lensPermTitle => 'Camera permission required';

  @override
  String get lensErrorTitle => 'Reflection scan unavailable';

  @override
  String get lensConfirmBanner =>
      'Suspected lens reflection, change angle to confirm';

  @override
  String get lensHintBanner =>
      'Bright circular spot detected, keep scanning to confirm reflection (glass/metal can cause false positives)';

  @override
  String get retry => 'Retry';

  @override
  String get wifiNeedInfo =>
      'Could not get current WiFi info, make sure you are connected to WiFi';

  @override
  String wifiHighCount(Object count) {
    return '$count high-risk device(s)';
  }

  @override
  String wifiMediumCount(Object count) {
    return '$count suspicious device(s)';
  }

  @override
  String get wifiNoOpenDevices => 'No devices with open probe ports found';

  @override
  String wifiSummary(Object count, Object detail, Object ssid) {
    return 'WiFi $ssid, $count device(s) found. $detail';
  }

  @override
  String get wifiUnknown => 'Unknown';

  @override
  String wifiVerdictGw(Object gw) {
    return 'No devices with open probe ports found (gateway $gw reachable). Make sure: the camera is on the same WiFi and AP isolation is off; some brands are cloud-only by default and need local access enabled in their official app.';
  }

  @override
  String get wifiVerdictInternet =>
      'Public internet (1.1.1.1:80) is reachable but the LAN is not — your phone is isolated or blocked from LAN devices. Most common causes: 1) VPN/proxy is on (it blocks the LAN, please turn it off); 2) phone is on the router\'s \"guest network\" or \"device isolation/AP isolation\" is enabled; 3) iOS local network permission has not taken effect (Settings > Privacy & Security > Local Network, make sure \"Privacy Camera\" is green; if not, restart the phone and retry).';

  @override
  String get wifiVerdictNone =>
      'Neither public internet nor LAN is reachable — check if Airplane Mode or a global VPN is on, or confirm the WiFi actually has internet.';

  @override
  String get wifiDisclaimer =>
      'Note: only devices on the current WiFi can be found; offline or local-storage cameras are invisible. Results are for reference only, not legal evidence. Long-press a device to quickly mark it as \"my device\".';

  @override
  String get wifiNotConnected => 'Not connected to WiFi';

  @override
  String get wifiGettingInfo => 'Getting network info…';

  @override
  String wifiGatewayMask(Object gateway, Object mask) {
    return 'Gateway $gateway · Mask $mask';
  }

  @override
  String get wifiScanning => 'Scanning subnet…';

  @override
  String get wifiStartScan => 'Scan LAN devices';

  @override
  String get wifiResults => 'Scan results';

  @override
  String wifiRiskCounts(Object high, Object medium) {
    return '$high high-risk · $medium suspicious';
  }

  @override
  String get wifiMyDevices => 'My devices (marked)';

  @override
  String get wifiPermTitle => 'Location permission required';

  @override
  String get wifiPermDesc =>
      'Android requires location permission to read WiFi info. Scan results stay on your device.';

  @override
  String wifiDetailReason(Object reason) {
    return 'Risk: $reason';
  }

  @override
  String get wifiDetailIp => 'IP address';

  @override
  String get wifiDetailMac => 'MAC address';

  @override
  String get wifiDetailVendor => 'Vendor match';

  @override
  String get wifiDetailPorts => 'Open ports';

  @override
  String get wifiNone => 'None';

  @override
  String get wifiPortUnknown => 'Unknown';

  @override
  String get wifiDetailUpnp => 'UPnP discovery';

  @override
  String get wifiMarkedCancel => 'My device (tap to unmark)';

  @override
  String get wifiMarkAsMine => 'Mark as my device';

  @override
  String get wifiMyDeviceChip => 'My device';

  @override
  String wifiPorts(Object text) {
    return 'Port $text';
  }

  @override
  String get wifiNoOpenPort => 'No open port found';

  @override
  String get bleUnnamed => 'Unnamed device';

  @override
  String bleSummary(Object count, Object high, Object medium, Object names) {
    return '$count Bluetooth device(s) nearby. $high high-risk, $medium suspicious. $names';
  }

  @override
  String get bleDisclaimer =>
      'Note: Bluetooth cameras are uncommon, this tool is only a supplementary clue. Names containing camera/recorder keywords or unnamed devices are worth attention; connected earbuds, bands and speakers are normal devices.';

  @override
  String get bleOn => 'Bluetooth on';

  @override
  String get bleTurningOn => 'Turning on…';

  @override
  String get bleOff => 'Bluetooth off';

  @override
  String get bleOnDesc => 'Ready to scan nearby devices';

  @override
  String get bleOffDesc => 'Bluetooth must be on to scan';

  @override
  String get bleTurnOn => 'Turn on';

  @override
  String get bleScanning => 'Scanning (about 5s)…';

  @override
  String get bleStartScan => 'Scan nearby Bluetooth devices';

  @override
  String get bleRiskHigh => 'High risk';

  @override
  String get bleRiskMedium => 'Suspicious';

  @override
  String get bleRiskLow => 'Low risk';

  @override
  String magnetSummary(Object delta, Object threshold) {
    return 'Field delta $delta µT above ambient, exceeds threshold of $threshold µT';
  }

  @override
  String get magnetUsageTitle => 'Usage tips';

  @override
  String get magnetTip1 =>
      '• Hold the phone 3~10 cm from the suspicious object and move slowly';

  @override
  String get magnetTip2 =>
      '• Magnetometer location: near the top-right corner on iPhone, near the top-center on most Android phones';

  @override
  String get magnetTip3 =>
      '• Only act when above the threshold line for over 1 second';

  @override
  String get magnetTip4 =>
      '• Dense electronics areas (outlet walls, near routers) cause more false positives';

  @override
  String get magnetCalibrating =>
      'Calibrating ambient magnetic field (keep the phone still)…';

  @override
  String get magnetCalibrated =>
      'Calibrated, you can start scanning suspicious objects';

  @override
  String get magnetRecalibrate => 'Recalibrate';

  @override
  String get magnetAlarm => 'Magnetic anomaly detected, please confirm!';

  @override
  String get magnetDelta => 'Field delta vs ambient';

  @override
  String magnetThresholdValue(Object value) {
    return 'Threshold $value µT';
  }

  @override
  String get magnetThresholdTitle => 'Alarm threshold';

  @override
  String get magnetThresholdHint =>
      'Raise to reduce false positives (lower for more sensitive scenes)';

  @override
  String get magnetChart => 'Live chart';

  @override
  String get moreTools => 'Detection tools';

  @override
  String get moreLensTitle => 'Lens reflection scan';

  @override
  String get moreLensSubtitle =>
      'Coaxial torch light to find lens retro-reflection spots';

  @override
  String get moreBleTitle => 'Bluetooth scan';

  @override
  String get moreBleSubtitle =>
      'Supplementary scan of nearby Bluetooth devices';

  @override
  String get moreReportTitle => 'Inspection report';

  @override
  String get moreReportSubtitle => 'Summarize results and export as PDF';

  @override
  String get moreGuide => 'Hiding spots guide';

  @override
  String get moreGuideSubtitle =>
      'Common hiding places and anti-voyeurism tips';

  @override
  String get morePrivacy => 'Privacy policy';

  @override
  String get morePrivacySubtitle =>
      'No account · no ads · no cloud upload · no data saved';

  @override
  String get moreAbout => 'About';

  @override
  String get moreAboutSubtitle => 'Version 1.0.0';

  @override
  String get moreSettings => 'Settings';

  @override
  String get moreSettingsSubtitle => 'Language · local stats · data';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsLanguageSystem => 'Follow system';

  @override
  String get settingsLanguageZh => '简体中文';

  @override
  String get settingsLanguageEn => 'English';

  @override
  String get settingsLanguageKo => '한국어';

  @override
  String get settingsStatsTitle => 'Local stats';

  @override
  String get statsCheckStarted => 'Checks started';

  @override
  String get statsCheckDone => 'Checks completed';

  @override
  String get statsCompletionRate => 'Completion rate';

  @override
  String get statsAvgDuration => 'Avg. duration';

  @override
  String get statsTools => 'Tool usage';

  @override
  String get statsEmpty =>
      'No data yet. Complete a room check or use a detection tool and it will be recorded here (on-device only).';

  @override
  String statsDurationFormat(Object m, Object s) {
    return '${m}m ${s}s';
  }

  @override
  String get settingsDataTitle => 'Data';

  @override
  String get settingsClearStats => 'Clear local stats';

  @override
  String get settingsClearReport => 'Clear check records';

  @override
  String get settingsClearConfirm => 'This cannot be undone. Continue?';

  @override
  String get settingsClearDone => 'Clear';

  @override
  String get settingsCancel => 'Cancel';

  @override
  String get settingsDataNote =>
      'All stats are stored only on this device and never uploaded. Check records and photos live in memory only and are cleared when the app restarts.';

  @override
  String get morePrivacyDesign => 'Privacy-first design';

  @override
  String get morePrivacyDesc =>
      'All detection runs on-device: no account, no collection, no upload of any image or network data.';

  @override
  String get reportTitle => 'Inspection report';

  @override
  String get reportEmptyError =>
      'No inspection records yet, complete at least one detection first';

  @override
  String get reportShareCancelled => 'Share cancelled';

  @override
  String reportExportFailed(Object error) {
    return 'Export failed: $error';
  }

  @override
  String get reportPlaceLabel =>
      'Inspection place (optional, e.g. hotel / room no.)';

  @override
  String get reportPlaceHint => 'Only shown in the report, no location access';

  @override
  String get reportPhotos => 'Photos';

  @override
  String get reportPhotosEmpty =>
      'No photos yet. Photograph suspicious devices or spots; they will be included when you export.';

  @override
  String get reportAddPhoto => 'Add photo';

  @override
  String get reportAddPhotoCamera => 'Take photo';

  @override
  String get reportAddPhotoGallery => 'Choose from library';

  @override
  String get reportPhotoFailed => 'Failed to add photo, try again';

  @override
  String get reportEmptyHint =>
      'No records yet. Results are summarized here automatically after IR, reflection, WiFi, Bluetooth or magnet checks.';

  @override
  String get reportDetails => 'Details';

  @override
  String get reportClear => 'Clear';

  @override
  String get reportExporting => 'Generating PDF…';

  @override
  String get reportExportPdf => 'Export PDF & share';

  @override
  String get reportLocalNote =>
      'The report is generated on-device and shared through the system sheet; nothing is uploaded.';

  @override
  String reportSummary(Object count, Object riskCount) {
    return '$count check(s) · $riskCount risk(s)/uncertain';
  }

  @override
  String get reportSummaryDesc =>
      'Summary of this session\'s checks, exportable as PDF';

  @override
  String get reportPdfTitle => 'Privacy Camera · Inspection Report';

  @override
  String get reportPdfTime => 'Generated at';

  @override
  String get reportPdfPlace => 'Inspection place';

  @override
  String get reportPdfPlaceEmpty => 'Not specified';

  @override
  String get reportPdfWifi => 'WiFi';

  @override
  String get reportPdfWifiEmpty => 'Not connected to WiFi';

  @override
  String get reportPdfPhotos => 'Photos';

  @override
  String reportPdfSummary(Object count, Object risk) {
    return '$count check(s) in total, $risk flagged as risk/uncertain. For reference only, not legal evidence.';
  }

  @override
  String get reportPdfEmpty => 'No inspection records in this session.';

  @override
  String get reportPdfNext => 'Suggested next steps';

  @override
  String get reportPdfAction1 =>
      'Photograph the suspicious device\'s location and the room overview; do not touch or dismantle it';

  @override
  String get reportPdfAction2 =>
      'Inform the hotel front desk / landlord and request a written record or a room change';

  @override
  String get reportPdfAction3 =>
      'Call 110 (China) / local police for on-site forensics';

  @override
  String get reportPdfDisclaimer =>
      'Disclaimer: IR/reflection detection depends on the CMOS IR sensitivity of your phone; WiFi scanning only finds devices on the current LAN; magnet and Bluetooth checks are supplementary. This report is not legal evidence; rely on police forensics.';

  @override
  String get reportPdfFooter =>
      'Generated by \"Privacy Camera\" · processed on-device only';

  @override
  String get riskSafe => 'Pass';

  @override
  String get riskLow => 'Uncertain';

  @override
  String get riskHigh => 'Risk';

  @override
  String get featureIr => 'IR Detection';

  @override
  String get featureLens => 'Lens Reflection Scan';

  @override
  String get featureWifi => 'WiFi Network Scan';

  @override
  String get featureBluetooth => 'Bluetooth Scan';

  @override
  String get featureMagnet => 'Magnet Scan';
}
