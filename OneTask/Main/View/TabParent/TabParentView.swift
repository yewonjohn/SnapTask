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
        UITabBar.appearance().isHidden = false
    }
    
    var body: some View {
        Color.white
            .ignoresSafeArea()
        
        ZStack {
            TabView(selection: $viewModel.selectedTab) {
                TodoView(viewModel)
                    .tag("Home")
                RateUs()
                    .tag("Rate us")
            }
            .foregroundColor(Color.gray)
            if viewModel.showMenu {
                Rectangle()
                    .fill(Color.black)
                    .opacity(0.2)
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
