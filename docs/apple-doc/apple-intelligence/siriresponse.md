---
source_url: https://developer.apple.com/documentation/sirievaluations/siriresponse
title: SiriResponse
category: apple-intelligence
kind: tool
fetched_at: 2026-11-04T00:00:00Z
---

Siri Evaluations
Structure
SiriResponse
An expectation that the reply Siri gives contains specific text.
iOS 27.3+
Beta
iPadOS 27.3+
Beta
macOS 27.3+
Beta
visionOS 27.3+
Beta
struct SiriResponse
Overview

Use SiriResponse to check the text of the reply Siri gives for a turn. Every check must hold, and each check passes when the reply contains the text you give. The text is plain text, not a pattern. A check is case-sensitive unless you pass false for caseSensitive. In the Xcode evaluation report, a check that fails shows the reply Siri gives next to the text it requires.

The wording Siri uses varies between runs even when Siri responds correctly, so name something the reply has to say, such as a topic or a name the person provides, not how Siri says it. To check a value that an intent receives or returns, use Calls instead. Use SiriResponse for details that appear only in the reply.

Check a reply on the turn that gives it. A turn accepts a SiriResponse, but the expectation closure of init(_:expectation:) doesn’t, because the reply belongs to a single turn.

The following example shows a turn that expects the reply to name the topic in any capitalization:

UserTurn("In QuizExample, start a science quiz with 5 questions") {
    SiriResponse(.contains("science", caseSensitive: false))
}

Topics
Creating a response expectation
init(SiriResponse.Text...)
Creates an expectation that Siri’s reply satisfies every check.
Matching response text
struct Text
One check on the reply’s text.
Relationships
Conforms To
Decodable
Encodable
Sendable
SendableMetatype
See also
Expectations
struct Calls
An expectation that Siri calls, or doesn’t call, a set of intents during a turn or scenario.
Beta
struct Finds
An expectation that Siri surfaces specific app entities by search or resolution.
Beta
struct Loads
An expectation that Siri loads specific app skills.
Beta
struct OnScreen
An expectation that specific app entities are onscreen.
Beta

Beta Software

This documentation contains preliminary information about an API or technology in development. This information is subject to change, and software implemented according to this documentation should be tested with final operating system software.

Learn more about using Apple's beta software
