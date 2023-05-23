//
//  MainViewModel.swift
//  OneTask
//
//  Created by John Kim on 5/11/23.
//

import SwiftUI
import Lottie

class MainViewModel: ObservableObject {
    //Shared Properties
    @Published var selectedTab : String
    @Published var showMenu : Bool
    @Published var showMenuButton : Bool = true
    //SideMenu Properties
    @Published var username: String = ""
    @Published var menuItems: [MenuItem] = []
    @Published var appVersion: String
    
    //Replace this init with a load func when network call is implemented
    init() {
        self.selectedTab = "Home"
        self.showMenu = false
        
        self.username = "John Kim"
        self.menuItems = [MenuItem(image: "house", title: "Home"),
                     MenuItem(image: "star", title: "Rate us")]
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
    
    func toggleMenuAnimation(_ animationView: LottieAnimationView) {
        if showMenu {
            animationView.play(fromProgress: 0.0, toProgress: 0.5, loopMode: .playOnce, completion: nil)
        } else {
            animationView.play(fromProgress: 0.5, toProgress: 1.0, loopMode: .playOnce, completion: nil)
        }
    }
}

struct MenuItem: Hashable {
    let image: String
    let title: String
}
