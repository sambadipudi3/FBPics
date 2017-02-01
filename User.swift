//
//  User.swift
//  FBPics
//
//  Created by Sudhanshu Ambadipudi on 1/22/17.
//  Copyright © 2017 Sudhanshu Ambadipudi. All rights reserved.
//

import Foundation
import UIKit

class User{
    
    private var _name: String!
    private var _fbId: String!
    private var _profilePic: UIImage!
    private var _albumIds = [String]()
    private var _albumNames = [String]()
    private var _albumCovers = [UIImage]()
    private var _albumPhotos = [UIImage]()
    
    var name: String {
        if _name == nil {
            _name = ""
        }
        return _name
    }
    
    var fbId: String {
        if _fbId == nil {
            _fbId = ""
        }
        return _fbId
    }
    
    var profilePic: UIImage {
        if _profilePic == nil {
            _profilePic = UIImage()
        }
        return _profilePic
    }
    
    var albumIds: [String] {
        return _albumIds
    }
    
    var albumNames: [String] {
        return _albumNames
    }
    
    var albumPhotos: [UIImage] {
        return _albumPhotos
    }
    
    var albumCovers: [UIImage] {
        return _albumCovers
    }
    
    func saveName(name: String) {
        self._name = name;
    }
    
    func saveFbId(id: String) {
        self._fbId = id;
    }
    
    func saveImage(image: UIImage) {
        self._profilePic = image
    }
    
    func saveAlbumId(id: String) {
        self._albumIds.append(id)
    }
    
    func saveAlbumName(name: String) {
        self._albumNames.append(name)
    }
    
    func saveAlbumPhotos(image: UIImage) {
        self._albumPhotos.append(image)
    }
    
    func saveAlbumCovers(image: UIImage) {
        self._albumCovers.append(image)
    }
    
}
