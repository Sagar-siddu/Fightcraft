**FIGHTCRAFT**

Technical Product Requirements Document

A minimal, audio-led boxing training app for focused heavy-bag sessions.

| **Document field**      | **Value**                                                             |
|-------------------------|-----------------------------------------------------------------------|
| Version                 | 1.1 — Android-only personal project scope                             |
| Status                  | Draft for solo personal build                                         |
| Platforms               | Android only (iOS deferred)                                           |
| Primary sport at launch | Boxing                                                                |
| Product principle       | Open app → set rounds and intensity → start training                  |
| Experience direction    | Minimal interface, unmistakable fighting spirit; no unnecessary setup |

**PRODUCT NORTH STAR**

**Get the fighter into the round with as little friction as possible.**

# 1. Executive summary

Fightcraft is an audio-led boxing training app built primarily for heavy-bag work. It combines a configurable round timer with spoken combinations and defensive/footwork instructions. Instead of looking down at a phone between every sequence, the boxer listens, reacts, and keeps working.

The central product decision is simplicity. The primary path must be short: open Fightcraft, choose rounds and intensity, optionally adjust round/rest time, and start. The combination engine, timing, progression, and audio scheduling should handle the complexity behind the scenes.

The MVP focuses on Boxing, Android only (iOS deferred), spoken text-to-speech cues, a curated built-in combination library, user-created combinations, three skill levels, progressive session intensity, saved workouts, and session history (custom combinations, saved workouts and history are P1 in the first build). It should work offline and not require an account.

## 1.1 Product principles

- Training first: the workout start action is the most prominent action in the app.

- Minimal setup: sensible defaults; optional settings should not block a quick start.

- Fight-specific: callouts include punches, defence, head movement, pivots, steps, and directional exits.

- Clear under pressure: short spoken calls, no overlapping speech, no stale commands.

- Progressive, not reckless: intensity can rise without introducing techniques above the selected skill ceiling.

- Offline by default: the core session must not depend on network connectivity.

- No fake intelligence: the MVP selects from a reviewed catalogue; it does not invent unreviewed combinations live.

## 1.2 Project context (v1.1 update)

Fightcraft is now a personal, solo project. This revision narrows the plan to match; the architecture is unchanged, so scope can grow later without a rewrite.

- Platform: Android only for the first build. iOS is deferred. The engine, selector and UI are shared Dart code, so a later port mainly means rebuilding the audio and background adapters, and needs a Mac and an iPhone.

- Priorities: custom combination editing, enable/disable, source selection, saved workouts and local history move from P0 to P1. The first usable build uses the built-in library with the last-used setup.

- Quality gates: coach review, a formal device matrix, store preparation and beta programmes are goals, not release gates. Distribution is by sideloaded APK unless the app is released publicly later.

- Timeline: about 6–9 weeks to a usable version and 9–13 weeks with the P1 extras, at 8–10 hours/week (see Section 16).

# 2. Problem and target user

## 2.1 Problem statement

A boxer training alone on a heavy bag can fall into repetitive sequences, lose track of round timing, or spend too much time deciding what to practise. Fightcraft acts as a lightweight virtual corner: it controls the round structure and calls combinations at a useful pace.

## 2.2 Primary user

- Boxers who already attend a gym and want structured solo bag rounds.

- Beginners who need simple, safe, repeatable combinations.

- Intermediate and advanced users who want defence, movement, and more varied sequences.

- Users who prefer to start training immediately rather than configure a complex workout.

## 2.3 Jobs to be done

- When I approach the bag, help me start a structured session quickly.

- While I am moving and punching, tell me what to do without requiring me to look at the screen.

- As rounds progress, make the work more demanding while staying within my chosen level.

- After training, let me see what I completed and repeat workouts I like.

# 3. Scope and non-goals

| **In MVP**                                         | **Not in MVP**                                          |
|----------------------------------------------------|---------------------------------------------------------|
| Boxing only                                        | Muay Thai, kickboxing, MMA-specific libraries           |
| Configurable rounds, round duration and rest       | Complex workout builders with many nested options       |
| Intensity selection with progression               | AI-generated live combinations                          |
| Built-in and user-created combinations             | Cloud accounts and cross-device sync                    |
| Spoken callouts, bell/countdown sounds and haptics | Voice cloning or paid voice packs                       |
| Saved workout presets and local session history    | Social feed, leaderboards or coach marketplace          |
| Offline-first local storage                        | Punch detection, camera-based form scoring or wearables |

Scope guardrail: do not add a feature to the first-run flow unless it materially improves starting, conducting, or reviewing a training session.

# 4. UX and information architecture

## 4.1 Core navigation

