full_command_line := DllCall("GetCommandLine", "str")

if not (A_IsAdmin or RegExMatch(full_command_line, " /restart(?!\S)"))
{
  try
  {
    if A_IsCompiled
      Run *RunAs "%A_ScriptFullPath%" /restart
    else
      Run *RunAs "%A_AhkPath%" /restart "%A_ScriptFullPath%"
  }
  ExitApp
}

Process, Priority, , Realtime
#MenuMaskKey vkE8
#WinActivateForce
#InstallKeybdHook
#InstallMouseHook
#Persistent
#NoEnv
#SingleInstance Force
#MaxHotkeysPerInterval 2000
#KeyHistory 2000
SendMode Input
SetBatchLines -1
SetKeyDelay -1, 1
SetWorkingDir %A_ScriptDir%

Menu, Tray, Icon, %A_ScriptDir%\LOGO.ico
Menu, Tray, NoStandard ;不显示默认的AHK右键菜单
Menu, Tray, Add, 使用教程, 使用教程 ;添加新的右键菜单
Menu, Tray, Add, 画布设置, 画布设置 ;添加新的右键菜单
Menu, Tray, Add, 快捷设置, 快捷设置 ;添加新的右键菜单
Menu, Tray, Add, 开机自启, 开机自启 ;添加新的右键菜单
Menu, Tray, Add, 退出软件, 退出软件 ;添加新的右键菜单

色轮:=0 ;色轮是否打开
色轮位置X补偿:=12
色轮位置Y补偿:=0
取色位置Y:=477
色板位置:=1
时间:=0

autostartLnk:=A_StartupCommon . "\HighEfficiencyColorWheelForCSPv2.lnk" ;开机启动文件的路径
IfExist, % autostartLnk ;检查开机启动的文件是否存在
{
  autostart:=1
  Menu, Tray, Check, 开机自启 ;右键菜单打勾
}
else
{
  autostart:=0
  Menu, Tray, UnCheck, 开机自启 ;右键菜单不打勾
}

IfExist, %A_ScriptDir%\色轮设置.ini ;如果配置文件存在则读取
{
  IniRead, 色轮到笔刷距离, 色轮设置.ini, 设置, 色轮到笔刷距离
  IniRead, 鼠标在色轮位置X1, 色轮设置.ini, 设置, 鼠标在色轮位置X1
  IniRead, 鼠标在色轮位置Y1, 色轮设置.ini, 设置, 鼠标在色轮位置Y1
  IniRead, 鼠标在色轮位置X2, 色轮设置.ini, 设置, 鼠标在色轮位置X2
  IniRead, 鼠标在色轮位置Y2, 色轮设置.ini, 设置, 鼠标在色轮位置Y2
  IniRead, 色板1色相角度, 色轮设置.ini, 设置, 色板1色相角度
  IniRead, 色板2色相角度, 色轮设置.ini, 设置, 色板2色相角度
  IniRead, 色轮宽度W, 色轮设置.ini, 设置, 色轮宽度W
  IniRead, 色轮高度H, 色轮设置.ini, 设置, 色轮高度H
  IniRead, 色轮位置Y补偿, 色轮设置.ini, 设置, 色轮位置Y补偿
  IniRead, 色轮位置Y补偿, 色轮设置.ini, 设置, 色轮位置Y补偿
  IniRead, 画布左上角X, 色轮设置.ini, 设置, 画布左上角X
  IniRead, 画布左上角Y, 色轮设置.ini, 设置, 画布左上角Y
  IniRead, 画布右下角X, 色轮设置.ini, 设置, 画布右下角X
  IniRead, 画布右下角Y, 色轮设置.ini, 设置, 画布右下角Y
  IniRead, 色板1取色颜色, 色轮设置.ini, 设置, 色板1取色颜色
  IniRead, 色板2取色颜色, 色轮设置.ini, 设置, 色板2取色颜色
  IniRead, 色轮呼出快捷键, 色轮设置.ini, 设置, 色轮呼出快捷键
}
else
{
  色轮到笔刷距离:=200
  IniWrite, %色轮到笔刷距离%, 色轮设置.ini, 设置, 色轮到笔刷距离
  鼠标在色轮位置X1:=104
  IniWrite, %鼠标在色轮位置X1%, 色轮设置.ini, 设置, 鼠标在色轮位置X1
  鼠标在色轮位置Y1:=118
  IniWrite, %鼠标在色轮位置Y1%, 色轮设置.ini, 设置, 鼠标在色轮位置Y1
  鼠标在色轮位置X2:=104
  IniWrite, %鼠标在色轮位置X2%, 色轮设置.ini, 设置, 鼠标在色轮位置X2
  鼠标在色轮位置Y2:=118
  IniWrite, %鼠标在色轮位置Y2%, 色轮设置.ini, 设置, 鼠标在色轮位置Y2
  色板1色相角度:=0
  IniWrite, %色板1色相角度%, 色轮设置.ini, 设置, 色板1色相角度
  色板2色相角度:=0
  IniWrite, %色板2色相角度%, 色轮设置.ini, 设置, 色板2色相角度
  色轮宽度W:=Round(A_ScreenHeight*(465/1080))
  色轮高度H:=Round(A_ScreenHeight*(495/1080))
  IniWrite, %色轮宽度W%, 色轮设置.ini, 设置, 色轮宽度W
  IniWrite, %色轮高度H%, 色轮设置.ini, 设置, 色轮高度H
  色轮位置X补偿:=0
  色轮位置Y补偿:=0
  IniWrite, %色轮位置X补偿%, 色轮设置.ini, 设置, 色轮位置X补偿
  IniWrite, %色轮位置Y补偿%, 色轮设置.ini, 设置, 色轮位置Y补偿
  画布左上角X:=A_ScreenWidth/8
  画布左上角Y:=0
  画布右下角X:=A_ScreenWidth-A_ScreenWidth/8
  画布右下角Y:=A_ScreenHeight
  IniWrite, %画布左上角X%, 色轮设置.ini, 设置, 画布左上角X
  IniWrite, %画布左上角Y%, 色轮设置.ini, 设置, 画布左上角Y
  IniWrite, %画布右下角X%, 色轮设置.ini, 设置, 画布右下角X
  IniWrite, %画布右下角Y%, 色轮设置.ini, 设置, 画布右下角Y
  色板1取色颜色:=0xFFFFFF
  色板2取色颜色:=0xFFFFFF
  IniWrite, %色板1取色颜色%, 色轮设置.ini, 设置, 色板1取色颜色
  IniWrite, %色板2取色颜色%, 色轮设置.ini, 设置, 色板2取色颜色
  gosub 使用教程
  gosub 快捷设置
}
return

