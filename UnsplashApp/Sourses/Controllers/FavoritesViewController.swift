//
//  FavoritesViewController.swift
//  UnsplashApp
//
//  Created by Ян Нурков on 03.01.2023.
//

import UIKit
import SDWebImage
import CoreData

class FavoritesViewController: UIViewController {
    
    var likeData: [LikeEntities] = []
    var currentResult: LikeEntities?
    let context = (UIApplication.shared.delegate as!
                   AppDelegate).persistentContainer.viewContext
    
    //MARK: - Outlets
    
    lazy var tableView: UITableView = {
        let obj = UITableView(frame: .zero, style: UITableView.Style.grouped)
        obj.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.reduseId)
        obj.delegate = self
        obj.dataSource = self
        return obj
    }()
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fatch()
        view.backgroundColor = .white
        view.addSubview(tableView)
        tableView.frame = view.bounds
        self.navigationItem.title = "Favorites"
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fatch()
        self.tableView.reloadData()
    }
    
    //MARK: - FetchData
    
    func fatch() {
        do {
            likeData = try context.fetch(LikeEntities.fetchRequest())
            print("Fatch ok")
        }
        catch {
            print("Fetching Failed")
        }
    }
}

//MARK: - SettingsTableView

extension FavoritesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return likeData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.reduseId) as! TableViewCell
        cell.label.text = likeData[indexPath.row].nameAuthor
        let urlString = likeData[indexPath.row].pictureURL!
        cell.iconImageView.sd_setImage(with: URL(string: urlString), placeholderImage: UIImage(named: "photo"))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentResult = likeData[indexPath.row]
        guard let uuid = likeData[indexPath.row].uuid else {return}
        let vc = DetalesLikeViewController(uuid: uuid)
        guard let result = currentResult else { return }
        vc.result = result
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let id = likeData[indexPath.row].uuid
            let request: NSFetchRequest<LikeEntities> = LikeEntities.fetchRequest()
            request.predicate = NSPredicate(format: "%K == %@", "uuid", id! as CVarArg )
            guard let result = try? context.fetch(request).first else {return}
            context.delete(result)
            try? context.save()
            fatch()
            self.tableView.reloadData()
        }
    }
}

