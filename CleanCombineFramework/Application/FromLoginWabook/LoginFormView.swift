//
//  LoginFormView.swift
//  CleanCombineFramework
//
//  Created by Hai Sombo on 6/25/24.
//

import SwiftUI

struct LoginFormView: View {
    
    
    @StateObject var loginVM =  LogInVM()
    @State var userName : String = ""
    @State var passWord : String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                Text ("Log in WABOOKS ")
                    .font(.largeTitle)
                    .foregroundColor(.black)
                Divider()
                VStack (spacing : 20 ){
                    TextField("Enter ID", text: $userName)
                       .padding()
                       .foregroundColor(.black)
                       .frame( width: 350, height:  45)
                       .background(Color.gray.opacity(0.2))
                       .cornerRadius(12)
                    
                    TextField("Enter PAssword", text: $passWord)
                        .keyboardType(.numberPad)
                       .padding()
                       .foregroundColor(.black)
                       .frame( width: 350, height:  45)
                       .background(Color.gray.opacity(0.2))
                       .cornerRadius(12)
                       
                }.padding()
                
                Divider()
                Button(action: {
                 print("LogIn \(userName) , \(passWord)" )
                    self.loginVM.requestR001(USER_ID: userName, PWD: passWord) { result in
                        
                        switch result {
                        case  .success(let data) :
                            print(data)
                        case .failure(let error):
                            print(error.localizedDescription)
                        }
                    }
                }, label: {
                    Text("Login")
                        .font(.title)
                        .foregroundColor(.white)
                        .frame(width: 100   , height: 50)
                        .background(Color.blue.opacity(0.7))
                        .cornerRadius(12)
                })
            }
        }

    }
}

//#Preview {
//    LoginFormView()
//}
