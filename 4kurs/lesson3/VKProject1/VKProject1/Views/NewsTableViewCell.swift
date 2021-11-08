//
//  NewsTableViewCell.swift
//  VKProject1
//
//  Created by xc553a8 on 12.10.2021.
//

import Foundation
import UIKit

class NewsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var avatarUserNews: AvatarsView!
    @IBOutlet weak var nameUserNews: UILabel!
    @IBOutlet weak var dateNews: UILabel!
    @IBOutlet weak var textNews: UILabel!
    @IBOutlet weak var imgNews: UIImageView!
    
    @IBOutlet weak var textNewsPost: UITextField!
    
    @IBOutlet weak var likesCount: LikeControl!
    @IBOutlet weak var commentsCount: UIButton!
    @IBOutlet weak var repostCount: UIButton!
    @IBOutlet var viewsCount: UIButton!
}
