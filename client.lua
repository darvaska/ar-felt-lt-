local sx,sy = guiGetScreenSize();
local w,h = guiGetScreenSize();
local function getRSPsize( size )
    return (sx/1920) * size;
end
local windowWidth,windowHeight = getRSPsize(300), getRSPsize(225);
local margin = getRSPsize(10);
local switchSize = getRSPsize(200)
local buttonWidth,buttonHeight = getRSPsize(315), getRSPsize(30);
local time = 750;
local w,h = 380,430;
-----
local joinTick;
local showStartPanel = false;
local showFuvarLevel = false;
local showPaper = false;
local papers = false;
local doorOpen = false;
local doorMove = false;
local col = nil;
-----
local mainfont = dxCreateFont("files/mainfont.ttf",15);
local handFont = dxCreateFont("files/hand.otf",15);
local raktar = dxCreateTexture("files/raktar.png")
-----
local pX, pY, pZ = 627.85858154297, 1261.8985595703, 11.7;
local ped = createPed(math.random(50,120), pX, pY, pZ);
setElementData(ped,"aruPed.Damage",true);
setElementRotation(ped,-0, 0,234.5);
setElementFrozen(ped,true);
-----
local vehMarker = {};
local fuvar = {};
local MarkerHitTick = 0;
-----
local x,y = sx/2-w/2-100,sy/2-h/2+30
local move = {};

local item1 = nil;
local item2 = nil;
local time3 = nil;
local time4 = nil;

function renderPaper()
    if getElementData(localPlayer,"job >> aruF >> paper") == true then
        local text = "Fuvarlevél megjelenítése."
        if showPaper then
            text = "Fuvarlevél elrejtése."
        end
        if isCursorShowing() then 
            local cursorX, cursorY = getCursorPosition();
            local cursorX, cursorY = cursorX * sx, cursorY * sy;
            if move[1] then 
                x = cursorX + move[2];
                y = cursorY + move[3];
            end
        else 
            if move[1] then 
                move = {};
            end
        end
        dxDrawRectangle(sx/2-w/2+65,sy/2-h/2+495,250,25,tocolor(192, 57, 43,150))
        dxDrawText(text,sx/2-w/2,sy/2-h/2+493,sx/2-w/2+w,h,tocolor(255,255,255,255), 1, mainfont, "center", "top", false, false, true, true);
    end
    if showPaper then
        local name = getPlayerName(localPlayer);
        for k,v in pairs(fuvar) do 
            dxDrawImage(x,y,600,320,"files/paper.png",0,0,0,tocolor(255,255,255,250),false)
            dxDrawText(name,x-375,y+52,x+600,y+300,tocolor(0, 0, 0, 255),0.8, mainfont, "center", "top", false, false, true, true) -- név
            dxDrawText("Teherautó",x-0,y+52,x+600,y+300,tocolor(0, 0, 0, 255),0.8, mainfont, "center", "top", false, false, true, true) -- típus
            dxDrawText("JOB-CAR",x+370,y+52,x+600,y+300,tocolor(0, 0, 0, 255),0.8, mainfont, "center", "top", false, false, true, true) -- típus
            dxDrawText(name,x-400,y+265,x+600,y+300,tocolor(0, 0, 0, 255),1, handFont, "center", "top", false, false, true, true) -- név
            dxDrawText(v[2],x-365,y+127,x+600,y+300,tocolor(0, 0, 0, 255),0.8, mainfont, "center", "top", false, false, true, true) -- telephely
            ------------------
            --dxDrawText(itemsToCreate,x+190,y+127,x+600,y+300,tocolor(0, 0, 0, 255),0.8, mainfont, "center", "top", false, false, true, true) -- Árú megnevezése felntről 1.
            --dxDrawText(itemsToCreate,x+70,y+127,x+600,y+300,tocolor(0, 0, 0, 255),0.8, mainfont, "center", "top", false, false, true, true) -- Árú megnevezése felntről 1.
        -- dxDrawText("Liszt,",x+310,y+127,x+600,y+300,tocolor(0, 0, 0, 255),0.8, mainfont, "center", "top", false, false, true, true) -- Árú megnevezése felntről 1.
            ----
            dxDrawText("Cukor",x+190,y+127,x+600,y+300,tocolor(0, 0, 0, 255),0.8, mainfont, "center", "top", false, false, true, true) -- Árú megnevezése felntről 1.
            dxDrawText("Sajt",x+190,y+159,x+600,y+300,tocolor(0, 0, 0, 255),0.8, mainfont, "center", "top", false, false, true, true) -- Árú megnevezése felntről 2.
            dxDrawText("Olaj",x+190,y+192,x+600,y+300,tocolor(0, 0, 0, 255),0.8, mainfont, "center", "top", false, false, true, true) -- Árú megnevezése felntről 3.
            dxDrawText("Víz",x+190,y+225,x+600,y+300,tocolor(0, 0, 0, 255),0.8, mainfont, "center", "top", false, false, true, true) -- Árú megnevezése felntről 4.
        end
    end
    local veh = getPedOccupiedVehicle(localPlayer)
    if veh then
        if getElementModel(veh) == 456 then
            local state = tonumber(getElementData(veh, "door >> state")) or 1
            dxDrawRectangle(sx/2 + windowWidth*2.6, sy/2 - windowHeight/2.2, windowWidth/2, windowHeight/1.2,tocolor(0,0,0,160))
            centerText("Hátfal",sx/2 + buttonWidth*2.22 + margin,  sy/2 - windowHeight/6 - windowHeight/4,  buttonWidth - margin*2,  buttonHeight, tocolor(255,255,255,255), 1, mainfont)
            dxDrawImage(sx/2 + buttonWidth*2.4,  sy/2 - windowHeight/6 - windowHeight/5,switchSize,switchSize,"files/switch"..state..".png",0,0,0,tocolor(255,255,255,255),false)
        end
    end
    dxDrawMaterialLine3D(638.9462890625, 1236.873046875, 13.654847145081, 638.9462890625, 1236.873046875, 12.654847145081, raktar, 3.4133333333333, -2, 700.60760498047, 1270.8283691406, 17.657234191895)
