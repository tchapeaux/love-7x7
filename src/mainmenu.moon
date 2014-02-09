export ^

require "game"

class MainMenu
    new: =>
        @fontBig = love.graphics.newFont "res/font/ComicRelief.ttf", 100
        @fontMed = love.graphics.newFont "res/font/ComicRelief.ttf", 20
        @title = "PÖINTS"
        @selected = 1
        @text = {
            "Time Mode"
            "Move Mode"
            "Infinite Mode"
        }

        @defaultGridSize = 7

    update: =>


    draw: =>
        love.graphics.setColor {0, 0, 0}
        love.graphics.rectangle "fill", 0, 0, wScr!, hScr!
        love.graphics.setFont @fontBig
        love.graphics.setColor {255, 255, 255}
        love.graphics.printf @title, 0, hScr! / 8, wScr!, "center"
        love.graphics.setFont @fontMed
        for i, text in ipairs @text
            if i == @selected
                love.graphics.setColor {255, 255, 255}
            else
                love.graphics.setColor {100, 100, 100}
            love.graphics.printf text,
                (i-1) * wScr! / 3, 3 * hScr! / 4 - 25, wScr! / 3, "center"
        love.graphics.setColor {100, 100, 100}
        love.graphics.printf "Press escape to quit",
            0, hScr! - 50, wScr!, "center"
        love.graphics.printf "Use arrows to select mode",
            0, hScr! / 2, wScr!, "center"

    keyreleased: (key) =>
        switch key
            when "right"
                @selected += 1
                @selected = lua_mod @selected, #@text
            when "left"
                @selected -= 1
                @selected = lua_mod @selected, #@text
            when "return"
                @launchGame!
            when "escape"
                love.event.quit!

    launchGame: =>
        gameMode = @text[@selected]
        local game
        if gameMode == "Time Mode"
            game = Game @defaultGridSize, "time_score.txt", 30
        elseif gameMode == "Move Mode"
            game = Game @defaultGridSize, "move_score.txt", -1, 30
        elseif gameMode == "Infinite Mode"
            game = Game @defaultGridSize, "infinite_score.txt", -1, -1, true, true
        else
            error "Invalid game mode: #{gameMode}"
        statestack\push game
