import Flutter
import UIKit

/// 引用 C 检测内核符号，防止 Release 构建（-dead_strip）将未被引用的
/// sd_detect 从主可执行文件中剥离，确保 Dart 侧 DynamicLibrary.process()
/// 能取到该符号。仅在注册时用空参数安全调用一次（网格过小直接返回 0）。
@_silgen_name("sd_detect")
func sdDetectKeepalive(
  _ yPlane: UnsafePointer<UInt8>?,
  _ width: Int32,
  _ height: Int32,
  _ rowStride: Int32,
  _ step: Int32,
  _ sensitivity: Float,
  _ minCircularity: Float,
  _ minSize: Int32,
  _ maxSize: Float,
  _ spotsOut: UnsafeMutablePointer<Float>?,
  _ spotsCapacity: Int32,
  _ spotsCount: UnsafeMutablePointer<Int32>?,
  _ gridOut: UnsafeMutablePointer<Float>?,
  _ gridWidth: UnsafeMutablePointer<Int32>?,
  _ gridHeight: UnsafeMutablePointer<Int32>?
) -> Int32

public class SpotDetectorPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    var count: Int32 = 0
    _ = sdDetectKeepalive(
      nil, 1, 1, 1, 1, 3.0, 0.5, 2, 1.0e9, nil, 0, &count, nil, nil, nil)
    let channel = FlutterMethodChannel(name: "spot_detector", binaryMessenger: registrar.messenger())
    let instance = SpotDetectorPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getPlatformVersion":
      result("iOS " + UIDevice.current.systemVersion)
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}
