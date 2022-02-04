//
//  ContentView.swift
//  Food OrderingApp
//
//  Created by Boris Zinovyev on 02.02.2022.
//часть 1 https://www.youtube.com/watch?v=bRnBPJ_dzpg
//часть 2 https://www.youtube.com/watch?v=SUjl9pW0eSM&t=8s
//часть 3 https://www.youtube.com/watch?v=MND4P0aDDgs
//остановился 6:05(ч.3)

import SwiftUI

struct ContentView: View {
    var body: some View {
        
        NavigationView {
        Home()
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
