//
//  Registration.swift
//  ChatApp
//
//  Created by ved on 05/08/15.
//  Copyright (c) 2015 ved. All rights reserved.
//

import UIKit

class PostModel: NSObject {
    
    //Post
    var PostId: Int!
    var UserId: Int!
    var PostText: NSString!
    var PostedDate: NSString!
    var IsLike: Bool!
    var LikeCount: Int!
    var CommentCount: Int!
    var isPublic: Bool!
    
    //postImageVideos
    var arrImageVideo : NSMutableArray!
    
    //User
    var Email: NSString!
    var FirstName: NSString!
    var LastName: NSString!
    var BirthDate: NSString!
    var ProfilePic: NSString!
    var Contact: NSString!

}


