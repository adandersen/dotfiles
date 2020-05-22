--[[ TODO's
    - set per monitor dpi using beautiful.xresources.set_dpi(screen[1], 42)
    - make shortcut to copy all tags on a screen to another screen, maybe tyrannical with dynamic tag management can help here
    - find out how to make cursor not so big
    - get a better handle on how events work in awesomewm
    - change the ugly icons. Found in /usr/share/awesome/themes/default/titlebar
--]]

--[[ Configuration notes: 
    - have xrandr --dpi 108 for non laptop monitor in bash_profile_local on work machine. Scales awesome menus/borders/icons/font correctly (not cursor for some reason)
--]]

--[[ Function behavior reminders
    - To better understand a function, download the AwesomeWM source and look at the code directly. The function names are often misleading.
    - gears.table.join - joins multiple tables, e.g. table 1 and 2 both have {1={a}, 2={b}}, join makes {1={a}, 2={b}, 3={a}, 4={b}}
    - awful.button are mouse clicks. 1 = left mouse button, 2 = middle mouse button, 3 = right mouse button, 4 = scroll up, 5 = scroll down
    - awful.key are keyboard presses
    - wibox is the bar at the top that contains everything (tags, tasks, widgets, etc.)
    - Mod4 = Super key (windows key), Mod1 = Alt, Control = Control, Shift = Shift (left side are awesome as well as X names)
--]]


-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

al = {}
function al.cmd(cmd)
    local file = io.popen(cmd)
    local s = file:read("*a") -- *a reads whole file, *l reads one line (default), *n reads a number
    s = string.gsub(s, "^%s+", "") -- clears beginning white space
    s = string.gsub(s, "%s+$", "") -- clears ending whitespace (including new line that a* adds to text)
    s = string.gsub(s, "[\n\r]+", " ") -- deletes intermediate new lines? not sure if want this
    return s
end
al.home = al.cmd("echo ~")
function al.indent(count)
    s = ""
    for i = 1, count do
        s = s.."\t"
    end
    return s
end
function al.prin(str)
    local file = io.open(al.home.."/.awesome_prints", "a+") -- creates new file or (a)ppend (+)at end only
    file:write(str..'\n')
    file:close()
end
--@return string
function al.dump(o, depth)
    if depth == nil then depth = 0 end
    if depth > 3 or depth == -1 then return tostring(0) end
    if o == _G then depth = -2 end
    if type(o) == "table" then
        local s = "\n"..al.indent(depth-1).."{ \n"
        for k,v in pairs(o) do
            if type(k) ~= "userdata" and type(k) ~= "screen" then
                if type(k) ~= "number" then k = '"'..k..'"' end
                s = s..al.indent(depth)..k.." = "..al.dump(v, depth + 1)..",\n"
            end
        end
        return s.."\n"..al.indent(depth-1).."}"
    else
        return tostring(o)
    end
end
function al.dump_keys(o)
    if type(o) ~= "userdata" then
        if type(o) == "table" then
            local s = "\n{ \n"
            for k,v in pairs(o) do
                if type(k) ~= "number" then k = '"'..k..'"' end
                s = s..k..",\n"
            end
            return s.."\n}"
        else
            return tostring(o)
        end
    end
end
function al.eval(str)
    local success, val = pcall(assert(load("return "..str)))
    if not val then val = "nil" end
    if type(val) == "table" then val = al.dump(val, 0) end
    return success, val
end

-- Standard awesome library
local gears = require("gears")
al.gears = gears
local awful = require("awful")
al.awful = awful
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
al.wibox = wibox
-- Theme handling library
local beautiful = require("beautiful")
al.beautiful = beautiful
-- Notification library
local naughty = require("naughty")
al.naughty = naughty
local menubar = require("menubar")
al.menubar = menubar
local hotkeys_popup = require("awful.hotkeys_popup")
al.hotkeys_popup = hotkeys_popup
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

-- Load Debian menu entries
local debian = require("debian.menu")
al.debian = debian
local has_fdo, freedesktop = pcall(require, "freedesktop")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = tostring(err) })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
beautiful.init("~/.config/awesome/defaultCustom.lua")

-- This is used later as the default terminal and editor to run.
terminal = "kitty"
editor = os.getenv("EDITOR") or "editor"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4" -- aka Super

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    awful.layout.suit.floating,
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.spiral,
    awful.layout.suit.spiral.dwindle,
    awful.layout.suit.magnifier,
    awful.layout.suit.corner.nw,
    -- awful.layout.suit.corner.ne,
    -- awful.layout.suit.corner.sw,
    -- awful.layout.suit.corner.se,
}
-- }}}

