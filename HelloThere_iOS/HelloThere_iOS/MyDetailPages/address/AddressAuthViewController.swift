//
//  AddressAuthViewController.swift
//  HelloThere_iOS
//
//  Created by 서보현 on 2023/07/24.
//

import UIKit
import NMapsMap
import Alamofire
import SwiftyJSON
import CoreLocation

class AddressAuthViewController: UIViewController, CLLocationManagerDelegate {
    
    var locationManager = CLLocationManager()
    var marker = NMFMarker()
    let addressInfoLabel = UILabel(frame: CGRectMake(35, 739, 322, 43)) // 도로명 주소를 표시하는 라벨
    
    var userAddress: String = ""
    
//    Reverse Geocode API 정보
    let NAVER_CLIENT_ID = "w79vm77s97"
    let NAVER_CLIENT_SECRET = "n1cDaJfFqm5qwt0FDQQ4uCHXljHCIm0qhweizcWG"
    let NAVER_GEOCODE_URL = "https://naveropenapi.apigw.ntruss.com/map-reversegeocode/v2/gc?request=coordsToaddr&coords="
    let NAVER_GEOCODE_REQUEST = "&sourcecrs=EPSG:4326&orders=roadaddr&output=json"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addressInfoLabel.textAlignment = .center
        addressInfoLabel.layer.borderColor = UIColor.black.cgColor
        addressInfoLabel.layer.borderWidth = 0.5
        addressInfoLabel.layer.cornerRadius = 20
        addressInfoLabel.layer.masksToBounds = true
        addressInfoLabel.font = addressInfoLabel.font.withSize(12)
        addressInfoLabel.textColor = UIColor(red: 43/255, green: 203/255, blue: 165/255, alpha: 1)
        addressInfoLabel.backgroundColor = UIColor.white
        addressInfoLabel.text = ""

//        네이버 맵 띄우기
        let naverMap = NMFNaverMapView(frame: CGRectMake(0, 123, 393, 637))
        let mapView = naverMap.mapView
        naverMap.showLocationButton = true
        mapView.touchDelegate = self
        mapView.positionMode = NMFMyPositionMode.normal
        mapView.positionMode = .direction
        
//        naverMap과 label 화면에 띄우기
        view.addSubview(naverMap)
        view.addSubview(addressInfoLabel)
        
//        현재위치 가져오기 & 위치 허용 받기
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            print("위치 서비스 On 상태")
            locationManager.startUpdatingLocation()
            print(locationManager.location?.coordinate)

            let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat:37.5670135, lng:126.9783740)) // 시뮬레이터에서는 현재 위치가 잘 잡히지 않아서 임의로 잡아둠
//            let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: locationManager.location?.coordinate.latitude ?? 0, lng: locationManager.location?.coordinate.longitude ?? 0))
            cameraUpdate.animation = .easeIn
            mapView.moveCamera(cameraUpdate)
        } else {
            print("위치 서비스 Off 상태")
        }
    }
    
    
    @IBAction func didTapAddressVerificationButton(_ sender: Any) {
        if userAddress.isEmpty{
            sendMessage(text: "주소를 입력해주세요")
        }else {
            sendMessage(text: "주소 인증 완료")
        }
    }
    
    @IBAction func moveBackToScreen(_ sender : Any) {
        self.dismiss(animated: true)
    }
    
    func sendMessage(text:String){
        let alert = UIAlertController(title: nil, message: text, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
}


extension AddressAuthViewController: NMFMapViewTouchDelegate, NMFMapViewCameraDelegate {

    func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint){
        
//        마커 찍기
        marker.position = latlng
        marker.mapView = mapView
        marker.iconTintColor = UIColor.systemMint
        
//        도로명 주소로 변환
        latlngToRoadAddress(latlng: latlng)

    }
    
    func mapViewCameraIdle(_ mapView: NMFMapView) {
           print("symbol tap")
    }
    
    func latlngToRoadAddress(latlng: NMGLatLng) {
        let NAVER_GEOCODE_LATLNG = String(latlng.lng) + "," + String(latlng.lat)
        let header1 = HTTPHeader(name: "X-NCP-APIGW-API-KEY-ID", value: NAVER_CLIENT_ID)
        let header2 = HTTPHeader(name: "X-NCP-APIGW-API-KEY", value: NAVER_CLIENT_SECRET)
        let headers = HTTPHeaders([header1,header2])
        
        AF.request(NAVER_GEOCODE_URL + NAVER_GEOCODE_LATLNG + NAVER_GEOCODE_REQUEST, method: .get, headers: headers).validate()
                .responseJSON { response in
                    switch response.result {
                    case .success(let value):
                        if let detail = JSON(value)["results"].array{
                            for item in detail {
                                let region = item["region"]
                                let area1 = region["area1"]["name"].string ?? ""
                                let area2 = region["area2"]["name"].string ?? ""
                                let area3 = region["area3"]["name"].string ?? ""
                                let land = item["land"]
                                let addition0 = land["addition0"]["value"].string ?? ""
                                let name = land["name"].string ?? ""
                                self.userAddress = area1 + " " + area2 + " " + area3 + " " + name + ", " + addition0
                                print("주소 : \(self.userAddress)")
                                self.addressInfoLabel.text = self.userAddress
                            }
                        }
                    case .failure(let error):
                        print(error.errorDescription ?? "")
                    default :
                        fatalError()
                    }
                }
    }
}
