//
//  Film.swift
//  simple-app
//
//  Created by Binh Van Nguyen on 11/19/18.
//  Copyright © 2018 Binh Van Nguyen. All rights reserved.
//
import UIKit
import Foundation
class Film {
    var image: UIImage
    var title: String
    var overview: String
    
    init(imageUrl: String, title: String, overview: String) {
        self.image = Film.getImage(imageUrl)!
        self.title = title
        self.overview = overview
    }
    
    fileprivate static func getImage(_ imageUrl: String) -> UIImage? {
        if let url = URL(string: imageUrl) {
            do {
                let data = try Data(contentsOf: url)
                return UIImage(data: data)
            } catch let err {
                print("Error: \(err.localizedDescription)")
            }
        }
        return UIImage()
    }
}
