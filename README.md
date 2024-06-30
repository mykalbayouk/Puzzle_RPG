# puzzle_rpg

# Task
- [ ] Figma Create HP Bar (increments of 10 hp = 1 tick)
- [ ] Figma Create XP Bar (increments of 10 xp = 1 tick)

# Current Bugs
- [X] Loading into a new level causes the player to not load into the new level
- [X] Diagonal Collisions have teleportation issues
- [X] Enemies Movement is janky
- [ ] Enemies can move through walls
- [X] When exiting dungeon, player is still "in dungeon":
    correct level is displayed but the object layers are still from prior level.
    -- fix to this is just rebuilding the level each time which right now seems like the right design choice since when you enter a room enemies will respawn and the room will be reset.