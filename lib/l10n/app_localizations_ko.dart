// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => '스파이 어쌔신 - 숨은 카메라 탐지';

  @override
  String get privacyPromiseBanner => '계정 없음 · 광고 없음 · 클라우드 업로드 없음 · 데이터는 기기에서만 처리';

  @override
  String get proTitle => 'Pro';

  @override
  String get proSubtitle => '무제한 감지 + PDF 보고서 내보내기';

  @override
  String get proUnlock => '지금 잠금 해제';

  @override
  String get proUnlocked => 'Pro 활성화됨';

  @override
  String get proLimitTitle => '일일 무료 사용 횟수 초과';

  @override
  String get proUpgradePrompt => 'Pro로 업그레이드하면 모든 감지 도구를 무제한 사용하고 PDF 보고서를 내보낼 수 있습니다.';

  @override
  String get proLater => '나중에';

  @override
  String proLimitLeft(Object count) {
    return '오늘 남은 무료 감지 $count회';
  }

  @override
  String get proPlanMonthly => '월간';

  @override
  String get proPlanYearly => '연간';

  @override
  String get proPlanMonthlySub => '언제든 취소 가능';

  @override
  String get proPlanYearlySub => '가장 저렴, 2개월 무료';

  @override
  String get proBestValue => '최고의 가치';

  @override
  String get proRestore => '구매 복원';

  @override
  String get proRestoreEmpty => '복원할 구매 내역이 없습니다';

  @override
  String get proPurchasing => '처리 중…';

  @override
  String get proStoreUnavailable => '스토어를 사용할 수 없습니다. 나중에 다시 시도하세요.';

  @override
  String get proIapError => '구매에 실패했습니다. 다시 시도하세요.';

  @override
  String proActiveUntil(Object date) {
    return '$date까지 유효';
  }

  @override
  String get proLocalSimUnlock => '개발자 · 로컬 시뮬레이션 잠금 해제';

  @override
  String get navTabCheck => '점검';

  @override
  String get navTabIr => '적외선';

  @override
  String get navTabWifi => 'WiFi';

  @override
  String get navTabMagnet => '자력';

  @override
  String get navTabMore => '더보기';

  @override
  String get tabTitleCheck => '방 점검';

  @override
  String get tabTitleIr => '적외선 감지';

  @override
  String get tabTitleWifi => 'WiFi 스캔';

  @override
  String get tabTitleMagnet => '자력 감지';

  @override
  String get tabTitleMore => '더보기';

  @override
  String get checkVisualTitle => '육안 점검';

  @override
  String get checkVisualDesc => '거울, 화재 감지기, 콘센트 구멍, 액자, 에어컨 배출구, 전자시계 등 흔한 은닉 장소를 확인하세요';

  @override
  String get checkStep1Min => '약 1분';

  @override
  String get checkStep1_5Min => '약 1.5분';

  @override
  String get checkIrTitle => '적외선 스캔';

  @override
  String get checkIrDesc => '조명을 끈 뒤 \'적외선 감지\'를 열고 방 구석구석을 천천히 살펴보세요';

  @override
  String get checkNetTitle => '네트워크 스캔';

  @override
  String get checkNetDesc => '방 WiFi에 연결한 뒤 \'WiFi 스캔\'에서 의심스러운 기기를 확인하세요';

  @override
  String get checkMagnetTitle => '자력 점검';

  @override
  String get checkMagnetDesc => '\'자력 감지\'로 의심스러운 충전기, 시계, 화재 감지기 등을 가까이 스캔하세요';

  @override
  String get checkDone => '점검이 완료되었습니다. 안심하세요.';

  @override
  String get checkInProgress => '4단계를 순서대로 진행하세요 (약 4분 소요)';

  @override
  String checkSuspiciousFound(Object count) {
    return '$count곳에서 의심 신호를 발견했습니다. 다음 조치를 확인하세요';
  }

  @override
  String get checkNextActions => '다음 조치 보기';

  @override
  String checkStepN(Object n) {
    return '$n단계';
  }

  @override
  String get checkHideoutList => '은닉 장소 목록 보기';

  @override
  String get checkSkip => '건너뛰기';

  @override
  String get checkMarkedSuspicious => '의심 표시됨';

  @override
  String get checkMarkSuspicious => '의심 표시';

  @override
  String get checkAllFourDone => '4단계 점검 완료';

  @override
  String get checkAllDoneTip => '어느 단계에서든 의심 신호를 발견하면 사진으로 증거를 남기고, 프런트/집주인에게 알리거나 경찰에 신고하세요.';

  @override
  String get quickScanTitle => '빠른 검사';

  @override
  String get quickScanSubtitle => '적외선 → WiFi → 자력, 완전 자동';

  @override
  String get quickScanStart => '빠른 검사 시작';

  @override
  String quickScanRunning(Object step) {
    return '실행 중: $step';
  }

  @override
  String get quickScanStepIr => '적외선 검사 (약 20초)';

  @override
  String get quickScanStepWifi => 'WiFi 검사 (약 15초)';

  @override
  String get quickScanStepMagnet => '자력 검사 (약 15초)';

  @override
  String get quickScanDone => '빠른 검사 완료. 결론 보기';

  @override
  String get verdictTitle => '검사 결론';

  @override
  String get verdictSafe => '안전: 의심 신호 없음';

  @override
  String verdictRisk(Object count) {
    return '위험 발견: $count개 의심 항목';
  }

  @override
  String get verdictHighRisk => '고위험: 숨은 카메라 의심';

  @override
  String get verdictViewEvidence => '증거 보기';

  @override
  String get verdictExportPdf => 'PDF 내보내기';

  @override
  String get verdictNextActions => '다음 조치';

  @override
  String get verdictDone => '완료';

  @override
  String get nextActionsTitle => '카메라를 발견했다면';

  @override
  String get nextActionsTip => '침착하게, 먼저 증거를 확보하고, 기기를 분해하지 마세요. 인명 안전이 우선이며 필요하면 즉시 방을 떠나세요.';

  @override
  String get nextAction1Title => '1. 사진으로 증거 확보 (먼저)';

  @override
  String get nextAction1Desc => '다른 휴대폰으로 의심 기기를 여러 각도에서 촬영하고, 설치 위치와 방 전체 모습도 찍으세요. 기기를 만지거나 분해·훼손하지 말고 현장을 그대로 두세요. 신고와 처리의 핵심 증거입니다.';

  @override
  String get nextAction2Title => '2. 시설 책임자에게 알리기';

  @override
  String get nextAction2Desc => '호텔/민박: 즉시 프런트나 집주인에게 알리고 방 교체 또는 현장 처리를 요구하며 서면 기록을 요청하세요. 몰래 촬영은 시설의 위반 내지 불법이며, 목격자 없이 개인적으로 협상하지 마세요.';

  @override
  String get nextAction3Title => '3. 경찰 신고';

  @override
  String get nextAction3Desc => '110(중국) 또는 현지 경찰에 전화해 \'몰래 촬영 의심\'이라고 알리세요. 경찰이 현장 증거를 확보하고 기기를 사법 감정할 수 있습니다. 개인이 임의로 분해하거나 폐기하지 마세요.';

  @override
  String get nextActionsRightsTip => '권리 안내: 중국의 개인정보보호법과 각지 \'몰래카메라 근절\' 법령은 호텔 등 사적 공간에 카메라 설치를 금지합니다. 배상을 요구할 수 있으며 12315 또는 소비자협회에 신고할 수 있습니다.';

  @override
  String permissionDenial(Object feature) {
    return '$feature 권한이 필요합니다. 설정에서 활성화해 주세요.';
  }

  @override
  String get permissionCameraName => '카메라';

  @override
  String get goToSettings => '설정에서 켜기';

  @override
  String get irNoCamera => '카메라를 찾을 수 없습니다';

  @override
  String irInitFailed(Object error) {
    return '카메라 초기화 실패: $error';
  }

  @override
  String get irSustainedSummary => '적외선 광원으로 의심되는 신호가 지속 감지됨 (적외선 조명 특성 뚜렷)';

  @override
  String get irOccasionalSummary => '간헐적 적외선 점이 감지됨 (리모컨/반사일 수 있음)';

  @override
  String get irGuidance => '조명을 끄고 커튼을 치세요. 화재 감지기, 콘센트, 거울 등을 천천히 스캔하세요.';

  @override
  String get torchOn => '손전등 켜짐';

  @override
  String get torchOff => '손전등 켜기';

  @override
  String get irFlipTooltip => '카메라 전환 (전면 카메라가 적외선에 더 민감)';

  @override
  String get irResTooltip => '해상도 (낮출수록 프레임 향상)';

  @override
  String get irResLow => '부드러움 (480p, 최고 프레임)';

  @override
  String get irResMedium => '표준 (720p, 권장)';

  @override
  String get irResHigh => '고화질 (1080p, 프레임 낮음)';

  @override
  String get irPermTitle => '카메라 권한 필요';

  @override
  String get irErrorTitle => '적외선 감지를 사용할 수 없습니다';

  @override
  String get irAlarmBanner => '적외선 광원이 지속 감지됨. 천천히 움직이며 여러 각도에서 확인하세요';

  @override
  String get irAlertBanner => '간헐적 점이 감지됨. TV 리모컨(버튼을 누를 때만 적외선)이나 반사일 수 있으므로, 지속되는 점만 의심하세요';

  @override
  String get stabilityChip => '기기가 움직이고 있습니다. 안정적으로 유지하세요';

  @override
  String get startingCamera => '카메라 시작 중…';

  @override
  String lensInitFailed(Object error) {
    return '카메라 초기화 실패: $error';
  }

  @override
  String get lensConfirmedSummary => '렌즈 반사광으로 의심되는 점이 발견됨. 각도를 바꿔 확인하세요';

  @override
  String get lensGuidance => '손전등을 켜고 빛을 렌즈와 동축으로 맞춘 뒤 벽과 물체를 천천히 스캔하세요';

  @override
  String get lensFlipTooltip => '카메라 전환';

  @override
  String get lensPermTitle => '카메라 권한 필요';

  @override
  String get lensErrorTitle => '반사 스캔을 사용할 수 없습니다';

  @override
  String get lensConfirmBanner => '렌즈 반사로 의심됨. 각도를 바꿔 확인하세요';

  @override
  String get lensHintBanner => '밝은 원형 점이 감지됨. 반사인지 계속 스캔해 확인하세요 (유리/금속은 오탐 가능)';

  @override
  String get retry => '재시도';

  @override
  String get wifiNeedInfo => '현재 WiFi 정보를 가져올 수 없습니다. WiFi에 연결되었는지 확인하세요';

  @override
  String wifiHighCount(Object count) {
    return '고위험 기기 $count대';
  }

  @override
  String wifiMediumCount(Object count) {
    return '의심 기기 $count대';
  }

  @override
  String get wifiNoOpenDevices => '프로브 포트가 열린 기기를 찾지 못했습니다';

  @override
  String wifiSummary(Object count, Object detail, Object ssid) {
    return 'WiFi $ssid, 기기 $count대 발견. $detail';
  }

  @override
  String get wifiUnknown => '알 수 없음';

  @override
  String wifiVerdictGw(Object gw) {
    return '프로브 포트가 열린 기기를 찾지 못했습니다(게이트웨이 $gw 정상 연결). 확인할 것: 카메라가 같은 WiFi에 있고 AP 격리가 꺼져 있는지; 일부 브랜드는 기본적으로 클라우드 전용이라 공식 앱에서 로컬 접근을 켜야 합니다.';
  }

  @override
  String get wifiVerdictInternet => '공용 인터넷(1.1.1.1:80)은 연결되지만 LAN이 되지 않습니다 — 휴대폰이 LAN 기기와 격리/차단되어 있습니다. 흔한 원인: ① VPN/프록시가 켜짐(LAN 차단, 꺼 주세요); ② \'게스트 네트워크\' 또는 \'기기 격리/AP 격리\'가 켜짐; ③ iOS 로컬 네트워크 권한이 아직 적용 안 됨(설정 > 개인 정보 보호 및 보안 > 로컬 네트워크에서 \'스파이 어쌔신\' 스위치가 초록색인지 확인, 안 되면 재시동 후 재시도).';

  @override
  String get wifiVerdictNone => '공용 인터넷과 LAN 모두 연결되지 않습니다 — 비행기 모드나 전역 VPN을 확인하고, WiFi가 실제로 인터넷에 연결되는지 확인하세요.';

  @override
  String get wifiDisclaimer => '안내: 현재 WiFi에 연결된 기기만 탐지됩니다. 오프라인이거나 로컬 저장 카메라는 발견할 수 없으며 결과는 참고용입니다. 기기를 길게 누르면 \'내 기기\'로 표시할 수 있습니다.';

  @override
  String get wifiNotConnected => 'WiFi 미연결';

  @override
  String get wifiGettingInfo => '네트워크 정보 가져오는 중…';

  @override
  String wifiGatewayMask(Object gateway, Object mask) {
    return '게이트웨이 $gateway · 마스크 $mask';
  }

  @override
  String get wifiScanning => '서브넷 스캔 중…';

  @override
  String get wifiStartScan => 'LAN 기기 스캔 시작';

  @override
  String get wifiResults => '스캔 결과';

  @override
  String wifiRiskCounts(Object high, Object medium) {
    return '고위험 $high · 의심 $medium';
  }

  @override
  String get wifiMyDevices => '내 기기 (표시됨)';

  @override
  String get wifiPermTitle => '위치 권한 필요';

  @override
  String get wifiPermDesc => 'Android는 WiFi 정보를 읽으려면 위치 권한이 필요합니다. 스캔 결과는 기기에서만 처리됩니다.';

  @override
  String wifiDetailReason(Object reason) {
    return '위험 판정: $reason';
  }

  @override
  String get wifiDetailIp => 'IP 주소';

  @override
  String get wifiDetailHostname => '기기 이름';

  @override
  String get wifiDetailMac => 'MAC 주소';

  @override
  String get wifiDetailVendor => '제조사 매칭';

  @override
  String get wifiDetailPorts => '열린 포트';

  @override
  String get wifiNone => '없음';

  @override
  String get wifiPortUnknown => '알 수 없음';

  @override
  String get wifiDetailUpnp => 'UPnP 발견';

  @override
  String get wifiDetailRtsp => 'RTSP 지문';

  @override
  String get wifiDetailHttp => 'HTTP 지문';

  @override
  String get wifiNoMacIos => 'iOS는 MAC 주소를 읽을 수 없어 하드웨어 제조사 정보가 없습니다';

  @override
  String get wifiStaleChip => '절전 추정';

  @override
  String get wifiStaleSection => '절전/응답 없음 (기록)';

  @override
  String wifiStaleLastSeen(Object time) {
    return '마지막 온라인 $time';
  }

  @override
  String get wifiStaleNote => '이번 스캔에서 응답 없음. 절전 상태일 수 있습니다. 지난 스캔 기록입니다.';

  @override
  String wifiStaleCount(Object count) {
    return '절전/응답 없음 $count대 (기록)';
  }

  @override
  String get wifiMarkedCancel => '내 기기 (탭하여 해제)';

  @override
  String get wifiMarkAsMine => '내 기기로 표시';

  @override
  String get wifiMyDeviceChip => '내 기기';

  @override
  String wifiPorts(Object text) {
    return '포트 $text';
  }

  @override
  String get wifiNoOpenPort => '열린 포트 없음';

  @override
  String get bleUnnamed => '이름 없는 기기';

  @override
  String bleSummary(Object count, Object high, Object medium, Object names) {
    return '주변 블루투스 기기 $count개. 고위험 $high, 의심 $medium. $names';
  }

  @override
  String get bleDisclaimer => '안내: 블루투스 카메라는 드물어 보조 단서일 뿐입니다. 카메라/녹음 키워드가 있는 이름이나 이름 없는 기기를 주목하세요. 연결된 이어폰, 밴드, 스피커는 정상 기기입니다.';

  @override
  String get bleOn => '블루투스 켜짐';

  @override
  String get bleTurningOn => '켜는 중…';

  @override
  String get bleOff => '블루투스 꺼짐';

  @override
  String get bleOnDesc => '주변 기기를 스캔할 수 있습니다';

  @override
  String get bleOffDesc => '스캔하려면 블루투스를 켜야 합니다';

  @override
  String get bleTurnOn => '켜기';

  @override
  String get bleScanning => '스캔 중 (약 5초)…';

  @override
  String get bleStartScan => '주변 블루투스 기기 스캔';

  @override
  String get bleRiskHigh => '고위험';

  @override
  String get bleRiskMedium => '의심';

  @override
  String get bleRiskLow => '저위험';

  @override
  String magnetSummary(Object delta, Object threshold) {
    return '주변 대비 자기장 증가 $delta µT, 임계값 $threshold µT 초과';
  }

  @override
  String get magnetUsageTitle => '사용 안내';

  @override
  String get magnetTip1 => '• 휴대폰을 의심 물체에 3~10cm 가까이 대고 천천히 이동하세요';

  @override
  String get magnetTip2 => '• 자기 센서 위치: iPhone은 본체 오른쪽 위, 대부분의 Android는 상단 중앙';

  @override
  String get magnetTip3 => '• 임계선을 1초 이상 넘어야 확인할 가치가 있습니다';

  @override
  String get magnetTip4 => '• 전자기기 밀집 지역(콘센트 벽, 라우터 옆)은 오탐이 많습니다';

  @override
  String get magnetCalibrating => '주변 자기장 보정 중 (휴대폰을 움직이지 마세요)…';

  @override
  String get magnetCalibrated => '보정 완료. 의심 물체에 가까이 대고 스캔하세요';

  @override
  String get magnetRecalibrate => '다시 보정';

  @override
  String get magnetAlarm => '자기장 이상 감지! 확인해 주세요';

  @override
  String get magnetDelta => '주변 대비 자기장 증가';

  @override
  String magnetThresholdValue(Object value) {
    return '임계값 $value µT';
  }

  @override
  String get magnetThresholdTitle => '알람 임계값';

  @override
  String get magnetThresholdHint => '높이면 오탐 감소 (민감하게 하려면 낮춤)';

  @override
  String get magnetChart => '실시간 그래프';

  @override
  String get moreTools => '감지 도구';

  @override
  String get moreLensTitle => '렌즈 반사 스캔';

  @override
  String get moreLensSubtitle => '손전등 동축광으로 렌즈 반사광 탐지';

  @override
  String get moreBleTitle => '블루투스 스캔';

  @override
  String get moreBleSubtitle => '주변 블루투스 기기 보조 점검';

  @override
  String get moreReportTitle => '점검 보고서';

  @override
  String get moreReportSubtitle => '점검 결과 요약, PDF 내보내기';

  @override
  String get moreHistoryTitle => '스캔 기록';

  @override
  String get moreHistorySubtitle => '저장된 점검 기록과 사진';

  @override
  String get moreGuide => '은닉 장소 가이드';

  @override
  String get moreGuideSubtitle => '흔한 은닉 위치와 몰카 예방 팁';

  @override
  String get guideTitle => '점검 가이드';

  @override
  String get guideIntro => '먼저 육안으로 확인한 뒤 도구로 하나씩 검증하세요. 아래는 가장 흔한 은닉 위치이며 순서대로 살펴보는 것을 권장합니다.';

  @override
  String get guideCta => '의심되는 것이 보이나요? 다음 행동 보기';

  @override
  String get guideHow => '확인 방법: ';

  @override
  String get guideHint => '팁: ';

  @override
  String get guideP1Title => '연기 감지기';

  @override
  String get guideP1Check => '바로 아래에서 위/측면으로 살펴보세요. 금속과 플라스틱 이음새에 바늘구멍이 자주 있습니다';

  @override
  String get guideP1Hint => '검은 본체 안에 바늘구멍 렌즈가 가장 숨기 쉽습니다. 가까이서 여러 각도로 확인하세요';

  @override
  String get guideP2Title => '콘센트와 멀티탭';

  @override
  String get guideP2Check => '패널에 부자연스러운 구멍이나 돌출이 없는지 확인하고 손전등으로 내부를 비춰보세요';

  @override
  String get guideP2Hint => 'USB 포트, 충전구, 멀티탭 옆면은 은닉 장소로 흔합니다';

  @override
  String get guideP3Title => '거울 (양면거울)';

  @override
  String get guideP3Check => '손톱을 거울에 대세요. 손톱과 반사 사이에 틈이 있으면 일반 거울, 틈이 없으면 주의하세요';

  @override
  String get guideP3Hint => '양면거울 뒤에는 방이 있을 수 있고 거울 자체에도 초소형 렌즈를 숨길 수 있습니다';

  @override
  String get guideP4Title => '액자와 벽걸이 그림';

  @override
  String get guideP4Check => '액자 가장자리와 그림 뒤쪽 틈에 불필요한 구멍이 있는지 확인하세요';

  @override
  String get guideP4Hint => '액자 뒤 은닉공간은 전형적인 장소입니다. 테두리를 살짝 눌러 이상한 느낌이 있는지 확인하세요';

  @override
  String get guideP5Title => '에어컨 배출구';

  @override
  String get guideP5Check => '배출구 안쪽에 손전등을 비추고 핀 사이에 이상한 반사체가 없는지 확인하세요';

  @override
  String get guideP5Hint => '벽걸이 에어컨 위쪽과 벽 사이에도 소형 기기를 숨길 수 있습니다';

  @override
  String get guideP6Title => '침대 옆 전자시계 / 조명';

  @override
  String get guideP6Check => '화면, 버튼 틈, 받침대에 추가 구멍이 있는지 확인하세요';

  @override
  String get guideP6Hint => '침대 옆 전자기기는 은닉 지점이면서 당신과 가까워 가장 먼저 확인하세요';

  @override
  String get guideP7Title => '공유기 / 셋톱박스';

  @override
  String get guideP7Check => 'LED에 평소와 다른 표시등이나 바늘구멍이 있는지 확인하세요';

  @override
  String get guideP7Hint => '공유기는 \'합법적인 외형\'으로 위장해 카메라를 숨기는 데 자주 사용됩니다';

  @override
  String get guideP8Title => '화분 / 식물';

  @override
  String get guideP8Check => '화분과 흙 위 잎 사이에 이물질이 없는지 확인하세요';

  @override
  String get guideP8Hint => '잎에 가려진 초소형 렌즈는 직접 보기 어렵습니다. 적외선 스캔과 병행하세요';

  @override
  String get guideP9Title => '조명 / 연기 감지기';

  @override
  String get guideP9Check => '등갓 안, 샹들리에 연결부, 침대 옆 벽등 뒤를 하나씩 확인하세요';

  @override
  String get guideP9Hint => '광원 주변의 눈부심은 육안을 방해하므로 적외선 감지가 더 정확합니다';

  @override
  String get morePrivacy => '개인정보 처리방침';

  @override
  String get morePrivacySubtitle => '계정 없음 · 광고 없음 · 클라우드 업로드 없음 · 데이터 저장 안 함';

  @override
  String get moreAbout => '정보';

  @override
  String get moreAboutSubtitle => '버전 1.0.0';

  @override
  String get moreSettings => '설정';

  @override
  String get moreSettingsSubtitle => '언어 · 로컬 통계 · 데이터';

  @override
  String get settingsTitle => '설정';

  @override
  String get settingsLanguage => '언어';

  @override
  String get settingsLanguageSystem => '시스템 설정 따르기';

  @override
  String get settingsLanguageZh => '简体中文';

  @override
  String get settingsLanguageEn => 'English';

  @override
  String get settingsLanguageKo => '한국어';

  @override
  String get settingsStatsTitle => '로컬 통계';

  @override
  String get statsCheckStarted => '시작한 점검';

  @override
  String get statsCheckDone => '완료한 점검';

  @override
  String get statsCompletionRate => '완료율';

  @override
  String get statsAvgDuration => '평균 소요 시간';

  @override
  String get statsTools => '도구 사용 횟수';

  @override
  String get statsEmpty => '아직 데이터가 없습니다. 방 점검이나 감지 도구를 사용하면 여기에 기록됩니다(기기에서만).';

  @override
  String statsDurationFormat(Object m, Object s) {
    return '$m분 $s초';
  }

  @override
  String get settingsDataTitle => '데이터';

  @override
  String get settingsClearStats => '로컬 통계 지우기';

  @override
  String get settingsClearReport => '점검 기록 지우기';

  @override
  String get settingsClearConfirm => '되돌릴 수 없습니다. 계속할까요?';

  @override
  String get settingsClearDone => '지우기';

  @override
  String get settingsCancel => '취소';

  @override
  String get settingsDataNote => '모든 통계와 검사 기록은 이 기기에만 저장되며 업로드되지 않습니다. 스캔 기록은 기기에 저장되며, 무료는 최근 5개를 보관합니다.';

  @override
  String get morePrivacyDesign => '개인정보 우선 설계';

  @override
  String get morePrivacyDesc => '모든 감지는 기기에서만 진행되며, 계정이 필요 없고 어떤 이미지나 네트워크 데이터도 수집·업로드하지 않습니다.';

  @override
  String get reportTitle => '점검 보고서';

  @override
  String get reportHistoryTitle => '스캔 기록';

  @override
  String get reportOpenHistory => '전체 보기';

  @override
  String get reportSeal => '이번 검사 완료 및 저장';

  @override
  String get historyTitle => '스캔 기록';

  @override
  String get historyEmpty => '저장된 검사 기록이 없습니다. 검사를 마친 후 \'보고서\' 화면에서 \'이번 검사 완료 및 저장\'을 눌러 보관하세요.';

  @override
  String historyProNote(Object count) {
    return '무료는 최근 $count개의 스캔 기록을 보관합니다. Pro로 업그레이드하면 무제한 저장';
  }

  @override
  String get historyProUnlimited => 'Pro: 스캔 기록 무제한 저장';

  @override
  String historyPlace(Object place) {
    return '장소: $place';
  }

  @override
  String get historyOpen => '열기';

  @override
  String get historyDelete => '삭제';

  @override
  String get historyDeleteConfirm => '이 스캔 기록을 삭제할까요? 상세 내용과 사진이 영구 삭제됩니다.';

  @override
  String get reportEmptyError => '점검 기록이 없습니다. 먼저 하나 이상의 감지를 완료하세요';

  @override
  String get reportShareCancelled => '공유가 취소되었습니다';

  @override
  String reportExportFailed(Object error) {
    return '내보내기 실패: $error';
  }

  @override
  String get reportPlaceLabel => '점검 장소 (선택, 예: 호텔명/객실 번호)';

  @override
  String get reportPlaceHint => '보고서에만 표시되며 위치 정보는 사용하지 않습니다';

  @override
  String get reportPhotos => '현장 사진';

  @override
  String get reportPhotosEmpty => '사진이 아직 없습니다. 의심 기기나 위치를 촬영해 저장하면 내보낸 보고서에 포함됩니다.';

  @override
  String get reportAddPhoto => '사진 추가';

  @override
  String get reportAddPhotoCamera => '촬영';

  @override
  String get reportAddPhotoGallery => '앨범에서 선택';

  @override
  String get reportPhotoFailed => '사진 추가 실패, 다시 시도하세요';

  @override
  String get reportEmptyHint => '기록이 없습니다. 적외선, 반사, WiFi, 블루투스 또는 자력 감지 후 결과가 자동으로 모입니다.';

  @override
  String get reportDetails => '점검 내역';

  @override
  String get reportClear => '기록 지우기';

  @override
  String get reportExporting => 'PDF 생성 중…';

  @override
  String get reportExportPdf => 'PDF 내보내기 및 공유';

  @override
  String get reportLocalNote => '보고서는 기기에서 생성되어 시스템 공유 시트로 전송됩니다. 어떤 서버에도 업로드되지 않습니다. 이번 검사는 기기에 저장됩니다(무료는 최근 5개 유지).';

  @override
  String reportSummary(Object count, Object riskCount) {
    return '$count개 감지 · $riskCount개 위험/의심';
  }

  @override
  String get reportSummaryDesc => '이번 세션의 점검 결과 요약, PDF로 내보낼 수 있습니다';

  @override
  String get reportPdfTitle => '스파이 어쌔신 · 점검 보고서';

  @override
  String get reportPdfTime => '생성 시간';

  @override
  String get reportPdfPlace => '점검 장소';

  @override
  String get reportPdfPlaceEmpty => '미기재';

  @override
  String get reportPdfWifi => 'WiFi';

  @override
  String get reportPdfWifiEmpty => 'WiFi 미연결';

  @override
  String get reportPdfPhotos => '현장 사진';

  @override
  String reportPdfSummary(Object count, Object risk) {
    return '총 $count개 감지 중 $risk개가 위험/의심으로 표시되었습니다. 참고용이며 법적 증거가 아닙니다.';
  }

  @override
  String get reportPdfEmpty => '이번 세션에는 점검 기록이 없습니다.';

  @override
  String get reportPdfNext => '다음 조치 권고';

  @override
  String get reportPdfAction1 => '의심 기기의 위치와 방 전체 모습을 촬영해 보관하고, 만지거나 분해하지 마세요';

  @override
  String get reportPdfAction2 => '호텔 프런트/집주인에게 알리고 서면 기록을 요청하거나 방을 교체받으세요';

  @override
  String get reportPdfAction3 => '110(중국) 또는 현지 경찰에 신고해 현장 증거 확보와 사법 감정을 요청하세요';

  @override
  String get reportPdfDisclaimer => '면책: 적외선/반사 감지는 휴대폰 CMOS의 적외선 감도에 의존하며, WiFi 스캔은 현재 LAN에 연결된 기기만 찾을 수 있고, 자력·블루투스 감지는 보조 수단입니다. 본 보고서는 법적 증거가 아니며 경찰의 현장 감정을 따르세요.';

  @override
  String get reportPdfFooter => '\'스파이 어쌔신\'로 생성 · 데이터는 기기에서만 처리';

  @override
  String get riskSafe => '통과';

  @override
  String get riskLow => '의심';

  @override
  String get riskHigh => '위험';

  @override
  String get featureIr => '적외선 감지';

  @override
  String get featureLens => '렌즈 반사 스캔';

  @override
  String get featureWifi => 'WiFi 네트워크 스캔';

  @override
  String get featureBluetooth => '블루투스 스캔';

  @override
  String get featureMagnet => '자력 감지';
}
