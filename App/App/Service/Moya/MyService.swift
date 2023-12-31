//
//  MyService.swift
//  App
//
//  Created by Thanh Hien on 12/10/2023.
//

import Foundation
import Moya

enum MyService {
    case register(name: String, email: String, password: String, gender: String?, image: String?, address: String, phone: String)
    case login(email: String, password: String)
    case showCategories
    case showProfile
    case displayAndArrangeProducts(page: Int, size: Int, sort: String)
    case showProduct(sort: String?)
    case updateProfile(name: String?, address: String?, phone: String?, gender: String?, avatar: String?)
    case addCart(productId: Int, quantity: Int, color: String, size: String)
    case getCartItems
    case getItemDetail(id: Int)
    case deleteCartItem(id: Int)
    case deleteAllCartItem
    case addFavouriteProduct(id: Int)
    case getFavouriteProduct
    case deleteFavouriteProduct(id: Int)
    case createPayment(amount: Double, addressDelivery: String, productId: Int?, color: String?, size: String?, quantity: Int?)
    case createCOD(amount: Double, addressDelivery: String, productId: Int?, color: String?, size: String?, quantity: Int?)
    case getAllOders
}

extension MyService: TargetType, AccessTokenAuthorizable {
    var baseURL: URL { URL(string: "http://localhost:8080")! }
    var path: String {
        switch self {
        case .register(_,_,_,_,_,_,_):
            return "/user/register"
        case .login(_,_):
            return "/user/login"
        case .showCategories:
            return "/category/all"
        case .showProfile:
            return "/user/profile"
        case .showProduct(_):
            return "/product/all"
        case .updateProfile(_,_,_,_,_):
            return "/user/profile/edit"
        case .addCart(_,_,_,_):
            return "/cart/add"
        case .getCartItems:
            return "/cart"
        case .getItemDetail(let id):
            return "/product/detail/\(id)"
        case .deleteCartItem(let id):
            return "/cart/delete/\(id)"
        case .deleteAllCartItem:
            return "/cart/deleteAllCartItems"
        case .addFavouriteProduct(let id):
            return "/favouriteProduct/add/\(id)"
        case .getFavouriteProduct:
            return "/favouriteProduct"
        case .deleteFavouriteProduct(id: let id):
            return "/favouriteProduct/delete/\(id)"
        case .createPayment(_,_,_,_,_,_):
            return "/payment/createPayment"
        case .displayAndArrangeProducts(_,_,_):
            return "/product/all"
        case .createCOD(_,_,_,_,_,_):
            return "/order/createOrder"
        case .getAllOders:
            return "/order/getOrders"
        }
    }
    var method: Moya.Method {
        switch self {
        case .showCategories, .showProfile, .showProduct, .getCartItems, .getItemDetail, .getFavouriteProduct, .displayAndArrangeProducts, .getAllOders:
            return .get
        case .register, .login, .updateProfile, .addCart, .addFavouriteProduct, .createCOD, .createPayment:
            return .post
        case .deleteCartItem, .deleteFavouriteProduct, .deleteAllCartItem:
            return .delete
        }
    }
    var task: Task {
        switch self {
        case .showCategories, .showProfile, .getCartItems, .getItemDetail, .deleteCartItem, .addFavouriteProduct, .getFavouriteProduct, .deleteFavouriteProduct, .deleteAllCartItem, .getAllOders:
            return .requestPlain
        case .register(name: let name, email: let email, password: let password, gender: let gender, image: let image, address: let address, phone: let phone):
            return .requestParameters(parameters: ["name": name, "email": email, "password": password, "address": address, "phone": phone], encoding: JSONEncoding.default)
        case .login(let email, let password):
            return .requestParameters(parameters: ["email": email, "password": password], encoding: JSONEncoding.default)
        case .showProduct(sort: let sort):
            return .requestParameters(parameters: ["sort": sort ?? ""], encoding: URLEncoding.default)
        case .displayAndArrangeProducts(page: let page, size: let size, sort: let sort):
            return .requestParameters(parameters: ["page": page, "size": size, "sort": sort], encoding: URLEncoding.default)
        case .updateProfile(name: let name, address: let address, phone: let phone, gender: let gender, avatar: let avatar):
            return .requestParameters(parameters: ["name": name, "address": address ?? "", "phone": phone, "gender": gender ?? "", "avatar": avatar], encoding: JSONEncoding.default)
        case .addCart(productId: let productId, quantity: let quantity, color: let color, size: let size):
            return .requestParameters(parameters: ["productId": productId, "quantity": quantity, "color": color, "size": size], encoding: JSONEncoding.default)
        case .createCOD(amount: let amount, addressDelivery: let addressDelivery, productId: let productId, color: let color, size: let size, quantity: let quantity):
            return .requestParameters(parameters: ["amount": amount, "addressDelivery": addressDelivery, "productId": productId,"color": color, "size": size, "quantity": quantity ], encoding: JSONEncoding.default)
        case .createPayment(amount: let amount, addressDelivery: let addressDelivery, productId: let productId, color: let color, size: let size, quantity: let quantity):
            return .requestParameters(parameters: ["amount": amount, "addressDelivery": addressDelivery, "productId": productId,"color": color, "size": size, "quantity": quantity ], encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String: String]? {
        return ["Content-type": "application/json"]
    }
    
    var authorizationType: AuthorizationType? {
        switch self{
        case .showProfile, .updateProfile, .addCart, .getCartItems, .getCartItems, .deleteCartItem, .addFavouriteProduct, .getFavouriteProduct, .deleteFavouriteProduct, .createPayment, .displayAndArrangeProducts, .createCOD, .deleteAllCartItem, .getAllOders:
            return .bearer
        default:
            return nil
        }
    }
}
private extension String {
    var urlEscaped: String {
        addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
    
    var utf8Encoded: Data { Data(self.utf8) }
}
