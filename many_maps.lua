io.write("start time : ".. os.time().."\n")
require( "iuplua" )
require( "iupluacontrols" )

--set initial values
screen_x = 1000
screen_y = 1000

--set limit of icons based on ratio
icon_limit = (screen_x * screen_y) * (15 / 500^2)

--default values are half of the limit / colors attached are default rgb values
forest = math.floor(icon_limit / 2); color1 = "150 255 0"
mountain = math.floor(icon_limit / 2); color2 = "255 0 0"
city = math.floor(icon_limit / 2); color3 = "128 52 235"
lake = math.floor(icon_limit / 2); color4 = "0 0 255"
village = math.floor(icon_limit / 2); color5 = "0 255 170"
volcanoes = math.floor(icon_limit / 2); color6 = "200 100 100"
color7 = "0 0 0"
name_map = "Map_Name"

--table of color strings
colors = {color1,color2,color3,color4,color5,color6,color7}
--destination table of int colors
tab = {}
--loop through table of colors
for i,v in ipairs(colors) do
  tab[i] ={}
  --break strings apart at the space characters and insert them as ints to tab
  for col in colors[i]:gmatch("%w+") do
    table.insert(tab[i], tonumber(col))
  end
end

local map = {}
local border = 30
--dice
local landmarks = {
    fours = {total = forest, type =  1},
    sixs = {total = mountain, type = 2},
    eights = {total = city, type = 3},
    tens = {total = lake, type = 4},
    twelves = {total = village, type = 5},
    twentys = {total = volcanoes, type = 6}
}
--initialize random function, needs to be popped a few times
math.randomseed(os.time()) 
math.random(); math.random(); math.random(); math.random()

--return a random number in range
function rand_in_border(num)
    local ret = math.floor(math.random(border,num))
    return ret
end

function dist(x1,y1,x2,y2)
    return  ((x2-x1)^2+(y2-y1)^2)^0.5
end

--place landmarks at random coordinates on the map
function dice_bag()
    for k, dcs in pairs(landmarks) do
        for i = 1, dcs.total do
            local x = rand_in_border(screen_x-border)
            local y = rand_in_border(screen_y-border)
            local type = dcs.type
            table.insert(map, {x,y,type})
        end
    end
end

--init gd
local gd = require ("gd")
--creates a new image
local im = gd.createTrueColor(screen_x, screen_y)

--set colors
local palette = {
im:colorAllocate(tab[1][1], tab[1][2], tab[1][3]), -- greenish
im:colorAllocate(tab[2][1], tab[2][2], tab[2][3]), -- red
im:colorAllocate(tab[3][1], tab[3][2], tab[3][3]), -- purple
im:colorAllocate(tab[4][1], tab[4][2], tab[4][3]), -- blue
im:colorAllocate(tab[5][1], tab[5][2], tab[5][3]), -- cyan
im:colorAllocate(tab[6][1], tab[6][2], tab[6][3]), -- brownsih
im:colorAllocate(tab[7][1], tab[7][2], tab[7][3]), -- black
im:colorAllocate(255, 255, 255), -- white
im:colorAllocate(150, 150, 150) -- grey
}

local icons = {}
--functions to draw icons on map
icons.forest = function ( xl, yl, col )
    im:filledPolygon( { 
    {xl, yl}, {xl+7, yl+7}, {xl+2, yl+7}, 
    {xl+7, yl+14}, {xl+2, yl+14},{xl+2, yl+21},{xl-2, yl+21},
    {xl-2, yl+14},{xl-7, yl+14},{xl-2, yl+7},{xl-7, yl+7}
    }, palette[col])
end
icons.mountain = function ( xl, yl, col )
    im:filledPolygon( { 
    {xl, yl}, {xl+7, yl-14}, {xl+7, yl-2}, 
    {xl+14, yl-14}, {xl+14, yl-2},{xl+21, yl-14},{xl+21, yl}
    }, palette[col])
