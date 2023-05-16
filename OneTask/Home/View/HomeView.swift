////
////  HomeView.swift
////  OneTask
////
////  Created by John Kim on 5/15/23.
////
//
//import SwiftUI
//import Lottie
//
//struct HomeView: View {
//    @State var items : [TodoItem] = [TodoItem(title: "Stuff do"), TodoItem(title: "Stuff do"), TodoItem(title: "Stuff do")]
//    
//    var body: some View {
//        
//            VStack{
//                Text("Tasks!")
//                    .font(.title)
//                    .foregroundColor(.black)
//                    .padding()
//
//                List {
//                    ForEach(items, id: \.id) { item in
//                        var title = item.title
//                        ZStack(alignment: .leading) {
//                            Text(title)
//                            Rectangle()
//                                .opacity(0.01)
//                                .gesture(
//                                    DragGesture()
//                                        .onEnded { value in
//                                            animationProgress = value.translation
//                                            if value.translation.width < -100{
//                                                // Swiped left, delete the text
//                                                strikethroughAnimation
//                                                
//                                                withAnimation {
//                                                    title = ""
//                                                    let index = items.firstIndex(of: item)!
//                                                    items.remove(at: index)
//                                                }
//                                                
//                                            }
//                                        }
//                                )
//                                .overlay(
//                                    strikethroughAnimation
//                                )
//                        }
//                    }
//                }
//            }
//
//        
//    }
//    
//}
//
//struct TodoItem: View, Identifiable, Equatable {
//    static func == (lhs: TodoItem, rhs: TodoItem) -> Bool {
//        return lhs.title == rhs.title
//    }
//    
//    var id = UUID()
//    @State var isCompleted = false
//    var title: String
//    
//    var body: some View {
//        HStack {
//            if isCompleted {
//                Text(title)
//                    .strikethrough()
//                    .foregroundColor(.gray)
//            } else {
//                Text(title)
//            }
//            
//            Spacer()
//            
//            if isCompleted {
//                Image(systemName: "checkmark")
//                    .foregroundColor(.green)
//            } else {
//                Image(systemName: "circle")
//                    .foregroundColor(.gray)
//            }
//        }
//        .swipeActions(edge: .leading) {
//            Button(action: {
//                // handle the delete action here
//            }) {
//                Label("Delete", systemImage: "trash")
//            }
//            .tint(.red)
//        }
//    }
//}
//
//struct HomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeView()
//    }
//}
//
//
////Avatar Animation
//struct StrikethroughLottieView: UIViewRepresentable {
//    
//    var progress : CGSize
//    
//    func makeUIView(context: UIViewRepresentableContext<StrikethroughLottieView>) -> UIView {
//        let view = UIView(frame: .zero)
//
//        let animationView = LottieAnimationView(name: "strikethrough")
//        animationView.contentMode = .scaleAspectFit
//        animationView.loopMode = .playOnce
//        animationView.currentProgress = progress.width
//        
//        
//        view.addSubview(animationView)
//        animationView.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            animationView.heightAnchor.constraint(equalTo: view.heightAnchor),
//            animationView.widthAnchor.constraint(equalTo: view.widthAnchor),
//        ])
//        return view
//    }
//
//    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<StrikethroughLottieView>) {
//    }
//}
