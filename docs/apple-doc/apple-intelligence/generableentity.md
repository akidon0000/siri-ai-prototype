---
source_url: https://developer.apple.com/documentation/appintents/generableentity
title: GenerableEntity
category: apple-intelligence
kind: tool
fetched_at: 2026-11-04T00:00:00Z
---

App Intents
Protocol
GenerableEntity
An interface that tells a model it can create an entity and fill in its properties directly.
iOS 27.3+
Beta
iPadOS 27.3+
Beta
Mac Catalyst 27.3+
Beta
macOS 27.3+
Beta
visionOS 27.3+
Beta
protocol GenerableEntity : TransientAppEntity
Mentioned in
Bringing custom actions and content to Siri
Overview

The GenerableEntity protocol reduces the friction between a model’s output and your app’s custom types. The addition of this protocol to an entity type tells the model it can generate instances of the entity directly, and without using the entity’s query object. During the generation process, the model fills in the properties of the entity according to the descriptions you provide for each of its properties.

To support this protocol in one of your custom entity types, precede your type declaration with the @AppEntity macro and the generable trait, as shown in the following example. In addition to this macro, adopt the TransientAppEntity protocol to allow the system to create instances of your entity.

@AppEntity(.generable)
struct FlightSearch: TransientAppEntity {
    @Property(title: "Origin", description: "IATA code of the departure airport")
    var origin: String

    @Property(title: "Destination", description: "IATA code of the arrival airport")
    var destination: String

    @Property(title: "Date", description: "The day to depart")
    var date: Date
    // ...
}

For each declared property, include title and description parameters with values that the model can use to map its output to the required value. For example, in the preceding code, the descriptions of the origin and destination properties tell the model to fill in the property with an International Air Transport Association (IATA) code that identifies the airport.

Declare each property of a generable entity as one of the following types:

A plain value type, such as Int, String, or Date

An AppEnum type

Another GenerableEntity type

An array of one of these applicable types

Important

In an entity that supports the GenerableEntity protocol, the compiler reports an error if a property contains a nongenerable type.

Generable entities are useful as parameter types for a ToolIntent. In the following example, a person can invoke the tool with the phrase “Find a business class flight from SFO to JFK next Friday.” The tool’s one search parameter is a FlightSearch entity, which is a generable type. The model can create a FlightSearch entity instance directly and fill its properties with values it retrieves from the provided phrase. It can then call the intent’s perform() method to deliver the results.

@AppIntent(.tool)
struct SearchFlights: AppIntent {
    static let title: LocalizedStringResource = "Search Flights"
    static let description = IntentDescription("Finds flights for a route and date.")

    @Parameter(title: "Search", description: "The route and date to search")
    var search: FlightSearch

    func perform() async throws -> some ReturnsValue<[FlightEntity]> {
        .result(value: try await FlightService.search(search))
    }
}

Note

If a tool parameter contains a nongenerable, app-owned entity types, it runs entity queries to set the values of those parameters, instead of creating the entities directly.

Relationships
Inherits From
AppEntity
AppValue
CustomLocalizedStringResourceConvertible
DisplayRepresentable
Identifiable
InstanceDisplayRepresentable
PersistentlyIdentifiable
Sendable
SendableMetatype
TransientAppEntity
TypeDisplayRepresentable
See also
Entity support
macro AppEntity(AppEntityTraits)
Marks a transient entity whose values the model can generate on its own.
macro AppEntity<T>(AppEntityTraits, schema: T)
Marks a transient entity that conforms to a schema as one whose values the model can generate on its own.
macro ComputedProperty(title: LocalizedStringResource?, description: LocalizedStringResource?, authenticationPolicy: IntentAuthenticationPolicy?, visibility: IntentVisibility?)
A macro that adds a computed app entity property with a get accessor and an optional set accessor.
macro ComputedProperty(title: LocalizedStringResource?, description: LocalizedStringResource?, authenticationPolicy: IntentAuthenticationPolicy?, visibility: IntentVisibility?, customIndexingKey: CSCustomAttributeKey)
A macro that adds a computed app entity property with a get accessor and an optional set accessor.
macro ComputedProperty(title: LocalizedStringResource?, description: LocalizedStringResource?, authenticationPolicy: IntentAuthenticationPolicy?, visibility: IntentVisibility?, indexingKey: PartialKeyPath<CSSearchableItemAttributeSet>)
A macro that adds a computed app entity property with a get accessor and an optional set accessor.
macro DeferredProperty(title: LocalizedStringResource?, description: LocalizedStringResource?, authenticationPolicy: IntentAuthenticationPolicy?, visibility: IntentVisibility?)
A macro that adds an asynchronous app entity property with an asynchronous get accessor.
macro DeferredProperty(title: LocalizedStringResource?, description: LocalizedStringResource?, authenticationPolicy: IntentAuthenticationPolicy?, visibility: IntentVisibility?, indexingKey: PartialKeyPath<CSSearchableItemAttributeSet>)
A macro that adds an asynchronous app entity property with an asynchronous get accessor.
struct AppEntityTraits
The roles an app entity takes on, passed to @AppEntity.

Beta Software

This documentation contains preliminary information about an API or technology in development. This information is subject to change, and software implemented according to this documentation should be tested with final operating system software.

Learn more about using Apple's beta software
