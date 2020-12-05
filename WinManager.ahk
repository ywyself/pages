; 窗口管理，最大化/最小化/移动/关闭窗口
    
<#q::	; Win(L) + Q	; 当前活动窗口 - 关闭
	;winId := WinExist("A")	; 获取活动窗口的 ID/HWND
	;WinClose, ahk_id %winId%, , , ,
	Send {Blind}{RAlt up}{RAlt down}{F4}{RAlt up}
	return

<#z::	; Win(L) + Z	; 当前活动窗口 - 最小化
	winId := WinExist("A")
	PostMessage, 0x112, 0xF020,,, ahk_id %winId%, ; 0x112 = WM_SYSCOMMAND, 0xF020 = SC_MINIMIZE
	return

<#x::	; Win(L) + X	; 当前活动窗口 - 最大化/还原
	winId := WinExist("A")
	WinGet, mixMax, MinMax, ahk_id %winId%  ; 获取窗口的最小化/最大化状态
	if (mixMax = 1 )	; 窗口处于最大化状态
	{
		; 还原
		PostMessage, 0x112, 0xF120,,, ahk_id %winId%, ; 0x112 = WM_SYSCOMMAND, 0xF120 = SC_RESTORE
	}
	else if (mixMax = 0)	; 窗口既不处于最小化状态也不处于最大化状态
	{
		; 最大化
		PostMessage, 0x112, 0xF030,,, ahk_id %winId%, ; 0x112 = WM_SYSCOMMAND,0xF030 = SC_MAXIMIZE
	}
	else if (mixMax = -1)	; 窗口处于最小化状态
	{
		; 还原
		PostMessage, 0x112, 0xF120,,, ahk_id %winId%, ; 0x112 = WM_SYSCOMMAND, 0xF120 = SC_RESTORE
	}
	return

<#RButton::	; Win(L) + 鼠标右键	; 最小化
	winId := WinExist("A")
	PostMessage, 0x112, 0xF020,,, ahk_id %winId%, ; 0x112 = WM_SYSCOMMAND, 0xF020 = SC_MINIMIZE
	return

<#MButton::	; Win(L) + 鼠标中键	; （取消）置顶窗口
	winId := WinExist("A")
	WinSet, AlwaysOnTop, Toggle, ahk_id %winId%, , ,
	return

$<#$WheelUp::		; Win(L) + 向上滚轮	; 向左切换虚拟桌面
	Send ^#{Left}
	return

$<#$WheelDown::	; Win(L) + 向下滚轮	; 向右切换虚拟桌面
	Send ^#{Right}
	return

<#LButton::	; Win(L) + 鼠标左键	; 移动窗口
	; 设置坐标模式, 相对于活动窗口还是屏幕
	CoordMode, Mouse, Screen
	; 获取鼠标光标的当前位置以及鼠标当前悬停的窗口和控件
	MouseGetPos, originalMouseX, originalMouseY, winId
	; 获取指定窗口的位置和大小.
	WinGetPos, winX, winY, winW, winH, ahk_id %winId%, ,
	; 获取窗口的最小化/最大化状态
	WinGet, winState, MinMax, ahk_id %winId%, , ,
	if (winState = -1)	; 窗口处于最小化状态
	{
		return
	}
	else if (winState = 1 )	; 窗口处于最大化状态
	{
		; 还原
		PostMessage, 0x112, 0xF120,,, ahk_id %winId%, ; 0x112 = WM_SYSCOMMAND, 0xF120 = SC_RESTORE
		return
	}
	SysGet, monitorWorkArea, MonitorWorkArea, %A_Index%	; 获取屏幕工作区大小
	screenTop := MonitorWorkAreaTop			;
	screenLeft := MonitorWorkAreaLeft		;
	screenRight := MonitorWorkAreaRight		;
	screenBottom := MonitorWorkAreaBottom	;
	SetTimer, MoveWin, 10	; 设置定时器

	MoveWin:	; 移动窗口
		key1State := GetKeyState("LWin" , "P") = 1		; 检查左LWin键 状态
		key2State := GetKeyState("LButton", "P") = 1		; 检查鼠标左键 状态
		if (!key1State || !key2State)
		{
			SetTimer, MoveWin, off
			return
		}
		CoordMode, Mouse, Screen
		MouseGetPos, mouseX, mouseY
		WinGetPos, winX, winY, winW, winH, ahk_id %winId%, ,
		SetWinDelay, -1	; Makes the below move faster/smoother.
		newWinX := winX + mouseX - originalMouseX
		newWinY := winY + mouseY - originalMouseY
		; 控制贴边
		xOffsetWinAndScreen := 0
		yOffsetWinAndScreen := 0
		if (newWinX < screenLeft + 10)
		{
			xOffsetWinAndScreen := -newWinX
		}
		else if (newWinX + winW > screenRight - 10)
		{
			xOffsetWinAndScreen := screenRight - winW - newWinX
		}
		if (newWinY < screenTop + 10)
		{
			yOffsetWinAndScreen := -newWinY
		}
		else if (newWinY + winH > screenBottom - 10)
		{
			yOffsetWinAndScreen := screenBottom - winH - newWinY
		}
		WinMove, ahk_id %winId%,, newWinX + xOffsetWinAndScreen , newWinY + yOffsetWinAndScreen
		; 初始化鼠标原始位置
		originalMouseX := mouseX
		originalMouseY := mouseY
		return
