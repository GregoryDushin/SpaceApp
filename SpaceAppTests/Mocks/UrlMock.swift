//
//  UrlMock.swift
//  SpaceAppTests
//
//  Created by Григорий Душин on 09.01.2023.
//

import XCTest

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
