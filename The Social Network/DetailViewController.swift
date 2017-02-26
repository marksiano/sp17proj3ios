//
//  DetailViewController.swift
//  The Social Network
//
//  Created by Mark Siano on 2/25/17.
//  Copyright © 2017 Mark Siano. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class DetailViewController: UIViewController {
    
    var post: Post!
    var currentUser: User!
    var imageView: UIImageView!
    var titleLabel: UILabel!
    var poster: UILabel!
    var date: UILabel!
    var descriptionText: UITextView!
    var descriptionTitle: UILabel!
    var numInterestedButton: UIButton!
    var interestedButton: UIButton!
    
    func fetchUser(withBlock: @escaping () -> ()) {
        //TODO: Implement a method to fetch posts with Firebase!
        let ref = FIRDatabase.database().reference()
        ref.child("Users").child((FIRAuth.auth()?.currentUser?.uid)!).observeSingleEvent(of: .value, with: { (snapshot) in
            let user = User(id: snapshot.key, userDict: snapshot.value as! [String : Any]?)
            self.currentUser = user
            withBlock()
            
        })
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchUser {
            self.initImageView()
            self.initTitleText()
            self.initPoster()
            self.initDescription()
            self.initNumInterested()
        }

        // Do any additional setup after loading the view.
    }
    
    func initImageView() {
        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 160, height: 160))
        print(post.imageUrl)
        imageView.layer.masksToBounds = true
        
        let storage = FIRStorage.storage()
        storage.reference(forURL: post.imageUrl!).data(withMaxSize: 25 * 2048 * 2048, completion: { (data, error) -> Void in
            
            if error != nil {
                print(error)
            }
            // 1. Download the image into the struct's image field
            self.post.image = UIImage(data: data!)
            self.imageView.image = self.post.image
            print("doing")
            self.view.addSubview(self.imageView)
        })
    }
    
    func initTitleText() {
        titleLabel = UILabel(frame: CGRect(x: imageView.frame.maxX, y: 20, width: view.frame.width - imageView.frame.maxX, height: 40))
        titleLabel.text = post.title
        titleLabel.textAlignment = NSTextAlignment.center
        
        view.addSubview(titleLabel)
    }
    
    func initPoster() {
        poster = UILabel(frame: CGRect(x: imageView.frame.maxY, y: titleLabel.frame.maxY + 10, width: view.frame.width - imageView.frame.maxX, height: 40))
        poster.text = post.poster
        poster.textAlignment = NSTextAlignment.center
        
        view.addSubview(poster)
    }
    
    func initDescription() {
        descriptionText = UITextView(frame: CGRect(x: 0, y: imageView.frame.maxY + 10, width: view.frame.width, height: 150))
        descriptionText.textAlignment = NSTextAlignment.center
        descriptionText.textContainer.lineBreakMode = NSLineBreakMode.byWordWrapping
        descriptionText.text = post.description
        
        view.addSubview(descriptionText)
    }
    
    func initNumInterested() {
        numInterestedButton = UIButton(frame: CGRect(x: 10, y: descriptionText.frame.maxY + 20, width: view.frame.width / 2 - 10, height: 40))
        numInterestedButton.setTitle("\(Int(post.numLikes!)) people interested", for: .normal)
        numInterestedButton.backgroundColor = UIColor.init(red: 200/255, green: 200/255, blue: 230/255, alpha: 1.0)
        numInterestedButton.setTitleColor(UIColor.white, for: .normal)
        
        view.addSubview(numInterestedButton)
    }
    
    func initInterested() {
        interestedButton = UIButton(frame: CGRect(x: numInterestedButton.frame.maxX, y: numInterestedButton.frame.minY, width: view.frame.width / 2 - 10, height: 40))
        interestedButton.setTitle("I'm Interested!", for: .normal)
        interestedButton.backgroundColor = UIColor.init(red: 230/255, green: 200/255, blue: 200/255, alpha: 1.0)
        interestedButton.setTitleColor(UIColor.white, for: .normal)
        
        view.addSubview(interestedButton)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
