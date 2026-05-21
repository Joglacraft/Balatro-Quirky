QRK = SMODS.current_mod

QRK.calculate = function(self, context)
	for k, v in pairs(G.jokers.cards) do
		local key = v.config.center.key
		if G.localization.descriptions.Quirky[key] then
			if context.end_of_round and context.main_eval then
				G.PROFILES[G.SETTINGS.profile].dequirk[key] = true
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
