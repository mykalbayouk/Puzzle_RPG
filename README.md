# Puzzle Based Top-Down RPG

This is a project that I am working on to learn more about Game Development. The goal of this project is to create a top-down RPG that is puzzle based. The player will have to solve puzzles in dungeons in order to progress through the game. The game will have a leveling system and a health system. The player will be able to attack enemies in order to gain experience and level up. The player will also be able to interact with objects in the world in order to solve puzzles.


# Demo Video
[Mini Youtube Demo](https://youtu.be/H85N1oCvjR0)


# TODO
- [X] Adjust Mana Bar to different design
- [X] Create Leveling System
- [X] Create Health System
- [ ] Finish Map Design
- [ ] Create Dialogue System
- [ ] Design 3 other Dungeons and give Mechs to main dung
- [ ] Create a Boss Dungeon

# Current Bugs
- [X] Loading into a new level causes the player to not load into the new level
- [X] Diagonal Collisions have teleportation issues
- [X] Enemies Movement is janky
- [ ] Enemies can occasionally move through walls
- [X] When exiting dungeon, player is still "in dungeon":
    correct level is displayed but the object layers are still from prior level.
    -- fix to this is just rebuilding the level each time which right now seems like the right design choice since when you enter a room enemies will respawn and the room will be reset.