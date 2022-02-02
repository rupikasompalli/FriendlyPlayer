//
//  MovieCell.swift
//  EartQuakeListings
//
//  Created by Rupika Sompalli on 2022-01-21.
//

import UIKit

class MovieCell: UITableViewCell {
    
    static let Identifier = "MovieCell"
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var contentHolder: UIView!
    
    var movie: Movie?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func showData(data: Movie) {
        self.movie = data
        DispatchQueue.main.async { [weak self] in
            self?.titleLabel.text = data.title
            self?.subtitleLabel.text = data.subtitle
            self?.descriptionLabel.text = data.description
        }
    }
}
