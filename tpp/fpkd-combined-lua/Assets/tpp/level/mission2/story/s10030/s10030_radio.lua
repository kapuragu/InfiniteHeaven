local this = {}
local StrCode32 = Fox.StrCode32
local StrCode32Table = Tpp.StrCode32Table

local TimerStart = GkEventTimerManager.Start




local OCELOT_NAME = "Ocelot"
local OCELOT_GAMEOBJTYPE = "TppOcelot2"

local SPEECH_CHARACTER = {
	OCELOT = {
		NAME = "Ocelot",
		GAMEOBJTYPE = "TppOcelot2",
	}
}

local PRESET_DELAY_TIME = {
	short	= 0.5,
	mid		= 1.5,
	long	= 3.0,
}


local TIMER_TIME = 10
local TIMER_TIME_TALK = 2	

local OCELOT_TALK_MAX = 3	






this.commonRadioTable = {
	

		
	[ TppDefine.COMMON_RADIO.ENEMY_RECOVERED  ] 			= TppRadio.IGNORE_COMMON_RADIO,		
	[ TppDefine.COMMON_RADIO.HOSTAGE_RECOVERED  ] 			= TppRadio.IGNORE_COMMON_RADIO,		
	[ TppDefine.COMMON_RADIO.HOSTAGE_DEAD  ] 				= TppRadio.IGNORE_COMMON_RADIO,		
	[ TppDefine.COMMON_RADIO.HOSTAGE_DAMAGED_FROM_PC  ]	= TppRadio.IGNORE_COMMON_RADIO,		
	[ TppDefine.COMMON_RADIO.PHASE_DOWN_OUTSIDE_HOTZONE  ] = TppRadio.IGNORE_COMMON_RADIO,		
	[ TppDefine.COMMON_RADIO.OUTSIDE_MISSION_AREA  ] 		= TppRadio.IGNORE_COMMON_RADIO,		
	[ TppDefine.COMMON_RADIO.OUTSIDE_HOTZONE_ALERT  ] 		= TppRadio.IGNORE_COMMON_RADIO,		
	[ TppDefine.COMMON_RADIO.OUTSIDE_HOTZONE  ] 			= TppRadio.IGNORE_COMMON_RADIO,		
	[ TppDefine.COMMON_RADIO.RETURN_HOTZONE  ] 				= TppRadio.IGNORE_COMMON_RADIO,		
	[ TppDefine.COMMON_RADIO.ABORT_BY_HELI  ] 				= TppRadio.IGNORE_COMMON_RADIO,		
	[ TppDefine.COMMON_RADIO.RECOMMEND_CURE  ] 				= TppRadio.IGNORE_COMMON_RADIO,		
	[ TppDefine.COMMON_RADIO.SUPPRESSOR_BROKEN  ] 			= TppRadio.IGNORE_COMMON_RADIO,		
	[ TppDefine.COMMON_RADIO.CALL_HELI_FIRST_TIME  ] 		= TppRadio.IGNORE_COMMON_RADIO,		
	[ TppDefine.COMMON_RADIO.CALL_HELI_FIRST_TIME_HOT_ZONE  ] = TppRadio.IGNORE_COMMON_RADIO,	
	[ TppDefine.COMMON_RADIO.CALL_HELI_SECOND_TIME  ] 		= TppRadio.IGNORE_COMMON_RADIO,		
	[ TppDefine.COMMON_RADIO.RESULT_RANK_S  ] 				= TppRadio.IGNORE_COMMON_RADIO,		
	[ TppDefine.COMMON_RADIO.RESULT_RANK_A  ] 				= TppRadio.IGNORE_COMMON_RADIO,		
	[ TppDefine.COMMON_RADIO.RESULT_RANK_B  ] 				= TppRadio.IGNORE_COMMON_RADIO,		
	[ TppDefine.COMMON_RADIO.RESULT_RANK_C  ] 				= TppRadio.IGNORE_COMMON_RADIO,		
	[ TppDefine.COMMON_RADIO.RESULT_RANK_D  ] 				= TppRadio.IGNORE_COMMON_RADIO,		
	[ TppDefine.COMMON_RADIO.RESULT_RANK_E  ] 				= TppRadio.IGNORE_COMMON_RADIO,		
	[ TppDefine.COMMON_RADIO.RECOVERED_RUSSIAN_INTERPRETER  ] = TppRadio.IGNORE_COMMON_RADIO,		
	[ TppDefine.COMMON_RADIO.CALL_SUPPROT_BUDDY  ] 		= TppRadio.IGNORE_COMMON_RADIO,		
	[ TppDefine.COMMON_RADIO.TARGET_MARKED  ] 				= TppRadio.IGNORE_COMMON_RADIO,		
	[ TppDefine.COMMON_RADIO.SEARCH_TARGET_ENABLED  ]		= TppRadio.IGNORE_COMMON_RADIO,		
	[ TppDefine.COMMON_RADIO.RESULT_RANK_NOT_DEFINED  ] 	= TppRadio.IGNORE_COMMON_RADIO,		
	[ TppDefine.COMMON_RADIO.TARGET_RECOVERED  ] 			= TppRadio.IGNORE_COMMON_RADIO,		
	[ TppDefine.COMMON_RADIO.TARGET_ELIMINATED  ] 			= TppRadio.IGNORE_COMMON_RADIO,		

}




local ocelotSpeechLabel = nil











