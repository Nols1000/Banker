function Banker:mDebug(...)
	if self:getConfigValue("debug") then
		CHAT_SYSTEM:AddMessage("[BANKER] " .. string.format(...))
	end
end

function Banker:msg(...)
	if self:getConfigValue("msg") then
		CHAT_SYSTEM:AddMessage(string.format(...))
	end
end