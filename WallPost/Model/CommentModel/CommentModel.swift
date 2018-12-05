//
//  Registration.swift
//  ChatApp
//
//  Created by ved on 05/08/15.
//  Copyright (c) 2015 ved. All rights reserved.
//

import UIKit

class CommentModel: NSObject {
    
    //postcomment
    var PostCommentId: Int!
    var UserId: Int!
    var PostId: Int!
    var IsLike: Bool!
    var isPublic: Bool!

    var Comment: NSString!
    var CommentImage: NSString!
    var PostedDate: NSString!
    var LikeCount: Int!
    var ReplyCount: Int!
    
    //User
    var Email: NSString!
    var FirstName: NSString!
    var LastName: NSString!
    var BirthDate: NSString!
    var ProfilePic: NSString!
    var Contact: NSString!
    
    //PostCommentReply
    var PostCommentReplyId: Int!
    var ReplyPostCommentId: Int!
    var Reply: NSString!
    var ReplyImage: NSString!
    var ReplyPostedDate: NSString!
    var ReplyLikeCount: Int!
    var ReplyFirstName: NSString!
    var ReplyLastName: NSString!
    var ReplyProfilePic: NSString!
    var ReplyEmail: NSString!
    var ReplyBirthDate: NSString!
    var ReplyContact: NSString!
    var ReplyIsLike: Bool!
    var arrReply: NSMutableArray!
    var ReplyisPublic: Bool!

}


