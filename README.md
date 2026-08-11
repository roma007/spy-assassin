# 隐私相机（Privacy Camera）

住酒店 / 在家查找隐藏摄像头的隐私检测工具。全程本地处理：无账号、无广告、无云上传。

[![Android Build](https://github.com/roma007/security-Camera/actions/workflows/build_apk.yml/badge.svg)](https://github.com/roma007/security-Camera/actions/workflows/build_apk.yml)

## 功能

- **房间检查（Room Check）**：4 步引导流程，汇总红外 / 镜头反光 / WiFi / 磁力 / 蓝牙检测结论，一键导出检测报告
- **红外检测**：FFI + C 检测内核（`packages/spot_detector`），实时找镜头红外点，≥24 FPS
- **镜头反光扫描**：手电同轴光查找镜头回反射光斑
- **WiFi 扫描**：局域网设备发现 + 常用端口探测
- **磁力计检测**：近距贴物扫描 + 振动提醒
- **蓝牙扫描**：辅助排查周边可疑蓝牙设备
- **多语言**：简体中文 / English / 한국어，可手动切换或跟随系统
- **隐私设计**：全部数据仅本机处理，统计与检测记录不出设备

## 技术栈

- Flutter（iOS + Android），本地已验证并部署到 iPhone
- 原生加速：FFI + C 检测内核（iOS CocoaPods / Android CMake）
- i18n 使用 gen-l10n（ARB 三语）

## 构建

Android 安装包由 GitHub Actions 在每次 push 到 `main` 时自动构建（见下方 Actions 页面下载 APK）：

```bash
flutter pub get
flutter analyze
flutter test
flutter build apk --release   # 产物：build/app/outputs/flutter-apk/app-release.apk
```

## 仓库

- GitHub：https://github.com/roma007/security-Camera
- Gitee（镜像）：https://gitee.com/roma007007/security-camera

## License

[MIT](LICENSE) © 2026 roma007
