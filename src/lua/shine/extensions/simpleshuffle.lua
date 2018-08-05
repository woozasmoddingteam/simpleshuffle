local Shine = Shine
local Plugin = {
	Conflicts = {
		DisableThem = {
			"voterandom"
		}
	}
}

local function sort(a, b)
	return a:GetPlayerSkill() > b:GetPlayerSkill()
end

function pair_sort(self, gamerules, targets, teams)
	table.addtable(teams[1], targets)
	table.addtable(teams[2], targets)

	local team1 = {}
	local team2 = {}

	local skill1 = 0
	local skill2 = 0

	table.sort(targets, sort)

	for i = 1, math.floor(#targets / 2) * 2, 2 do
		local a = targets[i]
		local b = targets[i+1]

		if skill1 > skill2 then
			table.insert(team2, a)
			table.insert(team1, b)

			skill2 = skill2 + a:GetPlayerSkill()
			skill1 = skill1 + b:GetPlayerSkill()
		else
			table.insert(team1, a)
			table.insert(team2, b)
			
			skill1 = skill1 + a:GetPlayerSkill()
			skill2 = skill2 + b:GetPlayerSkill()
		end
	end

	if #targets % 2 == 1 then
		local last = targets[#targets]
		if skill1 > skill2 then
			table.insert(team2, last)

			skill2 = skill2 + last:GetPlayerSkill()
		else
			table.insert(team1, last)
			
			skill1 = skill1 + last:GetPlayerSkill()
		end
	end

	for team_number, team in ipairs {team1, team2} do
		for i = 1, #team do
			gamerules:JoinTeam(team[i], team_number, true, true)
		end
	end
end

function Plugin:Initialise()
	self.BaseClass.Initialise(self)

	self.ShufflingModes[self.ShuffleMode.HIVE] = pair_sort
end

Shine:RegisterExtension("simpleshuffle", Plugin, {
	Base = "voterandom"
})