-- {{{ Menu
-- Create a launcher widget and a main menu
myawesomemenu = {
   { "hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "suspend", terminal.." -e ".."systemctl suspend" },
   { "logout", function() awesome.quit() end }
}

local menu_awesome = { "awesome", myawesomemenu, beautiful.awesome_icon }
local menu_terminal = { "open terminal", terminal }

if has_fdo then
    mymainmenu = freedesktop.menu.build({
        before = { menu_awesome },
        after =  { menu_terminal }
    })
else
    mymainmenu = awful.menu({
        items = {
                  menu_awesome,
                  { "Debian", debian.menu.Debian_menu.Debian },
                  menu_terminal,
                }
    })
end


-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- {{{ Wibar
-- Create a wibox for each screen and add it
-- taglist are all the clickable tax boxes
local taglist_buttons = gears.table.join(
                    awful.button({ }, 1, function(t) t:view_only() end),
                    awful.button({ modkey }, 1, function(t)
                                              if client.focus then
                                                  client.focus:move_to_tag(t)
                                              end
                                          end),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, function(t)
                                              if client.focus then
                                                  client.focus:toggle_tag(t)
                                              end
                                          end),
                    awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
                )

-- task list is all the client tabs
local tasklist_buttons = gears.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  c:emit_signal(
                                                      "request::activate",
                                                      "tasklist",
                                                      {raise = true}
                                                  )
                                              end
                                          end),
                     awful.button({ }, 3, function()
                                              awful.menu.client_list({ theme = { width = 250 } })
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                          end))

local function set_wallpaper(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end

-- {{{ Widgets
local mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })

-- Create a textclock widget
local mytextclock = wibox.widget.textclock()
battery_widget = require("awesome-wm-widgets.batteryarc-widget.batteryarc")
volumebar_widget = require("awesome-wm-widgets.volumebar-widget.volumebar")
--naughty.notify({title = tostring(battery_widget())})

-- }}}

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

local tagCount = 9
awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    set_wallpaper(s)

    -- Each screen has its own tag table.
    -- warning: don't try changing these with clients open, will screw up and lose your clients from any of the tags not on the first tag and you will have to pkill them.
    local tags = {}
    local layouts = {} 
    local l = awful.layout.suit
    for i = 1, tagCount do table.insert(tags, i)         end
    for i = 1, tagCount do table.insert(layouts, l.tile) end
    awful.tag(tags, s, layouts) -- create the actual desktops (aka tags) for each screen (a monitor abstraction for X)

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt({
        fg = '#74aeab', -- text color
        bg = '#000000'
    })
    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
                           awful.button({ }, 1, function () awful.layout.inc( 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(-1) end),
                           awful.button({ }, 4, function () awful.layout.inc( 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(-1) end)))
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        buttons = taglist_buttons -- mouse clicks
    }

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist {
        screen  = s,
        filter  = awful.widget.tasklist.filter.currenttags,
        buttons = tasklist_buttons, -- mouse clicks
        style = {
            shape = gears.shape.powerline
        }
    }

    -- Create the wibox (aka widget box)
    s.mywibox = awful.wibar({ position = "top", screen = s })

    -- Add widgets to the wibox
    -- 
    -- wibox layout explanations. Each "widget" can actually be a collection (table) of widgets. Only 3 widgets or collections is usable for the align layout. It also seems to be the only layout that auto stretches a collection (the middle one). One of them can't be in a table apparently, don't know why.
    -- See https://awesomewm.org/apidoc/documentation/03-declarative-layout.md.html Layouts section
    -- fixed, each widget gets what it asks for, left aligned
    -- align, 1st widget is left aligned, 3rd widget is right aligned, 2nd widget expands to take up all space (useful for task list)
    s.mywibox:setup {
        {  -- empty layout. The second (middle) one for align takes up all the remaining space. 
            layout = wibox.layout.fixed.horizontal,
        },
        layout = wibox.layout.align.horizontal,
        s.mytasklist, -- Middle widget, since it expands to take up all the space with align layout
        { -- Right widgets, everything else on the right
            layout = wibox.layout.fixed.horizontal,
            spacing = 5, -- add pixels of space between widgets
            wibox.widget.systray(),
            volumebar_widget({
                main_color = "#74aeab",
                mute_color = "#ff0000",
                width = 80,
                shape = "hexagon",
                margins = 12
            }),
            battery_widget({
                main_color = "#74aeab",
            }),
            mytextclock,
            s.mylayoutbox,
            --mylauncher, -- the awesome icon used to click to launch apps.
            s.mytaglist,
            s.mypromptbox,
        },
    }
end)
-- }}}