| **Area**            | **Purpose**                                                                    | **MVP priority** |
|---------------------|--------------------------------------------------------------------------------|------------------|
| Home / Start        | Start a session immediately; show last-used setup and quick-start action.      | P0               |
| Session setup       | Set rounds, round duration, rest and intensity; choose skill level if needed.  | P0               |
| Active workout      | Show round/time and provide pause, resume, skip-rest and end controls.         | P0               |
| Combination library | Browse, enable/disable, create and edit combinations.                          | P1               |
| Saved workouts      | Save and reuse a preferred setup.                                              | P1               |
| Session summary     | Review completed rounds and duration. Previous-session history is P1 (FR-020). | P0               |
| Settings            | Speech rate/voice where supported, sounds, haptics and default values.         | P1               |

## 4.2 Home screen requirements

- One dominant action: “Start training” or “Start workout”.

- Display the last-used setup as a compact summary, e.g. “6 rounds · 3:00 rounds · High intensity”.

- Provide a low-friction quick start using the last-used setup.

- Secondary actions may include “Customise”, “Saved workouts” and “Combinations”, but they must not compete visually with Start.

- No mandatory onboarding questionnaire, account creation, goal setup or lengthy tutorial.

## 4.3 Session setup requirements

Expose the smallest useful set of controls. Recommended defaults: 3-minute rounds, 1-minute rest, 3 rounds, Intermediate skill level, Medium intensity. Defaults are configurable in Settings and should remember the last-used values.

| **Control**    | **Behaviour**                                 | **Validation / notes**                                                              |
|----------------|-----------------------------------------------|-------------------------------------------------------------------------------------|
| Rounds         | Stepper or compact picker; default 3.         | MVP range: 1–10 rounds.                                                             |
| Round duration | Preset chips or compact picker; default 3:00. | MVP range: 1–10 minutes.                                                            |
| Rest duration  | Preset chips; default 1:00.                   | Allow 0 rest; recommended range 0–3 minutes.                                        |
| Skill level    | Beginner / Intermediate / Advanced.           | Caps technique complexity; does not mean the user must change it every session.     |
| Intensity      | Low / Medium / High.                          | Controls cue pace, density and progression, not permission to exceed skill level.   |
| Start          | Large, clear primary action.                  | Start after a brief ready countdown; avoid additional confirmation unless required. |

## 4.4 Active workout screen

- Large remaining-time display and clear round indicator (e.g. ROUND 2 / 5).

- Show the current spoken combination in large, glanceable text as a backup to audio.

- Primary controls: Pause/Resume and End. Skip rest appears during rest.

- Do not require interaction to receive the next callout.

- Support screen lock/background operation to the extent permitted by the OS; audio and timer behaviour must be verified on physical devices.

- When paused, freeze workout elapsed time and cancel queued calls. On resume, rebuild the schedule from the current session state.

## 4.5 Rest and completion states

- Rest state clearly shows rest countdown and the next round number; play a distinct round-end and round-start cue.

- Allow the user to skip rest. The next round starts with the normal ready cue and transition sound.

- Session completion shows rounds completed, elapsed work time, total session duration and whether the session was completed or ended early.

- Never label a session “completed” if it was ended early or interrupted before the planned end.

# 5. Functional requirements

