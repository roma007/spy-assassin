import 'package:permission_handler/permission_handler.dart';

/// 权限申请封装：全部按需申请、拒绝后提供"去设置"引导。
class PermissionHelper {
  /// 请求相机权限，返回是否已授权。
  static Future<bool> requestCamera() async {
    final status = await Permission.camera.request();
    return status.isGranted;
  }

  /// 本地网络权限（iOS 14+）无公开 API，系统在首次访问局域网时自动弹窗，
  /// 这里仅返回 true，由后续扫描结果判断是否可用。
  static Future<bool> requestLocalNetwork() async => true;

  /// 请求定位权限（Android WiFi 扫描必需）。
  static Future<bool> requestLocation() async {
    final status = await Permission.locationWhenInUse.request();
    return status.isGranted;
  }

  /// 请求蓝牙权限。
  static Future<bool> requestBluetooth() async {
    final status = await Permission.bluetoothScan.request();
    if (status.isGranted) {
      await Permission.bluetoothConnect.request();
    }
    return status.isGranted;
  }

  /// 全部拒绝时，引导用户去系统设置开启。
  static Future<void> openSettings() => openAppSettings();
}
