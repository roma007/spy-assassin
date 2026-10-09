# AGENTS.md — 项目约定（供 opencode 等 AI 助手遵循）

## 「提交」约定

用户说「提交」（或「提交到仓库」）时，执行固定流程：

1. 在 `/Users/mengfeng/我的文档/源码/Security Camera`（真实项目，含中文路径）执行：
   - `git add -A && git commit -m "<中文、简短、描述性消息>"`
2. 依次推送到两个远端：
   - GitHub：`git push origin main`（URL `git@github.com:roma007/spy-assassin.git`，SSH 走 `ssh.github.com:443`）
   - Gitee：`git push gitee main`（URL `git@gitee.com:roma007007/spy-assassin.git`）
3. 推送 GitHub 后，Actions 工作流 `.github/workflows/build_apk.yml` 会自动构建 Android APK。
   完成后告知用户：去 GitHub Actions 页面（https://github.com/roma007/spy-assassin/actions）下载 `app-release-apk` 产物安装。
   （仓库为公共仓库，无需登录也能看运行结果；如可用 `gh` 则用 `gh run watch` 跟踪。）

注意：提交前先 `git status` / `git diff` 核对，只提交预期文件；绝不提交密钥/证书/.env。

## 远程仓库

- `origin` = GitHub `git@github.com:roma007/spy-assassin.git`
- `gitee` = Gitee `git@gitee.com:roma007007/spy-assassin.git`（镜像，不触发构建）
- SSH 配置在 `~/.ssh/config`（GitHub 走 443）。

## 项目与构建要点

- 真实项目路径含中文，**`flutter analyze` / `flutter test` 不能直接在真实目录跑**。
  验证流程：把真实目录的 `lib/`、`packages/`、`test/`、`pubspec.yaml` 拷贝到 ASCII 路径
  `/var/folders/_t/4h8d1ftd4cq9cn64g4c9t8780000gn/T/opencode/pc_analyze`，在那里
  `flutter pub get && flutter gen-l10n && flutter analyze && flutter test`。
- l10n：新增 ARB 键后必须显式 `flutter gen-l10n`（`flutter pub get` 不会重新生成）。
- iOS 部署（如需）：`flutter build ios --release` → `xcrun devicectl device install app`
  → `xcrun devicectl device process launch`。设备：iPhone XS Max，ID `1D4B63FE-82F6-5C8B-9C7F-DAA006E0B13D`，
  bundle `com.spyassassin.app`，Team `R2TCRBA6NZ`。
- 原生加速内核：`packages/spot_detector`（FFI + C）。iOS 用 CocoaPods（已删 Package.swift），
  Android 用 CMake。本机无 Android SDK/NDK，Android 只能靠 CI 验证。
- 真实 IAP 已接入：`lib/core/pro/iap_store.dart`（in_app_purchase）+ `iap_config.dart`（产品 ID）。
  上线前需在 App Store Connect / Google Play Console 创建产品 `com.spyassassin.app.pro.monthly` / `.yearly`。
  本地模拟解锁（`ProStore.unlock()`）仅保留在 `kDebugMode` 付费墙里。
- **商业化模型（2026-08-12 定稿，`docs/产品方案.md` §5 已同步）**：全部检测工具免费无限次使用 + PDF 报告免费；
  扫描历史免费保留最近 5 份；Pro（月/年订阅）解锁无限历史存档 + 后续 AI 高级识别。
  已无每日限次/扣次机制（旧 `ProStore.consumeUse()`/`maxFreePerDay` 已删除）——任何关于「限次/每日 5 次/扣次」的结论都是过时的。
- 验证前必须把 `assets/` 一并拷贝到临时目录（PDF 内嵌字体 `assets/fonts/`），否则 `flutter test` 报 asset 缺失。
