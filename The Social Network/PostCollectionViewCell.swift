//
//  PostCollectionViewCell.swift
//  FirebaseDemoWeek3
//
//  Created by Sahil Lamba on 2/13/17.
//  Copyright © 2017 Sahil Lamba. All rights reserved.
//

import UIKit

class PostCollectionViewCell: UICollectionViewCell {
    var profileImage: UIImageView!
    var posterText: UILabel!
    var postText: UITextView!
    var likeButton: UIButton!
    
    var addPostButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.white
        setupProfileImage()
        setupPosterText()
        setupPostText()
        setupLikeButton()
    }
    
    func setupProfileImage() {
        profileImage = UIImageView(frame: CGRect(x: 10, y: 10, width: 0.50 * self.frame.height, height: 0.50 * self.frame.height))
        profileImage.clipsToBounds = true
        profileImage.contentMode = .scaleAspectFit
        addSubview(profileImage)
    }
    
    func setupPosterText() {
        posterText = UILabel(frame: CGRect(x: profileImage.frame.maxX + 10, y: 10, width: self.frame.width, height: 30))
        posterText.textColor = UIColor.black
        posterText.font = UIFont.systemFont(ofSize: 24, weight: 2)
        posterText.adjustsFontForContentSizeCategory = true
        addSubview(posterText)
    }
    
    func setupPostText() {
        postText = UITextView(frame: CGRect(x: profileImage.frame.maxX + 10, y: posterText.frame.maxY + 10, width: self.frame.width, height: 0.5 * self.frame.height - 40))
        postText.textColor = UIColor.black
        postText.adjustsFontForContentSizeCategory = true
        postText.isEditable = false
        addSubview(postText)
        
    }
    func setupLikeButton() {
        likeButton = UIButton(frame: CGRect(x: 10, y: profileImage.frame.maxY + 10, width: 50, height: 30))
        likeButton.setTitle("Like", for: .normal)
        likeButton.setTitle("Unlike", for: .selected)
        likeButton.setTitleColor(UIColor.blue, for: .normal)
        addSubview(likeButton)
    }
    
}
