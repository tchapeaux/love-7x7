export randomColor, lighter, darker

colors = {
    {255, 0, 0}
    {0, 0, 255}
    {0, 255, 0}
    {0, 255, 255}
    {255, 0, 255}
    {255, 255, 0}
}

randomColor = ->
    return colors[math.random #colors]

lighter = (color) ->
    {r, g, b} = color
    r = r + (255 - r) / 2
    g = g + (255 - g) / 2
    b = b + (255 - b) / 2
    return {r, g, b}

darker = (color) ->
    {r, g, b} = color
    return {r / 2, g / 2, b / 2}
