

extern _BeginPaint@8
extern _EndPaint@8
extern _FillRect@12
extern _CreateSolidBrush@4



section .data


section .bss

PAINT_STRUCT resb 64
HDC resb 4


section .text



mPaintWindow@4:

		push ebp
        mov ebp,esp
        mov eax, [ebp+8]
        
       ; mov eax,0;debug
       ; mov ebx, [eax];debug
        push PAINT_STRUCT
        push dword eax
      
        call _BeginPaint@8
        mov [HDC], eax
        ;Paint Here

        

        push  0x00005500
        call _CreateSolidBrush@4

     
        push dword eax
        push PAINT_STRUCT+8
        push dword [HDC]        
        call _FillRect@12

        
        push PAINT_STRUCT
        push dword [HWND]
        call _EndPaint@8


        leave
        ret 16
