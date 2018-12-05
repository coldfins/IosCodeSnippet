//
//  AppConstant.swift
//  VAPEixSocial
//
//  Created by Ved on 14/10/15.
//  Copyright (c) 2015 Ved. All rights reserved.
//

import UIKit
import Foundation

struct ScreenSize
{
    static let SCREEN_WIDTH = UIScreen.main.bounds.size.width
    static let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
    static let SCREEN_MAX_LENGTH = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    static let SCREEN_MIN_LENGTH = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
}

//screen resolution
let IS_IPHONE_4_OR_LESS =  UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
let IS_IPHONE_5 = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0

//URL
let BASE_URL = "http://34.212.127.62:86/api/WallPostAPI/"
let LOGIN_URL = "UserLogin"
let REGISTRATION_URL = "UserRegistration"
let POSTLIST_URL = "postList?offset="
let ADD_POST_URL = "userPost"
let LIKE_UNLIKE_URL = "likeUnlikePost"
let LIKE_USERS_OF_POST = "getLikeUsersOfPost?PostId="
let COMMENT_LIST = "postCommentList?PostId="
let POST_COMMENT = "postComment"
let GIVE_LIKE_ON_COMMENT = "postCommentLikeUnlike"
let GIVE_LIKE_TO_REPLY = "postCommentReplyLikeUnlike"
let POST_REPLY_TO_COMMENT = "postCommentReply"
let EDIT_PROFILE = "EditProfile"
let CHANGE_PWD = "ChangePassword"
let POST_REPORT = "addPostToReport"
let FORGOT_PASSWORD = "forgotPassword"

// Identifier
let IdentifireLoginView = "LoginViewController"
let IdentifireRegistrationView = "RegistrationViewController"
let IdentifireHomeView = "HomeViewController"
let IdentifireAlbumPhotoSlideView = "AlbumPhotoSlideViewController"
let IdentifireAddPostView = "AddPostViewController"
let IdentifireVideoPlayerView = "VideoPlayerViewController"
let IdentifireLikePeopleView = "LikePeopleListViewController"
let IdentifireCommentView = "CommentViewController"
let IdentifireReplyView = "ReplyViewController"
let IdentifireChangePwdView = "ChangePasswordViewController"
let IdentifireEditProfileView = "EditProfileViewController"
let IdentifireSettingsView = "SettingsViewController"
let IdentifireForgotPwdView = "ForgotPasswordViewController"
let IdentifireMailSentView = "MailConfirmationViewController"
let IdentifireUserDetailsView = "UserDetailsViewController"

//MESSAGE
let INTERNET_CONNECTION = "Please check your internet connection and try again."
let API_ERROR = "Something went wrong! please try again later."

//Keyword
let AlertTitle = "WallPost"
let keyFirstName = "FirstName"
let keyLastName = "LastName"
let keyEmail = "Email"
let keyContact = "Contact"
let keyProfilePic = "ProfilePic"
let keyUserId = "UserId"
let keyBirthDate = "BirthDate"
let keyIsPublic = "IsPublic"
