//
//  NetworkLaunchTest.swift
//  SpaceAppTests
//
//  Created by Григорий Душин on 28.12.2022.
//

import XCTest
@testable import SpaceApp

class NetworkLaunchTest: XCTestCase {

    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }

    func testNetwork() {
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
        let launchLoader = LaunchLoader(urlSession: mockedSession)

        launchLoader.launchDataLoad(id: "5e9d0d95eda69955f709d1eb") { launches in
            DispatchQueue.main.async {
                switch launches {
                case .success(let launches):
                    print(launches)  // данные приходят
                    XCTAssertEqual(launches[0].name, "hui")
                case .failure(let error):
                    print(error.localizedDescription)
                    XCTAssertNil(error)
                }
            }
        }
    }

}