end
icons.city = function ( xl, yl, col )
    im:filledPolygon( { 
    {xl, yl}, {xl+7, yl}, {xl+7, yl+7}, 
    {xl+12, yl+7}, {xl+12, yl+14},{xl-3, yl+14}
    }, palette[col])
    im:line(xl+7, yl+7, xl+7, y+14, palette[7])
end
icons.lake = function ( xl, yl, col )
    im:filledPolygon( { 
    {xl, yl}, {xl+5, yl-3}, {xl+15, yl-7}, 
    {xl+21, yl}, {xl+18, yl+7},{xl+12, yl+10},{xl+6, yl+11},
    {xl+3, yl+5}
    }, palette[col])
end
icons.village = function ( xl, yl, col )
    im:filledPolygon( { 
    {xl, yl}, {xl+7, yl-7}, {xl+14, yl}, 
    {xl+10, yl}, {xl+11, yl+7},{xl+4, yl+7},{xl+4, yl}
    }, palette[col])
end
icons.volcano = function ( xl, yl, col )
    im:filledPolygon( { 
    {xl, yl}, {xl+3, yl+2}, {xl+6, yl}, 
    {xl+9, yl+9}, {xl-3, yl+9}
    }, palette[col])
    im:line(xl+3, yl+2, xl-3, yl-6, palette[2])
    im:line(xl+3, yl+2, xl+3, yl-6, palette[2])
    im:line(xl+3, yl+2, xl+9, yl-6, palette[2])
end

--draw lines on the map
function map_line(coef)
    
    for i,v in ipairs(map) do
        prev_x = map[i][1]
        prev_y = map[i][2]
        for k,v in ipairs(map) do
            x = map[k][1]
            y = map[k][2] 
            if dist(prev_x, prev_y, x, y) < coef then 
                im:line(prev_x, prev_y, x, y, palette[9])
            end
        end
    end
end

--draw arcs on the map
function map_arc(coef, index)
    for i,v in ipairs(map) do
        prev_x = map[i][1]
        prev_y = map[i][2]
        for k,v in ipairs(map) do
            x = map[k][1]
            y = map[k][2] 
            d = dist(prev_x, prev_y, x, y)
            d_x = dist(prev_x, 0, x, 0)
            d_y = dist(prev_y, 0, y, 0)
            if d < coef then 
                mid_x = (prev_x + x) / 2
                mid_y = (prev_y + y) / 2
                rand_w = d_x+30
                rand_h = d_y+40
                if d > 0 and d % 5 == 0 then 
                    im:arc(mid_x, mid_y, rand_h, rand_w, 0, 360, palette[index]) 
                else
                    im:arc(mid_x, mid_y, rand_w, rand_h, 0, 360, palette[index]) 
                end
                --if prev_x > x then im:arc(mid_x, mid_y, rand_w, rand_h, 0, 180, palette[9]) end
            end
        end
    end
end

--go through every point on map and create icons on the image
function map_populate()
    for i,v in ipairs(map) do
        x = map[i][1]
        y = map[i][2]
        type = map[i][3]
        if type == 1 then
            icons.forest(x,y,type)
        elseif type == 2 then
            icons.mountain(x,y,type)
        elseif type == 3 then
            icons.city(x,y,type)
        elseif type == 4 then
            icons.lake(x,y,type)
        elseif type == 5 then
            icons.village(x,y,type)
        elseif type == 6 then
            icons.volcano(x,y,type)
        else
            im:filledPolygon( { {x, y}, {x+10, y}, {x+10, y+10}, {x, y+10} }, palette[type])
        end
    end
end
--only works with windows command line

io.write("number of images:")
a = io.read("*n")
io.write("coefficient integer:")
b = io.read("*n")


for k=1,a do
  dice_bag()
  map_arc(b,9)
  im:fill(0,0,palette[8])
  map_arc(b,7)
  map_populate()
  im:png("./instant_maps/"..name_map .. k .. ".png")
  --os.execute("start ".. "./instant_maps/".. name_map .. k .. ".png")
  map={}
  im = gd.createTrueColor(screen_x, screen_y)
end

io.write("\nend time : ".. os.time())