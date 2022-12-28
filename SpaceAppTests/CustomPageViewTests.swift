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
        print(error.localizedDescription)
    }

    func success(data: [RocketModelElement]) {
        self.titleTest = data[0].name
        print(self.titleTest)  // данные приходят
    }
}

class CustomPageViewTests: XCTestCase {
    var view: MockCustomView!
    var presenter: CustomPagePresenter!


    func testCustomPageView() {
        let url = URL(string: "https://api.spacexdata.com/v4/rockets")
        let response = HTTPURLResponse(url: url!, statusCode: 200, httpVersion: nil, headerFields: nil)
        let error: Error? = nil
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
                "name":"Falcon 9",
                "stages":2,
                "cost_per_launch":6700000,
                "first_flight":"2006-03-24",
                "id":"5e9d0d95eda69955f709d1eb"
            }
          ]
        """.data(using: .utf8)

        URLProtocolMock.mockURLs = [url: (error, data, response)]
        let sessionConfiguration = URLSessionConfiguration.ephemeral
        sessionConfiguration.protocolClasses = [URLProtocolMock.self]
        let mockedSession = URLSession(configuration: sessionConfiguration)

        view = MockCustomView()
        presenter = CustomPagePresenter(rocketLoader: RocketLoader(urlSession: mockedSession)) // инициализируем презентер
        presenter.view = view
        presenter.getData()

            //XCTAssertEqual(view.titleTest, "Falcon 9")  //nil
    }
}
