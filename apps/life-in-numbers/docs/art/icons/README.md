# Memory icons

Midjourney watercolor icon squares (1:1, single subject on cream paper), the
source art for the memory icons. Each is cropped/resized into the asset
catalog as `MemoryIcon-<name>` and drawn in the memory editor, the diary
list, and the life grid itself.

| File            | Subject            | Used for            |
|-----------------|--------------------|---------------------|
| `sun.png`       | a small sun        | Born / bright days  |
| `walk.png`      | walking shoes      | First steps         |
| `backpack.png`  | a child's backpack | Started school      |
| `gradcap.png`   | a graduation cap   | Graduated           |
| `heart.png`     | a heart            | First crush / love  |
| `briefcase.png` | a leather briefcase| First job           |
| `house.png`     | a cottage house    | Moved home          |
| `plane.png`     | a paper airplane   | A big trip          |
| `music.png`     | a music note       | Music memories      |
| `paw.png`       | a dog paw print    | New pet             |
| `trophy.png`    | a small trophy     | Proud moment        |
| `gift.png`      | a wrapped gift     | Celebrations (source art still wanted here) |

To add or replace one: drop the square PNG here under the name above, then
update the matching `MemoryIcon-*.imageset` in
`LifeInNumbers/LifeInNumbers/Assets.xcassets` and the map in
`Views/MemoryIconView.swift` if it's a brand-new icon.