| **ID** | **Requirement**           | **Priority** | **Acceptance-level description**                                                                                        |
|--------|---------------------------|--------------|-------------------------------------------------------------------------------------------------------------------------|
| FR-001 | Quick start               | P0           | User can start with last-used settings from Home in one primary action, followed by a short ready countdown.            |
| FR-002 | Configure rounds          | P0           | User can select 1–10 rounds.                                                                                            |
| FR-003 | Configure round length    | P0           | User can select 1–10 minutes per round.                                                                                 |
| FR-004 | Configure rest            | P0           | User can select 0 or more minutes of rest between rounds. No rest follows the final round.                              |
| FR-005 | Session controls          | P0           | Pause, resume, end early and skip rest are available at appropriate times.                                              |
| FR-006 | Accurate timing           | P0           | Timer remains accurate through screen-off/background transitions by using monotonic time rather than counting UI ticks. |
| FR-007 | Transition cues           | P0           | Ready countdown, round start, round end and session complete cues are distinct and configurable.                        |
| FR-008 | Built-in library          | P0           | App ships with reviewed Boxing combinations tagged by level, difficulty and techniques.                                 |
| FR-009 | Create custom combo       | P1           | User can name a combination and construct an ordered sequence from the technique catalogue.                             |
| FR-010 | Edit and duplicate        | P1           | User can edit or duplicate custom combinations without modifying built-in source data.                                  |
| FR-011 | Enable / disable          | P1           | User can include or exclude combinations from selection.                                                                |
| FR-012 | Choose source             | P1           | Workout can use built-in, custom, or both sources. Default is both enabled sources.                                     |
| FR-013 | Spoken callouts           | P0           | App speaks the selected combination using system text-to-speech.                                                        |
| FR-014 | Eligible random selection | P0           | Selector only chooses combinations eligible for the chosen sport, skill level, source and enabled state.                |
| FR-015 | Progression               | P0           | Difficulty and callout density progress according to intensity settings and round position.                             |
| FR-016 | Directional movement      | P0           | Movement is explicitly directional and represented as structured techniques, not inferred from free text.               |
| FR-017 | No overlapping calls      | P0           | Audio scheduler prevents simultaneous spoken combinations and prioritises round transitions.                            |
| FR-018 | Avoid immediate repeats   | P0           | Selector avoids recently called combinations when enough alternatives exist.                                            |
| FR-019 | Saved workouts            | P1           | User can save a named workout setup and load it later.                                                                  |
| FR-020 | Local history             | P1           | Completed and interrupted sessions are stored locally with accurate status.                                             |
| FR-021 | Audio settings            | P1           | User can adjust speech rate/voice where supported and enable/disable sound cues and haptics.                            |
| FR-022 | Search/filter library     | P1           | User can search and filter combinations by level, technique and enabled state.                                          |
| FR-023 | Import/export             | P2           | Allow portable backup/share of custom combinations and workouts.                                                        |
| FR-024 | Cloud sync                | P2           | Only considered after MVP; requires explicit consent and account/security design.                                       |

# 6. Combination data model and technique catalogue

## 6.1 Combination schema

Store combinations as structured data so the selector, display and speech layer use the same source of truth. Do not rely on parsing a free-text label to determine movement direction or difficulty.

| **Field**               | **Type / example**                    | **Purpose**                                                           |
|-------------------------|---------------------------------------|-----------------------------------------------------------------------|
| id                      | UUID/string                           | Stable identifier.                                                    |
| name                    | String: “Jab–cross, slip left, cross” | Readable display name.                                                |
| sport                   | Enum: boxing                          | MVP sport filter.                                                     |
| source                  | Enum: built_in/custom                 | Source selection.                                                     |
| skill_level             | Enum: beginner/intermediate/advanced  | Maximum recommended user level.                                       |
| difficulty              | Integer 1–5                           | Technique/sequence complexity.                                        |
| techniques              | Ordered TechniqueRef\[\]              | Actual sequence of actions, including direction.                      |
| estimated_duration_ms   | Integer                               | Estimate for deciding whether the sequence fits before the next call. |
| is_enabled              | Boolean                               | Whether selection may use it.                                         |
| tags                    | String\[\]                            | Optional searchable tags, e.g. defence, footwork, counter.            |
| created_at / updated_at | Timestamp                             | Local persistence and editing.                                        |

## 6.2 Technique schema

A technique should have a stable ID, a spoken label, a category, optional direction, optional target, and an eligibility/level tag. The spoken phrase can be localised or adjusted without changing the selector logic.

| **Category**        | **Example technique IDs**                                      | **Spoken output examples**  |
|---------------------|----------------------------------------------------------------|-----------------------------|
| Punches             | jab, cross, lead_hook, rear_hook, lead_uppercut, rear_uppercut | “Jab”, “cross”, “lead hook” |
| Slips               | slip_left, slip_right                                          | “Slip left”, “slip right”   |
| Rolls               | roll_left, roll_right                                          | “Roll left”, “roll right”   |
| Pull / lean         | pull_back, lean_back                                           | “Pull back”, “lean back”    |
| Pivots              | pivot_left, pivot_right                                        | “Pivot left”, “pivot right” |
| Steps               | step_forward, step_back, step_left, step_right                 | “Step back”, “step right”   |
| Exits / resets      | exit_left, exit_right, reset_stance                            | “Exit left”, “reset stance” |
| Defence / guard     | high_guard, parry_left, parry_right, block                     | “High guard”, “parry right” |
| Combination actions | double_jab, jab_cross                                          | “Double jab”, “jab, cross”  |

## 6.3 Directionality is a core requirement

Every directional movement must be a distinct technique ID. “Slip left” and “slip right” are different catalogue entries; the system must not randomly append a direction or infer one from a display string. Direction should remain correct in the spoken callout, visible text, logs and custom-combo editor.

Example sequence: jab → cross → slip_left → cross → pivot_right. Display and speech: “Jab, cross, slip left, cross, pivot right.”

## 6.4 Initial catalogue guidelines

- Seed the MVP with enough reviewed combinations to avoid obvious repetition during a normal session; start with about 30 varied combinations across the three skill levels and grow towards 60–100 over time.

