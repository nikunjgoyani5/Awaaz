import Flutter
import UIKit
import google_mobile_ads
import Photos

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
      let controller = window.rootViewController as! FlutterViewController
      let channel = FlutterMethodChannel(name: "com.example.app/media_scanner", binaryMessenger: controller.binaryMessenger)
      channel.setMethodCallHandler { (call, result) in
           if call.method == "saveVideoToGallery" {
             guard let args = call.arguments as? [String: Any],
                   let path = args["path"] as? String else {
               result(FlutterError(code: "INVALID_ARGUMENTS", message: nil, details: nil))
               return
             }

             self.saveVideoToGallery(path: path, result: result)
           }
         }


//     let factory = ListTileNativeAdFactory()
      let factory = NativeAdFactory()
     FLTGoogleMobileAdsPlugin.registerNativeAdFactory(self, factoryId: "nativeAd", nativeAdFactory: factory)
      
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    private func saveVideoToGallery(path: String, result: @escaping FlutterResult) {
      PHPhotoLibrary.requestAuthorization { status in
        if status == .authorized {
          UISaveVideoAtPathToSavedPhotosAlbum(path, nil, nil, nil)
          result("Video saved")
        } else {
          result(FlutterError(code: "PERMISSION_DENIED", message: "Photo library access denied", details: nil))
        }
      }
    }
}
