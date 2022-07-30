# Between Worlds

## Description

Between Worlds: Path to Graduation is a side scrolling shooter based on the journey of a
Informatics engineering student through their academic path up until their graduation.
Throughout the game, the player will face several challenges, from aggressive programming
languages, to serial ports pumping out deadly data. To face their challenges, the player
character is equipped with mouse cursors and Visual Studio Code grenades to dispatch
enemies, and a dimension shifting power, which is the main focus of the gameplay.
The player is able to seamlessly switch between two versions of the same level, being able
to interact with obstacles, enemies, and entire portions of the level by shifting dimensions.

![Snapshot](https://user-images.githubusercontent.com/45019363/182001892-30f8168e-f02b-4dd5-b838-3943b16328ae.png)

## Playing instructions

### Objective

The objective of the game is to grab the diploma at the end of the level without dying. For
that, the player needs to avoid obstacles, kill or avoid enemies and use his dimension
shifting powers and skill to traverse the level. Power ups can be collected to help the player
in it’s journey. If the player dies three times, the main menu shows up.

### Controls

* Go left - Left Arrow or A
* Go right - Right Arrow or D
* Jump - Up Arrow or W
* Shoot - Z or Left Mouse Button
* Change Dimension - C or Right Mouse Button
* Sprint - X or Shift (both right or left shift work, but we recommend using the left one)
* Leave to the main menu - Esc while playing
* Leave the game - Esc while in the main menu

### Dimension shifting

The player is in a world with two parallel dimensions. Enemies and obstacles from one
dimension cannot be seen or interacted with from the other, but their shadows are still
visible.

### Shooting

The player has access to 2 types of bullets. Each bullet only works in their respective dimension:

In the first dimension, the player shoots **Mouse Cursors** that travel in a straight line until they collide with enemies, terrain or after a certain distance traveled.

In the second dimension, he throws **Visual Studio Code grenades** that travel in a parabolic trajectory, exploding upon contact with an enemy or terrain. The blast deals a high amount of damage.

Enemies drop ammo when killed. Enemies from the first dimension always drop ammo for the second dimension and vice-versa.

### Power Ups

**Coffee:** This power up completely fills the player focus bar and allows him to stay in the second dimension for 4 seconds without using focus. Collecting this power up gives 100 points.


**Stack Overflow:** This power up gives a shield to the player, blocking all incoming damage for 4 seconds, except damage from spikes and shifting inside the wall. When collected, this power up also gives 100 points.

### Enemies

**C++:** This enemy walks back and forth, changing direction when it collides with a wall or the player. When it collides with the player, it also deals damage to him. This enemy gives 200 points when killed and drops 10 Visual Studio Code grenades.

**Python:** This enemy is stationary, often positioned in elevated platforms. It shoots bugs at the player, damaging him. If the player collides with this enemy, the player also loses health. When killed, it also gives 200 points and drops 10 Mouse Cursors.

### Obstacles
**Byte Stream:** This obstacle is made up of the top part of a serial port, that creates data bytes at a set interval that descend with constant speed until they disappear inside the bottom part of the serial port. Every data byte deals a bit of damage to the player upon contact.

**Spikes:** This obstacle instantly kills the player upon contact, even if the player has a shield. It is usually at the bottom of pitfalls.

## Credits
### Authors
Bruno Filipe Cardoso Micaelo
João Ricardo Ribeiro Cardoso

### Assets
Tilemap and character sprite - https://szadiart.itch.io/pixel-platformer-castle

Sound effects and background music - https://opengameart.org/
