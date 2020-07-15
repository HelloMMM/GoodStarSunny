//
//  IAPManager.swift
//  AnswerBook
//
//  Created by HellöM on 2020/3/11.
//  Copyright © 2020 HellöM. All rights reserved.
//

import UIKit
import StoreKit

class IAPManager: NSObject {
    
    let productID = "uuu.HelloM.BodyInformation.item02"
    static let shared = IAPManager()
    var reuqest: SKProductsRequest!
    var products: [SKProduct] = []
    
    override init() {
        super.init()
        
        SKPaymentQueue.default().add(self)
    }
    
    func startPurchase() {
        
        NVLoadingView.startBlockLoadingView()
        
        for transaction: SKPaymentTransaction in SKPaymentQueue.default().transactions {
            
            SKPaymentQueue.default().finishTransaction(transaction)
        }
        
        let products = NSSet(array: [productID])
        
        reuqest = SKProductsRequest(productIdentifiers: products as! Set<String>)
        reuqest.delegate = self
        reuqest.start()
    }
    
    func restorePurchase() {
        
        NVLoadingView.startBlockLoadingView()
        
        if SKPaymentQueue.canMakePayments() {
            SKPaymentQueue.default().restoreCompletedTransactions()
        }
    }
}

extension IAPManager: SKProductsRequestDelegate {
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        
        if response.products.count != 0 {
            
            for product: SKProduct in response.products {
                
                print("---------商品資訊---------")
                print("商品標题: \(product.localizedTitle)")
                print("商品描述: \(product.localizedDescription)")
                print("商品價格: \(product.price)")
                print("商品ID: \(product.productIdentifier)")
                print("---------商品資訊---------")
                
                products.append(product)
            }
        } else {
            
            NVLoadingView.stopBlockLoadingView()
            return
        }
        
        if let productInfo = products.first {
            
            let payment = SKPayment(product: productInfo)
            SKPaymentQueue.default().add(payment)
        } else {
            
            NVLoadingView.stopBlockLoadingView()
        }
    }
}

extension IAPManager: SKPaymentTransactionObserver {
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
        for transaction: SKPaymentTransaction in transactions {
            
            if transaction.payment.productIdentifier == productID {
                
                switch transaction.transactionState {
                case .purchased:
                    
                    print("交易成功")
                    NVLoadingView.stopBlockLoadingView()
                    UserDefaults.standard.set(true, forKey: "isRemoveAD")
                    NotificationCenter.default.post(name: Notification.Name("RemoveAD"), object: nil)
                    SKPaymentQueue.default().finishTransaction(transaction)
                case .purchasing:
                    print("交易中")
                case .failed:
                    print("交易失敗")
                    
                    NVLoadingView.stopBlockLoadingView()
                    SKPaymentQueue.default().finishTransaction(transaction)
                    if let error = transaction.error as? SKError {
                        switch error.code {
                        case .paymentCancelled:
                            print("Transaction Cancelled: \(error.localizedDescription)")
                        case .paymentInvalid:
                            print("Transaction paymentInvalid: \(error.localizedDescription)")
                        case .paymentNotAllowed:
                            print("Transaction paymentNotAllowed: \(error.localizedDescription)")
                        default:
                            print("Transaction: \(error.localizedDescription)")
                        }
                    }
                case .restored:
                    
                    print("復原成功...")
                    NVLoadingView.stopBlockLoadingView()
                    UserDefaults.standard.set(true, forKey: "isRemoveAD")
                    NotificationCenter.default.post(name: Notification.Name("RemoveAD"), object: nil)
                    SKPaymentQueue.default().finishTransaction(transaction)
                    
                    let alert = UIAlertController(title: nil, message: "恢復成功", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "確定", style: .cancel, handler: nil)
                    alert.addAction(ok)
                    UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
                default:
                    print(transaction.transactionState.rawValue)
                    NVLoadingView.stopBlockLoadingView()
                }
            }
        }
    }
    
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        
        NVLoadingView.stopBlockLoadingView()
        
        if queue.transactions.count == 0 {
            
            let alert = UIAlertController(title: "注意!", message: "恢復失敗,\n尚未購買去除廣告.", preferredStyle: .alert)
            let ok = UIAlertAction(title: "確定", style: .cancel, handler: nil)
            alert.addAction(ok)
            
            UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
        
        NVLoadingView.stopBlockLoadingView()
        print("restoreCompletedTransactionsFailedWithError: \(queue)")
    }
}
