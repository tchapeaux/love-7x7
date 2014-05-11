export ^

require "colors"

class Point
    new: (@i, @j, @color=randomColor!, initAnimation=true) =>
        @selected = false
        @drawJ = -2
        @lasttween = nil
        if initAnimation
            distance = @j - @drawJ
            randTime = .3 + .05 * distance + (love.math.random() - .5) / 4
            @lasttween = flux.to(@, randTime, {drawJ: @j})\ease("backout")
        else
            @drawJ = @j


    update: (dt) =>

    draw: (radius) =>
        -- assume the axis are placed at the point position
        x = 0
        y = 0
        love.graphics.setColor @color
        love.graphics.circle("fill", x, y, radius, 2 * radius)
        love.graphics.setColor darker @color
        love.graphics.setLineWidth 2
        love.graphics.circle("line", x, y, radius, 2 * radius)
        x -= radius / 3
        y -= radius / 3
        love.graphics.setColor lighter @color
        -- love.graphics.circle "fill", x, y, radius / 2, radius
        -- love.graphics.setColor {255, 255, 255}
        love.graphics.circle "fill", x, y, radius / 4, radius


    adjacent: (otherP) =>
        dx = math.abs(@i - otherP.i)
        dy = math.abs(@j - otherP.j)
        return dx + dy == 1

    goDown: =>
        @j += 1
        flux.remove(@lasttween) -- cancel previous tween if existing
        randTime = .5 + love.math.random() / 2
        @lasttween = flux.to(@, randTime, {drawJ: @j})\ease("backout")


