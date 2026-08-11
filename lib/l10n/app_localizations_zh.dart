// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => '隐私相机';

  @override
  String get privacyPromiseBanner => '无账号 · 无广告 · 无云上传 · 数据不落盘，全程本地检测';

  @override
  String get proTitle => 'Pro 版';

  @override
  String get proSubtitle => '无限次检测 + 导出 PDF 报告';

  @override
  String get proUnlock => '立即解锁';

  @override
  String get proUnlocked => 'Pro 已激活';

  @override
  String get proLimitTitle => '已达每日免费次数上限';

  @override
  String get proUpgradePrompt => '升级 Pro 后可无限次使用全部检测工具，并解锁 PDF 报告导出。';

  @override
  String get proLater => '暂不升级';

  @override
  String proLimitLeft(Object count) {
    return '今日剩余免费检测 $count 次';
  }

  @override
  String get navTabCheck => '检查';

  @override
  String get navTabIr => '红外';

  @override
  String get navTabWifi => 'WiFi';

  @override
  String get navTabMagnet => '磁力';

  @override
  String get navTabMore => '更多';

  @override
  String get tabTitleCheck => '房间检查';

  @override
  String get tabTitleIr => '红外检测';

  @override
  String get tabTitleWifi => 'WiFi 扫描';

  @override
  String get tabTitleMagnet => '磁力检测';

  @override
  String get tabTitleMore => '更多';

  @override
  String get checkVisualTitle => '视觉排查';

  @override
  String get checkVisualDesc => '检查镜面、烟雾报警器、插座孔、装饰画、空调出风口、电子钟等常见隐藏点';

  @override
  String get checkStep1Min => '约 1 分钟';

  @override
  String get checkStep1_5Min => '约 1.5 分钟';

  @override
  String get checkIrTitle => '红外扫描';

  @override
  String get checkIrDesc => '关闭灯光后进入「红外检测」，缓慢扫描房间每个角落';

  @override
  String get checkNetTitle => '网络扫描';

  @override
  String get checkNetDesc => '连接房间 WiFi，进入「WiFi 扫描」查看是否有可疑联网设备';

  @override
  String get checkMagnetTitle => '磁力排查';

  @override
  String get checkMagnetDesc => '用「磁力检测」贴近可疑的充电器、时钟、烟雾报警器等物体';

  @override
  String get checkDone => '检查完成，已获得安心。';

  @override
  String get checkInProgress => '按顺序完成 4 步检查，全程约 4 分钟';

  @override
  String checkSuspiciousFound(Object count) {
    return '发现 $count 处可疑信号，建议查看下一步行动';
  }

  @override
  String get checkNextActions => '查看下一步行动';

  @override
  String checkStepN(Object n) {
    return '第 $n 步';
  }

  @override
  String get checkHideoutList => '查看藏匿点清单';

  @override
  String get checkSkip => '跳过';

  @override
  String get checkMarkedSuspicious => '已标记可疑';

  @override
  String get checkMarkSuspicious => '标记可疑';

  @override
  String get checkAllFourDone => '4 步检查全部完成';

  @override
  String get checkAllDoneTip => '若任一环节发现可疑信号，请拍照留存证据，并联系前台/房东或报警处理。';

  @override
  String get nextActionsTitle => '发现摄像头怎么办';

  @override
  String get nextActionsTip => '先冷静、先取证、不拆机。人身安全优先，必要时立刻离开房间。';

  @override
  String get nextAction1Title => '1. 拍照取证（先做）';

  @override
  String get nextAction1Desc =>
      '用另一台手机对可疑设备多角度拍照，拍下安装位置与房间全貌；不要触碰、拆卸或破坏设备，保持现场原样，这是报警和处理的关键证据。';

  @override
  String get nextAction2Title => '2. 告知场所负责人';

  @override
  String get nextAction2Desc =>
      '酒店/民宿：立刻告知前台或房东，要求换房或到场处理，并索要书面记录；被偷拍是场所的违约甚至违法责任，别在没人见证的情况下私下沟通。';

  @override
  String get nextAction3Title => '3. 报警';

  @override
  String get nextAction3Desc =>
      '拨打 110（中国）/ 当地报警电话，说明\"疑似被偷拍\"，警察会到场取证；警方可对设备进行司法鉴定，个人不要自行拆除或销毁可疑设备。';

  @override
  String get nextActionsRightsTip =>
      '维权提示：在中国，《个人信息保护法》与各地\"反偷拍\"立法明确禁止在酒店等隐私场所安装摄像头，你可以要求场所赔偿，并可向 12315 或当地消协投诉。';

  @override
  String permissionDenial(Object feature) {
    return '需要 $feature 权限才能使用此功能，请在设置中开启。';
  }

  @override
  String get permissionCameraName => '相机';

  @override
  String get goToSettings => '去设置开启';

  @override
  String get irNoCamera => '未检测到相机';

  @override
  String irInitFailed(Object error) {
    return '相机初始化失败：$error';
  }

  @override
  String get irSustainedSummary => '持续发现疑似红外光源（红外补光特征明显）';

  @override
  String get irOccasionalSummary => '检测到偶发红外光点（可能是遥控器/反光）';

  @override
  String get irGuidance => '关闭灯光、拉上窗帘。缓慢扫描烟雾报警器、插座、镜子等位置。';

  @override
  String get torchOn => '手电已开';

  @override
  String get torchOff => '打开手电';

  @override
  String get irFlipTooltip => '切换摄像头（前摄对红外更敏感）';

  @override
  String get irResTooltip => '画面分辨率（降低可提升帧率）';

  @override
  String get irResLow => '流畅（480p，最高帧率）';

  @override
  String get irResMedium => '标准（720p，推荐）';

  @override
  String get irResHigh => '高清（1080p，帧率较低）';

  @override
  String get irPermTitle => '需要相机权限';

  @override
  String get irErrorTitle => '无法使用红外检测';

  @override
  String get irAlarmBanner => '持续发现疑似红外光源，请缓慢移动并从多角度确认';

  @override
  String get irAlertBanner => '检测到偶发光点，可能是电视遥控器（仅在按键瞬间发红外）或反光，连续亮点才可疑';

  @override
  String get stabilityChip => '设备在移动，请保持稳定';

  @override
  String get startingCamera => '正在启动相机…';

  @override
  String lensInitFailed(Object error) {
    return '相机初始化失败：$error';
  }

  @override
  String get lensConfirmedSummary => '发现疑似镜头反光光斑，请变换角度确认';

  @override
  String get lensGuidance => '保持手电常亮、手机与光源同轴，缓慢横移扫描墙面与物体';

  @override
  String get lensFlipTooltip => '切换摄像头';

  @override
  String get lensPermTitle => '需要相机权限';

  @override
  String get lensErrorTitle => '无法使用反光扫描';

  @override
  String get lensConfirmBanner => '疑似镜头反光，请变换角度确认';

  @override
  String get lensHintBanner => '检测到高亮圆斑，持续扫描确认是否反光（玻璃/金属会误报）';

  @override
  String get retry => '重试';

  @override
  String get wifiNeedInfo => '未能获取当前 WiFi 信息，请确认已连接 WiFi';

  @override
  String wifiHighCount(Object count) {
    return '高风险设备 $count 台';
  }

  @override
  String wifiMediumCount(Object count) {
    return '可疑设备 $count 台';
  }

  @override
  String get wifiNoOpenDevices => '未发现开放探测端口的设备';

  @override
  String wifiSummary(Object count, Object detail, Object ssid) {
    return 'WiFi $ssid，共发现设备 $count 台。$detail';
  }

  @override
  String get wifiUnknown => '未知';

  @override
  String wifiVerdictGw(Object gw) {
    return '未发现开放探测端口的设备（网关 $gw 连通正常）。请确认：摄像头与本机在同一 WiFi、未开 AP 隔离；部分品牌摄像头默认仅云端，需在官方 App 开启本地访问。';
  }

  @override
  String get wifiVerdictInternet =>
      '能访问公网(1.1.1.1:80)，但无法访问局域网——说明手机与局域网设备被隔离或屏蔽。最常见原因：① 手机开着 VPN/代理（会屏蔽局域网，请关闭）；② 手机连的是路由器的「访客网络」或开启了「设备隔离/AP 隔离」；③ iOS 本地网络权限仍未生效（设置 > 隐私与安全性 > 本地网络，确认「隐私相机」开关为绿色；不行就重启手机后重试）。';

  @override
  String get wifiVerdictNone =>
      '公网与局域网均不可达——请检查是否开了飞行模式、VPN 全局模式，或确认 WiFi 是否真的可上网。';

  @override
  String get wifiDisclaimer =>
      '说明：仅检测当前 WiFi 下的联网设备，离线或本地存储的摄像头无法被发现；结果仅供参考，非执法证据。长按设备可快速标记为\"我的设备\"。';

  @override
  String get wifiNotConnected => '未连接 WiFi';

  @override
  String get wifiGettingInfo => '正在获取网络信息…';

  @override
  String wifiGatewayMask(Object gateway, Object mask) {
    return '网关 $gateway · 掩码 $mask';
  }

  @override
  String get wifiScanning => '正在扫描网段…';

  @override
  String get wifiStartScan => '开始扫描局域网设备';

  @override
  String get wifiResults => '扫描结果';

  @override
  String wifiRiskCounts(Object high, Object medium) {
    return '高风险 $high · 可疑 $medium';
  }

  @override
  String get wifiMyDevices => '我的设备（已标记）';

  @override
  String get wifiPermTitle => '需要定位权限';

  @override
  String get wifiPermDesc => 'Android 系统要求定位权限才能读取 WiFi 信息。扫描结果仅在本地处理。';

  @override
  String wifiDetailReason(Object reason) {
    return '风险判定：$reason';
  }

  @override
  String get wifiDetailIp => 'IP 地址';

  @override
  String get wifiDetailMac => 'MAC 地址';

  @override
  String get wifiDetailVendor => '厂商匹配';

  @override
  String get wifiDetailPorts => '开放端口';

  @override
  String get wifiNone => '无';

  @override
  String get wifiPortUnknown => '未知';

  @override
  String get wifiDetailUpnp => 'UPnP 发现';

  @override
  String get wifiMarkedCancel => '我的设备（点击取消标记）';

  @override
  String get wifiMarkAsMine => '标记为我的设备';

  @override
  String get wifiMyDeviceChip => '我的设备';

  @override
  String wifiPorts(Object text) {
    return '端口 $text';
  }

  @override
  String get wifiNoOpenPort => '未探到开放端口';

  @override
  String get bleUnnamed => '未命名设备';

  @override
  String bleSummary(Object count, Object high, Object medium, Object names) {
    return '周边蓝牙设备共 $count 个。高风险 $high、可疑 $medium。$names';
  }

  @override
  String get bleDisclaimer =>
      '说明：蓝牙摄像头使用率低，本工具仅作辅助线索。名称含摄像头/录音关键词或未命名设备值得留意；已连接的耳机、手环、音箱等均为正常设备。';

  @override
  String get bleOn => '蓝牙已开启';

  @override
  String get bleTurningOn => '正在开启…';

  @override
  String get bleOff => '蓝牙未开启';

  @override
  String get bleOnDesc => '可以开始扫描周边设备';

  @override
  String get bleOffDesc => '需要开启蓝牙才能扫描';

  @override
  String get bleTurnOn => '开启';

  @override
  String get bleScanning => '正在扫描（约 5 秒）…';

  @override
  String get bleStartScan => '开始扫描周边蓝牙设备';

  @override
  String get bleRiskHigh => '高风险';

  @override
  String get bleRiskMedium => '可疑';

  @override
  String get bleRiskLow => '低风险';

  @override
  String magnetSummary(Object delta, Object threshold) {
    return '相对环境磁场增量 $delta µT，超过阈值 $threshold µT';
  }

  @override
  String get magnetUsageTitle => '使用提示';

  @override
  String get magnetTip1 => '• 将手机贴近可疑物体 3~10cm 缓慢移动';

  @override
  String get magnetTip2 => '• 磁力传感器位置：iPhone 在机身右上角附近，多数 Android 在顶部中段';

  @override
  String get magnetTip3 => '• 超过阈值线并持续 1 秒以上，才值得进一步确认';

  @override
  String get magnetTip4 => '• 电子设备密集区域（插座墙、路由器旁）误报较多';

  @override
  String get magnetCalibrating => '正在校准环境磁场（请保持手机静止）…';

  @override
  String get magnetCalibrated => '已校准，可以开始贴近可疑物体扫描';

  @override
  String get magnetRecalibrate => '重新校准';

  @override
  String get magnetAlarm => '检测到磁场异常，请确认！';

  @override
  String get magnetDelta => '相对环境磁场增量';

  @override
  String magnetThresholdValue(Object value) {
    return '阈值 $value µT';
  }

  @override
  String get magnetThresholdTitle => '报警阈值';

  @override
  String get magnetThresholdHint => '调高可减少误报（更灵敏的场景调低）';

  @override
  String get magnetChart => '实时曲线';

  @override
  String get moreTools => '检测工具';

  @override
  String get moreLensTitle => '镜头反光扫描';

  @override
  String get moreLensSubtitle => '手电同轴光查找镜头回反射光斑';

  @override
  String get moreBleTitle => '蓝牙扫描';

  @override
  String get moreBleSubtitle => '辅助排查周边蓝牙设备';

  @override
  String get moreReportTitle => '检测报告';

  @override
  String get moreReportSubtitle => '汇总检测结论，导出 PDF 存档';

  @override
  String get moreGuide => '排查指南';

  @override
  String get moreGuideSubtitle => '常见隐藏位置与反偷拍技巧';

  @override
  String get morePrivacy => '隐私政策';

  @override
  String get morePrivacySubtitle => '无账号 · 无广告 · 无云上传 · 数据不落盘';

  @override
  String get moreAbout => '关于';

  @override
  String get moreAboutSubtitle => '版本 1.0.0';

  @override
  String get moreSettings => '设置';

  @override
  String get moreSettingsSubtitle => '语言 · 本地统计 · 数据';

  @override
  String get settingsTitle => '设置';

  @override
  String get settingsLanguage => '语言';

  @override
  String get settingsLanguageSystem => '跟随系统';

  @override
  String get settingsLanguageZh => '简体中文';

  @override
  String get settingsLanguageEn => 'English';

  @override
  String get settingsLanguageKo => '한국어';

  @override
  String get settingsStatsTitle => '本地统计';

  @override
  String get statsCheckStarted => '开始检查次数';

  @override
  String get statsCheckDone => '完成检查次数';

  @override
  String get statsCompletionRate => '完成率';

  @override
  String get statsAvgDuration => '平均时长';

  @override
  String get statsTools => '各工具使用次数';

  @override
  String get statsEmpty => '暂无数据：完成一次房间检查或使用任一检测工具后，这里会记录（仅本机）。';

  @override
  String statsDurationFormat(Object m, Object s) {
    return '$m分 $s秒';
  }

  @override
  String get settingsDataTitle => '数据';

  @override
  String get settingsClearStats => '清除本地统计';

  @override
  String get settingsClearReport => '清空检测记录';

  @override
  String get settingsClearConfirm => '该操作不可撤销，确定继续？';

  @override
  String get settingsClearDone => '清除';

  @override
  String get settingsCancel => '取消';

  @override
  String get settingsDataNote =>
      '所有统计数据仅保存在本机，用于查看自己的使用情况，不会上传。检测报告与照片仅存于内存，重启应用后自动清空。';

  @override
  String get morePrivacyDesign => '隐私优先设计';

  @override
  String get morePrivacyDesc => '所有检测均在本机完成，无需账号，不收集、不上传任何图像或网络数据。';

  @override
  String get reportTitle => '检测报告';

  @override
  String get reportEmptyError => '暂无检测记录，请先完成至少一项检测';

  @override
  String get reportShareCancelled => '分享已取消';

  @override
  String reportExportFailed(Object error) {
    return '导出失败：$error';
  }

  @override
  String get reportPlaceLabel => '检查地点（可选，如酒店名/房号）';

  @override
  String get reportPlaceHint => '仅用于报告展示，不涉及定位';

  @override
  String get reportPhotos => '现场照片';

  @override
  String get reportPhotosEmpty => '尚未添加照片。发现可疑设备或位置时可拍照存档，导出报告会一并包含。';

  @override
  String get reportAddPhoto => '添加照片';

  @override
  String get reportAddPhotoCamera => '拍照';

  @override
  String get reportAddPhotoGallery => '从相册选择';

  @override
  String get reportPhotoFailed => '照片添加失败，请重试';

  @override
  String get reportEmptyHint => '暂无检测记录。完成红外、反光、WiFi、蓝牙或磁力检测后，结论会自动汇总到这里。';

  @override
  String get reportDetails => '检测明细';

  @override
  String get reportClear => '清空记录';

  @override
  String get reportExporting => '正在生成 PDF…';

  @override
  String get reportExportPdf => '导出 PDF 并分享';

  @override
  String get reportLocalNote => '报告在本地生成并通过系统分享面板发送，不会上传到任何服务器。';

  @override
  String reportSummary(Object count, Object riskCount) {
    return '$count 项检测 · $riskCount 项风险/存疑';
  }

  @override
  String get reportSummaryDesc => '本次会话的检测结论汇总，可导出为 PDF';

  @override
  String get reportPdfTitle => '隐私相机 · 检测报告';

  @override
  String get reportPdfTime => '生成时间';

  @override
  String get reportPdfPlace => '检查地点';

  @override
  String get reportPdfPlaceEmpty => '未填写';

  @override
  String get reportPdfWifi => 'WiFi';

  @override
  String get reportPdfWifiEmpty => '未连接 WiFi';

  @override
  String get reportPdfPhotos => '现场照片';

  @override
  String reportPdfSummary(Object count, Object risk) {
    return '共 $count 项检测，其中 $risk 项提示风险/存疑。结果仅供参考，非执法证据。';
  }

  @override
  String get reportPdfEmpty => '本次会话暂无检测记录。';

  @override
  String get reportPdfNext => '下一步行动建议';

  @override
  String get reportPdfAction1 => '拍照留存可疑设备位置与房间全貌，不触碰、不拆卸';

  @override
  String get reportPdfAction2 => '告知酒店前台 / 房东，并要求书面记录或换房';

  @override
  String get reportPdfAction3 => '拨打 110 报警，由警方到场取证与司法鉴定';

  @override
  String get reportPdfDisclaimer =>
      '免责声明：红外/反光检测依赖手机 CMOS 对红外光的敏感度，WiFi 扫描仅能发现当前局域网内联网设备，磁力与蓝牙检测仅作辅助。本报告不构成任何法律证据，请以警方取证为准。';

  @override
  String get reportPdfFooter => '由「隐私相机」生成 · 数据仅在本地处理';

  @override
  String get riskSafe => '通过';

  @override
  String get riskLow => '存疑';

  @override
  String get riskHigh => '风险';

  @override
  String get featureIr => '红外检测';

  @override
  String get featureLens => '镜头反光扫描';

  @override
  String get featureWifi => 'WiFi 网络扫描';

  @override
  String get featureBluetooth => '蓝牙扫描';

  @override
  String get featureMagnet => '磁力检测';
}