-- {{{ Mouse bindings
-- root is the term for the main X window, in awesome it means the desktop itself behind all the windows (on every screen) as well as the "awesome instance" where all the global key bindings live
root.buttons(gears.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = gears.table.join(
    awful.key({ modkey,           }, "s",      hotkeys_popup.show_help,
              {description="show help", group = "awesome"}),
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev,
              {description = "view previous", group = "tag"}),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext,
              {description = "view next", group = "tag"}),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore,
              {description = "go back", group = "tag"}),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
        end,
        {description = "focus next by index", group = "client"}
    ),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
        end,
        {description = "focus previous by index", group = "client"}
    ),
    awful.key({ modkey,           }, "w", function () mymainmenu:show() end,
              {description = "show main menu", group = "awesome"}),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end,
              {description = "swap with next client by index", group = "client"}),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end,
              {description = "swap with previous client by index", group = "client"}),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end,
              {description = "focus the next screen", group = "screen"}),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end,
              {description = "focus the previous screen", group = "screen"}),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
              {description = "jump to urgent client", group = "client"}),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "go back", group = "client"}),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.spawn(terminal) end,
              {description = "open a terminal", group = "launcher"}),
    awful.key({ modkey, "Control" }, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit,
              {description = "quit awesome", group = "awesome"}),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)          end,
              {description = "increase master width factor", group = "layout"}),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)          end,
              {description = "decrease master width factor", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1, nil, true) end,
              {description = "increase the number of master clients", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1, nil, true) end,
              {description = "decrease the number of master clients", group = "layout"}),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1, nil, true)    end,
              {description = "increase the number of columns", group = "layout"}),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1, nil, true)    end,
              {description = "decrease the number of columns", group = "layout"}),
    awful.key({ modkey,           }, "space", function () awful.layout.inc( 1)                end,
              {description = "select next", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(-1)                end,
              {description = "select previous", group = "layout"}),
    awful.key({ modkey,           }, "i",     function ()   
        local current_screen = awful.screen.focused()
        local laptop_screen = screen.primary

        if current_screen.index == screen.primary then
            ;
        else
            -- need to copy all tags to primary screen
            -- maybe add a copied_from_index property to know where it came from (in case want to sync clients back)
            for k, tag in ipairs(current_screen.tags) do
                naughty.notify({title = al.dump(awful.tag.getdata(tag))})
            end
        end

    end,
              {description = "move tags to other screen", group = "layout"}),

    awful.key({ modkey, "Control" }, "n",
              function ()
                  local c = awful.client.restore()
                  -- Focus restored client
                  if c then
                    c:emit_signal(
                        "request::activate", "key.unminimize", {raise = true}
                    )
                  end
              end,
              {description = "restore minimized", group = "client"}),

    -- Prompt
    awful.key({ modkey },            "r",     function () awful.screen.focused().mypromptbox:run() end,
              {description = "run prompt", group = "launcher"}),

    awful.key({ modkey }, "z",
              function ()
                  awful.prompt.run {
                    prompt       = "See Lua global value: ",
                    textbox      = awful.screen.focused().mypromptbox.widget,
                    exe_callback = function (str)
                        success, val = al.eval(str)
                        naughty.notify({ preset = naughty.config.presets.normal,
                                title = "Lua Value",
                                text = "Input: "..str.."\nSuccess: "..tostring(success).."\nOutput: "..val,
                                timeout = 999999})
                    end,
                    history_path = awful.util.get_cache_dir() .. "/history_eval"
                  }
              end,
              {description = "lua execute prompt", group = "awesome"}),
    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run {
                    prompt       = "Run Lua code: ",
                    textbox      = awful.screen.focused().mypromptbox.widget,
                    exe_callback = function (str)
                        success, val = al.eval(str)
                        naughty.notify({ preset = naughty.config.presets.normal,
                                title = "Lua Output",
                                text = "Input: "..str.."\nSuccess: "..tostring(success).."\nOutput: "..val,
                                timeout = 999999})
                    end,
                    history_path = awful.util.get_cache_dir() .. "/history_eval"
                  }
              end,
              {description = "lua execute prompt", group = "awesome"}),
    -- Menubar
    awful.key({ modkey }, "p", function() menubar.show() end,
              {description = "show the menubar", group = "launcher"})
)

