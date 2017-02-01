//
//  LoadingViewController.swift
//  FBPics
//
//  Created by Sudhanshu Ambadipudi on 1/25/17.
//  Copyright © 2017 Sudhanshu Ambadipudi. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class LoadingViewController: UIViewController {
    
    var user = User()
    
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getFBInfo()
    }
    
    func getFBInfo() {
        activity.startAnimating()
        if(FBSDKAccessToken.current() != nil) {
            let group = DispatchGroup()
            group.enter()
                    
                    let parameters = ["fields": "id, name"]
                    FBSDKGraphRequest(graphPath: "me", parameters: parameters).start { (connection, result, error) -> Void in
                        
                        let data = result as! [String : AnyObject]
                        //NAME
                        let name = data["name"] as? String
                        self.user.saveName(name: name!)
                        //ID
                        let fbId = data["id"] as? String
                        self.user.saveFbId(id: fbId!)
                        //PROFILE PIC
                        let url = NSURL(string: "https://graph.facebook.com/\(fbId!)/picture?type=large&return_ssl_resources=1")
                        self.user.saveImage(image: UIImage(data: NSData(contentsOf: url! as URL)! as Data)!)
                        
                        group.leave()
                        group.enter()
                        
                        FBSDKGraphRequest(graphPath: "me/albums", parameters: ["fields": "id, name, picture"]).start { (connection, result, error) -> Void in
                            
                            if let albumDict = result as? NSDictionary {
                                if let albumData = albumDict["data"] as? [Dictionary<String, AnyObject>] {
                                    for album in albumData {
                                        let albumID = album["id"] as? String
                                        self.user.saveAlbumId(id: albumID!)
                                        let albumName = album["name"] as? String
                                        self.user.saveAlbumName(name: albumName!)
                                        if let picture = album["picture"] as? NSDictionary {
                                            if let data1 = picture["data"] as? NSDictionary {
                                                let urlCover = data1["url"] as? String
                                                let urlNS = NSURL(string: urlCover!)
                                                self.user.saveAlbumCovers(image: UIImage(data: NSData(contentsOf: urlNS! as URL)! as Data)!)
                                            }
                                        }
                                    }
                                }
                            }
                            
                            self.activity.stopAnimating()
                            self.performSegue(withIdentifier: "navSegue", sender: self)
                            group.leave()
                        }}}


    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "navSegue" {
            let navVC = segue.destination as? UINavigationController
        
            let albumVC = navVC?.topViewController as! AlbumController
        
            albumVC.user = user
        }
    }

}
