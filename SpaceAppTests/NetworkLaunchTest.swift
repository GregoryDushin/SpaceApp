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
    private var testError: Error!

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
        "rocket":"test",
        "success":false,
        "name":"FalconSat_Test",
        "date_utc":"2001-01-01T04:00:00.000+0400"
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

        testData = [
            LaunchModelElement(
                success: false,
                name: "FalconSat_Test",
                dateUtc: Date(timeIntervalSinceReferenceDate: 0.0),
                rocket: "test"
            )
        ]
    }

    override func tearDown() {
        launchLoader = nil
    }

    func testLaunvhDataRecieving() async {

        let exp = expectation(description: "Loading data")

        launchLoader.launchDataLoad(id: "test") { launches in
            switch launches {
            case .success(let launches):
                self.launchData = launches
                exp.fulfill()
            case .failure(let error):
                self.testError = error
            }
        }

        await waitForExpectations(timeout: 3)

        XCTAssertEqual(launchData, testData)
        XCTAssertNil(testError)
        
    }
}
