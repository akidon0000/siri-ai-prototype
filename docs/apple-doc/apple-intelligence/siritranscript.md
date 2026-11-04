---
source_url: https://developer.apple.com/documentation/sirievaluations/siritranscript
title: SiriTranscript
category: apple-intelligence
kind: tool
fetched_at: 2026-11-04T00:00:00Z
---

Siri Evaluations
Structure
SiriTranscript
The immutable record of one scenario’s execution.
iOS 27.3+
Beta
iPadOS 27.3+
Beta
macOS 27.3+
Beta
visionOS 27.3+
Beta
struct SiriTranscript
Overview

A transcript records what Siri does while running one scenario. For each turn, it holds:

the intents Siri calls, with their arguments

how each call ends

the entities Siri finds

the entities onscreen

the skills Siri loads

the reply Siri gives

A SiriExpectationEvaluator reads the transcript to compute metrics. When you write an evaluator of your own, read the transcript through the siriTranscript property of the evaluation subject.

Look up a turn with turn(for:) using the identifier of the UserTurn that produces it, not its position. Identifier lookup keeps a run that stops early from pairing a recorded turn with the wrong turn from the scenario.

The following shows a function that counts the intents Siri runs during a turn:

func ranIntentCount(for turn: UserTurn, in subject: SiriScenarioSubject) -> Int {
    // Look up the recorded turn by the identifier.
    guard let recorded = subject.siriTranscript.turn(for: turn.id) else {
        return 0
    }

    // Count the calls that run, not the ones that stop to ask a
    // question or fail.
    return recorded.intentInvocations
        .filter { $0.value.outcome.ran }
        .count
}

Topics
Inspecting a transcript
let turns: [SiriTranscript.Turn]
The turns the run reached, in conversation order.
func turn(for: UUID) -> SiriTranscript.Turn?
Returns the turn produced by the scenario turn with this identity, if it ran.
Reading transcript contents
struct Turn
Everything observed during one user turn.
struct IntentInvocation
A record of one intent call, including its arguments and result.
struct Observation
A value from the run, with the time the framework built its transcript.
Relationships
Conforms To
Sendable
SendableMetatype
See also
Results
struct SiriScenarioSubject
A record of one scenario’s run through Siri, as the Evaluations framework sees it.
Beta

Beta Software

This documentation contains preliminary information about an API or technology in development. This information is subject to change, and software implemented according to this documentation should be tested with final operating system software.

Learn more about using Apple's beta software
