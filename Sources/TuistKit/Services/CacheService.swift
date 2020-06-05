import Foundation
import TSCBasic
import TuistSupport
import TuistCore
import TuistLoader

final class CacheService {
    /// Cache controller.
    private let cacheController: CacheControlling
    
    /// Generator Model Loader, used for getting the user config
    private let generatorModelLoader: GeneratorModelLoader

    init(cacheController: CacheControlling = CacheController(),
         manifestLoader: ManifestLoader = ManifestLoader(),
         manifestLinter: ManifestLinter = ManifestLinter()) {
        self.cacheController = cacheController
        self.generatorModelLoader = GeneratorModelLoader(manifestLoader: manifestLoader,
                                                         manifestLinter: manifestLinter)
    }

    func run(path: String?) throws {
        let path = self.path(path)
        let userConfig = try loadConfig()
        try cacheController.cache(path: path, userConfig: userConfig)
    }

    // MARK: - Helpers

    private func path(_ path: String?) -> AbsolutePath {
        if let path = path {
            return AbsolutePath(path, relativeTo: currentPath)
        } else {
            return currentPath
        }
    }
    
    private func loadConfig() throws -> Config {
        return try generatorModelLoader.loadConfig(at: currentPath)
    }
    
    private var currentPath: AbsolutePath {
        FileHandler.shared.currentPath
    }
}
