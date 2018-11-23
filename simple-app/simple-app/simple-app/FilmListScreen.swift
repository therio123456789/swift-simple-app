//
//  FilmListScreen.swift
//  simple-app
//
//  Created by Binh Van Nguyen on 11/19/18.
//  Copyright © 2018 Binh Van Nguyen. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SwiftGifOrigin

class FilmListScreen: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let LOADING_ASSET = "loading"
    
    let URL_GET_DATA = "http://www.mocky.io/v2/5bf3bce23100002c00619909"
    
    let HOST_IMAGE = "http://image.tmdb.org/t/p/w500"
    
    @IBOutlet weak var loadingImage: UIImageView!
    @IBOutlet weak var filmTable: UITableView!
    
    var films = [Film]()
    var filmGroup: [String: [Film]] = [:]
    var groupTitles: [String] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return (filmGroup[groupTitles[section]]?.count)!
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return filmGroup.count
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return groupTitles
    }
    
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return index
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return groupTitles[section] as? String
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let film = filmGroup[groupTitles[indexPath.section]]![indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FilmCell") as! FilmCell
        
        cell.setFilm(film: film)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 125
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareForData()
    }
    
    fileprivate func prepareForData() {
        filmTable.isHidden = true
        loadingImage.isHidden = false
        self.loadingImage.image = UIImage.gif(asset: LOADING_ASSET)
        createDataCompletion(completion: {
            (filmsTemp) in
            self.films = filmsTemp
            self.filmGroup = self.createFilmGroupByTitle(self.films)
            self.groupTitles = Array(self.filmGroup.keys).sorted {
                $0 < $1
            }
            self.filmTable.reloadData()
            self.filmTable.isHidden = false
            self.loadingImage.isHidden = true
        })
    }
    
    fileprivate func createFilmGroupByTitle(_ filmsTemp: [Film]) -> [String: [Film]] {
        let filmsSorted = self.sortArrayByAlphabet(filmsRaw: filmsTemp)
        var filmGroupTemp: [String: [Film]] = [:]
        var groupTitle = ""
        var filmsInGroup: [Film] = []
        for i in 0..<filmsSorted.count {
            let firstChar = getFirstLetterTitle(filmsSorted[i].title)
            if i == 0 {
                groupTitle = firstChar
            }
            
            if i == filmsSorted.count - 1 {
                filmGroupTemp[groupTitle] = filmsInGroup
            }
            
            if groupTitle != firstChar {
                filmGroupTemp[groupTitle] = filmsInGroup
                
                filmsInGroup = []
                groupTitle = firstChar
                filmsInGroup.append(filmsSorted[i])
                continue
            } else {
                filmsInGroup.append(filmsSorted[i])
            }
        }
        return filmGroupTemp
    }
    
    fileprivate func getFirstLetterTitle(_ text: String) -> String {
        return String(text.prefix(1))
    }
    
    fileprivate func sortArrayByAlphabet( filmsRaw: [Film]) -> [Film] {
        return filmsRaw.sorted {
            $0.title < $1.title
        }
    }
    
    fileprivate func createDataCompletion(completion:@escaping (_ filmsTemp: [Film]) ->()) {
        var filmsTemp = [Film]()
        Alamofire.request(URL_GET_DATA).responseJSON { response in
            switch(response.result) {
            case .success(_):
                if let json = response.result.value {
                    filmsTemp = self.getFilmArray(json)
                }
                completion(filmsTemp)
                break
            case .failure(_):
                completion(filmsTemp)
                break;
            }
        }
    }
    
    fileprivate func createFilmArray(_ data: Data) -> [Film] {
        var filmsTemp = [Film]()
        do {
            if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [Dictionary<String,Any>]
            {
                for i in 0..<jsonArray.count {
                    let film = self.getFilmObject(jsonArray, i)
                    filmsTemp.append(film)
                }
            } else {
                print("Bad Json")
            }
        } catch let error as NSError {
            print(error)
        }
        return filmsTemp
    }
    
    fileprivate func getFilmArray(_ json: Any) -> [Film] {
        let data = "\(json)".data(using: .utf8)!
        return createFilmArray(data)
    }
    
    fileprivate func getFilmObject(_ jsonArray: [[String : Any]], _ i: Int) -> Film {
        let filmData = jsonArray[i]
        let filmTitle: String = "\(String(describing: filmData["title"]!))"
        let filmPosterUrl: String = self.HOST_IMAGE+"\(String(describing: filmData["poster_path"]!))"
        let filmOverview: String = "\(String(describing: filmData["overview"]!))"
        return Film(imageUrl: filmPosterUrl, title: filmTitle, overview: filmOverview)
    }
    
}

extension UIImage {
    public class func gif(asset: String) -> UIImage? {
        if let asset = NSDataAsset(name: asset) {
            return UIImage.gif(data: asset.data)
        }
        return nil
    }

}
