//
//  GetFlickerPhotos.swift
//  AppStreetTask
//
//  Created by Shashank Atray on 03/07/19.
//  Copyright © 2019 Shashank Atray. All rights reserved.
//

import Foundation
import UIKit

struct FlickrPhoto {
    
    let photoId: String
    let farm: Int
    let secret: String
    let server: String
    let title: String
    
    var photoUrl: String {
        return "https://farm\(farm).staticflickr.com/\(server)/\(photoId)_\(secret)_m.jpg"
    }
    
}
