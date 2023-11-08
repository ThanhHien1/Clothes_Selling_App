//
//  CartViewModel.swift
//  App
//
//  Created by Thanh Hien on 02/11/2023.
//

import Foundation
import Moya
import Kingfisher


class CartViewModel: ObservableObject {
    @Published var productId = 0
    @Published var quantity = 1
    @Published var color = ""
    @Published var size = ""
    @Published var id = 1
    @Published var image: UIImage?
    @Published var urlImage: String?
    @Published var cartItems: [Cart] = []
    
    func addCart(completed: @escaping () -> Void) {
        let token = UserDefaults.standard.string(forKey: Constanst.tokenKey) ?? ""
        let tokenPlugin = AccessTokenPlugin{_ in token }
        let plugin: PluginType = NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))
        let provider = MoyaProvider<MyService>(plugins: [tokenPlugin, plugin])
        provider.request(.addCart(productId: productId, quantity: quantity, color: color, size: size)) { [self] result in
            switch result {
            case let .success(moyaResponse):
                do {
                    let filteredResponse = try moyaResponse.filterSuccessfulStatusCodes()
                    let message = try filteredResponse.map(AddCartReponse.self)
                    print(message)
                    completed()
                    getCartItems()
                } catch {}
                print(self.productId, self.quantity, self.color, self.size)
            case let .failure(error):
                print(error)
                print(" thêm giỏ hàng k thành công")
            }
        }
    }
    
    func getCartItems() {
        let token = UserDefaults.standard.string(forKey: Constanst.tokenKey) ?? ""
        let tokenPlugin = AccessTokenPlugin{_ in token }
        let plugin: PluginType = NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))
        let provider = MoyaProvider<MyService>(plugins: [tokenPlugin, plugin])
        provider.request(.getCartItems) { [self] result in
            switch result {
            case let .success(moyaResponse):
                do {
                    let filteredResponse = try moyaResponse.filterSuccessfulStatusCodes()
                    let cart = try filteredResponse.map([Cart].self)
                    self.cartItems = cart
                    print(cart)
                } catch {}
            case let .failure(error):
                print(error)
                print("get cart item error")
            }
            
        }
    }
    
    func deleteCartItems() {
        let token = UserDefaults.standard.string(forKey: Constanst.tokenKey) ?? ""
        let tokenPlugin = AccessTokenPlugin{_ in token }
        let plugin: PluginType = NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))
        let provider = MoyaProvider<MyService>(plugins: [tokenPlugin, plugin])
        provider.request(.deleteCartItem(id: id)) {result in
            switch result {
            case .success(_):
                    self.getCartItems()
                print("Xoas thanhf coong")
            case let .failure(error):
                print(error)
                print("Xoa k thanh cong")
            }
        }
    }
    
}