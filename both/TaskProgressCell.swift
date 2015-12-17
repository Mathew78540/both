//
//  TaskCell.swift
//  both
//
//  Created by Mathieu Le tyrant on 14/12/2015.
//  Copyright © 2015 Mathieu Le tyrant. All rights reserved.
//

import UIKit

class TaskProgressCell: UITableViewCell {
    
    static let identifier = "task_progress_cell"
    
    // MARK: - Outlets
    @IBOutlet weak var chipBackground: UIImageView!
    @IBOutlet weak var counterView: UIView!
    @IBOutlet weak var differenceCounter: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var categoryIcon: UIImageView!
    
    var task:TaskProgress! {
        didSet {
            
            // Transparent background
            counterView.backgroundColor = UIColor(white: 1, alpha: 0)
            
            // Chip color
            if(task.difference >= 0){
                chipBackground.tintColor = UIColorFromRGBA("7ED321", alpha: 1.0)
            } else if(task.difference <= -10){
                chipBackground.tintColor = UIColorFromRGBA("EF3061", alpha: 1.0)
            } else if(task.difference <= -4) {
                chipBackground.tintColor = UIColorFromRGBA("F5A623", alpha: 1.0)
            } else if(task.difference <= -1) {
                chipBackground.tintColor = UIColorFromRGBA("F8E71C", alpha: 1.0)
            }
            
            // Task name
            title.text = task.name
            
            // Category Icon
            categoryIcon.image = UIImage(named: task.category.lowercaseString)
            
            
            // Difference counter
            differenceCounter.text = String(task.difference)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
        

}
