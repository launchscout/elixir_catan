# Catan

## Maps, Hexes, and Tiles, oh my!

### Glossary

* Hex: The logical structure of a single hexagon. The board is made up of a pattern of these
* Tile: The "face" of the hexagon. The face contains the things that sit on top of the hexagon's inner space. This includes the terrain/resource type, the chit, and possibly the robber
* Edge: a single edge of a hexagon, which can contain a road or harbor
* Vertex: a single point representing the point at which three edges meet. A vertex can contain a settlement or city
* Flat top: The layout of the board (as opposed to "pointy top"). We are using flat top because it is easier to lay out an ascii board in flat top orientation.

### Hexes and Tiles

#### In order to have a unique address for every point on the board, each hex "owns" a pair of vertices and the hex's southern edges. The other vertices and edges are owned by adjacent hexagons on the board. See the following ascii illustration for naming conventions:

```
             >-----<
            /~~~~~~~\
           /~~~2:1~~~\
 :left    <~~~brick~~~> :right
           \~~~~~~~~~/
     :sw    \~~~~~~*/   :se
             >-----<
               :s
```

### References (these are important!)

* http://www.redblobgames.com/grids/hexagons/
* www.catan.com/files/downloads/catan_5th_ed_rules_eng_150303.pdf
