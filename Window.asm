include windows.inc
include user32.inc
include kernel32.inc
includelib user32.lib
includelib kernel32.lib


MB_OK equ 0


.code
start:
	invoke GetModuleHandle, 0
	mov hInstance, eax
	invoke GetCommandLine
	invoke WinMain, hInstance, 0, eax, SW_SHOWDEFAULT
	invoke ExitProcess, eax


WinMain proc hInst:HINSTANCE, hPrevInst:HINSTANCE, CmdLine:LPSTR, CmdShow:DWORD
	invoke CreateWindowEx, 0, wndClass, wndTitle, WS_OVERLAPPEDWINDOW, CW_USEDEFAULT, CW_USEDEFAULT, 400, 300, NULL, NULL hInst, NULL
	mov hwnd, eax

	test hwnd, hwnd
	jz @F
	invoke ShowWindow, hwnd, CmdShow
	invoke UpdateWindow, hwnd

	.while TRUE
		invoke GetMessage, addr msg, NULL, 0, 0
		.break .if (!eax)
		invoke TranslateMessage, addr msg
		invoke DispatchMessage, addr msg
	.endw
	mov eax, msg.wParam
	ret

WinMain endp

WndProc proc hWnd:HWND, uMsg:UINT, wParam:WPARAM, lParam:LPARAM
	.if uMsg == WM_DESTROY
		invoke PostQuitMessage, 0
	.elseif uMsg == WM_PAINT
		invoke PaintWindow
	.else
		invoke DefWindowProc, hWnd, uMsg, wParam, lParam
		ret
	.endif
	xor eax, eax
	ret

WndProc endp

PaintWindow proc
	LOCAL hdc:HDC
	LOCAL ps:PAINTSTRUCT

	invoke BeginPaint, hwnd, addr ps
	mov hdc, eax
	invoke TextOut, hdc, 10, 10, addr msgText, msgTextLen
	invoke EndPaint, hwnd, addr ps
	ret

PaintWindow endp

.data
hInstance HINSTANCE ?
hwnd HWND ?
msg MSG <>
wndClass db "SimpleWinClass", 0
wndTitle db "Simple Window", 0
msgText db "Hello, World!", 0
msgTextLen equ $ - offset msgText

start:
	invoke WinMain, hInstance, NULL, NULL, SW_SHOWNORMAL

end start