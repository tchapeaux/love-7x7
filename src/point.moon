export ^

require "colors"

class Point
    new: (@i, @j, @color=randomColor!, @origin_j = -3) =>
        @selected = false
        -- animation is handled by the Grid but the timer is here
        @animation_timer = 0
        @animation_duration = math.random(45, 55) / 100

    update: (dt) =>
        if @animation_timer > @animation_duration
            @animation_timer = @animation_duration
            if @origin_j ~= @j
                @origin_j = @j
        elseif @animation_timer < @animation_duration
            @animation_timer += dt

    draw: (radius) =>
        x = 0
        y = 0
        love.graphics.setColor @color
        if @selected
            radius += 5
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
        @animation_timer = 0
        @j = @j + 1


