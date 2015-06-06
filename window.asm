
;$ nasm -f win32 -g FILE_NAME.asm
;$ ld -e _start FILE_NAME.obj -lkernel32 -luser32 -lgdi32  -o EXECUTABLE_NAME.exe
;
%include "WindowProcedure.asm";order is important here
%include "PaintWindow.asm"


global _start
global HWND ;probably unnecessary:using %include directives


extern _ExitProcess@4
extern _CreateWindowExA@48
extern _GetLastError@0
extern _SetLastErrorEx@8
extern _GetModuleHandleA@4
extern _RegisterClassExA@4

extern _GetMessageA@16
extern _TranslateMessage@4
extern _DispatchMessageA@4
extern _BeginPaint@8
extern _EndPaint@8
extern _FillRect@12
extern _GetStockObject@4
extern _CreateSolidBrush@4



section .data
        ApplicationName db "test", 0
        ClassName       db "class", 0
        Text            db "Hello world"


section .bss
        HINSTANCE resd 1
        CMDLN resd 1
        WNDCLASSEX resb 48
        MSG resb 28
        HWND resb 4
        ;PAINT_STRUCT resb 64
        ;HDC resb 4
 
 
section .text

_start:
        

        push dword 0
        call _GetModuleHandleA@4
        mov dword[HINSTANCE],eax

        mov ecx,WNDCLASSEX
        mov dword[ecx+00],48
        mov dword[ecx+04],3
        mov dword[ecx+08], mWindowProcedure
        mov dword[ecx+12],0
        mov dword[ecx+16],0
        mov eax,dword[HINSTANCE]
        mov dword[ecx+20],eax
        ;????????????????????????
        ;????????????????????????
        mov dword[ecx+32],6
        mov dword[ecx+36],0
        mov dword[ecx+40],ClassName

        push WNDCLASSEX
        call _RegisterClassExA@4

        cmp eax,0
        je Exit

        push dword 0
        push dword [HINSTANCE]
        push dword 0
        push dword 0

        push dword 400              ;; 400 px H
        push dword 600              ;; 600 px W 
        push dword 0x80000000       ;; CW_USEDEFAULT 
        push dword 0x80000000       ;; CW_USEDEFAULT 
        push dword 0x00 | 0xC00000 | 0x80000 | 0x40000 | 0x20000 | 0x10000
        push dword ApplicationName 
        push dword ClassName
        push dword 0
        call _CreateWindowExA@48
        ;call _GetLastError@0
        mov [HWND],eax
        cmp eax,0
        jne MSGLoop

        Exit:
        push    dword 0
        call    _ExitProcess@4
        ret



MSGLoop:
        push dword 0
        push dword 0
        push dword 0
        push dword MSG
        call _GetMessageA@16
        cmp eax,0
        jle Exit
        push dword MSG
        call _TranslateMessage@4
        push dword MSG
        call _DispatchMessageA@4
        jmp MSGLoop