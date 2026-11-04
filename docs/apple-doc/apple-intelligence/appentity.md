---
source_url: https://developer.apple.com/documentation/appintents/appentity(_:)
title: AppEntity(_:)
category: apple-intelligence
kind: tool
fetched_at: 2026-11-04T00:00:00Z
---

App Intents
Macro
AppEntity(_:)
Marks a transient entity whose values the model can generate on its own.
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
@attached(extension, conformances: GenerableEntity) macro AppEntity(_ traits: AppEntityTraits)
Parameters
traits

The entity’s roles, such as .generable or [.generable].

Overview

Apply this macro to a structure or class that conforms to TransientAppEntity. It adds a GenerableEntity conformance, using the availability declared on the type, or the availability of GenerableEntity when the type declares none.

@AppEntity(.generable)
struct FlightSearch: TransientAppEntity { ... }

See also
Entity support
protocol GenerableEntity
An interface that tells a model it can create an entity and fill in its properties directly.
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