- Beginner combinations emphasise stance, straight punches, simple two- or three-action sequences and safe basic movement.

- Intermediate combinations introduce defensive reactions, hooks/uppercuts, directional slips/rolls, pivots and exits.

- Advanced combinations can combine multi-punch sequences, defensive reactions and movement, but must remain physically executable within the cue window.

- Each entry should ideally be reviewed by an experienced boxer or coach; this is a quality goal rather than a release gate.

- Avoid unsafe or ambiguous calls, combinations that require impossible timing, and long sequences that the spoken cue cannot finish before execution should begin.

# 7. Selection, intensity and progression engine

## 7.1 Keep difficulty and intensity separate

Difficulty describes what the boxer must execute. Intensity describes how demanding the session feels through callout frequency, pace, variety and round-to-round progression. High intensity for a beginner must not silently unlock advanced techniques.

| **Intensity** | **Early rounds**                                       | **Middle rounds**                                           | **Final rounds**                                                         |
|---------------|--------------------------------------------------------|-------------------------------------------------------------|--------------------------------------------------------------------------|
| Low           | Comfortable cue spacing; simple eligible combinations. | Steady pace with modest variety.                            | Slight increase in variety, not a sudden speed spike.                    |
| Medium        | Controlled pace and foundational sequences.            | Mix punches with eligible defence/footwork.                 | Higher cue density and broader variety within the skill ceiling.         |
| High          | Begin at a purposeful but manageable pace.             | More frequent calls and more complex eligible combinations. | Highest planned density and variety; preserve time to execute each call. |

## 7.2 Eligibility pipeline

1.  Filter to Boxing combinations.

2.  Filter to enabled sources selected for this workout.

3.  Filter to enabled combinations.

4.  Filter to combinations within the selected skill-level ceiling.

5.  Filter out combinations that cannot reasonably fit the remaining round time.

6.  Prefer entries not called recently; if the pool is too small, permit repeats rather than inventing content.

7.  Select a combination using weighted randomisation appropriate to intensity and round progression.

8.  Schedule speech only after checking transition priority, current playback state and available execution window.

## 7.3 Suggested round progression

Use round position as a progression input, not as a reason to force an arbitrary difficulty jump. A practical starting model is: first third = settle into rhythm; middle third = add variety and defensive movement; final third = highest cue density and variety permitted by the selected level. Tune these thresholds during physical testing.

## 7.4 Anti-repetition behaviour

- Track a recent-call history per session.

- Prefer not to repeat the last 3–5 combinations when the eligible pool is large enough.

- When the eligible pool is small, relax the exclusion window progressively.

- Never generate a random sequence by concatenating arbitrary technique IDs unless that sequence is a reviewed combination.

## 7.5 Timing and execution windows

- Estimate the spoken duration and likely execution time for each combination.

- Do not start a callout if it would collide with a round transition or leave too little time to act on it.

- Reserve the final transition window for the round-end cue; cancel lower-priority pending callouts when needed.

- Intensity changes cue spacing/density but cannot create overlapping speech.

- Record selected and actually spoken callouts separately if useful for debugging and future analytics.

# 8. Audio, haptics and platform behaviour

## 8.1 Audio requirements

- Use native system text-to-speech for MVP; do not require prerecorded voice packs or network calls.

- Speak concise commands with clear pauses between actions when needed.

- Use distinct sound effects for ready countdown, round start, round end, rest and session completion.

- Speech must not overlap itself. Transition sounds may duck or briefly interrupt lower-priority audio according to a documented policy.

- On pause or end, cancel queued callouts and prevent stale speech from playing later.

- If speech fails, continue the timer and show the callout visually; report the limitation without crashing the session.

## 8.2 Audio scheduling priorities

| **Priority** | **Event**                          | **Expected behaviour**                                                                     |
|--------------|------------------------------------|--------------------------------------------------------------------------------------------|
| 1 — highest  | Stop/end session                   | Stop speech and cancel all pending cues immediately.                                       |
| 2            | Round/rest/session transition      | Play the transition cue at the correct boundary; suppress lower-priority speech if needed. |
| 3            | Current combination                | Speak only if enough time remains and no higher-priority event is due.                     |
| 4 — lowest   | Optional nonessential sound/haptic | Drop or defer if it interferes with spoken instructions.                                   |

## 8.3 Haptics

- Use short, distinguishable haptic patterns for round start/end and optional countdown warnings.

- Haptics are supplementary; all important transitions must also be represented visually and/or audibly.

- Provide a setting to disable haptics.

## 8.4 Background and interruption handling

