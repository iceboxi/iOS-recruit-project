//
//  NetworkManager.swift
//  Hahow-iOS-Recruit
//
//  Created by ice on 2021/11/5.
//

import Foundation

// MARK: - URLSession response handlers
protocol MySession {
    func loadData(with url: URL, complete: @escaping (Data?, Error?) -> Void)
}

extension URLSession: MySession {
    func loadData(with url: URL, complete: @escaping (Data?, Error?) -> Void) {
        let task = dataTask(with: url) { (data, _, error) in
            complete(data, error)
        }

        task.resume()
    }
}

class NetworkManager {
    private let session: MySession

    init(session: MySession = URLSession.shared) {
        self.session = session
    }

    func loadData(with url: URL, complete: @escaping (Hahow?) -> Void) {
        session.loadData(with: url) { data, _ in
            guard let data = data else {
                complete(nil)
                return
            }
            
            let result = Hahow(data: data)
            complete(result)
        }
    }
}

class HahowSessionMock: MySession {
    var data: Data? = try! Data(contentsOf: Bundle(for: ViewController.self).url(forResource: "data", withExtension: "json")!)
    var error: Error?

    func loadData(with url: URL, complete: @escaping (Data?, Error?) -> Void) {
        complete(data, error)
    }
}
