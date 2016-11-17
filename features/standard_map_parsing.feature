Feature: The parser can handle a simple map
  Background:
    Given I have the rendered board:
    """
                                  >-----<
                                 /~~~~~~~\
                                /~~~~~~~~~\
                         >-----<~~~~~~~~~~~>-----<
                        /~~~~~~~\~~~~~~~~~/~~~~~~~\
                       /~~~~~~~~~\~~333~~/~~~~~~~~~\
                >-----<~~~~~~~~~~~>-----<~~~~~~~~~~~>-----<
               /~~~~~~~\~~~~~~~~~/       \~~~~~~~~~/~~~~~~~\
              /~~~~~~~~~\~~~~~~~/    8    \~~~~~~~/~~~~~~~~~\
       >-----<~~~~~~~~~~~>-----<  lumber   >-----<~~~~~~~~~~~>-----<
      /~~~~~~~\~~~~~~~~l/       \         /       \w~~~~~~~~/~~~~~~~\
     /~~~~~~~~~\~~~~~~l/   11    \       /    4    \w~~~~~~/~~~~~~~~~\
    <~~~~~~~~~~~>-----<   brick   >-----<   brick   >-----<~~~~~~~~~~~>
     \~~~~~~~~~/       \         /       \         /       \~~~~~~~~~/
      \~~~~~~~/    3    \       /    9    \       /    9    \~~~~~~~/
       >-----<   grain   >-----<  lumber   >-----<    ore    >-----<
      /~~~~~~~\     NW  /       \         /       \         /~~~~~~~\
     /~~~~~~~~~\       /    8    \       /     R   \       /~~~~~~~~~\
    <~~~~~~~~~~~>-----<   wool    >-----<  desert   >-----<~~~~~~~~~~~>
     \~~~~~~~~b/       \         /       \  BURGL  /       \o~~~~~~~~/
      \~~~~~~b/   10    \       /    6    \       /   10    \o~~~~~~/
       >-----<  lumber   >-----<   brick   >-----<   wool    >-----<
      /~~~~~~~\         /       \   HOME  /       \         /~~~~~~~\
     /~~~~~~~~~\       /   12    \       /    2    \       /~~~~~~~~~\
    <~~~~~~~~~~~>-----R   grain   >-----<    ore    >-----<~~~~~~~~~~~>
     \~~WATER~~/       \    RED  /       \         /       \~~~~~~~~~/
      \~~~~~~~/    6    \       /    4    \       /   12    \~~~~~~~/
       >-----<   grain   >-----<   wool   WW-----<   brick   >-----<
      /~~~~~~3\         /       \  WHITE  /       \   PORT  r3~~~~~~\
     /~~~~~~~~3\       /   11    \       /    5    \       r3~~~~~~~~\
    <~~~~~~~~~~~>-----<  lumber   >-----<   grain   >-----<~~~~~~~~~~~>
     \~~~~~~~~~/~~~~~~~\         /       \         /~~~~~~~\~~~~~~~~~/
      \~~~~~~~/~~~~~~~~~\       /    5    \       /~~~~~~~~~\~~~~~~~/
       >-----<~~~~~~~~~~~>-----<   wool    >-----<~~~~~~~~~~~>-----<
              \~~~~~~~~~/~~333~~\         /~~ggg~~\~~~~~~~~~/
               \~~~~~~~/~~~~~~~~~\       /~~~~~~~~~\~~~~~~~/
                >-----<~~~~~~~~~~~>-----<~~~~~~~~~~~>-----<
                       \~~~~~~~~~/~~~~~~~\~~~~~~~~~/
                        \~~~~~~~/~~~~~~~~~\~~~~~~~/
                         >-----<~~~~~~~~~~~>-----<
                                \~~~~~~~~~/
                                 \~~~~~~~/
                                  >-----<
    """

  Scenario: Correctly parsing the correct number of tiles
    When the map parser parses the board
    Then the board has a terrain count of 19
    
  Scenario: Parsing resources and terrains
    When the map parser parses the board
    Then the board has a "hills" terrain at "HOME"
    And the board has a "brick" resource at "HOME"
    And the board has a "fields" terrain at "NW"
    And the board has a "grain" resource at "NW"
    
  Scenario: Parsing the chit value
    When the map parser parses the board
    Then the board has a 6 chit at "HOME"
    
  Scenario: Parsing the robber
    When the map parser parses the board
    Then the board has a robber at "BURGL"
    
  Scenario: Parsing water tiles
    When the map parser parses the board
    Then the board has a "water" terrain at "WATER"
    And the board has no resource at "WATER"
    
  Scenario: Parsing harbors
    When the map parser parses the board
    Then the board has a harbor at the "SE" edge of "PORT"

  Scenario: Parsing roads
    When the map parser parses the board
    Then the "red" player has a road at the "SE" edge of "PORT"

  Scenario: Parsing Settlements
    When the map parser parses the board
    Then the "red" player has a settlement at the "left" side of "RED"
    
  Scenario: Parsing Cities
    When the map parser parses the board
    Then the "white" player has a city at the "right" side of "WHITE"
