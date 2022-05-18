//
//  StoreFromJson.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/4/24.
//

import Foundation

struct Excel: Codable {
    let page1: [ExcelData]
}
struct ExcelData: Codable {
    let name: String
    var engName: String? = ""
    let address: String
    let area: String
    let coordinateLong: String
    let coordinateLat: String
    let mainImage: String
    let menuImage: String
    let phone: String
    let facebookLink: String
    let tags: String
    let meals: String
    let seat: String
    let sun: String
    let mon: String
    let tue: String
    let wed: String
    let thu: String
    let fri: String
    let sat: String
    var note: String? = ""
    var closeDay: String? = ""
    enum CodingKeys: String, CodingKey {
        case name
        case engName
        case address
        case area
        case coordinateLong = "coordinate_long"
        case coordinateLat = "coordinate_lat"
        case mainImage
        case menuImage
        case phone
        case facebookLink
        case tags
        case meals
        case seat
        case sun
        case mon
        case tue
        case wed
        case thu
        case fri
        case sat
        case note
        case closeDay
    }
}

class AppDataProvider {
    
    static let shared = AppDataProvider()
    
    func allInOne() {
        callGet { data in
            self.mapDataFromExcelToFirebase(datas: data.page1) { datas in
                var datacopy = datas
                for i in 0..<datacopy.count {
                    StoreRequestProvider.shared.adminPublishNewStore(store: &datacopy[i]) { result in
                        switch result {
                        case .success(let message):
                            print(message)
                        case .failure(let error):
                            print(error)
                        }
                    }
                }
                
            }
        }
    }
    func decodingFormPlist(com: @escaping (Excel) -> ()) {
        let url = Bundle.main.url(forResource: "dataraman", withExtension: "plist")!
        
        guard let data = try? Data(contentsOf: url) else {
            print("123 Fail.")
            return com(Excel(page1: []))
        }
        
        guard let decodedData = try? PropertyListDecoder().decode(Excel.self, from: data) else { print("345")
            return com(Excel(page1: [])) }
        
        com(decodedData)
        
    }
    func callGet(com: @escaping (Excel) -> () ) {
        let urla = URL(string: "https://run.mocky.io/v3/61013114-7cd1-41ae-a9c4-9ee8de90ce31")!
        URLSession.shared.dataTask(with: urla) { data, res, error in
            guard let data = data else {
                return
            }
            do {
                let newdata = try JSONDecoder().decode(Excel.self, from: data)
                
                com(newdata)
            }
            catch {
                print(error)
                com(Excel(page1: []))
            }
        }.resume()
    }
    func mapDataFromExcelToFirebase(datas: [ExcelData],com: @escaping ([Store]) -> ()) {
        var storeArray: [Store] = []
        for data in datas {
            var closeInt: [Int] = []
            if data.closeDay != "" {
                let close = data.closeDay?.components(separatedBy: [" "])
                let array: [Int] = close?.compactMap { Int($0) } ?? []
                closeInt = array
            }
            let store = Store(storeID: "",
                              name: data.name,
                              engName: data.engName ?? "",
                              area: data.area,
                              facebookLink: data.facebookLink,
                              note: data.note ?? "",
                              address: data.address,
                              coordinate: Coordinate(long: Double(data.coordinateLong)!, lat: Double(data.coordinateLat)!),
                              phone: data.phone,
                              tags: data.tags.components(separatedBy: [" "]),
                              meals: data.meals.components(separatedBy: [" "]),
                              seat: data.seat,
                              opentime: Opentime(
                                sun: Time(lunch: data.sun.components(separatedBy: [" "]).first!,
                                          dinner: data.sun.components(separatedBy: [" "]).last!),
                                mon: Time(lunch: data.mon.components(separatedBy: [" "]).first!,
                                          dinner: data.mon.components(separatedBy: [" "]).last!),
                                tue: Time(lunch: data.tue.components(separatedBy: [" "]).first!,
                                          dinner: data.tue.components(separatedBy: [" "]).last!),
                                wed: Time(lunch: data.wed.components(separatedBy: [" "]).first!,
                                          dinner: data.wed.components(separatedBy: [" "]).last!),
                                thu: Time(lunch: data.thu.components(separatedBy: [" "]).first!,
                                          dinner: data.thu.components(separatedBy: [" "]).last!),
                                fri: Time(lunch: data.fri.components(separatedBy: [" "]).first!,
                                          dinner: data.fri.components(separatedBy: [" "]).last!),
                                sat: Time(lunch: data.sat.components(separatedBy: [" "]).first!,
                                          dinner: data.sat.components(separatedBy: [" "]).last!)),
                              menuImage: data.menuImage,
                              mainImage: data.mainImage,
                              closeDay: closeInt)
            print(store)
            storeArray.append(store)
        }
        com(storeArray)
    }
    
}
