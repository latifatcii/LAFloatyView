//
//  LAFloatyView.swift
//  LAFloatyView
//
//  Created by Latif Atçı on 25.05.2022.
//

import UIKit

private enum LAFloatyViewState {
    case leftOpen
    case leftClosed
    case rightOpen
    case rightClosed
    
    var isOpen: Bool {
        self == .leftOpen || self == .rightOpen
    }
}

public final class LAFloatyView: UIView {
    private var items: [UIButton] = []
    private let initialItem = UIButton()
    weak var datasource: LAFloatyViewDatasource? {
        didSet {
            prepareUI()
        }
    }
    
    private var state: LAFloatyViewState = .rightClosed
    
    @objc private func panHandler(gesture: UIPanGestureRecognizer) {
        guard !state.isOpen else { return }
        items.forEach { $0.isHidden = true }
        let location = gesture.location(in: self)
        initialItem.center = location
        
        if gesture.state == .ended {
            if initialItem.frame.midX >= self.layer.frame.width / 2 {
            animateItems(firstButtonX: frame.maxX - 55, itemsX: 55, state: .rightClosed)
            } else {
            animateItems(firstButtonX: frame.minX + 5, itemsX: -55, state: .leftClosed)
            }
        }
    }
    
    private func animateItems(firstButtonX: CGFloat, itemsX: CGFloat, state: LAFloatyViewState) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.initialItem.frame.origin.x = firstButtonX
            guard let dataSource = self.datasource else { return }
            for i in 1...dataSource.itemCount {
                let itemY = CGFloat((i) * 55)
                self.items[i-1].center.x = self.initialItem.center.x + itemsX
                self.items[i-1].center.y = self.initialItem.center.y - itemY
            }
        }, completion: { [weak self] _ in
            guard let self = self else { return }
            self.state = state
            self.items.forEach { $0.isHidden = false }
        })
    }
    
    private func prepareUI() {
        guard let datasource = datasource else {
            return
        }
        backgroundColor = .clear
        addSubview(initialItem)
        initialItem.frame = .init(x: frame.maxX - 55, y: frame.maxY - 150, width: datasource.itemSize.width, height: datasource.itemSize.height)
        initialItem.backgroundColor = .red
        initialItem.layer.cornerRadius = datasource.itemCornerRadius
        initialItem.addTarget(self, action: #selector(firstButtonTapped), for: .touchUpInside)
        initialItem.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(panHandler)))
        
        
        for i in 1...datasource.itemCount {
            let itemY = CGFloat((i) * 55)
            let item = UIButton(frame: .init(x: initialItem.frame.origin.x + 55, y: initialItem.frame.origin.y - itemY, width: datasource.itemSize.width, height: datasource.itemSize.height))
            item.backgroundColor = .blue
            item.layer.cornerRadius = datasource.itemCornerRadius
            item.setImage(datasource.itemImage(at: i), for: .normal)
            item.alpha = 0
            addSubview(item)
            items.append(item)
        }
    }
    
    @objc private func firstButtonTapped() {
        switch state {
        case .leftOpen:
            close(x: -55)
            state = .leftClosed
        case .leftClosed:
            open()
            state = .leftOpen
        case .rightOpen:
            close()
            state = .rightClosed
        case .rightClosed:
            open()
            state = .rightOpen
        }
    }
    
    private func open() {
        var delay = 0.0
        for item in items {
            UIView.animate(withDuration: 0.3, delay: delay, usingSpringWithDamping: 0.55, initialSpringVelocity: 0.3, options: UIView.AnimationOptions()) {
                item.alpha = 1
                item.frame.origin.x = self.initialItem.frame.origin.x
            }
            
            delay += 0.1
        }
    }
    
    private func close(x: CGFloat = 55) {
        var delay = 0.0
        for item in items.reversed() {
            UIView.animate(withDuration: 0.3, delay: delay, usingSpringWithDamping: 0.55, initialSpringVelocity: 0.3, options: .transitionFlipFromRight) {
                item.alpha = 1
                item.frame.origin.x = self.initialItem.frame.origin.x + x
            }
            delay += 0.1
        }
    }
}
