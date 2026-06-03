//
//  FullNativeAds.swift
//  Runner
//
//  Created by LogicGo Mac Mini M4 on 15/05/25.
//
import UIKit
import GoogleMobileAds

//class FullNativeAds: GADNativeAdView {
//    
//  
//    
//    static func loadFromNib() -> FullNativeAds {
//        let nib = UINib(nibName: "FullNativeAds", bundle: nil)
//        guard let view = nib.instantiate(withOwner: nil, options: nil).first as? FullNativeAds else {
//            fatalError("Could not load NativeAdView from nib")
//        }
//        return view
//    }
//    
//}
class FullNativeAds: GADNativeAdView {
    
  
    
    static func loadFromNib() -> FullNativeAds {
        let nib = UINib(nibName: "NativeFullAds", bundle: nil)
        guard let view = nib.instantiate(withOwner: nil, options: nil).first as? FullNativeAds else {
            fatalError("Could not load NativeAdView from nib")
        }
        return view
    }
    
}
