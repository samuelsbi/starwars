
import Foundation
import Swinject

extension Resolver {
    public func resolveUnwrapping<Service>(_ serviceType: Service.Type) -> Service {
        if let resolution = resolve(serviceType) {
            return resolution
        }
        fatalError("\(serviceType) resolution failed")
    }

    public func resolveUnwrapping<Service, Arg1>(_ serviceType: Service.Type, argument: Arg1) -> Service {
        if let resolution = resolve(serviceType, argument: argument) {
            return resolution
        }
        fatalError("\(serviceType) resolution failed")
    }

    // swiftlint:disable function_parameter_count
    public func resolveUnwrapping<Service, Arg1, Arg2>(_ serviceType: Service.Type, arguments arg1: Arg1, _ arg2: Arg2) -> Service {
        if let resolution = resolve(serviceType, arguments: arg1, arg2) {
            return resolution
        }
        fatalError("\(serviceType) resolution failed")
    }

    public func resolveUnwrapping<Service, Arg1, Arg2, Arg3>(
        _ serviceType: Service.Type,
        arguments arg1: Arg1,
        _ arg2: Arg2,
        _ arg3: Arg3
    ) -> Service {
        if let resolution = resolve(serviceType, arguments: arg1, arg2, arg3) {
            return resolution
        }
        fatalError("\(serviceType) resolution failed")
    }

}
