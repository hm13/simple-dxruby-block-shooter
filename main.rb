require 'dxruby'

class Ball < Sprite
    @@image= Image.load('images/ball32x32.png')

    def initialize
        super
        self.x = 50
        self.y = 50
        self.image = @@image
        @vx = 5
        @vy = 5
    end

    def update
        self.x += @vx
        self.y += @vy
    end

    def hit(o)
        if self == o
            return
        end

        # Estimate direction the Ball(self) shot the object(o).
        # Inaccruate, but simple algorithm.
        is_horizontal_shot = (o.image.width - self.center_x.abs < 0)

        if is_horizontal_shot
            @vx = -@vx
        else
            @vy = -@vy
        end
    end
end

class Bar < Sprite
    @@image = Image.load('images/bar128x32.png')

    def initialize
        super
        self.x = 300
        self.y = 400
        self.image = @@image
    end

    def update
        self.x += Input.x * 5
    end
end

class WallTop < Sprite
    @@image = Image.new(640,2,C_BLUE)

    def initialize
        self.x = 0
        self.y = 0
        self.image = @@image
    end
end

class WallBottom < Sprite
    @@image = Image.new(640,2,C_BLUE)

    def initialize
        self.x = 0
        self.y = 478
        self.image = @@image
    end

    def hit(o)
        if o.instance_of?(Ball)
            o.vanish
        end
    end
end

class WallLeft < Sprite
    @@image = Image.new(2,480,C_BLUE)

    def initialize
        self.x = 0
        self.y = 0
        self.image = @@image
    end
end

class WallRight < Sprite
    @@image = Image.new(2,480,C_BLUE)

    def initialize
        self.x = 638
        self.y = 0
        self.image = @@image
    end
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
