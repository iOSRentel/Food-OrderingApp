//
//  HomeViewModel.swift
//  Food OrderingApp
//
//  Created by Boris Zinovyev on 02.02.2022.
//

import SwiftUI
// Геолокация
import CoreLocation
//Файрбейс авторизация + Firestore
import Firebase
import CoreMedia
import simd

//Если использовать без геолокации оставляю только ObservableObject
class HomeViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    
//MARK: - Поиск
    @Published var search = ""
    
//MARK: - SideMenu
    @Published var showMenu = false
    
//MARK: - ItemData
    @Published var items: [Item] = []
    
//MARK: - Поиск
    @Published var filtered: [Item] = []
    
//MARK: - Корзина
    @Published var cartItems : [Cart] = []
    @Published var ordered = false
    
//MARK: - Геолокация
    @Published var locationManager = CLLocationManager()
    @Published var userLocation: CLLocation!
    @Published var userAdress = ""
    @Published var noLocation = false
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
// checking Location Access
        switch manager.authorizationStatus {
        case .authorizedWhenInUse:
//          print("authorized") можно убрать
            print("authorized")
            self.noLocation = false
            manager.requestLocation()
        case . denied:
//          print("denied") можно убрать
            print("denied")
            self.noLocation = true
        default:
//          print("unknown") можно убрать
            print("unknown")
            self.noLocation = false
            locationManager.requestWhenInUseAuthorization()
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        read user location
        self.userLocation = locations.last
        self.extractLocation()
        
//MARK: - КУСОК АВТОРИЗАЦИИ
        self.login()
//MARK: - продолжение геолокации
    }
    func extractLocation() {
        CLGeocoder().reverseGeocodeLocation(self.userLocation) { (response, error) in
            guard let safeData = response else{return}
            
            var address = ""
            
            address += safeData.first?.name ?? ""
            address += ", "
            address += safeData.first?.locality ?? ""
            
            self.userAdress = address
        }
    }
//MARK: - Авторизация
    func login() {
        Auth.auth().signInAnonymously { (res, error) in
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            print("Success = \(res!.user.uid)")
            
//   кусок получения данных из БД
            self.fetchData()
            
        }
    }
    
//MARK: - Получение данных из БД
    func fetchData() {
        
        let db = Firestore.firestore()
        
        db.collection("Items").getDocuments { (snap, err) in
            
            guard let itemData = snap else{return}
            
            self.items = itemData.documents.compactMap( { (doc) -> Item? in
                
                let id = doc.documentID
                let name = doc.get("item_name") as! String
                let cost = doc.get("item_cost") as! NSNumber
                let image = doc.get("item_image") as! String
                let rating = doc.get("item_rating") as! String
                let details = doc.get("item_details") as! String
                
                return Item(id: id, item_name: name, item_cost: cost, item_details: details, item_image: image, item_rating: rating)

            })
            self.filtered = self.items
        }
    }

//MARK: - Поиск
    func filterData() {
        withAnimation(.linear){
            self.filtered = self.items.filter {
            return $0.item_name.lowercased().contains(self.search.lowercased())
            }
        }
    }
    
//MARK: - Добавить в корзину
    func addToCart(item: Item) {
//  проверка добавлено или нет
            self.items[getIndex(item: item, isCartIndex: false)].isAdded = !item.isAdded
        
// смотри видео 3 (12:15)
        let filterIndex = self.filtered.firstIndex { (item1) -> Bool in
            return item.id == item1.id
        } ?? 0
        
//  обновление строки поиска
            self.filtered[filterIndex].isAdded = !item.isAdded

        
        if item.isAdded {
            self.cartItems.remove(at: getIndex(item: item, isCartIndex: true))
            return
        }
            self.cartItems.append(Cart(item: item, quantity: 1))
    }
// продолжение про корзину видео 3 (1:44)
    func getIndex(item: Item,isCartIndex: Bool) -> Int {
        let index = self.items.firstIndex { (item1) -> Bool in
            return item.id == item1.id
        } ?? 0
        
        let cartIndex = self.cartItems.firstIndex { (item1) -> Bool in
            return item.id == item1.item.id
        } ?? 0
            return isCartIndex ? cartIndex : index
    }
    
//MARK: - товары в корзине
    func calculateTotalPrice()->String{
        var price : Float = 0
        
        cartItems.forEach { (item) in
            price += Float(item.quantity) * Float(truncating: item.item.item_cost)
        }
        return getPrice(value: price)
    }
    
    func getPrice(value: Float)->String{
        let format = NumberFormatter()
        format.numberStyle = .currency
        
        return format.string(from: NSNumber(value: value)) ?? ""
    }
    
//MARK: - Отправка счета корзины в Файрбейс
    func updateOrder() {
        let db = Firestore.firestore()
        
        if ordered {
            
            ordered = false
            db.collection("Users").document(Auth.auth().currentUser!.uid).delete {
                (err) in
                if err != nil {
                    self.ordered = true
                }
            }
            
            return
        }
        
        var details : [[String: Any]] = []
        cartItems.forEach { (cart) in
            
            details.append([
                
                "item_name": cart.item.item_name,
                "item_quantity": cart.quantity,
                "item_cost": cart.item.item_cost
            ])
        }
        
        ordered = true
        
        db.collection("Users").document(Auth.auth().currentUser!.uid).setData([
            "ordered_food": details,
            "total_cost": calculateTotalPrice(),
            "location": GeoPoint(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
            
        ]) { (err) in
            
            if err != nil {
                self.ordered = false
                return
        }
        print("seccess")
        }
    }
}
