//
//  Home.swift
//  Food OrderingApp
//
//  Created by Boris Zinovyev on 02.02.2022.
//

import SwiftUI

struct Home: View {
    
    @StateObject var HomeModel = HomeViewModel()
    
    var body: some View {
        
//MARK: - Шапка с геолокацией
        
         ZStack {
             VStack(spacing: 10) {
                HStack(spacing: 15) {
                    
                    Button(action: {
                        //MARK: - добавил код на 13:00
                        withAnimation(.easeIn){HomeModel.showMenu.toggle()}
                        //MARK: -
                    }, label: {
                        
                        Image(systemName: "line.horizontal.3")
                            .font(.title)
                    })
                    //вначале кода было так, до геолокации     Text("Deliver To")
                    Text(HomeModel.userLocation == nil ? "Locating..." : "Deliver To")
                    
                        .foregroundColor(.black)
                    //вначале кода было так, до геолокации       Text("Apple")
                    Text(HomeModel.userAdress)
                        .font(.caption)
                        .fontWeight(.heavy)
                    
                    Spacer(minLength: 0)
                    
                }
                .padding([.horizontal,.top])
                 
                 Divider()
                 
                 HStack(spacing: 15) {
//MARK: - Поиск
                Image(systemName: "magnifyingglass")
                    .font(.title2)
                    .foregroundColor(.gray)
                     
                TextField("Search", text: $HomeModel.search)
            }
                    .padding(.horizontal)
                    .padding(.top, 10)
                 
                 Divider()
                 
// убираем этот Спейсер на 6:55 видео номер 2
//                 Spacer(minLength: 0)
                                  
//MARK: - Иконки еды
                 ScrollView(.vertical, showsIndicators: false, content: {
                     VStack(spacing: 25) {
                         ForEach(HomeModel.filtered) {item in
//  ItemView
                             ZStack(alignment: Alignment(horizontal: .center, vertical: .top), content: {
                             ItemView(item: item)
                                 
                                 HStack {
                                     Text("FREE DELIVERY")
                                         .foregroundColor(.white)
                                         .padding(.vertical, 10)
                                         .padding(.horizontal)
                                         .background(Color(.green))
                                 
                                 Spacer(minLength: 0)
                                 
                                 Button(action: {
//MARK: - добавляю из 3 видео(3:06)
                                    HomeModel.addToCart(item: item)
//MARK: -
                                 }, label: {
                                     Image(systemName: item.isAdded ? "checkmark" : "plus")
                                         .foregroundColor(.white)
                                         .padding(10)
                                         .background(item.isAdded ? Color(.green) : Color(.blue))
                                         .clipShape(Circle())
                                 })
                             }
                                        .padding(.trailing,10)
                                        .padding(.top,10)
                        })
                            .frame(width: UIScreen.main.bounds.width - 30)

                         }
                     }
                     .padding(.top, 10)
                 })
             }
//MARK: - продолжение локации
             if HomeModel.noLocation {
                 Text("Please Enable Location Access In Settings To Further Move On")
                     .foregroundColor(.black)
                     .frame(width: UIScreen.main.bounds.width - 100, height: 120)
                     .background(Color.white)
                     .cornerRadius(10)
                     .frame(maxWidth: .infinity, maxHeight: .infinity)
                     .background(Color.black.opacity(0.3).ignoresSafeArea())
             }
             
//MARK: - сдвижное меню
             HStack {
                 Menu(homeData: HomeModel)
                     .offset(x: HomeModel.showMenu ? 0 : -UIScreen.main.bounds.width / 1.6)
                 
                 Spacer(minLength: 0)
             }
             .background(Color.black.opacity(HomeModel.showMenu ? 0.3 : 0).ignoresSafeArea()
                         //       закрытие по свободному нажатию
                            .onTapGesture(perform: {
                 withAnimation(.easeIn){HomeModel.showMenu.toggle()}
             })
             )
         }
        
//MARK: - функции геолокации
        .onAppear(perform: {
            HomeModel.locationManager.delegate = HomeModel
//    Изменения в plist! (Privacy - Location When In Use Usage Description)
        })
    
//MARK: - Поиск функция
        .onChange(of: HomeModel.search, perform: { value in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                if value == HomeModel.search && HomeModel.search != "" {
                    HomeModel.filterData()
                }
            }
            if HomeModel.search == "" {
                withAnimation(.linear){HomeModel.filtered = HomeModel.items}
            }
        })
    }
}