clientkeys = gears.table.join(
    awful.key({ modkey,           }, "f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "toggle fullscreen", group = "client"}),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end,
              {description = "close", group = "client"}),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ,
              {description = "toggle floating", group = "client"}),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
              {description = "move to master", group = "client"}),
    awful.key({ modkey,           }, "o",      function (c) c:move_to_screen()               end,
              {description = "move to screen", group = "client"}),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end,
              {description = "toggle keep on top", group = "client"}),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end ,
        {description = "minimize", group = "client"}),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized = not c.maximized
            c:raise()
        end ,
        {description = "(un)maximize", group = "client"}),
    awful.key({ modkey, "Control" }, "m",
        function (c)
            c.maximized_vertical = not c.maximized_vertical
            c:raise()
        end ,
        {description = "(un)maximize vertically", group = "client"}),
    awful.key({ modkey, "Shift"   }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c:raise()
        end ,
        {description = "(un)maximize horizontally", group = "client"})
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = gears.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = awful.screen.focused()
                        local tag = screen.tags[i]
                        if tag then
                           tag:view_only()
                        end
                  end,
                  {description = "view tag #"..i, group = "tag"}),
        -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = awful.screen.focused()
                      local tag = screen.tags[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end,
                  {description = "toggle tag #" .. i, group = "tag"}),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                          end
                     end
                  end,
                  {description = "move focused client to tag #"..i, group = "tag"}),
        -- Toggle tag on focused client.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:toggle_tag(tag)
                          end
                      end
                  end,
                  {description = "toggle focused client on tag #" .. i, group = "tag"})
    )
end

clientbuttons = gears.table.join(
    awful.button({ }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
    end),
    awful.button({ modkey }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.move(c)
    end),
    awful.button({ modkey }, 3, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.resize(c)
    end)
)

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     screen = awful.screen.preferred,
                     placement = awful.placement.no_overlap+awful.placement.no_offscreen
     }
    },

    -- Floating clients.
    { rule_any = {
        instance = {
          "DTA",  -- Firefox addon DownThemAll.
          "copyq",  -- Includes session name in class.
          "pinentry",
        },
        class = {
          "Arandr",
          "Blueman-manager",
          "Gpick",
          "Kruler",
          "MessageWin",  -- kalarm.
          "Sxiv",
          "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
          "Wpa_gui",
          "veromix",
          "xtightvncviewer"},

        -- Note that the name property shown in xprop might be set slightly after creation of the client
        -- and the name shown there might not match defined rules here.
        name = {
          "Event Tester",  -- xev.
        },
        role = {
          "AlarmWindow",  -- Thunderbird's calendar.
          "ConfigManager",  -- Thunderbird's about:config.
          "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
        }
      }, properties = { floating = true }},

    -- Add titlebars to normal clients and dialogs
    { rule_any = {type = { "normal", "dialog" }
      }, properties = { titlebars_enabled = true }
    },

    -- Set Firefox to always map on the tag named "2" on screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { screen = 1, tag = "2" } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup
      and not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = gears.table.join(
        awful.button({ }, 1, function() -- when clicking on a client's title bar
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.move(c)
        end),
        awful.button({ }, 3, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.resize(c)
        end)
    )

    awful.titlebar(c) : setup {
        { -- Left
            awful.titlebar.widget.iconwidget(c),
            buttons = buttons,
            layout  = wibox.layout.fixed.horizontal
        },
        { -- Middle
            { -- Title
                align  = "center",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },
        { -- Right
            awful.titlebar.widget.floatingbutton (c),
            awful.titlebar.widget.maximizedbutton(c),
            --awful.titlebar.widget.stickybutton   (c),
            --awful.titlebar.widget.ontopbutton    (c),
            awful.titlebar.widget.closebutton    (c),
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", {raise = false})
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}

-- Autorun programs
-- pgrep to find if the program is already running or not
apps = {
    "nm-applet",  	    -- nm-applet is the wireless widget in the top right that controls network-manager
    "redshift", 	    -- redshift changes screen temp to eliminate blue light
    redshiftOptions = "-t 6500:3500"
}

function spawn(app)
    local options = apps[app.."Options"]
    if options == nil then options = '' end
    awful.util.spawn_with_shell("pgrep -u $USER -x " .. app .. " > /dev/null || (" .. app .. ' ' .. options .. " &)")
end
for i = 1, #apps do
    spawn(apps[i])
end