this.radioList = {


	"s0030_gmov0010",
	"s0030_gmov0020",
	
	TOMB1000_101010_0_ocelot = {"(dbg)「ボス、大事な話がある。基地（マザーベース）の運営についてだ」",},
	TOMB1000_111010_0_ocelot = {"(dbg)「俺のところへ来てくれ」",},


	TOMB3000_101010_0_ocelot = {"(dbg)「まずはそいつを眠らせるんだ」",},
	TOMB3000_111010_0_ocelot = {"(dbg)「麻酔銃は持っているな？」",},
	TOMB3000_121010_0_ocelot = {"(dbg)「よし、スタッフが眠ったぞ」",},
	TOMB3000_131010_0_ocelot = {"(dbg)「近付いて回収しろ」",},
	TOMB3000_141010_0_ocelot = {"(dbg)「回収成功だ」",},
	TOMB3000_151010_0_ocelot = {"(dbg)「フルトン回収ができるのは、無抵抗の相手だけだ」",},
	TOMB3000_161010_0_ocelot = {"(dbg)「死体は回収できない。うちで働いてもらうには手遅れだ」",},
	TOMB3000_171010_0_ocelot = {"(dbg)「あんたが？回収したスタッフは、その能力が最も活かせる班に配属される」",},
	TOMB3000_181010_0_ocelot = {"(dbg)「確認しよう。端末を開いてくれ」",},
	TOMB3000_1a1010_0_ocelot = {"(dbg)「今のスタッフは、『研究開発班』に配属されたな」",},
	TOMB3000_1b1010_0_ocelot = {"(dbg)「研究開発班では、あんたのミッションでも役立つ様々な武器やアイテムを開発する」",},
	TOMB3000_1c1010_0_ocelot = {"(dbg)「その開発予定リストを見てみよう」",},
	TOMB3000_1d1010_0_ocelot = {"(dbg)「そいつが、研究開発班の開発予定リストだ」",},
	TOMB3000_1e1010_0_ocelot = {"(dbg)「その中に『ダンボール箱』があるな？」",},
	TOMB3000_1f1010_0_ocelot = {"(dbg)「何に使うかわからんが、ミラーがあんたのために準備していたらしい」",},
	TOMB3000_1g1010_0_ocelot = {"(dbg)「潜入用に特化した「こだわりの逸品」……」",},
	TOMB3000_1h1010_0_ocelot = {"(dbg)「うむ、おかげで、こいつを開発するにはまだ人手が足りていないようだ 」",},
	TOMB3000_1i1010_0_ocelot = {"(dbg)「スタッフを補充しよう。あと何人かフルトン回収してくれ」",},
	TOMB4000_101010_0_ocelot = {"(dbg)「フルトン回収は『気絶』した相手にも行うことができる」",},
	TOMB4000_111010_0_ocelot = {"(dbg)「次はCQC（近接戦闘術）で『気絶』させてみるか？」",},
	TOMB4000_121010_0_ocelot = {"(dbg)「ボス、皆に“本物（ホンモノ）”を見せてやれ」",},
	TOMB4000_1f1010_0_ocelot = {"(dbg)「そいつを『投げ』てみろ」",},
	TOMB4000_1g1010_0_ocelot = {"(dbg)「相手を即座に 気絶させるには、そいつが一番だ」",},
	TOMB4000_1j1010_0_ocelot = {"(dbg)「さすがだ、ボス」",},
	TOMB4000_1k1010_0_ocelot = {"(dbg)「フルトン回収してくれ」",},
	TOMB3000_141010_0_ocelot = {"(dbg)「回収成功だ」",},
	TOMB4000_1m1010_0_ocelot = {"(dbg)「ただし、いいか、フルトン回収は必ずしも成功するとは限らない」",},
	TOMB4000_1n1010_0_ocelot = {"(dbg)「負傷者は回収時の衝撃に耐えられず『死亡』する可能性もあるし」",},
	TOMB4000_1o1010_0_ocelot = {"(dbg)「天候が悪ければ、『行方不明』になる可能性もある」",},
	TOMB4000_1p1010_0_ocelot = {"(dbg)「フルトン回収の『成功率』は、対象に近づけば、おのずと見極めることができるだろう。」",},
	TOMB4000_1q1010_0_ocelot = {"(dbg)「確実に回収したい対象は、自分で担いでヘリまで運ぶんだ」",},
	TOMB4000_1r1010_0_ocelot = {"(dbg)「よし、次のスタッフを回収してみろ」",},
	TOMB4000_1s1010_0_ocelot = {"(dbg)「そいつを回収するんだ」 ",},
	TOMB4000_1t1010_0_ocelot = {"(dbg)「方法はあんたに任せる」",},
	TOMB4000_1v1010_0_ocelot = {"(dbg)「まずそいつを気絶させてくれ。眠らせてもいい」",},
	TOMB4000_1w1010_0_ocelot = {"(dbg)「いいぞ」",},
	TOMB4000_1k1010_0_ocelot = {"(dbg)「フルトン回収してくれ」",},
	ocelot_410 = {"(dbg)「（バリエーション）回収するんだ」",},
	ocelot_420 = {"(dbg)「（バリエーション）そいつを回収してみろ」",},
	ocelot_430 = {"(dbg)「ボス、ミッションへ出るのか？」",},
	ocelot_440 = {"(dbg)「話はまだ終わってないぞ」",},
	TOMB5000_101010_0_ocelot = {"(dbg)「ボス、人手が集まったおかげで『研究開発班』のレベルが上がった 」",},
	TOMB5000_111010_0_ocelot = {"(dbg)「これで『ダンボール箱』が開発できるんじゃないか？」",},
	TOMB5000_121010_0_ocelot = {"(dbg)「端末を開けてみろ」",},
	TOMB5000_131010_0_ocelot = {"(dbg)「よし、『ダンボール箱』を選んで、開発を実行するんだ」",},
	TOMB5000_141010_0_ocelot = {"(dbg)「ただし開発には『｛資金→GMP｝』が必要になる。赤字には気をつけろ」",},
	TOMB5000_151010_0_ocelot = {"(dbg)「開発の成果だ」",},
	TOMB5000_161010_0_ocelot = {"(dbg)「使い道はよくわからんが……ミラーは「ボスならわかる」と」",},
	TOMB5000_171010_0_ocelot = {"(dbg)「試してみてくれ」",},
	TOMB5000_181010_0_ocelot = {"(dbg)「それから、今回回収したスタッフは、すべて研究開発班に配属されたが、これはミラーによる判断だ」",},
	TOMB5000_191010_0_ocelot = {"(dbg)「あんたが気に入らなければ自分で再配置してもいい」",},
	TOMB5000_1a1010_0_ocelot = {"(dbg)「さて、説明は以上だ」",},
	TOMB5000_1b1010_0_ocelot = {"(dbg)「GMPを稼ぐにも、人を集めるにも、ここにいては始まらん」",},
	ocelot_570 = {"(dbg)「ミッションに出る覚悟が出来たら、ヘリに乗ってくれ」",},
	ocelot_580 = {"(dbg)「端末から｛ランディングゾーン←LZ｝を指定すれば、そこに支援ヘリを呼ぶことができる」 ",},
	ocelot_590 = {"(dbg)「あんたがまだ投げ足りなければ、しばらくここ（マザーベース）でスタッフに稽古をつけてもいいぞ」",},
	ocelot_600 = {"(dbg)「その時は、俺のところへ来てくれ」",},
	TOMB7000_101010_0_ocelot = {"(dbg)「ボス」",},
	TOMB7000_111010_0_ocelot = {"(dbg)「CQCの稽古といこう」",},
	TOMB7000_121010_0_ocelot = {"(dbg)「ではそいつを『拘束』してみろ」",},
	ocelot_640 = {"(dbg)「拘束した相手は、あんたの意のままだ」",},
	ocelot_650 = {"(dbg)「『尋問』『気絶』『殺傷』……おっと、殺すのはなしだぞ」",},
	ocelot_660 = {"(dbg)「気絶させてみろ」",},
	TOMB7000_161010_0_ocelot = {"(dbg)「よし」",},
	ocelot_680 = {"(dbg)「次へ行こう」＜なくても？",},
	TOMB7000_171010_0_ocelot = {"(dbg)「次は『打撃』だ」",},
	TOMB7000_181010_0_ocelot = {"(dbg)「打撃を連続で与えれば、相手はしばらく昏倒する。」",},
	TOMB7000_191010_0_ocelot = {"(dbg)「『投げ』よりも長く、気絶させておけるだろう。」",},
	TOMB7000_1a1010_0_ocelot = {"(dbg)「よぉし」",},
	ocelot_720 = {"(dbg)「今度は相手の武器を奪ってみろ」",},
	ocelot_730 = {"(dbg)「よし、銃を構えろ。相手に向けるんだ。」",},
	ocelot_740 = {"(dbg)「ボス、銃を向けて、相手を威嚇するんだ」",},
	ocelot_750 = {"(dbg)「観念したな。…… 『ホールドアップ』だ」",},
	ocelot_760 = {"(dbg)「あんたが隙を見せない限り、相手は『無力化』したまま。もう抵抗はできないはずだ」",},
	TOMB7000_1g1010_0_ocelot = {"(dbg)「近くに複数の相手がいるなら、立て続けにCQCをかけてやれ。」",},
	TOMB7000_1h1010_0_ocelot = {"(dbg)「反撃の隙を与えず、一網打尽にできるぞ」",},
	TOMB7000_1i1010_0_ocelot = {"(dbg)「やるな、いいセンスだ。」",},
	TOMB7000_1k1010_0_ocelot = {"(dbg)「あとは実戦で憶えていけばいいだろう。」",},
	TOMB7000_1l1010_0_ocelot = {"(dbg)「さあ、端末からヘリを呼んでくれ」",},
	ocelot_820	=	{"(dbg)「まあいい」（つなぎで共通で使う）",},
	ocelot_830	=	{"(dbg)「（今ので）眠ったのか」",},
	ocelot_840	=	{"(dbg)「（続けて）だらしない寝顔だ」",},
	ocelot_850	=	{"(dbg)「（今ので）気絶したのか」",},
	ocelot_860	=	{"(dbg)「（続けて）鍛え方が足りんな」",},
	ocelot_870	=	{"(dbg)「どうした。もう一度だ。」",},
	ocelot_880	=	{"(dbg)「ほう、なるほど……」",},
}























