//
//  ViewCoding.swift
//  ToDoListVIPER
//
//  Created by Lucas on 18/04/25.
//

import Foundation

protocol ViewCoding {
    func setupHierarchy()
    func setupConstraints()
    func setupAdditionalConfiguration()
    func setupView()
}

extension ViewCoding {
    func setupView() {
        setupHierarchy()
        setupConstraints()
        setupAdditionalConfiguration()
    }
}
