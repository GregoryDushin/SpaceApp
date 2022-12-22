//
//  CustomPageViewTests.swift
//  SpaceAppTests
//
//  Created by Григорий Душин on 22.12.2022.
//

import XCTest
@testable import SpaceApp

class MockCustomView: CustomPageViewProtocol {
    var titleTest: String?

    func failure(error: Error) {
        self.titleTest = "failure"
    }

    func success(data: [RocketModelElement]) {
        self.titleTest = data[0].name
    }
}

class CustomPageViewTests: XCTestCase {
    var view: MockCustomView!
    var presenter: CustomPagePresenter!

    override func setUpWithError() throws {
        view = MockCustomView()
        presenter = CustomPagePresenter(rocketLoader: RocketLoader()) // инициализируем презентер
        presenter.view = view
    }

    override func tearDownWithError() throws {
        view = nil
        presenter = nil
    }

    func testCustomPageIsNotNil() {
        XCTAssertNotNil(view, "view is not nil")
        XCTAssertNotNil(presenter, "presenter is not nil")
    }

    func testCustomPageView() {
        presenter.getData()
        XCTAssertEqual(view.titleTest, "hui_znaet_pochemu_titleTest_nil")  // Должнно быть Falcon 1...
    }
}

