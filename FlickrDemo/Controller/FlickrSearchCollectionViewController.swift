//
//  FlickrSearchCollectionViewController.swift
//  FlickrDemo
//
//  Created by apple on 2020/5/22.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class FlickrSearchCollectionViewController: UICollectionViewController {
    
    var photos = [Photo]()
    var inputText: String?
    var numberText: String?
    let apiKey = "7f2e7c8fd464ffcf5afa9afcc5239f40"
    

    override func viewDidLoad() {
        super.viewDidLoad()

        let layout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        let width = (view.bounds.width - 10) / 2
        layout?.itemSize = CGSize(width: width, height: width + 80)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.title = "搜尋結果 \(inputText!)"
        fetchData()
    }
    
    func fetchData() {
        var encodedString: String?
        
        //判斷輸入的字串是否為漢字
        if isIncludeChineseIn(string: inputText!) {
            encodedString = inputText!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        } else {
            encodedString = inputText!
        }
        
        //b1f2069dbe375757c1c5da8a7a76de47
        if let url = URL(string: "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(apiKey)&text=\( encodedString!)&per_page=\(numberText!)&format=json&nojsoncallback=1") {
            print(url)
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let data = data, let searchData = try? JSONDecoder().decode(SearchData.self, from: data) {
                    self.photos = searchData.photos.photo
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                }
            }
            
            task.resume()
        }
    }
    
    /// 判斷是否為漢字
    ///
    /// - Parameter string: 判斷傳入的字串
    /// - Returns:為漢字的話回傳true
    func isIncludeChineseIn(string: String) -> Bool {
        //string.characters.enumerated()
        for (_, value) in string.enumerated() {
            
            if ("\u{4E00}" <= value  && value <= "\u{9FA5}") {
                return true
            }
        }
        
        return false
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return photos.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PhotoCollectionViewCell
    
        // Configure the cell
        let photo = photos[indexPath.item]
        cell.titleLabel.text = photo.title
        cell.imageURL = photo.imageUrl
        cell.photoImageView.image = nil
        NetworkUtility.downloadImage(url: cell.imageURL) { (image) in
            if cell.imageURL == photo.imageUrl, let image = image  {
                DispatchQueue.main.async {
                    cell.photoImageView.image = image
                }
            }
        }
        
        return cell
    }

}

extension FlickrSearchCollectionViewController : FatchValueDelegate {
    func fetchInputText(_ text: String) {
        inputText = text
    }
    
    func fetchNumber(_ text: String) {
        numberText = text
    }
    
}

