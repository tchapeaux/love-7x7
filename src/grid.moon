export ^

require "colors"

class Point
    new: (@i, @j, @color=randomColor!, @origin_j = -3) =>
        @selected = false
        -- animation is handled by the Grid but the timer is here
        @animation_timer = 0
        @animation_duration = math.random(35, 40) / 100

    update: (dt) =>
        if @animation_timer > @animation_duration
            @animation_timer = @animation_duration
            if @origin_j ~= @j
                @origin_j = @j
        elseif @animation_timer < @animation_duration
            @animation_timer += dt

    adjacent: (otherP) =>
        dx = math.abs(@i - otherP.i)
        dy = math.abs(@j - otherP.j)
        return dx + dy == 1

    goDown: =>
        @animation_timer = 0
        @j = @j + 1


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
        @selectionLoopPoint = nil

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
        for i, col in pairs @points
            for j, point in pairs col
                point\update dt
        if @selecting
            lastP = @selection[#@selection]
            local lastlastP
            if #@selection > 1
                lastlastP = @selection[#@selection - 1]
            mX, mY = love.mouse.getX!, love.mouse.getY!
            mouseP = @insidePoint mX, mY
            if mouseP and lastP\adjacent(mouseP) and lastP.color == mouseP.color
                if mouseP == lastlastP
                    @unselect lastP
                else
                    if @inSelection mouseP
                        @selectionLoopPoint = mouseP
                    @select mouseP

    draw: =>
        if @selecting and @selectionLoopPoint
            loopColor = @selectionLoopPoint.color
            alpha = 100
            table.insert loopColor, alpha
            love.graphics.setColor loopColor
            table.remove loopColor
            love.graphics.rectangle "fill", 0, 0, @w, @h
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

    unselect: (p) =>
        -- find and remove point
        for i, point in ipairs @selection
            if point == p
                table.remove @selection, i
                break
        if @selectionLoopPoint = p
            @selectionLoopPoint = nil
        p.selected = false

    inSelection: (p) =>
        for i, selectP in ipairs @selection
            if p == selectP
                return true
        return false

    clearSelected: =>
        mustDelete = #@selection > 1
        -- delete selection
        for i, p in ipairs @selection
            if mustDelete
                @deletePoint p
            else
                p.selected = false
        -- selectionLoop : delete all point of the same color
        if @selectionLoopPoint
            selectColor = @selectionLoopPoint.color
            for i, col in pairs @points
                for j, p in pairs col
                    if p.color == selectColor
                        @deletePoint p
        @selection = {}
        @selectionLoopPoint = nil

    deletePoint: (p) =>
        i = p.i
        for j = p.j, 2, -1
            @points[i][j - 1]\goDown!
            @points[i][j] = @points[i][j - 1]
        @points[i][1] = Point i, 1

    mousepressed: (x, y, button) =>
        switch button
            when "l"
                mouseP = @insidePoint(x, y)
                if mouseP
                    @selecting = true
                    @select mouseP

    mousereleased: (x, y, button) =>
        switch button
            when "l"
                @selecting = false
                @clearSelected!