Numpad0::Reload

使用教程:
MsgBox, , 德芙色轮, 黑钨重工出品 免费开源 请勿商用 侵权必究`n`n目前仅支持1080p屏幕 100`%缩放`nCSP v2版本 请使用HSV色轮`n请在数位板设置中关闭Windows Ink功能`n`n按住Tab键触发德芙色轮`nW 切换色板`nQ和E 控制色相慢速左旋和右旋`nA和D 控制色相快速左旋和右旋`n松开Tab完成取色`n`n如果无法触发建议手动设置一次画布范围`n更多细节设置看ini文件修改`n支持有偿适配你的分辨率OWO`n`n更多免费教程尽在QQ群 1群763625227 2群643763519
return

画布设置:
KeyWait, LButton
loop
{
  ToolTip 按下鼠标左键设置画布左上角
  if GetKeyState("LButton", "P")
  {
    CoordMode, Mouse, Screen
    MouseGetPos, 画布左上角X, 画布左上角Y
    IniWrite, %画布左上角X%, 色轮设置.ini, 设置, 画布左上角X
    IniWrite, %画布左上角Y%, 色轮设置.ini, 设置, 画布左上角Y
    KeyWait, LButton
    break
  }
  Sleep 10
}
loop
{
  ToolTip 按下鼠标左键设置画布右下角
  if GetKeyState("LButton", "P")
  {
    CoordMode, Mouse, Screen
    MouseGetPos, 画布右下角X, 画布右下角Y
    IniWrite, %画布右下角X%, 色轮设置.ini, 设置, 画布右下角X
    IniWrite, %画布右下角Y%, 色轮设置.ini, 设置, 画布右下角Y
    KeyWait, LButton
    break
  }
  Sleep 10
}
ToolTip, 画布范围设置完成`n画布左上角 X%画布左上角X% Y%画布左上角Y%`n画布右下角 X%画布右下角X% %画布右下角Y%
Sleep 1000
ToolTip
return

快捷设置:
旧色轮呼出快捷键:=色轮呼出快捷键
Gui 快捷键:+DPIScale -MinimizeBox -MaximizeBox -Resize -SysMenu
Gui 快捷键:Font, s9, Segoe UI
Gui 快捷键:Add, Hotkey, x9 y29 w157 h25 v色轮呼出快捷键, %色轮呼出快捷键%
Gui 快捷键:Add, Text, x9 y7 w157 h20, 色轮呼出快捷键
Gui 快捷键:Add, Button, x8 y58 w80 h23 GButton确认, &确认
Gui 快捷键:Add, Button, x87 y58 w80 h23 GButton取消, &取消
Gui 快捷键:Show, w174 h95, 快捷键设置
return

Button确认:
Gui, 快捷键:Submit, NoHide
Gui, 快捷键:Destroy
IniWrite, %色轮呼出快捷键%, Settings.ini, 设置, 色轮呼出快捷键 ;写入设置到ini文件
return

Button取消:
GuiEscape:
GuiClose:
色轮呼出快捷键:=旧色轮呼出快捷键
Gui, 快捷键:Destroy
return

开机自启: ;模式切换
Critical, On
if (autostart=1) ;关闭开机自启动
{
  IfExist, % autostartLnk ;如果开机启动的文件存在
  {
    FileDelete, %autostartLnk% ;删除开机启动的文件
  }
  
  autostart:=0
  Menu, Tray, UnCheck, 开机自启 ;右键菜单不打勾
}
else ;开启开机自启动
{
  IfExist, % autostartLnk ;如果开机启动的文件存在
  {
    FileGetShortcut, %autostartLnkautostartLnk%, lnkTarget ;获取开机启动文件的信息
    if (lnkTarget!=A_ScriptFullPath) ;如果启动文件执行的路径和当前脚本的完整路径不一致
    {
      FileCreateShortcut, %A_ScriptFullPath%, %autostartLnk%, %A_WorkingDir% ;将启动文件执行的路径改成和当前脚本的完整路径一致
    }
  }
  else ;如果开机启动的文件不存在
  {
    FileCreateShortcut, %A_ScriptFullPath%, %autostartLnk%, %A_WorkingDir% ;创建和当前脚本的完整路径一致的启动文件
  }
  
  autostart:=1
  Menu, Tray, Check, 开机自启 ;右键菜单打勾
}
Critical, Off
return

退出软件:
ExitApp

ToBase(n,b){
    return (n < b ? "" : ToBase(n//b,b)) . ((d:=Mod(n,b)) < 10 ? d : Chr(d+55))
}

#IfWinActive ahk_exe CLIPStudioPaint.exe
$w::
if (色轮=0)
{
  Send {w Down}
  KeyWait, w
  Send {w Up}
  return
}
return

$q::
if (色轮=0)
{
  Send {q Down}
  KeyWait, q
  Send {q Up}
  return
}
return

$e::
if (色轮=0)
{
  Send {e Down}
  KeyWait, e
  Send {e Up}
  return
}
return

$a::
if (色轮=0)
{
  Send {a Down}
  KeyWait, a
  Send {a Up}
  return
}
return

$d::
if (色轮=0)
{
  Send {d Down}
  KeyWait, d
  Send {d Up}
  return
}
return

Tab:: ;Tab键
 ;检测鼠标是否在画布范围
CoordMode, Mouse, Screen
MouseGetPos, 鼠标在屏幕位置X, 鼠标在屏幕位置Y
if (鼠标在屏幕位置X<画布左上角X) or (鼠标在屏幕位置X>画布右下角X) or (鼠标在屏幕位置Y<画布左上角Y) or (鼠标在屏幕位置Y>画布右下角Y) ;不在画布范围内
{
  Send {Tab Down}
  KeyWait, Tab
  Send {Tab Up}
  return
}

 ;在画布范围
BlockInput, On
BlockInput, MouseMove
CoordMode, Pixel, Screen

 ;识别是否全屏
ImageSearch, , , 0, 0, A_ScreenWidth, A_ScreenHeight, *30 %A_ScriptDir%\全屏识别.png
if (ErrorLevel=0) ;不是全屏
{
  Send {Tab} ;进入全屏
  全屏:=1
}

 ;向左移动画布
Send {space Down}
Sleep 10
Send {LButton Down}
CoordMode, Mouse, Screen
if (色板位置=1)
{
  移动画布距离:=0+色轮到笔刷距离+鼠标在色轮位置X1
}
else if (色板位置=2)
{
  移动画布距离:=0+色轮到笔刷距离+鼠标在色轮位置X2
}
MouseMove, -移动画布距离, 0, 0, R
Sleep 30
Send {LButton Up}
Send {space Up}
MouseMove, 移动画布距离, 0, 0, R

 ;打开色轮并检测是否打开
Send %色轮呼出快捷键% ;打开色轮
开始计时:=A_TickCount
loop ;寻找色轮
{
  寻找耗时:=A_TickCount-开始计时
  ; ToolTip 寻找色轮中%寻找耗时%ms
  if !(WinExist("色轮")=0) ;""内填窗口名称
  {
    色轮:=1
    色轮窗口ID:=WinExist("色轮") ;""内填窗口名称
    ; ToolTip 已找到色轮
    break
  }
  else if (寻找耗时>500)
  {
    色轮:=0
    BlockInput, Off
    BlockInput, MouseMoveOff
    ToolTip 未找到色轮
    return
  }
}

 ;加载取色环
Gui 取色环:New, -DPIScale -MinimizeBox -MaximizeBox -SysMenu AlwaysOnTop, 取色环
Gui 取色环:Show, W117 H50 X0 Y0, 取色环 ;宽30（-6） 高40（+29）
WinSet, Transparent, 255, 取色环 ;透明度0-255
WinSet, Style, -0xC00000, 取色环 ;去除标题
WinSet, Region, 25-0 W74 H74 E, 取色环 ;圆形窗口
Gui, 取色环:Add, Picture, X25 Y0 BackgroundTrans, %A_ScriptDir%\取色环.png
WinSet, TransColor, cccccc, 取色环 ;透明化
WinMove 取色环, , 鼠标在屏幕位置X-62-移动画布距离+色轮位置X补偿, 鼠标在屏幕位置Y-37+色轮位置Y补偿
Gui, 取色环:Color, 0xffffff ;色环颜色

 ;查看正在使用哪个色板
CoordMode Pixel, Window
PixelSearch, 色板位置X, , 0, 467, 126, 469, 0x7D8EB3, 5, Fast RGB
if (色板位置X<45)
{
  取色位置X:=25
  色板位置:=1
}
else if (色板位置X>45) and (色板位置X<85)
{
  取色位置X:=65
  色板位置:=2
}
else
{
  if (色板位置=1)
  {
    取色位置X:=25
  }
  else (色板位置=2)
  {
    取色位置X:=65
  }
}

 ;检测当前颜色和之前是否一致
WinActivate 色轮
CoordMode Pixel, Window
PixelGetColor, 取色颜色, 取色位置X, 取色位置Y, RGB
if (色板位置=1) and (取色颜色!=色板1取色颜色)
{
  gosub 更新色板位置
  鼠标在色轮位置X1:=鼠标在色轮位置X
  鼠标在色轮位置Y1:=鼠标在色轮位置Y
  色板1色相角度:=色相角度
  
  IniWrite, %鼠标在色轮位置X1%, 色轮设置.ini, 设置, 鼠标在色轮位置X1
  IniWrite, %鼠标在色轮位置Y1%, 色轮设置.ini, 设置, 鼠标在色轮位置Y1
  IniWrite, %色板1色相角度%, 色轮设置.ini, 设置, 色板1色相角度
  IniWrite, %取色颜色%, 色轮设置.ini, 设置, 色板1取色颜色
}
else if (色板位置=2) and (取色颜色!=色板2取色颜色)
{
  gosub 更新色板位置
  鼠标在色轮位置X2:=鼠标在色轮位置X
  鼠标在色轮位置Y2:=鼠标在色轮位置Y
  色板2色相角度:=色相角度
  
  IniWrite, %鼠标在色轮位置X2%, 色轮设置.ini, 设置, 鼠标在色轮位置X2
  IniWrite, %鼠标在色轮位置Y2%, 色轮设置.ini, 设置, 鼠标在色轮位置Y2
  IniWrite, %色板2色相角度%, 色轮设置.ini, 设置, 色板2色相角度
  IniWrite, %取色颜色%, 色轮设置.ini, 设置, 色板2取色颜色
}

 ;移动色轮取色位置到鼠标下方
if (色板位置=1)
{
  色轮位置X:=Round(鼠标在屏幕位置X-鼠标在色轮位置X1)
  色轮位置Y:=Round(鼠标在屏幕位置Y-鼠标在色轮位置Y1)
}
else if (色板位置=2)
{
  色轮位置X:=Round(鼠标在屏幕位置X-鼠标在色轮位置X2)
  色轮位置Y:=Round(鼠标在屏幕位置Y-鼠标在色轮位置Y2)
}
WinMove, 色轮, , 色轮位置X, 色轮位置Y, 色轮宽度W, 色轮高度H ;移动色轮窗口位置

 ;调整取色环颜色并监控热键
Send {LButton Down} ;开始取色
BlockInput, Off
BlockInput, MouseMoveOff
loop
{
  if !GetKeyState("Tab", "P")
  {
    break
  }
  else if GetKeyState("w", "P")
  {
    gosub 切换色板
  }
  else if GetKeyState("q", "P")
  {
    gosub 色相慢左旋
  }
  else if GetKeyState("e", "P")
  {
    gosub 色相慢右旋
  }
  else if GetKeyState("a", "P")
  {
    gosub 色相快左旋
    Sleep 100
  }
  else if GetKeyState("d", "P")
  {
    gosub 色相快右旋
    Sleep 100
  }
  PixelGetColor, 取色颜色, 取色位置X, 取色位置Y, RGB
  Gui, 取色环:Color, %取色颜色% ;色环颜色
  Sleep 10
}

 ;抬起热键关闭取色环
Gui, 取色环:Destroy
CoordMode, Mouse, Window
MouseGetPos, 鼠标在色轮位置X, 鼠标在色轮位置Y

 ;记录取色位置到配置文件
if (色板位置=1)
{
  鼠标在色轮位置X1:=鼠标在色轮位置X
  鼠标在色轮位置Y1:=鼠标在色轮位置Y
  if (鼠标在色轮位置X1<104)
  {
    鼠标在色轮位置X1:=104
  }
  else if (鼠标在色轮位置X1>360)
  {
    鼠标在色轮位置X1:=360
  }
  if (鼠标在色轮位置Y1<118)
  {
    鼠标在色轮位置Y1:=118
  }
  else if (鼠标在色轮位置Y1>374)
  {
    鼠标在色轮位置Y1:=374
  }
  IniWrite, %鼠标在色轮位置X1%, 色轮设置.ini, 设置, 鼠标在色轮位置X1
  IniWrite, %鼠标在色轮位置Y1%, 色轮设置.ini, 设置, 鼠标在色轮位置Y1
  色板1取色颜色:=取色颜色
  IniWrite, %取色颜色%, 色轮设置.ini, 设置, 色板1取色颜色
}
else if (色板位置=2)
{
  鼠标在色轮位置X2:=鼠标在色轮位置X
  鼠标在色轮位置Y2:=鼠标在色轮位置Y
  if (鼠标在色轮位置X2<104)
  {
    鼠标在色轮位置X2:=104
  }
  else if (鼠标在色轮位置X2>360)
  {
    鼠标在色轮位置X2:=360
  }
  if (鼠标在色轮位置Y2<118)
  {
    鼠标在色轮位置Y2:=118
  }
  else if (鼠标在色轮位置Y2>374)
  {
    鼠标在色轮位置Y2:=374
  }
  IniWrite, %鼠标在色轮位置X2%, 色轮设置.ini, 设置, 鼠标在色轮位置X2
  IniWrite, %鼠标在色轮位置Y2%, 色轮设置.ini, 设置, 鼠标在色轮位置Y2
  色板2取色颜色:=取色颜色
  IniWrite, %取色颜色%, 色轮设置.ini, 设置, 色板2取色颜色
}

 ;关闭色轮并移动画布至原始位置
CoordMode, Mouse, Screen
MouseGetPos, 鼠标在屏幕位置X, 鼠标在屏幕位置Y
BlockInput, On
BlockInput, MouseMove
Send {LButton Up} ;结束取色
Send %色轮呼出快捷键% ;关闭色轮
Sleep 50
Send {space Down}
Send {LButton Down}
CoordMode, Mouse, Screen
MouseMove, 移动画布距离, 0, 0, R
Sleep 50
Send {LButton Up}
Send {space Up}
CoordMode, Pixel, Screen
if (全屏=1) ;如果之前进入了全屏则退出全屏
{
  Send {Tab}
  全屏:=0
}
MouseMove, 鼠标在屏幕位置X, 鼠标在屏幕位置Y
色轮:=0
BlockInput, Off
BlockInput, MouseMoveOff
return

更新色板位置:
rgbArray1:="0x"
rgbArray1.=SubStr(取色颜色, 3, 2)
rgbArray1:=ToBase(rgbArray1,10)

rgbArray2:="0x"
rgbArray2.=SubStr(取色颜色, 5, 2)
rgbArray2:=ToBase(rgbArray2,10)

rgbArray3:="0x"
rgbArray3.=SubStr(取色颜色, 7, 2)
rgbArray3:=ToBase(rgbArray3,10)

r :=rgbArray1 / 255
g :=rgbArray2 / 255
b :=rgbArray3 / 255

max := Max(r, g, b)
min := Min(r, g, b)
delta := max - min

if (delta = 0) {
    h := 0
} else if (max = r) {
    h := 60 * Mod(((g - b) / delta), 6)
} else if (max = g) {
    h := 60 * (((b - r) / delta) + 2)
} else if (max = b) {
    h := 60 * (((r - g) / delta) + 4)
}
  
if (h < 0)
{
    h := 300 + (60 - Abs(h))
}

if (max = 0) {
    s := 0
} else {
    s := delta / max
}

v := max

色相角度:=Floor((6.283*((h-60)/360))/0.00515)*0.00515
if (色相角度<0)
{
  色相角度:=6.283+色相角度
}
鼠标在色轮位置X:=104+Round(s*256)
鼠标在色轮位置Y:=118+256-Round(v*256)
return

切换色板:
BlockInput, On
BlockInput, MouseMove
Send {LButton Up} ;结束取色
CoordMode, Mouse, Window
MouseGetPos, 鼠标在色轮位置X, 鼠标在色轮位置Y

if (色板位置=1)
{
  鼠标在色轮位置X1:=鼠标在色轮位置X
  鼠标在色轮位置Y1:=鼠标在色轮位置Y
  if (鼠标在色轮位置X1<104)
  {
    鼠标在色轮位置X1:=104
  }
  else if (鼠标在色轮位置X1>360)
  {
    鼠标在色轮位置X1:=360
  }
  if (鼠标在色轮位置Y1<118)
  {
    鼠标在色轮位置Y1:=118
  }
  else if (鼠标在色轮位置Y1>374)
  {
    鼠标在色轮位置Y1:=374
  }
  IniWrite, %鼠标在色轮位置X1%, 色轮设置.ini, 设置, 鼠标在色轮位置X1
  IniWrite, %鼠标在色轮位置Y1%, 色轮设置.ini, 设置, 鼠标在色轮位置Y1
}
else if (色板位置=2)
{
  鼠标在色轮位置X2:=鼠标在色轮位置X
  鼠标在色轮位置Y2:=鼠标在色轮位置Y
  if (鼠标在色轮位置X2<104)
  {
    鼠标在色轮位置X2:=104
  }
  else if (鼠标在色轮位置X2>360)
  {
    鼠标在色轮位置X2:=360
  }
  if (鼠标在色轮位置Y2<118)
  {
    鼠标在色轮位置Y2:=118
  }
  else if (鼠标在色轮位置Y2>374)
  {
    鼠标在色轮位置Y2:=374
  }
  IniWrite, %鼠标在色轮位置X2%, 色轮设置.ini, 设置, 鼠标在色轮位置X2
  IniWrite, %鼠标在色轮位置Y2%, 色轮设置.ini, 设置, 鼠标在色轮位置Y2
}

CoordMode, Mouse, Screen
MouseGetPos, 鼠标在屏幕位置X, 鼠标在屏幕位置Y
WinGetPos, 色轮在屏幕位置X, 色轮在屏幕位置Y, , , 色轮
; ToolTip %色轮在屏幕位置X% %色轮在屏幕位置Y%
if (色板位置=1)
{
  色板位置:=2
  取色位置X:=65
  MouseMove, 色轮在屏幕位置X+65, 色轮在屏幕位置Y+取色位置Y, 0
  Sleep 10
  Send {LButton Down}
  Sleep 10
  Send {LButton Up}
  Sleep 10
  色轮位置X:=Round(鼠标在屏幕位置X-鼠标在色轮位置X2)
  色轮位置Y:=Round(鼠标在屏幕位置Y-鼠标在色轮位置Y2)
  WinMove, 色轮, , 色轮位置X, 色轮位置Y, 色轮宽度W, 色轮高度H ;移动色轮窗口位置
  MouseMove, 鼠标在屏幕位置X, 鼠标在屏幕位置Y, 0
  Sleep 10
  Send {LButton Down}
}
else
{
  色板位置:=1
  取色位置X:=25
  MouseMove, 色轮在屏幕位置X+25, 色轮在屏幕位置Y+取色位置Y, 0
  Sleep 10
  Send {LButton Down}
  Sleep 10
  Send {LButton Up}
  Sleep 10
  色轮位置X:=Round(鼠标在屏幕位置X-鼠标在色轮位置X1)
  色轮位置Y:=Round(鼠标在屏幕位置Y-鼠标在色轮位置Y1)
  WinMove, 色轮, , 色轮位置X, 色轮位置Y, 色轮宽度W, 色轮高度H ;移动色轮窗口位置
  MouseMove, 鼠标在屏幕位置X, 鼠标在屏幕位置Y, 0
  Sleep 10
  Send {LButton Down}
}
BlockInput, Off
BlockInput, MouseMoveOff
loop
{
  if !GetKeyState("z", "P")
  {
    break
  }
}
return

色相慢左旋:
BlockInput MouseMove
Send {LButton Up}
CoordMode, Mouse, Screen
MouseGetPos, 鼠标在屏幕位置记忆X, 鼠标在屏幕位置记忆Y
WinGetPos, 色轮在屏幕位置X, 色轮在屏幕位置Y, , , 色轮
圆心坐标X:=Round(色轮在屏幕位置X+色轮宽度W/2)
圆心坐标Y:=Round(色轮在屏幕位置Y+色轮宽度W/2)+13
圆的半径:=色轮宽度W/2-10
CoordMode, Mouse, Screen
if (色板位置=1)
{
  色板1色相角度:=色板1色相角度-0.00515
  色相角度:=色板1色相角度
  if (色板1色相角度<0)
  {
    色板1色相角度:=6.283
    色相角度:=6.283
  }
  IniWrite, %色板1色相角度%, 色轮设置.ini, 设置, 色板1色相角度
}
else if (色板位置=2)
{
  色板2色相角度:=色板2色相角度-0.00515
  色相角度:=色板2色相角度
  if (色板2色相角度<0)
  {
    色板2色相角度:=6.283
    色相角度:=6.283
  }
  IniWrite, %色板2色相角度%, 色轮设置.ini, 设置, 色板2色相角度
}
gosub 色相偏移
Send {LButton Up}
CoordMode, Mouse, Screen
MouseMove, 鼠标在屏幕位置记忆X, 鼠标在屏幕位置记忆Y, 0
Send {LButton Down}
BlockInput MouseMoveOff
return

色相慢右旋:
BlockInput MouseMove
Send {LButton Up}
CoordMode, Mouse, Screen
MouseGetPos, 鼠标在屏幕位置记忆X, 鼠标在屏幕位置记忆Y
WinGetPos, 色轮在屏幕位置X, 色轮在屏幕位置Y, , , 色轮
圆心坐标X:=Round(色轮在屏幕位置X+色轮宽度W/2)
圆心坐标Y:=Round(色轮在屏幕位置Y+色轮宽度W/2)+12
圆的半径:=色轮宽度W/2-10
CoordMode, Mouse, Screen
if (色板位置=1)
{
  色板1色相角度:=色板1色相角度+0.00515
  色相角度:=色板1色相角度
  if (色板1色相角度>6.283)
  {
    色板1色相角度:=0
    色相角度:=0
  }
  IniWrite, %色板1色相角度%, 色轮设置.ini, 设置, 色板1色相角度
}
else if (色板位置=2)
{
  色板2色相角度:=色板2色相角度+0.00515
  色相角度:=色板2色相角度
  if (色板2色相角度>6.283)
  {
    色板2色相角度:=0
    色相角度:=0
  }
  IniWrite, %色板2色相角度%, 色轮设置.ini, 设置, 色板2色相角度
}
gosub 色相偏移
Send {LButton Up}
CoordMode, Mouse, Screen
MouseMove, 鼠标在屏幕位置记忆X, 鼠标在屏幕位置记忆Y, 0
Send {LButton Down}
BlockInput MouseMoveOff
return

色相快左旋:
BlockInput MouseMove
Send {LButton Up}
CoordMode, Mouse, Screen
MouseGetPos, 鼠标在屏幕位置记忆X, 鼠标在屏幕位置记忆Y
WinGetPos, 色轮在屏幕位置X, 色轮在屏幕位置Y, , , 色轮
圆心坐标X:=Round(色轮在屏幕位置X+色轮宽度W/2)
圆心坐标Y:=Round(色轮在屏幕位置Y+色轮宽度W/2)+12
圆的半径:=色轮宽度W/2-10
CoordMode, Mouse, Screen
if (色板位置=1)
{
  色板1色相角度:=色板1色相角度-0.103
  色相角度:=色板1色相角度
  if (色板1色相角度<0)
  {
    色板1色相角度:=6.283
    色相角度:=6.283
  }
  IniWrite, %色板1色相角度%, 色轮设置.ini, 设置, 色板1色相角度
}
else if (色板位置=2)
{
  色板2色相角度:=色板2色相角度-0.103
  色相角度:=色板2色相角度
  if (色板2色相角度<0)
  {
    色板2色相角度:=6.283
    色相角度:=6.283
  }
  IniWrite, %色板2色相角度%, 色轮设置.ini, 设置, 色板2色相角度
}
gosub 色相偏移
Send {LButton Up}
CoordMode, Mouse, Screen
MouseMove, 鼠标在屏幕位置记忆X, 鼠标在屏幕位置记忆Y, 0
Send {LButton Down}
BlockInput MouseMoveOff
return

色相快右旋:
BlockInput MouseMove
Send {LButton Up}
CoordMode, Mouse, Screen
MouseGetPos, 鼠标在屏幕位置记忆X, 鼠标在屏幕位置记忆Y
WinGetPos, 色轮在屏幕位置X, 色轮在屏幕位置Y, , , 色轮
圆心坐标X:=Round(色轮在屏幕位置X+色轮宽度W/2)
圆心坐标Y:=Round(色轮在屏幕位置Y+色轮宽度W/2)+12
圆的半径:=色轮宽度W/2-10
CoordMode, Mouse, Screen
if (色板位置=1)
{
  色板1色相角度:=色板1色相角度+0.103
  色相角度:=色板1色相角度
  if (色板1色相角度>6.283)
  {
    色板1色相角度:=0
    色相角度:=0
  }
  IniWrite, %色板1色相角度%, 色轮设置.ini, 设置, 色板1色相角度
}
else if (色板位置=2)
{
  色板2色相角度:=色板2色相角度+0.103
  色相角度:=色板2色相角度
  if (色板2色相角度>6.283)
  {
    色板2色相角度:=0
    色相角度:=0
  }
  IniWrite, %色板2色相角度%, 色轮设置.ini, 设置, 色板2色相角度
}
gosub 色相偏移
Send {LButton Up}
CoordMode, Mouse, Screen
MouseMove, 鼠标在屏幕位置记忆X, 鼠标在屏幕位置记忆Y, 0
Send {LButton Down}
BlockInput MouseMoveOff
return

色相偏移:
if (色相角度<1.57075)
{
  角度:=色相角度
}
else if (色相角度>=1.57075) and (色相角度<3.1415)
{
  角度:=1.57075-(色相角度-1.57075)
}
else if (色相角度>=3.1415) and (色相角度<4.71225)
{
  角度:=色相角度-3.1415
}
else if (色相角度>=4.71225) and (色相角度<6.283)
{
  角度:=1.57075-(色相角度-4.71225)
}
计算坐标X:=圆的半径*Sin(角度)
计算坐标Y:=Sqrt(圆的半径*圆的半径-计算坐标X*计算坐标X)
if (色相角度<1.57075)
{
  绘制坐标X:=Round(圆心坐标X+计算坐标X)
  绘制坐标Y:=Round(圆心坐标Y-计算坐标Y)
  MouseMove, 绘制坐标X, 绘制坐标Y, 0
}
else if (色相角度>=1.57075) and (色相角度<3.1415)
{
  绘制坐标X:=Round(圆心坐标X+计算坐标X)
  绘制坐标Y:=Round(圆心坐标Y+计算坐标Y)
  MouseMove, 绘制坐标X, 绘制坐标Y, 0
}
else if (色相角度>=3.1415) and (色相角度<4.71225)
{
  绘制坐标X:=Round(圆心坐标X-计算坐标X)
  绘制坐标Y:=Round(圆心坐标Y+计算坐标Y)
  MouseMove, 绘制坐标X, 绘制坐标Y, 0
}
else if (色相角度>=4.71225) and (色相角度<6.283)
{
  绘制坐标X:=Round(圆心坐标X-计算坐标X)
  绘制坐标Y:=Round(圆心坐标Y-计算坐标Y)
  MouseMove, 绘制坐标X, 绘制坐标Y, 0
}
Send {LButton Down}
return