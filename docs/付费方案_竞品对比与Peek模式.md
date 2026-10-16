# 付费方案：美区 iOS 反偷拍竞品对比与 Peek 模式方案

> 数据抓取日：2026-10-15（美区 iOS App Store 现价）
> 状态：**已实施（2026-10-15 定为 Peek 模式，代码已改；本文档为决策依据与回溯）**
>
> 落地情况以代码为准：`lib/core/pro/iap_config.dart`（周/月/年三档）、`lib/core/pro/pro_store.dart`
> （`freeScanQuota = 1`）、`lib/features/report/report_screen.dart` 与 `lib/features/check/verdict_screen.dart`
> （PDF 门控）。**终身档未实施。**
>
> ⚠️ **定价以《产品方案.md》§5 为准**：美区 **$0.99/周、$2.99/月、$19.99/年，无试用**（低价走量）。
> 本文 §5.1、§5.4 原推荐的 $8.99/周 + 3 天试用为**早期研究锚点，已被产品决策取代**，仅作回溯。

---

## 一、竞品格局：谁是用户量/收入最大的

该品类很小——没有一款专职反偷拍 App 进入美区 Utilities 榜 Top 100，流量几乎全部来自关键词搜索。

### 1.1 头部排名（美区评分数 = 用户量代理指标）

| 排名 | 产品（开发者） | 美区评分量 / 分数 | iOS 月收入估算 | 月下载估算 |
|---|---|---|---|---|
| 收入第1 | Hidden Camera Detector – Peek（土耳其 88 Tech/Kupertino） | 16,692 / 4.4 | **$200K–300K** | 100K–200K |
| 邻近巨头 | Fing（网络扫描器，含摄像头设备发现） | 116,451 / 4.7 | ~$90K | ~200K |
| 用户量第2 | Cam Detector App: Home Security（AppNexus） | 15,992 / 4.4 | ~$10K | ~1K |
| 3 | Hidden Spy Camera Finder Pro（波兰 DREAMTEAM） | 11,840 / 4.4 | <$5K | <5K |
| 4 | Camera Detector App（Om Solutions） | 9,990 / 4.4 | — | — |
| 5 | FindSpy（新加坡 KAIN SUITE） | 4,077 / 4.4 | — | — |
| 6 | #1 Hidden Camera Detector（Gibco） | 3,744 / 4.2 | — | — |
| 老牌掉队 | Hidden Camera Detector (LSC)，自称累计 200 万下载 | 1,865 / 3.6 | — | 搜索排名跌至 #21 |
| 新品 | NoSpy（2025-07 上线） | 159 / 4.8 | — | — |
| 买断型 | DontSpy 2（$3.99 买断，无订阅无广告） | 96 / 2.4 | — | — |

### 1.2 关键洞察

- **评分数最大 ≠ 收入最高**：Peek 用 1.6 万评分做到 $200K+/月，AppNexus 同样 1.6 万评分只有 $10K/月，差异在付费墙激进度。
- 收入数据来源：IOSMRR / AppRank / TrendApps 模型分档估算，Peek 三源为 $200K/$200K/$300K。Sensor Tower / data.ai 精确数字需付费库。

---

## 二、付费功能对比矩阵

✅ 免费可用 ｜ 🔒 付费解锁 ｜ ➖ 无此功能

| 付费墙锁定点 | Peek（收入王） | LSC（老牌） | NoSpy（口碑最好） | AppNexus | DREAMTEAM | Om | FindSpy | HiddenGuard（新品） | **我们（现状）** |
|---|---|---|---|---|---|---|---|---|---|
| 基础检测功能 | 🔒 扫描限时，结果模糊需付费 | 🔒 3 天试用后全部工具锁定 | 🔒 免费仅 5 扫/天 | 🔒 订阅解锁全部 | 🔒 Pro Access | 🔒 3 天试用后锁 | 🔒 Pro | 🔒 **仅 1 次免费完整扫描** | ✅ **无限免费** |
| Wi-Fi/网络设备扫描 | 🔒 | 🔒 | 含在 5 扫内 | ✅/🔒 | — | — | — | ✅ 开局免费 1 次 | ✅ |
| 蓝牙/AirTag 追踪器 | ✅/🔒 | 🔒 | 🔒 Pro | 🔒 | — | — | — | 🔒 | — |
| 磁场 EMF | 🔒 | 🔒 | 含在 5 扫内 | 🔒 | ➖ | ➖ | 功能有 | 🔒 | ✅ |
| 红外 IR | 🔒 | 🔒 | 含在 5 扫内 | 🔒 | ➖ | ➖ | 功能有 | 🔒 | ✅ |
| AI 镜头识别 | ✅/🔒 | 🔒 | 核心卖点 | ➖ | ➖ | ✅ | ➖ | ➖ | 🔜 已规划 Pro |
| 详细报告 / PDF 导出 | 报告付费 | ➖ | 🔒 完整历史 | ➖ | 🔒 Scan History | 🔒 Scan History | ➖ | 🔒 **reports + PDF export 明文为 Pro** | ✅ **完全免费** |
| 扫描历史 | 付费 | 跨地点追踪付费 | 🔒 完整历史 | ➖ | 🔒 | 🔒 | ➖ | ➖ | 🔒 **仅最近 5 份** |
| 去广告 | 🔒 | 无广告证据 | 🔒 | — | — | — | — | 🔒 | 无广告 |
| 场景预设/专家指南 | ➖ | 专家视频永久免费 | ➖ | 指南付费 | 🔒 Exclusive Guides | ➖ | ➖ | ➖ | ✅ 免费 |
| 差异化付费功能 | 多 SKU 价格歧视 | — | 精度阈值 | 公共摄像头实时画面、RTSP 连接 | 指南 | — | 积分包（$4.99/20 个） | 音频 FFT、流量检查 | — |

