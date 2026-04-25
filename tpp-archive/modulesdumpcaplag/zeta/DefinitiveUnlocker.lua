--DDogMillerOcelot.Lua
local this={
	modName = "Definitive Unlocker",
	modDesc = "Don't gotta buy two games you already own for a texture",
	modCategory = "Misc",
	modAuthor = "caplag",
}

function this.EquipDevelopConstSetting()
	local invalid=65535
    return{
        {
            ["equipDevelopID"]=2030,--WEAPON_MACHT_P5_WEISS
            ["bluePrintId"]=invalid,
        },
        {
            ["equipDevelopID"]=4060,--WEAPON_RASP_SB_SG_GOLD
            ["bluePrintId"]=invalid,
        },
        {
            ["equipDevelopID"]=9010,--WEAPON_PB_SHIELD_SIL
            ["bluePrintId"]=invalid,
        },
        {
            ["equipDevelopID"]=9011,--WEAPON_PB_SHIELD_OD
            ["bluePrintId"]=invalid,
        },
        {
            ["equipDevelopID"]=9012,--WEAPON_PB_SHIELD_WHT
            ["bluePrintId"]=invalid,
        },
        {
            ["equipDevelopID"]=9013,--WEAPON_PB_SHIELD_GLD
            ["bluePrintId"]=invalid,
        },
        {
            ["equipDevelopID"]=12010,--ITEM_CBOX_APD
            ["bluePrintId"]=invalid,
        },
        {
            ["equipDevelopID"]=12011,--ITEM_CBOX_RT
            ["bluePrintId"]=invalid,
        },
        {
            ["equipDevelopID"]=12012,--ITEM_CBOX_WET
            ["bluePrintId"]=invalid,
        },
        {
            ["equipDevelopID"]=19032,--SUIT_FATIGUES_APD
            ["bluePrintId"]=invalid,
        },
        {
            ["equipDevelopID"]=19030,--SUIT_FATIGUES_GRAY_URBAN
            ["bluePrintId"]=invalid,
        },
        {
            ["equipDevelopID"]=19031,--SUIT_FATIGUES_BLUE_URBAN
            ["bluePrintId"]=invalid,
        },
        {
            ["equipDevelopID"]=19033,--SUIT_FATIGUES_BLACK_OCELOT
            ["bluePrintId"]=invalid,
        },
        {
            ["equipDevelopID"]=1090,--WEAPON_ADAM_SKA_SP
            ["bluePrintId"]=invalid,
        },
        {
            ["equipDevelopID"]=1091,--WEAPON_WU_S333_CB_SP
            ["bluePrintId"]=invalid,
        },
    }
end

return this