this.gameOverRadioTable = {}
this.gameOverRadioTable[TppDefine.GAME_OVER_RADIO.PLAYER_DEAD]  = "s0030_gmov0010"
this.gameOverRadioTable[TppDefine.GAME_OVER_RADIO.S10030_TARGET_DEAD] = "s0030_gmov0020"



































this.PlaySpeech = function ( speechSetTable )
	local locatorName = speechSetTable.speakerName
	local gameObjectType = speechSetTable.speakerType
	local gameObjectId = GameObject.GetGameObjectId(gameObjectType, locatorName)
	local command = {
		id = "CallMonologue",
		label = speechSetTable.speechLabel,
	}
	GameObject.SendCommand( gameObjectId, command )
end
--RETAILBUG: duplicate function name, differing behavior
this.PlaySpeech = function ( speechSetTable )
	local locatorName = speechSetTable.speakerName
	local gameObjectType = speechSetTable.speakerType
	local gameObjectId = GameObject.GetGameObjectId(gameObjectType, locatorName)
	local command = {
		id = "CallMonologue",
		label = speechSetTable.speechLabel,
		reset = true,
	}
	GameObject.SendCommand( gameObjectId, command )
end

this.PlaySpeech_Ocelot = function (speechLabel,delayTime)
	
	ocelotSpeechLabel = speechLabel

	if( GkEventTimerManager.IsTimerActive( "speechStartTimer" ) == true ) then return end

	
	if delayTime ~= nil then
		TimerStart( "speechStartTimer_Ocelot", delayTime )
	else
		this._PlaySpeech_Ocelot()
	end
end


this._PlaySpeech_Ocelot = function ()
	local locatorName = SPEECH_CHARACTER.OCELOT.NAME
	local gameObjectType = SPEECH_CHARACTER.OCELOT.GAMEOBJTYPE
	local gameObjectId = GameObject.GetGameObjectId(gameObjectType, locatorName)
	local command = {
		id = "CallMonologue",
		label = ocelotSpeechLabel,
	}
	GameObject.SendCommand( gameObjectId, command )
end


this.FailedRequest = function()
	GkEventTimerManager.Stop( "Timer_MonologueFailed")
	GkEventTimerManager.Start( "Timer_MonologueFailed", 6 )
end


this.FailedReset = function()
	GkEventTimerManager.Stop( "Timer_MonologueFailed")
	if mvars.ocerotTalkProcess == s10030_sequence.OCELOT_TALK_PROCESS.TALKING_1 then
		mvars.ocerotTalkProcess = s10030_sequence.OCELOT_TALK_PROCESS.WAITING_1
	elseif mvars.ocerotTalkProcess == s10030_sequence.OCELOT_TALK_PROCESS.TALKING_2 then
		mvars.ocerotTalkProcess = s10030_sequence.OCELOT_TALK_PROCESS.WAITING_2
	elseif mvars.ocerotTalkProcess == s10030_sequence.OCELOT_TALK_PROCESS.TALKING_3 then
		mvars.ocerotTalkProcess = s10030_sequence.OCELOT_TALK_PROCESS.WAITING_3
	elseif mvars.ocerotTalkProcess == s10030_sequence.OCELOT_TALK_PROCESS.TALKING_4 then
		mvars.ocerotTalkProcess = s10030_sequence.OCELOT_TALK_PROCESS.WAITING_4
	elseif mvars.ocerotTalkProcess == s10030_sequence.OCELOT_TALK_PROCESS.TALKING_5 then
		mvars.ocerotTalkProcess = s10030_sequence.OCELOT_TALK_PROCESS.WAITING_5
	elseif mvars.ocerotTalkProcess == s10030_sequence.OCELOT_TALK_PROCESS.TALKING_6 then
		mvars.ocerotTalkProcess = s10030_sequence.OCELOT_TALK_PROCESS.WAITING_6
	elseif mvars.ocerotTalkProcess == s10030_sequence.OCELOT_TALK_PROCESS.TALKING_7 then
		mvars.ocerotTalkProcess = s10030_sequence.OCELOT_TALK_PROCESS.WAITING_7
	elseif mvars.ocerotTalkProcess == s10030_sequence.OCELOT_TALK_PROCESS.TALKING_8 then
		mvars.ocerotTalkProcess = s10030_sequence.OCELOT_TALK_PROCESS.WAITING_8
	elseif mvars.ocerotTalkProcess == s10030_sequence.OCELOT_TALK_PROCESS.TALKING_9 then
		mvars.ocerotTalkProcess = s10030_sequence.OCELOT_TALK_PROCESS.WAITING_9
	end
end








this.TalkingToApproach = function()
	Fox.Log("#### s10030_radio.TalkingToApproach ####")

	if mvars.OcelotTooFarCount <= OCELOT_TALK_MAX then	
		mvars.OcelotTooFarCount = mvars.OcelotTooFarCount+1

		this.PlaySpeech{
			speakerName = OCELOT_NAME,
			speakerType = OCELOT_GAMEOBJTYPE,
			speechLabel = "MBTS_086"
		}
	else
	
	end	
end



this.TalkingToLeave = function()
	Fox.Log("#### s10030_radio.TalkingToLeave ####")
	if mvars.isInterruptTalk == true then
		return
	end

	mvars.isInterruptTalk= true	

	this.PlaySpeech{
		speakerName = OCELOT_NAME,
		speakerType = OCELOT_GAMEOBJTYPE,
		speechLabel = "MBTS_085"
	}
end




this.CrazyAction = function()
	Fox.Log("#### s10030_radio.CrazyAction ####")
	if mvars.isInterruptTalk == true then
		return
	end

	mvars.isInterruptTalk= true	

	this.CrazyTalk()	

	GkEventTimerManager.Stop( "Timer_waitApproachOcelot" )	
	GkEventTimerManager.Start( "Timer_waitApproachOcelot", TIMER_TIME )


end

this.CrazyTalk = function()	
	if mvars.ToggleCrazyTalk == 0 then
		mvars.ToggleCrazyTalk = mvars.ToggleCrazyTalk +1
		this.CrazyTalk1() 
	else
		mvars.ToggleCrazyTalk = 0
		this.CrazyTalk2() 
	end
end

this.CrazyTalk1 = function()	
	this.PlaySpeech{
		speakerName = OCELOT_NAME,
		speakerType = OCELOT_GAMEOBJTYPE,
		speechLabel = "MBTS_110"
	}
end


this.CrazyTalk2 = function()	
	this.PlaySpeech{
		speakerName = OCELOT_NAME,
		speakerType = OCELOT_GAMEOBJTYPE,
		speechLabel = "MBTS_111"
	}
end



this.OcelotBoxHit = function()
	mvars.isSoldierBoxHit = false 
	if svars.isOcelotBoxHit ==false then	
		svars.isOcelotBoxHit = true 
		this.PlaySpeech{
			speakerName = OCELOT_NAME,
			speakerType = OCELOT_GAMEOBJTYPE,
			speechLabel = "MBTS_430"
		}
		return
	end
	this.PlaySpeech{
		speakerName = OCELOT_NAME,
		speakerType = OCELOT_GAMEOBJTYPE,
		speechLabel = "MBTS_230"
	}
