//
//  File.swift
//  BookPlace
//
//  Created by Nazar on 06.02.18.
//  Copyright © 2018 Nazar. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class RestAPIManager {
    private let apiSearch = "https://www.googleapis.com/books/v1/volumes"
    private let apiKey = "AIzaSyBwXTWWEKwx5u8SWhgZktRtn_xrKqVOyU8"
    
    func searchBook(searchText: String, offset: Int, handlerResponseAPICompletion: @escaping (BooksPesponse?) -> Void ) {
       let url = createQuery(searchText: searchText, offset: offset)
        Alamofire.request(url).responseJSON{ (response) in
            let json = JSON(response.result.value!)
            do {
                let booksPesponse = try JSONDecoder().decode(BooksPesponse.self, from:  json.rawData())
                handlerResponseAPICompletion(booksPesponse)
            } catch let error {
                Swift.print(error)
            }
        }
    }
    
    private func createQuery(searchText: String, offset: Int) -> URL {
        let firstValue = searchText.replacingOccurrences(of: " ", with: "+")
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "q", value: firstValue))
        queryParameters.append(URLQueryItem(name: "maxResults", value: "15"))
        queryParameters.append(URLQueryItem(name: "startIndex", value: String(offset)))
        queryParameters.append(URLQueryItem(name: "key", value: apiKey))
        var query = URLComponents(url: URL.init(string: apiSearch)! , resolvingAgainstBaseURL: true)
        query?.queryItems = queryParameters
        return  (query?.url)!
    }
}

class Connectivity {
    class func isConnectedToInternet() ->Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}

struct BooksPesponse: Decodable {
    let kind: String
    let totalItems: Int
    let items: [Item]
}
struct Item: Decodable {
    let kind: String?
    let id: String
    let etag: String?
    let selfLink: String?
    let volumeInfo: VolumInfo
}
struct VolumInfo: Decodable {
    let title: String?
    let subtitle: String?
    let authors: [String]?
    let publisher: String?
    let publishedDate: String?
    let description: String?
    let imageLinks: ImageLinks?
}
struct ImageLinks: Decodable {
    let smallThumbnail: String?
    let thumbnail: String?
}

