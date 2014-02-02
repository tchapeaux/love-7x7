export randomColor

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

