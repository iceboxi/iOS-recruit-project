//
//  Model.swift
//  Hahow-iOS-Recruit
//
//  Created by ice on 2021/11/4.
//

import Foundation

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

public protocol Model: Codable, Equatable {
    init?(data: Data)
    func encode() -> Data?
}

extension Model {
    public init?(data: Data) {
        do {
            self = try JSONDecoder().decode(Self.self, from: data)
        } catch {
            print("Decode Error: \(error)")
            return nil
        }
    }
    
    public func encode() -> Data? {
        do {
            return try JSONEncoder().encode(self)
        } catch {
            return nil
        }
    }
    
    public static func ==(lhs: Self, rhs: Self) -> Bool {
        return lhs.encode() == rhs.encode()
    }
}
