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
    private var launchDataFromPresenter = [LaunchModelElement]()
    private let error: Error? = nil
    private var launchArrayForComparingData = [LaunchModelElement]()
    private var errorFromPresenter: Error!
    private var correctData = Data()
    private var wrongData = Data()

    private func makeMockSession(data: Data) -> URLSession {
        let response = HTTPURLResponse(
            url: URL(string: "https://api.spacexdata.com/v4/launches")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
        URLProtocolMock.mockURLs = [URL(string: "https://api.spacexdata.com/v4/launches")!: (error, data, response)]
        let sessionConfiguration = URLSessionConfiguration.ephemeral
        sessionConfiguration.protocolClasses = [URLProtocolMock.self]

        return URLSession(configuration: sessionConfiguration)
    }

    override func setUp() {
        launchArrayForComparingData = [
            LaunchModelElement(
                success: false,
                name: "FalconSat_Test",
                dateUtc: Date(timeIntervalSinceReferenceDate: 0.0),
                rocket: "test"
            )
        ]
        correctData = """
                   [
                     {
                 "rocket":"test",
                 "success":false,
                 "name":"FalconSat_Test",
                 "date_utc":"2001-01-01T04:00:00.000+0400"
                 }
                   ]
                 """.data(using: .utf8)!
        wrongData = "testDataForError".data(using: .utf8)!
    }

    override func tearDown() {
        launchLoader = nil
    }

    func testDataRecievingFromLaunchLoader() async {
        let exp = expectation(description: "Recieving data")
        launchLoader = LaunchLoader(urlSession: makeMockSession(data: correctData))
        launchLoader.launchDataLoad(id: "test") { launches in
            switch launches {
            case .success(let launches):
                self.launchDataFromPresenter = launches
            case .failure(let error):
                self.errorFromPresenter = error
            }

            exp.fulfill()
        }

        await waitForExpectations(timeout: 3)
        XCTAssertEqual(launchDataFromPresenter, launchArrayForComparingData)
        XCTAssertNil(errorFromPresenter)
    }

    func testErrorRecievingFromLaunchLoader() async {
        let exp = expectation(description: "Recieving error")
        launchLoader = LaunchLoader(urlSession: makeMockSession(data: wrongData))
        launchLoader.launchDataLoad(id: "test") { launches in
            switch launches {
            case .success(let launches):
                self.launchDataFromPresenter = launches
            case .failure(let error):
                self.errorFromPresenter = error
            }

            exp.fulfill()
        }

        await waitForExpectations(timeout: 3)
        XCTAssertNotNil(errorFromPresenter)
    }
}
