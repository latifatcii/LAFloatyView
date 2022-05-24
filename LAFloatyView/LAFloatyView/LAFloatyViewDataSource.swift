//
//  LAFloatyViewDataSource.swift
//  LAFloatyView
//
//  Created by Latif Atçı on 25.05.2022.
//

import UIKit

protocol LAFloatyViewDatasource: AnyObject {
    var itemCount: Int { get }
    var itemSize: CGSize { get }
    var itemCornerRadius: CGFloat { get }
    
    func itemImage(at index: Int) -> UIImage?
}

extension LAFloatyViewDatasource {
    var itemSize: CGSize { .init(width: 50, height: 50) }
    var itemCornerRadius: CGFloat { 25 }
}
