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
Menu, Tray, Add, 视频教程, 视频教程 ;添加新的右键菜单
Menu, Tray, Add, 软件更新, 软件更新 ;添加新的右键菜单
Menu, Tray, Add
Menu, Tray, Add, 简体中文, 语言设置 ;添加新的右键菜单
Menu, Tray, Add, 穿透设置, 穿透设置 ;添加新的右键菜单
Menu, Tray, Add, 画布设置, 画布设置 ;添加新的右键菜单
Menu, Tray, Add, 快捷设置, 快捷设置 ;添加新的右键菜单
Menu, Tray, Add, 色环矫正, 色环矫正 ;添加新的右键菜单
Menu, Tray, Add, 重置设置, 重置设置 ;添加新的右键菜单
Menu, Tray, Add
Menu, Tray, Add, 中键呼出, 中键呼出 ;添加新的右键菜单
Menu, Tray, Add, 记忆模式, 记忆模式 ;添加新的右键菜单
Menu, Tray, Add, 开机自启, 开机自启 ;添加新的右键菜单
Menu, Tray, Add
Menu, Tray, Add, 重启软件, 重启软件 ;添加新的右键菜单
Menu, Tray, Add, 退出软件, 退出软件 ;添加新的右键菜单

色轮:=0 ;色轮是否打开
调色盘:=0 ;调色盘是否打开
取色位置Y:=477
色板位置:=1
色环矫正:=0
色相慢左旋:=0
色相慢右旋:=0
菜单隐藏:=0
延迟执行:=0
面板自动展开:=0
软件Class名:=0
计时器:=0
导航穿透:=0
摸鱼穿透:=0

if (A_ScreenHeight<1440)
{
  屏幕高度:=1080
}
else if (A_ScreenHeight>=2160)
{
  屏幕高度:=2160
}
else
{
  屏幕高度:=1440
}

autostartLnk:=A_StartupCommon . "\HighEfficiencyColorWheelForCSPv2.lnk" ;开机启动文件的路径
IfExist, % autostartLnk ;检查开机启动的文件是否存在
{
  FileGetShortcut, %autostartLnk%, lnkTarget ;获取开机启动文件的信息
  if (lnkTarget!=A_ScriptFullPath) ;如果启动文件执行的路径和当前脚本的完整路径不一致
  {
    FileCreateShortcut, %A_ScriptFullPath%, %autostartLnk%, %A_WorkingDir% ;将启动文件执行的路径改成和当前脚本的完整路径一致
  }
  
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
  色轮目标边长:=Round(256/1080*屏幕高度)
  调色盘按键Y:=Round(480/495*色轮高度H)
  色轮方块XL边界:=Round(104/465*色轮宽度W)
  色轮方块XR边界:=Round(360/465*色轮宽度W)
  色轮方块YU边界:=Round(118/495*色轮高度H)
  色轮方块YD边界:=Round(374/495*色轮高度H)
  圆心坐标X:=Round(色轮宽度W/2)
  圆心坐标Y:=Round(色轮宽度W/2+12/1080*屏幕高度)
  圆的半径:=Round(色轮宽度W/2-10/1080*屏幕高度)
  IniRead, 全屏色轮位置X补偿, 色轮设置.ini, 设置, 全屏色轮位置X补偿
  IniRead, 全屏色轮位置Y补偿, 色轮设置.ini, 设置, 全屏色轮位置Y补偿
  IniRead, 色轮位置X补偿, 色轮设置.ini, 设置, 色轮位置X补偿
  IniRead, 色轮位置Y补偿, 色轮设置.ini, 设置, 色轮位置Y补偿
  IniRead, 画布左上角X, 色轮设置.ini, 设置, 画布左上角X
  IniRead, 画布左上角Y, 色轮设置.ini, 设置, 画布左上角Y
  IniRead, 画布右下角X, 色轮设置.ini, 设置, 画布右下角X
  IniRead, 画布右下角Y, 色轮设置.ini, 设置, 画布右下角Y
  IniRead, 色板1取色颜色, 色轮设置.ini, 设置, 色板1取色颜色
  IniRead, 色板2取色颜色, 色轮设置.ini, 设置, 色板2取色颜色
  IniRead, 调色盘笔刷样式, 色轮设置.ini, 设置, 调色盘笔刷样式
  IniRead, 调色盘笔刷大小, 色轮设置.ini, 设置, 调色盘笔刷大小
  IniRead, 面板展开, 色轮设置.ini, 设置, 面板展开
  IniRead, 软件Class名, 色轮设置.ini, 设置, 软件Class名
  ; IniRead, PSwinclass, 色轮设置.ini, 设置, PS取色窗口
  if (软件Class名!=0)
  {
    SetTimer, 自动隐藏菜单, 200
  }
  IniRead, 色轮呼出快捷键, 色轮设置.ini, 设置, 色轮呼出快捷键
  快捷键1:=色轮呼出快捷键
  Ctrl键1:=InStr(快捷键1, "^")
  Shift键1:=InStr(快捷键1, "+")
  Alt键1:=InStr(快捷键1, "!")
  快捷键1:=StrReplace(快捷键1,"^")
  快捷键1:=StrReplace(快捷键1,"+")
  快捷键1:=StrReplace(快捷键1,"!")
  
  IniRead, 调色盘呼出快捷键, 色轮设置.ini, 设置, 调色盘呼出快捷键
  快捷键2:=调色盘呼出快捷键
  Ctrl键2:=InStr(快捷键2, "^")
  Shift键2:=InStr(快捷键2, "+")
  Alt键2:=InStr(快捷键2, "!")
  快捷键2:=StrReplace(快捷键2,"^")
  快捷键2:=StrReplace(快捷键2,"+")
  快捷键2:=StrReplace(快捷键2,"!")
  
  IniRead, 导航器呼出快捷键, 色轮设置.ini, 设置, 导航器呼出快捷键 ;写入设置到ini文件
  ; Hotkey, %导航器呼出快捷键%, 导航器呼出快捷键, On
  快捷键3:=导航器呼出快捷键
  Ctrl键3:=InStr(快捷键3, "^")
  Shift键3:=InStr(快捷键3, "+")
  Alt键3:=InStr(快捷键3, "!")
  快捷键3:=StrReplace(快捷键3,"^")
  快捷键3:=StrReplace(快捷键3,"+")
  快捷键3:=StrReplace(快捷键3,"!")
  
  IniRead, 导航器透明度, 色轮设置.ini, 设置, 导航器透明度 ;写入设置到ini文件
  IniRead, 摸鱼窗口, 色轮设置.ini, 设置, 摸鱼窗口 ;写入设置到ini文件
  IniRead, 摸鱼窗口透明度, 色轮设置.ini, 设置, 摸鱼窗口透明度 ;写入设置到ini文件
  
  IniRead, 简体中文, 色轮设置.ini, 设置, 简体中文
  if (简体中文=1)
  {
    IniRead, 排除标题, 色轮设置.ini, 设置, 简体中文排除标题
    Menu, Tray, Check, 简体中文 ;右键菜单打勾
  }
  else
  {
    IniRead, 排除标题, 色轮设置.ini, 设置, 繁体中文排除标题
  }
  排除名单:=StrSplit(排除标题, "|")
  名单数量:=排除名单.Count()
  ; MsgBox %名单数量%
  /*
  字符数量:=StrLen(排除标题)
  名单数量:=1
  loop %字符数量% length
  {
    if (A_Index>字符数量)
    {
      break
    }
    else
    {
      if (SubStr(排除标题, A_Index, 1)="|")
      {
        名单数量:=名单数量+1
      }
    }
  }
  */
  
  IniRead, 记忆模式, 色轮设置.ini, 设置, 记忆模式
  if (记忆模式=1)
  {
    Menu, Tray, Check, 记忆模式 ;右键菜单打勾
  }
  IniRead, 初始设置, 色轮设置.ini, 设置, 初始设置
  IniRead, 中键呼出, 色轮设置.ini, 设置, 中键呼出
  Hotkey, $MButton, 中键
  Hotkey, $WheelUp, 滚轮上
  Hotkey, $WheelDown, 滚轮下
  if (中键呼出=1)
  {
    Menu, Tray, Check, 中键呼出 ;右键菜单打勾
    IniWrite, %中键呼出%, 色轮设置.ini, 设置, 中键呼出
    Hotkey, MButton, On
    Hotkey, $WheelUp, On
    Hotkey, $WheelDown, On
  }
  else
  {
    Menu, Tray, UnCheck, 中键呼出 ;右键菜单不打勾
    IniWrite, %中键呼出%, 色轮设置.ini, 设置, 中键呼出
    Hotkey, MButton, Off
    Hotkey, $WheelUp, Off
    Hotkey, $WheelDown, Off
  }
  
  Hotkey, Up, 上
  Hotkey, Up, Off
  Hotkey, Down, 下
  Hotkey, Down, Off
  Hotkey, Left, 左
  Hotkey, Left, Off
  Hotkey, Right, 右
  Hotkey, Right, Off
}
else
{
  色轮到笔刷距离:=Round(200/1080*屏幕高度)
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
  色轮宽度W:=Round(屏幕高度*(465/1080))
  色轮高度H:=Round(屏幕高度*(495/1080))
  IniWrite, %色轮宽度W%, 色轮设置.ini, 设置, 色轮宽度W
  IniWrite, %色轮高度H%, 色轮设置.ini, 设置, 色轮高度H
  色轮目标边长:=Round(256/1080*屏幕高度)
  调色盘按键Y:=Round(480/495*色轮高度H)
  色轮方块XL边界:=Round(104/465*色轮宽度W)
  色轮方块XR边界:=Round(360/465*色轮宽度W)
  色轮方块YU边界:=Round(118/495*色轮高度H)
  色轮方块YD边界:=Round(374/495*色轮高度H)
  圆心坐标X:=Round(色轮宽度W/2)
  圆心坐标Y:=Round(色轮宽度W/2+12/1080*屏幕高度)
  圆的半径:=Round(色轮宽度W/2-10/1080*屏幕高度)
  全屏色轮位置X补偿:=0
  全屏色轮位置Y补偿:=0
  IniWrite, %全屏色轮位置X补偿%, 色轮设置.ini, 设置, 全屏色轮位置X补偿
  IniWrite, %全屏色轮位置Y补偿%, 色轮设置.ini, 设置, 全屏色轮位置Y补偿
  色轮位置X补偿:=0
  色轮位置Y补偿:=0
  IniWrite, %色轮位置X补偿%, 色轮设置.ini, 设置, 色轮位置X补偿
  IniWrite, %色轮位置Y补偿%, 色轮设置.ini, 设置, 色轮位置Y补偿
  画布左上角X:=Round(A_ScreenWidth/8)
  画布左上角Y:=0
  画布右下角X:=A_ScreenWidth-Round(A_ScreenWidth/8)
  画布右下角Y:=屏幕高度
  IniWrite, %画布左上角X%, 色轮设置.ini, 设置, 画布左上角X
  IniWrite, %画布左上角Y%, 色轮设置.ini, 设置, 画布左上角Y
  IniWrite, %画布右下角X%, 色轮设置.ini, 设置, 画布右下角X
  IniWrite, %画布右下角Y%, 色轮设置.ini, 设置, 画布右下角Y
  色板1取色颜色:=0xFFFFFF
  色板2取色颜色:=0xFFFFFF
  IniWrite, %色板1取色颜色%, 色轮设置.ini, 设置, 色板1取色颜色
  IniWrite, %色板2取色颜色%, 色轮设置.ini, 设置, 色板2取色颜色
  记忆模式:=0
  IniWrite, %记忆模式%, 色轮设置.ini, 设置, 记忆模式
  调色盘笔刷样式:=0
  IniWrite, %调色盘笔刷样式%, 色轮设置.ini, 设置, 调色盘笔刷样式
  调色盘笔刷大小:=0
  IniWrite, %调色盘笔刷大小%, 色轮设置.ini, 设置, 调色盘笔刷大小
  软件Class名:=0
  IniWrite, %软件Class名%, 色轮设置.ini, 设置, 软件Class名
  中键呼出:=0
  IniWrite, %中键呼出%, 色轮设置.ini, 设置, 中键呼出
  简体中文排除标题:="画布大小|插入区域|删除区域|自动阴影|高斯模糊|顏色设置"
  IniWrite, %简体中文排除标题%, 色轮设置.ini, 设置, 简体中文排除标题
  繁体中文排除标题:="變更畫布尺寸|插入畫布的區域|刪除畫布的區域|自動陰影|高斯模糊|顏色設定"
  IniWrite, %繁体中文排除标题%, 色轮设置.ini, 设置, 繁体中文排除标题
  导航器透明度:=200
  IniWrite, %导航器透明度%, 色轮设置.ini, 设置, 导航器透明度 ;写入设置到ini文件
  摸鱼窗口:=0
  IniWrite, %摸鱼窗口%, 色轮设置.ini, 设置, 摸鱼窗口 ;写入设置到ini文件
  摸鱼窗口透明度:=200
  IniWrite, %摸鱼窗口透明度%, 色轮设置.ini, 设置, 摸鱼窗口透明度 ;写入设置到ini文件
  ; PSwinclass:="ahk_class OWL.Dock"
  ; IniWrite, %PSwinclass%, 色轮设置.ini, 设置, PS取色窗口
  goto 初始设置
}
return

