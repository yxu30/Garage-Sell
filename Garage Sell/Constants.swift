//
//  Constants.swift
//  Garage Sell
//
//  Created by Yuhong Xu on 5/19/20.
//  Copyright © 2020 Yuhong Xu. All rights reserved.
//

import Foundation

class Constants{
    
    static let loginViewControllerIdentifier = "LoginVC"
    static let homeTabBarControllerIdentifier = "homeTBCon"
    static let homeTableViewControllerIdentifier = "HomeVC"
    static let postDetailViewControllerIdentifier = "PostDVC"
    static let postUploadViewControllerIdentifier = "PostUVC"
    static let accountViewControllerIdentifier = "AccountVC"
    static let profileViewControllerIdentifier = "ProfVC"
    
    static let itemCellIdentifier = "itemCell"
    static let itemDetailIdentifier = "showDetail"
    static let itemUploadContinueIdentifier = "postUploadContinue"
    
    static let usersCollectionName = "users"
    static let postsCollectionName = "Post"
    
    enum Category : String{
        case beauty = "Beauty"
        case books = "Books"
        case clothes = "Clothes"
        case cookware = "Cookware"
        case furnitures = "Furniture"
        case games = "Games"
        case schoolSupplies = "School Supplies"
        case tools = "Tools"
        case miscellaneous = "Misc."
    }
    
}
