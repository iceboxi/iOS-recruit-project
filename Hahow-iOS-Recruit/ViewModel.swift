//
//  ViewModel.swift
//  Hahow-iOS-Recruit
//
//  Created by ice on 2021/11/5.
//

import Foundation

class ViewModel {
    var items: [Classmute] = []
    
    func callMockAPI(_ complete: (() -> Void)?) {
        let mock = HahowSessionMock()
        let manager = NetworkManager(session: mock)
        manager.loadData(with: URL(string: "mock")!) { [weak self] result in
            guard let result = result else {
                return
            }
            
            self?.items = result.data
            complete?()
        }
    }
    
    func numberOfSection() -> Int {
        return items.count
    }
    
    func numberOfRow(_ section: Int, style: Bool) -> Int {
        var max = 3
        if style {
            max = 4
        }
        return items[section].courses.count > max ? max : items[section].courses.count
    }
    
    func getCourse(_ indexPath: IndexPath) -> Course {
        return items[indexPath.section].courses[indexPath.row]
    }
    
    func getSectionTitle(_ section: Int) -> String {
        let model = items[section]
        return model.category
    }
}
