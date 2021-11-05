//
//  Model.swift
//  Hahow-iOS-Recruit
//
//  Created by ice on 2021/11/4.
//

import Foundation
import IITool

// MARK: - Hahow
struct Hahow: Model {
    let data: [Classmute]
}

// MARK: - Classmute
struct Classmute: Model {
    let category: String
    let courses: [Course]
}

// MARK: - Course
struct Course: Model {
    let title: String
    let coverImageUrl: String
    let name: String
    let category: String
}

