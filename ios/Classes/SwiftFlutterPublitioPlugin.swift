import Flutter
import UIKit
import Publitio

public class SwiftFlutterPublitioPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "flutter_publitio", binaryMessenger: registrar.messenger())
    let instance = SwiftFlutterPublitioPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    if (call.method == "uploadFile") {
        guard let args = call.arguments else {
          return
        }
        if let myArgs = args as? [String: Any],
            let path = myArgs["path"] as? String {
        
            Publitio.shared.filesCreate(localMediaPath: path, mimeType: .mov, fileUrl: nil, publicId: nil, title: nil, description: nil, tags: nil, privacy: true, optionDownload: true, optionTransform: true, optionAd: nil, completion: { (success, publitioResult) in
                DispatchQueue.main.async {
                    if (success) {
                        result(publitioResult)
                        return
                    } else {
                        result("Publitio.shared.filesCreate success is false")
                    }
                }
            })
        } else {
          result("iOS could not extract flutter arguments in method: (sendParams)")
        }
    }
  }
}
