//
//  AddTaskOverlayViewModel.swift
//  OneTask
//
//  Created by John Kim on 5/25/23.
//

import Foundation
import Combine

class AddTaskOverlayViewModel {
    
    var cancellables: Set<AnyCancellable> = []
    private(set) var addTask = PassthroughSubject<String?, Never>()
    private(set) var closeTapped = PassthroughSubject<Void?, Never>()

    func removeCancellables() {
        cancellables.removeAll()
    }
    
    func addTask(_ input: String){
        addTask.send(input)
    }
    
    func dismissScreen() {
        closeTapped.send(Void())
    }
}
