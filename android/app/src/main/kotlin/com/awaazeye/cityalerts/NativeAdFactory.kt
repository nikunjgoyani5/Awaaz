import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.view.View.VISIBLE
import android.widget.ImageView
import android.widget.TextView
import com.google.android.gms.ads.nativead.MediaView
import com.google.android.gms.ads.nativead.NativeAd
import com.google.android.gms.ads.nativead.NativeAdView
import com.awaazeye.cityalerts.R
import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin
import android.util.Log

class NativeAdFactory(private val context: Context) : GoogleMobileAdsPlugin.NativeAdFactory {

    @Override
    override fun createNativeAd(
        nativeAd: NativeAd, customOptions: Map<String?, Any?>?
    ): NativeAdView {

        val nativeAdView = LayoutInflater.from(context)
            .inflate(R.layout.native_ad, null) as NativeAdView

        if (nativeAd != null) {
            try {
                val mediaView: MediaView? = nativeAdView.findViewById(R.id.ad_media)
                if (mediaView != null) {
                    nativeAdView.mediaView = mediaView
                } else {
                    Log.e("NativeAdFactory", "MediaView is null")
                }

                val adCallToAction: TextView = nativeAdView.findViewById(R.id.ad_call_to_action)
                nativeAdView.callToActionView = adCallToAction
                adCallToAction.visibility = if (nativeAd.callToAction == null) {
                    View.INVISIBLE
                } else {
                    adCallToAction.text = nativeAd.callToAction
                    View.VISIBLE
                }

                val headlineView: TextView = nativeAdView.findViewById(R.id.ad_headline)
                headlineView.text = nativeAd.headline
                nativeAdView.headlineView = headlineView

                nativeAdView.iconView = nativeAdView.findViewById(R.id.ad_app_icon)
                if (nativeAd.icon != null) {
                    (nativeAdView.iconView as ImageView).setImageDrawable(nativeAd.icon?.drawable)
                    nativeAdView.iconView?.visibility = View.VISIBLE
                } else {
                    nativeAdView.iconView?.visibility = View.GONE
                }

                nativeAdView.setNativeAd(nativeAd)
            } catch (e: Exception) {
                Log.e("NativeAdFactory", "Error setting up native ad: ${e.message}", e)
            }
        }

        return nativeAdView
    }
}