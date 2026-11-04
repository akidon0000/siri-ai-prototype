import AppIntents

// Siriが依頼の文から直接組み立てる検索条件。クエリで探さずに値を作れる
// .generable は AppEntityTraits の値。[.generable] と配列でも書ける。変数や計算した値は渡せない
// スキーマに合わせた一時的なEntityなら @AppEntity(.generable, schema: ...) と書く
@AppEntity(.generable)
struct MemoSearch: TransientAppEntity {
    static let typeDisplayRepresentation: TypeDisplayRepresentation = "メモ検索"
}
