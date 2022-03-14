import Flutter
import UIKit

public class SwiftRForbidshotPlugin: NSObject, FlutterPlugin {
    
    var channel:FlutterMethodChannel? = nil
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "r_forbidshot", binaryMessenger: registrar.messenger())
        let instance = SwiftRForbidshotPlugin()
        instance.channel = channel
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "iosShotStatus":
            self.iosShotStatus(call,result: result)
            break
        case "forbidshot":
            let arguments = call.arguments as! Dictionary<String,Any>
            let isOpen = arguments["isOpen"] as! Bool
            if(isOpen){
                //截屏通知
                NotificationCenter.default
                    .addObserver(self, selector: #selector(screenshots), name: UIApplication.userDidTakeScreenshotNotification, object: nil)
                //屏幕变化
                if #available(iOS 11.0, *) {
                    NotificationCenter.default
                        .addObserver(self, selector: #selector(captured), name: UIScreen.capturedDidChangeNotification, object: nil)
                } else {
                    // Fallback on earlier versions
                }
            }else{
                //截屏通知
                NotificationCenter.default.removeObserver(self, name: UIApplication.userDidTakeScreenshotNotification, object: nil)
                //屏幕变化
                if #available(iOS 11.0, *) {
                    NotificationCenter.default.removeObserver(self, name: UIScreen.capturedDidChangeNotification, object: nil)
                } else {
                    // Fallback on earlier versions
                }
            }
            
            result(nil)
            break
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    @objc func captured(){
        if #available(iOS 11.0, *) {
            channel?.invokeMethod("iosCapturedStatus", arguments: UIScreen.main.isCaptured)
        } else {
            channel?.invokeMethod("iosCapturedStatus", arguments: false)
        }
    }
    @objc func screenshots(){
        channel?.invokeMethod("iosScreenShots", arguments: true)
    }
    
    private func iosShotStatus(_ call: FlutterMethodCall, result: @escaping FlutterResult){
        let src = UIScreen.main
        if #available(iOS 11.0, *) {
            result(src.isCaptured)
        } else {
            result(false)
        }
    }
}
