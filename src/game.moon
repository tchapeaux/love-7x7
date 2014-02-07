require "grid"
require "gamemenu"
require "endstate"

export ^

w, h = love.graphics.getWidth!, love.graphics.getHeight!

class Game
    new: (gridSize, @timeLimit=-1, @maxMove=-1, changeGridSize=false) =>
        @font = love.graphics.newFont "res/font/ComicRelief.ttf", 20
        @grid = Grid gridSize
        @menu = GameMenu!
        @score = 0
        @selection = {}
        @selecting = false
        @selectionLoopPoint = nil
        if love.filesystem.isFile "score.txt"
            score, _ = love.filesystem.read "score.txt"
            score = tonumber score
            @score = score

    update: (dt) =>
        if @menu.active
            @menu\update dt
        else
            @grid\update dt
        @checkNewSelection love.mouse.getX!, love.mouse.getY!
        if @endOfGame!
            statestack\pop!
            statestack\push EndState @score

    endOfGame: =>
        if @timeLimit > -1 and @grid.timer >= @timeLimit
            return true
        if @maxMove > -1 and @grid.moveCount >= @maxMove
            return true
        return false

    checkNewSelection: (mX, mY) =>
        if @selecting
            lastP = @selection[#@selection]
            local lastlastP
            if #@selection > 1
                lastlastP = @selection[#@selection - 1]
            mX, mY = love.mouse.getX!, love.mouse.getY!
            mouseP = @grid\insidePoint mX, mY
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
        if #@selection > 0
            @drawSelectionLines selection
        @grid\draw!
        love.graphics.setColor {0, 0, 0}
        local hud_string
        hud_string = ""
        hud_string ..= "Score: #{@score}"
        if @timeLimit > -1
            displayTime = @timeLimit - math.floor @grid.timer
            hud_string ..= "\nRemaining Time: #{displayTime}"
        if @maxMove > -1
            hud_string ..= "\nMoves: #{@grid.moveCount} / #{@maxMove}"
        love.graphics.setFont @font
        love.graphics.printf hud_string,
            w/2, 10, w/2 - 10, "right"

        if @menu.active
            @menu\draw!

    drawBackground: =>
        love.graphics.setBackgroundColor {255, 255, 255}
        if @selecting and @selectionLoopPoint
            loopColor = @selectionLoopPoint.color
            r, g, b = loopColor[1], loopColor[2], loopColor[3]
            alpha = 100
            love.graphics.setColor {r, g, b, alpha}
            love.graphics.rectangle "fill", 0, 0, w, h

    drawSelectionLines: =>
        first_p = @selection[1]
        love.graphics.setColor darker first_p.color
        love.graphics.setLineWidth 5
        mX, mY = love.mouse.getX!, love.mouse.getY!
        prev_p = first_p
        for i, p in ipairs @selection
            if i > 1
                {prev_x, prev_y} = @grid\pointCoordinate prev_p
                {cur_x, cur_y} = @grid\pointCoordinate p
                love.graphics.line prev_x, prev_y, cur_x, cur_y
            prev_p = p
        {prev_x, prev_y} = @grid\pointCoordinate prev_p
        love.graphics.line prev_x, prev_y, mX, mY

    resetGrid: (newSize=@grid.size) =>
        if newSize == "up"
            newSize = @grid.size + 1
        if newSize == "down"
            newSize = @grid.size - 1
        score = @grid.score
        @grid = Grid newSize
        @grid.score = score

    inSelection: (p) =>
        for i, selectP in ipairs @selection
            if p == selectP
                return true
        return false

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

    clearSelected: =>
        mustDelete = #@selection > 1
        -- move count
        if mustDelete
            @grid.moveCount += 1
        -- delete selection
        for i, p in ipairs @selection
            if mustDelete
                @deletePoint p
            else
                p.selected = false
        -- if selection loop : delete all point of the same color
        if @selectionLoopPoint
            selectColor = @selectionLoopPoint.color
            for i, col in pairs @grid.points
                for j, p in pairs col
                    if p.color == selectColor
                        @deletePoint p
        @selection = {}
        @selectionLoopPoint = nil
        love.filesystem.write "score.txt", "#{@score}"

    deletePoint: (p) =>
        @score += 1
        @grid\deletePoint p

    mousepressed: (x, y, button) =>
        switch button
            when "l"
                mouseP = @grid\insidePoint(x, y)
                if mouseP
                    @selecting = true
                    @select mouseP

    mousereleased: (x, y, button) =>
        switch button
            when "l"
                @selecting = false
                @clearSelected!

    keyreleased: (key) =>
        switch key
            when "escape"
                if not @menu.active
                    @menu.active = true
                else
                    @menu\keyreleased key
            when "r"
                unless @menu.active
                    @resetGrid!
            when "up"
                if @menu.active
                    @menu\keyreleased key
                else
                    if @changeGridSize
                        @resetGrid "up"
            when "down"
                if @menu.active
                    @menu\keyreleased key
                else
                    if @changeGridSize
                        @resetGrid "down"
            when "f11"
                width, height, fullscreen, vsync, fsaa = love.graphics.getMode!
                love.graphics.setMode width, height, not fullscreen, vsync, fsaa
            else
                if @menu.active
                    @menu\keyreleased key
