//
//  ViewController.swift
//  DunyaSaatleri
//
//  Created by Ozan Barış Günaydın on 25.11.2021.
//

import UIKit

final class MasterViewController: UIViewController {
    
    lazy var viewModel: ClocksViewModel = ClockViewModel()

    private var collectionView: UICollectionView?
    private var timeZones: [Time] = []
    private var cityObserved: String?
    private var timeZoneObserved: String?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewConfigure()
        navBarConfigure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        readSavedData()

    }
    
    private func readSavedData() {
        
        let defaults = UserDefaults.standard
        if let savedCity = defaults.object(forKey: "myKey") as? Data {
            let decoder = JSONDecoder()
            if let loadedData = try? decoder.decode([Time].self, from: savedCity) {
                timeZones = loadedData
            }
        }
    }
    
    private func navBarConfigure() {
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus.app.fill"), style: .plain, target: self, action: #selector(didTapAddButton))
    }
    
    @objc func didTapAddButton() {
        let selectionVC = SelectionViewController()
        navigationController?.pushViewController(selectionVC, animated: true)
    }
    // MARK: Delete Cell From CollectionView
    @objc func didSelectDelete() {
        if let selectedItems = collectionView?.indexPathsForSelectedItems {
            let items = selectedItems.map{$0.item}.sorted().reversed()
            for item in items {
                timeZones.remove(at: item)
                collectionView?.reloadData()
                let encoder = JSONEncoder()
                if let encoded = try? encoder.encode(timeZones) {
                    let defaults = UserDefaults.standard
                    defaults.set(encoded, forKey: "myKey")
                }
            }
        }
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus.app.fill"), style: .plain, target: self, action: #selector(didTapAddButton))
    }
    
    
    
    private func viewConfigure() {
        
        title = "Dünya Saatleri"
        
        // MARK: CollectionView Layout Properties
        let cvLayout = UICollectionViewFlowLayout()
        cvLayout.scrollDirection = .vertical
        cvLayout.minimumLineSpacing = 1
        cvLayout.minimumInteritemSpacing = 1
        
        // MARK: Collection View Cell's Frame and Properties
        cvLayout.itemSize = CGSize(width: (view.frame.size.width / 2) - 4 , height: (view.frame.size.width / 2) - 4)
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: cvLayout)
        guard let collectionView = collectionView else { return }
      
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.frame = view.bounds
        view.addSubview(collectionView)
   
    }

}
// MARK: Collection View Delegate Functions
extension MasterViewController: UICollectionViewDataSource, UICollectionViewDelegate {
  
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if timeZones.count > 0  {
            return timeZones.count
        }
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        /// Cell Identifiier Porperties
        if timeZones.count > 0  {
            collectionView.register(ClocksCollectionViewCell.self, forCellWithReuseIdentifier: ClocksCollectionViewCell.identifier)
        } else {
            collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        }
        
        /// Cell configuration:
        /// There is data:
        if timeZones.count > 0  {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ClocksCollectionViewCell.identifier, for: indexPath) as! ClocksCollectionViewCell
            
            cell.saveModel(model: timeZones[indexPath.row])
            cell.isEditing = isEditing
            return cell
            /// No data in dictionary ( user defaults)
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
            
            let plusImage = UIImageView(frame: CGRect(x: 10, y: 10, width: (view.frame.size.width / 2) - 20, height: (view.frame.size.width / 2) - 20))
            plusImage.image = UIImage(systemName: "plus.square.dashed")
            cell.contentView.addSubview(plusImage)
            return cell
        }
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        if timeZones.count != 0 {
            collectionView?.allowsMultipleSelection = editing
            if isEditing {
                self.navigationItem.rightBarButtonItem =  UIBarButtonItem(image: UIImage(systemName: "trash.circle"), style: .plain, target: self, action: #selector(didSelectDelete))
            }
            
            collectionView?.indexPathsForVisibleItems.forEach{ (indexPath) in
                let cell = collectionView?.cellForItem(at: indexPath) as! ClocksCollectionViewCell
                cell.isEditing = editing
            }
        }
    }
    
}

