import Foundation

final class LocationStorageAdapter: LocationStorageProtocol
{
    func load() -> LastLocation? { LocationStorageManager.load() }
    func save(_ location: LastLocation) { LocationStorageManager.save(location) }
}
