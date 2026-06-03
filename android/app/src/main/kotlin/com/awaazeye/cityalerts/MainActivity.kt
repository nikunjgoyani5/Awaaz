package com.awaazeye.cityalerts

import android.content.Intent
import android.net.Uri
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File
import NativeAdFactory
import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin
import android.os.Bundle
import io.flutter.embedding.android.FlutterFragmentActivity


class MainActivity: FlutterFragmentActivity(){
    private val CHANNEL = "com.example.app/media_scanner"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
                call, result ->
            if (call.method == "scanFile") {
                val path = call.argument<String>("path")
                if (path != null) {
                    val file = File(path)
                    val uri = Uri.fromFile(file)
                    val scanIntent = Intent(Intent.ACTION_MEDIA_SCANNER_SCAN_FILE, uri)
                    sendBroadcast(scanIntent)
                    result.success(null)
                } else {
                    result.error("INVALID_PATH", "Path is null", null)
                }
            }
        }
        GoogleMobileAdsPlugin.registerNativeAdFactory(
            flutterEngine,
            "nativeAd",
            NativeAdFactory(this)
        )
    }
}