Background execution and speech behaviour vary by Android version and manufacturer. Implement a technical spike early (using an Android foreground service) and validate on a physical Android phone before building the full experience around assumed behaviour.

- The monotonic clock is the source of truth for elapsed session time; UI timer ticks only refresh the display.

- Handle screen lock, app backgrounding, incoming calls, audio-focus loss, Bluetooth headset changes and device volume/mute states.

- On pause, stop scheduling new calls. On resume, recompute time remaining and future call slots; do not replay expired cues.

- If the OS terminates the app, persist enough session state to offer a clear recovery choice on next launch (P1 for the first build). Never silently resume a workout.

- Document platform-specific constraints and test supported behaviour on current target OS versions.

# 9. Workout lifecycle and state machine

| **State**  | **Entry condition**                                                                   | **Allowed transitions / behaviour**                                                           |
|------------|---------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------|
| Setup      | User is configuring or reviewing a workout.                                           | Start → Ready; edit setup or return Home.                                                     |
| Ready      | User presses Start.                                                                   | Short countdown; then Active. End returns to Home without a session if workout never started. |
| Active     | Round timer is running.                                                               | Pause → Paused; round ends → Rest or Complete; End → EndedEarly.                              |
| Paused     | User pauses.                                                                          | Resume → Active/Rest as appropriate; End → EndedEarly. No new callouts.                       |
| Rest       | Work round ended and more rounds remain.                                              | Skip rest or countdown expiry → Ready/Active next round; End → EndedEarly.                    |
| Complete   | All planned rounds and rests are finished.                                            | Persist final summary; open Summary.                                                          |
| EndedEarly | User ends before planned completion or session is interrupted and confirmed as ended. | Persist status and accurate completed-round count; open Summary.                              |

Use explicit state transitions rather than a collection of loosely coordinated booleans. Invalid transitions should be rejected by the workout engine, not merely hidden by the UI.

# 10. Data model and persistence

| **Entity**                | **Key fields**                                                                                                   | **Notes**                                                                          |
|---------------------------|------------------------------------------------------------------------------------------------------------------|------------------------------------------------------------------------------------|
| Technique                 | id, label, category, direction, level, tags                                                                      | Seeded catalogue; IDs remain stable.                                               |
| Combination               | id, name, sport, source, skill_level, difficulty, ordered technique IDs, estimated duration, enabled, timestamps | Built-in entries are read-only at source; users can duplicate into custom entries. |
| WorkoutConfig             | round_count, round_duration, rest_duration, skill_level, intensity, source_selection, audio options              | Validated snapshot for starting a session.                                         |
| SavedWorkout              | id, name, config, created_at, updated_at                                                                         | Stores a reusable setup, not a mutable pointer to all current settings.            |
| Session                   | id, start/end timestamps, config snapshot, status, completed rounds, work duration, rest duration                | Snapshot config so later settings changes do not rewrite history.                  |
| RoundRecord               | session_id, round_number, started_at, ended_at, status                                                           | Supports accurate partial/incomplete session history.                              |
| SessionCallout (optional) | session_id, round_number, combination_id, scheduled_at, spoken_at, status                                        | Useful for QA and future analytics; keep storage modest.                           |
| UserSettings              | defaults, TTS rate/voice, sounds, haptics                                                                        | Local preferences.                                                                 |

## 10.1 Persistence rules

- Use a local relational database such as SQLite for combinations, saved workouts and history.

- Use local preferences for lightweight settings.

- Take a configuration snapshot when a session starts.

- Use database transactions when finalising session and round records.

- Handle migration/versioning from the first release.

- No login or backend is required for the MVP.

# 11. Technical architecture

## 11.1 Recommended stack

| **Layer**            | **Recommendation**                                           | **Rationale / caveat**                                                                                                   |
|----------------------|--------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------|
| Mobile UI            | Flutter / Dart                                               | Single codebase targeting Android now, keeping a later iOS port possible. Verify native audio and lifecycle needs early. |
| State management     | Riverpod or equivalent explicit state layer                  | Testable session state and separation from widgets.                                                                      |
| Workout engine       | Pure Dart domain service                                     | Owns state machine, timing calculations and transitions.                                                                 |
| Combination selector | Pure Dart service                                            | Deterministic, unit-testable eligibility and selection rules.                                                            |
| Audio adapter        | Flutter TTS plus native/platform audio integration as needed | System TTS for spoken combinations; sounds and audio focus may need platform-specific handling.                          |
| Local persistence    | SQLite via a maintained Flutter package                      | Structured local data and history.                                                                                       |
| Preferences          | Local key-value storage                                      | Small user settings and defaults.                                                                                        |
| Backend              | None in MVP                                                  | Offline-first and lower implementation/operational complexity.                                                           |

