//
//  ChooseAddressView.swift
//  App
//
//  Created by Thanh Hien on 21/10/2023.
//

import SwiftUI

struct ChooseAddressView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var path: NavigationPath
    @State var showAddAddress = false
    @State var isSelected: Int = 0
    @State var value: Int = 0
    @State var address = [ItemAddress(name: " Nguyễn Thị Thanh Hiền", phone: "01243242343", address: "213 chau tinh tri", contries: "Thanh xuan, Ha noi, Viet nam"), ItemAddress(name: "Nguyễn Thị Thanh Hiền", phone: "01243242343", address: "213 chau tinh tri", contries: "Thanh xuan, Ha noi, Viet nam"), ItemAddress(name: "Nguyễn Thị Thanh Hiền", phone: "01243242343", address: "213 chau tinh tri", contries: "Thanh xuan, Ha noi, Viet nam")]
    
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Spacer().frame(height: 20)
            HStack(spacing: 0) {
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "arrow.left")
                        .resizable()
                        .foregroundColor(.black)
                        .frame(width: 18, height: 18)
                        .padding(.leading, 25)
                }
                Text("Địa chỉ của tôi")
                    .font(.system(size: 24))
                    .fontWeight(.medium)
                    .padding(.leading, 15)
                Spacer()
                //                    }
            }
            Spacer().frame(height: 30)
            RadioAddressGroup(items: address , selection: 0) {
                //                    address.append(ItemAddress(name: "Hien", phone: "01243242343", address: "213 chau tinh tri", contries: "Thanh xuan, Ha noi, Viet nam")
                self.showAddAddress = true
            }
            Spacer()
        }
        .navigationBarBackButtonHidden(true)
        .navigationDestination(isPresented: $showAddAddress) {
            AddAddressView(path: $path)
        }
    }
}

struct ChooseAddressView_Previews: PreviewProvider {
    static var previews: some View {
        ChooseAddressView(path: .constant(NavigationPath()))
    }
}