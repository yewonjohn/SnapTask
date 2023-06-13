//
//  EditTaskOverlayView.swift
//  OneTask
//
//  Created by John Kim on 5/27/23.
//

import Foundation
import Combine

class EditTaskOverlayViewModel {
    
    var cancellables: Set<AnyCancellable> = []
    private(set) var editTask = PassthroughSubject<String?, Never>()
    private(set) var closeTapped = PassthroughSubject<Void?, Never>()

    func removeCancellables() {
        cancellables.removeAll()
    }
    
    func editTask(text: String) {
        editTask.send(text)
    }
    
    func dismissScreen() {
        closeTapped.send(Void())
    }
}
