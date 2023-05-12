//
//  Home.swift
//  OneTask
//
//  Created by John Kim on 5/11/23.
//

import SwiftUI

struct TabParentView: View {
    @EnvironmentObject var viewModel : MainViewModel
    
    init() {
        UITabBar.appearance().isHidden = true
    }
    
    var body: some View {
        
        ZStack {
            TabView(selection: $viewModel.selectedTab) {
                //Views
                HomeScreen()
                    .tag("Home")
                Completed()
                    .tag("Completed")
                Settings()
                    .tag("Settings")
                RateUs()
                    .tag("Rate us")
            }
            if viewModel.showMenu {
                Rectangle()
                    .fill(Color.clear)
                    .contentShape(Rectangle())
                    .gesture(
                        DragGesture()
                            .onEnded { value in
                                if value.translation.width < 0 {
                                    withAnimation(.spring()){
                                        viewModel.showMenu.toggle()
                                    }
                                }
                            }
                    )

            }
        }
    }
}

//Subviews
struct HomeScreen: View {
    var body: some View {
        NavigationView{
            
            Text("Home")
                .font(.largeTitle)
                .fontWeight(.heavy)
                .foregroundColor(.primary)
        }
        
    }
}

struct Completed: View {
    var body: some View {
        NavigationView{
            
            Text("Completed")
                .font(.largeTitle)
                .fontWeight(.heavy)
                .foregroundColor(.primary)
//                .navigationTitle("Completed")
        }
    }
}

struct Settings: View {
    var body: some View {
        NavigationView{
            
            Text("Settings")
                .font(.largeTitle)
                .fontWeight(.heavy)
                .foregroundColor(.primary)
//                .navigationTitle("Settings")
        }
    }
}

struct RateUs: View {
    var body: some View {
        NavigationView{
            
            Text("Rate us")
                .font(.largeTitle)
                .fontWeight(.heavy)
                .foregroundColor(.primary)
//                .navigationTitle("Rate us")
        }
    }
}