### 核心结论

**在全部 9 款主要竞品中，没有任何一家把"历史存档容量"作为唯一付费点。** 我们当前唯一付费墙（超 5 份历史）在品类里没有先例。行业最主流的三个收费点是：①扫描能力本身（次数/时长/模式）②报告导出 ③扫描历史——我们前两个全免费、第三个只挡边缘场景。

---

## 三、价格锚点（美区，2026-10-15 实抓）

| 档位 | 品类主流区间 | 收入王 Peek | Fing | 我们（现状） |
|---|---|---|---|---|
| 周订阅 | $2.99–$12.99（主力 $4.99–$7.99） | $8.99–$9.99 | 无周档 | **无周档** |
| 月订阅 | $5.99–$12.99 | $9.99 | $7.99 | 有产品 ID，价格未配置 |
| 年订阅 | $14.99–$59.99（主力 $29.99–$39.99） | $29.99/季 | $69.99 | 有产品 ID，价格未配置 |
| 终身买断 | $9.99–$79.99（主力 $49.99–$69.99） | $59.99–$69.99 | 无 | **无** |

- **周订阅是品类收入机器**：折合年化 $260–$415，Peek 高收入主要靠 $9.99/周 × 忘记取消的试用用户。
- App 工厂普遍挂 5–12 个混乱 SKU 做 A/B 和价格歧视。

---

## 四、付费墙打法的四种模式

1. **焦虑触发型（收入最高，Peek/HiddenGuard）**：免费跑 1 次或限时扫描→结果/报告锁死→$4.99–9.99/周订阅。
2. **每日配额型（NoSpy）**：每天 5 次完整扫描，超出付费。口碑最好（4.8 分、评测 9.4 分），但变现温和。
3. **试用全功能型（LSC/Om）**：3 天内全部工具免费用，到期转订阅。老牌 LSC 已掉队。
4. **买断/工具型（DontSpy 2、Fing 免费层）**：$3.99 买断或核心网络扫描永久免费，靠高级功能订阅。

---

## 五、推荐方案：Peek 模式（收入最高）

> 该模式与项目 2026-08-12 定稿的「检测工具免费无限次 + PDF 免费」直接冲突，需产品确认。

### 5.1 模式核心

用户焦虑时刻（扫到可疑设备）→ 1 次免费扫描 → 结果/报告/PDF 全部锁死 → 周订阅（原推荐 $8.99/周 + 3 天试用；**实际采用 $0.99/周、无试用**，见文首状态说明）。

### 5.2 与现定稿的冲突

| 定稿条款（产品方案.md §5） | 本方案 |
|---|---|
| 全部检测工具免费无限次 | ❌ 免费仅 1 次完整扫描，之后锁 |
| PDF 报告免费 | ❌ PDF 导出是 Pro 功能 |
| 历史免费保留 5 份 | 维持，Pro 无限 |

### 5.3 免费层 vs Pro 功能清单

| 功能 | 免费层 | Pro |
|---|---|---|
| Wi-Fi / 蓝牙 / AirTag / EMF / IR / AI 检测 | ✅ 第 1 次完整扫描免费 | ✅ 无限 |
| 扫描次数 | 🔒 仅 1 次完整扫描 | ✅ 无限 |
| 详细结论报告 | 🔒 模糊显示（不显示设备明细） | ✅ 完整明细 |
| PDF 导出 / 分享 | 🔒 锁 | ✅ |
| 扫描历史 | 🔒 仅最近 5 份 | ✅ 无限 |
| 场景预设 / 引导式检查 | 🔒 锁 | ✅ |
| 去广告 | 无广告 | — |

### 5.4 IAP 档位与价格（美区锚点）

**实施状态（2026-10-16）**：已在 `lib/core/pro/iap_config.dart` 落地 **周 / 月 / 年** 三档
（`weekly1` / `monthly2` / `yearly2`，同一订阅组）。**终身买断档未实施**（表中第 4 行仅作价格锚点参考，代码里没有对应产品）。

