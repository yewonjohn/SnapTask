//
//  ViewController.swift
//  OneTask
//
//  Created by John Kim on 5/11/23.
//

import UIKit
import SwiftUI

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Create a UIHostingController with MySwiftUIView as its root view
        let mainViewModel = MainViewModel()
        let mainUIView = MainView().environmentObject(mainViewModel)
        let hostingController = UIHostingController(rootView: mainUIView)

        // Add the hosting controller as a child view controller and set its constraints
        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        // Notify the hosting controller that it has been added to the view hierarchy
        hostingController.didMove(toParent: self)
    }

}

