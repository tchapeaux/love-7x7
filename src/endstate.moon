export ^

require "resources"

class EndState
    new: (@score) =>
        @w = love.graphics.getWidth!
        @h = love.graphics.getHeight!
        @fontBig = love.graphics.newFont resources.font_path, 100
        @fontMed = love.graphics.newFont resources.font_path, 20

    update: =>

    draw: =>
        love.graphics.setFont @fontBig
        love.graphics.printf "That's it!", 0, @h/4, @w, "center"
        love.graphics.setFont @fontMed
        love.graphics.printf "You scored #{@score}, nice!\nPress Enter to go back to the menu", 0, 2 * @h / 3, @w, "center"

    keyreleased: (key) =>
        switch key
            when "return"
                statestack\pop!
