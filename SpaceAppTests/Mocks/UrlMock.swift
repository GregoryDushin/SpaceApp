//
//  UrlMock.swift
//  SpaceAppTests
//
//  Created by Григорий Душин on 09.01.2023.
//

import XCTest

final class URLMock: URLProtocol {

    static var mockURLs = [URL?: (error: Error?, data: Data?, response: HTTPURLResponse?)]()

    override class func canInit(with request: URLRequest) -> Bool {
        true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }

    override func startLoading() {
        guard let url = request.url, let (error, data, response) = URLMock.mockURLs[url] else { return }

                if let response = response {
                    self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
                }

                if let data = data {
                    self.client?.urlProtocol(self, didLoad: data)
                }

                if let error = error {
                    self.client?.urlProtocol(self, didFailWithError: error)
                }

        self.client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {
    }
}
