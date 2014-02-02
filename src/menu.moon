export ^

class Menu
    new: =>
        @active = false
        @w = love.graphics.getWidth!
        @h = love.graphics.getHeight!
        @options = {
            "Resume"
            "Reset Score"
            "Instructions (coming soon...)"
            "Credits (coming soon...)"
            "Quit"
        }
        @optionHeight = 30
        @margin = 10
        @selected = 1

    draw: =>
        yO = @h / 2 - (#@options * @optionHeight + (#@options - 1) * @margin) / 2
        for i, opt in ipairs @options
            y = yO + (i-1) * (@optionHeight + @margin)
            love.graphics.setColor {0, 0, 0, 200}
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
                @selectAction!

    selectAction: =>
        switch @options[@selected]
            when "Resume"
                @active = false
            when "Reset Score"
                grid.score = 0
                @active= false
            when "Quit"
                love.event.quit!
