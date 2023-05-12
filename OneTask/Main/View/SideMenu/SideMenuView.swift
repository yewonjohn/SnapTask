//
//  SideMenu.swift
//  OneTask
//
//  Created by John Kim on 5/11/23.
//

import SwiftUI

struct SideMenuView: View {
    @Namespace var animation
    @EnvironmentObject var viewModel: MainViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            //Profile Image
            Image("profile")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 70, height: 70)
                .cornerRadius(10)
                .padding(.top, 50)
            
            VStack(alignment: .leading, spacing: 6) {
                Text(viewModel.username)
                    .font(.title)
                    .fontWeight(.heavy)
                    .foregroundColor(.white)
                
                Button(action: viewModel.viewProfile, label: {
                    Text("View Profile")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .opacity(0.7)
                })
            }
            
            //Menu buttons
            VStack(alignment: .leading, spacing: 10) {
                ForEach(viewModel.menuItems, id: \.self) { menuItem in
                    MenuItemButton(image: menuItem.image, title: menuItem.title, animation: animation)
                }
            }
            .padding(.leading, -15)
            .padding(.top, 50)
            
            Spacer()
            
            VStack(alignment: .leading, spacing: 6) {
                LogoutButton(image: "rectangle.righthalf.inset.fill.arrow.right", title: "Log out")
                    .padding(.leading, -15)
                
                Text("App Version \(viewModel.appVersion)")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .opacity(0.6)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }
}

