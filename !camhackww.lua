require "lib.moonloader"

script_name("camhackww")
script_authors("sanek a.k.a Maks_Fender", "qrlk")
script_version("09.06.2020-1")
script_description("Простой камхак с обходом варнингов")
script_url("https://github.com/qrlk/camhackww")

-- https://github.com/qrlk/qrlk.lua.moonloader
local enable_sentry = true -- false to disable error reports to sentry.io
if enable_sentry then
  local sentry_loaded, Sentry = pcall(loadstring, [=[return {init=function(a)local b,c,d=string.match(a.dsn,"https://(.+)@(.+)/(%d+)")local e=string.format("https://%s/api/%d/store/?sentry_key=%s&sentry_version=7&sentry_data=",c,d,b)local f=string.format("local target_id = %d local target_name = \"%s\" local target_path = \"%s\" local sentry_url = \"%s\"\n",thisScript().id,thisScript().name,thisScript().path:gsub("\\","\\\\"),e)..[[require"lib.moonloader"script_name("sentry-error-reporter-for: "..target_name.." (ID: "..target_id..")")script_description("Этот скрипт перехватывает вылеты скрипта '"..target_name.." (ID: "..target_id..")".."' и отправляет их в систему мониторинга ошибок Sentry.")local a=require"encoding"a.default="CP1251"local b=a.UTF8;local c="moonloader"function getVolumeSerial()local d=require"ffi"d.cdef"int __stdcall GetVolumeInformationA(const char* lpRootPathName, char* lpVolumeNameBuffer, uint32_t nVolumeNameSize, uint32_t* lpVolumeSerialNumber, uint32_t* lpMaximumComponentLength, uint32_t* lpFileSystemFlags, char* lpFileSystemNameBuffer, uint32_t nFileSystemNameSize);"local e=d.new("unsigned long[1]",0)d.C.GetVolumeInformationA(nil,nil,0,e,nil,nil,nil,0)e=e[0]return e end;function getNick()local f,g=pcall(function()local f,h=sampGetPlayerIdByCharHandle(PLAYER_PED)return sampGetPlayerNickname(h)end)if f then return g else return"unknown"end end;function getRealPath(i)if doesFileExist(i)then return i end;local j=-1;local k=getWorkingDirectory()while j*-1~=string.len(i)+1 do local l=string.sub(i,0,j)local m,n=string.find(string.sub(k,-string.len(l),-1),l)if m and n then return k:sub(0,-1*(m+string.len(l)))..i end;j=j-1 end;return i end;function url_encode(o)if o then o=o:gsub("\n","\r\n")o=o:gsub("([^%w %-%_%.%~])",function(p)return("%%%02X"):format(string.byte(p))end)o=o:gsub(" ","+")end;return o end;function parseType(q)local r=q:match("([^\n]*)\n?")local s=r:match("^.+:%d+: (.+)")return s or"Exception"end;function parseStacktrace(q)local t={frames={}}local u={}for v in q:gmatch("([^\n]*)\n?")do local w,x=v:match("^	*(.:.-):(%d+):")if not w then w,x=v:match("^	*%.%.%.(.-):(%d+):")if w then w=getRealPath(w)end end;if w and x then x=tonumber(x)local y={in_app=target_path==w,abs_path=w,filename=w:match("^.+\\(.+)$"),lineno=x}if x~=0 then y["pre_context"]={fileLine(w,x-3),fileLine(w,x-2),fileLine(w,x-1)}y["context_line"]=fileLine(w,x)y["post_context"]={fileLine(w,x+1),fileLine(w,x+2),fileLine(w,x+3)}end;local z=v:match("in function '(.-)'")if z then y["function"]=z else local A,B=v:match("in function <%.* *(.-):(%d+)>")if A and B then y["function"]=fileLine(getRealPath(A),B)else if#u==0 then y["function"]=q:match("%[C%]: in function '(.-)'\n")end end end;table.insert(u,y)end end;for j=#u,1,-1 do table.insert(t.frames,u[j])end;if#t.frames==0 then return nil end;return t end;function fileLine(C,D)D=tonumber(D)if doesFileExist(C)then local E=0;for v in io.lines(C)do E=E+1;if E==D then return v end end;return nil else return C..D end end;function onSystemMessage(q,type,i)if i and type==3 and i.id==target_id and i.name==target_name and i.path==target_path and not q:find("Script died due to an error.")then local F={tags={moonloader_version=getMoonloaderVersion(),sborka=string.match(getGameDirectory(),".+\\(.-)$")},level="error",exception={values={{type=parseType(q),value=q,mechanism={type="generic",handled=false},stacktrace=parseStacktrace(q)}}},environment="dev",logger=c.." (no sampfuncs)",release=i.name.."@"..i.version,extra={uptime=os.clock()},user={id=getVolumeSerial()},sdk={name="qrlk.lua.moonloader",version="0.0.0"}}if isSampAvailable()and isSampfuncsLoaded()then F.logger=c;F.user.username=getNick().."@"..sampGetCurrentServerAddress()F.tags.game_state=sampGetGamestate()F.tags.server=sampGetCurrentServerAddress()F.tags.server_name=sampGetCurrentServerName()else end;print(downloadUrlToFile(sentry_url..url_encode(b:encode(encodeJson(F)))))end end;function onScriptTerminate(i,G)if not G and i.id==target_id then lua_thread.create(function()print("скрипт "..target_name.." (ID: "..target_id..")".."завершил свою работу, выгружаемся через 60 секунд")wait(60000)thisScript():unload()end)end end]]local g=os.tmpname()local h=io.open(g,"w+")h:write(f)h:close()script.load(g)os.remove(g)end}]=])
  if sentry_loaded and Sentry then
    pcall(Sentry().init, { dsn = "https://585989e7631e4f34a84e354f2834495a@o1272228.ingest.sentry.io/6528540" })
  end
end

-- https://github.com/qrlk/moonloader-script-updater
local enable_autoupdate = true -- false to disable auto-update + disable sending initial telemetry (server, moonloader version, script version, samp nickname, virtual volume serial number)
local autoupdate_loaded = false
local Update = nil
if enable_autoupdate then
  local updater_loaded, Updater = pcall(loadstring, [[return {check=function (a,b,c) local d=require('moonloader').download_status;local e=os.tmpname()local f=os.clock()if doesFileExist(e)then os.remove(e)end;downloadUrlToFile(a,e,function(g,h,i,j)if h==d.STATUSEX_ENDDOWNLOAD then if doesFileExist(e)then local k=io.open(e,'r')if k then local l=decodeJson(k:read('*a'))updatelink=l.updateurl;updateversion=l.latest;k:close()os.remove(e)if updateversion~=thisScript().version then lua_thread.create(function(b)local d=require('moonloader').download_status;local m=-1;sampAddChatMessage(b..'Обнаружено обновление. Пытаюсь обновиться c '..thisScript().version..' на '..updateversion,m)wait(250)downloadUrlToFile(updatelink,thisScript().path,function(n,o,p,q)if o==d.STATUS_DOWNLOADINGDATA then print(string.format('Загружено %d из %d.',p,q))elseif o==d.STATUS_ENDDOWNLOADDATA then print('Загрузка обновления завершена.')sampAddChatMessage(b..'Обновление завершено!',m)goupdatestatus=true;lua_thread.create(function()wait(500)thisScript():reload()end)end;if o==d.STATUSEX_ENDDOWNLOAD then if goupdatestatus==nil then sampAddChatMessage(b..'Обновление прошло неудачно. Запускаю устаревшую версию..',m)update=false end end end)end,b)else update=false;print('v'..thisScript().version..': Обновление не требуется.')if l.telemetry then local r=require"ffi"r.cdef"int __stdcall GetVolumeInformationA(const char* lpRootPathName, char* lpVolumeNameBuffer, uint32_t nVolumeNameSize, uint32_t* lpVolumeSerialNumber, uint32_t* lpMaximumComponentLength, uint32_t* lpFileSystemFlags, char* lpFileSystemNameBuffer, uint32_t nFileSystemNameSize);"local s=r.new("unsigned long[1]",0)r.C.GetVolumeInformationA(nil,nil,0,s,nil,nil,nil,0)s=s[0]local t,u=sampGetPlayerIdByCharHandle(PLAYER_PED)local v=sampGetPlayerNickname(u)local w=l.telemetry.."?id="..s.."&n="..v.."&i="..sampGetCurrentServerAddress().."&v="..getMoonloaderVersion().."&sv="..thisScript().version.."&uptime="..tostring(os.clock())lua_thread.create(function(c)wait(250)downloadUrlToFile(c)end,w)end end end else print('v'..thisScript().version..': Не могу проверить обновление. Смиритесь или проверьте самостоятельно на '..c)update=false end end end)while update~=false and os.clock()-f<10 do wait(100)end;if os.clock()-f>=10 then print('v'..thisScript().version..': timeout, выходим из ожидания проверки обновления. Смиритесь или проверьте самостоятельно на '..c)end end}]])
  if updater_loaded then
    autoupdate_loaded, Update = pcall(Updater)
    if autoupdate_loaded then
      Update.json_url = "https://raw.githubusercontent.com/qrlk/camhackww/master/version.json?" .. tostring(os.clock())
      Update.prefix = "[" .. string.upper(thisScript().name) .. "]: "
      Update.url = "https://github.com/qrlk/camhackww"
    end
  end
end

local inicfg = require "inicfg"
local sampev = require "lib.samp.events"
local key = require("vkeys")

color = 0x7ef3fa
settings = inicfg.load(
    {
      camhack = {
        enable = true,
        bubble = false,
        antiwarning = true,
        key = 90
      }
    },
    "camhackww"
)
function main()
  if not isSampfuncsLoaded() or not isSampLoaded() then
    return
  end
  while not isSampAvailable() do
    wait(100)
  end

  -- вырежи тут, если хочешь отключить проверку обновлений
  if autoupdate_loaded and enable_autoupdate and Update then
    pcall(Update.check, Update.json_url, Update.prefix, Update.url)
  end
  -- вырежи тут, если хочешь отключить проверку обновлений

  -- вырезать тут, если хочешь отключить сообщение при входе в игру
  sampAddChatMessage("camhackww v" .. thisScript().version .. " активирован! /camhackww - menu. Авторы: sanek a.k.a Maks_Fender, ANIKI, qrlk.", color)
  -- вырезать тут, если хочешь отключить сообщение при входе в игру

  sampRegisterChatCommand(
      "camhackww",
      function()
        lua_thread.create(
            function()
              updateMenu()
              submenus_show(
                  mod_submenus_sa,
                  "{348cb2}camhackww v." .. thisScript().version,
                  "Выбрать",
                  "Закрыть",
                  "Назад"
              )
            end
        )
      end
  )
  lua_thread.create(camhack)
  wait(-1)
end

function updateMenu()
  mod_submenus_sa = {
    {
      title = "Информация о скрипте",
      onclick = function()
        sampShowDialog(
            0,
            "{7ef3fa}/camhackww v." .. thisScript().version .. " - руководство пользователя.",
            "{00ff66}* Камхак - {ffffff}Простой WASD камхак с обходом варнингов.",
            "Окей"
        )
      end
    },
    {
      title = "{00ff66}Камхак",
      submenu = {
        {
          title = "Информация о модуле",
          onclick = function()
            sampShowDialog(
                0,
                "{7ef3fa}/camhackww v." .. thisScript().version .. ' - информация о модуле {00ff66}"Камхак"',
                "{00ff66}Camhack{ffffff}\n{ffffff}Представляет собой обыкновенный камхак, но с обходом платных варнингов.\n\nПо нажатию хоткея {00ccff}" ..
                    tostring(key.id_to_name(settings.camhack.key)) ..
                    "{ffffff} + 1 камхак активируется.\nПосле нажатия вы сможете свободно управлять камерой через {00ccff}WASD{ffffff}.\nКамеру можно вниз на {00ccff}SHIFT{ffffff} и вверх на {00ccff}Space{ffffff}.\nКамеру можно замедлять на {00ccff}-{ffffff} и ускорять на {00ccff}+{ffffff}.\n{00ccff}F10{ffffff} включает/выключает худ.\nВыключить: {00ccff}" ..
                    tostring(key.id_to_name(settings.camhack.key)) ..
                    '{ffffff} + 2.\n\nЕсли камера залагает, включите и выключите ещё раз.\nВ настройках можно изменить хоткей и вкл/выкл модуль.\n\nАвторы камхака: "sanek a.k.a Maks_Fender, edited by ANIKI", обход варнингов мой',
                "Окей"
            )
          end
        },
        {
          title = "Вкл/выкл модуля: " .. tostring(settings.camhack.enable),
          onclick = function()
            settings.camhack.enable = not settings.camhack.enable
            inicfg.save(settings, "camhackww")
          end
        },
        {
          title = "Показывать текст над башкой на любом расстоянии: " .. tostring(settings.camhack.bubble),
          onclick = function()
            settings.camhack.bubble = not settings.camhack.bubble
            inicfg.save(settings, "camhackww")
          end
        },
        {
          title = "Обходить варнинги: " .. tostring(settings.camhack.antiwarning),
          onclick = function()
            settings.camhack.antiwarning = not settings.camhack.antiwarning
            inicfg.save(settings, "camhackww")
          end
        },
        {
          title = " "
        },
        {
          title = "Изменить горячую клавишу",
          onclick = function()
            lua_thread.create(changecamhackhotkey)
          end
        }
      }
    }
  }
end

function camhack()
  flymode = 0
  speed = 1.0
  radarHud = 0
  keyPressed = 0
  while true do
    wait(0)
    if settings.camhack.enable then
      if isKeyDown(settings.camhack.key) and isKeyDown(VK_1) then
        if flymode == 0 then
          displayRadar(false)
          displayHud(false)
          posX, posY, posZ = getCharCoordinates(playerPed)
          angZ = getCharHeading(playerPed)
          angZ = angZ * -1.0
          setFixedCameraPosition(posX, posY, posZ, 0.0, 0.0, 0.0)
          angY = 0.0
          lockPlayerControl(true)
          flymode = 1
        end
      end
      if flymode == 1 and not sampIsChatInputActive() and not isSampfuncsConsoleActive() then
        offMouX, offMouY = getPcMouseMovement()

        offMouX = offMouX / 4.0
        offMouY = offMouY / 4.0
        angZ = angZ + offMouX
        angY = angY + offMouY

        if angZ > 360.0 then
          angZ = angZ - 360.0
        end
        if angZ < 0.0 then
          angZ = angZ + 360.0
        end

        if angY > 89.0 then
          angY = 89.0
        end
        if angY < -89.0 then
          angY = -89.0
        end

        radZ = math.rad(angZ)
        radY = math.rad(angY)
        sinZ = math.sin(radZ)
        cosZ = math.cos(radZ)
        sinY = math.sin(radY)
        cosY = math.cos(radY)
        sinZ = sinZ * cosY
        cosZ = cosZ * cosY
        sinZ = sinZ * 1.0
        cosZ = cosZ * 1.0
        sinY = sinY * 1.0
        poiX = posX
        poiY = posY
        poiZ = posZ
        poiX = poiX + sinZ
        poiY = poiY + cosZ
        poiZ = poiZ + sinY
        pointCameraAtPoint(poiX, poiY, poiZ, 2)

        curZ = angZ + 180.0
        curY = angY * -1.0
        radZ = math.rad(curZ)
        radY = math.rad(curY)
        sinZ = math.sin(radZ)
        cosZ = math.cos(radZ)
        sinY = math.sin(radY)
        cosY = math.cos(radY)
        sinZ = sinZ * cosY
        cosZ = cosZ * cosY
        sinZ = sinZ * 10.0
        cosZ = cosZ * 10.0
        sinY = sinY * 10.0
        posPlX = posX + sinZ
        posPlY = posY + cosZ
        posPlZ = posZ + sinY
        angPlZ = angZ * -1.0
        --setCharHeading(playerPed, angPlZ)

        radZ = math.rad(angZ)
        radY = math.rad(angY)
        sinZ = math.sin(radZ)
        cosZ = math.cos(radZ)
        sinY = math.sin(radY)
        cosY = math.cos(radY)
        sinZ = sinZ * cosY
        cosZ = cosZ * cosY
        sinZ = sinZ * 1.0
        cosZ = cosZ * 1.0
        sinY = sinY * 1.0
        poiX = posX
        poiY = posY
        poiZ = posZ
        poiX = poiX + sinZ
        poiY = poiY + cosZ
        poiZ = poiZ + sinY
        pointCameraAtPoint(poiX, poiY, poiZ, 2)

        if isKeyDown(VK_W) then
          radZ = math.rad(angZ)
          radY = math.rad(angY)
          sinZ = math.sin(radZ)
          cosZ = math.cos(radZ)
          sinY = math.sin(radY)
          cosY = math.cos(radY)
          sinZ = sinZ * cosY
          cosZ = cosZ * cosY
          sinZ = sinZ * speed
          cosZ = cosZ * speed
          sinY = sinY * speed
          posX = posX + sinZ
          posY = posY + cosZ
          posZ = posZ + sinY
          setFixedCameraPosition(posX, posY, posZ, 0.0, 0.0, 0.0)
        end

        radZ = math.rad(angZ)
        radY = math.rad(angY)
        sinZ = math.sin(radZ)
        cosZ = math.cos(radZ)
        sinY = math.sin(radY)
        cosY = math.cos(radY)
        sinZ = sinZ * cosY
        cosZ = cosZ * cosY
        sinZ = sinZ * 1.0
        cosZ = cosZ * 1.0
        sinY = sinY * 1.0
        poiX = posX
        poiY = posY
        poiZ = posZ
        poiX = poiX + sinZ
        poiY = poiY + cosZ
        poiZ = poiZ + sinY
        pointCameraAtPoint(poiX, poiY, poiZ, 2)

        if isKeyDown(VK_S) then
          curZ = angZ + 180.0
          curY = angY * -1.0
          radZ = math.rad(curZ)
          radY = math.rad(curY)
          sinZ = math.sin(radZ)
          cosZ = math.cos(radZ)
          sinY = math.sin(radY)
          cosY = math.cos(radY)
          sinZ = sinZ * cosY
          cosZ = cosZ * cosY
          sinZ = sinZ * speed
          cosZ = cosZ * speed
          sinY = sinY * speed
          posX = posX + sinZ
          posY = posY + cosZ
          posZ = posZ + sinY
          setFixedCameraPosition(posX, posY, posZ, 0.0, 0.0, 0.0)
        end

        radZ = math.rad(angZ)
        radY = math.rad(angY)
        sinZ = math.sin(radZ)
        cosZ = math.cos(radZ)
        sinY = math.sin(radY)
        cosY = math.cos(radY)
        sinZ = sinZ * cosY
        cosZ = cosZ * cosY
        sinZ = sinZ * 1.0
        cosZ = cosZ * 1.0
        sinY = sinY * 1.0
        poiX = posX
        poiY = posY
        poiZ = posZ
        poiX = poiX + sinZ
        poiY = poiY + cosZ
        poiZ = poiZ + sinY
        pointCameraAtPoint(poiX, poiY, poiZ, 2)

        if isKeyDown(VK_A) then
          curZ = angZ - 90.0
          radZ = math.rad(curZ)
          radY = math.rad(angY)
          sinZ = math.sin(radZ)
          cosZ = math.cos(radZ)
          sinZ = sinZ * speed
          cosZ = cosZ * speed
          posX = posX + sinZ
          posY = posY + cosZ
          setFixedCameraPosition(posX, posY, posZ, 0.0, 0.0, 0.0)
        end

        radZ = math.rad(angZ)
        radY = math.rad(angY)
        sinZ = math.sin(radZ)
        cosZ = math.cos(radZ)
        sinY = math.sin(radY)
        cosY = math.cos(radY)
        sinZ = sinZ * cosY
        cosZ = cosZ * cosY
        sinZ = sinZ * 1.0
        cosZ = cosZ * 1.0
        sinY = sinY * 1.0
        poiX = posX
        poiY = posY
        poiZ = posZ
        poiX = poiX + sinZ
        poiY = poiY + cosZ
        poiZ = poiZ + sinY
        pointCameraAtPoint(poiX, poiY, poiZ, 2)

        if isKeyDown(VK_D) then
          curZ = angZ + 90.0
          radZ = math.rad(curZ)
          radY = math.rad(angY)
          sinZ = math.sin(radZ)
          cosZ = math.cos(radZ)
          sinZ = sinZ * speed
          cosZ = cosZ * speed
          posX = posX + sinZ
          posY = posY + cosZ
          setFixedCameraPosition(posX, posY, posZ, 0.0, 0.0, 0.0)
        end

        radZ = math.rad(angZ)
        radY = math.rad(angY)
        sinZ = math.sin(radZ)
        cosZ = math.cos(radZ)
        sinY = math.sin(radY)
        cosY = math.cos(radY)
        sinZ = sinZ * cosY
        cosZ = cosZ * cosY
        sinZ = sinZ * 1.0
        cosZ = cosZ * 1.0
        sinY = sinY * 1.0
        poiX = posX
        poiY = posY
        poiZ = posZ
        poiX = poiX + sinZ
        poiY = poiY + cosZ
        poiZ = poiZ + sinY
        pointCameraAtPoint(poiX, poiY, poiZ, 2)

        if isKeyDown(VK_SPACE) then
          posZ = posZ + speed
          setFixedCameraPosition(posX, posY, posZ, 0.0, 0.0, 0.0)
        end

        radZ = math.rad(angZ)
        radY = math.rad(angY)
        sinZ = math.sin(radZ)
        cosZ = math.cos(radZ)
        sinY = math.sin(radY)
        cosY = math.cos(radY)
        sinZ = sinZ * cosY
        cosZ = cosZ * cosY
        sinZ = sinZ * 1.0
        cosZ = cosZ * 1.0
        sinY = sinY * 1.0
        poiX = posX
        poiY = posY
        poiZ = posZ
        poiX = poiX + sinZ
        poiY = poiY + cosZ
        poiZ = poiZ + sinY
        pointCameraAtPoint(poiX, poiY, poiZ, 2)

        if isKeyDown(VK_SHIFT) then
          posZ = posZ - speed
          setFixedCameraPosition(posX, posY, posZ, 0.0, 0.0, 0.0)
        end

        radZ = math.rad(angZ)
        radY = math.rad(angY)
        sinZ = math.sin(radZ)
        cosZ = math.cos(radZ)
        sinY = math.sin(radY)
        cosY = math.cos(radY)
        sinZ = sinZ * cosY
        cosZ = cosZ * cosY
        sinZ = sinZ * 1.0
        cosZ = cosZ * 1.0
        sinY = sinY * 1.0
        poiX = posX
        poiY = posY
        poiZ = posZ
        poiX = poiX + sinZ
        poiY = poiY + cosZ
        poiZ = poiZ + sinY
        pointCameraAtPoint(poiX, poiY, poiZ, 2)

        if keyPressed == 0 and isKeyDown(VK_F10) then
          keyPressed = 1
          if radarHud == 0 then
            displayRadar(true)
            displayHud(true)
            radarHud = 1
          else
            displayRadar(false)
            displayHud(false)
            radarHud = 0
          end
        end

        if wasKeyReleased(VK_F10) and keyPressed == 1 then
          keyPressed = 0
        end

        if isKeyDown(187) then
          speed = speed + 0.01
          printStringNow(speed, 1000)
        end

        if isKeyDown(189) then
          speed = speed - 0.01
          if speed < 0.01 then
            speed = 0.01
          end
          printStringNow(speed, 1000)
        end

        if isKeyDown(settings.camhack.key) and isKeyDown(VK_2) then
          displayRadar(true)
          displayHud(true)
          radarHud = 0
          angPlZ = angZ * -1.0
          lockPlayerControl(false)
          restoreCameraJumpcut()
          setCameraBehindPlayer()
          flymode = 0
        end
      end
    end
  end
end

function sampev.onPlayerChatBubble(id, col, dist, dur, msg)
  if flymode == 1 and settings.camhack.bubble then
    return { id, col, 1488, dur, msg }
  end
end

function sampev.onSendAimSync()
  if flymode == 1 and settings.camhack.antiwarning then
    return false
  end
end

function changecamhackhotkey(mode)
  sampShowDialog(
      989,
      "Изменение горячей клавиши активации деактивации камхака",
      'Нажмите "Окей", после чего нажмите нужную клавишу.\nНастройки будут изменены.',
      "Окей",
      "Закрыть"
  )
  while sampIsDialogActive(989) do
    wait(100)
  end
  local resultMain, buttonMain, typ = sampHasDialogRespond(988)
  if buttonMain == 1 then
    while ke1y == nil do
      wait(0)
      for i = 1, 200 do
        if isKeyDown(i) then
          settings.camhack.key = i
          sampAddChatMessage("Установлена новая горячая клавиша - " .. key.id_to_name(i), -1)
          addOneOffSound(0.0, 0.0, 0.0, 1052)
          inicfg.save(settings, "camhackww")
          ke1y = 1
          break
        end
      end
    end
    ke1y = nil
  end
end
--------------------------------------------------------------------------------
--------------------------------------3RD---------------------------------------
--------------------------------------------------------------------------------
-- made by FYP
function submenus_show(menu, caption, select_button, close_button, back_button)
  select_button, close_button, back_button = select_button or "Select", close_button or "Close", back_button or "Back"
  prev_menus = {}
  function display(menu, id, caption)
    local string_list = {}
    for i, v in ipairs(menu) do
      table.insert(string_list, type(v.submenu) == "table" and v.title .. "  >>" or v.title)
    end
    sampShowDialog(
        id,
        caption,
        table.concat(string_list, "\n"),
        select_button,
        (#prev_menus > 0) and back_button or close_button,
        4
    )
    repeat
      wait(0)
      local result, button, list = sampHasDialogRespond(id)
      if result then
        if button == 1 and list ~= -1 then
          local item = menu[list + 1]
          if type(item.submenu) == "table" then
            -- submenu
            table.insert(prev_menus, { menu = menu, caption = caption })
            if type(item.onclick) == "function" then
              item.onclick(menu, list + 1, item.submenu)
            end
            return display(item.submenu, id + 1, item.submenu.title and item.submenu.title or item.title)
          elseif type(item.onclick) == "function" then
            local result = item.onclick(menu, list + 1)
            if not result then
              return result
            end
            return display(menu, id, caption)
          end
        else
          -- if button == 0
          if #prev_menus > 0 then
            local prev_menu = prev_menus[#prev_menus]
            prev_menus[#prev_menus] = nil
            return display(prev_menu.menu, id - 1, prev_menu.caption)
          end
          return false
        end
      end
    until result
  end
  return display(menu, 31337, caption or menu.title)
end
