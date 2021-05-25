//
//  AtlasPayGeneralTitleTableViewCell.swift
//  AtlasSDK
//
//  Created by Yelyzaveta Kartseva on 11.04.2021.
//

import UIKit

class AtlasPayGeneralTitleTableViewCell: UITableViewCell {
    
    //MARK: - Properties
    
    @IBOutlet weak private var lblTitle: UILabel!
    
    var title: String? {
        didSet {
            self.lblTitle.text = self.title
        }
    }
    
    //MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}

//MARK: - AutoIndentifierCell
extension AtlasPayGeneralTitleTableViewCell: AutoIndentifierCell {}
