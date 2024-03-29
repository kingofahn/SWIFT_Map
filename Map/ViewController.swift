//
//  ViewController.swift
//  Map
//
//  Created by kingofahn on 13/06/2019.
//  Copyright © 2019 kingofahn. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet var myMap: MKMapView!
    @IBOutlet var lblLocationInfo1: UILabel!
    @IBOutlet var lblLocationInfo2: UILabel!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblLocationInfo1.text = "" // 아직 표시할 내용이 없으니 공백
        lblLocationInfo2.text = "" // 아직 표시할 내용이 없으니 공백
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest // 정확도 최고로 설정
        locationManager.requestWhenInUseAuthorization() // 사용자에게 승인 요구
        locationManager.startUpdatingLocation() // 위치 업데이트 시작
        myMap.showsUserLocation = true // 위치보기 값 true 설정
    }
    
    func goLocation(latitudeValue: CLLocationDegrees, longitudeValue : CLLocationDegrees, delta span : Double) -> CLLocationCoordinate2D {
        let pLocation = CLLocationCoordinate2DMake(latitudeValue, longitudeValue)
        let spanValue = MKCoordinateSpan(latitudeDelta: span, longitudeDelta: span)
        // 문법이 바뀐 것 같음 -> 기존 let spanValue = MKCoordinateSpanMake(span, span)
        let pRegion = MKCoordinateRegion(center: pLocation, span: spanValue)
        // 문법이 바뀐 것 같음 -> 기존 let pRegion = MKCoordinateRegionMake(pLocation, spanValue)
        myMap.setRegion(pRegion, animated: true)
        return pLocation
    }
    
    func setAnnotaion(latitudeValue: CLLocationDegrees, longitudeValue : CLLocationDegrees, delta span :Double, title strTitle: String, subtitle strSubtitle:String){
        let annotation = MKPointAnnotation()
        // 핀을 설치하기 위해 MKPointAnnotation함수를 호출하여 리턴을 annotation으로 받는다.
        annotation.coordinate = goLocation(latitudeValue: latitudeValue, longitudeValue: longitudeValue, delta: span)
        annotation.title = strTitle
        annotation.subtitle = strSubtitle
        myMap.addAnnotation(annotation)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let pLocation = locations.last // 위치가 업데이트되면 먼저 마지막 위치 값을 찾아냄
        _ = goLocation(latitudeValue: (pLocation?.coordinate.latitude)!, longitudeValue: (pLocation?.coordinate.longitude)!, delta: 0.01)
        // delta를 0.01로 하였으니 1의 값보다 지도를 100배로 확대함
        CLGeocoder().reverseGeocodeLocation(pLocation!, completionHandler: {
            (placemarks, error) -> Void in
            let pm = placemarks!.first
            let country = pm!.country
            var address:String = country!
            if pm!.locality != nil {
                address += " "
                address += pm!.thoroughfare!
            }
            
            self.lblLocationInfo1.text = "현재 위치"
            self.lblLocationInfo2.text = address
            
        })
        
        locationManager.stopUpdatingLocation()
    }

    @IBAction func sgChangeLocation(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
        // 현재 위치
            self.lblLocationInfo1.text = ""
            self.lblLocationInfo2.text = ""
            locationManager.startUpdatingLocation()
        } else if sender.selectedSegmentIndex == 1 {
        // 폴리텍대학
            setAnnotaion(latitudeValue: 37.751853, longitudeValue: 128.87605740000004, delta: 1, title: "한국폴리텍대학 강릉캠퍼스", subtitle: "강원도 강릉시 남산초교길 121")
            self.lblLocationInfo1.text = "보고 계신 위치"
            self.lblLocationInfo2.text = "한국폴리텍대학 강릉캠퍼스"
        } else {
        // 이지스퍼블리싱
            setAnnotaion(latitudeValue: 37.5307871, longitudeValue: 126.8981, delta: 0.1, title: "이지퍼블리싱", subtitle: "서울시 영등포구 당산로 41길 11")
            self.lblLocationInfo1.text = "보고 계신 위치"
            self.lblLocationInfo2.text = "이지스퍼블리싱 출판사"
        }
    }
    
}