end



this.SoldierBoxHit = function()
	if mvars.isSoldierBoxHit ==false then	
		mvars.isSoldierBoxHit = true 
		if mvars.isInterruptTalk== false then	
			this.PlaySpeech{	
				speakerName = OCELOT_NAME,
				speakerType = OCELOT_GAMEOBJTYPE,
				speechLabel = "MBTS_410"
			}
		end
	end
	if svars.isOcelotBoxHit ==false then	
		svars.isOcelotBoxHit = true 
		this.PlaySpeech{
			speakerName = OCELOT_NAME,
			speakerType = OCELOT_GAMEOBJTYPE,
			speechLabel = "MBTS_241"
		}
	end
end



this.FultonSuccessCommon = function()
	Fox.Log("#### s10030_radio.FultonSuccessCommon ####")
	this.PlaySpeech{
		speakerName = OCELOT_NAME,
		speakerType = OCELOT_GAMEOBJTYPE,
		speechLabel = "MBTS_050"
	}
end



this.WrongAction = function()
	Fox.Log("#### s10030_radio.WrongAction ####")
	if mvars.ToggleCrazyTalk == 0 then
		mvars.ToggleCrazyTalk = mvars.ToggleCrazyTalk +1
		this.WrongAction1() 
	elseif mvars.ToggleCrazyTalk == 1 then
		mvars.ToggleCrazyTalk = mvars.ToggleCrazyTalk +1
		this.WrongAction2() 
	elseif mvars.ToggleCrazyTalk == 2 then
		mvars.ToggleCrazyTalk = mvars.ToggleCrazyTalk +1
		this.WrongAction3() 
	else
		mvars.ToggleCrazyTalk = 0
		this.WrongAction4() 
	end
end

this.WrongAction1 = function()
	Fox.Log("#### s10030_radio.WrongAction1 ####")
	this.PlaySpeech{
		speakerName = OCELOT_NAME,
		speakerType = OCELOT_GAMEOBJTYPE,
		speechLabel = "MBTS_080"
	}

end
this.WrongAction2 = function()
	Fox.Log("#### s10030_radio.WrongAction2 ####")
	this.PlaySpeech{
		speakerName = OCELOT_NAME,
		speakerType = OCELOT_GAMEOBJTYPE,
		speechLabel = "MBTS_081"
	}

end
this.WrongAction3 = function()
	Fox.Log("#### s10030_radio.WrongAction3 ####")
	this.PlaySpeech{
		speakerName = OCELOT_NAME,
		speakerType = OCELOT_GAMEOBJTYPE,
		speechLabel = "MBTS_082"
	}

end
this.WrongAction4 = function()
	Fox.Log("#### s10030_radio.WrongAction4 ####")
	this.PlaySpeech{
		speakerName = OCELOT_NAME,
		speakerType = OCELOT_GAMEOBJTYPE,
		speechLabel = "MBTS_083"
	}

end




this.WrongActionAfter = function()	
	Fox.Log("#### s10030_radio.WrongActionAfter ####")
	this.PlaySpeech{
		speakerName = OCELOT_NAME,
		speakerType = OCELOT_GAMEOBJTYPE,
		speechLabel = "MBTS_410"
	}

end



this.FultonFailed = function()
	Fox.Log("#### s10030_radio.FultonFailed ####")

	if svars.FultonFailedCount == 0 then
		this.FultonFailed1()	
	elseif  svars.FultonFailedCount == 1 then	
		this.FultonFailed2()
	else										
		this.FultonFailed3()
	end
end

this.FultonFailed1 = function()
	Fox.Log("#### s10030_radio.FultonFailed1 ####")
	svars.FultonFailedCount= svars.FultonFailedCount + 1 

	this.PlaySpeech{	
		speakerName = OCELOT_NAME,
		speakerType = OCELOT_GAMEOBJTYPE,
		speechLabel = "MBTS_410"
	}

end

this.FultonFailed2 = function()	
	Fox.Log("#### s10030_radio.FultonFailed2 ####")
	svars.FultonFailedCount= svars.FultonFailedCount + 1 

	this.PlaySpeech{	
		speakerName = OCELOT_NAME,
		speakerType = OCELOT_GAMEOBJTYPE,
		speechLabel = "MBTS_411"
	}
	
end

this.FultonFailed3 = function()		
	Fox.Log("#### s10030_radio.FultonFailed3 ####")
	svars.FultonFailedCount= 1 

	this.PlaySpeech{	
		speakerName = OCELOT_NAME,
		speakerType = OCELOT_GAMEOBJTYPE,
		speechLabel = "MBTS_412"
	}

end





this.MissionStart = function() 
	Fox.Log("#### s10030_radio.MissionStart ####")
	mvars.ocerotTalkProcess = s10030_sequence.OCELOT_TALK_PROCESS.TALKING_1 	

	this.PlaySpeech{
		speakerName = OCELOT_NAME,
		speakerType = OCELOT_GAMEOBJTYPE,
		speechLabel = "MBTS_010"
	}
end



this.WaitingApproach = function()
	Fox.Log("#### s10030_radio.WaitingApproach ####")
	if mvars.OcelotTooFarCount	<= OCELOT_TALK_MAX then	
		mvars.OcelotTooFarCount = mvars.OcelotTooFarCount+1
		this.PlaySpeech{
			speakerName = OCELOT_NAME,
			speakerType = OCELOT_GAMEOBJTYPE,
			speechLabel = "MBTS_087",
		}
	else
	
	end
end




this.Approached = function()
	Fox.Log("#### s10030_radio.Approached ####")
	mvars.ocerotTalkProcess = s10030_sequence.OCELOT_TALK_PROCESS.TALKING_1 	

	this.PlaySpeech{
		speakerName = OCELOT_NAME,
		speakerType = OCELOT_GAMEOBJTYPE,
		speechLabel = "MBTS_020"
	}
end



this.GiveFulton_021 = function()
	Fox.Log("#### s10030_radio.GiveFulton_021 ####")
	mvars.ocerotTalkProcess = s10030_sequence.OCELOT_TALK_PROCESS.TALKING_2	

	this.PlaySpeech{
		speakerName = OCELOT_NAME,
		speakerType = OCELOT_GAMEOBJTYPE,
		speechLabel = "MBTS_021"
	}
end



this.GiveFulton_022 = function()
	Fox.Log("#### s10030_radio.GiveFulton_022 ####")
	mvars.ocerotTalkProcess = s10030_sequence.OCELOT_TALK_PROCESS.TALKING_3	

	this.PlaySpeech{
		speakerName = OCELOT_NAME,
		speakerType = OCELOT_GAMEOBJTYPE,
		speechLabel = "MBTS_022"
	}
end




this.GiveFulton_023 = function()
	Fox.Log("#### s10030_radio.GiveFulton_023 ####")
	mvars.ocerotTalkProcess = s10030_sequence.OCELOT_TALK_PROCESS.TALKING_1	

	
	s10030_demo.OcelotGiveFulton()






end




this.GiveFulton_024 = function()
	Fox.Log("#### s10030_radio.GiveFulton_024 ####")
	mvars.ocerotTalkProcess = s10030_sequence.OCELOT_TALK_PROCESS.TALKING_1	
	this.PlaySpeech{
		speakerName = OCELOT_NAME,
		speakerType = OCELOT_GAMEOBJTYPE,
		speechLabel = "MBTS_024"
	}
end



