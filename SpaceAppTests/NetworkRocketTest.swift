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
    private var rocketData: [RocketModelElement] = []
    private let error: Error? = nil
    private var rocketDataTest: [RocketModelElement]!
    private var testError: Error!

    private func makeMockSession() -> URLSession {
        let response = HTTPURLResponse(
            url: URL(string: "https://api.spacexdata.com/v4/rockets")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
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

        URLProtocolMock.mockURLs = [URL(string: "https://api.spacexdata.com/v4/rockets")!: (error, data, response)]
        let sessionConfiguration = URLSessionConfiguration.ephemeral

        sessionConfiguration.protocolClasses = [URLProtocolMock.self]

        return URLSession(configuration: sessionConfiguration)
    }

    override func setUp() {

        rocketLoader = RocketLoader(urlSession: makeMockSession())
        rocketDataTest = [
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

    func testRocketDataRecieving() {

        let exp = expectation(description: "Loading data")

        rocketLoader.rocketDataLoad { rockets in
            DispatchQueue.main.async {
                switch rockets {
                case .success(let rockets):
                    self.rocketData = rockets
                    exp.fulfill()
                case .failure(let error):
                    self.testError = error
                }
            }
        }

        waitForExpectations(timeout: 3)

        XCTAssertEqual(rocketData, rocketDataTest)
        XCTAssertNil(testError)
    }
}
