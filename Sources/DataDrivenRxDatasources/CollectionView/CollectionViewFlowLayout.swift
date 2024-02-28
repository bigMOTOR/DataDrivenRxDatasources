//
//  CollectionViewFlowLayout.swift
//
//
//  Created by Mykola Fiantsev on 28.02.2024.
//

import UIKit

public protocol CollectionViewFlowLayout where Self: UICollectionView {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
}
