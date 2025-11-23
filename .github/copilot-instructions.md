# Hekili AI Coding Agent Instructions

This guide provides essential context for AI agents working in the Hekili codebase (World of Warcraft addon for combat recommendations). Follow these instructions to maximize productivity and maintain project conventions.

## Architecture Overview
- **Core Logic**: Main files (`Core.lua`, `State.lua`, `Classes.lua`, `Constants.lua`, `Events.lua`, `Targets.lua`, `Utils.lua`) implement the engine for combat analysis, state tracking, and recommendations.
- **UI Layer**: Managed in `UI.lua`, `Options/`, and `MultilineEditor.lua`. Handles configuration, display, and user interaction.
- **Specializations**: Class/spec logic is modularized by expansion (`MistsOfPandaria/`, `Cataclysm/`, `TheBurningCrusade/`, `Wrath/`). Each spec has its own Lua file for priorities and rotations.
- **External Libraries**: Located in `Libs/`. Use `LibStub` for library access (e.g., `LibDeflate`, `LibItemBuffs-1.0`, `LibRangeCheck-3.0`, `LibCustomGlow-1.0`, `LibSpellRange-1.0`).
- **Textures**: UI assets in `Textures/`.

## Developer Workflows
- **Testing**: No automated test runner in root; some libraries (e.g., `LibItemBuffs-1.0/tests/wowmock/`) use LuaUnit and mockagne for isolated tests. For core addon, manual in-game testing is standard.
- **Spec Priorities**: Update rotation logic by editing the relevant spec file (e.g., `MistsOfPandaria/WarriorArms.lua`). Reference `.simc` files in `MistsOfPandaria/Priorities/` for SimulationCraft-based priorities.
- **Importing Priorities**: Use the in-game Hekili config UI to import `.simc` priority lists. These are mapped to Lua logic for recommendations.
- **Library Integration**: Always use `LibStub:GetLibrary("LibName")` for external libraries. Do not require libraries directly unless outside WoW.

## Project Conventions
- **Naming**: Class/spec files use the format `<Class><Spec>.lua` (e.g., `MageFrost.lua`).
- **Expansion Support**: Expansion folders contain only relevant class/spec logic. Do not mix expansions.
- **UI Options**: All configuration logic is in `Options/`.
- **Documentation**: Key documentation in `README.md` (root and some subfolders). For library usage, see each library's README.

## Integration Points
- **SimulationCraft**: `.simc` files in `MistsOfPandaria/Priorities/` are the source of rotation logic. Lua files encode these priorities for the addon engine.
- **WoW API**: Use Blizzard's API for combat, spell, and UI interactions. Mock WoW API for unit tests (C:\Users\fredd\Documents\GitHub\wow-ui-source-mists\Interface\AddOns).
- **Libraries**: Integrate only via `LibStub`. Some libraries (e.g., `LibCustomGlow-1.0`) require additional dependencies (see their README).

## Patterns and Examples
- **Spec Logic Example**: `MistsOfPandaria/MageFrost.lua` encodes Frost Mage rotation. Reference priorities from `MistsOfPandaria/Priorities/MageFrost.simc`.
- **Library Usage Example**:
  ```lua
  local LibDeflate = LibStub:GetLibrary("LibDeflate")
  local compressed = LibDeflate:CompressDeflate(data)
  ```
- **UI Option Example**: Add new config options in `Options/Options.lua`.

## Additional Notes
- **Manual Testing**: Most changes require in-game validation. Use WoW's `/reload` command to refresh the addon.
- **No build system**: Deploy by copying files to the AddOns folder.
- **Do not edit library code unless fixing bugs or updating versions.**

---
For unclear conventions or missing context, ask the user for clarification or examples from recent changes.
