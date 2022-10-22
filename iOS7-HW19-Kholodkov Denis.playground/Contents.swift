import UIKit

import var CommonCrypto.CC_MD5_DIGEST_LENGTH
import func CommonCrypto.CC_MD5
import typealias CommonCrypto.CC_LONG

// MARK: - get hash for two varriants

func MD5(string: String) -> Data {
        let length = Int(CC_MD5_DIGEST_LENGTH)
        let messageData = string.data(using:.utf8)
        var digestData = Data(count: length)

    _ = digestData.withUnsafeMutableBytes { digestBytes -> (UInt8?) in
            (messageData?.withUnsafeBytes { messageBytes -> UInt8 in
                if let messageBytesBaseAddress = messageBytes.baseAddress, let digestBytesBlindMemory = digestBytes.bindMemory(to: UInt8.self).baseAddress {
                    let messageLength = CC_LONG(messageData?.count ?? 0)
                    CC_MD5(messageBytesBaseAddress, messageLength, digestBytesBlindMemory)
                }
                return 0
            })
        }
        return digestData
    }

// MARK: - test performing function

let md5Data = MD5(string:"19c780b4c5e237b923fa240915d17fc660c8c65ab76e11f4cafd421488974a942a334254f")

let md5Hex =  md5Data.map { String(format: "%02hhx", $0) }.joined()
print("md5Hex: \(md5Hex)")

let md5Base64 = md5Data.base64EncodedString()
print("md5Base64: \(md5Base64)")
print("-----------------------")

// MARK: - main constants of URL

let timeStamp = "1"
let apiKey = "76e11f4cafd421488974a942a334254f"
let hash = md5Hex // 097b0685fa5871c9487052504c2328d6

// MARK: - main function of project

func getData(urlRequest: String) {
    let urlRequest = URL(string: urlRequest)
    guard let url = urlRequest else { return }
    URLSession.shared.dataTask(with: url) { data, response, error in
        if error != nil {
            print("Error: \(String(describing: error))")
        } else if let response = response as? HTTPURLResponse, response.statusCode == 200 {
            print("response = \(response.statusCode)")
            
            guard let data = data else { return }
            let dataAsString = String(data: data, encoding: .utf8)
            print("Data printing \n ---------------------- \n\(String(describing: dataAsString))")
        }
    }.resume()
}

let url = "http://gateway.marvel.com/v1/public/comics?ts="
+ "\(timeStamp)&apikey=" + "\(apiKey)&hash=" + "\(hash)"
getData(urlRequest: url)
