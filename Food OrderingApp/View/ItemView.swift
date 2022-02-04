//
//  ItemView.swift
//  Food OrderingApp
//
//  Created by Boris Zinovyev on 03.02.2022.
//

import SwiftUI
// ВНИМАНИЕ!!!
import SDWebImageSwiftUI

struct ItemView: View {
    
    var item: Item
    
    var body: some View {
        VStack {
//  Downloading image with SPM (SDWebImageSwiftUI)
//  Картинка
            WebImage(url: URL(string: item.item_image))
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: UIScreen.main.bounds.width - 30, height: 250)
                .frame(height: 250)
            
        HStack(spacing: 8) {
//  Название
            Text(item.item_name)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.black)
                
        Spacer(minLength: 0)
                
//  Рейтинг
        ForEach(1...5,id: \.self){index in
            Image(systemName: "star.fill")
                .foregroundColor(index <= Int(item.item_rating) ?? 0 ? .yellow : .gray)
                    }
                }
//  Описание блюда
        HStack {
            Text(item.item_details)
                .font(.caption)
                .foregroundColor(.gray)
                .lineLimit(2)
                
        Spacer(minLength: 0)
            }
        }
    }
}
