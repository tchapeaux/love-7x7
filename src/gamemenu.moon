export ^

export controlsText = "Click and drag to match similar colors
Up/Down arrows: change grid size
R: Reset Grid


>>> Press Enter to return to the menu <<<"

export creditText = "7x7 - an open-source clone of DOTS
Original game: www.weplaydots.com
Font: http://loudifier.com/comic-relief/


Made by Altom for a pretty Cookie
Github: https://github.com/tchapeaux/love-7x7

>>> Press Enter to return to the menu <<<"

class GameMenu
    new: =>
        @active = false
        @w = love.graphics.getWidth!
        @h = love.graphics.getHeight!
        @options = {
            "Resume"
            "Reset Score"
            "Controls"
            "Credits"
            "Quit"
        }
        @optionHeight = 30
        @margin = 10
        @selected = 1
        @logo = resources.logo

        @displayText = nil

    draw: =>
        -- darken game screen (drawn previously)
        love.graphics.setColor {0, 0, 0, 100}
        love.graphics.rectangle "fill", 0, 0, @w, @h
        -- logo
        x = (@w / 2) - (@logo\getWidth! / 2)
        y = (@h / 4) - (@logo\getHeight! / 2)
        love.graphics.setColor {255, 255, 255, 100}
        love.graphics.rectangle "fill", x, y, @logo\getWidth!, @logo\getHeight!
        love.graphics.setColor {255, 255, 255, 255}
        love.graphics.draw @logo, x, y

        if @displayText
            love.graphics.setColor {0, 0, 0, 200}
            love.graphics.rectangle("fill", 0, @h / 4, @w, @h / 2)
            love.graphics.setColor {255, 255, 255}
            love.graphics.printf @displayText, 0, @h / 4 + 30, @w, "center"
        else
            for i, opt in ipairs @options
                love.graphics.setColor {0, 0, 0, 200}
                yO = @h / 2 - (#@options * @optionHeight + (#@options - 1) * @margin) / 2
                y = yO + (i-1) * (@optionHeight + @margin)
                love.graphics.rectangle "fill", 0, y, @w, @optionHeight
                love.graphics.setColor {255, 255, 255}
                love.graphics.printf opt, 0, y, @w, "center"
                if i == @selected
                    love.graphics.printf ">>>>", 0, y, @w, "left"
                    love.graphics.printf "<<<<", 0, y, @w, "right"

    update: (dt) =>

    keyreleased: (key) =>
        switch key
            when "up"
                @selected -= 1
                @selected = ((@selected - 1) % #@options) + 1
            when "down"
                @selected += 1
                @selected = ((@selected - 1) % #@options) + 1
            when "return"
                if @displayText
                    @displayText = nil
                else
                    @selectAction!
            when "escape"
                @displayText = nil
                @active = false

    selectAction: =>
        switch @options[@selected]
            when "Resume"
                @active = false
            when "Reset Score"
                game.grid.score = 0
                @active= false
            when "Controls"
                @displayText = controlsText
            when "Credits"
                @displayText = creditText
            when "Quit"
                love.event.quit!
