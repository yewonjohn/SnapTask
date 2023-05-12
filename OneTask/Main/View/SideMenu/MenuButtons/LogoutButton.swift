//
//  LogoutButton.swift
//  OneTask
//
//  Created by John Kim on 5/12/23.
//

import SwiftUI

struct LogoutButton: View {
    //MARK: - Properties
    var image: String
    var title: String
    
    var body: some View {
        
        Button(action: {
            withAnimation(.spring()){}
        }, label: {
            HStack(spacing: 15){
                
                Image(systemName: image)
                    .font(.title2)
                    .frame(width: 30)
                
                Text(title)
                    .fontWeight(.semibold)
            }
            .foregroundColor(Color.white)
            .padding(.vertical, 12)
            .padding(.horizontal, 10)
        })
    }
}