end
--addEventHandler("onClientRender",root,renderPaper);

function renderJobPanel()
    if showStartPanel then
        local height = interpolateBetween(0, 0, 0, windowHeight, 0, 0, (getTickCount()-joinTick)/2000, "InOutBack");
        local width = interpolateBetween(0, 0, 0, windowWidth, 0, 0, (getTickCount()-joinTick)/2000, "InOutBack");
        local button1 = interpolateBetween(0, 0, 0, buttonWidth - margin*2, 0, 0, (getTickCount()-joinTick)/2000, "InOutBack");
        local button2 = interpolateBetween(0, 0, 0, buttonHeight, 0, 0, (getTickCount()-joinTick)/2000, "InOutBack");

        dxDrawRectangle(sx/2 - windowWidth/2, sy/2 - windowHeight/2, width, height,tocolor(0,0,0,160))
        renderButton(sx/2 - buttonWidth/2 + margin,  sy/2 - windowHeight/2 + windowHeight - (buttonHeight*1.8) - (margin*1.88), button1, button2, "Felvétel", tocolor(0,0,0,150), tocolor(48,119,166,255),1)
        renderButton(sx/2 - buttonWidth/2 + margin,  sy/2 - windowHeight/2 + windowHeight - buttonHeight - margin, button1, button2, "Felvétel", tocolor(0,0,0,150), tocolor(233,24,24,180),1)
        if button2 == buttonHeight then
            centerText("Árúfeltöltő",sx/2 - buttonWidth/2 + margin,  sy/2 - windowHeight/2 - windowHeight/4 + margin*2, button1, button2, tocolor(255,255,255,255), 1, mainfont)
            centerText("Kilépés",sx/2 - buttonWidth/2 + margin,  sy/2 - windowHeight/2 + windowHeight - buttonHeight - margin, button1, button2, tocolor(255,255,255,255), 1, mainfont);
            if getElementData(localPlayer,"job >> aruF >> state") == false then
                centerText("Kezdés",sx/2 - buttonWidth/2 + margin,  sy/2 - windowHeight/2 + windowHeight - (buttonHeight*1.8) - (margin*1.88), button1, button2, tocolor(255,255,255,255), 1, mainfont)       
            else
                centerText("Befejezés",sx/2 - buttonWidth/2 + margin,  sy/2 - windowHeight/2 + windowHeight - (buttonHeight*1.8) - (margin*1.88), button1, button2, tocolor(255,255,255,255), 1, mainfont)        
            end
        end
    end
