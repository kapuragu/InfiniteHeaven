HalfPointLight = {

-- CreateToolで作られた位置をPlaneのPositionへ
CreateToolCommand = function( position )
    local   data, body

    data, body = Command.CreateData( "HalfPointLight" )
    data.halfPlanePosition = position

    return  data, body
end,

}