;========== 下面是类和函数 ==========
Class 后台 {
  ;-- 类开始，使用类的命名空间可防止变量名、函数名污染
  获取控件句柄(WinTitle, Control="") {
    tmm:=A_TitleMatchMode, dhw:=A_DetectHiddenWindows
    SetTitleMatchMode, 2
    DetectHiddenWindows, On
    ControlGet, hwnd, Hwnd,, %Control%, %WinTitle%
    DetectHiddenWindows, %dhw%
    SetTitleMatchMode, %tmm%
    return, hwnd
  }
  点击左键(hwnd, x, y) {
    return, this.Click_PostMessage(hwnd, x, y, "L")
  }
  点击右键(hwnd, x, y) {
    return, this.Click_PostMessage(hwnd, x, y, "R")
  }
  移动鼠标(hwnd, x, y) {
    return, this.Click_PostMessage(hwnd, x, y, 0)
  }
  Click_PostMessage(hwnd, x, y, flag="L") {
    static WM_MOUSEMOVE:=0x200
      , WM_LBUTTONDOWN:=0x201, WM_LBUTTONUP:=0x202
      , WM_RBUTTONDOWN:=0x204, WM_RBUTTONUP:=0x205
    ;---------------------
    VarSetCapacity(pt,16,0), DllCall("GetWindowRect", "ptr",hwnd, "ptr",&pt)
    , ScreenX:=x+NumGet(pt,"int"), ScreenY:=y+NumGet(pt,4,"int")
    Loop {
      NumPut(ScreenX,pt,"int"), NumPut(ScreenY,pt,4,"int")
      , DllCall("ScreenToClient", "ptr",hwnd, "ptr",&pt)
      , x:=NumGet(pt,"int"), y:=NumGet(pt,4,"int")
      , id:=DllCall("ChildWindowFromPoint", "ptr",hwnd, "int64",y<<32|x, "ptr")
      if (id=hwnd or !id)
        Break
      else hwnd:=id
    }
    ;---------------------
    if (flag=0)
      PostMessage, WM_MOUSEMOVE, 0, (y<<16)|x,, ahk_id %hwnd%
    else if InStr(flag,"L")=1
    {
      PostMessage, WM_LBUTTONDOWN, 0, (y<<16)|x,, ahk_id %hwnd%
      PostMessage, WM_LBUTTONUP, 0, (y<<16)|x,, ahk_id %hwnd%
    }
    else if InStr(flag,"R")=1
    {
      PostMessage, WM_RBUTTONDOWN, 0, (y<<16)|x,, ahk_id %hwnd%
      PostMessage, WM_RBUTTONUP, 0, (y<<16)|x,, ahk_id %hwnd%
    }
  }
  发送按键(hwnd, key) {
    static WM_KEYDOWN:=0x100, WM_KEYUP:=0x101
      , WM_SYSKEYDOWN:=0x104, WM_SYSKEYUP:=0x105, KEYEVENTF_KEYUP:=0x2
    Alt:=Ctrl:=Shift:=0
    if InStr(key,"!")
      Alt:=1, key:=StrReplace(key,"!")
    if InStr(key,"^")
    {
      Ctrl:=1, key:=StrReplace(key,"^")
      this.Send_keybd_event("Ctrl")
      Sleep, 100
    }
    if InStr(key,"+")
    {
      Shift:=1, key:=StrReplace(key,"+")
      this.Send_keybd_event("Shift")
      Sleep, 100
    }
    this.Send_PostMessage(hwnd, Alt=1 ? WM_SYSKEYDOWN : WM_KEYDOWN, key)
    Sleep, 100
    this.Send_PostMessage(hwnd, Alt=1 ? WM_SYSKEYUP : WM_KEYUP, key)
    if (Shift=1)
      this.Send_keybd_event("Shift", KEYEVENTF_KEYUP)
    if (Ctrl=1)
      this.Send_keybd_event("Ctrl", KEYEVENTF_KEYUP)
  }
  Send_PostMessage(hwnd, msg, key) {
    static WM_KEYDOWN:=0x100, WM_KEYUP:=0x101
      , WM_SYSKEYDOWN:=0x104, WM_SYSKEYUP:=0x105
    VK:=GetKeyVK(Key), SC:=GetKeySC(Key)
    flag:=msg=WM_KEYDOWN ? 0
      : msg=WM_KEYUP ? 0xC0
      : msg=WM_SYSKEYDOWN ? 0x20
      : msg=WM_SYSKEYUP ? 0xE0 : 0
    PostMessage, msg, VK, (count:=1)|(SC<<16)|(flag<<24),, ahk_id %hwnd%
  }
  Send_keybd_event(key, msg=0) {
    static KEYEVENTF_KEYUP:=0x2
    VK:=GetKeyVK(Key), SC:=GetKeySC(Key)
    DllCall("keybd_event", "int",VK, "int",SC, "int",msg, "int",0)
  }
  ;-- 类结束
}

窗口检定(){
  global
  
  排除:=0
  loop %名单数量%
  {
    当前标题:=排除名单[A_Index]
    ; ToolTip %A_Index% %当前标题%
    ; sleep 400
    检定ID:=WinActive(当前标题)
    if !(WinActive(当前标题)=0)
    {
      排除:=1
      ; ToolTip %当前标题% %检定ID% 已激活
      return
    }
  }
  return
}

