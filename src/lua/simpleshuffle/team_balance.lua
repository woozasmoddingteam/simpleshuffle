local Shine = Shine
local Plugin = Plugin
local BalanceModule = Plugin.Modules[#Plugin.Modules]

local function sort(a, b)
	return a:GetPlayerSkill() > b:GetPlayerSkill()
end

BalanceModule.ShufflingModes[Plugin.ShuffleMode.HIVE] = function(self, gamerules, targets, teams)
	Log "\n\nShuffling Simply\n\n"
	table.addtable(teams[1], targets)
	table.addtable(teams[2], targets)

	for i = #targets, 1, -1 do
		local target = targets[i]
		if target:isa "Commander" then
			targets[i] = targets[#targets]
			targets[#targets] = nil
		else
			gamerules:JoinTeam(team[i], 0, true, true)
		end
	end

	Log("Targets: %s", targets)
	Log("Teams: %s", teams)

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

			Print("%s to 1", b:GetName())
			Print("%s to 2", a:GetName())
		else
			table.insert(team1, a)
			table.insert(team2, b)
			
			skill1 = skill1 + a:GetPlayerSkill()
			skill2 = skill2 + b:GetPlayerSkill()
			
			Print("%s to 1", a:GetName())
			Print("%s to 2", b:GetName())
		end
	end

	if #targets % 2 == 1 then
		local last = targets[#targets]
		if skill1 > skill2 then
			table.insert(team2, last)
			
			skill2 = skill2 + last:GetPlayerSkill()

			Print("%s to 2", last:GetName())
		else
			table.insert(team1, last)
			
			skill1 = skill1 + last:GetPlayerSkill()

			Print("%s to 1", last:GetName())
		end
	end

	for team_number, team in ipairs {team1, team2} do
		for i = 1, #team do
			Print("Shuffling %s", team[i]:GetName())
			gamerules:JoinTeam(team[i], team_number, true, true)
		end
	end
end
