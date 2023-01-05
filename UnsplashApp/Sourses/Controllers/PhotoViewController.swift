//
//  PhotoViewController.swift
//  UnsplashApp
//
//  Created by Ян Нурков on 02.01.2023.
//

import UIKit
import SDWebImage

class PhotoViewController: UIViewController {
    var keyword = "random"
    var totalPage = 0
    var currentPage = 1
    var key = Constant.AccessKey
    var baseUrl = Constant.baseURL
    var photoDatas = [PhotosResult]()
    var currentResult: PhotosResult?
    let search = UISearchController(searchResultsController: nil)
    
    lazy var collectionView: UICollectionView = {
        let obj = UICollectionView(frame: .zero, collectionViewLayout: CustomLayout())
        obj.delegate = self
        obj.dataSource = self
        obj.backgroundColor = .white
        obj.showsHorizontalScrollIndicator = false
        obj.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        obj.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
        return obj
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        collectionView.frame = view.bounds
        configView()
        fetchPhotos()
    }
}

//MARK: - ConfigurationView

extension PhotoViewController {
    private func configView() {
        view.backgroundColor = .white
        self.title = "Unsplash Photo"
        navigationController?.navigationBar.prefersLargeTitles = true
        if let layout = collectionView.collectionViewLayout as? CustomLayout {
            layout.delegate = self
        }
        search.searchBar.delegate = self
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Search"
        navigationItem.searchController = search
    }
}

//MARK: - GetData

extension PhotoViewController {
    private func fetchPhotos() {
        let query = keyword.replacingOccurrences(of: "", with: "%10")
        let urlString = baseUrl + "client_id=\(key)&query=\(query)&page=\(currentPage)"
        guard let url = URL(string: urlString) else {
            alert()
            print("Bad URL")
            return
        }
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else {
                print("No Data")
                return
            }
            guard let decoded = try? JSONDecoder().decode(PhotosResponse.self, from: data) else {
                print(String(data: data, encoding: .utf8) ?? "No Data")
                return
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                let newPhotoDatas = decoded.results
                let oldPhotoDatas = self.photoDatas
                self.photoDatas = oldPhotoDatas + newPhotoDatas
                self.totalPage = decoded.totalPages
                self.currentPage += 1
                self.collectionView.reloadData()
                if self.photoDatas.isEmpty {
                    self.alert()
                }
            }
        }.resume()
    }
}

// MARK: - Settings CollectionView

extension PhotoViewController : UICollectionViewDelegate,
                                UICollectionViewDataSource,
                                UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: view.frame.width, height: view.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return photoDatas.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) ->UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier,
                                                      for: indexPath) as? PhotoCollectionViewCell
        let urlString = photoDatas[indexPath.row].urls.regular
        cell?.imageView.sd_setImage(with: URL(string: urlString), placeholderImage: UIImage(named: "photo"))
        return cell ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        currentResult = photoDatas[indexPath.row]
        let vc = DetailViewController()
        guard let result = currentResult else { return }
        vc.result = result
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        if indexPath.row == (photoDatas.count - 2) {
            currentPage += 1
            if currentPage <= totalPage {
                fetchPhotos()
            }
        }
    }
}

// MARK: - Layout

extension PhotoViewController: CustomLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        heightForPhotoAtIndexPath indexPath:IndexPath) -> CGFloat {
        return 200
    }
}

//MARK: - SearchBar

extension PhotoViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text?.lowercased() else { return }
         let engCharacters = "qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM1234567890"
            text.forEach { (char) in
                if !(engCharacters.contains(char)) {
                    DispatchQueue.main.async {
                        self.keyword = "random"
                        self.alert()
                        self.collectionView.reloadData()
                    }
                }
            }
        keyword = text
        photoDatas.removeAll()
        currentPage = 1
        fetchPhotos()
    }
}

//MARK: - Alert

extension PhotoViewController {
    func alert() {
        let alert = UIAlertController(title: "No result found", message: "Enter a new request", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Retry", style: .cancel, handler: { actions in
            self.updateSearch()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func updateSearch() {
        search.searchBar.text = ""
        keyword = "random"
        photoDatas.removeAll()
        currentPage = 1
        fetchPhotos()
    }
}
