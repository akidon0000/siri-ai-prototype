---
source_url: https://developer.apple.com/documentation/appintents/computedproperty(title:description:authenticationpolicy:visibility:indexingkey:)
title: ComputedProperty(title:description:authenticationPolicy:visibility:indexingKey:)
category: apple-intelligence
kind: tool
fetched_at: 2026-11-04T00:00:00Z
---

App Intents
Macro
ComputedProperty(title:description:authenticationPolicy:visibility:indexingKey:)
A macro that adds a computed app entity property with a get accessor and an optional set accessor.
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
@attached(peer, names: prefixed(`$`), prefixed(`_`)) @attached(accessor, names: named(get), named(set))
macro ComputedProperty(
    title: LocalizedStringResource? = nil,
    description: LocalizedStringResource? = nil,
    authenticationPolicy: IntentAuthenticationPolicy? = nil,
    visibility: IntentVisibility? = nil,
    indexingKey: PartialKeyPath<CSSearchableItemAttributeSet>
)
Parameters
title

A localized string resource describing the property for display in the user interface.

description

Additional details about this property.

authenticationPolicy

The authentication policy to enforce when the system accesses this property, or nil to use the entity’s policy.

visibility

Whether the property is available to system features, or only to your app, or nil for .default.

indexingKey

A Spotlight attribute set key mapping for this property.

See also
Entity support
protocol GenerableEntity
An interface that tells a model it can create an entity and fill in its properties directly.
macro AppEntity(AppEntityTraits)
Marks a transient entity whose values the model can generate on its own.
macro AppEntity<T>(AppEntityTraits, schema: T)
Marks a transient entity that conforms to a schema as one whose values the model can generate on its own.
macro ComputedProperty(title: LocalizedStringResource?, description: LocalizedStringResource?, authenticationPolicy: IntentAuthenticationPolicy?, visibility: IntentVisibility?)
A macro that adds a computed app entity property with a get accessor and an optional set accessor.
macro ComputedProperty(title: LocalizedStringResource?, description: LocalizedStringResource?, authenticationPolicy: IntentAuthenticationPolicy?, visibility: IntentVisibility?, customIndexingKey: CSCustomAttributeKey)
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
