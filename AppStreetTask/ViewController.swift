//
//  ViewController.swift
//  AppStreetTask
//
//  Created by Shashank Atray on 02/07/19.
//  Copyright © 2019 Shashank Atray. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var button = dropDownBtn()
    lazy var searchBar:UISearchBar = UISearchBar(frame: CGRect(x: 10, y: 5, width: 250, height: 25))
  
    var photos: [FlickrPhoto] = []
    let apiKey = "c9ee672014711d3be9f7b806b4c77494"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        collectionViewSetUp()
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    
    func setUpViews() {
        searchBar.placeholder = "Your placeholder"
        let leftNavBarButton = UIBarButtonItem(customView:searchBar)
        self.navigationItem.leftBarButtonItem = leftNavBarButton
        searchBar.delegate = self
        
        button = dropDownBtn.init(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
        button.setTitle("Select", for: .normal)
        button.backgroundColor = UIColor.red
        button.translatesAutoresizingMaskIntoConstraints = false
       
        //Add Button to the View Controller
        let rightBarButton = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = rightBarButton
        
  
    }
    
    func collectionViewSetUp() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5)
        layout.itemSize = CGSize(width: (self.view.frame.width - 20)/2, height: (self.view.frame.width - 20)/2)
        //layout.itemSize = CGSize(width: (self.view.frame.width - 20)/4, height: (self.view.frame.width - 20)/4)

        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        self.collectionView.reloadData()
        collectionView!.collectionViewLayout = layout
        
    }
    
    func flickerPhotoGetter(flickrPhotos: [AnyObject]) -> [FlickrPhoto] {
        
        let flickrPhotos: [FlickrPhoto] = flickrPhotos.map { photoDictionary in
            
            let photoId = photoDictionary["id"] as? String ?? ""
            let farm = photoDictionary["farm"] as? Int ?? 0
            let secret = photoDictionary["secret"] as? String ?? ""
            let server = photoDictionary["server"] as? String ?? ""
            let title = photoDictionary["title"] as? String ?? ""
            
            let flickrPhoto = FlickrPhoto(photoId: photoId, farm: farm, secret: secret, server: server, title: title)
            return flickrPhoto
        }
        return flickrPhotos
    }
    
    func requestForUserDataWith(searchText: String, completionHandler: @escaping(_ result: [String: Any]) -> ()) {
      let url = URL(string: "https://www.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(apiKey)&text=\(searchText)&format=json&nojsoncallback=1")!
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if (responseJSON as? [String : Any]) != nil {
            
                completionHandler(responseJSON as! [String : Any])
            }
        }
        
        task.resume()
    }
    
}

extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let bodyCell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCell",for: indexPath) as! collectionViewCell
        
        bodyCell.setupWithPhoto(flickrPhoto: self.photos[indexPath.row] as! FlickrPhoto)
        return bodyCell
    }
    
}

extension ViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard searchText.count > 2 else {
            return
        }
        
        requestForUserDataWith(searchText: searchText.removingWhitespaces()) { result in
            
            if let compatData = result["photos"] as? [String: AnyObject], let photo = compatData["photo"]   {
                
               self.photos = self.flickerPhotoGetter(flickrPhotos: photo as! [AnyObject])
            }
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
}
























