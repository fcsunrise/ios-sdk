//
//  AtlasPayLogoTableViewCell.swift
//  AtlasSDK
//
//  Created by Yelyzaveta Kartseva on 24.05.2021.
//

import UIKit

class AtlasPayLogoTableViewCell: UITableViewCell {
    
    //MARK: - Properties
    
    @IBOutlet weak private var ivLogo: UIImageView!
    
    var logo: UIImage? {
        didSet {
            self.ivLogo.image = self.logo
        }
    }
    
    //MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}

//MARK: - AutoIndentifierCell
extension AtlasPayLogoTableViewCell: AutoIndentifierCell { }
