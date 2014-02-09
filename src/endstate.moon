export ^

require "resources"

class EndState
    new: (@score, @scoreFile) =>
        @fontBig = love.graphics.newFont resources.font_path, 100
        @fontMed = love.graphics.newFont resources.font_path, 20
        if not love.filesystem.isFile @scoreFile
            love.filesystem.write @scoreFile, "0"
        @best_score = love.filesystem.read @scoreFile
        @best_score = tonumber @best_score
        if @score > @best_score
            love.filesystem.write @scoreFile, "#{@score}"

    update: =>

    draw: =>
        love.graphics.setFont @fontBig
        love.graphics.printf "That's it!", 0, hScr! / 4, wScr!, "center"
        love.graphics.setFont @fontMed
        scoreText = "You scored #{@score}.\n"
        if @score > @best_score
            scoreText ..= "It's a new record!"
        else
            scoreText ..= "Your previous record was: #{@best_score}"
        scoreText ..= "\nPress Enter to go back to the menu"

        love.graphics.printf scoreText, 0, 2 * hScr! / 3, wScr!, "center"

    keyreleased: (key) =>
        switch key
            when "return"
                statestack\pop!
