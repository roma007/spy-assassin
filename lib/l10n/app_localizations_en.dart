// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Spy Assassin - Hidden Camera Detector';

  @override
  String get privacyPromiseBanner =>
      'No account · no ads · no cloud upload · no data saved — all detection runs on-device';

  @override
  String get proTitle => 'Pro';

  @override
  String get proSubtitle => 'Unlimited history archive + advanced AI features';

  @override
  String get proUnlock => 'Unlock now';

  @override
  String get proUnlocked => 'Pro activated';

  @override
  String get proUpgradePrompt =>
      'Upgrade to Pro for unlimited history archive and future advanced AI detection features.';

  @override
  String get proPlanMonthly => 'Monthly';

  @override
  String get proPlanYearly => 'Yearly';

  @override
  String get proPlanMonthlySub => 'Cancel anytime';

  @override
  String get proPlanYearlySub => 'Best value, 2 months free';

  @override
  String get proBestValue => 'BEST VALUE';

  @override
  String get proRestore => 'Restore purchases';

  @override
  String get proRestoreEmpty => 'No previous purchases found';

  @override
  String get proPurchasing => 'Processing…';

  @override
  String get proStoreUnavailable =>
      'Store is not available. Please try again later.';

  @override
  String get proIapError => 'Purchase failed. Please try again.';

  @override
  String proActiveUntil(Object date) {
    return 'Active until $date';
  }

  @override
  String get proLocalSimUnlock => 'Developer · simulate unlock';

  @override
  String get navTabIr => 'IR';

  @override
  String get navTabWifi => 'WiFi';

  @override
  String get navTabMagnet => 'Magnet';

  @override
  String get navTabMore => 'More';

  @override
  String get tabTitleCheck => 'Anti-Peeping';

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
      'Public internet (1.1.1.1:80) is reachable but the LAN is not — your phone is isolated or blocked from LAN devices. Most common causes: 1) VPN/proxy is on (it blocks the LAN, please turn it off); 2) phone is on the router\'s \"guest network\" or \"device isolation/AP isolation\" is enabled; 3) iOS local network permission has not taken effect (Settings > Privacy & Security > Local Network, make sure \"Spy Assassin\" is green; if not, restart the phone and retry).';

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
  String get wifiDetailHostname => 'Device name';

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
  String get wifiDetailRtsp => 'RTSP fingerprint';

  @override
  String get wifiDetailHttp => 'HTTP fingerprint';

  @override
  String get wifiNoMacIos =>
      'iOS cannot read the MAC address, so hardware vendor info is unavailable';

  @override
  String get wifiStaleChip => 'Likely sleeping';

  @override
  String get wifiStaleSection => 'Sleeping / unreachable (history)';

  @override
  String wifiStaleLastSeen(Object time) {
    return 'Last online $time';
  }

  @override
  String get wifiStaleNote =>
      'No response this time; may be sleeping. From the last scan.';

  @override
  String wifiStaleCount(Object count) {
    return '$count more sleeping / unreachable (history)';
  }

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
  String get moreHistoryTitle => 'Scan History';

  @override
  String get moreHistorySubtitle => 'Saved inspection records and photos';

  @override
  String get moreGuide => 'Hiding spots guide';

  @override
  String get moreGuideSubtitle =>
      'Common hiding places and anti-voyeurism tips';

  @override
  String get guideTitle => 'Inspection Guide';

  @override
  String get guideIntro =>
      'Check by eye first, then verify each spot with the tools. Below are the most common hiding places — go through them in order.';

  @override
  String get guideCta => 'Found something suspicious? See next steps';

  @override
  String get guideHow => 'How to check: ';

  @override
  String get guideHint => 'Tip: ';

  @override
  String get guideP1Title => 'Smoke detector';

  @override
  String get guideP1Check =>
      'Stand directly beneath it and look up / from the side; pinholes often hide at metal-plastic seams';

  @override
  String get guideP1Hint =>
      'Black housings hide pinhole lenses easily — get close and check several angles';

  @override
  String get guideP2Title => 'Outlets & power strips';

  @override
  String get guideP2Check =>
      'Look for unnatural holes or bulges on the panel; shine a flashlight inside';

  @override
  String get guideP2Hint =>
      'USB ports, charger holes and power-strip sides are common hiding spots';

  @override
  String get guideP3Title => 'Mirror (two-way)';

  @override
  String get guideP3Check =>
      'Press a fingernail to the glass: a gap means a normal mirror; no gap means caution';

  @override
  String get guideP3Hint =>
      'A two-way mirror may hide a room behind it — but the mirror itself can also hold a micro lens';

  @override
  String get guideP4Title => 'Wall art & frames';

  @override
  String get guideP4Check =>
      'Check the frame edges and the gap behind the painting for extra holes';

  @override
  String get guideP4Hint =>
      'Hidden compartments behind frames are classic — gently press the frame to feel for oddities';

  @override
  String get guideP5Title => 'AC vents';

  @override
  String get guideP5Check =>
      'Shine a flashlight into the vent and look for unusual reflections between the fins';

  @override
  String get guideP5Hint =>
      'The gap above a wall-mounted AC and the wall can hide micro devices';

  @override
  String get guideP6Title => 'Bedside clock / lamp';

  @override
  String get guideP6Check =>
      'Check the screen, button gaps and base for extra holes';

  @override
  String get guideP6Hint =>
      'Devices right by the bed are both hidden and close to you — check them first';

  @override
  String get guideP7Title => 'Router / TV box';

  @override
  String get guideP7Check =>
      'Look for extra LEDs or pinholes beyond the normal lights';

  @override
  String get guideP7Hint =>
      'Routers are often repurposed as a \"legitimate\" disguise for a camera';

  @override
  String get guideP8Title => 'Plant pots';

  @override
  String get guideP8Check =>
      'Check the pot and the foliage above the soil for foreign objects';

  @override
  String get guideP8Hint =>
      'Micro lenses under foliage are hard to spot — combine with the IR scan';

  @override
  String get guideP9Title => 'Lights / smoke detector';

  @override
  String get guideP9Check =>
      'Check inside lamp shades, chandelier joints and behind bedside wall lamps';

  @override
  String get guideP9Hint =>
      'Glare near light sources fools the eye — the IR detector is more reliable here';

  @override
  String get quickScanTitle => 'Quick Scan';

  @override
  String get quickScanSubtitle => 'IR → WiFi → Magnet, fully automated';

  @override
  String get quickScanStepIr => 'IR scan (≈ 20s)';

  @override
  String get quickScanStepWifi => 'WiFi scan (≈ 15s)';

  @override
  String get quickScanStepMagnet => 'Magnet scan (≈ 15s)';

  @override
  String get quickScanDone => 'Quick scan complete. View verdict.';

  @override
  String quickScanRunning(Object step) {
    return 'Running: $step';
  }

  @override
  String get quickScanStart => 'Start Quick Scan';

  @override
  String get verdictTitle => 'Scan Verdict';

  @override
  String get verdictSafe => 'Safe: no suspicious signals found';

  @override
  String get verdictHighRisk => 'High risk: suspected hidden camera';

  @override
  String verdictRisk(Object count) {
    return 'Risk found: $count suspicious items';
  }

  @override
  String get verdictViewEvidence => 'View evidence';

  @override
  String get verdictExportPdf => 'Export PDF';

  @override
  String get verdictNextActions => 'Next actions';

  @override
  String get verdictDone => 'Done';

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
      'All stats are stored only on this device and never uploaded. Scan history is saved on-device; the free tier keeps the last 5 records.';

  @override
  String get morePrivacyDesign => 'Privacy-first design';

  @override
  String get morePrivacyDesc =>
      'All detection runs on-device: no account, no collection, no upload of any image or network data.';

  @override
  String get reportTitle => 'Inspection report';

  @override
  String get reportHistoryTitle => 'Scan History';

  @override
  String get reportOpenHistory => 'View all';

  @override
  String get reportSeal => 'Finish & save this check';

  @override
  String get historyTitle => 'Scan History';

  @override
  String get historyEmpty =>
      'No saved checks yet. Finish a check, then tap \"Finish & save this check\" on the Report screen to archive it.';

  @override
  String historyProNote(Object count) {
    return 'Free keeps the last $count scan records. Upgrade to Pro for unlimited storage';
  }

  @override
  String get historyProUnlimited => 'Pro: unlimited scan history';

  @override
  String historyPlace(Object place) {
    return 'Place: $place';
  }

  @override
  String get historyOpen => 'Open';

  @override
  String get historyDelete => 'Delete';

  @override
  String get historyDeleteConfirm =>
      'Delete this scan record? Its details and photos will be removed permanently.';

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
      'The report is generated on-device and shared through the system sheet; nothing is uploaded. This check is saved on-device (free keeps the last 5).';

  @override
  String reportSummary(Object count, Object riskCount) {
    return '$count check(s) · $riskCount risk(s)/uncertain';
  }

  @override
  String get reportSummaryDesc =>
      'Summary of this session\'s checks, exportable as PDF';

  @override
  String get reportPdfTitle => 'Spy Assassin · Inspection Report';

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
      'Generated by \"Spy Assassin\" · processed on-device only';

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

  @override
  String get featureTracker => 'Tracker Scan';

  @override
  String get navTabHub => 'Anti-Spy';

  @override
  String get tabTitleHub => 'Anti-Surveillance';

  @override
  String get hubTagline =>
      'Find hidden cameras in your room and trackers that follow you';

  @override
  String get hubTaglineSub => 'Anti-voyeurism · anti-tracking, all on-device';

  @override
  String get hubRoomCheckTitle => 'Anti-Peeping';

  @override
  String get hubRoomCheckSubtitle =>
      '4-step scan for hidden cameras (IR / lens / WiFi / magnet)';

  @override
  String get hubTrackerTitle => 'Tracker Scan';

  @override
  String get hubTrackerSubtitle =>
      'Scan nearby Bluetooth for trackers following you';

  @override
  String get trackerTitle => 'Tracker Scan';

  @override
  String get trackerIntro =>
      'Scans nearby Bluetooth devices for known trackers such as AirTags. Scan a few times from different spots to check whether any device keeps following you. Everything stays on your device.';

  @override
  String get trackerStartScan => 'Start scan';

  @override
  String get trackerScanning => 'Scanning (about 10s)…';

  @override
  String get trackerScanAgain => 'Scan again';

  @override
  String get trackerScanFailed =>
      'Scan failed. Make sure Bluetooth permission is granted, then try again.';

  @override
  String trackerRoundsDone(Object count) {
    return '$count scan(s) completed';
  }

  @override
  String get trackerRoundsTip =>
      'Move to another spot or outside, then scan again to confirm whether a device keeps following you.';

  @override
  String get trackerMoveHint =>
      'Tracker candidates found. Confirm their location, or scan again for more confidence.';

  @override
  String get trackerFinish => 'Finish check';

  @override
  String get trackerRestart => 'Start over';

  @override
  String get trackerNoTracker => 'No known trackers found';

  @override
  String get trackerNoTrackerTip =>
      'Keep relying on the system\'s built-in unknown-tracker alerts and stay alert.';

  @override
  String trackerFoundCandidates(Object count) {
    return '$count candidate(s) found';
  }

  @override
  String get trackerSectionTrackers => 'Tracker candidates';

  @override
  String trackerSectionOthers(Object count) {
    return 'Other Bluetooth devices ($count)';
  }

  @override
  String get trackerBrandFindMy => 'AirTag / Find My accessory';

  @override
  String get trackerBrandSamsung => 'Samsung SmartTag';

  @override
  String get trackerBrandTile => 'Tile tracker';

  @override
  String get trackerBrandGoogle => 'Google tracker';

  @override
  String get trackerMotionRepeated => 'Possibly following';

  @override
  String get trackerMotionOnce => 'Seen once';

  @override
  String get trackerMotionRegular => 'Regular device';

  @override
  String get trackerDistanceNear => 'Very close';

  @override
  String get trackerDistanceMid => 'Close';

  @override
  String get trackerDistanceFar => 'Far';

  @override
  String get trackerGuidanceTitle => 'Suspicious tracker found, what to do';

  @override
  String get trackerGuidance1 =>
      'Check your belongings, bags, and inside/outside your vehicle for unfamiliar small devices';

  @override
  String get trackerGuidance2 =>
      'For an AirTag, open the Find My app on any nearby iPhone → Items, and try playing a sound to locate it';

  @override
  String get trackerGuidance3 =>
      'Do not remove it hastily — photograph it as evidence first; if confirmed, contact the police';

  @override
  String get trackerDisclaimer =>
      'Note: this scan runs in the foreground and only recognizes known tracker brands. Devices actively paired to their owner\'s phone may be missed. Results are for reference only, not legal evidence.';

  @override
  String get trackerSafeTitle => 'Nothing unusual';

  @override
  String get trackerSafeDesc =>
      'No known trackers found in this round. Stay alert and rescan from another spot if needed.';

  @override
  String get trackerRiskTitle => 'Tracker candidate(s) found';

  @override
  String trackerRiskRepeated(Object count) {
    return '$count device(s) kept appearing near you across scans — check now';
  }

  @override
  String trackerRiskOnce(Object count) {
    return '$count tracker candidate(s) found — follow the guidance below';
  }

  @override
  String trackerReportSummary(
    Object candidates,
    Object repeated,
    Object rounds,
  ) {
    return 'Tracker scan $rounds time(s): $candidates candidate(s), $repeated possibly following';
  }

  @override
  String get trackerReportSummaryNone => 'Tracker scan found no known trackers';

  @override
  String get moreTrackerTitle => 'Tracker Scan';

  @override
  String get moreTrackerSubtitle =>
      'Detect nearby AirTags, SmartTags and other trackers';
}