this.GiveFulton_030 = function()
	Fox.Log("#### s10030_radio.GiveFulton_030 ####")
	mvars.ocerotTalkProcess = s10030_sequence.OCELOT_TALK_PROCESS.TALKING_2	
	this.PlaySpeech{
		speakerName = OCELOT_NAME,
		speakerType = OCELOT_GAMEOBJTYPE,
		speechLabel = "MBTS_030"
	}
end




this.MakeThemSleep = function()
	Fox.Log("#### s10030_radio.MakeThemSleep ####")
	this.PlaySpeech{
		speakerName = OCELOT_NAME,
		speakerType = OCELOT_GAMEOBJTYPE,
		speechLabel = "MBTS_031"
	}
end



this.TalkAboutTranq = function()
	Fox.Log("#### s10030_radio.TalkAboutTranq ####")
	this.PlaySpeech{
		speakerName = OCELOT_NAME,
		speakerType = OCELOT_GAMEOBJTYPE,
		speechLabel = "MBTS_032"
	}

	s10030_sequence.displayTips( s10030_sequence.TIPS.SLEEP_BULLET)	

end



this.SuccessSleep = function()
	Fox.Log("#### s10030_radio.SuccessSleep ####")
	this.PlaySpeech{
		speakerName = OCELOT_NAME,
		speakerType = OCELOT_GAMEOBJTYPE,
		speechLabel = "MBTS_040"
	}
end



this.SuccessFaint = function()
	Fox.Log("#### s10030_radio.SuccessSleep ####")
	this.PlaySpeech{
		speakerName = OCELOT_NAME,
		speakerType = OCELOT_GAMEOBJTYPE,
		speechLabel = "MBTS_280"
	}
end



this.PleaseSleep = function()
	Fox.Log("#### s10030_radio.PleaseSleep ####")
	this.PlaySpeech{
		speakerName = OCELOT_NAME,
		speakerType = OCELOT_GAMEOBJTYPE,
		speechLabel = "MBTS_031"
	}
end



this.PleaseFaint = function()
	Fox.Log("#### s10030_radio.PleaseFaint ####")
	this.PlaySpeech{
		speakerName = OCELOT_NAME,
		speakerType = OCELOT_GAMEOBJTYPE,
		speechLabel = "MBTS_160"
	}
end



this.PleaseFultonFirst = function()
	Fox.Log("#### s10030_radio.PleaseFultonFirst ####")

	if mvars.isStopRepeatTalk == true then	
		return
	end
	mvars.isStopRepeatTalk = true	
	this.PlaySpeech{
		speakerName = OCELOT_NAME,
		speakerType = OCELOT_GAMEOBJTYPE,
		speechLabel = "MBTS_045"
	}

end



this.PleaseFulton = function()
	Fox.Log("#### s10030_radio.PleaseFulton ####")
	this.PlaySpeech{
		speakerName = OCELOT_NAME,
		speakerType = OCELOT_GAMEOBJTYPE,
		speechLabel = "MBTS_131"
	}
end



this.PleaseFultonAgain = function()
	Fox.Log("#### s10030_radio.TakeFulton ####")
	this.PlaySpeech{
		speakerName = OCELOT_NAME,
		speakerType = OCELOT_GAMEOBJTYPE,
		speechLabel = "MBTS_180"
	}
end



this.DoneDifferentAction = function()
	Fox.Log("#### s10030_radio.DoneDifferentAction ####")

	this.PlaySpeech{
		speakerName = OCELOT_NAME,
		speakerType = OCELOT_GAMEOBJTYPE,
		speechLabel = "MBTS_041"
	}
end



this.DoneDifferentAction2 = function()
	Fox.Log("#### s10030_radio.DoneDifferentAction2 ####")

	this.PlaySpeech{
		speakerName = OCELOT_NAME,
		speakerType = OCELOT_GAMEOBJTYPE,
		speechLabel = "MBTS_042"
	}
end



this.CarriedStart = function()
	Fox.Log("#### s10030_radio.CarriedStart ####")
	if mvars.isInterruptTalk == true then
		return
	end

	mvars.isInterruptTalk= true	

	this.PlaySpeech{
		speakerName = OCELOT_NAME,
		speakerType = OCELOT_GAMEOBJTYPE,
		speechLabel = "MBTS_088"
	}
end


this.CarriedEnd = function()
	Fox.Log("#### s10030_radio.CarriedEnd ####")

	if mvars.isStopRepeatTalk == true then	
		return
	end

	if mvars.isInterruptTalk == true then
		return
	end
	mvars.isInterruptTalk= true	

	mvars.isStopRepeatTalk = true	

	this.PlaySpeech{
		speakerName = OCELOT_NAME,
		speakerType = OCELOT_GAMEOBJTYPE,
		speechLabel = "MBTS_131"
	}

end



this.TryAgain1 = function()
	Fox.Log("#### s10030_radio.TryAgain1 ####")
	if mvars.isInterruptTalk == true then
		return
	end
	mvars.isInterruptTalk= true	

	this.PlaySpeech{
		speakerName = OCELOT_NAME,
		speakerType = OCELOT_GAMEOBJTYPE,
		speechLabel = "MBTS_082"
	}
end




this.TryAgain2 = function()
	Fox.Log("#### s10030_radio.TryAgain2 ####")
	if mvars.isInterruptTalk == true then
		return
	end
	mvars.isInterruptTalk= true	

	this.PlaySpeech{
		speakerName = OCELOT_NAME,
		speakerType = OCELOT_GAMEOBJTYPE,
		speechLabel = "MBTS_084"
	}
end



this.RestraintStart = function()
	Fox.Log("#### s10030_radio.RestraintStart ####")
	if mvars.isInterruptTalk == true then
		return
	end
	mvars.isInterruptTalk= true	

	this.PlaySpeech{
		speakerName = OCELOT_NAME,
		speakerType = OCELOT_GAMEOBJTYPE,
		speechLabel = "MBTS_088"
	}
end



this.RestraintEnd = function()
	Fox.Log("#### s10030_radio.RestraintEnd ####")
	if mvars.isInterruptTalk == true then
		return
	end
	mvars.isInterruptTalk= true	

	this.PlaySpeech{
		speakerName = OCELOT_NAME,
		speakerType = OCELOT_GAMEOBJTYPE,
		speechLabel = "MBTS_380"
	}
end



this.FirstFultonStart = function()
	Fox.Log("#### s10030_radio.FultonStart ####")

	this.PlaySpeech{
		speakerName = OCELOT_NAME,
		speakerType = OCELOT_GAMEOBJTYPE,
		speechLabel = "MBTS_170"
	}
end



this.ExplainFultonRule = function()
	Fox.Log("#### s10030_radio.ExplainFultonRule ####")
	this.PlaySpeech{
		speakerName = OCELOT_NAME,
		speakerType = OCELOT_GAMEOBJTYPE,
		speechLabel = "MBTS_050"
	}
	mvars.ocerotTalkProcess = s10030_sequence.OCELOT_TALK_PROCESS.TALKING_1 	
end



this.ExplainFultonRule_051 = function()
	Fox.Log("#### s10030_radio.ExplainFultonRule_051 ####")
	mvars.ocerotTalkProcess = s10030_sequence.OCELOT_TALK_PROCESS.TALKING_2	

	this.PlaySpeech{
		speakerName = OCELOT_NAME,
		speakerType = OCELOT_GAMEOBJTYPE,
		speechLabel = "MBTS_051"
	}
end



