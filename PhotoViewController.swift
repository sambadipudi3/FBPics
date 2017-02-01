//
//  PhotoViewController.swift
//  FBPics
//
//  Created by Sudhanshu Ambadipudi on 1/25/17.
//  Copyright © 2017 Sudhanshu Ambadipudi. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import FBSDKShareKit

class PhotoViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate,
UINavigationControllerDelegate {
    
    var user: User!
    var tapped = 0
    var nameArray: [String]?
    var picArray: [UIImage]!
    let reuseIdentifier = "photocell"
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    //--------**********************
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 160, height: 160)
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! PhotoCell
        cell.photoImage.image = picArray[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        tapped = indexPath.row
        self.performSegue(withIdentifier: "toPhotoSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPhotoSegue" {
            
            let tappedPhotoVC = segue.destination as! TappedPhotoController
            
            tappedPhotoVC.tappedPhoto = picArray[tapped]
            tappedPhotoVC.tappedName = nameArray?[tapped]
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return picArray.count
    }
    //--------
    
    @IBAction func addBtnPressed(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            let photo = FBSDKSharePhoto()
            photo.image = image
            photo.isUserGenerated = true
            
            let content = FBSDKSharePhotoContent()
            content.photos = [photo]
            
            let shareObject = FBSDKShareAPI()
            shareObject.shareContent = content
            shareObject.graphNode = String(format:"/%@/photos", user.albumIds[tapped])
            shareObject.share()
        } else{
            print("Something went wrong")
        }
        
        dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
}
