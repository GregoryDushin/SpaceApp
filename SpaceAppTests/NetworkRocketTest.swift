//
//  NetworkRocketTest.swift
//  SpaceAppTests
//
//  Created by Григорий Душин on 26.12.2022.
//
import XCTest

@testable import SpaceApp

 class URLProtocolMock: URLProtocol {

    static var mockURLs = [URL?: (error: Error?, data: Data?, response: HTTPURLResponse?)]()

    override class func canInit(with request: URLRequest) -> Bool {
        true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }

    override func startLoading() {
        if let url = request.url {
            if let (error, data, response) = URLProtocolMock.mockURLs[url] {

                if let responseStrong = response {
                    self.client?.urlProtocol(self, didReceive: responseStrong, cacheStoragePolicy: .notAllowed)
                }

                if let dataStrong = data {
                    self.client?.urlProtocol(self, didLoad: dataStrong)
                }

                if let errorStrong = error {
                    self.client?.urlProtocol(self, didFailWithError: errorStrong)
                }
            }
        }

        self.client?.urlProtocolDidFinishLoading(self)
    }
    override func stopLoading() {

    }
}

class NetworkRocketTest: XCTestCase {
    var rocketLoader: RocketLoader!
    var rocketData: [RocketModelElement] = []
    let error: Error? = nil
    let response = HTTPURLResponse(url: URL(string: "https://api.spacexdata.com/v4/rockets")!, statusCode: 200, httpVersion: nil, headerFields: nil)
    let data = """
      [
        {
            "height":{"meters":22.25,"feet":73},
            "diameter":{"meters":1.68,"feet":5.9},
            "mass":{"kg":30146,"lb":66460},
            "first_stage":{
                "engines":1,
                "fuel_amount_tons":44.3,
                "burn_time_sec":169},
            "second_stage":{
                "engines":1,
                "fuel_amount_tons":3.38,
                "burn_time_sec":378},
            "payload_weights":[{"kg":450,"lb":992}],
            "flickr_images":["https://imgur.com/DaCfMsj.jpg","https://imgur.com/azYafd8.jpg"],
            "name":"Falcon 1 Test",
            "stages":2,
            "cost_per_launch":6700000,
            "first_flight":"2006-03-24",
            "id":"5e9d0d95eda69955f709d1eb"
        }
      ]
    """.data(using: .utf8)

    override func setUpWithError() throws {

        URLProtocolMock.mockURLs = [URL(string: "https://api.spacexdata.com/v4/rockets")!: (error, data, response)]
        let sessionConfiguration = URLSessionConfiguration.ephemeral
        sessionConfiguration.protocolClasses = [URLProtocolMock.self]
        let mockedSession = URLSession(configuration: sessionConfiguration)
        rocketLoader = RocketLoader(urlSession: mockedSession)
    }

    override func tearDownWithError() throws {
        rocketLoader = nil
    }

    func testNetwork() {

        let exp = expectation(description: "Loading data")

        rocketLoader.rocketDataLoad { rockets in
            DispatchQueue.main.async {
                switch rockets {
                case .success(let rockets):
                    self.rocketData = rockets
                    exp.fulfill()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
        waitForExpectations(timeout: 3)

        XCTAssertEqual(rocketData[0].name, "Falcon 1 Test")

        }
    }