this.ExplainFultonRule_052 = function()
	Fox.Log("#### s10030_radio.ExplainFultonRule_052 ####")
	mvars.ocerotTalkProcess = s10030_sequence.OCELOT_TALK_PROCESS.TALKING_3	

	this.PlaySpeech{
		speakerName = OCELOT_NAME,
		speakerType = OCELOT_GAMEOBJTYPE,
		speechLabel = "MBTS_052"
	}
end




this.PleaseOpenDvc = function()
	Fox.Log("#### s10030_radio.PleaseOpenDvc ####")
	this.PlaySpeech{
		speakerName = OCELOT_NAME,
		speakerType = OCELOT_GAMEOBJTYPE,
		speechLabel = "MBTS_055"
	}
end



this.ExplainDevelop10_10 = function()
	Fox.Log("#### s10030_radio.ExplainDevelop10_10 ####")
	GkEventTimerManager.Stop( "Timer_waitOpenTerminal")	
	GkEventTimerManager.Stop( "Timer_waitApproachOcelot" )	

	this.PlaySpeech{
		speakerName = OCELOT_NAME,
		speakerType = OCELOT_GAMEOBJTYPE,
		speechLabel = "MBTS_060"
	}
end



this.ExplainDevelop10_20 = function()
	Fox.Log("#### s10030_radio.ExplainDevelop10_20 ####")
	GkEventTimerManager.Stop( "Timer_waitOpenTerminal")	
	GkEventTimerManager.Stop( "Timer_waitApproachOcelot" )	

	this.PlaySpeech{
		speakerName = OCELOT_NAME,
		speakerType = OCELOT_GAMEOBJTYPE,
		speechLabel = "MBTS_070"
	}
end



this.ExplainDevelop10_20_1 = function()
	Fox.Log("#### s10030_radio.ExplainDevelop10_20_1 ####")
	GkEventTimerManager.Stop( "Timer_waitOpenTerminal")	
	GkEventTimerManager.Stop( "Timer_waitApproachOcelot" )	

	this.PlaySpeech{
		speakerName = OCELOT_NAME,
		speakerType = OCELOT_GAMEOBJTYPE,
		speechLabel = "MBTS_071"
	}
end



this.ExplainDevelop10_20_2 = function()
	Fox.Log("#### s10030_radio.ExplainDevelop10_20_2 ####")
	GkEventTimerManager.Stop( "Timer_waitOpenTerminal")	
	GkEventTimerManager.Stop( "Timer_waitApproachOcelot" )	

	this.PlaySpeech{
		speakerName = OCELOT_NAME,
		speakerType = OCELOT_GAMEOBJTYPE,
		speechLabel = "MBTS_072"
	}
end



this.ExplainDevelop10_20_DevelopBox = function()
	Fox.Log("#### s10030_radio.ExplainDevelop10_20_DevelopBox ####")
	GkEventTimerManager.Stop( "Timer_waitOpenTerminal")	
	GkEventTimerManager.Stop( "Timer_waitApproachOcelot" )	

	this.PlaySpeech{
		speakerName = OCELOT_NAME,
		speakerType = OCELOT_GAMEOBJTYPE,
		speechLabel = "MBTS_073"
	}

end



this.ExplainDevelop10_20_BoxDeveloped = function()
	Fox.Log("#### s10030_radio.ExplainDevelop10_20_BoxDeveloped ####")
	GkEventTimerManager.Stop( "Timer_waitOpenTerminal")	
	GkEventTimerManager.Stop( "Timer_waitApproachOcelot" )	

	this.PlaySpeech{
		speakerName = OCELOT_NAME,
		speakerType = OCELOT_GAMEOBJTYPE,
		speechLabel = "MBTS_076"
	}
end



this.PleaseSelectStaffManagement = function()
	Fox.Log("#### s10030_radio.PleaseSelectStaffManagement ####")
	if mvars.isSelectStaffList	== true then
		Fox.Log("#### already open staff list ####")
		return
	end

	this.PlaySpeech{
		speakerName = OCELOT_NAME,
		speakerType = OCELOT_GAMEOBJTYPE,
		speechLabel = "MBTS_440"
	}
end



this.PleaseBackMotherBaseMenu = function()
	Fox.Log("#### s10030_radio.PleaseBackMotherBaseMenu ####")
	this.PlaySpeech{
		speakerName = OCELOT_NAME,
		speakerType = OCELOT_GAMEOBJTYPE,
		speechLabel = "MBTS_450"
	}
end



this.PleaseSelectDevelopment = function()
	Fox.Log("#### s10030_radio.PleaseSelectDevelopment ####")
	this.PlaySpeech{
		speakerName = OCELOT_NAME,
		speakerType = OCELOT_GAMEOBJTYPE,
		speechLabel = "MBTS_460"
	}
end



this.PleaseSelectRedMarker = function()
	Fox.Log("#### s10030_radio.PleaseSelectRedMarker ####")
	this.PlaySpeech{
		speakerName = OCELOT_NAME,
		speakerType = OCELOT_GAMEOBJTYPE,
		speechLabel = "MBTS_480"
	}
end




this.PleaseDevelopBox = function()
	Fox.Log("#### s10030_radio.PleaseDevelopBox ####")
	this.PlaySpeech{
		speakerName = OCELOT_NAME,
		speakerType = OCELOT_GAMEOBJTYPE,
		speechLabel = "MBTS_470"
	}
end



this.DevelopComplete = function()
	Fox.Log("#### s10030_radio.DevelopComplete ####")
	this.PlaySpeech{
		speakerName = OCELOT_NAME,
		speakerType = OCELOT_GAMEOBJTYPE,
		speechLabel = "MBTS_490"
	}
end



this.AboutSupply = function()
	Fox.Log("#### s10030_radio.AboutSupply ####")
	this.PlaySpeech{
		speakerName = OCELOT_NAME,
		speakerType = OCELOT_GAMEOBJTYPE,
		speechLabel = "MBTS_500"
	}
end



this.PleaseCloseTerminal= function()
	Fox.Log("#### s10030_radio.PleaseCloseTerminal ####")
	this.PlaySpeech{
		speakerName = OCELOT_NAME,
		speakerType = OCELOT_GAMEOBJTYPE,
		speechLabel = "MBTS_510"
	}
end




this.OcelotCQCTutStart = function()
	Fox.Log("#### s10030_radio.OcelotCQCTutStart ####")
	mvars.ocerotTalkProcess = s10030_sequence.OCELOT_TALK_PROCESS.TALKING_1 	

	this.PlaySpeech{
		speakerName = OCELOT_NAME,
		speakerType = OCELOT_GAMEOBJTYPE,
		speechLabel = "MBTS_100"
	}
end



this.OcelotCQCTutStart2 = function()
	Fox.Log("#### s10030_radio.OcelotCQCTutStart2 ####")
	mvars.ocerotTalkProcess = s10030_sequence.OCELOT_TALK_PROCESS.TALKING_2

	this.PlaySpeech{
		speakerName = OCELOT_NAME,
		speakerType = OCELOT_GAMEOBJTYPE,
		speechLabel = "MBTS_101"
	}
	s10030_sequence.displayTips(s10030_sequence.TIPS.ABOUT_CQC)

end



this.PleaseCQCFirst = function()
	Fox.Log("#### s10030_radio.PleaseCQCFirst ####")
	this.PlaySpeech{
		speakerName = OCELOT_NAME,
		speakerType = OCELOT_GAMEOBJTYPE,
		speechLabel = "MBTS_120"
	}
end



this.PleaseCQC = function()
	Fox.Log("#### s10030_radio.PleaseCQC ####")
	this.PlaySpeech{
		speakerName = OCELOT_NAME,
		speakerType = OCELOT_GAMEOBJTYPE,
		speechLabel = "MBTS_125"
	}