## 11.2 Logical component architecture

```
Flutter UI (Home / Setup / Active Workout / Library / History)
↓ user actions / rendered state
Application state & session controller
├── Workout engine (state machine + monotonic timing)
├── Combination selector (eligibility + progression)
├── Audio scheduler (priority queue + cue windows)
└── Repository interfaces
├── SQLite repositories (combos, workouts, sessions)
├── TTS / sound / haptic adapters
└── Platform lifecycle & audio-focus adapters
```

## 11.3 Suggested project structure

```
lib/
  app/ # app bootstrap, routing, theme
  core/models/ # domain models and enums
  core/storage/ # database, migrations, preferences
  core/audio/ # TTS, sound playback, audio scheduler
  core/platform/ # lifecycle, audio focus, haptics
  features/home/
  features/session_setup/
  features/workout/ # workout_engine, session_controller, state
  features/combinations/ # library, selector, technique catalogue
  features/saved_workouts/
  features/history/
  features/settings/
  data/repositories/
  test/
    unit/ # timer, state machine, selector, scheduler
    widget/ # setup, workout, library screens
    integration/ # lifecycle and end-to-end flows
```

## 11.4 Timing implementation

Do not decrement a counter once per second and assume that it remains accurate. Store the round start monotonic timestamp and calculate remaining time as configured duration minus elapsed monotonic time. Reconcile the UI and scheduler after lifecycle changes. Wall-clock timestamps may be stored for history, but must not drive live countdown correctness.

# 12. Safety, privacy and accessibility

- No microphone, contacts or location permissions are required for the MVP.

- Keep session data on device by default and explain any future cloud feature before enabling it.

- Use clear, high-contrast typography and large controls usable with sweaty hands and quick glances.

- Do not make audio the only representation of state: show current callout, round, time and pause state visually.

- Provide a clear End action; prevent accidental termination with a lightweight confirmation if usability testing supports it.

- Combination content should be reviewed for sensible sequencing and should not imply that users should ignore pain, dizziness or injury.

- The app is a training aid, not a substitute for coaching or medical advice.

# 13. Edge cases and required behaviour

| **Scenario**                               | **Required behaviour**                                                                                                 |
|--------------------------------------------|------------------------------------------------------------------------------------------------------------------------|
| No eligible combinations                   | Block workout start or offer a clear path to enable/add combinations; never start silently with an empty selector.     |
| Too few eligible combinations              | Relax recent-repeat avoidance gradually; do not fabricate combinations.                                                |
| Custom combination edited during a workout | The active session uses its start-time snapshot or stable combination IDs; edits must not corrupt the running session. |
| Pause while speech is playing              | Stop or finish current speech according to platform capability; cancel queued cues and prevent stale calls on resume.  |
| End session                                | Stop timer/audio/haptics, persist accurate status and navigate to summary.                                             |
| Skip rest                                  | Transition cleanly into the next round without double-starting timers or audio.                                        |
| Incoming call / audio-focus loss           | Preserve timer correctness; apply documented audio policy and show state clearly.                                      |
| Screen locked / app backgrounded           | Maintain supported timing/audio behaviour and test against platform restrictions.                                      |
| TTS unavailable or errors                  | Keep workout timer functional; display callout and log/report the audio failure.                                       |
| App killed by OS                           | On relaunch, show recovery/discard options; do not silently restart.                                                   |
| Device muted / low media volume            | Do not claim speech is audible; visual callout remains available.                                                      |
| Duplicate combination names                | Allow duplicates or warn clearly; use stable IDs internally.                                                           |
| Storage failure                            | Avoid crashing; show an error and preserve session state where possible.                                               |
| Round ends while a callout is queued       | Round transition wins; cancel stale queued speech.                                                                     |

# 14. Non-functional requirements

| **Area**        | **Requirement**                                                                                                                |
|-----------------|--------------------------------------------------------------------------------------------------------------------------------|
| Performance     | Home and setup should feel immediate; library and history should remain responsive with hundreds of combinations and sessions. |
| Timing accuracy | No cumulative drift from repeated UI ticks; use monotonic time and reconcile on resume.                                        |
| Reliability     | No duplicate round transitions, double timers, or stale queued callouts after pause/end.                                       |
| Offline         | All core workouts, seeded combinations, custom combinations and history function without network.                              |
| Maintainability | Domain logic isolated from widgets and platform-specific adapters.                                                             |
| Testability     | Timer, state machine, selector and audio scheduling rules can be tested without physical audio hardware.                       |
| Compatibility   | Support a declared minimum OS range selected during project setup and verify physical-device behaviour.                        |
| Accessibility   | Readable contrast, scalable text where feasible, large touch targets and visual backup for spoken cues.                        |