end

function startJob()
    if getElementData(localPlayer,"job >> aruF >> state") == true then
        for k,v in ipairs(getElementsByType("object")) do
            if getElementData(v,"aruF:object") then
                destroyElement(v)
            end
        end
        for k,v in pairs(ObjectsPosition) do
            obj = createObject(2969,v[1],v[2],v[3]-0.86)
            setElementData(obj,"aruF:object",true)
            setElementRotation(obj,v[4],v[5],v[6])
        end
        vehMarker[1] = createMarker(635.95770263672, 1252.9968261719, 11.651686668396,"checkpoint",2,255,0,0,100);
        vehMarker[2] = createBlip(635.95770263672, 1252.9968261719, 11.651686668396,11);
        papers = true;
        local randomItem1 = math.random(1,10);
        local randomItem2 = math.random(1,10);
        local randomItem3 = math.random(1,10);
        local randomItem4 = math.random(1,10);
        local item1 = list[randomItem1][1];
        local item2 = list[randomItem2][1];
        local item3 = list[randomItem3][1];
        local item4 = list[randomItem4][1];
        local randomshop1 = math.random(1,5);
        local randomshop2 = math.random(1,5);
        local randomshop3 = math.random(1,5);
        local randomshop4 = math.random(1,5);
        local shop1,x1,y1,z1 = shop[randomshop1][1],shop[randomshop1][2],shop[randomshop1][3],shop[randomshop1][4];
        local shop2,x2,y2,z2 = shop[randomshop1][1],shop[randomshop1][2],shop[randomshop1][3],shop[randomshop1][4];
        local shop3,x3,y3,z3 = shop[randomshop1][1],shop[randomshop1][2],shop[randomshop1][3],shop[randomshop1][4];
        local shop4,x4,y4,z4 = shop[randomshop1][1],shop[randomshop1][2],shop[randomshop1][3],shop[randomshop1][4];
        fuvar[1] = {item1, shop1,x1,y1,z1}
        fuvar[2] = {item2, shop2,x2,y2,z2}
        fuvar[3] = {item3, shop3,x3,y3,z3}
        fuvar[4] = {item4, shop4,x4,y4,z4}
        addEventHandler("onClientRender",root,renderPaper);
        addEventHandler("onClientMarkerHit",vehMarker[1],function(hitElement)
            if hitElement == localPlayer then 
                local veh = getPedOccupiedVehicle(localPlayer);
                if MarkerHitTick+(1000*10) > getTickCount() then outputChatBox("Csak 10 percenként hívhatsz/adhatsz le járművet!",255,255,255,true) return end;
                if veh then 
                    if veh == getElementData(localPlayer,"jobVeh") then 
                        triggerServerEvent("removeJobVeh",localPlayer,localPlayer);
                        outputChatBox("Munkajárműved törölve");
                        unbindKey("e","down",moveDoboz)
                    else 
                        outputChatBox("Ez nem a munkajárműved!",255,255,255,true);
                        return;
                    end
                else 
                    if getElementData(localPlayer, "jobVehState") == true then
                        triggerServerEvent("removeJobVeh",localPlayer,localPlayer);
                        outputChatBox("Munkajárműved törölve");
                        unbindKey("e","down",moveDoboz)
                    else
                        triggerServerEvent("startJobVeh",localPlayer,localPlayer);
                        bindKey("e","down",moveDoboz)
                        MarkerHitTick = getTickCount();
                    end
                end
            end
        end);
    end
