export ^

require "point"
require "colors"

class Grid
    new: (@size) =>
        -- point grid:
        -- note that i is horizontal coordinate and j is vertical coordinate
        @points = [ [Point j, i for i=1, @size] for j=1, @size]

        @moveCount = 0
        @timer = 0

    pointsRadius: =>
        wScr! / 40
    pointsMargin: =>
        wScr! / 50

    topLeftCoord: =>
        gridWidth = 2 * @pointsRadius! * @size + @pointsMargin! * (@size - 1)
        gridHeight = 2 * @pointsRadius! * @size + @pointsMargin! * (@size - 1)
        return {wScr! / 2 - gridWidth / 2, hScr! / 2 - gridHeight / 2}

    pointCoordinate: (p) =>
        -- give screen coordinate of point p
        i, j = p.i, p.drawJ
        pointSize = (2 * @pointsRadius! + @pointsMargin!)
        {offX, offY} = @topLeftCoord!
        x = offX + @pointsMargin! + (i - 1) * pointSize
        y = offY + @pointsMargin! + (j - 1) * pointSize
        return {x, y}

    insidePoint: (x, y) =>
        -- return coordinate of a point if x, y is inside this point,
        --    nil otherwise
        -- (Supposes that circles do not intersect, i.e. a coordinate can be
        -- in at most one point)
        for i, col in pairs @points
            for j, point in pairs col
                {xP, yP} = @pointCoordinate point
                dx = xP - x
                dy = yP - y
                dist = math.sqrt dx * dx + dy * dy
                if dist <= @pointsRadius!
                    return @points[i][j]
        return nil


    update: (dt) =>
        @timer += dt
        for i, col in pairs @points
            for j, point in pairs col
                point\update dt

    draw: (highlightColor) =>
        for i, col in pairs @points
            for j, point in pairs col
                {x, y} = @pointCoordinate point
                love.graphics.push!
                love.graphics.translate x, y
                radius = @pointsRadius!
                if point.selected or point.color == highlightColor
                    radius += 5
                point\draw radius
                love.graphics.pop!

    deletePoint: (p) =>
        i = p.i
        for j = p.j, 2, -1
            @points[i][j - 1]\goDown!
            @points[i][j] = @points[i][j - 1]
        @points[i][1] = Point i, 1
