export ^

require "colors"

class Point
    new: (@i, @j, @color=randomColor!, @origin_j = -math.random(1, 3)) =>
        @selected = false
        -- animation is handled by the Grid but the timer is here
        @animation_timer = 0
        @animation_duration = math.random(2, 4) / 10

    adjacent: (otherP) =>
        dx = math.abs(@i - otherP.i)
        dy = math.abs(@j - otherP.j)
        return dx + dy == 1

    update: (dt) =>
        if @animation_timer > @animation_duration
            @animation_timer = @animation_duration
            if @origin_j ~= @j
                @origin_j = @j
        elseif @animation_timer < @animation_duration
            @animation_timer += dt


class Grid
    new: (@size) =>
        @w = love.graphics.getWidth!
        @h = love.graphics.getHeight!
        @pointsRadius = 20
        @pointsMargin = 20
        -- point grid:
        -- note that i is horizontal coordinate and j is vertical coordinate
        @points = [ [Point j, i for i=1, @size] for j=1, @size]
        @selection = {}
        @selecting = false

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
                    return {i, j}
        return {nil, nil}


    update: (dt) =>
        for i, col in pairs @points
            for j, point in pairs col
                point\update dt
        if @selecting
            lastPoint = @selection[#@selection]
            mX, mY = love.mouse.getX!, love.mouse.getY!
            {selectP_X, selectP_Y} = @insidePoint mX, mY
            if selectP_X and selectP_Y
                p = @points[selectP_X][selectP_Y]
                if lastPoint\adjacent(p) and lastPoint.color == p.color
                    if not @inSelection p
                        @select p

    draw: =>
        for i, col in pairs @points
            for j, point in pairs col
                love.graphics.setColor point.color
                {x, y} = @pointCoordinate point
                fillage = if point.selected then "line" else "fill"
                love.graphics.circle(fillage, x, y, @pointsRadius, 2 * @pointsRadius)

        if @selecting
            love.graphics.setColor {255, 255, 255}
            love.graphics.setLineWidth 2
            mX, mY = love.mouse.getX!, love.mouse.getY!
            prev_p = @selection[1]
            for i, p in ipairs @selection
                if i > 1
                    {prev_x, prev_y} = @pointCoordinate prev_p
                    {cur_x, cur_y} = @pointCoordinate p
                    love.graphics.line prev_x, prev_y, cur_x, cur_y
                prev_p = p
            {prev_x, prev_y} = @pointCoordinate prev_p
            love.graphics.line prev_x, prev_y, mX, mY


    select: (p) =>
        table.insert @selection, p
        p.selected = true

    inSelection: (p) =>
        for i, selectP in ipairs @selection
            if p == selectP
                return true
        return false

    clearSelected: =>
        mustDelete = #@selection > 1
        for i, p in ipairs @selection
            if mustDelete
                @deletePoint p
            else
                p.selected = false
            @selection = {}

    deletePoint: (p) =>
        i = p.i
        for j = p.j, 2, -1
            color = @points[i][j - 1].color
            origin = @points[i][j - 1].origin_j
            @points[i][j] = Point i, j, color, origin
        @points[i][1] = Point i, 1

    mousepressed: (x, y, button) =>
        switch button
            when "l"
                {selectP_X, selectP_Y} = @insidePoint(x, y)
                if selectP_X and selectP_Y
                    @selecting = true
                    @select @points[selectP_X][selectP_Y]

    mousereleased: (x, y, button) =>
        switch button
            when "l"
                @selecting = false
                @clearSelected!
