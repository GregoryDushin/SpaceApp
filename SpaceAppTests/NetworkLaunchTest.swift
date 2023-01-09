//
//  NetworkLaunchTest.swift
//  SpaceAppTests
//
//  Created by Григорий Душин on 28.12.2022.
//

import XCTest
@testable import SpaceApp

final class NetworkLaunchTest: XCTestCase {
    private var launchLoader: LaunchLoader!
    private var launchData: [LaunchModelElement] = []
    private let error: Error? = nil
    private var testData: [LaunchModelElement]!

    private func makeMockSession() -> URLSession {
        let response = HTTPURLResponse(
            url: URL(string: "https://api.spacexdata.com/v4/launches")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
        let data = """
          [
            {
        "rocket":"5e9d0d95eda69955f709d1eb",
        "success":false,
        "name":"FalconSat_Test",
        "date_utc":"1970-01-01T04:00:03.142+0400"
        }
          ]
        """.data(using: .utf8)
        URLProtocolMock.mockURLs = [URL(string: "https://api.spacexdata.com/v4/launches")!: (error, data, response)]
        let sessionConfiguration = URLSessionConfiguration.ephemeral

        sessionConfiguration.protocolClasses = [URLProtocolMock.self]

        return URLSession(configuration: sessionConfiguration)
    }

    override func setUp() {

        launchLoader = LaunchLoader(urlSession: makeMockSession())

        testData = [LaunchModelElement(
            success: false,
            name: "FalconSat_Test",
            dateUtc: Date(timeIntervalSince1970: .pi),
            rocket: "5e9d0d95eda69955f709d1eb"
        )
        ]
    }

    override func tearDown() {
        launchLoader = nil
    }

    func testLaunvhDataRecieving() {

        let exp = expectation(description: "Loading data")

        launchLoader.launchDataLoad(id: "5e9d0d95eda69955f709d1eb") { launches in
            DispatchQueue.main.async {
                switch launches {
                case .success(let launches):
                    self.launchData = launches
                    exp.fulfill()
                case .failure:
                    XCTFail("Request failed")
                }
            }
        }

        waitForExpectations(timeout: 3)

        XCTAssertEqual(launchData[0].name, "FalconSat_Test")
        XCTAssertEqual(launchData[0].name, testData[0].name)
        XCTAssertEqual(launchData[0].rocket, testData[0].rocket)
        XCTAssertEqual(launchData[0].success, testData[0].success)
        // XCTAssertEqual(launchData[0].dateUtc, testData[0].dateUtc)
    }
}
