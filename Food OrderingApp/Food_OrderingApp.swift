//
//  Food_OrderingAppApp.swift
//  Food OrderingApp
//
//  Created by Boris Zinovyev on 02.02.2022.
//

import SwiftUI
import Firebase

@main
struct Food_OrderingApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}
