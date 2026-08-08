--InfZooSoldier.lua
local this={}

local SendCommand = GameObject.SendCommand
local GetGameObjectId = GameObject.GetGameObjectId

this.enableIvars={
  "mbZooEnableSoldiers",
}

this.registerIvars={
  "mbZooEnableSoldiers",
}

this.mbZooEnableSoldiers={
  save=IvarProc.CATEGORY_EXTERNAL,
  range=Ivars.switchRange,
  settingNames="set_switch",
}

this.langStrings={
  eng={
    mbZooEnableSoldiers="Enable soldiers on Zoo",
  },
  help={
    eng={
        mbZooEnableSoldiers="Adds soldiers to the Animal Conservation Platform.",
    },
  },
}

this.ZOO_ENEMY_COUNT = 8

--TODO ivars
function this.IsEnable()
	return Ivars.mbZooEnableSoldiers:Is(1)
end

function this.IsZooMission(missionCode)
	missionCode = missionCode or vars.missionCode
	if missionCode==TppDefine.SYS_MISSION_ID.MTBS_ZOO then
		return true
	end
	return false
end

--custom enemy subscript:
local enemyModule={}
enemyModule.soldierDefine = {
	zoo_mtbs_cp = {
		"sol_mtbs_0000",
		"sol_mtbs_0001",
		"sol_mtbs_0002",
		"sol_mtbs_0003",
		"sol_mtbs_0004",
		"sol_mtbs_0005",
		"sol_mtbs_0006",
		"sol_mtbs_0007",
	},
}
enemyModule.routeSets = {
	zoo_mtbs_cp = {
		priority = {
			"groupA",
			"groupB",
			"groupC",
			"groupD",
		},
		sneak_day = {
			groupA = {
				"rt_zoopl0_d_0000",
				"rt_zoopl0_d_0001",
			},
			groupB = {
				"rt_zoopl1_d_0000",
				"rt_zoopl1_d_0001",
			},
			groupC = {
				"rt_zoopl2_d_0000",
				"rt_zoopl2_d_0001",
			},
			groupD = {
				"rt_zoopl3_d_0000",
				"rt_zoopl3_d_0001",
			},
		},
		sneak_night= {
			groupA = {
				"rt_zoopl0_d_0000",
				"rt_zoopl0_d_0001",
			},
			groupB = {
				"rt_zoopl1_d_0000",
				"rt_zoopl1_d_0001",
			},
			groupC = {
				"rt_zoopl2_d_0000",
				"rt_zoopl2_d_0001",
			},
			groupD = {
				"rt_zoopl3_d_0000",
				"rt_zoopl3_d_0001",
			},
		},
	},
}
enemyModule.SetUpEnemy = function()
	InfCore.Log("*** enemu.lua f30150 SetupEnemy ***")

	SendCommand( { type="TppCommandPost2", index=0 }, { id = "SetFriendlyCp" } )

	SendCommand( { type="TppSoldier2" }, { id="SetFriendly", enabled=true } )

	local mbStaffIds = TppMotherBaseManagement.GetOutOnMotherBaseStaffs{ sectionId = TppMotherBaseManagementConst.SECTION_SECURITY, }
  
	mvars.mbStaffCount = #mbStaffIds
  
	local faceIdList = {}
	for index, staffId in pairs( mbStaffIds ) do
		local faceId = TppMotherBaseManagement.StaffIdToFaceId{ staffId = staffId }
		if faceIdList[index] == nil then
			faceIdList[index] = faceId
		end
		
		if not enemyModule.soldierDefine.zoo_mtbs_cp[index+1] then
			break
		end
	end
  	for index, enemyId in ipairs( enemyModule.soldierDefine.zoo_mtbs_cp ) do
		local gameObjectId = GetGameObjectId( enemyId )
		if index <= mvars.mbStaffCount then
			if faceIdList[index] then
				TppEneFova.ApplyMTBSUniqueSetting( gameObjectId, faceIdList[index] )
			end
		else
			SendCommand( gameObjectId, { id = "SetEnabled", enabled = false, } )
		end
  	end

	SendCommand( { type="TppSoldier2" }, { id = "SetEmblemType", type = 1 } )
	
	TppEnemy.SetSaluteVoiceList()
end

--supplanting the enemy subscript from the outside:
function this.OnAllocateTop(missionTable)
	if not this.IsEnable() then
		return
	end
    if not this.IsZooMission() then
		return
    end
	if not missionTable.enemy then
		--enemy subscript doesn't exist
		missionTable.enemy=enemyModule
	else
		--enemy subscript exists, inject individually 
		--and log cause it shouldn't be like this in vanilla
		InfCore.Log("Zoo enemy: enemy subscript already exists!")
		for key, value in pairs(enemyModule) do
			if missionTable.enemy[key] then
				InfCore.Log("Zoo enemy: "..tostring(key).." already exists!")
			end
			missionTable.enemy[key]=value
		end
	end
end

this.packages={
    mbZooEnableSoldiers="/Assets/tpp/pack/mission2/ih/f30150_enemy.fpk"--tex still relies on totalCount in f30050_npc.fox2
}

--add pack with extra locators
function this.AddMissionPacks(missionCode,packPaths)
	if not this.IsEnable() then
		return
	end
    if not this.IsZooMission() then
		return
    end
	local _packPaths=packPaths
	for i, packPath in ipairs(_packPaths) do
		if packPath==TppDefine.MISSION_COMMON_PACK.HELICOPTER then
			table.insert(packPaths,i+1,TppDefine.MISSION_COMMON_PACK.DD_SOLDIER_WAIT)
			table.insert(packPaths,i+2,this.packages.mbZooEnableSoldiers)
			break
		end
	end
end

--copied from 30250
function this.fovaSetupFunc(locationName,missionId)
	if not this.IsEnable() then
		return
	end
	local faces={}
	--mtbsFaceSetupFuncs
	local securityStaff=TppMotherBaseManagement.GetOutOnMotherBaseStaffs{sectionId=TppMotherBaseManagementConst.SECTION_SECURITY}
	--local numStaff=#securityStaff--UNUSED
	local numSoldiers = this.ZOO_ENEMY_COUNT --rlc changed from 30250's 7
	local faceCounts={}
	for n,staffId in pairs(securityStaff)do
	  local staffFaceId=TppMotherBaseManagement.StaffIdToFaceId{staffId=staffId}
	  if faceCounts[staffFaceId]==nil then
		faceCounts[staffFaceId]=1
	  else
		faceCounts[staffFaceId]=faceCounts[staffFaceId]+1
	  end
	  if n==numSoldiers then
		break
	  end
	end
	for faceId,faceCount in pairs(faceCounts)do
	  table.insert(faces,{faceId,faceCount,faceCount,0})
	end
	table.insert(faces,{TppEnemyFaceId.dds_balaclava6,numSoldiers,numSoldiers,0})

	TppSoldierFace.OverwriteMissionFovaData{face=faces}
end

return this