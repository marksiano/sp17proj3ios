//
//  Post.swift
//  FirebaseDemoWeek3
//
//  Created by Sahil Lamba on 2/13/17.
//  Copyright © 2017 Sahil Lamba. All rights reserved.
//

import Foundation
import UIKit
import Firebase


class Post {
    var title: String?
    var imageUrl: String?
    var numLikes: Int?
    var posterId: String?
    var poster: String?
    var id: String?
    var image: UIImage?
    var description: String?
    
    
    init(id: String, postDict: [String:Any]?) {
        self.id = id
        if postDict != nil {
            if let title = postDict!["title"] as? String {
                self.title = title
            }
            if let imageUrl = postDict!["imageURL"] as? String {
                self.imageUrl = imageUrl
            }
            if let numLikes = postDict!["numLikes"] as? Int {
                self.numLikes = numLikes
            }
            if let posterId = postDict!["posterId"] as? String {
                self.posterId = posterId
            }
            if let poster = postDict!["poster"] as? String {
                self.poster = poster
            }
            if let description = postDict!["description"] as? String {
                self.description = description
            }
        }
    }
    
    func getProfilePic(withBlock: @escaping () -> ()) {
        
            let ref = FIRStorage.storage().reference(forURL: imageUrl!)
            ref.data(withMaxSize: 15 * 2048 * 2048) { data, error in
            if let error = error {
                print(error)
            } else {
                self.image = UIImage(data: data!)
                withBlock()
            }
        }
    }
}
