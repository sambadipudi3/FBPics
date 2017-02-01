//
//  AlbumController.swift
//  FBPics
//
//  Created by Sudhanshu Ambadipudi on 1/22/17.
//  Copyright © 2017 Sudhanshu Ambadipudi. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class AlbumController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    var user: User!
    var nameArray = [String]()
    var picArray = [UIImage]()
    @IBOutlet weak var albumCollectionView: UICollectionView!
    var menuShowing = false
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var sideViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var sideView: UIView!
    @IBOutlet weak var logoutBtn: UIButton!
    
    //--------**********************
    let reuseIdentifier = "cell"
    //--------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        albumCollectionView.delegate = self
        albumCollectionView.dataSource = self
        updateUI()
        logoutBtn.layer.cornerRadius = 5
        sideView.layer.shadowOpacity = 1
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! AlbumCell
        cell.albumNameLbl.text = user.albumNames[indexPath.row]
        cell.albumImage.image = user.albumCovers[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if(FBSDKAccessToken.current() != nil) {
            let group = DispatchGroup()
            group.enter()
            FBSDKGraphRequest(graphPath: "\(self.user.albumIds[indexPath.row])/photos", parameters: ["fields": "name, images"]).start { (connection, result, error) -> Void in
            
                if let photoDict = result as? NSDictionary {
                    if let photoData = photoDict["data"] as? [Dictionary<String, AnyObject>] {
                            self.nameArray.removeAll()
                            self.picArray.removeAll()
                            for photo in photoData {
                                
                                if let photoName = photo["name"] as? String {
                                    self.nameArray.append(photoName)
                                } else {
                                    self.nameArray.append("Awesome photo!")
                                }
                                
                                if let imageData = photo["images"] as? [Dictionary<String, AnyObject>] {
                                    let image = imageData[0]
                                    let url = image["source"] as? String
                                    let urlNS = NSURL(string: url!)
                                    self.picArray.append(UIImage(data: NSData(contentsOf: urlNS! as URL)! as Data)!)
                                }
                                
                                
                            }
                        }
                }
                self.performSegue(withIdentifier: "toAlbumSegue", sender: self)
                group.leave()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return user.albumNames.count
    }
    //--------
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAlbumSegue" {
            let photoVC = segue.destination as! PhotoViewController
            
            photoVC.nameArray = nameArray
            photoVC.picArray = picArray
            photoVC.user = user
        }
    }
    
    func updateUI() {
        self.nameLbl.text = user.name
        self.profilePic.image = user.profilePic
        
        let permissions = ["publish_actions"]
        FBSDKLoginManager().logIn(withPublishPermissions: permissions, from: self, handler: { (result, error) -> Void in
            if(error != nil){
                FBSDKLoginManager().logOut()
            } else if(result?.isCancelled)!{
                FBSDKLoginManager().logOut()
            } else{
                //Handle success
            }
        })
        
    }
    
    @IBAction func logOutBtnPressed(_ sender: Any) {
        FBSDKLoginManager().logOut()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        // vc is the Storyboard ID that you added
        // as! ... Add your ViewController class name that you want to navigate to
        let controller = storyboard.instantiateViewController(withIdentifier: "loginvc")
        self.present(controller, animated: true, completion: { () -> Void in
        })
    }
    @IBAction func openSideView(_ sender: UIBarButtonItem) {
        if !menuShowing {
            sideViewConstraint.constant = 0
            self.animateSideView()
        } else {
            sideViewConstraint.constant = -260
            self.animateSideView()
        }
        menuShowing = !menuShowing
    }
    
    func animateSideView() {
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
}
