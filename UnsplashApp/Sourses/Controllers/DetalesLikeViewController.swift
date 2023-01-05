//
//  DetalesLikeViewController.swift
//  UnsplashApp
//
//  Created by Ян Нурков on 03.01.2023.
//


import Foundation
import UIKit
import SDWebImage
import CoreData

class DetalesLikeViewController: UIViewController {
    var likeData: [LikeEntities] = []
    let context = (UIApplication.shared.delegate as!
                   AppDelegate).persistentContainer.viewContext
    var tab: Bool = true
    var result: LikeEntities?
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
        obj.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        obj.tintColor = .red
        obj.imageView?.contentMode = .scaleAspectFit
        obj.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 50), forImageIn: .normal)
        obj.translatesAutoresizingMaskIntoConstraints = false
        obj.addTarget(self, action: #selector(deleteLike), for: .touchDown)
        return obj
    }()
    
   //MARK: - Init
    init (id: String) {
        self.regular = id
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fillingData()
        setupLayout()
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
        image.sd_setImage(with: URL(string: result.pictureURL!), placeholderImage: UIImage(named: "photo"))
        let dateNew = String(result.date!.prefix(10))
        dateLabel.text = dateNew
        locationLabel.text = result.location
        downloadLabel.text = ("\(result.like ?? "")")
        nameLabel.text = result.nameAuthor
        profileView.sd_setImage(with: URL(string: result.profileImage ?? ""), placeholderImage: UIImage(named: "photo"))
        regular = result.regular ?? ""
    }
    
    //MARK: - Actions
    
    @objc func deleteLike() {
        let request: NSFetchRequest<LikeEntities> = LikeEntities.fetchRequest()
        request.predicate = NSPredicate(format: "%K == %@", "regular", regular as CVarArg)
        guard let result = try? context.fetch(request).first else {return}
        NotificationCenter.default.post(name: Notification.Name("switchTab"), object: nil)
        context.delete(result)
        try? context.save()
        if tab == false {
            tab = true
            likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            tab = false
            likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
            navigationController?.popViewController(animated: true)
            dismiss(animated: true, completion: nil)
        }
    }
}


