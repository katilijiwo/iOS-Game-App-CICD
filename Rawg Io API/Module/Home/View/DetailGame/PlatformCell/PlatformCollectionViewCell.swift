//
//  PlatformCollectionViewCell.swift
//  Rawg Io API
//
//  Created by MAC on 01/09/23.
//

import UIKit

class PlatformCollectionViewCell: UICollectionViewCell {

    static let identifier = "PlatformCollectionViewCell"
    @IBOutlet weak var rootView: UIView!
    @IBOutlet weak var textLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    func setupViews(text: String) {
        rootView.clipsToBounds = false
        rootView.layer.cornerRadius = 24
        textLbl.text = text
    }

}
