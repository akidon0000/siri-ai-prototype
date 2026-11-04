import AppIntents
import GeoToolbox

// reminder スキーマの locationTrigger に入る型。Memoは場所での通知に対応していないので、保存はしない
// スキーマの必須プロパティは event と place。Siriが値を組み立てて渡すので TransientAppEntity にする
@AppEntity(schema: .reminders.locationTrigger)
struct MemoLocationTriggerEntity: TransientAppEntity {
    var event: MemoLocationTriggerEvent
    var place: PlaceDescriptor

    var displayRepresentation: DisplayRepresentation {
        "場所"
    }
}

@AppEnum(schema: .reminders.locationTriggerEvent)
enum MemoLocationTriggerEvent: String {
    case arrive, depart

    static let caseDisplayRepresentations: [Self: DisplayRepresentation] = [
        .arrive: "到着したとき",
        .depart: "出発したとき",
    ]
}
