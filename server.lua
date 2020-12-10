addEvent("startJobVeh",true);
addEventHandler("startJobVeh",root,function(player)
    local x,y,z = getElementPosition(player);
    local rx,ry,rz = getElementRotation(player);
    local veh = createVehicle(456,x,y,z,rx,ry,rz,"JOB-CAR",0,0);
    setVehicleEngineState(veh,true);
    setVehicleVariant(veh, 1, 1);
    setElementAlpha(veh, 0);
    setVehicleDamageProof(veh,true);
    setTimer(function(veh) 
        local alpha = getElementAlpha(veh);
        setElementAlpha(veh, alpha+63.75);
        if(alpha+63.75 >= 250) then
            setElementAlpha(veh, 255)
            setVehicleDamageProof(veh,false);
            setElementData(player,"jobVeh",veh);
            setElementData(player,"jobVehState", true);
        end
    end, 1000, 4, veh)
    warpPedIntoVehicle(player,veh);
end);

addEvent("removeJobVeh",true);
addEventHandler("removeJobVeh",root,function(player)
    local veh = getElementData(player,"jobVeh");
    if not isElement(veh) then 
        setElementData(player,"jobVehState",false) 
        setElementData(player,"jobVeh",nil)
    else
        for k,v in pairs(getAttachedElements(veh)) do
            if isElement(v) then 
                destroyElement(v);
            end
        end
        setElementData(veh,"aruF >> doboz", 0);
        destroyElement(veh);
        setElementData(player,"jobVehState",false);
        setElementData(player,"jobVeh",nil)
    end
end);

addEvent("createObjectHand", true)
addEventHandler("createObjectHand",getRootElement(),function(player, veh)
    local obj = createObject(2969,0,0,0);
    exports.cr_bone_attach:attachElementToBone(obj,player,12,0.18,0.12,0,-90,0,-15);
    setPedAnimation(player, "CARRY", "crry_prtial", 0, true, false, true, true);
    setElementData(player,"aruF >> ObjHand",obj);
    toggleControl(player,"fire", false);
    toggleControl(player,"sprint", false);
    toggleControl(player,"crouch", false);
    toggleControl(player,"jump", false);
    if veh then
        setElementData(veh,"aruF >> doboz",(getElementData(veh,"aruF >> doboz") or 0) - 1);
        outputChatBox("Sikeresen kivetél egy dobozt! A járműbe lévő dobozok száma #FF0000"..getElementData(veh,"aruF >> doboz").."#FFFFFF / #FF00004", player, 255,255,255, true);
    end
end)

addEvent("deleteObjectHand", true)
addEventHandler("deleteObjectHand",getRootElement(),function(player, veh)
    local obj = getElementData(player,"aruF >> ObjHand");
    if obj and isElement(obj) then 
        destroyElement(obj);
        exports.cr_bone_attach:detachElementFromBone(obj)
		toggleControl(player,"fire", true)
		toggleControl(player,"sprint", true)
		toggleControl(player,"crouch", true)
		toggleControl(player,"jump", true)
		setElementData(player,"aruF:object:hand",false)
        setElementData(player,"aruF >> ObjHand",false);
        if veh then
            setElementData(veh,"aruF >> doboz",(getElementData(veh,"aruF >> doboz") or 0) + 1);
            outputChatBox("Sikeresen beraktál egy dobozt!A járműbe lévő dobozok száma #FF0000"..getElementData(veh,"aruF >> doboz").."#FFFFFF / #FF00004", player, 255,255,255, true);
        end
    end
end)

addEventHandler("onPlayerQuit", getRootElement(),
function()
    setElementData(source,"aruF:object:hand",false);
    setElementData(source,"job >> aruF >> state",false);
    setElementData(source,"job >> aruF >> paper", false);
    local veh = getElementData(source,"jobVeh");
    if not isElement(veh) then 
        setElementData(source,"jobVehState",false);
        setElementData(source,"jobVeh",nil);
    else
        for k,v in pairs(getAttachedElements(veh)) do
            if isElement(v) then 
                destroyElement(v);
            end
        end
        setElementData(veh,"aruF >> doboz", 0);
        destroyElement(veh);
        setElementData(source,"jobVehState",false);
        setElementData(source,"jobVeh",nil);
    end
end);

function exit(player) 
    if getElementData(player, "doorMove") then 
        outputChatBox("Amig a hátfal mozgásba van addig nem szálhatsz ki!",player, 255,255,255,true);
        cancelEvent()
    end
 end
 addEventHandler ( "onVehicleStartExit", getRootElement(), exit)