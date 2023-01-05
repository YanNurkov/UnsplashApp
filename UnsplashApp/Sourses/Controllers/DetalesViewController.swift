//
//  DetalesViewController.swift
//  UnsplashApp
//
//  Created by Ян Нурков on 02.01.2023.
//

import Foundation
import UIKit
import SDWebImage
import CoreData

class DetailViewController: UIViewController {
    var likeData: [LikeEntities] = []
    let context = (UIApplication.shared.delegate as!
                   AppDelegate).persistentContainer.viewContext
    var tab = Bool()
    var result: PhotosResult?
    var regular = ""
    
    //MARK: - Outlets
    
    lazy var mainView: UIView = {
        let obj = UIView()
        obj.backgroundColor = .white
        return obj
    }()
    
    lazy var image: UIImageView = {
        let obj = UIImageView()
        obj.layer.shadowRadius = 6
        obj.layer.cornerRadius = 20
        obj.layer.masksToBounds = true
        obj.translatesAutoresizingMaskIntoConstraints = false
        return obj
    }()
    
    lazy var nameLabel: UILabel = {
        let obj = UILabel()
        obj.textColor = .black
        obj.font = .boldSystemFont(ofSize: 18)
        obj.textAlignment = .left
        obj.translatesAutoresizingMaskIntoConstraints = false
        return obj
    }()
    
    lazy var profileView: UIImageView = {
        let obj = UIImageView()
        obj.layer.shadowRadius = 6
        obj.layer.cornerRadius = 25
        obj.layer.masksToBounds = true
        obj.translatesAutoresizingMaskIntoConstraints = false
        return obj
    }()
    
    lazy var dateLabel: UILabel = {
        let obj = UILabel()
        obj.textColor = .black
        obj.font = .systemFont(ofSize: 15)
        obj.textAlignment = .left
        obj.translatesAutoresizingMaskIntoConstraints = false
        return obj
    }()
    
    lazy var locationLabel: UILabel = {
        let obj = UILabel()
        obj.textColor = .black
        obj.font = .systemFont(ofSize: 15)
        obj.textAlignment = .right
        obj.translatesAutoresizingMaskIntoConstraints = false
        return obj
    }()
    
    lazy var downloadLabel: UILabel = {
        let obj = UILabel()
        obj.textColor = .black
        obj.font = .systemFont(ofSize: 15)
        obj.textAlignment = .right
        obj.translatesAutoresizingMaskIntoConstraints = false
        return obj
    }()
    
