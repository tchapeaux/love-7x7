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
        @selection = {}
        @selecting = false
        @selectionLoopPoint = nil

        @score = 0
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
        if @selecting
            lastP = @selection[#@selection]
            local lastlastP
            if #@selection > 1
                lastlastP = @selection[#@selection - 1]
            mX, mY = love.mouse.getX!, love.mouse.getY!
            mouseP = @insidePoint mX, mY
            if mouseP and lastP\adjacent(mouseP) and lastP.color == mouseP.color
                if mouseP == lastlastP
                    if @selectionLoopPoint == lastP
                        -- TODO: fix this hack: should be handled by unselect
                        @selection[#@selection] = nil
                        @selectionLoopPoint = nil
                    else
                        @unselect lastP
                else
                    unless lastP == @selectionLoopPoint and @inSelection mouseP
                        if @inSelection mouseP
                            @selectionLoopPoint = mouseP
                        @select mouseP

    draw: =>
        @drawBackground!
        if @selecting
            @drawSelectionLines!
        @drawPoints!
        love.graphics.setColor {0, 0, 0}
        love.graphics.printf "Score: #{@score}",
            @w/2, 10, @w/2 - 10, "right"

    drawBackground: =>
        love.graphics.setBackgroundColor {255, 255, 255}
        if @selecting and @selectionLoopPoint
            loopColor = @selectionLoopPoint.color
            r, g, b = loopColor[1], loopColor[2], loopColor[3]
            alpha = 100
            love.graphics.setColor {r, g, b, alpha}
            love.graphics.rectangle "fill", 0, 0, @w, @h

    drawSelectionLines: =>
        first_p = @selection[1]
        love.graphics.setColor darker first_p.color
        love.graphics.setLineWidth 5
        mX, mY = love.mouse.getX!, love.mouse.getY!
        prev_p = first_p
        for i, p in ipairs @selection
            if i > 1
                {prev_x, prev_y} = @pointCoordinate prev_p
                {cur_x, cur_y} = @pointCoordinate p
                love.graphics.line prev_x, prev_y, cur_x, cur_y
            prev_p = p
        {prev_x, prev_y} = @pointCoordinate prev_p
        love.graphics.line prev_x, prev_y, mX, mY

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


    select: (p) =>
        table.insert @selection, p
        p.selected = true

    unselect: (p) =>
        -- find and remove point
        for i, point in ipairs @selection
            if point == p
                table.remove @selection, i
                break
        if @selectionLoopPoint == p
            @selectionLoopPoint = nil
        p.selected = false

    inSelection: (p) =>
        for i, selectP in ipairs @selection
            if p == selectP
                return true
        return false

    clearSelected: =>
        mustDelete = #@selection > 1
        -- move count
        if mustDelete
            @moveCount += 1
        -- delete selection
        for i, p in ipairs @selection
            if mustDelete
                @deletePoint p
            else
                p.selected = false
        -- if selection loop : delete all point of the same color
        if @selectionLoopPoint
            selectColor = @selectionLoopPoint.color
            for i, col in pairs @points
                for j, p in pairs col
                    if p.color == selectColor
                        @deletePoint p
        @selection = {}
        @selectionLoopPoint = nil
        love.filesystem.write "score.txt", "#{@score}"

    deletePoint: (p) =>
        i = p.i
        for j = p.j, 2, -1
            @points[i][j - 1]\goDown!
            @points[i][j] = @points[i][j - 1]
        @points[i][1] = Point i, 1
        @score += 1

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