end


function click( button, state, absoluteX, absoluteY, worldX, worldY, worldZ, clickedElement )
    if button == "right" and state == "down" then
        if (clickedElement) and (clickedElement == ped) then
            local px,py,pz = getElementPosition(localPlayer);
            if getDistanceBetweenPoints3D(px,py,pz,worldX,worldY,worldZ) < 3 then 
                if (showStartPanel == false) then
                    addEventHandler("onClientRender",root,renderJobPanel)
                    setElementFrozen(localPlayer,true)
                    joinTick = getTickCount();
                    showStartPanel = true;
                end
            end
        end
    elseif button == "left" and state == "down" then
        if isInSlot(sx/2-w/2+65,sy/2-h/2+495,250,25) then
            showPaper = not showPaper
        end
        if isInSlot(sx/2 + windowWidth*2.73, sy/2 - windowHeight/4, windowWidth/4, windowHeight/2) then
            local veh = getPedOccupiedVehicle(localPlayer);
            if veh then
                if getElementData(localPlayer, "doorMove") then
                    outputChatBox("A hátfal jelenleg mozgásba van!",255,255,255,true);
                else
                    moveTick = getTickCount();
                    addEventHandler("onClientRender", root, moveVehicleDoor);
                    if getElementData(veh, "doorOpen") ~= false then
                        setElementData(veh, "door >> state", 1)
                    else
                        setElementData(veh, "door >> state", 2)
                    end
                end
            end
        end
        if isElement(clickedElement) then
			if getElementType(clickedElement) == "object" then
				if getElementData(clickedElement, "aruF:object") then
					local playerX,playerY,playerZ = getElementPosition(localPlayer)
					local targetX,targetY,targetZ = getElementPosition(clickedElement)
					if getDistanceBetweenPoints3D(playerX,playerY,playerZ,targetX,targetY,targetZ) <= 2.5 then
						if not getElementData(localPlayer,"aruF:object:hand") then
							setElementData(localPlayer,"aruF:object:hand",true);
							destroyElement(clickedElement);
                            triggerServerEvent("createObjectHand",localPlayer,localPlayer);
                            outputChatBox("Sikeresen felvettél egy doboz most pakold be a kocsiba a #FF0000E #FFFFFFgomb segítségével", 255,255,255, true);
						end
					end
                end
            end
        end
    end
    if showPaper then 
        if button == "left" then 
            if state == "down" then 
                if isInSlot(x,y, 600,320) then   
                    move = {};
                    move[1] = true;
                    move[2] = x-cursorX;
                    move[3] = y-cursorY;
                end
            elseif state == "up" then 
                move = {};
            end
        end
    end
end
addEventHandler("onClientClick",root,click)

addEventHandler("onClientKey",root,function(button,state)
    if button == "mouse1" and state then
        if showStartPanel then
            if isInSlot(sx/2 - buttonWidth/2 + margin,  sy/2 - windowHeight/2 + windowHeight - (buttonHeight*1.8) - (margin*1.88), buttonWidth - margin*2, buttonHeight) then
                if getElementData(localPlayer,"job >> aruF >> state") == false then
                    setElementData(localPlayer,"job >> aruF >> state",true);
                    outputChatBox("Sikeresen elkezted a munkád.",255,255,255,true)
                    setElementData(localPlayer,"job >> aruF >> paper", true)
                    startJob()
                    quitJobPanel()
                else 
                    setElementData(localPlayer,"job >> aruF >> state",false);
                    outputChatBox("Sikeresen befejezted a munkát!",255,255,255,true);
                    setElementData(localPlayer,"job >> aruF >> paper", false)
                    stopJob();
                    quitJobPanel();
                end
            elseif isInSlot(sx/2 - buttonWidth/2 + margin,  sy/2 - windowHeight/2 + windowHeight - buttonHeight - margin, buttonWidth - margin*2, buttonHeight) then
                if showStartPanel then
                    quitJobPanel();
                end
            end
        end
    end
end);