~lbutton::
MouseGetPos, , , WinID
WinGet, ExeName, ProcessName, ahk_id %WinID% ;ahk_exe CLIPStudioPaint.exe
WinGetTitle, WinTitle, ahk_id %WinID%
WinGetClass, WinClass, ahk_id %WinID%
if (WinTitle="CLIP STUDIO PAINT") or (WinTitle="導航器") or (WinTitle="色環") or (WinTitle="色彩混合") or (WinClass="Photoshop") or (WinClass="OWL.Dock") or (WinClass="PSFloatC")
{
  ToolTip
  return
}
else
{
  if (ExeName!="CLIPStudioPaint.exe")
  {
    return
  }
  else
  {
    if (InStr(排除标题, WinTitle)=0)
    {
      if (简体中文=1)
      {
        排除标题.=|
        排除标题.=WinTitle
        IniWrite, %排除标题%, 色轮设置.ini, 设置, 简体中文排除标题
        排除名单:=StrSplit(排除标题, "|")
        名单数量:=排除名单.Count()
      }
      else
      {
        排除标题.="|"
        排除标题.=WinTitle
        IniWrite, %排除标题%, 色轮设置.ini, 设置, 繁体中文排除标题
        排除名单:=StrSplit(排除标题, "|")
        名单数量:=排除名单.Count()
      }
      ToolTip 当前窗口标题 %WinTitle% 未在排除列表内 已经自动为您添加`n%排除标题%
    }
    SetTimer, 重新检定, -300
  }
}
return

重新检定:
窗口检定()
return

自动隐藏菜单:
; ToolTip %排除%, , , 2
MouseGetPos, , , WinID
WinGetClass, 当前界面Class名, ahk_id %WinID%
if GetKeyState("LButton", "P") or GetKeyState("Tab", "P") or GetKeyState("Ctrl", "P") or GetKeyState("Shift", "P") or GetKeyState("Alt", "P") or GetKeyState("1", "P") or GetKeyState("2", "P") or GetKeyState("3", "P") or GetKeyState("4", "P") or (色轮=1) or (当前界面Class名!=软件Class名)
{
  return
}
; Hotkey, $Tab, Off
软件前台:=WinActive("ahk_exe CLIPStudioPaint.exe")
if (软件前台!=0x0)
{
  窗口检定()
  CoordMode, Mouse, Screen
  CoordMode, Pixel, Screen
  MouseGetPos, MX, MY, WinID
  if (计时器!=0) and (MY<=屏幕高度/30) and (排除=0)
  {
    耗时:=A_TickCount-计时器
  }
  else if (MY>屏幕高度/20)
  {
    计时器:=0
  }
  
  if (MY<=屏幕高度/30) and (菜单隐藏=1) and (计时器=0) and (排除=0)
  {
    计时器:=A_TickCount
  }
  else if (MY<=屏幕高度/30) and (菜单隐藏=1) and (耗时>300) and (排除=0)
  {
    Send {Shift Down}
    Sleep 100
    loop
    {
      ImageSearch, , , 0, 0, A_ScreenWidth, 屏幕高度/10, *10 %A_ScriptDir%\隐藏菜单.png
      ; ToolTip 显示%ErrorLevel%
      if (ErrorLevel=1) ;隐藏
      {
        Send {Tab Down}
        Sleep 50
        Send {Tab Up}
        Sleep 150
      }
      if (ErrorLevel=0) ;显示
      {
        Send {Tab Down}
        Sleep 50
        Send {Tab Up}
        break
      }
    }
    ImageSearch, , , 0, 0, A_ScreenWidth, 屏幕高度/10, *10 %A_ScriptDir%\隐藏工具栏.png
    if (ErrorLevel=1) ;隐藏
    {
      Send {F3 Down}
      Sleep 50
      Send {F3 Up}
    }
    Send {Shift Up}
    菜单隐藏:=0
    延迟执行:=1
    loop
    {
      CoordMode, Mouse, Screen
      MouseGetPos, , MY
      if GetKeyState("LButton", "P")
      {
        loop
        {
          MouseGetPos, , , WinID
          WinGetClass, 当前界面Class名, ahk_id %WinID%
          if (当前界面Class名!=软件Class名)
          {
            break
          }
        }
      }
      else if (MY>屏幕高度/20)
      {
        break
      }
    }
    loop
    {
      ; WinGetClass, classid, A
      ; ToolTip %classid%
      MouseGetPos, , , WinID
      WinGetClass, 当前界面Class名, ahk_id %WinID%
      if (当前界面Class名=软件Class名)
      {
        if (简体中文=1)
        {
          if (排除=1)
          {
            延迟执行:=1
          }
          else
          {
            延迟执行:=延迟执行+1 
          }
        }
        else
        {
          if (排除=1)
          {
            延迟执行:=1
          }
          else
          {
            延迟执行:=延迟执行+1 
          }
        }
        
        if (延迟执行>35)
        {
          break
        }
      }
      else
      {
        延迟执行:=1
      }
      Sleep 100
    }
    延迟执行:=0
  }
  else if (MY>屏幕高度/20) and (菜单隐藏=0) and (延迟执行=0) and (排除=0)
  {
    计时器:=0
    Send {Shift Down}
    loop
    {
      ImageSearch, , , 0, 0, A_ScreenWidth, 屏幕高度/10, *10 %A_ScriptDir%\隐藏菜单.png
      ; ToolTip 隐藏%ErrorLevel%
      if (ErrorLevel=0) ;显示
      {
        Send {Tab Down}
        Sleep 50
        Send {Tab Up}
        Sleep 150
      }
      if (ErrorLevel=1) ;隐藏
      {
        break
      }
    }
    ImageSearch, , , 0, 0, A_ScreenWidth, 屏幕高度/10, *10 %A_ScriptDir%\隐藏工具栏.png
    if (ErrorLevel=0) ;显示
    {
      Send {F3 Down}
      Sleep 50
      Send {F3 Up}
    }
    Send {Shift Up}
    菜单隐藏:=1
  }
  ; Hotkey, $Tab, On
  
  if (面板展开=0) and (MY>屏幕高度/20)
  {
    if (MX<=A_ScreenWidth/30) or (MX>=A_ScreenWidth-A_ScreenWidth/30) and (排除=0) ;展开面板
    {
      loop
      {
        ImageSearch, , , 0, 0, A_ScreenWidth, 屏幕高度, *10 %A_ScriptDir%\全屏识别.png
        if (ErrorLevel=1)
        {
          Send {Tab Down}
          Sleep 50
          Send {Tab Up}
          Sleep 250
        }
        else if (ErrorLevel=0)
        {
          break
        }
      }
      面板自动展开:=1
      
      ;自动识别面板位置
      CoordMode, Pixel, Screen
      ImageSearch, 隐藏面板XL1, , A_ScreenWidth/15, 0, A_ScreenWidth/2, 屏幕高度/10, *10 %A_ScriptDir%\全屏识别.png
      if (ErrorLevel=1)
      {
        隐藏面板XL1:=Round(A_ScreenWidth/15)
      }
      else if (ErrorLevel=0)
      {
        隐藏面板XL1:=隐藏面板XL1+Round(23/1080*屏幕高度)
      }
      
      ImageSearch, 隐藏面板XL2, , A_ScreenWidth/15, 0, A_ScreenWidth/2, 屏幕高度/10, *10 %A_ScriptDir%\右箭头.png
      if (ErrorLevel=1)
      {
        隐藏面板XL2:=Round(A_ScreenWidth/15)
      }
      else if (ErrorLevel=0)
      {
        隐藏面板XL2:=隐藏面板XL2+Round(20/1080*屏幕高度)
      }
      
      if (隐藏面板XL1<隐藏面板XL2)
      {
        隐藏面板XL:=Round(隐藏面板XL2)
      }
      else
      {
        隐藏面板XL:=Round(隐藏面板XL1)
      }
      
      ImageSearch, 隐藏面板XR1, , A_ScreenWidth/2, 0, A_ScreenWidth-A_ScreenWidth/15, 屏幕高度/10, *10 %A_ScriptDir%\全屏识别.png
      if (ErrorLevel=1)
      {
        隐藏面板XR1:=Round(A_ScreenWidth-A_ScreenWidth/15)
      }
      else if (ErrorLevel=0)
      {
        隐藏面板XR1:=隐藏面板XR1-Round(18/1080*屏幕高度)
      }
      
      ImageSearch, 隐藏面板XR2, , A_ScreenWidth/2, 0, A_ScreenWidth-A_ScreenWidth/15, 屏幕高度/10, *10 %A_ScriptDir%\左箭头.png
      if (ErrorLevel=1)
      {
        隐藏面板XR2:=Round(A_ScreenWidth-A_ScreenWidth/15)
      }
      else if (ErrorLevel=0)
      {
        隐藏面板XR2:=隐藏面板XR2-Round(18/1080*屏幕高度)
      }
      
      if (隐藏面板XR1>隐藏面板XR2)
      {
        隐藏面板XR:=Round(隐藏面板XR2)
      }
      else
      {
        隐藏面板XR:=Round(隐藏面板XR1)
      }
      
      ; ToolTip 隐藏面板XL%隐藏面板XL% MX%MX% 隐藏面板XR%隐藏面板XR%`n隐藏面板XL1 %隐藏面板XL1% 隐藏面板XL2 %隐藏面板XL2%`n隐藏面板XR1 %隐藏面板XR1% 隐藏面板XR2 %隐藏面板XR2%
      
      if (简体中文=1)
      {
        if !(WinActive("导航器")=0)
        {
          导航器:=1
        }
        else
        {
          导航器:=0
        }
      }
      else if (简体中文!=1)
      {
        if !(WinActive("導航器")=0)
        {
          导航器:=1
        }
        else
        {
          导航器:=0
        }
      }
      
      if (导航器=1)
      {
        if (简体中文=1)
        {
          导航器ID:=WinActive("导航器")
          ; ToolTip 导航器ID%导航器ID%
          WinGetPos, 导航器X, 导航器Y, 导航器W, 导航器H, ahk_id %导航器ID%
          if (导航器X<隐藏面板XL) and (导航器防遮挡=0)
          {
            导航器防遮挡:=1
            WinMove, ahk_id %导航器ID%, , 隐藏面板XL+A_ScreenWidth/100, 导航器Y
          }
          else if (导航器X+导航器W>隐藏面板XR) and (导航器防遮挡=0)
          {
            导航器防遮挡:=1
            WinMove, ahk_id %导航器ID%, , 隐藏面板XR-导航器W-A_ScreenWidth/100, 导航器Y
          }
          else
          {
            导航器防遮挡:=0
          }
        }
        else if (简体中文!=1)
        {
          导航器ID:=WinActive("導航器")
          WinGetPos, 导航器X, 导航器Y, 导航器W, 导航器H, ahk_id %导航器ID%
          if (导航器X<隐藏面板XL) and (导航器防遮挡!=1)
          {
            导航器防遮挡:=1
            原始导航器X:=导航器X
            原始导航器Y:=导航器Y
            WinMove, ahk_id %导航器ID%, , 隐藏面板XL+A_ScreenWidth/100, 导航器Y
          }
          else if (导航器X+导航器W>隐藏面板XR) and (导航器防遮挡!=1)
          {
            导航器防遮挡:=1
            原始导航器X:=导航器X
            原始导航器Y:=导航器Y
            WinMove, ahk_id %导航器ID%, , 隐藏面板XR-导航器W-A_ScreenWidth/100, 导航器Y
          }
          ; ToolTip 导航器ID%导航器ID% 导航器防遮挡%导航器防遮挡%
        }
      }
    }
    else if (MX>=隐藏面板XL) and (MX<=隐藏面板XR) and (排除=0) ;隐藏面板
    {
      loop
      {
        ImageSearch, , , A_ScreenWidth/20, 0, A_ScreenWidth-A_ScreenWidth/20, 屏幕高度/10, *10 %A_ScriptDir%\全屏识别.png
        if (ErrorLevel=0)
        {
          Send {Tab Down}
          Sleep 50
          Send {Tab Up}
          Sleep 250
        }
        else if (ErrorLevel=1)
        {
          break
        }
      }
      面板自动展开:=0
      
      ; ToolTip %导航器%
      if (导航器=1)
      {
        loop
        {
          if (Ctrl键3!=0)
          {
            Send {Ctrl Down}
            Sleep 10
          }
          if (Shift键3!=0)
          {
            Send {Shift Down}
            Sleep 10
          }
          if (Alt键3!=0)
          {
            Send {Alt Down}
            Sleep 10
          }
          Send {%快捷键3% Down} ;打开色轮
          Sleep 50
          Send {%快捷键3% Up}
          if (Ctrl键3!=0)
          {
            Send {Ctrl Up}
          }
          if (Shift键3!=0)
          {
            Send {Shift Up}
          }
          if (Alt键3!=0)
          {
            Send {Alt Up}
          }
          Sleep 150
          
          if (简体中文=1)
          {
            if (WinExist("导航器")!=0)
            {
              导航器:=0
              
              if (导航器防遮挡=1)
              {
                WinMove, ahk_id %导航器ID%, , 原始导航器X, 原始导航器Y
                导航器防遮挡:=0
              }
              break
            }
          }
          else if (简体中文!=1)
          {
            if (WinExist("導航器")!=0)
            {
              导航器:=0
              
              if (导航器防遮挡=1)
              {
                WinMove, ahk_id %导航器ID%, , 原始导航器X, 原始导航器Y
                导航器防遮挡:=0
              }
              break
            }
          }
        }
      }
    }
  }
}
return

穿透设置:
SetTimer, 自动隐藏菜单, Delete
if (WinExist("穿透设置")!=0)
{
  WinActivate, 穿透设置
  return
}
; MsgBox, %导航器透明度% %摸鱼窗口透明度%
Gui 穿透设置:+DPIScale -MinimizeBox -MaximizeBox -Resize -SysMenu +AlwaysOnTop
Gui 穿透设置:Font, s9, Segoe UI

Gui 穿透设置:Add, Text, x20 y25 w120 h23 +0x200, 导航器透明度
Gui 穿透设置:Add, CheckBox, x215 y25 w120 h23 G导航器穿透切换 Checked%导航穿透%, 窗口穿透
Gui 穿透设置:Add, Slider, x13 y55 w278 h32 AltSubmit G导航器透明度调整 Range1-100 TickInterval5 ToolTip v导航器透明度, %导航器透明度%

Gui 穿透设置:Add, Text, x20 y115 w120 h23 +0x200, 摸鱼窗口透明度
Gui 穿透设置:Add, CheckBox, x215 y115 w120 h23 G摸鱼窗口穿透切换 Checked%摸鱼穿透%, 窗口穿透
Gui 穿透设置:Add, Slider, x13 y145 w278 h32 AltSubmit G摸鱼窗口透明度调整 Range1-100 TickInterval5 ToolTip v摸鱼窗口透明度, %摸鱼窗口透明度%

Gui 穿透设置:Add, Button, x206 y200 w80 h27 GButton确认2, &确认
Gui 穿透设置:Add, Button, x20 y200 w120 h27 G设置摸鱼窗口, &设置摸鱼窗口

Gui 穿透设置:Show, w303 h240, 穿透设置
; SetTimer, 窗口调整, 100
return

导航器透明度调整:
; ToolTip 导航器透明度%导航器透明度%
IniWrite, %导航器透明度%, 色轮设置.ini, 设置, 导航器透明度
导航器透明度转换:=Ceil(255*(导航器透明度/100))
if (简体中文=1)
{
  if (WinExist("导航器")!=0)
  {
    导航器ID:=WinExist("导航器")
    WinSet, Transparent, %导航器透明度转换%, ahk_id %导航器ID%
  }
}
else if (简体中文!=1)
{
  if (WinExist("導航器")!=0)
  {
    导航器ID:=WinExist("導航器")
    WinSet, Transparent, %导航器透明度转换%, ahk_id %导航器ID%
  }
}
return

导航器穿透切换:
导航器透明度转换:=Ceil(255*(导航器透明度/100))
if (简体中文=1)
{
  if (WinExist("导航器")!=0)
  {
    导航器ID:=WinExist("导航器")
    if (导航穿透=0)
    {
      导航穿透:=1
      WinSet, Transparent, %导航器透明度转换%, ahk_id %导航器ID%
      WinSet, ExStyle, +0x20, ahk_id %导航器ID%
    }
    else ;if (导航穿透=1)
    {
      导航穿透:=0
      WinSet, Transparent, 255, ahk_id %导航器ID%
      WinSet, ExStyle, -0x20, ahk_id %导航器ID%
    }
  }
}
else if (简体中文!=1)
{
  if (WinExist("導航器")!=0)
  {
    导航器ID:=WinExist("導航器")
    if (导航穿透=0)
    {
      导航穿透:=1
      WinSet, Transparent, %导航器透明度转换%, ahk_id %导航器ID%
      WinSet, ExStyle, +0x20, ahk_id %导航器ID%
    }
    else ;if (导航穿透=1)
    {
      导航穿透:=0
      WinSet, Transparent, 255, ahk_id %导航器ID%
      WinSet, ExStyle, -0x20, ahk_id %导航器ID%
    }
  }
}
; ToolTip, 导航穿透%导航穿透%
return

摸鱼窗口透明度调整:
IniWrite, %摸鱼窗口透明度%, 色轮设置.ini, 设置, 摸鱼窗口透明度
摸鱼窗口透明度转换:=Ceil(255*(摸鱼窗口透明度/100))
if (WinExist(ahk_class %摸鱼窗口%)!=0)
{
  摸鱼窗口ID:=WinExist(ahk_class %摸鱼窗口%)
  WinSet, Transparent, %摸鱼窗口透明度转换%, ahk_class %摸鱼窗口%
}
return

摸鱼窗口穿透切换:
摸鱼窗口透明度转换:=Ceil(255*(摸鱼窗口透明度/100))
if (WinExist(ahk_class %摸鱼窗口%)!=0)
{
  摸鱼窗口ID:=WinExist(ahk_class %摸鱼窗口%)
  if (摸鱼穿透=0)
  {
    摸鱼穿透:=1
    WinSet, AlwaysOnTop, On, ahk_class %摸鱼窗口%
    WinSet, Transparent, %摸鱼窗口透明度转换%, ahk_class %摸鱼窗口%
    WinSet, ExStyle, +0x20, ahk_class %摸鱼窗口%
  }
  else ;if (导航穿透=1)
  {
    摸鱼穿透:=0
    WinSet, AlwaysOnTop, Off, ahk_class %摸鱼窗口%
    WinSet, Transparent, 255, ahk_class %摸鱼窗口%
    WinSet, ExStyle, -0x20, ahk_class %摸鱼窗口%
  }
}
return

设置摸鱼窗口:
loop
{
  ToolTip 点击摸鱼窗口以绑定
  if GetKeyState("LButton", "P")
  {
    break
  }
  Sleep 30
}
MouseGetPos, , ,摸鱼窗口ID
WinGetClass, 摸鱼窗口, ahk_id %摸鱼窗口ID%
IniWrite, %摸鱼窗口%, 色轮设置.ini, 设置, 摸鱼窗口 ;写入设置到ini文件
loop 90
{
  ToolTip 已绑定%摸鱼窗口%窗口
  Sleep 30
}
ToolTip
return

Button确认2:
Gui, 穿透设置:Submit, NoHide
Gui, 穿透设置:Destroy
Sleep 300
SetTimer, 自动隐藏菜单, 200
; SetTimer, 窗口调整, Delete
return

初始设置:
初始设置:=0
IniWrite, %初始设置%, 色轮设置.ini, 设置, 初始设置
MsgBox 0, 初始设置, 很高兴见到你嗷OwO`~我是CSP色轮小管家.`n检测到是初次使用`,请根我的据提示完成初始设置`!
MsgBox 4, 初始设置, 请问CSP的界面语言是否是繁体中文嗷`?`-w`-
IfMsgBox No
{
  简体中文:=1
  Menu, Tray, Check, 简体中文 ;右键菜单打勾
  IniWrite, %简体中文%, 色轮设置.ini, 设置, 简体中文
}
else
{
  简体中文:=0
  IniWrite, %简体中文%, 色轮设置.ini, 设置, 简体中文
}
MsgBox 4, 初始设置, 接下来要设置在画布的多大范围内按下Tab才能呼出色轮嗷`!`n如果不知道这项设置是什么`,可以点击否先使用默认设置`,以后右键状态栏中可以再找到画布设置`.
IfMsgBox Yes
{
  goto 画布设置
}
goto 快捷设置
return

重置设置:
FileDelete %A_ScriptDir%\色轮设置.ini
Reload

语言设置:
if (简体中文=0)
{
  简体中文:=1
  Menu, Tray, Check, 简体中文 ;右键菜单打勾
  IniWrite, %简体中文%, 色轮设置.ini, 设置, 简体中文
}
else
{
  简体中文:=0
  Menu, Tray, UnCheck, 简体中文 ;右键菜单不打勾
  IniWrite, %简体中文%, 色轮设置.ini, 设置, 简体中文
}
return

记忆模式:
if (记忆模式=0)
{
  记忆模式:=1
  Menu, Tray, Check, 记忆模式 ;右键菜单打勾
  IniWrite, %记忆模式%, 色轮设置.ini, 设置, 记忆模式
  if GetKeyState("s", "P")
  {
    loop 100
    {
      ToolTip 记忆模式已开启
      if !GetKeyState("Tab", "P")
      {
        break
      }
      Sleep 15
    }
  }
  ToolTip
}
else
{
  记忆模式:=0
  Menu, Tray, UnCheck, 记忆模式 ;右键菜单不打勾
  IniWrite, %记忆模式%, 色轮设置.ini, 设置, 记忆模式
  if GetKeyState("s", "P")
  {
    loop 100
    {
      ToolTip 记忆模式已关闭
      if !GetKeyState("Tab", "P")
      {
        break
      }
      Sleep 15
    }
  }
  ToolTip
}
return

画布设置:
KeyWait, LButton
CoordMode, Mouse, Screen
loop
{
  WinActivate, ahk_exe CLIPStudioPaint.exe ;窗口置于顶层
  Sleep 100
  IfWinActive, ahk_exe CLIPStudioPaint.exe ;窗口坐标获取
  {
    loop
    {
      ToolTip 按住鼠标左键拖拽框选画布范围
      if GetKeyState("LButton", "P")
      {
        ToolTip
        MouseGetPos, 画布对角1X, 画布对角1Y
        break
      }
      Sleep 30
    }
    
    Gui 画布范围:New, -DPIScale -MinimizeBox -MaximizeBox -SysMenu AlwaysOnTop, 画布范围
    Gui 画布范围:Show, W24 H11 X-50 Y-50, 画布范围
    WinSet, Style, -0xC00000, 画布范围 ;去除标题
    WinSet, Transparent, 100, 画布范围 ;透明度0-255
    loop
    {
      MouseGetPos, 画布对角2X, 画布对角2Y
      画布宽度:=Abs(画布对角1X-画布对角2X)
      画布高度:=Abs(画布对角1Y-画布对角2Y)
      
      if (画布对角2X>画布对角1X)
      {
        范围显示X:=画布对角1X
      }
      else
      {
        范围显示X:=画布对角2X
      }
      
      if (画布对角2Y>画布对角1Y)
      {
        范围显示Y:=画布对角1Y
      }
      else
      {
        范围显示Y:=画布对角2Y
      }
      
      WinMove, 画布范围, ,范围显示X, 范围显示Y, 画布宽度, 画布高度
      
      if !GetKeyState("LButton", "P")
      {
        Gui 画布范围:Destroy
        break, 2
      }
    }
  }
}

if (画布对角2X>画布对角1X)
{
  画布左上角X:=画布对角1X
  画布右下角X:=画布对角2X
}
else
{
  画布左上角X:=画布对角2X
  画布右下角X:=画布对角1X
}

if (画布对角2Y>画布对角1Y)
{
  画布左上角Y:=画布对角1Y
  画布右下角Y:=画布对角2Y
}
else
{
  画布左上角Y:=画布对角2Y
  画布右下角Y:=画布对角1Y
}
IniWrite, %画布左上角X%, 色轮设置.ini, 设置, 画布左上角X
IniWrite, %画布左上角Y%, 色轮设置.ini, 设置, 画布左上角Y
IniWrite, %画布右下角X%, 色轮设置.ini, 设置, 画布右下角X
IniWrite, %画布右下角Y%, 色轮设置.ini, 设置, 画布右下角Y

loop 100
{
  ToolTip, 画布范围设置完成`n画布左上角 X%画布左上角X% Y%画布左上角Y%`n画布右下角 X%画布右下角X% %画布右下角Y%
  Sleep 30
}

ToolTip
if (初始设置=0)
{
  goto 快捷设置
}
return

PS取色:
loop
{
  ToolTip 请中键点击PS取色窗口
  if GetKeyState("MButton", "P")
  {
    MouseGetPos, , , PSwinid
    WinGetClass, PSwinclass, ahk_id %PSwinid%
    IniWrite, %PSwinclass%, 色轮设置.ini, 设置, PS取色窗口
    break
  }
  Sleep 30
}
loop 30
{
  ToolTip 已获取PS取色窗口 %PSwinclass%
  Sleep 30
}
ToolTip
return

使用教程:
MsgBox, , 德芙色轮, 黑钨重工出品 免费开源 请勿商用 侵权必究`n更多免费软件教程尽在QQ群 1群763625227 2群643763519`n`n默认使用的是1080P屏幕 100`%缩放的设置`n如果是其他分辨率请自己设置或导入设置包`n`nCSP需要设置的内容`:`n请使用HSV色彩空间 在色轮左上角三条横线处点击即可设置`n画布设置的意思是 画布的多大范围内按下Tab或者中键才能呼出色轮`n呼出色轮的快捷键`n设置的位置在 文件`-快捷键设置`-主菜单`-窗口`-色環/色轮`n呼出调色盘的快捷键`n设置的位置在 文件`-快捷键设置`-主菜单`-窗口`-色彩混合/混色`n自动隐藏需要设置命令列的快捷键为Shift`+F3`nCtrl`+Enter键 短按打开自动隐藏功能 长按关闭自动隐藏功能`n`nPS需要设置的内容`:`n呼出前景色拾色器的快捷键为N`n设置的位置在 工具`-前景色拾色器`n`n数位板相关设置`:`n数位板属性中 关闭Windows Ink功能`nCSP环境设置中 绘图板`-要使用的绘图板服务`-Wintab`n`n按住Tab键 或 鼠标中键 触发德芙色轮`n如果取色环显示位置不准 请打开色环矫正后 使用上下左右箭头修正`nW 切换色板`nQ和E 或者 滚轮 控制色相慢速左旋和右旋`nA和D 控制色相快速左旋和右旋`nS 打开或关闭记忆模式`n每次打开色轮使用上次在色轮中取的色而不使用在画布上取的颜色`n松开Tab 或 鼠标中键 完成取色`n`n色轮打开后右移动即可打开调色盘`n当打开调色盘时使用以下快捷键操作`n重音符波浪号 清空调色盘`n数字1 短按撤回 长按还原`n数字2 和 数字3 控制笔刷大小`n数字4 切换笔刷样式`n`n其他功能`:`nAlt`+A`/D 切换上一个下一个画布`n导航器穿透 打开后会以半透明显示 可以穿过导航器画画`n以亮度为基准黑白显示需要系统设置`-轻松使用`-颜色滤镜`-允许使用快捷键打开滤镜`n双击空格 在亮度基准显示和正常显示之间切换`nPgUp`+PgDn 强制重启   Home`+End 强制退出`n`n更新后无法运行请删除ini文件后重新运行本软件`n如果仍然使用不了请私聊我付费远程调试服务
return

视频教程:
Run https://space.bilibili.com/52593606/channel/collectiondetail?sid=1814250
return

软件更新:
Run https://github.com/Furtory/HighEfficiencyColorWheelForCSPv2
return

快捷设置:
if (WinExist("快捷键设置")!=0)
{
  WinActivate, 快捷键设置
  return
}
if (初始设置=0)
{
  MsgBox 0, 初始设置, 咱要知道CSP设置中呼出色轮和调色盘的快捷键是什么才能运行嗷`~如果没有设置请现在设置一个才能运行哦`!`n设置的位置在`:文件`-快捷键设置`-主菜单`-窗口`-色環/色轮 色彩混合/混色
}
旧色轮呼出快捷键:=色轮呼出快捷键
旧调色盘呼出快捷键:=调色盘呼出快捷键
旧导航器呼出快捷键:=导航器呼出快捷键
Gui 快捷键:+DPIScale -MinimizeBox -MaximizeBox -Resize -SysMenu
Gui 快捷键:Font, s9, Segoe UI
Gui 快捷键:Add, Text, x9 y7 w157 h20, 色轮呼出快捷键
Gui 快捷键:Add, Hotkey, x9 y31 w157 h25 v色轮呼出快捷键, %色轮呼出快捷键%
Gui 快捷键:Add, Text, x9 y68 w157 h20, 调色盘呼出快捷键
Gui 快捷键:Add, Hotkey, x9 y92 w157 h25 v调色盘呼出快捷键, %调色盘呼出快捷键%
Gui 快捷键:Add, Text, x9 y129 w157 h20, 导航器呼出快捷键
Gui 快捷键:Add, Hotkey, x9 y153 w157 h25 v导航器呼出快捷键, %导航器呼出快捷键%
Gui 快捷键:Add, Button, x9 y187 w80 h23 GButton确认, &确认
Gui 快捷键:Add, Button, x89 y187 w80 h23 GButton取消, &取消
Gui 快捷键:Show, w174 h237, 快捷键设置
return

Button确认:
Gui, 快捷键:Submit, NoHide
Gui, 快捷键:Destroy
IniWrite, %色轮呼出快捷键%, 色轮设置.ini, 设置, 色轮呼出快捷键 ;写入设置到ini文件
快捷键1:=色轮呼出快捷键
Ctrl键1:=InStr(快捷键1, "^")
Shift键1:=InStr(快捷键1, "+")
Alt键1:=InStr(快捷键1, "!")
快捷键1:=StrReplace(快捷键1,"^")
快捷键1:=StrReplace(快捷键1,"+")
快捷键1:=StrReplace(快捷键1,"!")

IniWrite, %调色盘呼出快捷键%, 色轮设置.ini, 设置, 调色盘呼出快捷键 ;写入设置到ini文件
快捷键2:=调色盘呼出快捷键
Ctrl键2:=InStr(快捷键2, "^")
Shift键2:=InStr(快捷键2, "+")
Alt键2:=InStr(快捷键2, "!")
快捷键2:=StrReplace(快捷键2,"^")
快捷键2:=StrReplace(快捷键2,"+")
快捷键2:=StrReplace(快捷键2,"!")

IniWrite, %导航器呼出快捷键%, 色轮设置.ini, 设置, 导航器呼出快捷键 ;写入设置到ini文件
快捷键3:=导航器呼出快捷键
Ctrl键3:=InStr(快捷键3, "^")
Shift键3:=InStr(快捷键3, "+")
Alt键3:=InStr(快捷键3, "!")
快捷键3:=StrReplace(快捷键3,"^")
快捷键3:=StrReplace(快捷键3,"+")
快捷键3:=StrReplace(快捷键3,"!")

if (初始设置=0)
{
  初始设置:=1
  IniWrite, %初始设置%, 色轮设置.ini, 设置, 初始设置
  goto 使用教程
}
return

Button取消:
色轮呼出快捷键:=旧色轮呼出快捷键
调色盘呼出快捷键:=旧调色盘呼出快捷键
导航器呼出快捷键:=旧导航器呼出快捷键
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
    FileGetShortcut, %autostartLnk%, lnkTarget ;获取开机启动文件的信息
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

PgUp & PgDn::Reload
重启软件:
Reload

Home & End::ExitApp
退出软件:
ExitApp

中键呼出:
if (中键呼出=0)
{
  Menu, Tray, Check, 中键呼出 ;右键菜单打勾
  中键呼出:=1
  IniWrite, %中键呼出%, 色轮设置.ini, 设置, 中键呼出
  Hotkey, MButton, On
  Hotkey, $WheelUp, On
  Hotkey, $WheelDown, On
}
else
{
  Menu, Tray, UnCheck, 中键呼出 ;右键菜单不打勾
  中键呼出:=0
  IniWrite, %中键呼出%, 色轮设置.ini, 设置, 中键呼出
  Hotkey, MButton, Off
  Hotkey, $WheelUp, Off
  Hotkey, $WheelDown, Off
}
return

色环矫正:
if (色环矫正=0)
{
  Menu, Tray, Check, 色环矫正 ;右键菜单打勾
  色环矫正:=1
  Hotkey, Up, On
  Hotkey, Down, On
  Hotkey, Left, On
  Hotkey, Right, On
}
else
{
  Menu, Tray, UnCheck, 色环矫正 ;右键菜单不打勾
  色环矫正:=0
  Hotkey, Up, Off
  Hotkey, Down, Off
  Hotkey, Left, Off
  Hotkey, Right, Off
}
return

上:
if (色轮=1)
{
  if (全屏=1)
  {
    全屏色轮位置Y补偿:=全屏色轮位置Y补偿-1
    IniWrite, %全屏色轮位置Y补偿%, 色轮设置.ini, 设置, 全屏色轮位置Y补偿
    WinMove 取色环, , 鼠标在屏幕位置X-Round(61/1080*屏幕高度)-移动画布距离+全屏色轮位置X补偿, 鼠标在屏幕位置Y-Round(36/1080*屏幕高度)+全屏色轮位置Y补偿
  }
  else
  {
    色轮位置Y补偿:=色轮位置Y补偿-1
    IniWrite, %色轮位置Y补偿%, 色轮设置.ini, 设置, 色轮位置Y补偿
    WinMove 取色环, , 鼠标在屏幕位置X-Round(61/1080*屏幕高度)-移动画布距离+色轮位置X补偿, 鼠标在屏幕位置Y-Round(36/1080*屏幕高度)+色轮位置Y补偿
  }
}
return

下:
if (色轮=1)
{
  if (全屏=1)
  {
    全屏色轮位置Y补偿:=全屏色轮位置Y补偿+1
    IniWrite, %全屏色轮位置Y补偿%, 色轮设置.ini, 设置, 全屏色轮位置Y补偿
    WinMove 取色环, , 鼠标在屏幕位置X-Round(61/1080*屏幕高度)-移动画布距离+全屏色轮位置X补偿, 鼠标在屏幕位置Y-Round(36/1080*屏幕高度)+全屏色轮位置Y补偿
  }
  else
  {
    色轮位置Y补偿:=色轮位置Y补偿+1
    IniWrite, %色轮位置Y补偿%, 色轮设置.ini, 设置, 色轮位置Y补偿
    WinMove 取色环, , 鼠标在屏幕位置X-Round(61/1080*屏幕高度)-移动画布距离+色轮位置X补偿, 鼠标在屏幕位置Y-Round(36/1080*屏幕高度)+色轮位置Y补偿
  }
}
return

左:
if (色轮=1)
{
  if (全屏=1)
  {
    全屏色轮位置X补偿:=全屏色轮位置X补偿-1
    IniWrite, %全屏色轮位置X补偿%, 色轮设置.ini, 设置, 全屏色轮位置X补偿
    WinMove 取色环, , 鼠标在屏幕位置X-Round(61/1080*屏幕高度)-移动画布距离+全屏色轮位置X补偿, 鼠标在屏幕位置Y-Round(36/1080*屏幕高度)+全屏色轮位置Y补偿
  }
  else
  {
    色轮位置X补偿:=色轮位置X补偿-1
    IniWrite, %色轮位置X补偿%, 色轮设置.ini, 设置, 色轮位置X补偿
    WinMove 取色环, , 鼠标在屏幕位置X-Round(61/1080*屏幕高度)-移动画布距离+色轮位置X补偿, 鼠标在屏幕位置Y-Round(36/1080*屏幕高度)+色轮位置Y补偿
  }
}
return

右:
if (色轮=1)
{
  if (全屏=1)
  {
    全屏色轮位置X补偿:=全屏色轮位置X补偿+1
    IniWrite, %全屏色轮位置X补偿%, 色轮设置.ini, 设置, 全屏色轮位置X补偿
    WinMove 取色环, , 鼠标在屏幕位置X-Round(61/1080*屏幕高度)-移动画布距离+全屏色轮位置X补偿, 鼠标在屏幕位置Y-Round(36/1080*屏幕高度)+全屏色轮位置Y补偿
  }
  else
  {
    色轮位置X补偿:=色轮位置X补偿+1
    IniWrite, %色轮位置X补偿%, 色轮设置.ini, 设置, 色轮位置X补偿
    WinMove 取色环, , 鼠标在屏幕位置X-Round(61/1080*屏幕高度)-移动画布距离+色轮位置X补偿, 鼠标在屏幕位置Y-Round(36/1080*屏幕高度)+色轮位置Y补偿
  }
}
return

ToBase(n,b){
    return (n < b ? "" : ToBase(n//b,b)) . ((d:=Mod(n,b)) < 10 ? d : Chr(d+55))
}

中键:
$Tab:: ;Tab键
CoordMode, Mouse, Screen
MouseGetPos, 鼠标在屏幕位置X, 鼠标在屏幕位置Y, CSP检测
WinGet, 软件EXE名, ProcessName, ahk_id %CSP检测%
最近按键:=StrReplace(A_ThisHotkey, "$")
; ToolTip %软件EXE名% %最近按键%
if (软件EXE名!="CLIPStudioPaint.exe")
{
  Send {%最近按键% Down}
  KeyWait, %最近按键%
  Send {%最近按键% Up}
  return
}
Send {Tab Up}
 ;检测鼠标是否在画布范围
if (鼠标在屏幕位置X<画布左上角X) or (鼠标在屏幕位置X>画布右下角X) or (鼠标在屏幕位置Y<画布左上角Y) or (鼠标在屏幕位置Y>画布右下角Y) ;不在画布范围内
{
  if (面板自动展开=1)
  {
    面板展开:=1
    面板自动展开:=0
    IniWrite, %面板展开%, 色轮设置.ini, 设置, 面板展开
    return
  }
  Send {Tab Down}
  KeyWait, Tab
  Send {Tab Up}
  Sleep 50
  ImageSearch, , , 0, 0, A_ScreenWidth, 屏幕高度, *10 %A_ScriptDir%\全屏识别.png
  if (ErrorLevel=0) ;是全屏
  {
    面板展开:=1
    IniWrite, %面板展开%, 色轮设置.ini, 设置, 面板展开
  }
  else
  {
    面板展开:=0
    IniWrite, %面板展开%, 色轮设置.ini, 设置, 面板展开
  }
  return
}

 ;在画布范围
WinActivate, ahk_exe CLIPStudioPaint.exe ;窗口置于顶层
BlockInput, On
CoordMode, Pixel, Screen

 ;识别是否全屏
ImageSearch, , , 0, 0, A_ScreenWidth, 屏幕高度, *10 %A_ScriptDir%\全屏识别.png
if (ErrorLevel=0) ;是全屏
{
  Send {Tab} ;进入全屏
  全屏:=1
}
else
{
  全屏:=0
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
Sleep 10
Send {LButton Up}
Send {space Up}
MouseMove, 移动画布距离, 0, 0, R

 ;打开色轮并检测是否打开
if (Ctrl键1!=0)
{
  Send {Ctrl Down}
  Sleep 10
}
if (Shift键1!=0)
{
  Send {Shift Down}
  Sleep 10
}
if (Alt键1!=0)
{
  Send {Alt Down}
  Sleep 10
}
Send {%快捷键1% Down} ;打开色轮
Sleep 50
Send {%快捷键1% Up}
if (Ctrl键1!=0)
{
  Send {Ctrl Up}
}
if (Shift键1!=0)
{
  Send {Shift Up}
}
if (Alt键1!=0)
{
  Send {Alt Up}
}
开始计时:=A_TickCount
if (简体中文=1)
{
  loop ;寻找色轮
  {
    寻找耗时:=A_TickCount-开始计时
    ; ToolTip 寻找色轮中%寻找耗时%ms
    if !(WinExist("色轮")=0) ;""内填窗口名称
    {
      色轮:=1
      色轮窗口ID:=WinExist("色轮") ;""内填窗口名称
      ; ToolTip 已找到色轮
      BlockInput, Off
      break
    }
    else
    {
      if (寻找耗时>3000)
      {
        色轮:=0
        Sleep 10
        Send {space Down}
        Send {LButton Down}
        CoordMode, Mouse, Screen
        MouseMove, 移动画布距离, 0, 0, R
        Sleep 10
        Send {LButton Up}
        Send {space Up}
        if (全屏=1) ;如果之前进入了全屏则退出全屏
        {
          Send {Tab}
          全屏:=0
        }
        MouseMove, 鼠标在屏幕位置X, 鼠标在屏幕位置Y
        BlockInput, Off
        loop 100
        {
          ToolTip 未找到色轮 请检查呼出色轮快捷键设置是否正确
          Sleep 30
        }
        ToolTip
        return
      }
      
      if (Ctrl键1!=0)
      {
        Send {Ctrl Down}
        Sleep 10
      }
      if (Shift键1!=0)
      {
        Send {Shift Down}
        Sleep 10
      }
      if (Alt键1!=0)
      {
        Send {Alt Down}
        Sleep 10
      }
      Send {%快捷键1% Down} ;打开色轮
      Sleep 50
      Send {%快捷键1% Up}
      if (Ctrl键1!=0)
      {
        Send {Ctrl Up}
      }
      if (Shift键1!=0)
      {
        Send {Shift Up}
      }
      if (Alt键1!=0)
      {
        Send {Alt Up}
      }
      Sleep 300
    }
  }
}
else
{
  loop ;寻找色轮
  {
    寻找耗时:=A_TickCount-开始计时
    ; ToolTip 寻找色轮中%寻找耗时%ms
    if !(WinExist("色環")=0) ;""内填窗口名称
    {
      色轮:=1
      色轮窗口ID:=WinExist("色環") ;""内填窗口名称
      ; ToolTip 已找到色轮
      BlockInput, Off
      break
    }
    else
    {
      if (寻找耗时>3000)
      {
        色轮:=0
        Sleep 10
        Send {space Down}
        Send {LButton Down}
        CoordMode, Mouse, Screen
        MouseMove, 移动画布距离, 0, 0, R
        Sleep 10
        Send {LButton Up}
        Send {space Up}
        if (全屏=1) ;如果之前进入了全屏则退出全屏
        {
          Send {Tab}
          全屏:=0
        }
        MouseMove, 鼠标在屏幕位置X, 鼠标在屏幕位置Y
        BlockInput, Off
        loop 100
        {
          ToolTip 未找到色轮 请检查呼出色轮快捷键设置是否正确
          Sleep 30
        }
        ToolTip
        return
      }
      
      if (Ctrl键1!=0)
      {
        Send {Ctrl Down}
        Sleep 10
      }
      if (Shift键1!=0)
      {
        Send {Shift Down}
        Sleep 10
      }
      if (Alt键1!=0)
      {
        Send {Alt Down}
        Sleep 10
      }
      Send {%快捷键1% Down} ;打开色轮
      Sleep 50
      Send {%快捷键1% Up}
      if (Ctrl键1!=0)
      {
        Send {Ctrl Up}
      }
      if (Shift键1!=0)
      {
        Send {Shift Up}
      }
      if (Alt键1!=0)
      {
        Send {Alt Up}
      }
      Sleep 300
    }
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
if (全屏=1)
{
  WinMove 取色环, , 鼠标在屏幕位置X-Round(61/1080*屏幕高度)-移动画布距离+全屏色轮位置X补偿, 鼠标在屏幕位置Y-Round(36/1080*屏幕高度)+全屏色轮位置Y补偿
}
else ;if (全屏=0)
{
  WinMove 取色环, , 鼠标在屏幕位置X-Round(61/1080*屏幕高度)-移动画布距离+色轮位置X补偿, 鼠标在屏幕位置Y-Round(36/1080*屏幕高度)+色轮位置Y补偿
}
; Gui, 取色环:Color, 0xffffff ;色环颜色

 ;查看正在使用哪个色板
if (简体中文=1)
{
  WinActivate 色轮
  WinGetPos, 色轮在屏幕位置X, 色轮在屏幕位置Y, , , 色轮
}
else
{
  WinActivate 色環
  WinGetPos, 色轮在屏幕位置X, 色轮在屏幕位置Y, , , 色環
}
CoordMode Pixel, Window
PixelSearch, 色板位置X, , 0, Round(467/1080*屏幕高度), Round(126/1080*屏幕高度), Round(469/1080*屏幕高度), 0x7D8EB3, 10, Fast RGB
if (色板位置X<Round(45/1080*屏幕高度))
{
  取色位置X:=Round(25/1080*屏幕高度)
  色板位置:=1
}
else if (色板位置X>Round(45/1080*屏幕高度)) and (色板位置X<Round(85/1080*屏幕高度))
{
  取色位置X:=Round(65/1080*屏幕高度)
  色板位置:=2
}
else
{
  if (色板位置=1)
  {
    取色位置X:=Round(25/1080*屏幕高度)
  }
  else (色板位置=2)
  {
    取色位置X:=Round(65/1080*屏幕高度)
  }
}
; ToolTip %色板位置% %色板位置X%

if (记忆模式=1)
{
  取色颜色:=色板1取色颜色
  gosub 更新色板位置
  鼠标在色轮位置X1:=鼠标在色轮位置X
  鼠标在色轮位置Y1:=鼠标在色轮位置Y
  色板1色相角度:=色相角度
  BlockInput MouseMove
  CoordMode, Mouse, Screen
  MouseGetPos, 鼠标在屏幕位置记忆X, 鼠标在屏幕位置记忆Y
  CoordMode, Mouse, Screen
  if (色板位置=1)
  {
    IniWrite, %色板1色相角度%, 色轮设置.ini, 设置, 色板1色相角度
  }
  else if (色板位置=2)
  {
    IniWrite, %色板2色相角度%, 色轮设置.ini, 设置, 色板2色相角度
  }
  gosub 色相偏移
  Send {LButton Up}
  Sleep 10
  CoordMode, Mouse, Screen
  MouseMove, 鼠标在屏幕位置记忆X, 鼠标在屏幕位置记忆Y, 0
  BlockInput MouseMoveOff
  
  IniWrite, %鼠标在色轮位置X1%, 色轮设置.ini, 设置, 鼠标在色轮位置X1
  IniWrite, %鼠标在色轮位置Y1%, 色轮设置.ini, 设置, 鼠标在色轮位置Y1
  IniWrite, %色板1色相角度%, 色轮设置.ini, 设置, 色板1色相角度
  IniWrite, %取色颜色%, 色轮设置.ini, 设置, 色板1取色颜色
}
else
{
  CoordMode Pixel, Screen
  PixelGetColor, 取色颜色, 色轮在屏幕位置X+取色位置X, 色轮在屏幕位置Y+取色位置Y, RGB
  ;检测当前颜色和之前是否一致
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
if (简体中文=1)
{
  WinMove, 色轮, , 色轮位置X, 色轮位置Y, 色轮宽度W, 色轮高度H ;移动色轮窗口位置
}
else
{
  WinMove, 色環, , 色轮位置X, 色轮位置Y, 色轮宽度W, 色轮高度H ;移动色轮窗口位置
}

 ;调整取色环颜色并监控热键
Send {LButton Down} ;开始取色
BlockInput, Off
BlockInput, MouseMoveOff
CoordMode Pixel, Screen
CoordMode, Mouse, Window
旧取色颜色:=取色颜色
MouseGetPos, 鼠标取色位置X, 鼠标取色位置Y, 色轮窗口ID
手动取色:=0
呼出调色盘:=0
呼出PS取色:=0
在PS取色:=0
loop
{
  CoordMode, Mouse, Screen
  MouseGetPos, 调色盘检测X, 调色盘检测Y
  if GetKeyState("LButton", "P")
  {
    手动取色:=1
    CoordMode, Mouse, Window
    MouseGetPos, 鼠标取色位置X, 鼠标取色位置Y, 当前界面Winid
    WinGetClass, 当前界面winclass, ahk_id %当前界面Winid%
    if (WinExist("ahk_class PSFloatC")!=0x0) ;""内填窗口名称
    {
      MouseGetPos, , , 拾色器判断
      WinGetClass, 当前窗口Class名, ahk_id %拾色器判断%
      ; ToolTip, 鼠标在拾色器位置X%鼠标在拾色器位置X% 鼠标在拾色器位置Y%鼠标在拾色器位置Y%
      if (当前窗口Class名="PSFloatC")
      {
        CoordMode, Mouse, Window
        MouseGetPos, 鼠标在拾色器位置X, 鼠标在拾色器位置Y
        WinGetPos, 拾色器窗口X, 拾色器窗口Y
        if (鼠标在拾色器位置Y<=Round(35/1080*屏幕高度))
        {
          KeyWait, LButton
          Send {Ctrl Down}
          Send {Shift Down}
          Sleep 30
          Send {Y Down}
          Sleep 30
          Send {Y Up}
          Send {Shift Up}
          Send {Ctrl Up}
        }
        else if (鼠标在拾色器位置Y>=Round(35/1080*屏幕高度)) and (鼠标在拾色器位置Y<=Round(75/1080*屏幕高度)) and (鼠标在拾色器位置X>=Round(425/1080*屏幕高度)) ;确定
        {
          KeyWait, LButton
          CoordMode, Pixel, Screen
          PixelGetColor, 取色颜色, 拾色器窗口X+Round(351/1080*屏幕高度), 拾色器窗口Y+Round(95/1080*屏幕高度), RGB
          Gui, 取色环:Color, %取色颜色% ;色环颜色
          loop 50
          {
            if (WinExist("ahk_class PSFloatC")=0x0)
            {
              在CSP取色颜色:=取色颜色
              gosub PS到CSP色彩更新
              break
            }
            Sleep 10
          }
        }
        else
        {
          ; ToolTip, e
          loop
          {
            CoordMode, Pixel, Screen
            PixelGetColor, 取色颜色, 拾色器窗口X+Round(350/1080*屏幕高度), 拾色器窗口Y+Round(95/1080*屏幕高度), RGB
            Gui, 取色环:Color, %取色颜色% ;色环颜色
            ; ToolTip, 鼠标在拾色器位置X%鼠标在拾色器位置X% 鼠标在拾色器位置Y%鼠标在拾色器位置Y% 取色颜色%取色颜色%
            if !GetKeyState("LButton", "P")
            {
              break
            }
          }
          if (LButton_presses > 0) ; SetTimer 已经启动, 所以我们记录键击.
          {
            LButton_presses += 1
          }
          else
          {
            LButton_presses := 1
            SetTimer, KeyLButton, -400 ; 在 400 毫秒内等待更多的键击.
          }
        }
      }
    }
    else if (当前界面winclass="OWL.Dock") and GetKeyState("LButton", "P")
    {
      IfWinNotActive, ahk_class OWL.Dock
      {
        BlockInput, Send
        ; Send {Tab Up}
        WinActivate, ahk_class OWL.Dock
        Send {LButton Up}
        Sleep 10
        Send {LButton Down}
        BlockInput, Default
      }
      
      在PS取色:=1
      loop
      {
        PixelGetColor, 取色颜色, 色轮位置X+Round(20/1080*屏幕高度), 色轮位置Y+色轮高度H+Round(62/1080*屏幕高度), RGB
        ; 旧在PS取色:=取色颜色
        Gui, 取色环:Color, %取色颜色% ;色环颜色
        if !GetKeyState("LButton", "P")
        {
          gosub PS到CSP色彩更新
          Sleep 50
          if (WinExist("ahk_class PSFloatC")!=0x0) ;""内填窗口名称
          {
            BlockInput, On
            CoordMode, Mouse, Screen
            WinActivate, ahk_class PSFloatC
            WinGetPos, 拾色器窗口X, 拾色器窗口Y
            
            if (拾色器窗口X!=色轮位置X+Round(40/1080*屏幕高度)) or (拾色器窗口Y!=色轮位置Y+色轮高度H)
            {
              MouseMove, 拾色器窗口X+Round(15/1080*屏幕高度), 拾色器窗口Y+Round(5/1080*屏幕高度), 0
              Send {LButton Down}
              MouseMove, 色轮位置X+Round(55/1080*屏幕高度), 色轮位置Y+色轮高度H+Round(5/1080*屏幕高度), 0
              Sleep 10
              Send {LButton Up}
            }
            
            if (记忆模式=0) and (在CSP取色颜色!=取色颜色)
            {
              在CSP取色颜色:=StrReplace(在CSP取色颜色,"0x")
              Clipboard:=在CSP取色颜色
              Sleep 10
              Send {Ctrl Down}
              Sleep 50
              Send {v Down}
              Sleep 50
              Send {v Up}
              Send {Ctrl Up}
              Sleep 50
            }
            
            BlockInput Off
          }
          break
        }
      }
    }
    else
    {
      在PS取色:=0
      loop
      {
        PixelGetColor, 取色颜色, 色轮位置X+取色位置X, 色轮位置Y+取色位置Y, RGB
        在CSP取色颜色:=取色颜色
        Gui, 取色环:Color, %取色颜色% ;色环颜色
        if !GetKeyState("LButton", "P")
        {
          break
        }
      }
    }
  }
  else if (调色盘检测X>色轮位置X+(色轮宽度W-色轮目标边长)/2+色轮目标边长+Round(20/1080*屏幕高度)) and (调色盘!=1) and (呼出调色盘!=1)
  {
    if (手动取色=0)
    {
      取色颜色:=旧取色颜色
      gosub 调色模式
      后台.点击左键(色轮窗口ID, 鼠标取色位置X, 鼠标取色位置Y)
    }
    else
    {
      gosub 调色模式
    }
  }
  else if (调色盘检测Y>色轮位置Y+色轮高度H) and (呼出PS取色!=1)
  {
    呼出PS取色:=1
    if (手动取色=0)
    {
      取色颜色:=旧取色颜色
      gosub 调色模式
      后台.点击左键(色轮窗口ID, 鼠标取色位置X, 鼠标取色位置Y)
    }
    else
    {
      gosub 调色模式
    }
  }
  else if !GetKeyState("Tab", "P") and !GetKeyState("MButton", "P")
  {
    PixelGetColor, 取色颜色, 色轮位置X+取色位置X, 色轮位置Y+取色位置Y, RGB
    break
  }
  else if GetKeyState("w", "P")
  {
    gosub 切换色板
  }
  else if GetKeyState("s", "P")
  {
    gosub 记忆模式
  }
  else if GetKeyState("q", "P") or (色相慢左旋=1)
  {
    gosub 色相慢左旋
  }
  else if GetKeyState("e", "P") or (色相慢右旋=1)
  {
    gosub 色相慢右旋
  }
  else if GetKeyState("a", "P")
  {
    gosub 色相快左旋
  }
  else if GetKeyState("d", "P")
  {
    gosub 色相快右旋
  }
  else if (调色盘=1)
  {
    if GetKeyState("``", "P")
    {
      gosub 清除调色盘
    }
    else if GetKeyState("1", "P")
    {
      gosub 撤回还原调色盘
    }
    else if GetKeyState("2", "P")
    {
      gosub 调色盘笔刷变小
    }
    else if GetKeyState("3", "P")
    {
      gosub 调色盘笔刷变大
    }
    else if GetKeyState("4", "P")
    {
      gosub 切换调色盘笔刷样式
    }
  }
  
  if (在PS取色=0)
  {
    PixelGetColor, 取色颜色, 色轮位置X+取色位置X, 色轮位置Y+取色位置Y, RGB
    在CSP取色颜色:=取色颜色
  }
  else
  {
    if (WinExist("ahk_class PSFloatC")!=0x0) ;""内填窗口名称
    {
      PixelGetColor, 取色颜色, 拾色器窗口X+Round(350/1080*屏幕高度), 拾色器窗口Y+Round(95/1080*屏幕高度), RGB
    }
    else
    {
      PixelGetColor, 取色颜色, 色轮位置X+Round(20/1080*屏幕高度), 色轮位置Y+色轮高度H+Round(62/1080*屏幕高度), RGB
    }
  }
  Gui, 取色环:Color, %取色颜色% ;色环颜色
  Sleep 10
}

if (WinExist("ahk_class PSFloatC")!=0x0) ;""内填窗口名称
{
  WinActivate, ahk_class PSFloatC
  Send {Enter Down}
  Sleep 50
  Send {Enter Up}
}

 ;抬起热键关闭取色环
Gui, 取色环:Destroy
WinSet, AlwaysOnTop, Off, ahk_class Photoshop
WinActivate, ahk_exe CLIPStudioPaint.exe ;窗口置于顶层
CoordMode, Mouse, Window
MouseGetPos, 鼠标在色轮位置X, 鼠标在色轮位置Y

 ;记录取色位置到配置文件
if (调色盘=1)
{
  if (色板位置=1)
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
  else if (色板位置=2)
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
}
if (色板位置=1)
{
  鼠标在色轮位置X1:=鼠标在色轮位置X
  鼠标在色轮位置Y1:=鼠标在色轮位置Y
  if (鼠标在色轮位置X1<色轮方块XL边界)
  {
    鼠标在色轮位置X1:=色轮方块XL边界
  }
  else if (鼠标在色轮位置X1>色轮方块XR边界)
  {
    鼠标在色轮位置X1:=色轮方块XR边界
  }
  if (鼠标在色轮位置Y1<色轮方块YU边界)
  {
    鼠标在色轮位置Y1:=色轮方块YU边界
  }
  else if (鼠标在色轮位置Y1>色轮方块YD边界)
  {
    鼠标在色轮位置Y1:=色轮方块YD边界
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
  if (鼠标在色轮位置X1<色轮方块XL边界)
  {
    鼠标在色轮位置X1:=色轮方块XL边界
  }
  else if (鼠标在色轮位置X1>色轮方块XR边界)
  {
    鼠标在色轮位置X1:=色轮方块XR边界
  }
  if (鼠标在色轮位置Y1<色轮方块YU边界)
  {
    鼠标在色轮位置Y1:=色轮方块YU边界
  }
  else if (鼠标在色轮位置Y1>色轮方块YD边界)
  {
    鼠标在色轮位置Y1:=色轮方块YD边界
  }
  IniWrite, %鼠标在色轮位置X2%, 色轮设置.ini, 设置, 鼠标在色轮位置X2
  IniWrite, %鼠标在色轮位置Y2%, 色轮设置.ini, 设置, 鼠标在色轮位置Y2
  色板2取色颜色:=取色颜色
  IniWrite, %取色颜色%, 色轮设置.ini, 设置, 色板2取色颜色
}

 ;关闭色轮并移动画布至原始位置
CoordMode, Mouse, Screen
MouseGetPos, 鼠标在屏幕位置X, 鼠标在屏幕位置Y
WinActivate, ahk_exe CLIPStudioPaint.exe ;窗口置于顶层
BlockInput, On
BlockInput, MouseMove
Send {LButton Up} ;结束取色
if (调色盘=1)
{
  if !(WinExist("混色")=0) or !(WinExist("色彩混合")=0)
  {
    调色盘:=0
    if (Ctrl键2!=0)
    {
      Send {Ctrl Down}
      Sleep 10
    }
    if (Shift键2!=0)
    {
      Send {Shift Down}
      Sleep 10
    }
    if (Alt键2!=0)
    {
      Send {Alt Down}
      Sleep 10
    }
    Send {%快捷键2% Down} ;打开色轮
    Sleep 50
    Send {%快捷键2% Up}
    if (Ctrl键2!=0)
    {
      Send {Ctrl Up}
    }
    if (Shift键2!=0)
    {
      Send {Shift Up}
    }
    if (Alt键2!=0)
    {
      Send {Alt Up}
    }
  }
}
if !(WinExist("色轮")=0) or !(WinExist("色環")=0)
{
  if (Ctrl键1!=0)
  {
    Send {Ctrl Down}
    Sleep 10
  }
  if (Shift键1!=0)
  {
    Send {Shift Down}
    Sleep 10
  }
  if (Alt键1!=0)
  {
    Send {Alt Down}
    Sleep 10
  }
  Send {%快捷键1% Down} ;打开色轮
  Sleep 50
  Send {%快捷键1% Up}
  if (Ctrl键1!=0)
  {
    Send {Ctrl Up}
  }
  if (Shift键1!=0)
  {
    Send {Shift Up}
  }
  if (Alt键1!=0)
  {
    Send {Alt Up}
  }
}
Sleep 10
Send {space Down}
Send {LButton Down}
CoordMode, Mouse, Screen
MouseMove, 移动画布距离, 0, 0, R
Sleep 10
Send {LButton Up}
Send {space Up}
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

PS到CSP色彩更新:
if (色板位置=1)
{
  gosub 更新色板位置
  鼠标在色轮位置X1:=鼠标在色轮位置X
  鼠标在色轮位置Y1:=鼠标在色轮位置Y
  色板1色相角度:=色相角度
  
  IniWrite, %鼠标在色轮位置X1%, 色轮设置.ini, 设置, 鼠标在色轮位置X1
  IniWrite, %鼠标在色轮位置Y1%, 色轮设置.ini, 设置, 鼠标在色轮位置Y1
  IniWrite, %色板1色相角度%, 色轮设置.ini, 设置, 色板1色相角度
  IniWrite, %取色颜色%, 色轮设置.ini, 设置, 色板1取色颜色
  
  BlockInput, On
  BlockInput, MouseMove
  if (简体中文=1)
  {
    WinActivate, 色轮
  }
  else
  {
    WinActivate, 色環
  }
  后台.点击左键(色轮窗口ID, 鼠标在色轮位置X1, 鼠标在色轮位置Y1)
  gosub 色相偏移
  ; ToolTip %色相角度% %绘制坐标X% %绘制坐标Y%
  BlockInput, MouseMoveOff
  BlockInput, Off
}
else if (色板位置=2)
{
  gosub 更新色板位置
  鼠标在色轮位置X2:=鼠标在色轮位置X
  鼠标在色轮位置Y2:=鼠标在色轮位置Y
  色板2色相角度:=色相角度
  
  IniWrite, %鼠标在色轮位置X2%, 色轮设置.ini, 设置, 鼠标在色轮位置X2
  IniWrite, %鼠标在色轮位置Y2%, 色轮设置.ini, 设置, 鼠标在色轮位置Y2
  IniWrite, %色板2色相角度%, 色轮设置.ini, 设置, 色板2色相角度
  IniWrite, %取色颜色%, 色轮设置.ini, 设置, 色板2取色颜色
  
  BlockInput, On
  BlockInput, MouseMove
  if (简体中文=1)
  {
    WinActivate, 色轮
  }
  else
  {
    WinActivate, 色環
  }
  后台.点击左键(色轮窗口ID, 鼠标在色轮位置X2, 鼠标在色轮位置Y2)
  gosub 色相偏移
  ; ToolTip %色相角度% %绘制坐标X% %绘制坐标Y%
  BlockInput, MouseMoveOff
  BlockInput, Off
}
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
鼠标在色轮位置X:=色轮方块XL边界+Round(s*色轮目标边长)
鼠标在色轮位置Y:=色轮方块YU边界+色轮目标边长-Round(v*色轮目标边长)
return

切换色板:
BlockInput, On
BlockInput, MouseMove
Send {LButton Up} ;结束取色
CoordMode, Mouse, Window
MouseGetPos, 鼠标在色轮位置X, 鼠标在色轮位置Y

if (色板位置=1) ;记录鼠标位置并限制在方框内
{
  鼠标在色轮位置X1:=鼠标在色轮位置X
  鼠标在色轮位置Y1:=鼠标在色轮位置Y
  if (鼠标在色轮位置X1<色轮方块XL边界)
  {
    鼠标在色轮位置X1:=色轮方块XL边界
  }
  else if (鼠标在色轮位置X1>色轮方块XR边界)
  {
    鼠标在色轮位置X1:=色轮方块XR边界
  }
  if (鼠标在色轮位置Y1<色轮方块YU边界)
  {
    鼠标在色轮位置Y1:=色轮方块YU边界
  }
  else if (鼠标在色轮位置Y1>色轮方块YD边界)
  {
    鼠标在色轮位置Y1:=色轮方块YD边界
  }
  IniWrite, %鼠标在色轮位置X1%, 色轮设置.ini, 设置, 鼠标在色轮位置X1
  IniWrite, %鼠标在色轮位置Y1%, 色轮设置.ini, 设置, 鼠标在色轮位置Y1
}
else if (色板位置=2)
{
  鼠标在色轮位置X2:=鼠标在色轮位置X
  鼠标在色轮位置Y2:=鼠标在色轮位置Y
  if (鼠标在色轮位置X1<色轮方块XL边界)
  {
    鼠标在色轮位置X1:=色轮方块XL边界
  }
  else if (鼠标在色轮位置X1>色轮方块XR边界)
  {
    鼠标在色轮位置X1:=色轮方块XR边界
  }
  if (鼠标在色轮位置Y1<色轮方块YU边界)
  {
    鼠标在色轮位置Y1:=色轮方块YU边界
  }
  else if (鼠标在色轮位置Y1>色轮方块YD边界)
  {
    鼠标在色轮位置Y1:=色轮方块YD边界
  }
  IniWrite, %鼠标在色轮位置X2%, 色轮设置.ini, 设置, 鼠标在色轮位置X2
  IniWrite, %鼠标在色轮位置Y2%, 色轮设置.ini, 设置, 鼠标在色轮位置Y2
}

CoordMode, Mouse, Screen
MouseGetPos, 鼠标在屏幕位置X, 鼠标在屏幕位置Y
if (简体中文=1) and (调色盘=0)
{
  WinGetPos, 色轮在屏幕位置X, 色轮在屏幕位置Y, , , 色轮
}
else if (简体中文!=1) and (调色盘=0)
{
  WinGetPos, 色轮在屏幕位置X, 色轮在屏幕位置Y, , , 色環
}
; ToolTip %色轮在屏幕位置X% %色轮在屏幕位置Y%
if (色板位置=1)
{
  色板位置:=2
  取色位置X:=Round(65/1080*屏幕高度)
  后台.点击左键(色轮窗口ID, 取色位置X, 取色位置Y)
  色轮位置X:=Round(鼠标在屏幕位置X-鼠标在色轮位置X2)
  色轮位置Y:=Round(鼠标在屏幕位置Y-鼠标在色轮位置Y2)
  if (简体中文=1) and (调色盘=0)
  {
    WinMove, 色轮, , 色轮位置X, 色轮位置Y, 色轮宽度W, 色轮高度H ;移动色轮窗口位置
  }
  else if (简体中文!=1) and (调色盘=0)
  {
    WinMove, 色環, , 色轮位置X, 色轮位置Y, 色轮宽度W, 色轮高度H ;移动色轮窗口位置
  }
  Send {LButton Down}
}
else
{
  色板位置:=1
  取色位置X:=Round(25/1080*屏幕高度)
  后台.点击左键(色轮窗口ID, 取色位置X, 取色位置Y)
  色轮位置X:=Round(鼠标在屏幕位置X-鼠标在色轮位置X1)
  色轮位置Y:=Round(鼠标在屏幕位置Y-鼠标在色轮位置Y1)
  if (简体中文=1) and (调色盘=0)
  {
    WinMove, 色轮, , 色轮位置X, 色轮位置Y, 色轮宽度W, 色轮高度H ;移动色轮窗口位置
  }
  else if (简体中文!=1) and (调色盘=0)
  {
    WinMove, 色環, , 色轮位置X, 色轮位置Y, 色轮宽度W, 色轮高度H ;移动色轮窗口位置
  }
  Send {LButton Down}
}
BlockInput, Off
BlockInput, MouseMoveOff
loop
{
  if !GetKeyState("w", "P")
  {
    break
  }
}
return

调色模式:
BlockInput, Send
if (呼出调色盘=1)
{
  goto 呼出PS取色
}
else
{
  呼出调色盘:=1
}
Send {LButton Up}
Sleep 10
if (Ctrl键2!=0)
{
  Send {Ctrl Down}
  Sleep 10
}
if (Shift键2!=0)
{
  Send {Shift Down}
  Sleep 10
}
if (Alt键2!=0)
{
  Send {Alt Down}
  Sleep 10
}
Send {%快捷键2% Down} ;打开调色盘
Sleep 50
Send {%快捷键2% Up}
if (Ctrl键2!=0)
{
  Send {Ctrl Up}
}
if (Shift键2!=0)
{
  Send {Shift Up}
}
if (Alt键2!=0)
{
  Send {Alt Up}
}
开始计时:=A_TickCount
if (简体中文=1)
{
  loop ;寻找调色盘
  {
    寻找耗时:=A_TickCount-开始计时
    ; ToolTip 寻找色轮中%寻找耗时%ms
    if !(WinExist("混色")=0) ;""内填窗口名称
    {
      调色盘:=1
      调色盘窗口ID:=WinExist("混色") ;""内填窗口名称
      ; ToolTip 已找到调色盘
      break
    }
    else
    {
      if (寻找耗时>3000)
      {
        调色盘:=0
        BlockInput, Default
        loop 100
        {
          ToolTip 未找到调色盘 请检查呼出调色盘快捷键设置是否正确
          Sleep 30
        }
        ToolTip
        return
      }
      
      Send {LButton Up}
      Sleep 10
      if (Ctrl键2!=0)
      {
        Send {Ctrl Down}
        Sleep 10
      }
      if (Shift键2!=0)
      {
        Send {Shift Down}
        Sleep 10
      }
      if (Alt键2!=0)
      {
        Send {Alt Down}
        Sleep 10
      }
      Send {%快捷键2% Down} ;打开色轮
      Sleep 50
      Send {%快捷键2% Up}
      if (Ctrl键2!=0)
      {
        Send {Ctrl Up}
      }
      if (Shift键2!=0)
      {
        Send {Shift Up}
      }
      if (Alt键2!=0)
      {
        Send {Alt Up}
      }
      Sleep 300
    }
  }
}
else
{
  loop ;寻找调色盘
  {
    寻找耗时:=A_TickCount-开始计时
    ; ToolTip 寻找色轮中%寻找耗时%ms
    if !(WinExist("色彩混合")=0) ;""内填窗口名称
    {
      调色盘:=1
      调色盘窗口ID:=WinExist("色彩混合") ;""内填窗口名称
      ; ToolTip 已找到调色盘
      break
    }
    else
    {
      if (寻找耗时>3000)
      {
        调色盘:=0
        BlockInput, Default
        loop 100
        {
          ToolTip 未找到调色盘 请检查呼出调色盘快捷键设置是否正确
          Sleep 30
        }
        ToolTip
        return
      }
      
      Send {LButton Up}
      Sleep 10
      if (Ctrl键2!=0)
      {
        Send {Ctrl Down}
        Sleep 10
      }
      if (Shift键2!=0)
      {
        Send {Shift Down}
        Sleep 10
      }
      if (Alt键2!=0)
      {
        Send {Alt Down}
        Sleep 10
      }
      Send {%快捷键2% Down} ;打开调色盘
      Sleep 50
      Send {%快捷键2% Up}
      if (Ctrl键2!=0)
      {
        Send {Ctrl Up}
      }
      if (Shift键2!=0)
      {
        Send {Shift Up}
      }
      if (Alt键2!=0)
      {
        Send {Alt Up}
      }
      Sleep 300
    }
  }
}
if (简体中文=1)
{
  WinMove, 混色, , 色轮位置X+色轮宽度W, 色轮位置Y, 色轮宽度W, 色轮高度H ;移动调色盘窗口位置
}
else
{
  WinMove, 色彩混合, , 色轮位置X+色轮宽度W, 色轮位置Y, 色轮宽度W, 色轮高度H ;移动调色盘窗口位置
}

呼出PS取色:
if (WinExist("ahk_class PSFloatC")!=0x0) ;""内填窗口名称
{
  WinActivate, ahk_class PSFloatC
  Send {Enter Down}
  Sleep 50
  Send {Enter Up}
  Sleep 200
}

if (呼出PS取色=1)
{
  Sleep 100
  if (色轮位置Y>屏幕高度-色轮高度H*2)
  {
    色轮位置Y:=屏幕高度-色轮高度H*2
  }
  if (简体中文=1)
  {
    WinMove, 色轮, , 色轮位置X, 色轮位置Y, 色轮宽度W, 色轮高度H ;移动色轮窗口位置
    WinMove, 混色, , 色轮位置X+色轮宽度W, 色轮位置Y, 色轮宽度W, 色轮高度H ;移动调色盘窗口位置
  }
  else
  {
    WinMove, 色環, , 色轮位置X, 色轮位置Y, 色轮宽度W, 色轮高度H ;移动色轮窗口位置
    WinMove, 色彩混合, , 色轮位置X+色轮宽度W, 色轮位置Y, 色轮宽度W, 色轮高度H ;移动调色盘窗口位置
  }
  ; SetWinDelay, 300
  WinActivate, ahk_class Photoshop
  WinRestore, ahk_class Photoshop
  WinMove, ahk_class Photoshop, , 色轮位置X, 色轮位置Y+色轮高度H, 色轮宽度W*2, 色轮高度H ;移动PS窗口
  WinSet, AlwaysOnTop, On, ahk_class Photoshop
  
  开始计时:=A_TickCount
  loop ;寻找LAB窗口
  {
    寻找耗时:=A_TickCount-开始计时
    ; ToolTip 寻找LAB窗口中%寻找耗时%ms
    if (WinExist("ahk_class OWL.Dock")!=0x0) ;""内填窗口名称
    {
      ; ToolTip 已找到LAB窗口
      开始计时:=A_TickCount
      loop
      {
        移动耗时:=A_TickCount-开始计时
        WinGetPos, LAB窗口X, LAB窗口Y, LAB窗口W, LAB窗口H, ahk_class OWL.Dock
        LAB窗口目标位置Y:=色轮位置Y+色轮高度H
        LAB窗口目标宽度W:=色轮宽度W*2
        ; ToolTip, 移动LAB窗口中%移动耗时%ms`nLAB窗口X%LAB窗口X% 色轮位置X%色轮位置X%`nLAB窗口Y%LAB窗口Y% 色轮位置Y%LAB窗口目标位置Y%`nLAB窗口W%LAB窗口W% 色轮宽度W%LAB窗口目标宽度W%`nLAB窗口H%LAB窗口H% 色轮高度H%色轮高度H%
        if (LAB窗口X!=色轮位置X) or (LAB窗口Y!=LAB窗口目标位置Y)
        {
          CoordMode, Mouse, Screen
          WinActivate, ahk_class OWL.Dock
          BlockInput, On
          MouseMove, LAB窗口X+Round(5/1080*屏幕高度), LAB窗口Y+Round(5/1080*屏幕高度)
          Send {LButton Down}
          MouseMove, 色轮位置X+Round(5/1080*屏幕高度), LAB窗口目标位置Y+Round(5/1080*屏幕高度), 0
          Sleep 10
          Send {LButton Up}
          Sleep 50
        }
        else if (LAB窗口W!=LAB窗口目标宽度W) or (LAB窗口H!=色轮高度H)
        {
          CoordMode, Mouse, Screen
          WinActivate, ahk_class OWL.Dock
          BlockInput, On
          MouseMove, LAB窗口X+LAB窗口W-Round(5/1080*屏幕高度), LAB窗口Y+LAB窗口H-Round(5/1080*屏幕高度), 
          Send {LButton Down}
          MouseMove, LAB窗口目标宽度W-LAB窗口W, 色轮高度H-LAB窗口H, 0, R
          Sleep 10
          Send {LButton Up}
          Sleep 50
        }
        else if (LAB窗口X=色轮位置X) and (LAB窗口Y=LAB窗口目标位置Y) and (LAB窗口W=LAB窗口目标宽度W) and (LAB窗口H=色轮高度H)
        {
          BlockInput, Off
          break, 2
        }
        else if (移动耗时>3000)
        {
          BlockInput, Off
          break, 2
        }
      }
    }
    else if (WinExist("ahk_class OWL.Dock")=0x0)
    {
      if (寻找耗时>500)
      {
        loop 100
        {
          ToolTip 未找到LAB窗口 请检查PS是否已经打开
          Sleep 30
        }
        ToolTip
        return
      }
      Send {F6}
      Sleep 50
      WinActivate, ahk_class OWL.Dock
    }
  }
  
  开始计时:=A_TickCount
  if (记忆模式=0) ;CSP颜色导入PS
  {
    BlockInput, On
    CoordMode, Mouse, Screen
    ; MouseGetPos, 鼠标在屏幕位置X, 鼠标在屏幕位置Y
    PS取色颜色:=StrReplace(取色颜色,"0x")
    Clipboard:=PS取色颜色
    Send {n}
    Sleep 50
    loop ;寻找拾色器窗口
    {
      寻找耗时:=A_TickCount-开始计时
      ; ToolTip 寻找拾色器窗口中%寻找耗时%ms
      if (WinExist("ahk_class PSFloatC")!=0x0) ;""内填窗口名称
      {
        ; ToolTip 已找到拾色器窗口%寻找耗时%ms 取色颜色%取色颜色%
        WinActivate, ahk_class PSFloatC
        WinGetPos, 拾色器窗口X, 拾色器窗口Y
        break
      }
      else if (WinExist("ahk_class PSFloatC")=0x0)
      {
        if (寻找耗时>500)
        {
          loop 100
          {
            ToolTip 未找到拾色器窗口 请检查是否已经设置快捷键为N
            Sleep 30
          }
          ToolTip
          return
        }
        
        Send {n}
        Sleep 50
        WinActivate, ahk_class PSFloatC
      }
    }
    if (拾色器窗口X!=色轮位置X+Round(40/1080*屏幕高度)) or (拾色器窗口Y!=色轮位置Y+色轮高度H)
    {
      MouseMove, 拾色器窗口X+Round(15/1080*屏幕高度), 拾色器窗口Y+Round(5/1080*屏幕高度), 0
      Send {LButton Down}
      MouseMove, 色轮位置X+Round(55/1080*屏幕高度), 色轮位置Y+色轮高度H+Round(5/1080*屏幕高度), 0
      Sleep 10
      Send {LButton Up}
    }
    Sleep 10
    Send {Ctrl Down}
    Sleep 50
    Send {v Down}
    Sleep 50
    Send {v Up}
    Send {Ctrl Up}
    Sleep 50
    Send {Enter}
    ; MouseMove, 鼠标在屏幕位置X, 鼠标在屏幕位置Y
    BlockInput Off
    Sleep 100
  }
}
return

#IfWinActive ahk_exe CLIPStudioPaint.exe
$s::
if (色轮=0)
{
  Send {s Down}
  KeyWait, s
  Send {s Up}
  return
}
return

$e::
if (色轮=0)
{
  Send {e Down}
  KeyWait, s
  Send {e Up}
  return
}
return

$w::
if (色轮=0)
{
  loop
  {
    Send {w Down}
    Sleep 50
    Send {w Up}
    
    if (A_Index=1)
    {
      Sleep 200
    }
    
    if !GetKeyState("w", "P")
    {
      break
    }
    else if GetKeyState("w", "P")
    {
      Sleep 50
    }
  }
}
return

$q::
if (色轮=0)
{
  loop
  {
    Send {q Down}
    Sleep 50
    Send {q Up}
    
    if (A_Index=1)
    {
      Sleep 200
    }
    
    if !GetKeyState("q", "P")
    {
      break
    }
    else if GetKeyState("q", "P")
    {
      Sleep 50
    }
  }
}
return

$a::
if (色轮=0)
{
  loop
  {
    Send {a Down}
    Sleep 50
    Send {a Up}
    
    if (A_Index=1)
    {
      Sleep 200
    }
    
    if !GetKeyState("a", "P")
    {
      break
    }
    else if GetKeyState("a", "P")
    {
      Sleep 50
    }
  }
}
return

$d::
if (色轮=0)
{
  loop
  {
    Send {d Down}
    Sleep 50
    Send {d Up}
    
    if (A_Index=1)
    {
      Sleep 200
    }
    
    if !GetKeyState("d", "P")
    {
      break
    }
    else if GetKeyState("d", "P")
    {
      Sleep 50
    }
  }
}
return

$1::
if (色轮=0)
{
  loop
  {
    Send {1 Down}
    Sleep 50
    Send {1 Up}
    
    if (A_Index=1)
    {
      loop 20
      {
        if !GetKeyState("1", "P")
        {
          break
        }
        Sleep 20
      }
    }
    
    if !GetKeyState("1", "P")
    {
      break
    }
    else if GetKeyState("1", "P")
    {
      Sleep 50
    }
  }
}
return

$2::
if (色轮=0)
{
  loop
  {
    Send {2 Down}
    Sleep 50
    Send {2 Up}
    
    if (A_Index=1)
    {
      loop 20
      {
        if !GetKeyState("2", "P")
        {
          break
        }
        Sleep 20
      }
    }
    
    if !GetKeyState("2", "P")
    {
      break
    }
    else if GetKeyState("2", "P")
    {
      Sleep 50
    }
  }
}
return

$3::
if (色轮=0)
{
  loop
  {
    Send {3 Down}
    Sleep 50
    Send {3 Up}
    
    if (A_Index=1)
    {
      loop 20
      {
        if !GetKeyState("3", "P")
        {
          break
        }
        Sleep 20
      }
    }
    
    if !GetKeyState("3", "P")
    {
      break
    }
    else if GetKeyState("3", "P")
    {
      Sleep 50
    }
  }
}
return

$4::
if (色轮=0)
{
  loop
  {
    Send {4 Down}
    Sleep 50
    Send {4 Up}
    
    if (A_Index=1)
    {
      loop 20
      {
        if !GetKeyState("4", "P")
        {
          break
        }
        Sleep 20
      }
    }
    
    if !GetKeyState("4", "P")
    {
      break
    }
    else if GetKeyState("4", "P")
    {
      Sleep 50
    }
  }
}
return

$`::
if (色轮=0)
{
  Send {`` Down}
  KeyWait, ``
  Send {`` Up}
  return
}
return

Space::
send {Space Down}
KeyWait Space
send {Space Up}
if (space_presses > 0) ;记录键击.
{
  space_presses += 1
  return
}
space_presses := 1
SetTimer, KeySpace, -400 ; 在 400 毫秒内等待更多的键击.
return

KeySpace:
if (space_presses >= 2) ; 此键按下了两次.
{
  Send {LWin Down}
  Send {Ctrl Down}
  Send {c}
  Send {LWin Up}
  Send {Ctrl Up}
}
space_presses := 0
return

KeyLButton:
if (LButton_presses >= 2) ; 此键按下了两次.
{
  ; ToolTip Enter
  Send {Enter Down}
  Sleep 50
  Send {Enter Up}
  Sleep 100
  gosub PS到CSP色彩更新
}
LButton_presses := 0
return

~^Enter::
自动隐藏:=A_TickCount
KeyWait, Enter
if (A_TickCount-自动隐藏<=500)
{
  if (软件Class名=0)
  {
    MouseGetPos, , , WinID
    WinGetClass, 软件Class名, ahk_id %WinID%
    IniWrite, %软件Class名%, 色轮设置.ini, 设置, 软件Class名
    if (软件Class名!=0)
    {
      SetTimer, 自动隐藏菜单, 200
    }
    loop 50
    {
      ToolTip, 已打开自动隐藏功能 %软件Class名%
      Sleep 30
    }
    ToolTip
  }
}
else
{
  软件Class名:=0
  IniWrite, %软件Class名%, 色轮设置.ini, 设置, 软件Class名
  SetTimer, 自动隐藏菜单, Delete
  loop 50
  {
    ToolTip, 已关闭自动隐藏功能
    Sleep 30
  }
  ToolTip
}
return

滚轮上:
if (色轮=0) and (色相慢左旋!=1)
{
  Send {WheelUp}
  return
}
色相慢左旋:=1
return

色相慢左旋:
if GetKeyState("LButton", "P")
{
  goto 色相快左旋
}
BlockInput MouseMove
Send {LButton Up}
CoordMode, Mouse, Screen
MouseGetPos, 鼠标在屏幕位置记忆X, 鼠标在屏幕位置记忆Y
if (简体中文=1)
{
  WinGetPos, 色轮在屏幕位置X, 色轮在屏幕位置Y, , , 色轮
}
else
{
  WinGetPos, 色轮在屏幕位置X, 色轮在屏幕位置Y, , , 色環
}
CoordMode, Mouse, Screen
loop
{
  if (色板位置=1)
  {
    色板1色相角度:=色板1色相角度-0.00515
    色相角度:=色板1色相角度
    if (色板1色相角度<0)
    {
      色板1色相角度:=6.283-0.00515
      色相角度:=6.283-0.00515
    }
    IniWrite, %色板1色相角度%, 色轮设置.ini, 设置, 色板1色相角度
  }
  else if (色板位置=2)
  {
    色板2色相角度:=色板2色相角度-0.00515
    色相角度:=色板2色相角度
    if (色板2色相角度<0)
    {
      色板2色相角度:=6.283-0.00515
      色相角度:=6.283-0.00515
    }
    IniWrite, %色板2色相角度%, 色轮设置.ini, 设置, 色板2色相角度
  }
  gosub 色相偏移
  
  if !GetKeyState("q", "P")
  {
    break
  }
  else
  {
    if (A_Index=1)
    {
      loop 10
      {
        if !GetKeyState("q", "P")
        {
          break, 2
        }
        Sleep 25
      }
    }
    Sleep 80
  }
}
if (调色盘!=1)
{
  Send {LButton Down}
}
BlockInput MouseMoveOff
色相慢左旋:=0
return

滚轮下:
if (色轮=0) and (色相慢右旋!=1)
{
  Send {WheelDown}
  return
}
色相慢右旋:=1
return

色相慢右旋:
if GetKeyState("LButton", "P")
{
  goto 色相快右旋
}
BlockInput MouseMove
Send {LButton Up}
CoordMode, Mouse, Screen
MouseGetPos, 鼠标在屏幕位置记忆X, 鼠标在屏幕位置记忆Y
if (简体中文=1)
{
  WinGetPos, 色轮在屏幕位置X, 色轮在屏幕位置Y, , , 色轮
}
else
{
  WinGetPos, 色轮在屏幕位置X, 色轮在屏幕位置Y, , , 色環
}
CoordMode, Mouse, Screen
loop
{
  if (色板位置=1)
  {
    色板1色相角度:=色板1色相角度+0.00515
    色相角度:=色板1色相角度
    if (色板1色相角度>=6.283)
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
    if (色板2色相角度>=6.283)
    {
      色板2色相角度:=0
      色相角度:=0
    }
    IniWrite, %色板2色相角度%, 色轮设置.ini, 设置, 色板2色相角度
  }
  gosub 色相偏移
  
  if !GetKeyState("e", "P")
  {
    break
  }
  else
  {
    if (A_Index=1)
    {
      loop 10
      {
        if !GetKeyState("e", "P")
        {
          break, 2
        }
        Sleep 25
      }
    }
    Sleep 80
  }
}
if (调色盘!=1)
{
  Send {LButton Down}
}
BlockInput MouseMoveOff
色相慢右旋:=0
return

色相快左旋:
BlockInput MouseMove
Send {LButton Up}
CoordMode, Mouse, Screen
MouseGetPos, 鼠标在屏幕位置记忆X, 鼠标在屏幕位置记忆Y
if (简体中文=1)
{
  WinGetPos, 色轮在屏幕位置X, 色轮在屏幕位置Y, , , 色轮
}
else
{
  WinGetPos, 色轮在屏幕位置X, 色轮在屏幕位置Y, , , 色環
}
CoordMode, Mouse, Screen
loop
{
  if (色板位置=1)
  {
    色板1色相角度:=色板1色相角度-0.103
    色相角度:=色板1色相角度
    if (色板1色相角度<0)
    {
      色板1色相角度:=6.283-0.103
      色相角度:=6.283-0.103
    }
    IniWrite, %色板1色相角度%, 色轮设置.ini, 设置, 色板1色相角度
  }
  else if (色板位置=2)
  {
    色板2色相角度:=色板2色相角度-0.103
    色相角度:=色板2色相角度
    if (色板2色相角度<0)
    {
      色板2色相角度:=6.283-0.103
      色相角度:=6.283-0.103
    }
    IniWrite, %色板2色相角度%, 色轮设置.ini, 设置, 色板2色相角度
  }
  gosub 色相偏移
  
  if !GetKeyState("a", "P")
  {
    break
  }
  else
  {
    if (A_Index=1)
    {
      loop 10
      {
        if !GetKeyState("a", "P")
        {
          break, 2
        }
        Sleep 25
      }
    }
    Sleep 80
  }
}
if (调色盘!=1)
{
  Send {LButton Down}
}
BlockInput MouseMoveOff
色相慢左旋:=0
return

色相快右旋:
BlockInput MouseMove
Send {LButton Up}
CoordMode, Mouse, Screen
MouseGetPos, 鼠标在屏幕位置记忆X, 鼠标在屏幕位置记忆Y
if (简体中文=1)
{
  WinGetPos, 色轮在屏幕位置X, 色轮在屏幕位置Y, , , 色轮
}
else
{
  WinGetPos, 色轮在屏幕位置X, 色轮在屏幕位置Y, , , 色環
}
CoordMode, Mouse, Screen
loop
{
  if (色板位置=1)
  {
    色板1色相角度:=色板1色相角度+0.103
    色相角度:=色板1色相角度
    if (色板1色相角度>=6.283)
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
    if (色板2色相角度>=6.283)
    {
      色板2色相角度:=0
      色相角度:=0
    }
    IniWrite, %色板2色相角度%, 色轮设置.ini, 设置, 色板2色相角度
  }
  gosub 色相偏移
  
  if !GetKeyState("d", "P")
  {
    break
  }
  else
  {
    if (A_Index=1)
    {
      loop 10
      {
        if !GetKeyState("d", "P")
        {
          break, 2
        }
        Sleep 25
      }
    }
    Sleep 80
  }
}
if (调色盘!=1)
{
  Send {LButton Down}
}
BlockInput MouseMoveOff
色相慢右旋:=0
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
}
else if (色相角度>=1.57075) and (色相角度<3.1415)
{
  绘制坐标X:=Round(圆心坐标X+计算坐标X)
  绘制坐标Y:=Round(圆心坐标Y+计算坐标Y)
}
else if (色相角度>=3.1415) and (色相角度<4.71225)
{
  绘制坐标X:=Round(圆心坐标X-计算坐标X)
  绘制坐标Y:=Round(圆心坐标Y+计算坐标Y)
}
else if (色相角度>=4.71225) and (色相角度<6.283)
{
  绘制坐标X:=Round(圆心坐标X-计算坐标X)
  绘制坐标Y:=Round(圆心坐标Y-计算坐标Y)
}
后台.点击左键(色轮窗口ID, 绘制坐标X, 绘制坐标Y)
return

清除调色盘:
清除调色盘:=Round(255/1080*屏幕高度)
后台.点击左键(调色盘窗口ID, 255, 调色盘按键Y)
; CoordMode, Mouse, Screen
; MouseGetPos, 鼠标在调色盘位置X, 鼠标在调色盘位置Y
; BlockInput, On
; BlockInput, MouseMove
; MouseMove, 色轮位置X+色轮宽度W+255, 色轮位置Y+480, 0
; Send {LButton}
; MouseMove, 鼠标在调色盘位置X, 鼠标在调色盘位置Y, 0
; BlockInput, Off
; BlockInput, MouseMoveOff
return

撤回还原调色盘:
撤回计时:=A_TickCount
loop
{
  记录时间:=A_TickCount-撤回计时
  if !GetKeyState("1", "P")
  {
    break
  }
  else if (记录时间>350) ;还原
  {
    调色盘还原:=Round(295/1080*屏幕高度)
    后台.点击左键(调色盘窗口ID, 调色盘还原, 调色盘按键Y)
    ; CoordMode, Mouse, Screen
    ; MouseGetPos, 鼠标在调色盘位置X, 鼠标在调色盘位置Y
    ; BlockInput, On
    ; BlockInput, MouseMove
    ; MouseMove, 色轮位置X+色轮宽度W+295, 色轮位置Y+480, 0
    ; Send {LButton}
    ; MouseMove, 鼠标在调色盘位置X, 鼠标在调色盘位置Y, 0
    ; BlockInput, Off
    ; BlockInput, MouseMoveOff
    Sleep 200
  }
}
if (记录时间<=350) ;撤回
{
  调色盘撤回:=Round(275/1080*屏幕高度)
  后台.点击左键(调色盘窗口ID, 调色盘撤回, 调色盘按键Y)
  ; CoordMode, Mouse, Screen
  ; MouseGetPos, 鼠标在调色盘位置X, 鼠标在调色盘位置Y
  ; BlockInput, On
  ; BlockInput, MouseMove
  ; MouseMove, 色轮位置X+色轮宽度W+275, 色轮位置Y+480, 0
  ; Send {LButton}
  ; MouseMove, 鼠标在调色盘位置X, 鼠标在调色盘位置Y, 0
  ; BlockInput, Off
  ; BlockInput, MouseMoveOff
}
return

调色盘笔刷变小:
旧调色盘笔刷大小:=调色盘笔刷大小
调色盘笔刷大小:=调色盘笔刷大小-1
if (调色盘笔刷大小<0)
{
  调色盘笔刷大小:=0
}
if (调色盘笔刷大小!=旧调色盘笔刷大小)
{
  调色盘笔刷变小:=Round(323/1080*屏幕高度)+Round(20/1080*屏幕高度)*调色盘笔刷大小
  后台.点击左键(调色盘窗口ID, 调色盘笔刷变小, 调色盘按键Y)
  ; CoordMode, Mouse, Screen
  ; MouseGetPos, 鼠标在调色盘位置X, 鼠标在调色盘位置Y
  ; BlockInput, On
  ; BlockInput, MouseMove
  ; MouseMove, 色轮位置X+色轮宽度W+323+20*调色盘笔刷大小, 色轮位置Y+480, 0
  ; Send {LButton}
  ; MouseMove, 鼠标在调色盘位置X, 鼠标在调色盘位置Y, 0
  ; BlockInput, Off
  ; BlockInput, MouseMoveOff
}
KeyWait, 2
return

调色盘笔刷变大:
旧调色盘笔刷大小:=调色盘笔刷大小
调色盘笔刷大小:=调色盘笔刷大小+1
if (调色盘笔刷大小>2)
{
  调色盘笔刷大小:=2
}
if (调色盘笔刷大小!=旧调色盘笔刷大小)
{
  调色盘笔刷变大:=Round(323/1080*屏幕高度)+Round(20/1080*屏幕高度)*调色盘笔刷大小
  后台.点击左键(调色盘窗口ID, 调色盘笔刷变大, 调色盘按键Y)
  ; CoordMode, Mouse, Screen
  ; MouseGetPos, 鼠标在调色盘位置X, 鼠标在调色盘位置Y
  ; BlockInput, On
  ; BlockInput, MouseMove
  ; MouseMove, 色轮位置X+色轮宽度W+323+20*调色盘笔刷大小, 色轮位置Y+480, 0
  ; Send {LButton}
  ; MouseMove, 鼠标在调色盘位置X, 鼠标在调色盘位置Y, 0
  ; BlockInput, Off
  ; BlockInput, MouseMoveOff
}
KeyWait, 3
return

切换调色盘笔刷样式:
调色盘笔刷样式:=调色盘笔刷样式+1
if (调色盘笔刷样式>2)
{
  调色盘笔刷样式:=0
}
切换调色盘笔刷样式:=Round(390/1080*屏幕高度)+Round(20/1080*屏幕高度)*调色盘笔刷样式
后台.点击左键(调色盘窗口ID, 切换调色盘笔刷样式, 调色盘按键Y)
; CoordMode, Mouse, Screen
; MouseGetPos, 鼠标在调色盘位置X, 鼠标在调色盘位置Y
; BlockInput, On
; BlockInput, MouseMove
; MouseMove, 色轮位置X+色轮宽度W+390+20*调色盘笔刷样式, 色轮位置Y+480, 0
; Send {LButton}
; MouseMove, 鼠标在调色盘位置X, 鼠标在调色盘位置Y, 0
; BlockInput, Off
; BlockInput, MouseMoveOff
KeyWait, 4
return

!a::
if (色轮=0)
{
  Send {Ctrl Down}
  Send {Shift Down}
  Sleep 50
  Send {Tab Down}
  Sleep 50
  Send {Tab Up}
  Send {Shift Up}
  Send {Ctrl Up}
  KeyWait, a
}
else
{
  Send {Alt Down}
  Sleep 50
  Send {a Down}
  Sleep 50
  Send {a Up}
  Send {Alt Up}
  KeyWait, a
}
return

!d::
if (色轮=0)
{
  Send {Ctrl Down}
  Sleep 50
  Send {Tab Down}
  Sleep 50
  Send {Tab Up}
  Send {Ctrl Up}
  KeyWait, d
}
else
{
  Send {Alt Down}
  Sleep 50
  Send {d Down}
  Sleep 50
  Send {d Up}
  Send {Alt Up}
  KeyWait, d
}
return