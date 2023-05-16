//
//  Home.swift
//  OneTask
//
//  Created by John Kim on 5/11/23.
//

import SwiftUI

struct TabParentView: View {
    @EnvironmentObject var viewModel : MainViewModel
    var animation: Namespace.ID

//    init() {
//        UITabBar.appearance().isHidden = false
//    }
    
    var body: some View {
        
        ZStack {
            TabView(selection: $viewModel.selectedTab) {
                TodoView()
                    .tag("Home")
                Completed()
                    .tag("Completed")
                Settings()
                    .tag("Settings")
                RateUs()
                    .tag("Rate us")
            }.foregroundColor(Color.gray)
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
