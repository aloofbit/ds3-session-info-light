{
Author: Aloofbit
Hi, this is a modified version of the session info UI made by inuNorii
}
[ENABLE]
{$lua}
if syntaxcheck then return end
SessionInfoLight.Show()
fileLocation = "C:/Users/canyon/Desktop/store/session_info.txt"
playerAddresses = { "38", "70", "A8", "E0", "XB" }
playersOutput = {}
-- place bad words to star out here
badwords = {""}

function SessionInfoUpdate(timer)
  playersOutput = {}
  for i, playerAddress in pairs(playerAddresses) do
    if readInteger("[[[BaseB]+40]+"..playerAddress.."]+0") then
      local name = readString("[[[[BaseB]+40]+"..playerAddress.."]+XB]+88",32,1)
      local sl = readInteger("[[[[BaseB]+40]+"..playerAddress.."]+XB]+70")
      local wl =readBytes("[[[[BaseB]+40]+"..playerAddress.."]+XB]+B3")
      if (name and sl and wl) then table.insert(playersOutput, name .. " " .. sl .. " +" .. wl) end
    end
  end

  singleLine = ""
  for i=1, 5, 1 do
     local text =((playersOutput[i] ~= nil) and playersOutput[i] or nil)
     control_setCaption(SessionInfoLight["P"..i.."_Text"], text)
     if (text ~= nil) then
       singleLine = singleLine .. ((i > 1) and " | " or " ") .. text
     end

  end

  -- profanity filter
  for i, badword in ipairs(badwords) do
    singleLine:lower():gsub(badword, "***")
  end

  if (fileLocation ~= nil) then
    file = io.open(fileLocation, "w+")
    io.output(file)
    io.write(singleLine)
    io.close(file)
  end

end

SessionInfoTimer = createTimer(getMainForm())
SessionInfoTimer.Interval = 200
SessionInfoTimer.OnTimer = SessionInfoUpdate
SessionInfoTimer.setEnabled(true)

[DISABLE]
{$lua}
if syntaxcheck then return end
SessionInfoLight.Hide()

if(SessionInfoTimer ~= nil) then
SessionInfoTimer.destroy()

if (fileLocation ~= nil) then
    file = io.open(fileLocation, "w+")
    io.output(file)
    io.write('')
    io.close(file)
  end
end
