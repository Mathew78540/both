//
//  TaskCell.swift
//  both
//
//  Created by Mathieu Le tyrant on 14/12/2015.
//  Copyright © 2015 Mathieu Le tyrant. All rights reserved.
//

import UIKit

class CategoryStatCell: UITableViewCell {
    
    static let identifier = "category_stat_cell"
    
    @IBOutlet weak var labelCategoryName: UILabel!
    @IBOutlet weak var labelMeCounter: UILabel!
    @IBOutlet weak var labelPartnerCounter: UILabel!
    @IBOutlet weak var labelMeName: UILabel!
    @IBOutlet weak var labelPartnerName: UILabel!
    @IBOutlet weak var labelCategoryIcon: UIImageView!
    @IBOutlet weak var labelSwitchIcon: UIImageView!
    
    var category:CategoryStat! {
        didSet {
            
            // Category Icon
            labelCategoryIcon.image = UIImage(named: category.category.lowercaseString)
            
            // Switch icon
            if((category.me - category.partner) < 0){
                labelSwitchIcon.image = UIImage(named:"bad-switch")
            } else {
                labelSwitchIcon.image = UIImage(named:"good-switch")
            }
            
            // Text
            labelCategoryName.text   = category.name
            labelMeCounter.text      = String(category.me)
            labelPartnerCounter.text = String(category.partner)
            labelMeName.text         = category.meName
            labelPartnerName.text    = category.partnerName
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
}
