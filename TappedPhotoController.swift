//
//  TappedPhotoController.swift
//  FBPics
//
//  Created by Sudhanshu Ambadipudi on 1/25/17.
//  Copyright © 2017 Sudhanshu Ambadipudi. All rights reserved.
//

import UIKit

class TappedPhotoController: UIViewController {

    var tappedPhoto: UIImage!
    var tappedName: String!
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var tappedPhotoView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tappedPhotoView.isUserInteractionEnabled = true
        tappedPhotoView.image = tappedPhoto
        nameLbl.text = tappedName
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        tappedPhotoView.addGestureRecognizer(tapRecognizer)
    }
    
    @IBAction func imageTapped(_ sender: UITapGestureRecognizer) {
        let imageView = sender.view as! UIImageView
        let newImageView = UIImageView(image: imageView.image)
        newImageView.frame = self.view.frame
        newImageView.backgroundColor = .black
        newImageView.contentMode = .scaleAspectFit
        newImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage))
        newImageView.addGestureRecognizer(tap)
        self.view.addSubview(newImageView)
    }
    
    func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
        sender.view?.removeFromSuperview()
    }
    
}