# 15. Testing strategy and release gates

## 15.1 Unit tests

- Timer calculations across pause/resume, app background/foreground and delayed UI refresh.

- State machine transitions, including zero-rest rounds, skip-rest, end-early and final-round completion.

- Selector eligibility by source, skill level, enabled state, difficulty and remaining time.

- Directionality preservation from technique ID through display and spoken text.

- Anti-repeat behaviour when the pool is large, small or empty.

- Audio scheduler priority, cancellation, execution windows and transition conflicts.

- Persistence snapshots, session status and interrupted-round accounting.

## 15.2 Device and integration tests

- Android physical-device tests with screen on, screen locked and app backgrounded.

- Incoming phone call, Bluetooth headset connect/disconnect, audio-focus changes and media volume/mute.

- Long session test to detect drift and duplicate transitions.

- Pause/end while speech is active; skip rest at the countdown boundary.

- Storage migration and recovery after force-close or OS termination.

- Real bag-session usability test with beginner and experienced boxers; validate that calls are audible, short and executable.

## 15.3 Release gates

- A user can go from launch to a running session with minimal interaction.

- Round and rest transitions remain accurate during supported background/locked-screen use.

- No overlapping or stale spoken callouts in the defined test suite.

- Directional movement calls are correct and unambiguous.

- Each skill level has enough combinations for realistic use, sanity-checked by an experienced boxer where possible.

- An interrupted or ended-early session is recorded honestly.

- No known critical crash or data-loss defect remains.

# 16. Delivery roadmap and estimates

Estimates assume a solo developer working part-time (about 8–10 hours/week) on Android only, and include implementation plus basic testing. Actual timing depends on platform audio/background constraints and the developer’s Flutter experience.

| **Phase**                     | **Deliverable**                                                                                                                  | **Estimate**                 |
|-------------------------------|----------------------------------------------------------------------------------------------------------------------------------|------------------------------|
| 0\. Setup and technical spike | Toolchain set up; locked-screen timer speaking cues on a physical Android phone (foreground service, TTS, audio focus, haptics). | 1–2 weekends                 |
| 1\. Workout engine            | State machine, monotonic timer, rounds/rests, pause/resume/end and transition sounds, with unit tests.                           | 1–2 weeks                    |
| 2\. Combination system        | Technique catalogue, about 30 built-in combinations (JSON), eligibility, anti-repeat and weighted random selection.              | 1–2 weeks                    |
| 3\. Audio and progression     | Speech scheduler (no overlaps), directional cues and intensity progression by round position.                                    | 1–2 weeks                    |
| 4\. Core screens              | Home with quick start, session setup, active workout and summary.                                                                | 1–2 weeks                    |
| 5\. Extras (P1)               | Custom combination editor, saved workouts, history, settings and recovery after OS kill.                                         | 2–3 weeks                    |
| 6\. Real-bag testing          | Tune cue spacing in real sessions, fix bugs, sideload the APK.                                                                   | 1–2 weeks (overlaps phase 5) |

Planning total: about 6–9 weeks to a usable version (phases 0–4) and 9–13 weeks including the P1 extras at around 8–10 hours/week. The Phase 0 spike is a go/no-go checkpoint; if background speech or timing needs native work, adjust the architecture before investing in the full UI.

# 17. Risks and mitigations

| **Risk**                             | **Impact**                                         | **Mitigation**                                                                                                    |
|--------------------------------------|----------------------------------------------------|-------------------------------------------------------------------------------------------------------------------|
| Background audio varies by OS/device | Core experience may fail when screen locks.        | Prototype first; test physical devices; document supported behaviour and use platform-specific code where needed. |
| Callouts too frequent or too long    | User cannot execute sequences before the next cue. | Measure spoken duration, enforce cue windows, test with real bag rounds and tune intensity.                       |
| Repetitive combinations              | Session feels random in a bad way.                 | Curate a sufficiently broad library and track recent selections.                                                  |
| Directional ambiguity                | Wrong movement is called or displayed.             | Structured technique IDs; direction included in tests, UI, speech and seed-data review.                           |
| Scope creep                          | MVP takes too long and core flow gets buried.      | Keep Boxing-only, offline-first and one-tap quick start; defer social, AI and cloud features.                     |
| Weak seed content                    | Technically correct app feels like a poor coach.   | Coach review, real-session testing and catalogue-quality gates.                                                   |
| Timer drift / duplicate events       | Workout timing becomes untrustworthy.              | Monotonic clock, explicit state machine, idempotent transitions and lifecycle tests.                              |

# 18. MVP acceptance criteria