end




this.SuccessCQC = function()
	Fox.Log("#### s10030_radio.SuccessCQC ####")
	mvars.ocerotTalkProcess = s10030_sequence.OCELOT_TALK_PROCESS.TALKING_3

	this.PlaySpeech{
		speakerName = OCELOT_NAME,
		speakerType = OCELOT_GAMEOBJTYPE,
		speechLabel = "MBTS_130"
	}
end



this.FultonStart = function()
	Fox.Log("#### s10030_radio.FultonStart ####")

	this.PlaySpeech{
		speakerName = OCELOT_NAME,
		speakerType = OCELOT_GAMEOBJTYPE,
		speechLabel = "MBTS_280"
	}
end



this.ExplainFultonRule2 = function()
	Fox.Log("#### s10030_radio.ExplainFultonRule2 ####")
	mvars.ocerotTalkProcess = s10030_sequence.OCELOT_TALK_PROCESS.TALKING_4 	

	this.PlaySpeech{
		speakerName = OCELOT_NAME,
		speakerType = OCELOT_GAMEOBJTYPE,
		speechLabel = "MBTS_050"
	}

end



this.ExplainFultonRule2_141 = function()
	Fox.Log("#### s10030_radio.ExplainFultonRule2_141 ####")
	mvars.ocerotTalkProcess = s10030_sequence.OCELOT_TALK_PROCESS.TALKING_5	

	this.PlaySpeech{
		speakerName = OCELOT_NAME,
		speakerType = OCELOT_GAMEOBJTYPE,
		speechLabel = "MBTS_141"
	}
end



this.ExplainFultonRule2_142 = function()
	Fox.Log("#### s10030_radio.ExplainFultonRule2_142 ####")
	mvars.ocerotTalkProcess = s10030_sequence.OCELOT_TALK_PROCESS.TALKING_6	

	this.PlaySpeech{
		speakerName = OCELOT_NAME,
		speakerType = OCELOT_GAMEOBJTYPE,
		speechLabel = "MBTS_142"
	}
end



this.ExplainFultonRule2_143 = function()
	Fox.Log("#### s10030_radio.ExplainFultonRule2_143 ####")
	mvars.ocerotTalkProcess = s10030_sequence.OCELOT_TALK_PROCESS.TALKING_7	

	this.PlaySpeech{
		speakerName = OCELOT_NAME,
		speakerType = OCELOT_GAMEOBJTYPE,
		speechLabel = "MBTS_143"
	}

end



this.PleaseFutonNext = function()
	Fox.Log("#### s10030_radio.PleaseFutonNext ####")
	mvars.ocerotTalkProcess = s10030_sequence.OCELOT_TALK_PROCESS.TALKING_8	

	this.PlaySpeech{
		speakerName = OCELOT_NAME,
		speakerType = OCELOT_GAMEOBJTYPE,
		speechLabel = "MBTS_145"
	}
	s10030_sequence.displayTips(s10030_sequence.TIPS.FULTON_RATIO)	

end




this.OcelotCQCTutStart3 = function()
	Fox.Log("#### s10030_radio.OcelotCQCTutStart3 ####")
	this.PlaySpeech{
		speakerName = OCELOT_NAME,
		speakerType = OCELOT_GAMEOBJTYPE,
		speechLabel = "MBTS_150"
	}
end



this.OcelotCQCTutStart4 = function()
	Fox.Log("#### s10030_radio.OcelotCQCTutStart4 ####")
	this.PlaySpeech{
		speakerName = OCELOT_NAME,
		speakerType = OCELOT_GAMEOBJTYPE,
		speechLabel = "MBTS_160"
	}
end



this.BeforeOneMoreFulton = function()
	Fox.Log("#### s10030_radio.BeforeOneMoreFulton ####")

	this.PlaySpeech{
		speakerName = OCELOT_NAME,
		speakerType = OCELOT_GAMEOBJTYPE,
		speechLabel = "MBTS_083"
	}
end




this.OcelotExplainDevelop20_00 = function()
	Fox.Log("#### s10030_radio.OcelotExplainDevelop20_00 ####")
	mvars.ocerotTalkProcess = s10030_sequence.OCELOT_TALK_PROCESS.TALKING_1 	

	this.PlaySpeech{
		speakerName = OCELOT_NAME,
		speakerType = OCELOT_GAMEOBJTYPE,
		speechLabel = "MBTS_077"
	}
end



this.OcelotExplainDevelop20_DevelopBox = function()
	Fox.Log("#### s10030_radio.OcelotExplainDevelop20_DevelopBox ####")
	GkEventTimerManager.Stop( "Timer_waitOpenTerminal")	
	GkEventTimerManager.Stop( "Timer_waitApproachOcelot" )	

	mvars.ocerotTalkProcess = s10030_sequence.OCELOT_TALK_PROCESS.TALKING_2	
	this.PlaySpeech{
		speakerName = OCELOT_NAME,
		speakerType = OCELOT_GAMEOBJTYPE,
		speechLabel = "MBTS_073"
	}

end



this.OcelotExplainDevelop20_Developed = function()
	Fox.Log("#### s10030_radio.OcelotExplainDevelop20_Developed ####")
	TppMission.UpdateObjective{objectives = { "task2_complete" },}	

	GkEventTimerManager.Stop( "Timer_waitOpenTerminal")	
	GkEventTimerManager.Stop( "Timer_waitApproachOcelot" )	

	mvars.ocerotTalkProcess = s10030_sequence.OCELOT_TALK_PROCESS.TALKING_3	
	this.PlaySpeech{
		speakerName = OCELOT_NAME,
		speakerType = OCELOT_GAMEOBJTYPE,
		speechLabel = "MBTS_074"
	}

end



this.OcelotExplainDevelop20_BoxUse = function()
	Fox.Log("#### s10030_radio.OcelotExplainDevelop20_BoxUse ####")
	GkEventTimerManager.Stop( "Timer_waitOpenTerminal")	
	GkEventTimerManager.Stop( "Timer_waitApproachOcelot" )	

	mvars.ocerotTalkProcess = s10030_sequence.OCELOT_TALK_PROCESS.TALKING_4	

	this.PlaySpeech{
		speakerName = OCELOT_NAME,
		speakerType = OCELOT_GAMEOBJTYPE,
		speechLabel = "MBTS_075"
	}
	s10030_sequence.displayTips(s10030_sequence.TIPS.ABOUT_BOX)	

end



this.OcelotExplainDevelop20_Staff = function()
	Fox.Log("#### s10030_radio.OcelotExplainDevelop20_Staff ####")
	mvars.ocerotTalkProcess = s10030_sequence.OCELOT_TALK_PROCESS.TALKING_1

	this.PlaySpeech{
		speakerName = OCELOT_NAME,
		speakerType = OCELOT_GAMEOBJTYPE,
		speechLabel = "MBTS_078"
	}
end



this.BoxBroken = function()
	Fox.Log("#### s10030_radio.BoxBroken ####")
	mvars.ocerotTalkProcess = s10030_sequence.OCELOT_TALK_PROCESS.TALKING_4

	this.PlaySpeech{
		speakerName = OCELOT_NAME,
		speakerType = OCELOT_GAMEOBJTYPE,
		speechLabel = "MBTS_079"
	}
end



this.IntermissionSleep = function()
	Fox.Log("#### s10030_radio.IntermissionSleep ####")

	





end



this.IntermissionFaint = function()
	Fox.Log("#### s10030_radio.IntermissionFaint ####")

	





end



this.IntermissionDown = function()
	Fox.Log("#### s10030_radio.IntermissionUnconsious ####")






