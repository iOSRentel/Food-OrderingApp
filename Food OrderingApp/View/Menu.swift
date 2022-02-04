//
//  Menu.swift
//  Food OrderingApp
//
//  Created by Boris Zinovyev on 02.02.2022.
//

import SwiftUI

struct Menu: View {
    @ObservedObject var homeData : HomeViewModel

    var body: some View {
        VStack {
//  корзина
            NavigationLink(destination: CartView(homeData: homeData)) {
//            Button(action: {}, label: {
                HStack(spacing: 15) {
                    Image(systemName: "cart")
                        .font(.title)
                        .foregroundColor(.red)
                    
                    Text("Cart")
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                    
                    Spacer(minLength: 0)
                }
                .padding()
            }
            
            Spacer()
//   версия
            HStack {
                
                Spacer()
                
                Text("Version 0.1")
                    .fontWeight(.bold)
                    .foregroundColor(.gray)
            }
            .padding(10)
        }
        .padding([.top,.trailing])
        .frame(width: UIScreen.main.bounds.width / 1.6)
        .background(Color.white.ignoresSafeArea())
    }
}
