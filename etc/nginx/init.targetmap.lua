function readfile(filename)
        local f = assert(io.open(filename, "r"))
        local content = f:read("*all")
        f:close()
        return content
end

local filedict = ngx.shared.rsafilenamekeymap
ngx.shared.rsafilenamekeymap:set( 'jwt_desktop_signing_public_key',  '/config.signing/abcdesktop_jwt_desktop_signing_public_key.pem'  )
ngx.shared.rsafilenamekeymap:set( 'jwt_desktop_payload_private_key', '/config.payload/abcdesktop_jwt_desktop_payload_private_key.pem' )
local jwt_secret = readfile( ngx.shared.rsafilenamekeymap:get( 'jwt_desktop_signing_public_key') )
ngx.shared.rsakeymap:set( 'jwt_desktop_signing_public_key', jwt_secret )
local private_key = readfile( ngx.shared.rsafilenamekeymap:get('jwt_desktop_payload_private_key') )
ngx.shared.rsakeymap:set( 'jwt_desktop_payload_private_key', private_key )