end




this.OcelotDevelopTutAllClear = function()
	Fox.Log("#### s10030_radio.OcelotDevelopTutAllClear ####")
	mvars.ocerotTalkProcess = s10030_sequence.OCELOT_TALK_PROCESS.TALKING_1 	

	this.PlaySpeech{
		speakerName = OCELOT_NAME,
		speakerType = OCELOT_GAMEOBJTYPE,
		speechLabel = "MBTS_225"
	}
end



this.OcelotAllClearToHeli = function()
	Fox.Log("#### s10030_radio.OcelotAllClearToHeli ####")
	mvars.ocerotTalkProcess = s10030_sequence.OCELOT_TALK_PROCESS.TALKING_2	

	this.PlaySpeech{
		speakerName = OCELOT_NAME,
		speakerType = OCELOT_GAMEOBJTYPE,
		speechLabel = "MBTS_226"
	}

end



this.OcelotAllClearSetLZ = function()
	Fox.Log("#### s10030_radio.OcelotAllClearSetLZ ####")
	mvars.ocerotTalkProcess = s10030_sequence.OCELOT_TALK_PROCESS.TALKING_3	

	this.PlaySpeech{
		speakerName = OCELOT_NAME,
		speakerType = OCELOT_GAMEOBJTYPE,
		speechLabel = "MBTS_227"
	}
end



this.OcelotAllClearMoreCQC = function()
	Fox.Log("#### s10030_radio.OcelotAllClearMoreCQC ####")
	mvars.ocerotTalkProcess = s10030_sequence.OCELOT_TALK_PROCESS.TALKING_4	

	this.PlaySpeech{
		speakerName = OCELOT_NAME,
		speakerType = OCELOT_GAMEOBJTYPE,
		speechLabel = "MBTS_228"
	}
end




this.OcelotCQCTut20_00 = function()
	Fox.Log("#### s10030_radio.OcelotCQCTut20_00 ####")
	mvars.ocerotTalkProcess = s10030_sequence.OCELOT_TALK_PROCESS.TALKING_1 	

	this.PlaySpeech{
		speakerName = OCELOT_NAME,
		speakerType = OCELOT_GAMEOBJTYPE,
		speechLabel = "MBTS_250"
	}
end



this.OcelotCQCTut20_00_251 = function()
	Fox.Log("#### s10030_radio.OcelotCQCTut20_00_251 ####")
	mvars.ocerotTalkProcess = s10030_sequence.OCELOT_TALK_PROCESS.TALKING_2	

	this.PlaySpeech{
		speakerName = OCELOT_NAME,
		speakerType = OCELOT_GAMEOBJTYPE,
		speechLabel = "MBTS_251"
	}
end



this.OcelotCQCTut20_10 = function()
	Fox.Log("#### s10030_radio.OcelotCQCTut20_10 ####")
	mvars.ocerotTalkProcess = s10030_sequence.OCELOT_TALK_PROCESS.TALKING_3	

	this.PlaySpeech{
		speakerName = OCELOT_NAME,
		speakerType = OCELOT_GAMEOBJTYPE,
		speechLabel = "MBTS_260"
	}
end



this.OcelotCQCTut20_15 = function()
	Fox.Log("#### s10030_radio.OcelotCQCTut20_10 ####")

	if mvars.isAlreadyDown	== true then	
		mvars.ocerotTalkProcess = s10030_sequence.OCELOT_TALK_PROCESS.TALKING_4	
		
		Fox.Log("#### already down ####")
	elseif mvars.isHangConciousTalk == true then
		mvars.ocerotTalkProcess = s10030_sequence.OCELOT_TALK_PROCESS.TALKING_4	
		Fox.Log("#### already request hang conciousd talk ####")
		
	else
		mvars.ocerotTalkProcess = s10030_sequence.OCELOT_TALK_PROCESS.TALKING_4	
		mvars.isHangConciousTalk = true 	


		this.PlaySpeech{
			speakerName = OCELOT_NAME,
			speakerType = OCELOT_GAMEOBJTYPE,
			speechLabel = "MBTS_270"
		}

		s10030_sequence.displayTips(s10030_sequence.TIPS.CQC_CHOKE)	

	end
end




this.OcelotCQCTut20_20 = function()
	Fox.Log("#### s10030_radio.OcelotCQCTut20_20 ####")
	mvars.ocerotTalkProcess = s10030_sequence.OCELOT_TALK_PROCESS.TALKING_5	

	this.PlaySpeech{
		speakerName = OCELOT_NAME,
		speakerType = OCELOT_GAMEOBJTYPE,
		speechLabel = "MBTS_280"
	}
end



this.OcelotCQCTut20_Failed = function()
	Fox.Log("#### s10030_radio.OcelotCQCTut20_20 ####")
	this.PlaySpeech{
		speakerName = OCELOT_NAME,
		speakerType = OCELOT_GAMEOBJTYPE,
		speechLabel = "MBTS_084"
	}
end




this.OcelotCQCTut30_00 = function()
	Fox.Log("#### s10030_radio.OcelotCQCTut30_00 ####")
	mvars.ocerotTalkProcess = s10030_sequence.OCELOT_TALK_PROCESS.TALKING_1 	

	this.PlaySpeech{
		speakerName = OCELOT_NAME,
		speakerType = OCELOT_GAMEOBJTYPE,
		speechLabel = "MBTS_290"
	}
end



this.OcelotCQCTut30_00_291 = function()
	Fox.Log("#### s10030_radio.OcelotCQCTut30_00_291 ####")
	mvars.ocerotTalkProcess = s10030_sequence.OCELOT_TALK_PROCESS.TALKING_2	

	this.PlaySpeech{
		speakerName = OCELOT_NAME,
		speakerType = OCELOT_GAMEOBJTYPE,
		speechLabel = "MBTS_291"
	}
end




this.OcelotCQCTut30_10 = function()
	Fox.Log("#### s10030_radio.OcelotCQCTut30_10 ####")
	this.PlaySpeech{
		speakerName = OCELOT_NAME,
		speakerType = OCELOT_GAMEOBJTYPE,
		speechLabel = "MBTS_300"
	}

end




this.ExplainChainCQC = function()
	Fox.Log("#### s10030_radio.ExplainChainCQC ####")
	this.PlaySpeech{
		speakerName = OCELOT_NAME,
		speakerType = OCELOT_GAMEOBJTYPE,
		speechLabel = "MBTS_350"
	}


end



this.SuccessChainCQC = function()
	Fox.Log("#### s10030_radio.SuccessChainCQC ####")


	this.PlaySpeech{
		speakerName = OCELOT_NAME,
		speakerType = OCELOT_GAMEOBJTYPE,
		speechLabel = "MBTS_360"
	}

end




this.OcelotAllClear = function()
	Fox.Log("#### s10030_radio.OcelotAllClear ####")
	mvars.ocerotTalkProcess = s10030_sequence.OCELOT_TALK_PROCESS.TALKING_1 	

	this.PlaySpeech{
		speakerName = OCELOT_NAME,
		speakerType = OCELOT_GAMEOBJTYPE,
		speechLabel = "MBTS_370"
	}
end



this.OcelotAllClear_CallHeli = function()
	Fox.Log("#### s10030_radio.OcelotAllClear_CallHeli ####")
	mvars.ocerotTalkProcess = s10030_sequence.OCELOT_TALK_PROCESS.TALKING_2	

	this.PlaySpeech{
		speakerName = OCELOT_NAME,
		speakerType = OCELOT_GAMEOBJTYPE,
		speechLabel = "MBTS_371"
	}
end




return this
