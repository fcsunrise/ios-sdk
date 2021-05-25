//
//  AtlasPayGeneralSumTableViewCell.swift
//  AtlasSDK
//
//  Created by Yelyzaveta Kartseva on 11.04.2021.
//

import UIKit

class AtlasPayGeneralSumTableViewCell: UITableViewCell {
    
    //MARK: - Defaults
    
    //MARK: - Properties
    
    @IBOutlet weak private var lblSum: UILabel!
    
    var sum: String? {
        didSet {
            self.lblSum.text = self.sum
        }
    }
    
    //MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}

//MARK: - AutoIndentifierCell
extension AtlasPayGeneralSumTableViewCell: AutoIndentifierCell { }