function stopJob()
    for k,v in pairs(vehMarker) do 
        if isElement(v) then 
            destroyElement(v);
        end
    end
    vehMarker = {};
    papers = false;
    setElementData(localPlayer,"aruF:object:hand",false);
    removeEventHandler("onClientRender",root,renderPaper);
    triggerServerEvent("removeJobVeh",localPlayer,localPlayer);
end

function quitJobPanel()
    showStartPanel =  not showStartPanel;
    setElementFrozen(localPlayer,false);
    removeEventHandler("onClientRender",root,renderJobPanel);
end    

addEventHandler("onClientPedDamage",root,function()
    if getElementData(source,"aruPed.Damage") then 
        cancelEvent();
    end
end);
addEventHandler("onClientPlayerStealthKill", localPlayer, function(target)
    if getElementData(target,"aruPed.Damage") then 
        cancelEvent();
    end
end)

local cursorState = isCursorShowing()
cursorX, cursorY = 0,0
if cursorState then
    local cursorX, cursorY = getCursorPosition()
    cursorX, cursorY = cursorX * sx, cursorY * sy;
end

addEventHandler("onClientCursorMove", root, 
    function(_, _, x, y)
        cursorX, cursorY = x, y;
    end
)

function isInBox(dX, dY, dSZ, dM, eX, eY)
    local eX, eY = exports['eh_core']:getCursorPosition()
    if(eX >= dX and eX <= dX+dSZ and eY >= dY and eY <= dY+dM) then
        return true;
    else
        return false;
    end
end

function isInSlot(xS,yS,wS,hS)
    if isCursorShowing() then
        if isInBox(xS,yS,wS,hS, cursorX, cursorY) then
            return true;
        else
            return false;
        end
    end 
end

function centerText( text,x,y,w,h,textcolor,size,font)
    dxDrawText( text, x + w/2, y + h/2, x + w/2, y + h/2, textcolor, size, font, "center", "center", false, false, false, true);
end

function renderButton(x,y,w,h,text,backgroundcolor,hovercolor,textSize)
    if( isInSlot(x,y,w,h)) then
        dxDrawRectangle(x,y,w,h, hovercolor);
    else
        dxDrawRectangle(x,y,w,h, backgroundcolor);
    end
end

_dxDrawRectangle = dxDrawRectangle;
dxDrawRectangle = function(left, top, width, height, color, postgui)
	if not postgui then
		postgui = false;
	end

	left, top = left + 2, top + 2;
	width, height = width - 4, height - 4;

	_dxDrawRectangle(left - 2, top, 2, height, color, postgui);
	_dxDrawRectangle(left + width, top, 2, height, color, postgui);
	_dxDrawRectangle(left, top - 2, width, 2, color, postgui);
	_dxDrawRectangle(left, top + height, width, 2, color, postgui);

	_dxDrawRectangle(left - 1, top - 1, 1, 1, color, postgui);
	_dxDrawRectangle(left + width, top - 1, 1, 1, color, postgui);
	_dxDrawRectangle(left - 1, top + height, 1, 1, color, postgui);
	_dxDrawRectangle(left + width, top + height, 1, 1, color, postgui);

	_dxDrawRectangle(left, top, width, height, color, postgui);
end

function dobozDown()
    if getElementData(localPlayer,"aruF:object:hand") then 
        triggerServerEvent("deleteObjectHand",localPlayer,localPlayer);
        local x, y, z = getElementPosition(localPlayer)
        local rotX, rotY, rotZ = getElementRotation(localPlayer)
        local obj = createObject(2969, x, y, z-0.86)
        setElementData(obj,"aruF:object",true)
        setElementRotation(obj,rotX, rotY, rotZ)
    end
end
addCommandHandler("letesz", dobozDown)

