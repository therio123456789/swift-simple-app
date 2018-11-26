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
    
    static let TITLE = "title"
    static let POSTER = "poster_path"
    static let OVERVIEW = "overview"
    
    var title: String
    var overview: String
    var posterImageUrl: String
    private var favourite: Bool = false
    
    init(imageUrl: String, title: String, overview: String) {
        self.posterImageUrl = imageUrl
        self.title = title
        self.overview = overview
    }
    
    func setFavourite(favourite: Bool) {
        self.favourite = favourite
    }
    
    func isFavourite() -> Bool {
        return self.favourite
    }
}
