//
//  CollectionTableViewCell.swift
//  tvMazeApp
//
//  Created by Alejandro De León on 26/6/23.
//

import UIKit

class CollectionTableViewCell: UITableViewCell {
    
    
    
    static let identifier = "CollectionViewTableViewCell"

    
    private var guest: [Guest] = [Guest]()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
             
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 160, height: 160)
//        layout.sectionInset = UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(GuestCollectionViewCell.self, forCellWithReuseIdentifier: GuestCollectionViewCell.identifier)
        return collectionView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(collectionView)
        
        
        
        
        NSLayoutConstraint.activate([
                    collectionView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
                    collectionView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
                    collectionView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
                    collectionView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
                ])
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = contentView.bounds
    }
    
    
    public func configure(guest: [Guest]) {
        self.guest = guest
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }
    
        

    }


extension CollectionTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GuestCollectionViewCell.identifier, for: indexPath) as? GuestCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.configure(guest: self.guest[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.guest.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
    }
}

