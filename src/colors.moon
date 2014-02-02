export randomColor, lighter, darker

colors = {
    {180, 82, 205} -- mediumorchid 3 (purple)
    {0, 201, 87} -- emeraldgreen
    {255, 106, 105} -- indianred
    {255, 193, 37} -- goldenrod 1 (yellow)
    {0, 255, 255} -- cyan/aqua
    {28, 134, 238} -- dogerblue 2 (dark blue)
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
