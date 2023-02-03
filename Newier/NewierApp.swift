//
//  NewierApp.swift
//  Newier
//
//  Created by KhaleD HuSsien on 31/01/2023.
//

import SwiftUI

@main
struct NewierApp: App {
    @StateObject var articleBookmarkVM = ArticleBookmarkViewModel.shared
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(articleBookmarkVM)
        }
    }
}
