//
//  Hahow_iOS_RecruitTests.swift
//  Hahow-iOS-RecruitTests
//
//  Created by Tommy Lin on 2021/10/5.
//

import XCTest
@testable import Hahow_iOS_Recruit

class Hahow_iOS_RecruitTests: XCTestCase {
    var mock: HahowSessionMock!
    var manager: NetworkManager!
    
    override func setUpWithError() throws {
        mock = HahowSessionMock()
        manager = NetworkManager(session: mock)
    }

    override func tearDownWithError() throws {
        mock = nil
        manager = nil
    }

    func testExample() throws {
        manager.loadData(with: URL(string: "mock")!) { model in
            XCTAssertEqual(model?.data.count, 4)
            XCTAssertEqual(model?.data.first?.category, "programming")
        }
    }
    
    func testViewModel() throws {
        let vm = ViewModel()
        vm.callMockAPI {
            XCTAssertEqual(vm.numberOfSection(), 4)
            let course = vm.getCourse(IndexPath(item: 0, section: 0))
            XCTAssertEqual(course.category, "programming")
        }
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
