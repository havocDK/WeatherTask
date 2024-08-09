//
//  Enums.swift
//  WeatherTask
//
//  Created by Dimitar Kolev on 9.08.24.
//

import Foundation

enum WeatherCode: Int {
    case clear = 0
    case mainlyClear = 1
    case partlyCloudy = 2
    case overcast = 3
    case fog = 45
    case rimeFog = 48
    case drizzleLight = 51
    case drizzleModerate = 53
    case drizzleDense = 55
    case freezingDrizzleLight = 56
    case freezingDrizzleDense = 57
    case rainSlight = 61
    case rainModerate = 63
    case rainHeavy = 65
    case freezingRainLight = 66
    case freezingRainHeavy = 67
    case snowSlight = 71
    case snowModerate = 73
    case snowHeavy = 75
    case snowGrains = 77
    case rainShowerSlight = 80
    case rainShowerModerate = 81
    case rainShowerViolent = 82
    case snowShowerSlight = 85
    case snowShowerHeavy = 86
    case thunderstorm = 95
    case thunderHailSlight = 96
    case thunderHailHeavy = 99
    var description: String {
        switch self {
        case .clear:
            return "Clear sky"
        case .mainlyClear:
            return "Mainly clear"
        case .partlyCloudy:
            return "Partly cloudy"
        case .overcast:
            return "Overcast"
        case .fog:
            return "Fog"
        case .rimeFog:
            return "Depositing rime fog"
        case .drizzleLight:
            return "Light drizzle"
        case .drizzleModerate:
            return "Moderate drizzle"
        case .drizzleDense:
            return "Dense drizzle"
        case .freezingDrizzleLight:
            return "Light freezing drizzle"
        case .freezingDrizzleDense:
            return "Dense freezing drizzle"
        case .snowSlight:
            return "Light snow fall"
        case .snowModerate:
            return "Moderate snow fall"
        case .snowHeavy:
            return "Heavy snow fall"
        case .snowGrains:
            return "Snow grains"
        case .rainShowerSlight:
            return "Slight rain showers"
        case .rainShowerModerate:
            return "Moderate rain showers"
        case .rainShowerViolent:
            return "Violent rain showers"
        case .snowShowerSlight:
            return "Slight snow showers"
        case .snowShowerHeavy:
            return "Heavy snow showers"
        case .thunderstorm:
            return "Thunderstorm"
        case .thunderHailSlight:
            return "Thunderstorm with slight hail"
        case .thunderHailHeavy:
            return "Thunderstorm with heavy hail"
        default:
            return "Unknown weather condition"
        }
    }
}
