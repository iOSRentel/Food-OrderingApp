//
//  Cart.swift
//  Food OrderingApp
//
//  Created by Boris Zinovyev on 03.02.2022.
//

import SwiftUI

struct Cart: Identifiable {
     
    var id = UUID().uuidString
    var item: Item
    var quantity: Int
}
