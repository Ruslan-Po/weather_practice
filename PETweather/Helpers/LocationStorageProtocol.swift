import Foundation

protocol LocationStorageProtocol {
    func load() -> LastLocation?
    func save(_ location: LastLocation)
}


