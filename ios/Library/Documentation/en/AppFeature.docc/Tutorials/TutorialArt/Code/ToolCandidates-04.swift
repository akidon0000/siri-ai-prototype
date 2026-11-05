import AppIntents

// ○ Make a tool: can be asked for in one sentence that fills in the parameters
// "Make the milk memo high priority" has both memo and priority in one sentence
@AppIntent(.tool)
struct SetMemoPriorityIntent: AppIntent { /* built in the next section */ }

// × Don't: intents that follow a Siri-enabled schema are already exposed to Siri
// Writing @AppIntent(.tool, schema: .reminders.createReminder) is a build error
@AppIntent(schema: .reminders.createReminder)
struct CreateMemoIntent { /* chapter 5 */ }

// × Don't: widget configuration intents, which have no action to perform
// (a WidgetConfigurationIntent can be a tool if its perform() does an action of its own)
struct SelectMemoListIntent: WidgetConfigurationIntent { /* … */ }
// × Don't: intents that only make sense as one step inside a shortcut
// × Don't: intents with side effects a person should start explicitly, like ordering or paying

// ○ Make a tool: "find memos by conditions", which has no schema
@AppIntent(.tool)
struct FindMemosIntent: AppIntent { /* built in a later section */ }