    lazy var likeButton: UIButton = {
        let obj = UIButton()
        obj.tintColor = .red
        obj.imageView?.contentMode = .scaleAspectFit
        obj.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 50), forImageIn: .normal)
        obj.translatesAutoresizingMaskIntoConstraints = false
        obj.addTarget(self, action: #selector(saveLike), for: .touchDown)
        return obj
    }()
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadLike()
        fillingData()
        likeStatus()
        setupLayout()
        NotificationCenter.default.addObserver(self, selector: #selector(switchTab), name: Notification.Name("switchTab"), object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadLike()
        likeStatus()
    }
    
    //MARK: - SetupLayout
    
    private func setupLayout() {
        guard let height = result?.height else {return}
        NSLayoutConstraint.activate([
            image.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            image.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            image.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            image.heightAnchor.constraint(equalToConstant: CGFloat(height)/12),
            
            profileView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            profileView.heightAnchor.constraint(equalToConstant: 50),
            profileView.widthAnchor.constraint(equalToConstant: 50),
            profileView.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 20),
            
            nameLabel.leadingAnchor.constraint(equalTo: profileView.trailingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            nameLabel.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 20),
            nameLabel.heightAnchor.constraint(equalToConstant: 20),
            
            dateLabel.leadingAnchor.constraint(equalTo: profileView.trailingAnchor, constant: 16),
            dateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            dateLabel.heightAnchor.constraint(equalToConstant: 20),
            dateLabel.bottomAnchor.constraint(equalTo: profileView.bottomAnchor),
            
            locationLabel.leadingAnchor.constraint(equalTo: profileView.trailingAnchor, constant: 16),
            locationLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            locationLabel.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 20),
            locationLabel.heightAnchor.constraint(equalToConstant: 20),
            
            downloadLabel.leadingAnchor.constraint(equalTo: profileView.trailingAnchor, constant: 16),
            downloadLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            downloadLabel.bottomAnchor.constraint(equalTo: profileView.bottomAnchor),
            downloadLabel.heightAnchor.constraint(equalToConstant: 20),
            
            likeButton.widthAnchor.constraint(equalToConstant: 30),
            likeButton.heightAnchor.constraint(equalToConstant: 30),
            likeButton.rightAnchor.constraint(equalTo: image.rightAnchor,constant: -10),
            likeButton.bottomAnchor.constraint(equalTo: image.bottomAnchor,constant: -10)
        ])
    }
    
    //MARK: - ConfigurationView
    
    private func setupUI() {
        view.addSubview(mainView)
        mainView.addSubview(image)
        mainView.addSubview(nameLabel)
        mainView.addSubview(profileView)
        mainView.addSubview(dateLabel)
        mainView.addSubview(locationLabel)
        mainView.addSubview(downloadLabel)
        mainView.addSubview(likeButton)
        mainView.frame = view.bounds
    }
    
    func fillingData() {
        guard let result = result else { return }
        image.sd_setImage(with: URL(string: result.urls.regular), placeholderImage: UIImage(named: "photo"))
        let date = String(result.created_at.prefix(10))
        dateLabel.text = date
        locationLabel.text = result.user.location
        downloadLabel.text = ("\(result.likes)")
        nameLabel.text = result.user.name
        profileView.sd_setImage(with: URL(string: result.user.profileImage.large), placeholderImage: UIImage(named: "photo"))
        regular = result.id
    }
    
    //MARK: - Actions
    
    func loadLike() {
        do {
            likeData = try context.fetch(LikeEntities.fetchRequest())
            print("Fatch ok")
        }
        catch {
            print("Fetching Failed")
        }
    }
    
    func likeStatus() {
        let query: NSFetchRequest<LikeEntities> = LikeEntities.fetchRequest()
        let predicate = NSPredicate(format: "%K == %@", "regular", regular as CVarArg)
        query.predicate = predicate
        
        do {
            likeData = try context.fetch(query)
            print(likeData.count)
            if likeData.count == 0 {
                likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
            }
            if likeData.count == 1 {
                likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            }
            if likeData.count >= 2 {
                likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
                guard let res = try? context.fetch(query).first else {return}
                context.delete(res)
            }
        } catch {
            print("error")
        }
    }
    
    @objc func saveLike() {
        if tab == false {
            tab = true
            likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            do {
                let data = LikeEntities(context: context)
                data.regular = result?.id
                data.pictureURL = result?.urls.regular
                data.nameAuthor = result?.user.name
                data.profileImage = result?.user.profileImage.large
                data.date = result?.created_at
                data.location = result?.user.location
                data.like = ("\(result?.likes ?? 0)")
                data.height = Int64(result?.height ?? 300)
                data.addDate = Date()
                let query: NSFetchRequest<LikeEntities> = LikeEntities.fetchRequest()
                let predicate = NSPredicate(format: "%K == %@", "regular", regular as CVarArg)
                query.predicate = predicate
                likeData = try context.fetch(query)
                if likeData.count > 1 {
                    guard let res = try? context.fetch(query).first else {return}
                    guard let last = try? context.fetch(query).last else {return}
                    context.delete(last)
                    context.delete(res)
                    tab = false
                    likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
                    print("jjj")
                    try context.save()
                } else {
                    print(data)
                }
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        } else {
            tab = false
            likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
            let request: NSFetchRequest<LikeEntities> = LikeEntities.fetchRequest()
            request.predicate = NSPredicate(format: "%K == %@", "regular", regular as CVarArg)
            guard let result = try? context.fetch(request).first else {return}
            context.delete(result)
            try? context.save()
        }
    }
    
    @objc func switchTab() {
        tab = false
    }
}


