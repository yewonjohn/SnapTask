//
//  MainViewModel.swift
//  OneTask
//
//  Created by John Kim on 5/11/23.
//

import SwiftUI

class MainViewModel: ObservableObject {
    //Shared Properties
    @Published var selectedTab : String
    @Published var showMenu : Bool
    //SideMenu Properties
    @Published var username: String = ""
    @Published var menuItems: [MenuItem] = []
    @Published var appVersion: String
    
    //Replace this init with a load func when network call is implemented
    init() {
        self.selectedTab = "Home"
        self.showMenu = false
        
        self.username = "Yewon Kim"
        self.menuItems = [MenuItem(image: "house", title: "Home"),
                     MenuItem(image: "house", title: "Completed"),
                     MenuItem(image: "house", title: "Settings"),
                     MenuItem(image: "house", title: "Rate us")]
        self.appVersion = "1.2"
    }
    
    func viewProfile() {
        // Navigate to the user's profile view
    }
    
    func toggleMenu() {
        withAnimation(.spring()) {
            showMenu.toggle()
        }
    }
}

struct MenuItem: Hashable {
    let image: String
    let title: String
}
