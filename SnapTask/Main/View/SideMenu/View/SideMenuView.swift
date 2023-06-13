//
//  SideMenu.swift
//  OneTask
//
//  Created by John Kim on 5/11/23.
//

import SwiftUI
import Lottie

struct SideMenuView: View {
    @Namespace var animation
    @EnvironmentObject var viewModel: MainViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            //Profile Image
            AvatarLottieView()
                .frame(width: 150, height: 150)
                .cornerRadius(10)
                .padding(.top, 50)
            
            VStack(alignment: .leading, spacing: 6) {
                Text(viewModel.username)
                    .font(.title)
                    .fontWeight(.heavy)
                    .foregroundColor(.white)
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
//                LogoutButton(image: "rectangle.righthalf.inset.fill.arrow.right", title: "Log out")
//                    .padding(.leading, -15)
                
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

//Avatar Animation
struct AvatarLottieView: UIViewRepresentable {
    
    func makeUIView(context: UIViewRepresentableContext<AvatarLottieView>) -> UIView {
        let view = UIView(frame: .zero)

        let animationView = LottieAnimationView(name: "male_avatar")
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.play()
        
        view.addSubview(animationView)
        animationView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor),
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor),
        ])
        return view
    }

    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<AvatarLottieView>) {
    }
}
