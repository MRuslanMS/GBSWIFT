//
//  GetGroupListOperations.swift
//  VKProject1
//
//  Created by xc553a8 on 08.11.2021.
//

import Foundation
import RealmSwift

final class GetGroupsListOperations {

    lazy var operationQueue = OperationQueue()

    func getData() {
        let loadedJsonFromVK = LoadJsonData()
                let parsedDataFromJson = ParseJsonData()
                let saveData = SaveDataToRealm()

                parsedDataFromJson.addDependency(loadedJsonFromVK)
                saveData.addDependency(parsedDataFromJson)

                let operations = [loadedJsonFromVK, parsedDataFromJson, saveData]
                operationQueue.addOperations(operations, waitUntilFinished: false)
            }


            // добавление режима асинхронной работы для LoadJsonData, чтобы ожидать получения данных от сервера
            class OperationsAsync: Operation {

                enum State: String {
                    case ready, executing, finished
                    fileprivate var keyPath: String {
                        return "is" + rawValue.capitalized
                    }
                }

                var state = State.ready {
                    willSet {
                        willChangeValue(forKey: state.keyPath)
                        willChangeValue(forKey: newValue.keyPath)
                    }
                    didSet {
                        didChangeValue(forKey: state.keyPath)
                        didChangeValue(forKey: oldValue.keyPath)
                    }
                }

                override var isAsynchronous: Bool {
                    return true
                }

                override var isReady: Bool {
                    return super.isReady && state == .ready
                }

                override var isExecuting: Bool {
                    return state == .executing
                }

                override var isFinished: Bool {
                    return state == .finished
                }

                override func start() {
                    if isCancelled {
                        state = .finished
                    } else {
                        main()
                        state = .executing
                    }
                }

                override func cancel() {
                    super.cancel()
                    state = .finished
                }
                
            }

    final class LoadJsonData: OperationsAsync {
        
        var jsonFromVK: Data?
        var errorFromVK: Error?

        override func main() {

            // Конфигурация по умолчанию
            let configuration = URLSessionConfiguration.default
            // собственная сессия
            let session =  URLSession(configuration: configuration)

            // конструктор для URL
            var urlConstructor = URLComponents()
            urlConstructor.scheme = "https"
            urlConstructor.host = "api.vk.com"
            urlConstructor.path = "/method/groups.get"
            urlConstructor.queryItems = [
                URLQueryItem(name: "user_id", value: String(Session.instance.userId)),
                URLQueryItem(name: "extended", value: "1"),
                URLQueryItem(name: "access_token", value: Session.instance.token),
                URLQueryItem(name: "v", value: "5.122")
            ]

            // задача для запуска
            let task = session.dataTask(with: urlConstructor.url!) { [weak self] (data, _, error) in
                //print("Запрос к API: \(urlConstructor.url!)")
                
                // в замыкании данные, полученные от сервера, мы преобразуем в json
                guard let data = data else { return }
                self?.jsonFromVK = data //сохраняем в свойство данные
                self?.errorFromVK = error //сохраняем в свойство ошибки
                self?.state = .finished // меняем флаг, что операция закончена
            }
            task.resume()

        }
    }

    final class ParseJsonData: Operation {
        var dataFromJson: [Group]?
               var errorFromJson: Error?

               override func main() {

                   // так как изначально данных нет, то нужно взять данные из массива зависимостей (появляется при использовании addDependency)
                   guard
                       let operation = dependencies.first as? LoadJsonData,
                       let data = operation.jsonFromVK
                       else { return }

                   do {
                       let arrayGroups = try JSONDecoder().decode(GroupsResponse.self, from: data)
                       var grougList: [Group] = []
                       for i in 0...arrayGroups.response.items.count-1 {
                           let name = ((arrayGroups.response.items[i].name))
                           let logo = arrayGroups.response.items[i].logo
                           let id = arrayGroups.response.items[i].id
                           grougList.append(Group.init(groupName: name, groupLogo: logo, id: id))
                       }

                       dataFromJson = grougList
                   } catch let error {
                       errorFromJson = error
                       print(error.localizedDescription )
                   }
               }
        
    }

    final class SaveDataToRealm: Operation {
        override func main() {
                // так как изначально данных нет, то нужно взять данные из массива зависимостей (появляется при использовании addDependency)
                guard
                let operation = dependencies.first as? ParseJsonData,
                let data = operation.dataFromJson
                else { return }
                DispatchQueue.main.async {
                    RealmOperations().saveGroupsToRealm(data)
                }
            }
    }

}
