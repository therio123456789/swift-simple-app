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
    var posterImageUrl: String
    var title: String
    var overview: String
    var isFavourite: Bool = false
    
    init(imageUrl: String, title: String, overview: String) {
        self.posterImageUrl = imageUrl
        self.title = title
        self.overview = overview
    }
}
