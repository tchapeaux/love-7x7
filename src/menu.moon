export ^

class Menu
    new: =>
        @active = false
        @w = love.graphics.getWidth!
        @h = love.graphics.getHeight!
        @options = {
            "Resume"
            "Reset Score"
            "Credits"
            "Quit"
        }
        @optionHeight = 30
        @margin = 10
        @selected = 1
        @creditText = "7x7 - an open-source clone of DOTS
Original game: www.weplaydots.com


Made by Altom for a pretty Cookie
Github: https://github.com/tchapeaux/love-7x7

>>> Press Enter to return to the menu <<<"
        @displayText = nil

    draw: =>
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
                grid.score = 0
                @active= false
            when "Credits"
                @displayText = @creditText
            when "Quit"
                love.event.quit!
