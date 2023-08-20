//
//  ListGameViewController.swift
//  Rawg Io API
//
//  Created by MAC on 19/08/23.
//

import Foundation
import UIKit

class ListGameViewTableCell: UITableViewCell {
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var releaseLbl: UILabel!
    
    func setupViews(data: GameModel) {
        
        titleLbl.text = data.title
        releaseLbl.text = data.released
        print("jiwo: \(data)")
    }
}
