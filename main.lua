QRK = SMODS.current_mod

QRK.config_tab = function()
    return {
        n = G.UIT.ROOT,
        config = { r = 0.1, minw = 8, align = "tm", padding = 0.2, colour = G.C.BLACK },
        nodes = {
            {n = G.UIT.R, config = { padding = 0.2 }, nodes = {
                {n = G.UIT.C, config = { align = "cm" }, nodes = {
                    {n = G.UIT.R, config = { align = "cm", padding = 0.01 }, nodes = {
                        create_toggle({ label = "I don't want to know the effects", ref_table = QRK.config, ref_value = 'vagueslop_mode' })
                    }},
					{ n = G.UIT.R, config = { align = "cm", padding = 0.01 }, nodes = {
                       {n = G.UIT.T, config = {text = "Jokers keep their quips instead of telling the info you need, duh", colour = G.C.UI.TEXT_LIGHT, scale = 0.3}}
                    }},
                }},
            }},
        }
    }
end


QRK.calculate = function(self, context)
	for k, v in pairs(G.jokers.cards) do
		local key = v.config.center.key
		if not QRK.config.vagueslop_mode then
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
