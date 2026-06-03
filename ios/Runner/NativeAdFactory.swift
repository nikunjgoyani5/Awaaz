import GoogleMobileAds
import UIKit
import google_mobile_ads

class NativeAdFactory: FLTNativeAdFactory {
    func createNativeAd(
        _ nativeAd: GADNativeAd,
        customOptions: [AnyHashable : Any]? = nil
    ) -> GADNativeAdView {
        guard let adView = Bundle.main.loadNibNamed("NativeFullAds", owner: nil, options: nil)?.first as? GADNativeAdView else {
            // Log error before crashing (for debugging purpose)
            print("⚠️ Error: Could not load NativeFullAds.xib or cast it to GADNativeAdView.")
            fatalError("Could not load NativeFullAds.xib")
        }

        // Safely unwrap and set values with optional chaining
        if let headline = nativeAd.headline {
            (adView.headlineView as? UILabel)?.text = headline
        } else {
            print("⚠️ Warning: nativeAd.headline is nil")
        }

        if let body = nativeAd.body {
            (adView.bodyView as? UILabel)?.text = body
        } else {
            print("⚠️ Warning: nativeAd.body is nil")
        }

        if let callToAction = nativeAd.callToAction {
            (adView.callToActionView as? UIButton)?.setTitle(callToAction, for: .normal)
        } else {
            print("⚠️ Warning: nativeAd.callToAction is nil")
        }

        if let iconImage = nativeAd.icon?.image {
            (adView.iconView as? UIImageView)?.image = iconImage
        } else {
            print("⚠️ Warning: nativeAd.icon?.image is nil")
        }

        adView.nativeAd = nativeAd
        return adView
    }
}
