 TppPlayerCallbackScript = {

StartCameraAnimation = function( eventStartFrame, currentPlayFrame,
	intValue1, intValue2, intValue3,
	floatValue1, floatValue2, floatValue3,
	stringIdValue1, stringIdValue2, stringIdValue3 )

	TppPlayerCallbackScript._StartCameraAnimation( eventStartFrame, currentPlayFrame, stringIdValue1, true, false, intValue1, false, true)
end,

StartCameraAnimationNoRecover = function( eventStartFrame, currentPlayFrame,
	intValue1, intValue2, intValue3,
	floatValue1, floatValue2, floatValue3,
	stringIdValue1, stringIdValue2, stringIdValue3 )
	
	-- 乗り物系は後ろにカメラを戻す処理とバッティングするので元の方向にカメラを戻す処理を切る
	TppPlayerCallbackScript._StartCameraAnimation( eventStartFrame, currentPlayFrame, stringIdValue1, false, false, intValue1, true)
end,

StartCameraAnimationNoRecoverNoCollsion = function( eventStartFrame, currentPlayFrame,
	intValue1, intValue2, intValue3,
	floatValue1, floatValue2, floatValue3,
	stringIdValue1, stringIdValue2, stringIdValue3 )
	
	-- 乗り物系は後ろにカメラを戻す処理とバッティングするので元の方向にカメラを戻す処理を切る
	TppPlayerCallbackScript._StartCameraAnimation( eventStartFrame, currentPlayFrame, stringIdValue1, false, true, intValue1)
end,

-- 武器奪いはストックチェンジでカメラを変える
StartCameraAnimationForSnatchWeapon = function( eventStartFrame, currentPlayFrame,
	intValue1, intValue2, intValue3,
	floatValue1, floatValue2, floatValue3,
	stringIdValue1, stringIdValue2, stringIdValue3 )

	if ( TppPlayerUtility.GetStock() == 0 ) then
		TppPlayerCallbackScript._StartCameraAnimationUseFileSetName( eventStartFrame, currentPlayFrame, "CqcSnatchAssaultRight", true, false)
	else
		TppPlayerCallbackScript._StartCameraAnimationUseFileSetName( eventStartFrame, currentPlayFrame, "CqcSnatchAssaultLeft", true, false)
	end
end,

StopCameraAnimation = function( eventStartFrame, currentPlayFrame,
	intValue1, intValue2, intValue3,
	floatValue1, floatValue2, floatValue3,
	stringIdValue1, stringIdValue2, stringIdValue3 )

	--print("StopCameraAnimation")

	TppPlayerUtility.RequestToStopCameraAnimation{
		fileSet = stringIdValue1,
	}

end,

StartCureDemoEffectStart = function( eventStartFrame, currentPlayFrame,
	intValue1, intValue2, intValue3,
	floatValue1, floatValue2, floatValue3,
	stringIdValue1, stringIdValue2, stringIdValue3 )

--	TppDemoUtility.Play("cureCutInCamEffect")
end,

----------------------------------------------------
-- Set camera noise for each action
----------------------------------------------------

-- 汎用カメラノイズ：まとめてパラメータの調整ができないのでなるだけ使わない
SetCameraNoise = function( eventStartFrame, currentPlayFrame,
	intValue1, intValue2, intValue3,
	floatValue1, floatValue2, floatValue3,
	stringIdValue1, stringIdValue2, stringIdValue3 )

	-- 終了時間はEndFrameから計算できるようにしたい
	TppPlayerCallbackScript._SetCameraNoise( floatValue1, floatValue1, floatValue2 )

end,

-- 梯子
SetCameraNoiseLadder = function( eventStartFrame, currentPlayFrame,
	intValue1, intValue2, intValue3,
	floatValue1, floatValue2, floatValue3,
	stringIdValue1, stringIdValue2, stringIdValue3 )

	TppPlayerCallbackScript._SetCameraNoise( 0.2, 0.2, 0.1 )

end,

-- エルード
SetCameraNoiseElude = function( eventStartFrame, currentPlayFrame,
	intValue1, intValue2, intValue3,
	floatValue1, floatValue2, floatValue3,
	stringIdValue1, stringIdValue2, stringIdValue3 )

	Fox.Log("TppPlayerCallbackScript.SetCameraNoiseElude()")
	TppPlayerCallbackScript._SetCameraNoise( 0.2, 0.2, 0.1 )

end,

-- よろけダメージ
SetCameraNoiseDamageBend = function( eventStartFrame, currentPlayFrame,
	intValue1, intValue2, intValue3,
	floatValue1, floatValue2, floatValue3,
	stringIdValue1, stringIdValue2, stringIdValue3 )

	TppPlayerCallbackScript._SetCameraNoise( 0.5, 0.5, 0.2 )

end,

-- 吹き飛びダメージ
SetCameraNoiseDamageBlow = function( eventStartFrame, currentPlayFrame,
	intValue1, intValue2, intValue3,
	floatValue1, floatValue2, floatValue3,
	stringIdValue1, stringIdValue2, stringIdValue3 )

	Fox.Log("TppPlayerCallbackScript.SetCameraNoiseDamageBlow()")
	TppPlayerCallbackScript._SetCameraNoise( 0.5, 0.5, 0.5 )

end,

-- 死亡ダメージ開始
SetCameraNoiseDamageDeadStart = function( eventStartFrame, currentPlayFrame,
	intValue1, intValue2, intValue3,
	floatValue1, floatValue2, floatValue3,
	stringIdValue1, stringIdValue2, stringIdValue3 )

	TppPlayerCallbackScript._SetCameraNoise( 0.45, 0.45, 0.52 )

end,

-- 落下ダメージ
SetCameraNoiseFallDamage = function( eventStartFrame, currentPlayFrame,
	intValue1, intValue2, intValue3,
	floatValue1, floatValue2, floatValue3,
	stringIdValue1, stringIdValue2, stringIdValue3 )

	TppPlayerCallbackScript._SetCameraNoise( 1.0, 0.4, 0.5 )

end,

-- ダッシュ　壁止まり
SetCameraNoiseDashToWallStop = function( eventStartFrame, currentPlayFrame,
	intValue1, intValue2, intValue3,
	floatValue1, floatValue2, floatValue3,
	stringIdValue1, stringIdValue2, stringIdValue3 )

	TppPlayerCallbackScript._SetCameraNoise( 0.5, 0.5, 0.2 )

end,

-- 段差上り
SetCameraNoiseStepOn = function( eventStartFrame, currentPlayFrame,
	intValue1, intValue2, intValue3,
	floatValue1, floatValue2, floatValue3,
	stringIdValue1, stringIdValue2, stringIdValue3 )

	Fox.Log("TppPlayerCallbackScript.SetCameraNoiseStepOn()")

	TppPlayerCallbackScript._SetCameraNoise( 0.3, 0.3, 0.1 )

end,

-- 段差降り
SetCameraNoiseStepDown = function( eventStartFrame, currentPlayFrame,
	intValue1, intValue2, intValue3,
	floatValue1, floatValue2, floatValue3,
	stringIdValue1, stringIdValue2, stringIdValue3 )

	Fox.Log("TppPlayerCallbackScript.SetCameraNoiseStepDown()")

	local levelX = 0.0
	local levelY = 0.0

	-- パラメータが設定されていたらそちらの振幅を利用する
	if ( floatValue1 > 0 ) then
		levelX = floatValue1
		levelY = floatValue1 * 0.25
	else
		levelX = 0.225
		levelY = 0.057
	end

	TppPlayerCallbackScript._SetCameraNoise( levelX, levelY, 0.11 )

end,

-- ジャンプ終了
SetCameraNoiseStepJumpEnd = function( eventStartFrame, currentPlayFrame,
	intValue1, intValue2, intValue3,
	floatValue1, floatValue2, floatValue3,
	stringIdValue1, stringIdValue2, stringIdValue3 )

	Fox.Log("TppPlayerCallbackScript.SetCameraNoiseStepJumpEnd / floatValue1 = " .. floatValue1 )

	local levelX = 0.0
	local levelY = 0.0

	-- パラメータが設定されていたらそちらの振幅を利用する
	if ( floatValue1 > 0 ) then
		levelX = floatValue1
		levelY = floatValue1 * 0.25
	else
		levelX = 0.225
		levelY = 0.057
	end

	TppPlayerCallbackScript._SetCameraNoise( levelX, levelY, 0.2 )

end,

-- ジャンプエルード
SetCameraNoiseStepJumpToElude = function( eventStartFrame, currentPlayFrame,
	intValue1, intValue2, intValue3,
	floatValue1, floatValue2, floatValue3,
	stringIdValue1, stringIdValue2, stringIdValue3 )

	Fox.Log("TppPlayerCallbackScript.SetCameraNoiseStepJumpToElude")
	TppPlayerCallbackScript._SetCameraNoise( 0.4, 0.4, 0.4 )

end,

-- 車輌衝突
SetCameraNoiseVehicleCrash = function( eventStartFrame, currentPlayFrame,
	intValue1, intValue2, intValue3,
	floatValue1, floatValue2, floatValue3,
	stringIdValue1, stringIdValue2, stringIdValue3 )

	Fox.Log("TppPlayerCallbackScript.SetCameraNoiseVehicleCrash()")
	TppPlayerCallbackScript._SetCameraNoise( 0.5, 0.5, 0.5 )

end,

-- デモカメラの着かないCQC用
SetCameraNoiseCqcHit = function( eventStartFrame, currentPlayFrame,
	intValue1, intValue2, intValue3,
	floatValue1, floatValue2, floatValue3,
	stringIdValue1, stringIdValue2, stringIdValue3 )

	Fox.Log("TppPlayerCallbackScript.SetCameraNoiseCqcHit()")
	TppPlayerCallbackScript._SetCameraNoise( 0.5, 0.5, 0.4 )

end,

-- 射撃時ノイズ
SetCameraNoiseOnMissileFire = function( eventStartFrame, currentPlayFrame,
	intValue1, intValue2, intValue3,
	floatValue1, floatValue2, floatValue3,
	stringIdValue1, stringIdValue2, stringIdValue3 )

	Fox.Log("TppPlayerCallbackScript.SetCameraNoiseOnMissileFire()")
	local levelX = 0.5
	local levelY = 0.5
	local time = 0.75
	local decayRate = 0.08
	local randomSeed = 12345
	local enableCamera = { 0, 1, 2 }

	TppPlayerUtility.SetCameraNoise{
		levelX = levelX,
		levelY = levelY,
		time = time,
		decayRate = decayRate,
		randomSeed = randomSeed,
		enableCamera = enableCamera,
	}
end,

-- 対空機関砲乗車時ノイズ
SetCameraNoiseOnRideOnAntiAircraftGun = function( eventStartFrame, currentPlayFrame,
	intValue1, intValue2, intValue3,
	floatValue1, floatValue2, floatValue3,
	stringIdValue1, stringIdValue2, stringIdValue3 )

	Fox.Log("TppPlayerCallbackScript.SetCameraNoiseOnRideOnAntiAircraftGun()")
	local levelX = 0.2
	local levelY = 0.2
	local time = 0.3
	local decayRate = 0.08
	local randomSeed = 12345
	local enableCamera = { 0, 1, 2 }

	TppPlayerUtility.SetCameraNoise{
		levelX = levelX,
		levelY = levelY,
		time = time,
		decayRate = decayRate,
		randomSeed = randomSeed,
		enableCamera = enableCamera,
	}
end,

-- 崖落ち強制死亡
SetNonAnimationCutInCameraFallDeath = function()

	local VehicleId = TppPlayerUtility.GetRidingVehicleCharacterId()

	Fox.Log( "*** GZCommon:SetNonAnimationCutInCameraFallDeath *** VehicleId = " .. VehicleId )

	if ( VehicleId ~= "" ) then
		local playerChara = TppPlayerUtility.GetLocalPlayerCharacter()
		local playerPos = playerChara:GetPosition()
		local MaxInterpCameraHeight = 5.3
		local MinInterpCameraHeight = 3.8
		
		-- カメラの高さをプレイヤーの高さから逆算
		local SetCameraY = -2.3		-- 海から十分遠いときはこの値
		if ( playerPos:GetY() < MaxInterpCameraHeight ) then
			if ( playerPos:GetY() < MinInterpCameraHeight ) then
				SetCameraY = 3.3	-- 海から十分近いときは固定値
			else
				-- 海から微妙に遠いときは線形補間
				SetCameraY = 3.3 - ( playerPos:GetY() - MinInterpCameraHeight) / (MaxInterpCameraHeight - MinInterpCameraHeight )* 5.6
			end
		end
	
		-- 車輌に乗っているとき
		TppPlayerUtility.RequestToPlayCameraNonAnimation{
			characterId = VehicleId,
			isFollowPos = false,
			isFollowRot = true,
			followTime = 0.1,
			useCharaPosRot = true,
			rotX = -30.0,
			rotY = 45.0,
			candidateRotX = 0.0,
			candidateRotY = 30.0,
			offsetPos = Vector3( -4.0, SetCameraY, -8.0),
			focalLength = 21.0,
		}
	else
		local playerChara = TppPlayerUtility.GetLocalPlayerCharacter()
		local playerPos = playerChara:GetPosition()
		local MaxInterpCameraHeight = 5.3
		local MinInterpCameraHeight = 3.8
		
		-- カメラの高さをプレイヤーの高さから逆算
		local SetCameraY = -2.3		-- 海から十分遠いときはこの値
		if ( playerPos:GetY() < MaxInterpCameraHeight ) then
			if ( playerPos:GetY() < MinInterpCameraHeight ) then
				SetCameraY = 1.5	-- 海から十分近いときは固定値
			else
				-- 海から微妙に遠いときは線形補間
				SetCameraY = 1.5 - ( playerPos:GetY() - MinInterpCameraHeight) / (MaxInterpCameraHeight - MinInterpCameraHeight )* 3.8
			end
		end
		
		Fox.Log( "*** GZCommon:SetNonAnimationCutInCameraFallDeath @player *** player.GetY() = " .. playerPos:GetY() .. "; SetCameraY = " .. SetCameraY)
		
		TppPlayerUtility.RequestToPlayCameraNonAnimation{
			characterId = "Player",
			isFollowPos = false,
			isFollowRot = true,
			followTime = 0.1,
			useCharaPosRot = true,
			rotX = -30.0,
			rotY = 45.0,
			candidateRotX = 0.0,
			candidateRotY = 30.0,
			offsetPos = Vector3( -2.43, SetCameraY, -2.43),
			focalLength = 21.0,
		}
	end

	TppHighSpeedCameraManager.RequestEvent{
		continueTime = 1.0,		-- ハイスピードカメラ継続時間
		worldTimeRate = 0.1,			-- 世界全体の速度倍率(1.0で等倍速)
		localPlayerTimeRate = timeRate,		-- プレイヤーの速度倍率(1.0で等倍速)
		timeRateInterpTimeAtStart = 0.0,	-- イベント開始時目標速度に達するまでの補完時間(秒)
		timeRateInterpTimeAtEnd = 0.3,		-- イベント終了時元の速度に戻るまでの補完時間(秒)
		cameraSetUpTime = 0.0				-- イベント開始時のカメラの準備時間(秒)※この間は時間が止まってカメラだけが動きます。
	}
	
end,

-- CQC直投げ時ハイスピードカメラ
SetHighSpeeCameraOnCQCDirectThrow = function()
	if TppPlayerUtility.IsCqcThrowWithHighSpeed() == true then
		TppSoundDaemon.PostEvent( 'sfx_s_highspeed_cqc' )
		TppPlayerCallbackScript._SetHighSpeedCamera( 1.0, 0.1 )
	end
end,

-- CQCコンボフィニッシュ時ハイスピードカメラ
SetHighSpeeCameraOnCQCComboFinish = function()
	TppSoundDaemon.PostEvent( 'sfx_s_highspeed_cqc' )
	TppPlayerCallbackScript._SetHighSpeedCamera( 0.6, 0.03 )
end,

-- 武器奪いハイスピードカメラ
SetHighSpeeCameraAtCQCSnatchWeapon = function()
	TppSoundDaemon.PostEvent( 'sfx_s_highspeed_cqc' )
	TppPlayerCallbackScript._SetHighSpeedCamera( 1.0,	0.1 )
end,

--------------------------------------------------------------------
--	Private function
--------------------------------------------------------------------

-- カメラアニメーション用デフォルト設定
defaultStopPlayingByCollision = false,			-- アニメーション中アタリに引っかかったらアニメーション再生を停止するかどうか(デフォルトはfalse)
defaultEnableCamera = { "NewAroundCamera" },		-- 有効なカメラ(デフォルトは全部)
defaultInterpTimeToRecoverOrientation = 0.24,	-- カメラを元の向きに戻す際の回転補間時間(デフォルトは0)
defaultStopRecoverInterpByPadOperation = true,	-- カメラを元に戻す補間中にカメラのパッド操作があった時に補間を中止する(デフォルトはtrue)
defaultInterpType = 2,							-- カメラを元に戻す時の回転補間の補間曲線タイプ(デフォルトは1(２次ベジェ曲線))

-- 通常はモーションイベントにファイルセット名を入れて実行する
_StartCameraAnimation = function( eventStartFrame, currentPlayFrame, animationFileSet, recoverPreOrientationSetting, ignoreCollisionCheckOnStart, offsetFrame, isRiding, StopPlayingByCollision )

	Fox.Log("TppPlayerCallbackScript._StartCameraAnimation() / fileSet = " .. tostring(animationFileSet) .. "/recoverCamera = " .. tostring(recoverPreOrientationSetting) .. "/ignoreCollisionCheckOnStart = " .. tostring(ignoreCollisionCheckOnStart)  .. ",offsetFrame = " .. tostring(offsetFrame) .. ", isRiding = " .. tostring(isRiding) .. ", StopPlayingByCollision = " .. tostring(StopPlayingByCollision))
	
	-- カメラアニメーションをどこから再生開始するか。通常はこの計算式で出した値を入れてください。
	-- カメラアニメーションを0フレーム目からではなく、途中から再生したい場合は、そのフレームの値をこの値に足してください。
	local startFrame = currentPlayFrame - eventStartFrame + offsetFrame
	-- 再生終了時に再生前の向きにカメラを戻す（デフォルトはfalse）
	local recoverPreOrientation = recoverPreOrientationSetting

	-- 指定が無いパラメータはデフォルトを使用
	TppPlayerUtility.RequestToPlayCameraAnimation{
		-- 引数で変わるもの
		fileSet = animationFileSet, -- MotionEventでparamStringのKeyColumn1番に再生したいバリエーションセット名を入れておいて、この形で指定してください。
		startFrame = startFrame,  
		ignoreCollisionCheckOnStart = ignoreCollisionCheckOnStart,
		recoverPreOrientation = recoverPreOrientation,
		isRiding = isRiding,
		stopPlayingByCollision = true,
		-- デフォルト値があるもの
		enableCamera = TppPlayerCallbackScript.defaultEnableCamera,
		interpTimeToRecoverOrientation = TppPlayerCallbackScript.defaultInterpTimeToRecoverOrientation,
		stopRecoverInterpByPadOperation = TppPlayerCallbackScript.defaultStopRecoverInterpByPadOperation,
		interpType = TppPlayerCallbackScript.defaultInterpType,
	}
end,

-- fileSetに文字列が使えるバージョン。武器奪いでのみ使用
_StartCameraAnimationUseFileSetName = function( eventStartFrame, currentPlayFrame, animationFileSetName, recoverPreOrientationSetting, ignoreCollisionCheckOnStart )

	Fox.Log("TppPlayerCallbackScript._StartCameraAnimationUseFileSetName() / fileSetName = " .. animationFileSetName .. "/recoverCamera = " .. tostring(recoverPreOrientationSetting) .. "/ignoreCollisionCheckOnStart = " .. tostring(ignoreCollisionCheckOnStart) )
	
	-- カメラアニメーションをどこから再生開始するか。通常はこの計算式で出した値を入れてください。
	-- カメラアニメーションを0フレーム目からではなく、途中から再生したい場合は、そのフレームの値をこの値に足してください。
	local startFrame = currentPlayFrame - eventStartFrame
	-- 再生終了時に再生前の向きにカメラを戻す（デフォルトはfalse）
	local recoverPreOrientation = recoverPreOrientationSetting

	-- 指定が無いパラメータはデフォルトを使用
	TppPlayerUtility.RequestToPlayCameraAnimation{
		-- 引数で変わるもの
		fileSetName = animationFileSetName, -- MotionEventでparamStringのKeyColumn1番に再生したいバリエーションセット名を入れておいて、この形で指定してください。
		startFrame = startFrame,  
		ignoreCollisionCheckOnStart = ignoreCollisionCheckOnStart,
		recoverPreOrientation = recoverPreOrientation,
		-- デフォルト値があるもの
		stopPlayingByCollision = TppPlayerCallbackScript.defaultStopPlayingByCollision,
		enableCamera = TppPlayerCallbackScript.defaultEnableCamera,
		interpTimeToRecoverOrientation = TppPlayerCallbackScript.defaultInterpTimeToRecoverOrientation,
		stopRecoverInterpByPadOperation = TppPlayerCallbackScript.defaultStopRecoverInterpByPadOperation,
		interpType = TppPlayerCallbackScript.defaultInterpType,
	}
end,

_SetCameraNoise = function( levelX, levelY, time )

	--print("set camera noise")
	local levelX = levelX
	local levelY = levelY
	local time = time
	local decayRate = 0.15
	local randomSeed = 12345
	local enableCamera = { "NewAroundCamera" }

	TppPlayerUtility.SetCameraNoise{
		levelX = levelX,
		levelY = levelY,
		time = time,
		decayRate = decayRate,
		randomSeed = randomSeed,
		enableCamera = enableCamera,
	}

end,

_SetHighSpeedCamera = function( continueTime, timeRate )

	Fox.Log("TppPlayerCallbackScript._SetHighSpeedCamera(): continueTime = " .. tostring( continueTime ) .. "/ timeRate = " .. tostring( timeRate ))

	TppHighSpeedCameraManager.RequestEvent{
		continueTime = continueTime,		-- ハイスピードカメラ継続時間
		worldTimeRate = timeRate,			-- 世界全体の速度倍率(1.0で等倍速)
		localPlayerTimeRate = timeRate,		-- プレイヤーの速度倍率(1.0で等倍速)
		timeRateInterpTimeAtStart = 0.0,	-- イベント開始時目標速度に達するまでの補完時間(秒)
		timeRateInterpTimeAtEnd = 0.0,		-- イベント終了時元の速度に戻るまでの補完時間(秒)
		cameraSetUpTime = 0.0				-- イベント開始時のカメラの準備時間(秒)※この間は時間が止まってカメラだけが動きます。
	}

end,


}
