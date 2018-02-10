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
    private let apiSearch = "https://www.googleapis.com/books/v1/volumes?q=Harry+Potter&key={YOUR_API_KEY}"
    private let apiKey = "AIzaSyBwXTWWEKwx5u8SWhgZktRtn_xrKqVOyU8"
    
    func searchBook(withName: String, handlerResponseAPICompletion: @escaping (BooksPesponse?) -> Void ) {
        
        let url = URL(string: "https://www.googleapis.com/books/v1/volumes?q=Harry+Potter&key=AIzaSyBwXTWWEKwx5u8SWhgZktRtn_xrKqVOyU8")
        Alamofire.request(url!, method: .get).responseJSON{ (response) in
            
            print("Response: ", response.result.isSuccess)
            let json = JSON(response.result.value!)
            do {
                let booksPesponse = try JSONDecoder().decode(BooksPesponse.self, from:  json.rawData())
                Swift.print("MY JSON OBJECT:     \(booksPesponse.totalItems) \n\n\n")
                handlerResponseAPICompletion(booksPesponse)
            } catch let error {
                Swift.print(error)
            }
        }
    }
    
    func searchTwo(complition: @escaping (Data) -> Void) {
        let url = URL(string: "https://www.googleapis.com/books/v1/volumes?q=Harry+Potter&key=AIzaSyBwXTWWEKwx5u8SWhgZktRtn_xrKqVOyU8")
        
        _ = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            guard error == nil else {
                print("ERROR: ", error)
                return
            }
            print("              norma")
            complition(data!)
            }.resume()
    }
}


struct BooksPesponse: Decodable {
    let kind: String
    let totalItems: Int
    let items: [Item]
}
struct Item: Decodable {
    let kind: String?
    let id: String?
    let etag: String?
    let selfLink: String?
    let volumeInfo: VolumInfo?
}
struct VolumInfo: Decodable {
    let title: String
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

/*
 
 "pageCount": 418,
 "printType": "BOOK",
 "categories": [
 "Literary Criticism"
 ],
 "averageRating": 4.5,
 "ratingsCount": 12,
 "maturityRating": "NOT_MATURE",
 "allowAnonLogging": false,
 "contentVersion": "2.0.3.0.preview.3",
 "panelizationSummary": {
 "containsEpubBubbles": false,
 "containsImageBubbles": false
 },
 "imageLinks": {
 "smallThumbnail": "http://books.google.com/books/content?id=iO5pApw2JycC&printsec=frontcover&img=1&zoom=5&edge=curl&source=gbs_api",
 "thumbnail": "http://books.google.com/books/content?id=iO5pApw2JycC&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api"
 },
 "language": "en",
 "previewLink": "http://books.google.com.ua/books?id=iO5pApw2JycC&printsec=frontcover&dq=Harry+Potter&hl=&cd=2&source=gbs_api",
 "infoLink": "http://books.google.com.ua/books?id=iO5pApw2JycC&dq=Harry+Potter&hl=&source=gbs_api",
 "canonicalVolumeLink": "https://books.google.com/books/about/The_Ivory_Tower_and_Harry_Potter.html?hl=&id=iO5pApw2JycC"
 },
 */
