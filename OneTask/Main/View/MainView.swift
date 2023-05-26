//
//  HomeUIView.swift
//  OneTask
//
//  Created by John Kim on 5/11/23.
//

import SwiftUI
import Lottie

struct MainView: View {
    
    //MARK: - Properties
    @EnvironmentObject var mainViewModel: MainViewModel
    @Namespace var animation

    var body: some View {
        
        ZStack{
            Color.gray
                .ignoresSafeArea()
            //Side menu
            ScrollView(getRect().height < 750 ? .vertical : .init(), showsIndicators: false, content: {
                SideMenuView()
            })
            
            ZStack{
                //Background Cards
                Color.white
                    .opacity(0.5)
                    .cornerRadius(mainViewModel.showMenu ? 15: 0)
                    .shadow(color: Color.black.opacity(0.07), radius: 5, x: -5, y: 0)
                    .offset(x: mainViewModel.showMenu ? -25 : 0)
                    .padding(.vertical, 30)
                
                Color.white
                    .opacity(0.4)
                    .cornerRadius(mainViewModel.showMenu ? 15: 0)
                    .shadow(color: Color.black.opacity(0.07), radius: 5, x: -5, y: 0)
                    .offset(x: mainViewModel.showMenu ? -50 : 0)
                    .padding(.vertical, 60)
                
                TabParentView()
                    .cornerRadius(mainViewModel.showMenu ? 15: 0)

            }
            //Scaling and Moving the View
            .scaleEffect(mainViewModel.showMenu ? 0.84 : 1)
            .offset(x: mainViewModel.showMenu ? getRect().width - 140 : 0)
            .edgesIgnoringSafeArea(.all)
        }
        .overlay(
            Button(action: {
                if(mainViewModel.showMenuButton){
                    mainViewModel.toggleMenu()
                }
            }, label: {
                    VStack(spacing: 5, content: {
                        Capsule()
                            .fill(mainViewModel.showMenu ? Color.white : Color.black)
                            .frame(width: 30, height: 3)
                            .rotationEffect(.init(degrees: mainViewModel.showMenu ? -50 : 0))
                            .offset(x: mainViewModel.showMenu ? 2 : 0, y: mainViewModel.showMenu ? 9 : 0)

                        VStack(spacing: 5, content: {
                            Capsule()
                                .fill(mainViewModel.showMenu ? Color.white : Color.black)
                                .frame(width: 30, height: 3)
                            Capsule()
                                .fill(mainViewModel.showMenu ? Color.white : Color.black)
                                .frame(width: 30, height: 3)
                                .offset(y: mainViewModel.showMenu ? -8 : 0)
                        })
                        .rotationEffect(.init(degrees: mainViewModel.showMenu ? 50 : 0))
                    })
                    .opacity(mainViewModel.showMenuButton ? 1 : 0.1)
                    .animation(.easeInOut(duration: 0.3))
            })
            .disabled(!mainViewModel.showMenuButton)
            .padding()
            ,alignment: .topLeading
        )
    }
}
