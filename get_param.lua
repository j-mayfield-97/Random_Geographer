io.write("start time : ".. os.time())

require( "iuplua" )
require( "iupluacontrols" )

--set initial values
screen_x = 600
screen_y = 600

--user input image size
ret, screen_x, screen_y = iup.GetParam("Image Dimensions", nil,
"x dimension: %i\n"..
"y dimension: %i\n",
screen_x, screen_y
)
--check to make sure its not too small 
if(screen_x < 100 or screen_y < 100) then
    iup.Message("Error", "Image cannot be smaller than 100 pixels \n"..
                        "For best results use 500 x 500 or greater")
    --Exits the main loop
    iup.Close()
end

--set limit of icons based on ratio
icon_limit = (screen_x * screen_y) * (15 / 500^2)
--landmass coeff limits
coeff_lower = 75; coeff_upper = 110
grouping_coeff = math.floor((coeff_upper + coeff_lower) / 2)

--default values are half of the limit / colors attached are default rgb values
forest = math.floor(icon_limit / 2); color1 = "150 255 0"
mountain = math.floor(icon_limit / 2); color2 = "255 0 0"
city = math.floor(icon_limit / 2); color3 = "128 52 235"
lake = math.floor(icon_limit / 2); color4 = "0 0 255"
village = math.floor(icon_limit / 2); color5 = "0 255 170"
volcanoes = math.floor(icon_limit / 2); color6 = "200 100 100"
opt = 0
color7 = "150 150 150"
name_map = "Map_Name"



-- get input numbers from user
ret, forest, color1, mountain, color2, city, color3, lake, color4, village, color5, volcanoes, color6, name_map, opt, color7, grouping_coeff = 
      iup.GetParam("Map Maker", nil ,
                    "Icons %t\n"..
                  "number of forest: %i[0,".. icon_limit .."]\n"..
                  "forest color %c\n" ..
                  "number of mountains: %i[0,".. icon_limit .."]\n"..
                  "mountain color %c\n" ..
                  "number of cities: %i[0,".. icon_limit .."]\n"..
                  "city color %c\n" ..
                  "number of lakes: %i[0,".. icon_limit .."]\n"..
                  "lake color %c\n" ..
                  "number of villages: %i[0,".. icon_limit .."]\n"..
                  "village color %c\n" ..
                  "number of volcanoes: %i[0,".. icon_limit .."]\n"..
                  "volcano color %c\n" ..
                    "Map Options %t\n"..
                  "name of map: %s\n"..
                  "options: %o|curve|straights|no lines|\n"..
                  "background color %c\n"..
                  "grouping coefficient: %i[".. coeff_lower ..",".. coeff_upper .."]{Lower for more islands, Higher for more landmass}\n",
                  forest, color1, mountain, color2, city, color3, lake, color4, village, color5, volcanoes, color6, name_map, opt, color7, grouping_coeff
                )

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

if (not ret) then
  return iup.CLOSE
end
if (ret) then
  return iup.CLOSE
end

function btn_exit_cb(self)
    iup.Message(name_map,
            "fours "..forest.."\n"..
            "sixes"..mountain.."\n"..
            "eights: "..city.."\n"..
            "tens: "..lake.."\n"..
            "twelves: "..village.."\n"..
            "twenties: "..volcanoes.."\n"
        )
    -- Exits the main loop
    return iup.CLOSE
end

if (iup.MainLoopLevel()==0) then
  iup.MainLoop()
  iup.Close()
end

