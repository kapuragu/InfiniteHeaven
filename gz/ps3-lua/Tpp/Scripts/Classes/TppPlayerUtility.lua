--------------------------------------------------------------------------------
--! @file	TppPlayerUtility.lua
--! @brief	プレイヤー関連のユーティリティ Lua 関数群
--------------------------------------------------------------------------------

TppPlayerUtility = {
	
-------------------------------------------------------------------------------------------------
-- Uiアイコンのデバッグ表示
-------------------------------------------------------------------------------------------------
ShowActionIcon = function( icon )
	GrxDebug.Print2D{ life=1, x=550, y= 600, size=15, color=Color(0.5, 1.0, 0.4, 1.0), args={ icon }, }
	GrxDebug.Print2D{ life=1, x=552, y= 602, size=15, color=Color(0.0, 0.0, 0.0, 0.8), args={ icon }, }
end,

-------------------------------------------------------------------------------------------------
-- デバッグ用ダメージ発生装置
-------------------------------------------------------------------------------------------------
DebugBullet = function( chara, attackName, targetGroup )
	local effectName = ""
	local speed = 5
	local penetration = 100.0
	local gravity = 9.8
	local life = 3.0
	local straightRange = 20.0
	local strengthInit = 1.0
	local strengthLast = 0.1
	local strengthStart = 10.0
	local strengthEnd = 90.0
	local penetrateInit = 100.0
	local penetrateLast = 100.0
	local penetrateStart = 0.0
	local penetrateEnd = 0.0
	local stoppingInit = 1.0
	local stoppingLast = 0.1
	local stoppingStart = 10.0
	local stoppingEnd = 90.0
	local wobbling = 0.18

	local charaObj = chara:GetCharacterObject()
	local plgBody = chara:FindPlugin( "ChBodyPlugin" )
	local pos = plgBody:GetControlPosition()
	local hit = Vector3( pos:GetX(), pos:GetY()+0.2, pos:GetZ() )
	local direction = Vector3(0,0,1)

	TppBulletForLuaTest {
		attackTargetName 		= attackName,
		position				= hit,
		direction				= direction,
		speed					= speed,
		penetration				= penetration,
		gravity					= gravity,
		targetGroup				= targetGroup,
		shooter					= NULL,
		life					= life,
		straightRange			= straightRange,
		strengthDecayCurve		= { strengthInit, strengthLast, strengthStart, strengthEnd },
		penetrationDecayCurve	= { penetrateInit, penetrateLast, penetrateStart, penetrateEnd },
		stoppingPowerDecayCurve	= { stoppingInit, stoppingLast, stoppingStart, stoppingEnd },
		wobbling				= wobbling,
	}
end,

-------------------------------------------------------------------------------------------------
-- アクションの分類制限
-------------------------------------------------------------------------------------------------
-- Disable Action
SetDisableActions = function( chara, disableActions, setFlag )
	Fox.Warning("この関数は廃止しました。")
end,

-------------------------------------------------------------------------------------------------
-- アクション制限
-------------------------------------------------------------------------------------------------

-- キプロス病院共通
CyprActionLimitCommon = function( setFlag )
	if setFlag == "Set" then
		TppPlayerUtility.SetDisableActionsWithName {
			name = "CyprCommon",
			disableActions = {
				"DIS_ACT_CQC",
				"DIS_ACT_CARRY",
				"DIS_ACT_FULTON",
				"DIS_ACT_MB_TERMINAL",
				"DIS_ACT_CALL",
				"DIS_ACT_BINOCLE"
			}
		}
	elseif setFlag == "Unset" or setFlag == "Reset" then
		TppPlayerUtility.ResetDisableActionsWithName("CyprCommon")
	else
		Fox.Warning("setFlag must be Set or Unset or Reset")
	end
end,

-- キプロス病院装備変更禁止
CyprActionLimitChangeEquip = function( setFlag )
	if setFlag == "Set" then
		TppPlayerUtility.SetDisableActionsWithName {
			name = "CyprChangeEquip",
			disableActions = {
				"DIS_ACT_CHANGEEQUIP",
			}
		}
	elseif setFlag == "Unset" or setFlag == "Reset" then
		TppPlayerUtility.ResetDisableActionsWithName("CyprChangeEquip")
	else
		Fox.Warning("setFlag must be Set or Unset or Reset")
	end
end,

-- キプロス病院立ち禁止
CyprActionLimitStand = function( setFlag )
	if setFlag == "Set" then
		TppPlayerUtility.SetDisableActionsWithName {
			name = "CyprStand",
			disableActions = {
				"DIS_ACT_STAND",
				"DIS_ACT_DASH",
			}
		}
	elseif setFlag == "Unset" or setFlag == "Reset" then
		TppPlayerUtility.ResetDisableActionsWithName("CyprStand")
	else
		Fox.Warning("setFlag must be Set or Unset or Reset")
	end
end,

-- キプロス病院ダッシュ禁止
CyprActionLimitDash = function( setFlag )
	if setFlag == "Set" then
		TppPlayerUtility.SetDisableActionsWithName {
			name = "CyprDash",
			disableActions = {
				"DIS_ACT_DASH",
			}
		}
	elseif setFlag == "Unset" or setFlag == "Reset" then
		TppPlayerUtility.ResetDisableActionsWithName("CyprDash")
	else
		Fox.Warning("setFlag must be Set or Unset or Reset")
	end
end,

-- キプロス病院匍匐以外禁止
CyprActionLimitExceptCrawl = function( setFlag )
	if setFlag == "Set" then
		TppPlayerUtility.SetDisableActionsWithName {
			name = "CyprExceptCrawl",
			disableActions = {
				"DIS_ACT_DASH",
				"DIS_ACT_STAND",
				"DIS_ACT_SQUAT",
			}
		}
	elseif setFlag == "Unset" or setFlag == "Reset" then
		TppPlayerUtility.ResetDisableActionsWithName("CyprExceptCrawl")
	else
		Fox.Warning("setFlag must be Set or Unset or Reset")
	end
end,

HospitalActionLimit = function( chara, setFlag )
	Fox.Warning("この関数は廃止しました。")
end,

-------------------------------------------------------------------------------------------------
-- 病院用のアクション制限
-- TppPlayerUtility.HospitalDemoActionLimit(chara,"Unset")
-------------------------------------------------------------------------------------------------
HospitalDemoActionLimit = function( chara, setFlag )
	Fox.Warning("この関数は廃止しました。")
end,

-------------------------------------------------------------------------------------------------
-- ヘリに乗るアクション制限
-------------------------------------------------------------------------------------------------
RideHelicopterActionLimit = function( chara, setFlag )

	if DEBUG then
		Fox.Log( "### RideHelicopterActionLimit is called. chara: " .. tostring(chara) .. " flag: " .. setFlag )
	end

	if setFlag ~= "Set" and setFlag ~= "Unset" then
		Fox.Log("RideHelicopterActionLimit: Unknown setFlag")
		return
	end
	if setFlag == "Set" then
		TppPlayerUtility.SetDisableActionsWithName{ name = "DisActRideHelicopter", disableActions = { "DIS_ACT_RIDE_HELICOPTER" } }
	else
		TppPlayerUtility.ResetDisableActionsWithName( "DisActRideHelicopter" )
	end
end,

---------------------------------------------------------------------------------------
-- パッドプラグイン追加
---------------------------------------------------------------------------------------
AddPadPlugin = function( chara )

	local isGz = true
	if TppGameSequence.GetGameTitleName() == "TPP" then
		isGz = false
	end

	-- Tpp/Gz共通
	--[[	
	chara:AddPlugins{
		--PadOperatorプラグイン
		"PLG_PAD_OPERATOR",
		TppPlayerPadOperatorPlugin{
			name			= "PadOperator",
			scripts			=	{
				--"common",			"Tpp/Scripts/Characters/PadOperations/PadTppPlayerCommon.lua",
				--"collectible",		"Tpp/Scripts/Characters/PadOperations/PadTppPlayerCollectible.lua",

				--"attack",			"Tpp/Scripts/Characters/NewPlayer/PadOperations/PadTppNewPlayerAttack.lua",
				--"newCqc",			"Tpp/Scripts/Characters/NewPlayer/PadOperations/PadTppNewPlayerCqcActions.lua",
				--"call",				"Tpp/Scripts/Characters/PadOperations/PadTppPlayerCallActions.lua",

				--"newUpper",			"Tpp/Scripts/Characters/NewPlayer/PadOperations/PadTppNewPlayerUpper.lua",
				--"newMBTerminal",	"Tpp/Scripts/Characters/NewPlayer/PadOperations/PadTppNewPlayerMBTerminal.lua",
				--"newBinocle",		"Tpp/Scripts/Characters/NewPlayer/PadOperations/PadTppNewPlayerBinocle.lua",
				--"newCarry",			"Tpp/Scripts/Characters/NewPlayer/PadOperations/PadTppNewPlayerCarryActions.lua",

			-------------------------------------------------------------
			-- 乗り物/ギミック系
			-------------------------------------------------------------
				--"ridevehiclebase",	"Tpp/Scripts/Characters/PadOperations/PadTppRideVehicleActions.lua",
				--"ridehelicopter",	"Tpp/Scripts/Characters/PadOperations/PadTppPlayerRideHeliActions.lua",
				--"attackstryker",	"Tpp/Scripts/Characters/PadOperations/PadTppAttackStrykerActions.lua",
				--"ridevehicledeck",	"Tpp/Scripts/Characters/PadOperations/PadTppPlayerRideVehicleDeck.lua",

				--"emplacement",		"Tpp/Scripts/Characters/PadOperations/PadTppPlayerUseTurretAction.lua",

			-------------------------------------------------------------
			-- 地形アクション系
			-------------------------------------------------------------
				--"evade",			"Tpp/Scripts/Characters/PadOperations/PadTppPlayerEvadeActions.lua",
				--"gadget",			"Tpp/Scripts/Characters/PadOperations/PadTppPlayerGadgetActions.lua",
				--"pickup",			"Tpp/Scripts/Characters/PadOperations/PadTppPlayerPickUpActions.lua",

				-- なめらかモーション対応アクション
				--"newJumpPath",		"Tpp/Scripts/Characters/NewPlayer/PadOperations/PadTppNewPlayerJumpByPath.lua",
				--"newLadder",		"Tpp/Scripts/Characters/NewPlayer/PadOperations/PadTppNewPlayerLadder.lua",
				--"newEludePath",		"Tpp/Scripts/Characters/NewPlayer/PadOperations/PadTppNewPlayerEludeByPath.lua",
				--"newStepDown",		"Tpp/Scripts/Characters/NewPlayer/PadOperations/PadTppNewPlayerStepDown.lua",
				--"newFencePath",		"Tpp/Scripts/Characters/NewPlayer/PadOperations/PadTppNewPlayerFenceByPath.lua",
				--"newStepOnPath",	"Tpp/Scripts/Characters/NewPlayer/PadOperations/PadTppNewPlayerStepOnByPath.lua",
				--"newBehindPath",	"Tpp/Scripts/Characters/NewPlayer/PadOperations/PadTppNewPlayerBehindByPath.lua",
				--"newWall",			"Tpp/Scripts/Characters/NewPlayer/PadOperations/PadTppNewPlayerWallActions.lua",
				--"newCliff",			"Tpp/Scripts/Characters/NewPlayer/PadOperations/PadTppNewPlayerCliff.lua",

			-------------------------------------------------------------
			-- Cure

			-------------------------------------------------------------
				--"hurt",				"Tpp/Scripts/Characters/PadOperations/PadTppPlayerHurtActions.lua",

			-------------------------------------------------------------
			-- Basic
			-------------------------------------------------------------
				--"default",			"Tpp/Scripts/Characters/NewPlayer/PadOperations/PadTppNewPlayerBasic.lua",

			-------------------------------------------------------------
			-- ダメージ系
			-------------------------------------------------------------
				--"damage",			"Tpp/Scripts/Characters/PadOperations/PadTppPlayerDamageActions.lua",

			-------------------------------------------------------------
			-- カメラ系
			-------------------------------------------------------------
				--"newSubjective",	"Tpp/Scripts/Characters/PadOperations/PadTppPlayerNewSubjectiveCamera.lua",

				-- カメラ切り替え管理
				--"cameraChange",	"Tpp/Scripts/Characters/PadOperations/PadTppPlayerCameraChange.lua",
			},
		},
	}
	--]]
	
	-- DEBUG用
	if DEBUG then
		--[[
		local plgPad = chara:FindPluginByName("PadOperator")
		plgPad:AddPadScript{
			name = "debug",
			script = "Tpp/Scripts/Characters/PadOperations/PadTppPlayerDebug.lua"
		}

		if isGz == false then
			plgPad:AddPadScript{
				name = "ridecharacter",
				script = "Tpp/Scripts/Characters/PadOperations/PadTppRideCharacterActions.lua"
			}
		end
		--]]
	end

	-- Tpp専用
	if isGz == false then
		--[[
		local plgPad = chara:FindPluginByName("PadOperator")
		plgPad:AddPadScript{
			name = "counter",
			script = "Tpp/Scripts/Characters/NewPlayer/PadOperations/PadTppNewPlayerCounterActions.lua"
		}
		plgPad:AddPadScript{
			name = "carryItem",
			script = "Tpp/Scripts/Characters/PadOperations/PadTppPlayerCarryItemActions.lua"
		}
		plgPad:AddPadScript{
			name = "ridehorse",
			script = "Tpp/Scripts/Characters/PadOperations/PadTppPlayerRideHorseActions.lua"
		}
		plgPad:AddPadScript{
			name = "ridemgm",
			script = "Tpp/Scripts/Characters/PadOperations/PadTppRideMgmActions.lua"
		}
		plgPad:AddPadScript{
			name = "pipe",
			script = "Tpp/Scripts/Characters/PadOperations/PadTppPlayerPipeActions.lua"
		}
		plgPad:AddPadScript{
			name = "climbPath",
			script = "Tpp/Scripts/Characters/PadOperations/PadTppPlayerClimbPathActions.lua"
		}
		plgPad:AddPadScript{
			name = "fulton",
			script = "Tpp/Scripts/Characters/PadOperations/PadTppPlayerFultonActions.lua"
		}
		--]]
	end
end,

---------------------------------------------------------------------------------------
-- カメラプラグイン追加
-- カメラ登録はローカルプレイヤーだけ
---------------------------------------------------------------------------------------
AddCameraPlugin = function( chara )

	chara:AddPlugins{

		-- カメラ共通ワーク
		"PLG_CAMERACOMMONWORK",
		TppCameraCommonWork {
			priority		= "CameraCommonWork",
			name			= "CameraCommonWork",
		},

		--カットインカメラプラグイン
		"PLG_CUT_IN_CAMERA",
		TppCutInCameraPlugin{
			name			= "CutInCamera",
			cameraPriority	= "Game",
			exclusiveGroups	= { TppPluginExclusiveGroup.Camera },
			priority		= "CutInCamera",
			isSleepStart	= true,
		},

		--新AroundCamera(ケツカメ)プラグイン
		"PLG_CAMERAMAN_CAMERA",
		TppCameramanCameraPlugin{
			name			= "NewAroundCamera",
			cameraPriority	= "Game",
			exclusiveGroups	= { TppPluginExclusiveGroup.Camera },
			priority		= "AroundCamera",

			components		= {
				TppCameraComponentShakeCamera{},	-- カメラ揺れ
				TppCameraComponentTargetConstrainCamera{},	-- ゆるコンカメラ
				TppCameraComponentRideHeli{},		-- ヘリアクション
			},

			distance		= 5.5,				-- 注視点からの距離設定
			focalLength		= 19.2,				-- 焦点距離設定
			distanceInterpRate	= 0.975,

			paramScript = "/Assets/tpp/level_asset/chara/player/CameraAroundParams.lua",

			isSleepStart	= true,
		},

		--新TpsCamera(肩越しカメラ)プラグイン
		"PLG_NEW_TPS_CAMERA",
		TppNewTpsCameraPlugin{
			name			= "NewTpsCamera",
			cameraPriority	= "Game",
			exclusiveGroups	= { TppPluginExclusiveGroup.Camera },
			priority		= "TpsCamera",

			components		= {
				TppCameraComponentEmplacement{},			-- 設置物ギミックを使う時のパラメタ反映（ギミック角度に従う）
				TppCameraComponentVehicleTurret{},			-- 戦車
			},

			distance		= 1.35,				-- 注視点からの距離設定
			offset			= Vector3( -0.40, 0.55, 0 ),-- カメラオフセット設定
			focalLength		= 19.2,							-- 焦点距離設定
			defaultFocalLength = 24.0,
			aimRootOffset	= 0.8,	-- Aim原点位置オフセット距離

			paramScript = "/Assets/tpp/level_asset/chara/player/CameraTpsParams.lua",

			isSleepStart	= true,
		},

		--新SubjectiveCamera(主観カメラ)プラグイン
		"PLG_NEW_SUBJECTIVE_CAMERA",
		TppNewSubjectiveCameraPlugin{
			name			= "NewSubjectiveCamera",
			cameraPriority	= "Game",
			exclusiveGroups	= { TppPluginExclusiveGroup.Camera },
			priority		= "SubjectiveCamera",
			
			components		= {
				TppCameraComponentEmplacement{},			-- 設置物ギミックを使う時のパラメタ反映（ギミック角度に従う）
			},
			
			defaultFocalLength = 24.0,
			attachPointType	= "Head",
			--attachPointName	= "SKL_004_HEAD",
			aimRootOffset	= 0.0,	-- Aim原点位置オフセット距離

			nearClipMin		= 0.05,
			nearClipMax		= 0.5,
			zoomForceMax	= 10.0,

			paramScript = "/Assets/tpp/level_asset/chara/player/CameraSubjectiveParams.lua",

			isSleepStart	= true,
		},
	}

	chara:AddPlugins{

		-- ハイスピードカメライベント用プラグイン
		"PLG_HIGHSPEEDCAMERA_EVENT_OPERATOR",
		TppHighSpeedCameraOperatorPlugin{
			name				= "HighSpeedCameraEventOperator",
			baseRateReduceTime	= 20,
			cameraRotInterp		= 0.93,
			cameraPosInterp		= 0.5,
			cameraFocusInterp	= 0.95,
			cameraFocalLength	= 40.0,
			cameraAperture		= 3.0,
			cameraRotZ			= foxmath.DegreeToRadian( 2 ),
			cameraOffset		= Vector3( -1.2, 1.0, -5.0 ),
			cameraOffsetDist	= 5.0,
			cameraBezierControlTime	= 0.3,
			cameraBezierControlRate	= 0.9,
			debugCallScript = false,
			isSleepStart	= true,
		},
	}

end,

----------------------------------------------------------------
-- 指定キャラクターの一番近いConnectPointを指定テーブルから探す
-- chara : 距離チェックの基準になるキャラクター
-- cnpOwner：ConnectPointを持っているキャラクター
-- cnpTable：比較するConnectPoint名前のテーブル（例：{ "cnp_1", "cnp_2" }）
----------------------------------------------------------------
FindNearestConnectPoint = function( chara, cnpOwner, cnpTable )

	-- make distance table for each CNP from Character
	local distTable = {}
	local charaPos = chara:GetPosition()
	local plgBody = cnpOwner:FindPlugin( "ChBodyPlugin" )

	for i, name in ipairs( cnpTable ) do
		local isValid, mtx = plgBody:GetValidConnectPointMatrix( name )
		if isValid then
			local cnpPos = mtx:GetTranslation()
			local distanceFromCharaToCNP = ( cnpPos - charaPos ):GetLength()
			table.insert( distTable, distanceFromCharaToCNP )
			--Fox.Log( "Table Insert " .. name .. " distanceFromCharaToCNP " .. distanceFromCharaToCNP )
		end

	end

	-- Compare and choose the nearest CNP from Character
	local nearestDist = distTable[1]
	local nearestIndex = 1
	for i, dist in ipairs( distTable ) do
		if nearestDist > dist then
			nearestDist = dist
			nearestIndex = i
			--Fox.Log( "nearestIndex " .. nearestIndex .. " nearestDist " .. nearestDist )
		end
	end

	-- Return
	return cnpTable[nearestIndex]
end,

} -- TppPlayerUtility

