require 'dxruby'
require 'json'

class SpriteJsonInit < Sprite
    attr_accessor :vx, :vy
    protected :vx, :vy

    def initialize
        all_config = File.open("config.json") do |j|
            JSON.load(j)
        end

        config = all_config[self.class.to_s]

        self.x = config["x"]
        self.y = config["y"]
        self.vx = config["vx"]
        self.vy = config["vy"]
        self.image = Image.new(config["w"],config["h"],eval(config["c"]))
    end
end

class Ball < SpriteJsonInit
    def update
        self.x += self.vx
        self.y += self.vy
    end

    def hit(o)
        if self == o
            return
        end

        # Estimate direction the Ball(self) shot the object(o).
        # Inaccruate, but simple algorithm.
        is_horizontal_shot = (o.image.width - self.center_x.abs < 0)

        if is_horizontal_shot
            self.vx = -self.vx
        else
            self.vy = -self.vy
        end
    end
end

class Bar < SpriteJsonInit
    def update
        self.x += Input.x * self.vx
    end
end

class WallTop < SpriteJsonInit
end

class WallBottom < SpriteJsonInit
    def hit(o)
        if o.instance_of?(Ball)
            o.vanish
        end
    end
end

class WallLeft < SpriteJsonInit
end

class WallRight < SpriteJsonInit
end

objects = [
    Bar.new,
    Ball.new,
    WallTop.new,
    WallBottom.new,
    WallLeft.new,
    WallRight.new
]

Window.loop do
    Sprite.update(objects)
    Sprite.draw(objects)
    Sprite.check(objects)
end
