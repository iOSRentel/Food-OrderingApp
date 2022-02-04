//
//  CartView.swift
//  Food OrderingApp
//
//  Created by Boris Zinovyev on 04.02.2022.
// 4%55

import SwiftUI

struct CartView: View {
    @ObservedObject var homeData: HomeViewModel
    @Environment(\.presentationMode) var present
    
    var body: some View {
        VStack{
            
            HStack(spacing: 20){
                
                Button(action: {present.wrappedValue.dismiss()}) {
                    
                Image(systemName: "chevron.left")
                    .font(.system(size: 26, weight: .heavy))
                    .foregroundColor(.black)
                }
                
                Text("My cart")
                    .foregroundColor(.black)
                    .fontWeight(.bold)
                    .font(.title)
                
                Spacer()
            }
                    .padding()
            
        ScrollView(.vertical, showsIndicators: false){
                
            LazyVStack(spacing:0) {
        
                ForEach(homeData.cartItems) {item in
                
                    Text(item.item.item_name)
                    }
                }
            }
//  BottomView
        VStack{
            HStack{
                Text("Total")
                    .fontWeight(.heavy)
                    .foregroundColor(.gray)
                    
            Spacer()
                    
//MARK: калькулятор
                Text(homeData.calculateTotalPrice())
                    .font(.title)
                    .fontWeight(.heavy)
                    .foregroundColor(.black)
                    
                }
                    .padding([.top, .horizontal])
                
            Button(action: {}) {
                Text("Check out")
                    .font(.title2)
                    .fontWeight(.heavy)
                    .foregroundColor(.white)
                    .padding(.vertical)
                    .frame(width: UIScreen.main.bounds.width - 30)
                    .background(Color.blue)
                    .cornerRadius(15)
                    }
                }
        .background(Color.white)
        }
        .background((Color.white).ignoresSafeArea())
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
    }
}