| 档位 | 价格（**已实施**） | 作用 | 产品 ID |
|---|---|---|---|
| 周订阅 Weekly | **$0.99/周**（主力，无试用） | 主力档（付费墙默认选中） | ✅ `pro.weekly1` |
| 月订阅 Monthly | $2.99/月 | 中间锚 | ✅ `pro.monthly2` |
| 年订阅 Yearly | **$19.99/年** | 主推（比周划算，引导长期） | ✅ `pro.yearly2` |
| 终身买断 Lifetime | ~~$69.99~~ | 高锚定 | ❌ 未实施 |

> **早期研究锚点（已被取代，勿用）**：$8.99/周 + 3 天免费试用、$9.99/月、$49.99/年、$69.99 终身。
> 产品最终采用**低价走量**：$0.99/周、$2.99/月、$19.99/年，**无试用**。定价单一来源 = `docs/产品方案.md` §5。

> 注：文档早期写「3 天免费试用后自动续订」，**当前代码未配置任何试用**（付费墙无试用说明）。
> 若要加试用，须在 App Store Connect 的订阅上配「推介优惠/免费试用」，并同步付费墙文案（3.1.2 要求披露）。
> 具体价格上线前在 App Store Connect 配置，代码里只需产品 ID；付费墙取商店实时价，改价无需改代码。

### 5.5 付费墙触发点（代码改动清单）

1. **检测入口拦截**：在每次扫描前判断剩余免费次数，第 2 次起弹付费墙
   - 检测流程入口接入 `ensureScanAccess`（已实施于 `ir/lens/magnet/wifi/bluetooth/tracker/quick_scan` 各入口）
   - 免费次数用 SharedPreferences 持久化
2. **PDF 导出拦截**：`report_screen.dart` 和 `verdict_screen.dart` 的 `_exportPdf` 调用前加 `ensureAccess`（已实施）
3. **报告明细锁定**：免费用户看到结论，但明细/证据列表显示 Pro 占位（已实施）
4. **历史 5 份限制**：`report_archive.dart` 维持（已实施，`freeKeepCount = 5`）
5. **IAP 配置**：`iap_config.dart` 增加 weekly 档（已实施；**lifetime 未实施**）
6. **付费墙文案**：`upgrade_dialog.dart` 展示周/月/年三档（已实施；无终身档）
7. **文档同步**：`docs/产品方案.md` §5 商业化模型改写

### 5.6 风险提示

- **口碑风险**：Peek 评分 4.4，差评集中在"免费版结果模糊、退订困难"。该模式 ARPU 高但 NPS 低，不适合做品牌型产品。
- **审核风险**：周订阅 + 3 天试用自动续订是 Apple 允许的，但免费层必须能真正完成一次有价值的检测，否则可能被拒。
- **定位冲突**：项目定位"取证安全助手"，纯收割模式可能损害长期信任。NoSpy 靠"诚实免费层"拿到品类最高口碑，是另一条路。

---

## 六、待确认决策

请选择以下之一（确认后实施）：

- **A. 纯 Peek 模式**：推翻"检测免费无限 + PDF 免费"定稿，锁检测 + 锁 PDF，加周订阅/终身档。收入最高，但口碑风险大。
- **B. 改良版**：保留检测免费无限，只锁 PDF/详细报告/历史，加周订阅/终身档。不违背定稿，收入打折扣但口碑可控。
- **C. 维持现状**：仅锁 5 份以上历史。收入最弱但完全符合定稿。

---

## 七、主要来源（均 2026-10-15 访问）

- Apple 官方：[iTunes Search/Lookup API（美区）](https://itunes.apple.com/lookup?id=1571925628&country=us)、[美区 Utilities 畅销榜 RSS](https://itunes.apple.com/us/rss/topgrossingapplications/limit=200/genre=6002/json)
- 收入估算：[AppRank – Peek](https://apprank.io/hidden-camera-detector-peek-5628)、[IOSMRR Utilities 榜](https://iosmrr.com/?category=utilities&type=apps&page=2)、[TrendApps – Peek](https://trendapps.dev/app/ios/1571925628/)
- App Store 美区页面：[Peek](https://apps.apple.com/us/app/id1571925628)、[LSC](https://apps.apple.com/us/app/hidden-camera-detector/id532882360)、[Fing](https://apps.apple.com/us/app/fing-network-scanner/id430921107)、[DREAMTEAM](https://apps.apple.com/us/app/id1560989782)、[AppNexus](https://apps.apple.com/us/app/id6450695466)、[Om Solutions](https://apps.apple.com/us/app/id6449518978)、[FindSpy](https://apps.apple.com/us/app/id6469943309)、[Gibco](https://apps.apple.com/us/app/id1665597557)、[NoSpy](https://apps.apple.com/us/app/nospy-hidden-camera-finder/id6747890850)、[DontSpy 2](https://apps.apple.com/us/app/dontspy-2-detector/id959086373)、[HiddenGuard](https://apps.apple.com/us/app/hidden-camera-scan-detector/id6773911350)
- 价格与用户口径：[Fing 官网/FAQ](https://www.fing.com/faq/)、[hiddensec 2026 实测](https://hiddensec.com/reviews/best-app/)（第三方，仅作功能旁证）
