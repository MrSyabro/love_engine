local M = {}

M.new_object = require "love_engine.UI.object"
M.new_element = require "love_engine.UI.element"
M.new_container = require "love_engine.UI.container"

M.new_button = require "love_engine.UI.button"
M.new_grid = require "love_engine.UI.grid"
M.new_simple_text = require "love_engine.UI.simple_text"
M.new_textentry = require "love_engine.UI.textentry"
M.new_v_slider = require "love_engine.UI.v_slider"

return M
