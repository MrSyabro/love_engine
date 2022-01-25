## Love2D custom engine

Представляю вашему вниманию небольшой, простой, основанный на моем говнокоде, движек на фреймворке Love2D.

## Пример

`main.lua`:
```
e = require "love_engine"

e:init(love)
e:load_scene("menu.lua")
```

`menu.lua`
```
local ui = require "love_engine.UI"

grid = ui.new_grid ("grid", 0, 0, utils.tc(1, 1))   -- Создаем grid на весь экран

button1 = ui.new_button("start_bt")                 -- Создаем кнопку
button1.printed_name = "Start"                      -- Присваиваем печатаемый текст
function button1.callbacks.mousepressed (self)      -- Отлавливаем нажатие мышкой
    utils.info ("Button1 pressed!")                 -- Печатаем информацию в консоль
end

grid:add (button1, 2, 2)                            -- Добавляем button1 в grid
objs:add (grid)                                     -- Добавляем grid на сцену
```
