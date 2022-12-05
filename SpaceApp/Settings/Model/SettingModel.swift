import Foundation

struct Setting {
    let title: String
    let positionKey: String
    let values: [String]
}

extension Setting {
    static let settingsArray = [
        Setting(
            title: "Высота",
            positionKey: PersistancePositionKeys.heightPositionKey,
            values: ["m", "ft"]
        ),
        Setting(
            title: "Диаметр",
            positionKey: PersistancePositionKeys.diameterPositionKey,
            values: ["m", "ft"]
        ),
        Setting(
            title: "Масса",
            positionKey: PersistancePositionKeys.massPositionKey,
            values: ["kg", "lb"]
            ),
        Setting(
            title: "Полезная нагрузка",
            positionKey: PersistancePositionKeys.capacityPositionKey,
            values: ["kg", "lb"]
            )
    ]
}
