# KindegartenHell

A 2D puzzle game made in the Godot Engine. You play as a teacher tasked with guiding a group of unpredictable children into the school. Each time you move, they react, but each child behaves differently, turning every level into a unique logic challenge. This prototype was created for a presentation and includes HTML5 export with gamepad support, making it playable on Android devices. Note: this is an earlier version of the game.
On e of the main challenges during development was handling collisions between the children. Since the game uses a tilemap system and each character moves tile by tile, managing their unique movement patterns became quite complex. Every child follows its own logic to determine whether it can move to a certain tile or not.
At times, multiple characters would attempt to move into the same tile simultaneously. To solve this, I implemented a hierarchy system, for example, the green child, who moves normally, always has priority over the other ones, like blue one, which moves in the opposite direction. If both tried to enter the same tile, the blue child would be pushed aside.
Interestingly, this technical limitation evolved into a gameplay mechanic, becoming an intentional part of the puzzle design.


Play a demo:
https://wtvlucas.github.io/PUTOSINHELL
