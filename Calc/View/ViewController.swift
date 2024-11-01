//
//  ViewController.swift
//  Calc
//
//  Created by Yazdan Javadi on 04/10/2024.
//

import UIKit

class ViewController: UIViewController {
    
    let viewModel = CalcControllerViewModel()
    private var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupCollectionView()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        // Observe updates from the viewModel
        viewModel.updateViews = { [weak self] in
            self?.collectionView.reloadData()
        }
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .black
        collectionView.register(HeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderCell.identifier)
        collectionView.register(Views.self, forCellWithReuseIdentifier: Views.identifier)
        
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.calcButtonCells.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Views.identifier, for: indexPath) as! Views
        let calcButton = viewModel.calcButtonCells[indexPath.row]
        
        var buttonToDisplay = calcButton
        if calcButton == .allClear || calcButton == .delete {
            // Decide whether to show "AC" or "Del" based on the viewModel state
            let shouldShowDelete = !viewModel.isResultDisplayed && viewModel.calcHeaderLabel != "0"
            buttonToDisplay = shouldShowDelete ? .delete : .allClear
        }
        
        cell.configure(with: buttonToDisplay)
        
        if buttonToDisplay == .delete {
            let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressOnDelete(_:)))
            cell.addGestureRecognizer(longPressRecognizer)
        }
        
        return cell
    }

    @objc func handleLongPressOnDelete(_ gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state == .began {
            // Call the didSelectAllClear function in the view model
            viewModel.didSelectAllClear()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderCell.identifier, for: indexPath) as! HeaderCell
        header.setup(currentNumber: viewModel.calcHeaderLabel, equation: viewModel.equation)
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: maxHeaderHeight())
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let buttonWidth = buttonSize(collectionView: collectionView)
        let calcButton = viewModel.calcButtonCells[indexPath.row]
        
        if case .number(let int) = calcButton, int == 0 {
            return CGSize(width: buttonWidth * 2 + 10, height: buttonWidth)
        } else {
            return CGSize(width: buttonWidth, height: buttonWidth)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let buttonCell = viewModel.calcButtonCells[indexPath.row]
        viewModel.didSelectButton(with: buttonCell)
        
        let headerHasContent = !viewModel.calcHeaderLabel.isEmpty
        if let acButtonIndex = viewModel.calcButtonCells.firstIndex(of: .allClear) {
            if let acCell = collectionView.cellForItem(at: IndexPath(row: acButtonIndex, section: 0)) as? Views {
                acCell.updateButtonTitleForClear(hasContent: headerHasContent)
            }
        }
    }
    
    private func buttonSize(collectionView: UICollectionView) -> CGFloat {
        let buttonsPerRow: CGFloat = 4
        let spacing: CGFloat = 10.0
        let totalSpacing = spacing * (buttonsPerRow - 1)
        return (collectionView.frame.size.width - totalSpacing) / buttonsPerRow
    }
    
    private func maxHeaderHeight() -> CGFloat {
        let buttonHeight = buttonSize(collectionView: collectionView)
        let numberOfRows = ceil(CGFloat(viewModel.calcButtonCells.count) / 4)
        let totalButtonHeight = buttonHeight * numberOfRows + (10.0 * (numberOfRows - 1))
        return max(collectionView.frame.size.height - totalButtonHeight - view.safeAreaInsets.top - view.safeAreaInsets.bottom - 16, 0)
    }
}
