# AGENTS.md — 项目约定（供 opencode 等 AI 助手遵循）

## 「提交」约定

用户说「提交」（或「提交到仓库」）时，执行固定流程（**铁律**）：

1. 在 `/Users/mengfeng/我的文档/源码/Security Camera`（真实项目，含中文路径）执行：
   - `git add -A && git commit -m "<中文、简短、描述性消息>"`
   - **提交范围 = 工作区全部待提交修改**，包括**其它对话/其它 AI 产生的修改**（未跟踪文件也要加），
     不筛选、不排除、不询问。**唯一例外**：密钥/证书/.env 绝不提交（发现则排除并立刻告知用户）。
2. **两个远端都要推**（缺一不可）：
   - GitHub：`git push origin main`（URL `git@github.com:roma007/spy-assassin.git`，SSH 走 `ssh.github.com:443`）
   - Gitee：`git push gitee main`（URL `git@gitee.com:roma007007/spy-assassin.git`）
3. 推送 GitHub 后，Actions 工作流 `.github/workflows/build_apk.yml` 会自动构建 **Android 安装包**。
   完成后告知用户：去 GitHub Actions 页面（https://github.com/roma007/spy-assassin/actions）下载 `app-release-apk` 产物安装。
   （仓库为公共仓库，无需登录也能看运行结果；如可用 `gh` 则用 `gh run watch` 跟踪并在完成后回报结论。）

注意：提交前仍要快速核对 `git status` / `git diff` 是否存在密钥/证书/.env（只做排除密钥这一件事，其余一律提交）。

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
- **iOS build 号已全自动**：`ios/Runner.xcodeproj` 的 Runner target 末尾有构建阶段
  `Auto Build Number`（ID `A1B2C3D4E5F60718293A4B5C`），Release 构建时把 `CFBundleVersion`
  写成 `date -u +%s`（Unix 秒，单调递增、<2³¹），**无需再手动 bump**。
  ⚠️ 上传 ASC 时**必须取消勾选** Xcode Organizer 的「Manage Version and Build Number」，
  否则 Xcode 会改写它（历史上 3→8 的错位就是这么来的）；`pubspec.yaml` 的 `+N` 对 iOS 已不生效
  （Android 的 `versionCode` 仍走它）。营销版本号（如 1.0.0）仍需手动维护。
  改动该 pbxproj 后需**重启 Xcode**（勿让其用旧的内存副本覆盖）。
- 原生加速内核：`packages/spot_detector`（FFI + C）。iOS 用 CocoaPods（已删 Package.swift），
  Android 用 CMake。本机无 Android SDK/NDK，Android 只能靠 CI 验证。
- 真实 IAP 已接入：`lib/core/pro/iap_store.dart`（in_app_purchase）+ `iap_config.dart`（产品 ID）。
  上线前需在 App Store Connect / Google Play Console 创建产品 `…pro.weekly1` / `.monthly2` / `.yearly2`（均为自动续期订阅）。
  已无本地模拟解锁入口（`ProStore.unlock()` 已删除），严格走真实 IAP 交易。
- **商业化模型（2026-10-15 改为 Peek 模式，`docs/产品方案.md` §5 已同步）**：
  免费层仅 1 次完整检测扫描；扫描结果明细模糊显示；PDF 导出锁定；历史保留最近 5 份。
  Pro（周/月/年订阅）解锁无限扫描、完整结果明细、PDF 报告、无限历史。
  旧「全部检测工具免费无限次 + PDF 免费」结论已过时。
- 验证前必须把 `assets/` 一并拷贝到临时目录（PDF 内嵌字体 `assets/fonts/`），否则 `flutter test` 报 asset 缺失。
