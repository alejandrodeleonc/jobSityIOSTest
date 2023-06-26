//
//  GuestCollectionViewCell.swift
//  tvMazeApp
//
//  Created by Alejandro De León on 26/6/23.
//

import UIKit

class GuestCollectionViewCell: UICollectionViewCell {
    static let identifier = "GuestCollectionViewCell"
    
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(posterImageView)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        posterImageView.frame = contentView.bounds
    }
    
    
    public func configure(guest:Guest) {
        
        guard let url = URL(string: guest.person.image?.original ?? "") else {
            return
        }
        
        posterImageView.sd_setImage(with: url, completed: nil)
    }
    
}
