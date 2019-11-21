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
            let path = myArgs["path"] as? String,
        let options = myArgs["options"] as? NSDictionary {
            
            let optionDownload =
                (options.object(forKey: "option_download") as? String == "1") ? true : false
            
            let optionTransform =
                (options.object(forKey: "option_transform") as? String == "1") ? true : false
            
            let privacy =
                (options.object(forKey: "privacy") as? String == "1") ? true : false
        
            Publitio.shared.filesCreate(
                localMediaPath: path,
                mimeType: .mov,
                fileUrl: nil,
                publicId: nil,
                title: nil,
                description: nil,
                tags: nil,
                privacy: privacy,
                optionDownload: optionDownload,
                optionTransform: optionTransform,
                optionAd: nil,
                completion: { (success, publitioResult) in
                DispatchQueue.main.async {
                    if (success) {
                        result(publitioResult)
                        return
                    } else {
                        let error = (publitioResult as! [String : AnyObject])["error"];
                        let message = (error as! [String : AnyObject])["message"];
                        let code = (error as! [String : AnyObject])["code"];
                        result(FlutterError(code: "PUBLITIO_ERROR",
                        message: message as! String,
                        details: nil))
                    }
                }
            })
        } else {
          result("iOS could not extract flutter arguments in method: (sendParams)")
        }
    }
  }
}
