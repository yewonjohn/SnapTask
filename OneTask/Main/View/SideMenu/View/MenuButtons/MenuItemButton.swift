//
//  HomeMenuButton.swift
//  OneTask
//
//  Created by John Kim on 5/11/23.
//

import SwiftUI

struct MenuItemButton: View {
    
    //MARK: - Properties
    var image: String
    var title: String
    var animation: Namespace.ID
    @EnvironmentObject var viewModel: MainViewModel

    
    var body: some View {
        
        Button(action: {
            withAnimation(.spring(response: 0.2)){viewModel.selectedTab = title}
        }, label: {
            HStack(spacing: 15){
                
                Image(systemName: image)
                    .font(.title2)
                    .frame(width: 30)
                
                Text(title)
                    .fontWeight(.semibold)
            }
            .foregroundColor(viewModel.selectedTab == title ? Color.blue : .white)
            .padding(.vertical, 12)
            .padding(.horizontal, 10)
            //Max frame
            .frame(maxWidth: getRect().width - 170, alignment: .leading)
            .background(
            
                //Hero animation
                ZStack{
                    if viewModel.selectedTab == title {
                        Color.white
                            .opacity(viewModel.selectedTab == title ? 1 : 0)
                            .clipShape(CustomCorners(corners: [.topRight, .bottomRight], radius: 12))
                            .matchedGeometryEffect(id: "TAB", in: animation)
                    }
                }
            )
        })
    }
}
