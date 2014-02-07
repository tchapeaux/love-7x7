export ^

require "point"
require "colors"

class Grid
    new: (@size) =>
        @w = love.graphics.getWidth!
        @h = love.graphics.getHeight!
        @pointsRadius = 20
        @pointsMargin = 20
        -- point grid:
        -- note that i is horizontal coordinate and j is vertical coordinate
        @points = [ [Point j, i for i=1, @size] for j=1, @size]

        @moveCount = 0
        @timer = 0

    topLeftCoord: =>
        gridWidth = 2 * @pointsRadius * @size + @pointsMargin * (@size - 1)
        gridHeight = 2 * @pointsRadius * @size + @pointsMargin * (@size - 1)
        return {@w / 2 - gridWidth / 2, @h / 2 - gridHeight / 2}

    pointCoordinate: (p) =>
        -- give screen coordinate of point p
        i, j = p.i, p.j
        pointSize = (2 * @pointsRadius + @pointsMargin)
        {offX, offY} = @topLeftCoord!
        x = offX + @pointsMargin + (i - 1) * pointSize
        y = offY + @pointsMargin + (j - 1) * pointSize
        orig_y = offY + @pointsMargin + (p.origin_j - 1) * pointSize
        -- animation
        animation_scale = p.animation_timer / p.animation_duration
        y = orig_y + animation_scale * (y - orig_y)
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
                if dist <= @pointsRadius
                    return @points[i][j]
        return nil


    update: (dt) =>
        @timer += dt
        for i, col in pairs @points
            for j, point in pairs col
                point\update dt

    draw: =>
        @drawPoints!

    drawPoints: =>
        for i, col in pairs @points
            for j, point in pairs col
                {x, y} = @pointCoordinate point
                love.graphics.push!
                love.graphics.translate x, y
                radius = @pointsRadius
                if point.selected or (@selectionLoopPoint and point.color == @selectionLoopPoint.color)
                    radius += 5
                point\draw radius
                love.graphics.pop!

    deletePoint: (p) =>
        i = p.i
        for j = p.j, 2, -1
            @points[i][j - 1]\goDown!
            @points[i][j] = @points[i][j - 1]
        @points[i][1] = Point i, 1
