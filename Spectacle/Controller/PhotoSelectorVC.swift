//
//  PhotoSelectorVC.swift
//  Spectacle
//
//  Created by Dan Lindsay on 2018-05-17.
//  Copyright © 2018 Dan Lindsay. All rights reserved.
//

import UIKit
import Photos

class PhotoSelectorVC: UICollectionViewController {
    
    //MARK: - Class Properties
    
    let photoSelectorCellId = "photoSelectorCell"
    let photoSelectorHeaderId = "photoSelectorHeader"
    var images = [UIImage]()
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
        setupNavButtons()
        
        collectionView?.register(PhotoSelectorCell.self, forCellWithReuseIdentifier: photoSelectorCellId)
        collectionView?.register(UICollectionViewCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: photoSelectorHeaderId)
        
        fetchPhotos()
    }
    
    //MARK: - Custom Methods
    fileprivate func setupNavButtons() {
        navigationController?.navigationBar.tintColor = .black
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelBtnPressed))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(nextBtnPressed))
    }
    
    fileprivate func fetchPhotos() {
        let fetchOptions = PHFetchOptions()
        fetchOptions.fetchLimit = images.count
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        fetchOptions.sortDescriptors = [sortDescriptor]
        let allPhotos = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        allPhotos.enumerateObjects { (asset, count, stop) in
            let imageManager = PHImageManager.default()
            let targetSize = CGSize(width: 350, height: 350)
            let options = PHImageRequestOptions()
            options.isSynchronous = true
            imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFit, options: options, resultHandler: { (image, info) in
                if let image = image {
                    self.images.append(image)
                }
                if count == allPhotos.count - 1 {
                    self.collectionView?.reloadData()
                }
            })
        }
    }
    
    @objc func cancelBtnPressed() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func nextBtnPressed() {
        print("Next pressed")
    }
}

//MARK: - UICollectionView methods and UICollectionViewFlowLayout
extension PhotoSelectorVC: UICollectionViewDelegateFlowLayout {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: photoSelectorCellId, for: indexPath) as! PhotoSelectorCell
        cell.photoimageView.image = images[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 3) / 4
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width = view.frame.width
        return CGSize(width: width, height: width)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: photoSelectorHeaderId, for: indexPath)
        header.backgroundColor = .red
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1, left: 0, bottom: 0, right: 0)
    }
}



