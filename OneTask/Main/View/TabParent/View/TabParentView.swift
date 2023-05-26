//
//  Home.swift
//  OneTask
//
//  Created by John Kim on 5/11/23.
//

import SwiftUI

struct TabParentView: View {
    @EnvironmentObject var viewModel : MainViewModel
    
    var body: some View {
        Color.white
            .ignoresSafeArea()
        
        ZStack {
            TabView(selection: $viewModel.selectedTab) {
                TodoView(viewModel)
                    .tag("Home")
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))

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

struct DisableTabBar: ViewModifier {
    @State private var isHidden: Bool = false

    func body(content: Content) -> some View {
        content
            .onAppear {
                isHidden = true
            }
            .onDisappear {
                isHidden = false
            }
            .edgesIgnoringSafeArea(isHidden ? .all : [])
    }
}
