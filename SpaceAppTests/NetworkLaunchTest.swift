//
//  NetworkLaunchTest.swift
//  SpaceAppTests
//
//  Created by Григорий Душин on 28.12.2022.
//

import XCTest
@testable import SpaceApp

class NetworkLaunchTest: XCTestCase {
    var launchLoader: LaunchLoader!
    var launchData: [LaunchModelElement] = []
    let error: Error? = nil
    let response = HTTPURLResponse(url: URL(string: "https://api.spacexdata.com/v4/launches")!, statusCode: 200, httpVersion: nil, headerFields: nil)
    let data = """
      [
        {
    "rocket":"5e9d0d95eda69955f709d1eb",
    "success":false,
    "name":"FalconSat_Test",
    "date_utc":"2006-03-24T22:30:00.000Z"
    }
      ]
    """.data(using: .utf8)

    override func setUpWithError() throws {
        URLProtocolMock.mockURLs = [URL(string: "https://api.spacexdata.com/v4/launches")!: (error, data, response)]

        let sessionConfiguration = URLSessionConfiguration.ephemeral

        sessionConfiguration.protocolClasses = [URLProtocolMock.self]

        let mockedSession = URLSession(configuration: sessionConfiguration)
        launchLoader = LaunchLoader(urlSession: mockedSession)
    }

    override func tearDownWithError() throws {
        launchLoader = nil
    }

    func testNetwork() {

        let exp = expectation(description: "Loading data")

        launchLoader.launchDataLoad(id: "5e9d0d95eda69955f709d1eb") { launches in
            DispatchQueue.main.async {
                switch launches {
                case .success(let launches):
                    self.launchData = launches
                    exp.fulfill()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }

        waitForExpectations(timeout: 3)

        XCTAssertEqual(launchData[0].name, "FalconSat_Test")
    }
}