function moveDoboz()
    if getElementData(localPlayer,"jobVeh",true) then
        local veh = getElementData(localPlayer,"jobVeh",true)
        local pX, pY, pZ = getVehicleComponentPosition(veh,"bump_rear_dummy","world")
        local px,py,pz = getElementPosition(localPlayer)
        if getDistanceBetweenPoints3D(pX, pY, pZ, px, py, pz) <= 2 then
            if getElementData(veh, "doorOpen") then
                local doboz = tonumber(getElementData(veh,"aruF >> doboz")) or 0
                if getElementData(localPlayer,"aruF:object:hand") then
                    if doboz == 4 then 
                        outputChatBox("A járműre nem fér több doboz #FF00004#FFFFFF/#FF00004",255,255,255,true);
                        triggerServerEvent("deleteObjectHand",localPlayer,localPlayer);
                    else 
                        triggerServerEvent("deleteObjectHand",localPlayer,localPlayer,veh);
                    end
                else
                    if doboz == 0 then 
                        outputChatBox("A járműbe nem található több doboz #FF00000#FFFFFF/#FF00004",255,255,255,true);
                    else 
                        setElementData(localPlayer,"aruF:object:hand",true);
                        triggerServerEvent("createObjectHand",localPlayer,localPlayer, veh);
                    end
                end
            end
        end
    end
end

function moveVehicleDoor()
    setElementData(localPlayer, "doorMove",true);
    local veh = getPedOccupiedVehicle(localPlayer);
    if getElementData(veh, "doorOpen") == false then
        setElementFrozen(veh, true);
        local x1, y1, z1, x2, y2, z2 = 0,0,0,0,0,0;
        local plus = 0
        local progression = (getTickCount() - moveTick) / 5000;
        local actualProgression = interpolateBetween(0,0,0,1,0,0, progression, "Linear")
        local x1, y1, z1 = interpolateBetween(0, 0, 0, 90, 0, 0, actualProgression, "OutQuad")
        local x2, y2, z2 = interpolateBetween(0, 0, 0, 0,  1, 1.2, actualProgression, "OutQuad")
        if actualProgression == 1 then
            local progression2 = (getTickCount() - moveTick) / 5000;
            local actualProgression2 = interpolateBetween(0,0,0,1,0,0, progression2, "SineCurve")
            plus = interpolateBetween(0, 0, 0, 0.6, 0, 0, actualProgression2, "OutQuad")
            if actualProgression2 >= 0.99 then
                removeEventHandler("onClientRender", root, moveVehicleDoor)
                setElementData(veh, "doorOpen", true);
                setElementData(localPlayer, "doorMove",false);
            end
        end
        setVehicleComponentRotation(veh, "boot_dummy", 0 - x1, y1, z1, "root")
        setVehicleComponentPosition(veh, "boot_dummy", 0.0043, -4.58 - y2, 1.129 - z2 - plus, "root")
    else
        local x1, y1, z1, x2, y2, z2 = 0,0,0,0,0,0;
        local plus = 0
        local progression = (getTickCount() - moveTick) / 5000;
        local actualProgression = interpolateBetween(0,0,0,1,0,0, progression, "Linear")
        local plus = interpolateBetween(0, 0, 0, 0.6, 0, 0, actualProgression, "OutQuad")
        if actualProgression == 1 then
            local progression2 = (getTickCount() - moveTick) / 5000;
            local actualProgression2 = interpolateBetween(0,0,0,1,0,0, progression2, "SineCurve")
            x1, y1, z1 = interpolateBetween(0, 0, 0, 90, 0, 0, actualProgression2, "OutQuad")
            x2, y2, z2 = interpolateBetween(0, 0, 0, 0, 1, 1.2, actualProgression2, "OutQuad")
            if actualProgression2 >= 0.99 then
                removeEventHandler("onClientRender", root, moveVehicleDoor)
                setElementFrozen(veh, false);
                setElementData(veh, "doorOpen", false);
                setElementData(localPlayer, "doorMove",false);
            end
        end
        setVehicleComponentRotation(veh, "boot_dummy", 270 + x1, y1, z1, "root")
        setVehicleComponentPosition(veh, "boot_dummy", 0.0043, -5.58 + y2, -0.671 + plus + z2, "root")
    end
end
