//
//  TestViewController.swift
//  HelloThere_iOS
//
//  Created by 우주대스타 on 2023-08-08.
//

import UIKit
import NMapsMap
import CoreLocation
import Alamofire
import SwiftyJSON

class TestViewController: UIViewController, CLLocationManagerDelegate {
    
    var locationManager = CLLocationManager()
    var marker = NMFMarker()
    
//    Geocode
    let NAVER_CLIENT_ID = "0ov3ivr4yg"
    let NAVER_CLIENT_SECRET = "qtgiMVzsryf5d08vcATCyAjEL1RyO7Q4HTWyvLVj"
    let NAVER_GEOCODE_URL = "https://naveropenapi.apigw.ntruss.com/map-reversegeocode/v2/gc?request=coordsToaddr&coords="
    let NAVER_GEOCODE_REQUEST = "&sourcecrs=EPSG:4326&orders=roadaddr&output=json"
    
//    public var address = geo
//    let hongdae = "서울시 마포구 동교동"
//    let encodeAddress = self().hongdae.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!


    override func viewDidLoad() {
        super.viewDidLoad()
        
        let naverMap = NMFNaverMapView(frame: view.frame)
        let mapView = naverMap.mapView
        naverMap.showLocationButton = true
        mapView.touchDelegate = self
        mapView.positionMode = NMFMyPositionMode.normal
        mapView.positionMode = .direction
        
        view.addSubview(naverMap)
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            print("위치 서비스 On 상태")
            locationManager.startUpdatingLocation()
            print(locationManager.location?.coordinate)

            let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat:37.5670135, lng:126.9783740))
//            let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: locationManager.location?.coordinate.latitude ?? 0, lng: locationManager.location?.coordinate.longitude ?? 0))
            cameraUpdate.animation = .easeIn
            mapView.moveCamera(cameraUpdate)

        } else {
            print("위치 서비스 Off 상태")
        }
    }
    
}

extension TestViewController: NMFMapViewTouchDelegate, NMFMapViewCameraDelegate {
        
    func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint){
        marker.position = latlng
        marker.mapView = mapView

//        let NAVER_GEOCODE_LATLNG = String(latlng.lng) + "," + String(latlng.lat)
////        print(">>\(NAVER_GEOCODE_LATLNG)\n")
//        let header1 = HTTPHeader(name: "X-NCP-APIGW-API-KEY-ID", value: NAVER_CLIENT_ID)
//        let header2 = HTTPHeader(name: "X-NCP-APIGW-API-KEY", value: NAVER_CLIENT_SECRET)
//        let headers = HTTPHeaders([header1,header2])
//        AF.request(NAVER_GEOCODE_URL + NAVER_GEOCODE_LATLNG + NAVER_GEOCODE_REQUEST, method: .get,headers: headers).validate()
//                .responseJSON { response in
//                    switch response.result {
//                    case .success(let value as [String:Any]):
//                        let json = JSON(value)
//                        let data = json["results"]
//                        let region = data[0]["region"]
//                        let area1 = region["area1"]["name"]
//                        let area2 = region["area2"]["name"]
//                        let area3 = region["area3"]["name"]
//
//                        let land = data[0]["land"]
//                        let addition0 = land["addition0"]["value"]
//                        let name = land["name"]
//                        print("주소 : \(area1) \(area2) \(area3) \(name), \(addition0)")
//                    case .failure(let error):
//                        print(error.errorDescription ?? "")
//                    default :
//                        fatalError()
//                    }
//                }
//        marker.touchHandler = { (overlay: NMFOverlay) -> Bool in
//            print("마커 터치\n현재 위치 \(latlng)")
//            return true // 이벤트 소비, -mapView:didTapMap:point 이벤트는 발생하지 않음
//        }
    }
    func mapViewCameraIdle(_ mapView: NMFMapView) {
           print("symbol tap")
        }
}
