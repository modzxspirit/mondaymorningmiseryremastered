--no skid pls
local userInputService = game:GetService('UserInputService')
local fireSignal do
    -- updated for script-ware or whatever
    -- attempted to update for krnl 
    local set_identity = (type(syn) == 'table' and syn.set_thread_identity) or setidentity or setthreadcontext
    function fireSignal(target, signal, ...)    
        -- getconnections with InputBegan / InputEnded does not work without setting Synapse to the game's context level
        set_identity(2) 
        for _, signal in next, getconnections(signal) do
            if type(signal.Function) == 'function' and islclosure(signal.Function) then
                local scr = rawget(getfenv(signal.Function), 'script')
                if scr == target then
                    pcall(signal.Function, ...)
                end
            end
        end
        set_identity(7)
    end

local g = "https://discord.gg/QdaJDDvRHN"
local Notify=function(Title,Text,Duration)game.StarterGui:SetCore("SendNotification",{Title=Title,Text=Text,Duration=Duration or 1})end --useless XD
local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/wally-rblx/uwuware-ui/main/main.lua"))() --OMG IP LOGGER!!!!
local Window = library:CreateWindow("CoolUI MMM AP")
Window:AddToggle({text = "Toggle autoplayer", flag = "AP" })
Window:AddButton({text = "Destroy Gui", callback = function()pcall(function()game:GetService("CoreGui").ScreenGui:Destroy()end)end})
Window:AddButton({text = "Copy discord invite",callback=function()
if setclipboard then
    Notify("Success","Discord invite is in your clipboard")
    setclipboard(g)
else
    Notify("","Exploit doesn't support 'setclipboard', see invite in F9 menu")
    print("\n\n== DISCORD INVITE ==\n" .. g .. "\n====================")
end
end})
Window:AddLabel({text = "Autoplayer by lucit#6896"})
Window:AddLabel({text = "UI and configs by cup#7282"})

library:Init()

local Client = game:GetService'Players'.LocalPlayer
local MainGui = Client.PlayerGui.ScreenGui.MainGui
local Background = function()
  local BG
  for i,v in pairs(MainGui:GetDescendants())do
    if v.Name == "Background"then BG=v end
  end
  return BG
end
local Side = function()
    for _,v in next,Background():GetDescendants() do
        if v:FindFirstChild'Username' and v.Username.Text==Client.DisplayName then
            if v.AbsolutePosition.X < Client.PlayerGui.ScreenGui.AbsoluteSize.X/2 then
              return "Left"
            else
              return "Right"
            end
        end
    end
end
local ArrowGui= function()
  local AG
  for _,v in pairs(MainGui:GetDescendants())do
    if v.Name == "ArrowGui"then AG=v end
  end
  return AG
end
local FakeContainer=function(sd)
  if ArrowGui()~=nil and ArrowGui():FindFirstChild(sd) then
    for i,v in next,ArrowGui()[sd]:GetDescendants()do
      if v.Name=='FakeContainer'then return v end
    end
  else
    return nil
  end
end
local ScrollType = function(Side)
  repeat wait() until FakeContainer(Side)and #FakeContainer(Side):children()>0
    if FakeContainer(Side):children()[1].AbsolutePosition.Y < Client.PlayerGui.ScreenGui.AbsoluteSize.Y/2 then
        return "Upscroll"
    else
        return "Downscroll"
    end
end
local Initialize = function(Side)
    repeat wait()until ArrowGui()
    local Arrows = ArrowGui():WaitForChild(Side)
    repeat wait()until #Arrows:WaitForChild'Notes':children()>0
    repeat wait()until FakeContainer(Side)and Arrows.Notes and #Arrows.Notes:children()>0
    --wait until can be ran
    local Keys = Controls[#Arrows.Notes:children()]
    local Y = FakeContainer(Side).Down.AbsolutePosition.Y
    for i,v in pairs(Arrows.Notes:children())do
        if ScrollType(Side)=="Downscroll"then
            v.ChildAdded:Connect(function(_)
                repeat task.wait() until _.AbsolutePosition.Y>=Y
                if library.flags.AP and Keys[_.Parent.Name]~=nil then
                    fireSignal(userInputService.InputBegan, {Enum.KeyCode[Keys[_.Parent.Name]],UserInputType = Enum.UserInputType.Keyboard }, false)
                    if #Arrows.LongNotes[_.Parent.Name]:children()==0 then 
                        fireSignal(userInputService.InputEnded, {Enum.KeyCode[Keys[_.Parent.Name]],UserInputType = Enum.UserInputType.Keyboard }, false)
                    end
                end
            end)
        else
            v.ChildAdded:Connect(function(_)
                repeat task.wait() until _.AbsolutePosition.Y<=Y
                if library.flags.AP then
                    game:GetService'VirtualInputManager':SendKeyEvent(true,Enum.KeyCode[Keys[_.Parent.Name]],false,nil)
                    if #Arrows.LongNotes[_.Parent.Name]:children()==0 then 
                        fireSignal(userInputService.InputEnded, {Enum.KeyCode[Keys[_.Parent.Name]],UserInputType = Enum.UserInputType.Keyboard }, false)
                    end
                end
            end)
        end
    end
    for i,v in pairs(ArrowGui()[Side].LongNotes:children())do
        if ScrollType(Side)=="Downscroll"then
            v.ChildAdded:Connect(function(sustainNote)
                repeat task.wait() until sustainNote.Visible==false
                fireSignal(userInputService.InputEnded, { Enum.KeyCode[Keys[sustainNote.Parent.Name]],UserInputType = Enum.UserInputType.Keyboard }, false)
                sustainNote:Destroy() 
            end)
        else
            v.ChildAdded:Connect(function(sustainNote)
                repeat task.wait() until sustainNote.Visible==false
                fireSignal(userInputService.InputEnded, { Enum.KeyCode[Keys[sustainNote.Parent.Name]],UserInputType = Enum.UserInputType.Keyboard }, false)
                sustainNote:Destroy() 
            end)
        end
    end
end
MainGui.ChildAdded:Connect(function(_)
    if _.Name == "ArrowGui" then
        repeat wait() until ArrowGui()and Background()
        Initialize(Side())
    end
end)
if ArrowGui()and Background()then
  Initialize(Side())
end
