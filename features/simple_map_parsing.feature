Feature: The parser can handle a simple map

  Scenario: Simple Map Parsing
    Given I have the rendered board:
    """
                >-----<
               /~~~~~~~\
              /~~~~~~~~~\
       >-----<~~~~~~~~~~~>-----<
      /~~~~~~~\~~~~~~~~~/~~~~~~~\
     /~~~~~~~~~\~~~~~~~/~~~~~~~~~\
    <~~~~~~~~~~~>-----<~~~~~~~~~~~>
     \~~~~~~~~~/       \~~~~~~~~~/
      \~~~~~~~/   12    \~~~~~~~/
       >-----<  lumber   >-----<
      /~~~~~~~\   HOME  /~~~~~~~\
     /~~~~~~~~~\       /~~~~~~~~~\
    <~~~~~~~~~~~>-----<~~~~~~~~~~~>
     \~~~~~~~~~/~~~~~~~\~~~~~~~~~/
      \~~~~~~~/~~~~~~~~~\~~~~~~~/
       >-----<~~~~~~~~~~~>-----<
              \~~~~~~~~~/
               \~~~~~~~/
                >-----<
    """
    When the map parser parses the board
    Then the board has a terrain count of 1
    And the board has a "forest" terrain at "HOME"
    And the board has a "lumber" resource at "HOME"
    And the board has a 12 chit at "HOME"
