//
//  LocationManager.swift
//  AmazonMonitoring
//
//  Created by 国生将弥 on 2022/02/16.
//
import MapKit
import SwiftUI


//現在地を取得するためのクラス
class LocationManager:NSObject,ObservableObject,CLLocationManagerDelegate{
    
    //ロケーションマネージャーを作る
    let manager = CLLocationManager()
    //領域の更新をパブリッシュ
    @Published var region = MKCoordinateRegion()
    
    
    override init(){
        super.init()
        //デリゲートを設定
        manager.delegate = self
        //プライバシー設定の確認
        manager.requestWhenInUseAuthorization()
        
        manager.desiredAccuracy = kCLLocationAccuracyBest
        //更新距離
        manager.distanceFilter = 2
        //追従を開始
        manager.startUpdatingLocation()
    }
    

    private func locationManager(_ manager: CLLocationManager, locations: [CLLocation]) {

        //locationの最後の要素に対して実行する
        locations.last.map{
            let center = CLLocationCoordinate2D(latitude:$0.coordinate.latitude,longitude:$0.coordinate.longitude)
            region = MKCoordinateRegion(center: center, latitudinalMeters: 1000.0,longitudinalMeters: 1000.0)
        }
    }
}

