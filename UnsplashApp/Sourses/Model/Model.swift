//
//  Model.swift
//  UnsplashApp
//
//  Created by Ян Нурков on 02.01.2023.
//

import Foundation

// MARK: - APIResponse

struct PhotosResponse: Codable {
    let totalPages: Int
    let results: [PhotosResult]
    
    enum CodingKeys: String, CodingKey {
        case totalPages = "total_pages"
        case results
    }
}

// MARK: - Result

struct PhotosResult: Codable, Identifiable {
    let id: String
    let urls: Urls
    let likes: Int
    let height : Int
    let created_at: String
    let resultDescription: String?
    let user: User
    
    enum CodingKeys: String, CodingKey {
        case id
        case likes
        case height
        case created_at
        case resultDescription = "description"
        case urls
        case user
    }
}

// MARK: - Urls

struct Urls: Codable {
    let regular: String
}

// MARK: - User

struct User: Codable {
    let id: String
    let name: String
    let location: String?
    let profileImage: ProfileImage
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case location
        case profileImage = "profile_image"
    }
}

// MARK: - ProfileImage

struct ProfileImage: Codable {
    let large: String
}
