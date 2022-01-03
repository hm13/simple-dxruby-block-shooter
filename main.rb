require 'dxruby'
require 'json'

class Ball < Sprite
    def initialize(x,y,image)
        super(x,y,image)
        @vx = 5
        @vy = 5
        @sign_x = 1
        @sign_y = 1
    end

    def update
        self.x += @sign_x * @vx
        self.y += @sign_y * @vy
    end

    def hit(o)
        if self == o
            return
        end

        # Estimate direction the Ball(self) shot the object(o).
        # Inaccruate, but simple algorithm.
        # See https://miro.com/app/board/uXjVOYSvPAI=/ for details.
        is_horizontal_shot = ((o.x + o.center_x) - (self.x + self.center_x)).abs > (o.image.width / 2)

        if is_horizontal_shot
            @sign_x = -@sign_x
        else
            @sign_y = -@sign_y
        end

        if o.instance_of?(Bar)
            # Calculate how far Ball(self) off from the center of the Bar(o) (in -0.5 ~ 0.5).
            # See https://miro.com/app/board/uXjVOYSvPAI=/ for details.
            d = (self.x + self.center_x) - (o.x + o.center_x)
            pos = d.to_f / o.image.width

            # Flip the result depending on @sign_x
            pos = @sign_x * pos

            if pos < -0.4
                @vx = 1
                @vy = 6
            elsif pos < -0.3
                @vx = 3
                @vy = 5
            elsif pos < 0.3
                @vx = 5
                @vy = 5
            elsif pos < 0.4
                @vx = 5
                @vy = 3
            else
                @vx = 6
                @vy = 1
            end
        end
    end
end

class Block < Sprite
    def initialize(x, y,image)
        super(x,y,image)
        self.x = x
        self.y = y
    end

    def hit(o)
        self.vanish
    end
end

class Bar < Sprite
    def initialize(x,y,image)
        super(x,y,image)
        @vx = 7
    end

    def update
        self.x += Input.x * @vx
    end
end

class WallTop < Sprite
end

class WallBottom < Sprite
    def hit(o)
        if o.instance_of?(Ball)
            # o.vanish
        end
    end
end

class WallLeft < Sprite
end

class WallRight < Sprite
end


all_config = File.open("config.json") do |j|
    JSON.load(j)
end

objects = []

all_config.each do |(class_name,object_param_list)|
    object_param_list.each do |c|
        x = c["x"]
        y = c["y"]
        image = Image.new(c["w"],c["h"],eval(c["c"]))
    
        objects << eval(class_name).new(x,y,image)
    end
end

Window.loop do
    Sprite.update(objects)
    Sprite.draw(objects)
    Sprite.check(objects)
end
