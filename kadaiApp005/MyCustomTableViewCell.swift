//
//  MyCustomTableViewCell.swift
//  kadaiApp005
//
//  Created by YoNa on 2020/11/17.
//

import UIKit

class MyCustomTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var MyCustomTableViewCell: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var linkLabel: UILabel!
    @IBOutlet weak var pubDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

}
