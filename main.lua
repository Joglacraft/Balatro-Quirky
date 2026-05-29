QRK = SMODS.current_mod

for k, v in pairs(QRK.config.mode) do
    if v == true then
        QRK.current_mode_option = k
    end
end

G.FUNCS.qrk_option_cycle = function(args)
  	if not args or not args.cycle_config then return end
    if args.cycle_config.current_option then
        for k, v in pairs(QRK.config.mode) do
            if k == args.cycle_config.current_option then
                QRK.config.mode[k] = true
                QRK.current_mode_option = k
            else
                QRK.config.mode[k] = false
            end
        end
    end
end

QRK.config_tab = function()
    local mode_pages = {}
    for i=1, #QRK.config.mode do
        table.insert(mode_pages, localize("qrk_mode_"..i))
    end
    return { n = G.UIT.ROOT, config = { r = 0.1, minw = 8, align = "tm", colour = G.C.BLACK },nodes = {
            { n = G.UIT.R, config = { align = "cm", padding = 0.2 }, nodes = {
                {n = G.UIT.C, config = { align = "cm",}, nodes = {
                    {n = G.UIT.R, config = { align = "cm"}, nodes = {
                        {n = G.UIT.C, config = { align = "cm" }, nodes = {
                            create_option_cycle({options = mode_pages, w = 4.5, cycle_shoulders = true, opt_callback = 'qrk_option_cycle', current_option = QRK.current_mode_option, colour = G.C.RED, no_pips = true, focus_args = {snap_to = true, nav = 'wide'}}),
                        }},
                        {n = G.UIT.C, config = { align = "cm", minw=1, minh=1, colour = G.C.RED, r = 0.1, button = "qrk_mode_guide", emboss = 0.1 }, nodes = {
                            {n = G.UIT.T, config = {text = "?", colour = G.C.UI.TEXT_LIGHT, scale = 1}}
                        }}
                    }},
                }},
            }},
        }
    }
end

G.FUNCS.qrk_mode_guide = function ()
    local loc = {}
    local guide = {}
	localize{type = 'other', key = "qrk_mode_guide", default_col = G.C.UI.TEXT_LIGHT, nodes = loc, vars = {}}
    guide = {transparent_multiline_text(loc)}
    print(guide)
    G.FUNCS.overlay_menu({
        definition = create_UIBox_generic_options({
            contents = {
                {n=G.UIT.C, config = {align = "cm", r = 0.1, colour = G.C.BLACK}, nodes=
					guide
				}
            }
        })     
	})
end

QRK.calculate = function(self, context)
	for k, v in pairs(G.jokers.cards) do
		local key = v.config.center.key
		if QRK.config.mode[1] then
			if G.localization.descriptions.Quirky[key] then
				if context.end_of_round and context.main_eval then
					if not QRK.table_contains(G.PROFILES[G.SETTINGS.profile].dequirk, key) then
						G.PROFILES[G.SETTINGS.profile].dequirk[#G.PROFILES[G.SETTINGS.profile].dequirk+1] = key
					end
				end
			end
		end
	end
end

function QRK.table_contains(table, element) 
	if table[element] then return true end
     for _, value in pairs(table) do
         if value == element then
            return true
        end
    end
    return false
end

local r_click = Controller.queue_R_cursor_press
function Controller:queue_R_cursor_press(x, y)
    local target = (self.HID.touch and self.cursor_hover.target) or self.hovering.target or self.focused.target
    if QRK.config.mode[3] and target.config and target.config.center then
        if target.config.center.quirked then
            target.config.center.quirked = false
        else
            target.config.center.quirked = true
        end
        print(target.config.center.quirked)
    end
    return r_click(self, x, y)
end