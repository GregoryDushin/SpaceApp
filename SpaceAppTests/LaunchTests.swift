//
//  LaunchTests.swift
//  SpaceAppTests
//
//  Created by Григорий Душин on 22.12.2022.
//

import XCTest
@testable import SpaceApp

class MockLaunchView: LaunchViewProtocol {
    var titleTest: String?

    func failure(error: Error) {
        titleTest = "failure"
    }

    func success(data: [LaunchData]) {
        titleTest = data[0].name //данные приходят
        print(titleTest)
    }
}

class LaunchTests: XCTestCase {
    var view: MockLaunchView!
    var presenter: LaunchPresenter!

    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }

    func testLaunchView() {
        let error: Error? = nil
        let url = URL(string: "https://api.spacexdata.com/v4/launches")
        let response = HTTPURLResponse(url: url!, statusCode: 200, httpVersion: nil, headerFields: nil)
        let data = """
          [
            {
        "rocket":"5e9d0d95eda69955f709d1eb",
        "success":false,
        "name":"FalconSat",
        "date_utc":"2006-03-24T22:30:00.000Z"
        }
          ]
        """.data(using: .utf8)

        URLProtocolMock.mockURLs = [url: (error, data, response)]

        let sessionConfiguration = URLSessionConfiguration.ephemeral

        sessionConfiguration.protocolClasses = [URLProtocolMock.self]

        let mockedSession = URLSession(configuration: sessionConfiguration)

        presenter = LaunchPresenter(launchLoader: LaunchLoader(urlSession: mockedSession), id: "5e9d0d95eda69955f709d1eb")
        presenter.view = view
        presenter.getData()
    }
}
