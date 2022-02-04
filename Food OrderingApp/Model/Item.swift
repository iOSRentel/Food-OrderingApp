//
//  Item.swift
//  Food OrderingApp
//
//  Created by Boris Zinovyev on 03.02.2022.
//

import SwiftUI

struct Item: Identifiable {
    var id: String
    var item_name: String
    var item_cost: NSNumber
    var item_details: String
    var item_image: String
    var item_rating: String
    
//MARK: - Из видео 3 (1:24) корзина
    var isAdded: Bool = false
}
