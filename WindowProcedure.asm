extern _PostQuitMessage@4
extern _DefWindowProcA@16
extern _UpdateWindow@4
extern _ShowWindow@8
extern _DestroyWindow@4




section .data


section .bss


section .text

mWindowProcedure: 
        ;mov eax,0
        ;mov [eax],dword 5
        push ebp
        mov ebp,esp
        mov eax,dword[ebp+12]
        cmp eax,2 
        je Quit
        cmp eax,1
        je Create
        cmp eax,15
        je Paint
        cmp eax,16
        je Close

        push dword[ebp+20]
        push dword[ebp+16]
        push dword[ebp+12]
        push dword[ebp+8]
        call _DefWindowProcA@16
        leave
        ret 16


    Quit:
        push dword 0
        call _PostQuitMessage@4
        mov eax,0
        leave
        ret 16

    Create:
        push dword 5
        push dword [ebp+8]
        call _ShowWindow@8        
        push dword [ebp+8]
        call _UpdateWindow@4        
        mov eax,0
        leave
        ret 16 
        
    Close:
        push dword [ebp+8]
        call _DestroyWindow@4
        mov eax,0
        leave
        ret 16 



    Paint:
         ;mov eax,0
         ;mov ebx,[eax];debug tool
        mov eax, [HWND]
        cmp eax, 0
        je .ExitPaint

        push dword [HWND]
       
        call mPaintWindow@4

    .ExitPaint:        
        mov eax,0
        leave
        ret 16 
