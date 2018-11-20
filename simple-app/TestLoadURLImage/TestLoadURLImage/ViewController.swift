//
//  ViewController.swift
//  TestLoadURLImage
//
//  Created by Binh Van Nguyen on 11/20/18.
//  Copyright © 2018 Binh Van Nguyen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    let urlKey: String = "http://image.tmdb.org/t/p/w500/uxzzxijgPIY7slzFvMotPv8wjKA.jpg"
        let titleFilm: String = "Three Billboards Outside Ebbing, Missouri"
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }


    @IBAction func click(_ sender: Any) {
        if let url = URL(string: urlKey) {
            do {
                let data = try Data(contentsOf: url)
                self.imageView.image = UIImage(data: data)
            } catch let err {
                print("Error: \(err.localizedDescription)")
            }
        }

        titleLabel.text = titleFilm
    }
}