- The user can open Fightcraft, accept last-used settings and begin a workout without navigating through multiple setup screens.

- The user can configure rounds, round duration, rest duration, skill level and intensity.

- The app plays distinct ready, round, rest and completion cues.

- Spoken callouts come from enabled built-in and/or custom combinations according to the selected source setting.

- Callouts include correct directional techniques such as slip left/right, roll left/right, pivot left/right and step back/forward/left/right.

- The selector avoids immediate repeats where possible and never invents an unreviewed combination.

- Difficulty remains within the selected skill level while intensity progresses across the session.

- Speech never overlaps with itself; pause/end cancels queued calls.

- (P1) Saved workouts can be reused and local session history accurately distinguishes completed from incomplete sessions.

- Core functionality works offline without account creation.

- Supported screen-lock/background behaviour is documented and verified on a physical Android device.

# 19. Recommended implementation order

1. Build the audio/background technical spike before committing to the full architecture.
2. Finalise the technique schema and seed combination format.
3. Implement and unit-test the workout state machine and monotonic timer.
4. Implement the selector, eligibility rules, directionality and anti-repeat logic.
5. Integrate TTS/audio scheduling and test call timing in real bag rounds.
6. Build the minimal Home, Setup and Active Workout screens around the working engine.
7. Add library editing, saved workouts, history and settings.
8. Test on real bag sessions, fix edge cases, and sideload the APK for personal use (optionally share with friends).

# Appendix A. Example combination records

Illustrative schema examples; these are format examples and should be reviewed before becoming production seed data.

| **ID**         | **Level / difficulty** | **Ordered techniques**                                  | **Spoken output**                                      |
|----------------|------------------------|---------------------------------------------------------|--------------------------------------------------------|
| boxing_beg_001 | Beginner / 1           | jab → cross                                             | “Jab, cross.”                                          |
| boxing_int_014 | Intermediate / 3       | jab → cross → slip_left → cross                         | “Jab, cross, slip left, cross.”                        |
| boxing_int_021 | Intermediate / 3       | jab → cross → roll_right → pivot_left                   | “Jab, cross, roll right, pivot left.”                  |
| boxing_adv_008 | Advanced / 5           | double_jab → cross → pull_back → rear_hook → exit_right | “Double jab, cross, pull back, rear hook, exit right.” |

# Appendix B. Product decisions to lock before implementation

| **Decision** | **Recommended default**            | **When to revisit**                                                                                                                                                                                          |
|--------------|------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Name         | Fightcraft                         | Only if released publicly: app-store, domain and trademark checks.                                                                                                                                           |
| Launch sport | Boxing                             | After MVP usage validates the core engine.                                                                                                                                                                   |
| Platforms    | Android only for now               | Add iOS only if there is demand and access to a Mac and iPhone; engine and UI are shared Dart code, so mainly the audio and background adapters need rework. Confirm minimum Android version during Phase 0. |
| Spoken voice | System TTS                         | If real-world intelligibility is poor, evaluate optional recorded cues later.                                                                                                                                |
| Intensity    | Low / Medium / High                | Tune cue frequency through user testing.                                                                                                                                                                     |
| Skill levels | Beginner / Intermediate / Advanced | Review catalogue boundaries with a coach.                                                                                                                                                                    |
| Persistence  | Local-only                         | Cloud sync only with a clear product case and explicit consent.                                                                                                                                              |
| Quick start  | Last-used setup                    | Keep this the primary route unless usability testing shows confusion.                                                                                                                                        |

# Appendix C. Development environment (Android-only)

Target machine: Lenovo IdeaPad 3 running Windows. Testing on a real Android phone replaces the emulator.

- Laptop: Windows 10/11 (64-bit), 8 GB RAM minimum (16 GB comfortable), 40 GB or more of free SSD space.

- Android phone with USB debugging enabled, as the primary test device. The emulator is a poor test for TTS, audio focus and background behaviour.

- Bluetooth earbuds, for headset connect/disconnect testing.

- Software: Flutter SDK (stable channel, includes Dart); Android Studio (Android SDK, platform tools, command-line tools, bundled JDK); VS Code with the Flutter and Dart extensions; Git and a GitHub account.

- Packages (confirm current maintained versions at project start): flutter_tts; audioplayers or just_audio with audio_session; a foreground-service or wake-lock plugin (decided by the spike, may need small native Kotlin code); drift or sqflite; shared_preferences; Riverpod (plain setState is fine initially); a haptics plugin; flutter_test, mocktail and integration_test.

- Optional: DB Browser for SQLite; Figma (free) for UI mock-ups.

- Setup check: run flutter doctor until the Android toolchain is green (the Xcode warning is expected on Windows), then flutter create and flutter run on the phone.
