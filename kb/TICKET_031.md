# TICKET-031: High Score Tracker

## Summary
Implemented `src/highscore.lua`, an in-memory high score tracker that records and returns the top 5 scores in descending order.

## API
```lua
local HighScore = require("src.highscore")

HighScore.record(score)       -- records explicit score, or Score.get() when nil; returns top scores copy
HighScore.recordCurrent()     -- records Score.get(); returns top scores copy
HighScore.get()               -- returns a copy of current top scores
HighScore.clear()             -- clears tracked scores; returns empty table
HighScore.isHighScore(score)  -- true when score would enter current top 5
```

## Integration
Uses the TICKET-030 score module API:
```lua
local Score = require("src.score")
Score.get()
```

Included `src/score.lua` from TICKET-030 so this branch is smoke-testable standalone.

## Validation
Ran a Lua smoke test covering current-score recording, sorting, top-5 truncation, defensive copies, and high-score qualification.
