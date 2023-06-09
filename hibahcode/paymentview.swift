//
//  paymentview.swift
//  hibahcode
//
//  Created by WadiahAlbuhairi on 17/11/1444 AH.
//

import SwiftUI
import StoreKit

struct paymentview: View {
    @EnvironmentObject private var purchaseManager: PurchaseManager
    
    var body: some View {
        ZStack {
            Image("0")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                if purchaseManager.hasUnlockedPro {
                    Text("Thank you :)")
                } else {
                    
                    ForEach(purchaseManager.products) { product in
                        Button {
                            Task {
                                do {
                                    try await purchaseManager.purchase(product)
                                } catch {
                                    print(error)
                                }
                            }
                        } label: {
                            Text("\(product.displayName) - \(product.displayPrice)")
                                .foregroundColor(.white)
                                .frame(width: 300, height: 50)
                                .background(RoundedRectangle(cornerRadius: 15)
                                    .fill(Color("pemantcolor"))
                                    .opacity(1)
                                )
                        }
                    }
                    Button {
                        Task {
                            do {
                                try await AppStore.sync()
                            } catch {
                                print(error)
                            }
                        }
                    } label: {
                        Text("Restore Purchases")
                    }
                }
            }.task {
                Task {
                    do {
                        try await purchaseManager.loadProudcts()
                    } catch {
                        print(error)
                    }
                }
            }
        }
    }
}

