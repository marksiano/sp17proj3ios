//
//  NewPostViewController.swift
//  MDBSocials
//
//  Created by Mark Siano on 2/24/17.
//  Copyright © 2017 Boris Yue. All rights reserved.
//

import UIKit
import ImagePicker
import Lightbox
import Firebase

class NewPostViewController: UIViewController, ImagePickerDelegate {
    
    var button: UIButton!
    var imageView: UIImageView!
    
    var titleField: CustomTextField!
    var descriptionField: CustomTextField!
    
    var auth = FIRAuth.auth()
    
    var navBar: UINavigationBar!
    var height: CGFloat!
    
    var addImageButton: UIButton!
    var removeImagesButton: UIButton!
    
    var images: [UIImage] = []
    
    var postsRef: FIRDatabaseReference = FIRDatabase.database().reference().child("Posts")
    var currentUser: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUser {
            self.navBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 60))
            self.view.addSubview(self.navBar);
            let navItem = UINavigationItem(title: "New Post");
            let doneItem = UIBarButtonItem(title: "Post", style: UIBarButtonItemStyle.done, target: nil, action: #selector  (self.makePost))
            //let doneItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: nil, action: #selector(getter: UIAccessibilityCustomAction.selector));
            navItem.rightBarButtonItem = doneItem;
            self.navBar.setItems([navItem], animated: false);
        
            self.initTextFields()
            self.initImageView()
            self.initButtons()
        }
        
        //initImagePicker()
        
        // Do any additional setup after loading the view.
    }
    
    func makePost() {
        //Add the image into storage
        
        if images != nil && titleField.text != "" && descriptionField.text != "" {
        
        let imageName = NSUUID().uuidString
        let storageRef = FIRStorage.storage().reference().child("post_images").child("\(imageName).png")
        
        if let uploadData = UIImagePNGRepresentation(images[0]) {
            
            storageRef.put(uploadData, metadata: nil, completion: { (metadata, error) in
                
                if error != nil {
                    print(error)
                    return
                }
                
                if let profileImageUrl = metadata?.downloadURL()?.absoluteString {
                    
                    let user = FIRAuth.auth()?.currentUser
                    let uid = user?.uid
                    
                    let newPost = ["title": self.titleField.text!, "poster": self.currentUser?.firstname, "imageURL": profileImageUrl, "numLikes": 0, "posterId": self.currentUser?.id, "description": self.descriptionField.text!] as [String : Any]
                    
                    let key = self.postsRef.childByAutoId().key
                    let childUpdates = ["/\(key)/": newPost]
                    self.postsRef.updateChildValues(childUpdates)
                }
                
                _ = self.navigationController?.popViewController(animated: true)
                self.dismiss(animated: true, completion: nil)
                print("Finished making post, going back one view")
                
            })
            
            
        }
        }
        
        /*print("Make Post")
        //Add the post (with image url) into database
         let newPost = ["title": titleField.text!, "poster": currentUser?.firstname, "imageURL": currentUser?.email, "numLikes": 0, "posterId": currentUser?.id, "description": descriptionField.text!] as [String : Any]
         let key = postsRef.childByAutoId().key
         let childUpdates = ["/\(key)/": newPost]
         postsRef.updateChildValues(childUpdates)*/
    }
    
    fileprivate func registerUserIntoDatabaseWithUID(_ uid: String, values: [String: AnyObject]) {
        let ref = FIRDatabase.database().reference()
        let usersReference = ref.child("Posts").child(uid)
        
        usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
            
            if err != nil {
                print(err)
                return
            }
            
            self.dismiss(animated: true, completion: nil)
        })
    }
    
    func initButtons() {
        addImageButton = UIButton(frame: CGRect(x: imageView.frame.maxX, y: imageView.frame.minY, width: view.frame.width - imageView.frame.width, height: imageView.frame.height / 2))
        addImageButton.setTitle("Add Photos", for: .normal)
        addImageButton.titleLabel?.font = UIFont(name: "Roboto-Regular", size: 18.0)
        addImageButton.setTitleColor(UIColor.init(red: 100/255, green: 100/255, blue: 100/255, alpha: 1.0), for: .normal)
        addImageButton.layer.borderColor = UIColor.init(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0).cgColor
        addImageButton.layer.borderWidth = 1.0
        
        view.addSubview(addImageButton)
        
        removeImagesButton = UIButton(frame: CGRect(x: imageView.frame.maxX, y: addImageButton.frame.maxY, width: view.frame.width - imageView.frame.width, height: imageView.frame.height / 2))
        removeImagesButton.setTitle("Remove Photos", for: .normal)
        removeImagesButton.titleLabel?.font = UIFont(name: "Roboto-Regular", size: 18.0)
        removeImagesButton.setTitleColor(UIColor.init(red: 100/255, green: 100/255, blue: 100/255, alpha: 1.0), for: .normal)
        removeImagesButton.layer.borderColor = UIColor.init(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0).cgColor
        removeImagesButton.layer.borderWidth = 1.0
        
        //Add targets
        addImageButton.addTarget(self, action: #selector(initImagePicker), for: UIControlEvents.touchUpInside)
        
        view.addSubview(removeImagesButton)
    }
    
    func initImageView() {
        let height = CGFloat(180)
        imageView = UIImageView(frame: CGRect(x: 0, y: view.frame.maxY - height, width: height, height: height))
        
        imageView.image = UIImage(named: "default.png")
        
        view.addSubview(imageView)
    }
    
    func initTextFields() {
        height = 40
        titleField = CustomTextField(frame: CGRect(x: 0, y: navBar.frame.maxY, width: view.frame.width, height: height))
        titleField.placeholder = "Event Title"
        
        view.addSubview(titleField)
        
        descriptionField = CustomTextField(frame: CGRect(x: 0, y: titleField.frame.maxY, width: view.frame.width, height: height * 2))
        descriptionField.placeholder = "Event Description"
        
        view.addSubview(descriptionField)
    }
    
    func fetchUser(withBlock: @escaping () -> ()) {
        //TODO: Implement a method to fetch posts with Firebase!
        let ref = FIRDatabase.database().reference()
        ref.child("Users").child((self.auth?.currentUser?.uid)!).observeSingleEvent(of: .value, with: { (snapshot) in
            let user = User(id: snapshot.key, userDict: snapshot.value as! [String : Any]?)
            self.currentUser = user
            withBlock()
            
        })
    }
    
    func initImagePicker() {
        let imagePickerController = ImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.imageLimit = 1
        present(imagePickerController, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        guard images.count > 0 else { return }
        
        let lightboxImages = images.map {
            return LightboxImage(image: $0)
        }
        
        let lightbox = LightboxController(images: lightboxImages, startIndex: 0)
        imagePicker.present(lightbox, animated: true, completion: nil)
    }
    
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        if images[0] != nil {
            imageView.image! = images[0]
            self.images = images
            print(self.images)
        } else {
            imageView.image! = UIImage(named: "default.png")!
        }
        imagePicker.dismiss(animated: true, completion: nil)
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
