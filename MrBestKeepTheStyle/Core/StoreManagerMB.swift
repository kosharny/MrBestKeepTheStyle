import Foundation
import StoreKit
import Combine

class StoreManagerMB: NSObject, ObservableObject, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    @Published var myProducts = [SKProduct]()
    @Published var transactionState: SKPaymentTransactionState?
    @Published var purchasedProductIDs: [String] = []
    
    var request: SKProductsRequest!
    
    // Replace with actual product IDs from App Store Connect
    let productIDs: Set<String> = [
        "com.mrbest.keepthestyle.royalbluepro",
        "com.mrbest.keepthestyle.darkneonpro"
    ]
    
    override init() {
        super.init()
        SKPaymentQueue.default().add(self)
        fetchProducts()
        // Check UserDefaults for previously purchased items (simple persistence)
        if let savedPurchases = UserDefaults.standard.stringArray(forKey: "purchasedProductIDs") {
            purchasedProductIDs = savedPurchases
        }
    }
    
    func fetchProducts() {
        request = SKProductsRequest(productIdentifiers: productIDs)
        request.delegate = self
        request.start()
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        if !response.products.isEmpty {
            DispatchQueue.main.async {
                self.myProducts = response.products
            }
        }
        
        for invalidIdentifier in response.invalidProductIdentifiers {
            print("Invalid Product ID: \(invalidIdentifier)")
        }
    }
    
    func purchaseProduct(product: SKProduct) {
        if SKPaymentQueue.canMakePayments() {
            let payment = SKPayment(product: product)
            SKPaymentQueue.default().add(payment)
        } else {
            print("User can't make payments.")
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchasing:
                transactionState = .purchasing
            case .purchased:
                transactionState = .purchased
                SKPaymentQueue.default().finishTransaction(transaction)
                handlePurchase(productID: transaction.payment.productIdentifier)
            case .restored:
                transactionState = .restored
                SKPaymentQueue.default().finishTransaction(transaction)
                handlePurchase(productID: transaction.payment.productIdentifier)
            case .failed:
                transactionState = .failed
                SKPaymentQueue.default().finishTransaction(transaction)
                if let error = transaction.error {
                    print("Payment failed: \(error.localizedDescription)")
                }
            case .deferred:
                transactionState = .deferred
            @unknown default:
                break
            }
        }
    }
    
    func restoreProducts() {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    func handlePurchase(productID: String) {
        if !purchasedProductIDs.contains(productID) {
            purchasedProductIDs.append(productID)
            UserDefaults.standard.set(purchasedProductIDs, forKey: "purchasedProductIDs")
        }
    }
    
    func isPurchased(_ productID: String) -> Bool {
        return purchasedProductIDs.contains(productID)
    }
}
