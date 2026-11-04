---
source_url: https://developer.apple.com/documentation/sirievaluations/siriscenariosubject
title: SiriScenarioSubject
category: apple-intelligence
kind: tool
fetched_at: 2026-11-04T00:00:00Z
---

Siri Evaluations
Structure
SiriScenarioSubject
A record of one scenario’s run through Siri, as the Evaluations framework sees it.
iOS 27.3+
Beta
iPadOS 27.3+
Beta
macOS 27.3+
Beta
visionOS 27.3+
Beta
struct SiriScenarioSubject
Topics
Inspecting the subject
var value: SiriScenarioSubject.ScenarioReport
The run as the report shows it.
let siriTranscript: SiriTranscript
Every observation captured during the run.
Reporting results
struct ScenarioReport
What the Xcode report shows for one scenario: Diagnostics, Scenario (if it has any expectations of its own), then each turn.
Relationships
Conforms To
EvaluationSubject
Sendable
SendableMetatype
See also
Results
struct SiriTranscript
The immutable record of one scenario’s execution.
Beta

Beta Software

This documentation contains preliminary information about an API or technology in development. This information is subject to change, and software implemented according to this documentation should be tested with final operating system software.

Learn more about using Apple's beta software
