//
//  NetworkRocketTest.swift
//  SpaceAppTests
//
//  Created by Григорий Душин on 26.12.2022.
//
import XCTest

@testable import SpaceApp

final class NetworkRocketTest: XCTestCase {
    private var rocketLoader: RocketLoader!
    private var rocketDataFromLoader = [RocketModelElement]()
    private var mockRocketData = [RocketModelElement]()
    private let mockError = ErrorMock()
    private var errorFromLoader: ErrorMock? = nil
    private var mockData = Data()

    private func makeMockSession(data: Data?, error: Error?) -> URLSession {
        let response = HTTPURLResponse(
            url: URL(string: "https://api.spacexdata.com/v4/rockets")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
        URLMock.mockURLs = [URL(string: "https://api.spacexdata.com/v4/rockets")!: (error, data, response)]
        let sessionConfiguration = URLSessionConfiguration.ephemeral

        sessionConfiguration.protocolClasses = [URLMock.self]

        return URLSession(configuration: sessionConfiguration)
    }

    override func setUp() {
        mockData = """
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
        """.data(using: .utf8)!

        mockRocketData = [
            RocketModelElement(
                height: .init(meters: 22.25, feet: 73),
                diameter: .init(meters: 1.68, feet: 5.9),
                mass: .init(kg: 30_146, lb: 66_460),
                firstStage: .init(engines: 1, fuelAmountTons: 44.3, burnTimeSec: 169),
                secondStage: .init(engines: 1, fuelAmountTons: 3.38, burnTimeSec: 378),
                payloadWeights: [.init(kg: 450, lb: 992)],
                flickrImages: ["https://imgur.com/DaCfMsj.jpg", "https://imgur.com/azYafd8.jpg"],
                name: "Falcon 1 Test",
                stages: 2,
                costPerLaunch: 6_700_000,
                firstFlight: "2006-03-24",
                id: "5e9d0d95eda69955f709d1eb"
            )
        ]
    }

    override func tearDown() {
        rocketLoader = nil
    }

    func testRocketDataRecieving() async {
        rocketLoader = RocketLoader(urlSession: makeMockSession(data: mockData, error: nil))

        let exp = expectation(description: "Loading data")

        rocketLoader.rocketDataLoad { rockets in
            switch rockets {
            case .success(let rockets):
                self.rocketDataFromLoader = rockets
            case .failure(let error):
                self.errorFromLoader = error as? ErrorMock
            }
            exp.fulfill()
        }

        await waitForExpectations(timeout: 3)

        XCTAssertEqual(rocketDataFromLoader, mockRocketData)
        XCTAssertNil(errorFromLoader)
    }

    func testRocketErrorRecieving() async {
        rocketLoader = RocketLoader(urlSession: makeMockSession(data: nil, error: nil))

        let exp = expectation(description: "Loading error")

        rocketLoader.rocketDataLoad { rockets in
            switch rockets {
            case .success(let rockets):
                self.rocketDataFromLoader = rockets
            case .failure(let error):
                self.errorFromLoader = error as? ErrorMock
            }
            exp.fulfill()
        }

        await waitForExpectations(timeout: 3)
        XCTAssertEqual(errorFromLoader, mockError)
    }
}
