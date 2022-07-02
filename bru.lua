local InputService = game:GetService("UserInputService")
local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/wally-rblx/uwuware-ui/main/main.lua"))() --OMG IP LOGGER!!!!
local Window = library:CreateWindow("Monday Morning Misery")
local Folder = Window:AddFolder("Autoplayer") do
local toggle = Folder:AddToggle({text = "Toggle autoplayer", flag = "AP" })
Folder:AddBind({ text = 'Autoplayer toggle', flag = 'AutoPlayerToggle', key = Enum.KeyCode.End, callback = function()
                toggle:SetState(not toggle.state)
            end })

Folder:AddButton({text = "Destroy Gui", callback = function()pcall(function()game:GetService("CoreGui").ScreenGui:Destroy()end)end})
Window:AddBind({ text = 'Menu toggle', key = Enum.KeyCode.Delete, callback = function() library:Close() end })

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
                    RunSignal(InputService.InputBegan, { KeyCode = Enum.KeyCode[Keys[_.Parent.Name]], UserInputType = Enum.UserInputType.Keyboard }, false,nil)
                    if #Arrows.LongNotes[_.Parent.Name]:children()==0 then 
                        RunSignal(InputService.InputEnded, { KeyCode = Enum.KeyCode[Keys[_.Parent.Name]], UserInputType = Enum.UserInputType.Keyboard }, false,nil)
                    end
                end
            end)
        else
            v.ChildAdded:Connect(function(_)
                repeat task.wait() until _.AbsolutePosition.Y<=Y
                if library.flags.AP then
                    RunSignal(InputService.InputBegan, { KeyCode = Enum.KeyCode[Keys[sustainNote.Parent.Name]], UserInputType = Enum.UserInputType.Keyboard }, false,nil)
                    if #Arrows.LongNotes[_.Parent.Name]:children()==0 then 
                        RunSignal(InputService.InputEnded, { KeyCode = Enum.KeyCode[Keys[sustainNote.Parent.Name]], UserInputType = Enum.UserInputType.Keyboard }, false,nil)
                    end
                end
            end)
        end
    end
    for i,v in pairs(ArrowGui()[Side].LongNotes:children())do
        if ScrollType(Side)=="Downscroll"then
            v.ChildAdded:Connect(function(sustainNote)
                repeat task.wait() until sustainNote.Visible==false
                RunSignal(InputService.InputEnded, { KeyCode = Enum.KeyCode[Keys[sustainNote.Parent.Name]], UserInputType = Enum.UserInputType.Keyboard }, false,nil)
                sustainNote:Destroy() 
            end)
        else
            v.ChildAdded:Connect(function(sustainNote)
                repeat task.wait() until sustainNote.Visible==false
                RunSignal(InputService.InputEnded, { KeyCode = Enum.KeyCode[Keys[sustainNote.Parent.Name]], UserInputType = Enum.UserInputType.Keyboard }, false,nil)
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
end

function RunSignal(signal, ...)
    syn.set_thread_identity(2)
    for _, signal in next, getconnections(signal) do
        if type(signal.Function) == 'function' and is_lclosure(signal.Function) then
            local scr = rawget(getfenv(signal.Function), 'script')
            for _, module in next, getloadedmodules() do
                if module.Name == 'ConsoleHandler' then
                    pcall(signal.Function, ...)
                    break
                end
            end 
        end
    end
    syn.set_thread_identity(7)
end
