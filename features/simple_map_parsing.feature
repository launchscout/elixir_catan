Feature: The parser can handle a simple map
  Scenario: Simple Map Parsing
    When the map parser parses a rendered board that looks like:
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
    Then the board has a terrain count of 1
    And the board has a "forest" terrain at "HOME"
    And the board has a "lumber" resource at "HOME"
    And the board has a 12 chit at "HOME"
