// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => '间谍刺客 - 隐藏摄像头检测';

  @override
  String get privacyPromiseBanner => '无账号 · 无广告 · 无云上传 · 数据不落盘，全程本地检测';

  @override
  String get proTitle => 'Pro 版';

  @override
  String get proSubtitle => '无限历史存档 + AI 高级识别';

  @override
  String get proUnlock => '立即解锁';

  @override
  String get proUnlocked => 'Pro 已激活';

  @override
  String get proUpgradePrompt => '升级 Pro：解锁无限历史存档与后续 AI 高级识别功能。';

  @override
  String get proPlanMonthly => '月度';

  @override
  String get proPlanYearly => '年度';

  @override
  String get proPlanMonthlySub => '随时取消';

  @override
  String get proPlanYearlySub => '最划算，送 2 个月';

  @override
  String get proBestValue => '超值';

  @override
  String get proRestore => '恢复购买';

  @override
  String get proRestoreEmpty => '未找到可恢复的购买记录';

  @override
  String get proPurchasing => '正在处理…';

  @override
  String get proStoreUnavailable => '商店暂不可用，请稍后重试';

  @override
  String get proIapError => '购买失败，请稍后重试';

  @override
  String proActiveUntil(Object date) {
    return '有效期至 $date';
  }

  @override
  String get proLocalSimUnlock => '开发者 · 本地模拟解锁';

  @override
  String get navTabIr => '红外';

  @override
  String get navTabWifi => 'WiFi';

  @override
  String get navTabMagnet => '磁力';

  @override
  String get navTabMore => '更多';

  @override
  String get tabTitleCheck => '防偷拍';

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
  String get checkStep2Min => '约 2 分钟';

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
  String get checkTrackerTitle => '随身防跟踪';

  @override
  String get checkTrackerDesc => '扫描周边蓝牙设备，识别 AirTag 等追踪器是否跟着你';

  @override
  String get checkDone => '检查完成，已获得安心。';

  @override
  String get checkInProgress => '按顺序完成全部步骤检查，全程约 7 分钟';

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
  String get checkAllFourDone => '所有步骤检查全部完成';

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
      '能访问公网(1.1.1.1:80)，但无法访问局域网——说明手机与局域网设备被隔离或屏蔽。最常见原因：① 手机开着 VPN/代理（会屏蔽局域网，请关闭）；② 手机连的是路由器的「访客网络」或开启了「设备隔离/AP 隔离」；③ iOS 本地网络权限仍未生效（设置 > 隐私与安全性 > 本地网络，确认「间谍刺客」开关为绿色；不行就重启手机后重试）。';

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
  String get wifiDetailHostname => '设备名称';

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
  String get wifiDetailRtsp => 'RTSP 指纹';

  @override
  String get wifiDetailHttp => 'HTTP 指纹';

  @override
  String get wifiNoMacIos => 'iOS 无法读取 MAC 地址，不含硬件厂商线索';

  @override
  String get wifiStaleChip => '可能休眠';

  @override
  String get wifiStaleSection => '休眠/未响应（历史记录）';

  @override
  String wifiStaleLastSeen(Object time) {
    return '上次在线 $time';
  }

  @override
  String get wifiStaleNote => '本次扫描未响应，可能处于休眠。来自上次扫描记录。';

  @override
  String wifiStaleCount(Object count) {
    return '另有 $count 台休眠/未响应（历史记录）';
  }

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
  String get moreHistoryTitle => '扫描历史';

  @override
  String get moreHistorySubtitle => '已保存的检查记录与现场照片';

  @override
  String get moreGuide => '排查指南';

  @override
  String get moreGuideSubtitle => '常见隐藏位置与反偷拍技巧';

  @override
  String get guideTitle => '排查指南';

  @override
  String get guideIntro => '先视觉排查，再用工具逐个验证。以下是最常见的藏匿位置，建议按顺序过一遍。';

  @override
  String get guideCta => '发现可疑？查看下一步行动';

  @override
  String get guideHow => '怎么看：';

  @override
  String get guideHint => '提示：';

  @override
  String get guideP1Title => '烟雾报警器';

  @override
  String get guideP1Check => '站在正下方从下往上 / 侧向观察，金属与塑料接缝处常有针孔';

  @override
  String get guideP1Hint => '黑色机身里最容易藏针孔镜头，务必贴近多看几个角度';

  @override
  String get guideP2Title => '插座孔与插线板';

  @override
  String get guideP2Check => '观察插座面板是否有不自然的孔洞或凸起，用手电照内部';

  @override
  String get guideP2Hint => 'USB 插口、充电口、排插侧面都是藏镜头高发区';

  @override
  String get guideP3Title => '镜子（双面镜）';

  @override
  String get guideP3Check => '指甲贴镜面：指甲与倒影之间有空隙为普通镜，无空隙需警惕';

  @override
  String get guideP3Hint => '双面镜后方可能是一间房，但镜子本身也能藏微型镜头';

  @override
  String get guideP4Title => '装饰画';

  @override
  String get guideP4Check => '检查画框四周、挂画背后的缝隙，是否有多余的洞';

  @override
  String get guideP4Hint => '画框暗格是经典藏匿点，轻轻按压边框感受是否有异';

  @override
  String get guideP5Title => '空调出风口';

  @override
  String get guideP5Check => '对出风口内部用手电照射，观察格栅间是否有异常反光体';

  @override
  String get guideP5Hint => '挂机空调顶部与墙体之间也容易塞入微型设备';

  @override
  String get guideP6Title => '床头电子钟 / 台灯';

  @override
  String get guideP6Check => '屏幕面板、按键缝隙、底座是否有额外的孔';

  @override
  String get guideP6Hint => '紧贴床头的电子设备既是隐蔽点又贴近你，优先级最高';

  @override
  String get guideP7Title => '路由器 / 电视盒子';

  @override
  String get guideP7Check => '观察 LED 是否有异常的额外指示灯或针孔';

  @override
  String get guideP7Hint => '路由器常被改装成“合法外衣”藏摄像头';

  @override
  String get guideP8Title => '花盆 / 绿植';

  @override
  String get guideP8Check => '检查花盆、土壤上方枝叶间是否有异物';

  @override
  String get guideP8Hint => '叶片遮挡下的微型镜头很难被直接看到，配合红外扫描';

  @override
  String get guideP9Title => '灯具 / 烟雾探测器';

  @override
  String get guideP9Check => '灯罩内、吊灯连接处、床头壁灯背面逐一检查';

  @override
  String get guideP9Hint => '光源附近的光晕会干扰肉眼，用红外检测扫过更可靠';

  @override
  String get guideP10Title => 'AirTag / 蓝牙追踪器';

  @override
  String get guideP10Check => '打开「随身防跟踪」扫描周边蓝牙，多扫几次并换个位置判断是否有设备一直跟着你';

  @override
  String get guideP10Hint => '追踪器常藏在背包、行李箱、车内；系统自带的未知追踪器提醒也要保持开启';

  @override
  String get quickScanTitle => '一键扫描';

  @override
  String get quickScanSubtitle => '红外 → WiFi → 磁力 → 防跟踪，全自动完成';

  @override
  String get quickScanStepIr => '红外检测（约 20 秒）';

  @override
  String get quickScanStepWifi => 'WiFi 扫描（约 15 秒）';

  @override
  String get quickScanStepMagnet => '磁力检测（约 15 秒）';

  @override
  String get quickScanStepTracker => '防跟踪扫描（约 10 秒）';

  @override
  String get quickScanDone => '一键扫描完成，查看结论';

  @override
  String quickScanRunning(Object step) {
    return '正在执行：$step';
  }

  @override
  String get quickScanStart => '开始一键扫描';

  @override
  String get verdictTitle => '扫描结论';

  @override
  String get verdictSafe => '安全：未发现可疑信号';

  @override
  String get verdictHighRisk => '高风险：疑似隐藏摄像头';

  @override
  String verdictRisk(Object count) {
    return '发现风险：$count 个可疑项';
  }

  @override
  String get verdictViewEvidence => '查看证据明细';

  @override
  String get verdictExportPdf => '导出 PDF';

  @override
  String get verdictNextActions => '下一步行动';

  @override
  String get verdictDone => '完成';

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
  String get settingsLanguageEs => 'Español';

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
  String get settingsDataNote => '所有统计数据与检测报告均保存在本机，不会上传。免费版扫描历史保留最近 5 份。';

  @override
  String get morePrivacyDesign => '隐私优先设计';

  @override
  String get morePrivacyDesc => '所有检测均在本机完成，无需账号，不收集、不上传任何图像或网络数据。';

  @override
  String get reportTitle => '检测报告';

  @override
  String get reportHistoryTitle => '扫描历史';

  @override
  String get reportOpenHistory => '查看全部';

  @override
  String get reportSeal => '完成并保存本次检查';

  @override
  String get historyTitle => '扫描历史';

  @override
  String get historyEmpty => '还没有保存的检查记录。完成检测后，在「检测报告」页点「完成并保存本次检查」即可归档。';

  @override
  String historyProNote(Object count) {
    return '免费版保留最近 $count 份扫描记录，升级 Pro 无限保存';
  }

  @override
  String get historyProUnlimited => 'Pro：扫描记录无限保存';

  @override
  String historyPlace(Object place) {
    return '地点：$place';
  }

  @override
  String get historyOpen => '打开';

  @override
  String get historyDelete => '删除';

  @override
  String get historyDeleteConfirm => '确定删除这份扫描记录？检测明细与现场照片将一并删除，不可恢复。';

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
  String get reportLocalNote =>
      '报告在本地生成并通过系统分享面板发送，不会上传。本次检查会自动保存到本机（免费版保留最近 5 份）。';

  @override
  String reportSummary(Object count, Object riskCount) {
    return '$count 项检测 · $riskCount 项风险/存疑';
  }

  @override
  String get reportSummaryDesc => '本次会话的检测结论汇总，可导出为 PDF';

  @override
  String get reportPdfTitle => '间谍刺客 · 检测报告';

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
  String get reportPdfFooter => '由「间谍刺客」生成 · 数据仅在本地处理';

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

  @override
  String get featureTracker => '防跟踪扫描';

  @override
  String get navTabHub => '反监视';

  @override
  String get tabTitleHub => '反监视中心';

  @override
  String get hubTagline => '检测藏在房间的摄像头，也扫描跟着你的追踪器';

  @override
  String get hubTaglineSub => '防偷拍 · 防追踪，全程本地检测';

  @override
  String get hubRoomCheckTitle => '防偷拍';

  @override
  String get hubRoomCheckSubtitle => '红外 / 镜头反光 / WiFi / 磁力，四步排查隐藏摄像头';

  @override
  String get hubTrackerTitle => '随身防跟踪';

  @override
  String get hubTrackerSubtitle => '扫描周边蓝牙，识别 AirTag 等追踪器是否跟着你';

  @override
  String get trackerTitle => '随身防跟踪';

  @override
  String get trackerIntro =>
      '扫描周边蓝牙设备，识别 AirTag 等已知追踪器。多扫几次、换个位置，可判断是否有设备一直跟着你。全程本地处理，不上传任何数据。';

  @override
  String get trackerStartScan => '开始扫描';

  @override
  String get trackerScanning => '扫描中（约 10 秒）…';

  @override
  String get trackerScanAgain => '再扫一次';

  @override
  String get trackerScanFailed => '扫描失败，请确认已授予蓝牙扫描权限后重试';

  @override
  String trackerRoundsDone(Object count) {
    return '已完成 $count 次扫描';
  }

  @override
  String get trackerRoundsTip => '建议走到房间另一处或门外，再扫一次，确认是否有设备一直跟着你。';

  @override
  String get trackerMoveHint => '已发现追踪器候选。建议先完成定位确认，或继续再扫一次增加可信度。';

  @override
  String get trackerFinish => '完成检查';

  @override
  String get trackerRestart => '重新检查';

  @override
  String get trackerNoTracker => '未发现已知追踪器';

  @override
  String get trackerNoTrackerTip => '继续使用系统自带的未知追踪器提醒，并保持警惕。';

  @override
  String trackerFoundCandidates(Object count) {
    return '发现 $count 个候选';
  }

  @override
  String get trackerSectionTrackers => '追踪器候选';

  @override
  String trackerSectionOthers(Object count) {
    return '其他蓝牙设备（$count）';
  }

  @override
  String get trackerBrandFindMy => 'AirTag / Find My 配件';

  @override
  String get trackerBrandSamsung => '三星 SmartTag';

  @override
  String get trackerBrandTile => 'Tile 追踪器';

  @override
  String get trackerBrandGoogle => 'Google 追踪器';

  @override
  String get trackerMotionRepeated => '疑似同行';

  @override
  String get trackerMotionOnce => '仅本次发现';

  @override
  String get trackerMotionRegular => '普通设备';

  @override
  String get trackerDistanceNear => '很近';

  @override
  String get trackerDistanceMid => '较近';

  @override
  String get trackerDistanceFar => '较远';

  @override
  String get trackerGuidanceTitle => '发现可疑追踪器怎么办';

  @override
  String get trackerGuidance1 => '检查随身物品、包、车内外是否有陌生的小型设备';

  @override
  String get trackerGuidance2 =>
      'AirTag 可用身边任一部 iPhone 打开「查找」App →「物品」，尝试播放声音定位';

  @override
  String get trackerGuidance3 => '不要贸然取下，先拍照留证；如确认被跟踪，请联系警方';

  @override
  String get trackerDisclaimer =>
      '说明：本扫描在前台进行，仅能识别已知品牌的追踪器；与主人手机关联并保持连接的设备可能无法被发现；结果仅供参考，不作为执法证据。';

  @override
  String get trackerSafeTitle => '未发现异常';

  @override
  String get trackerSafeDesc => '本轮未发现已知追踪器。保持警惕，必要时可换个位置再扫一次。';

  @override
  String get trackerRiskTitle => '发现追踪器候选';

  @override
  String trackerRiskRepeated(Object count) {
    return '$count 个设备多次扫描仍在你附近，建议立即排查';
  }

  @override
  String trackerRiskOnce(Object count) {
    return '发现 $count 个追踪器候选，建议按下方指引处置';
  }

  @override
  String trackerReportSummary(
    Object candidates,
    Object repeated,
    Object rounds,
  ) {
    return '防跟踪扫描 $rounds 次，发现追踪器候选 $candidates 个，其中疑似同行 $repeated 个';
  }

  @override
  String get trackerReportSummaryNone => '防跟踪扫描未发现已知追踪器';

  @override
  String get moreTrackerTitle => '防跟踪扫描';

  @override
  String get moreTrackerSubtitle => '识别周边 AirTag / SmartTag 等追踪器';
}
