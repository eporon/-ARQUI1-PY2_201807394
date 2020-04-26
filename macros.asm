; PRINT ON THE SCREEN
print macro string
    Pushear
    mov ah, 09h             ; PRINT
    mov dx, offset string
    int 21h
    Popear
endm

; GET CHARACTER
getChar macro    
    mov ah, 01h
    int 21h
endm

; CLEAN STRING
Clean macro string, numBytes, char
    local RepeatLoop
    Pushear
    xor si, si
    xor cx, cx
    mov cx, numBytes
    RepeatLoop:
        mov string[si], char
        inc si
    Loop RepeatLoop
    Popear
endm

; GET TEXT UNTIL THE USER WRITE ENTER
getText macro string
    local getCharacter, EndGC, Backspace
    xor si, si
    xor ax, ax
    getCharacter:
        getChar
        cmp al, 0dh
            je EndGC
        cmp al, 08h
            je Backspace
        mov string[si], al
        inc si
        jmp getCharacter
    Backspace:
        mov al, 24h
        dec si
        mov string[si], al
        jmp getCharacter
    EndGC:        
        mov al, 24h
        mov string[si], al
endm

; Move cursor
; The screen in text mode have 25 rows and 80 columns
moveCursor macro row, column
    Pushear
    mov ah, 02h
    mov dh, row
    mov dl, column
    int 10h
    Popear
endm

; CLEAN CONSOLE
ClearConsole macro
    local ClearConsoleRepeat
    Pushear
    mov dx, 50h
    ClearConsoleRepeat:
        print newLine
    Loop ClearConsoleRepeat
    moveCursor 00h, 00h
    Popear
endm

printPixel macro x, y, color
    Pushear

    mov ah, 0ch
    mov al, color
    mov bh, 0h
    mov dx, y
    mov cx, x

    int 10h

    Popear
endm

ConcatText macro string1, string2, numBytes
    local RepeatConcat, EndGC

    xor di, di
    mov cx, numBytes
    RepeatConcat:
        mov al, string2[di]
        cmp al, 24h
            je EndGC
        inc di
        mov string1[si], al
        inc si
    Loop RepeatConcat
    EndGC:
endm

CompareString macro string1, string2
    local ENDGC, RepeatComparison, EQUALS, NOTEQUALS
    push di
    push cx
    
    mov cx, SIZEOF string1    

    RepeatComparison:
        mov al, string1[di]
        mov ah, string2[di]
        cmp al, ah
            jne NOTEQUALS
        inc di
    Loop RepeatComparison
    EQUALS:
        mov al, 01h
        jmp ENDGC
    NOTEQUALS:
        mov al, 00h
        jmp ENDGC
    EndGC:
        pop cx
        pop di
endm

; TESTING THE VALUE THAT IS IN AX
TestingAX macro

    Push ax

    xor di, di
    mov testing[di], ah
    inc di
    mov testing[di], al

    print testing
    Push ax
    getChar
    Pop ax
    Pop ax
endm

; DELAY
Delay macro number
    local D1, D2, EndGC
    
    push si
    push di

    mov si, number
    D1:
        dec si
            jz EndGC
        mov di, number
    D2:
        dec di
            jnz D2
        JMP d1
    EndGC:
        pop di
        pop si
endm

; 1 - 20 : 100 | 21 - 40 : 300 | 41 - 60 : 500 | 61 - 80 : 700 | 81 - 99 : 900
; SOUND
Sound macro hz
    local One, Three, Five, Seven, SoundF

    Push ax
    mov al, 86h
    out 43h, al


    cmp hz, 20
        jbe One
    cmp hz, 40
        jbe Three
    cmp hz, 60
        jbe Five
    cmp hz, 80
        jbe Seven
    mov ax, (1193180 / 900)
    jmp SoundF
    One:
        mov ax, (1193180 / 100)
        jmp SoundF
    Three:
        mov ax, (1193180 / 300)
        jmp SoundF
    Five:
        mov ax, (1193180 / 500)
        jmp SoundF
    Seven:
        mov ax, (1193180 / 700)        

    SoundF:
        out 42h, al
        mov al, ah
        out 42h, al
        in al, 61h
        or al, 00000011b
        out 61h, al
        ; Delay time
        ; STOP
        in al, 61h
        and al, 11111100b
        out 61h, al
    Pop ax
endm

;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
;\\\\\\\\\\\\\\\ SORTING METHODS \\\\\\\\\\\\\\\\\\\\\
;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

    ; -------------------- BUBBLE SORT -------------------- ;
        BubbleSort macro array, ascOdec
            local JUMP3, JUMP2, JUMP1, Ascendent, Descendent
            push di
            ; GET THE SIZE OF NON ZERO ATRIBUTES OF THE ARRAY AND MOVE IT TO THE BX REGISTRY
            xor di, di
            JUMP3:
                mov si, di
                inc si
            JUMP2:
                mov al, array[di]
                mov ah, array[si]
                mov bl, ascOdec
                cmp bl, 01h
                    je Ascendent
                Descendent:
                    cmp al, ah
                        jge JUMP1
                    Sound al
                    mov array[di], ah
                    mov array[si], al
                    jmp JUMP1
                Ascendent:
                    cmp al, ah
                        jle JUMP1
                    Sound al
                    mov array[di], ah
                    mov array[si], al
            JUMP1:
                inc si
                cmp si, SIZEOF array
                    jnz JUMP2
                inc di
                mov cx, SIZEOF array
                dec cx
                cmp di, cx
                    jnz JUMP3
            pop di
        endm


    ; -------------------- SHELL SORT -------------------- ;
        ShellSort macro array
            ; TODO: Realizar esta parte del ShellSort. Comparar con el de Herberth y con codigo alto nivel. Y el de XMLSort
        endm

    ; -------------------- QUICK SORT -------------------- ;
        QuickSort macro array
            ; TODO: Realizar esta parte del QuickSort. Comparar con el de Herberth y con codigo alto nivel. Y el de XMLSort
        endm

;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
;\\\\\\\\\\\\\\\\     ARRAY     \\\\\\\\\\\\\\\\\\\\\\
;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

    PushIntoArray macro array
        
    endm

;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
;\\\\\\\\\\\\\\\\     USERS     \\\\\\\\\\\\\\\\\\\\\\
;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

ReadUsers macro file, route, handlerP
    Clean file, SIZEOF file, '$'
    
    OpenFile route, handlerP
    
    ReadFile handlerP, file, SIZEOF file
    
    CloseFile handlerP
endm

; Move to al 01h if the user exist. Move to al 00h if the user doesnt exist
CheckExistingUser macro user
    local EndGC, ReadLoop, Names, Pass, Points, Times, EndLoop, ChangeToUser, ChangeToTimes, ChangeToPoints, ChangeToPass

    ; To move through the file
    xor si, si
    xor di, di

    Clean auxiliarUser, SIZEOF auxiliarUser,'$'

    mov cx, SIZEOF file
    mov bx, 01h
    ReadLoop:
        xor ax, ax
        Push cx
        mov al, file[si]
        inc si

        cmp bx, 01h
            je Names
        cmp bx, 02h
            je Pass
        cmp bx, 03h
            je Points
        cmp bx, 04h
            je Times
        jmp EndGC

        Names:
            cmp al, ','
                je ChangeToPass
            ; User name
            mov auxiliarUser[di], al
            inc di
            jmp EndLoop
            ChangeToPass:
                xor di, di
                ; Compare Users
                CompareString auxiliarUser, actualUser

                cmp al, 01h
                    je EndGC

                Clean auxiliarUser, SIZEOF auxiliarUser,'$'

                mov bx, 02h
                jmp EndLoop
        Pass:
            cmp al, ','
                je ChangeToPoints
            ; Pass
            jmp EndLoop
            ChangeToPoints:
                xor di, di
                mov bx, 03h
                jmp EndLoop
        Points:
            cmp al, ','
                je ChangeToTimes
            ; Points
            jmp EndLoop
            ChangeToTimes:
                xor di, di
                mov bx, 04h
                jmp EndLoop
        Times:
            cmp al, '#'
                je EndGC
            cmp al, 59
                je ChangeToUser
            ; Times
            jmp EndLoop
            ChangeToUser:
                xor di, di
                mov bx, 01h
        EndLoop:
            Pop cx
    dec cx
        jne ReadLoop
    EndGC:
endm

; Move to ah 01h if the login have sucess
CheckPassOfUser macro user, pass
    local EndGC, ReadLoop, Names, PassJ, Points, Times, EndLoop, ChangeToUser, ChangeToTimes, ChangeToPoints, ChangeToPass
    xor ax, ax

    ; To move through the file
    xor si, si
    xor di, di

    Clean auxiliarUser, SIZEOF auxiliarUser,'$'

    mov cx, SIZEOF file
    mov bx, 01h
    ReadLoop:
        xor ax, ax
        push cx
        mov al, file[si]
        inc si

        cmp bx, 01h
            je Names
        cmp bx, 02h
            je PassJ
        cmp bx, 03h
            je Points
        cmp bx, 04h
            je Times
        jmp EndGC

        Names:
            cmp al, ','
                je ChangeToPass
            ; User name
            mov auxiliarUser[di], al
            inc di
            jmp EndLoop
            ChangeToPass:
                xor di, di
                mov bx, 02h
                jmp EndLoop
        PassJ:
            cmp al, ','
                je ChangeToPoints
            ; Pass
            mov auxiliarPass[di], al
            inc di
            jmp EndLoop
            ChangeToPoints:
                xor di, di
                mov bx, 03h

                xor ax, ax

                CompareString auxiliarUser, user

                cmp al, 01h
                    jne EndLoop

                xor ax, ax

                CompareString auxiliarPass, pass                

                cmp al, 01h
                    jne JErrorNoLogin

                mov ah, 01h
                
                jmp EndGC
        Points:
            cmp al, ','
                je ChangeToTimes
            ; Points
            jmp EndLoop
            ChangeToTimes:
                mov bx, 04h
                jmp EndLoop
        Times:
            cmp al, '#'
                je EndGC
            cmp al, 59
                je ChangeToUser
            ; Times
            jmp EndLoop
            ChangeToUser:
                Clean auxiliarUser, SIZEOF auxiliarUser, '$'
                Clean auxiliarPass, SIZEOF auxiliarPass, '$'
                mov bx, 01h
        EndLoop:
            Pop cx
    dec cx
        jne ReadLoop
    EndGC:
endm

; Check if the pass only have numbers
CheckPassR macro pass
    local RepeatLoop, EndGC

    xor di, di
    mov cx, 04h
    RepeatLoop:
        mov al, pass[di]
        inc di
        cmp al, 48
            jl JErrorInvalidPass
        cmp al, 57
            jg JErrorInvalidPass
    Loop RepeatLoop
    EndGC:
        mov al, pass[di]
        cmp al, '$'
            jne JErrorInvalidPass        
endm


LoginM macro user, pass

endm

AdminLogin macro user, pass
    local EndGC, CheckPass

    xor ax, ax

    CompareString adminUs, user

    cmp al, 01h
        je CheckPass
    jmp EndGC
    
    CheckPass:
        xor di, di
        
        mov al, pass[di]
        cmp al, '1'
            jne EndGC
        inc di
        
        mov al, pass[di]
        cmp al, '2'
            jne EndGC
        inc di
        
        mov al, pass[di]
        cmp al, '3'
            jne EndGC
        inc di
        
        mov al, pass[di]
        cmp al, '4'
            jne EndGC
        
        xor ax, ax
        mov al, 01h
        
        jmp AdminMenu

    EndGC:

endm

EnterUserAndPass macro user, pass
    local RepeatLoop, EnterNewUser, EndGC, EnterUser, EnterPass


    xor di, di
    xor cx, cx

    mov cx, SIZEOF file
    RepeatLoop:
        mov al, file[di]        
        cmp al, '#'
            je EnterNewUser
        inc di
    Loop RepeatLoop
    
    EnterNewUser:
        mov file[di], 59
        inc di
        
        EnterUser:
            xor si, si
            mov cx, SIZEOF user
            RepeatUser:
                mov al, user[si]
                inc si
                cmp al, '$'
                    je EnterPass
                mov file[di], al
                inc di
            Loop RepeatUser
        EnterPass:
            mov file[di], ','
            inc di
            xor si, si
            mov cx, SIZEOF pass
            RepeatPass:
                mov al, pass[si]
                inc si
                cmp al, '$'
                    je EnterPoint
                mov file[di], al
                inc di
            Loop RepeatPass
        EnterPoint:
            mov file[di], ','
            inc di
            mov file[di], '0'
            inc di
            mov file[di], '0'
            inc di
        EnterTime:
            mov file[di], ','
            inc di
            mov file[di], '0'
            inc di
            mov file[di], '0'
            inc di            
    EndGC:
        mov file[di], '#'
        ;print file
        ;getChar
        OpenFile route, handlerUsers
        WriteOnFile handlerUsers, file, SIZEOF file
        CloseFile handlerUsers
        ReadUsers file, route, handlerUsers
        ReadFileOfUsers file
endm

;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
;\\\\\\\\\\\\\\\\    TESTING    \\\\\\\\\\\\\\\\\\\\\\
;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

    ReadFileOfUsers macro file
        local ENDGC, ReadLoop, Names, Pass, Points, Times, EndLoop
        local ChangeToPass, ChangeToPoints, ChangeToTimes, ChangeToUser        

        ; For the file.
        ; ',' for the separation of information
        ; 13, 10 for the separation of users
        ; user,pass,maxPoints,minTime
        ; '#' for the end of file
        xor di, di
        xor si, si

        mov al, 00h
        mov count[00h], al
        
        mov cx, SIZEOF file
        mov bx, 01h
        ReadLoop:
            xor ax, ax
            Push cx
            mov al, file[si]
            inc si
            cmp bx, 01h
                je Names
            cmp bx, 02h
                je Pass
            cmp bx, 03h
                je Points
            cmp bx, 04h
                je Times
            jmp ENDGC

            Names:
                cmp al, ','
                    je ChangeToPass
                ; User name
                mov auxiliarUser[di], al
                inc di
                jmp EndLoop
                ChangeToPass:
                    mov al, count
                    inc al
                    mov count, al
                    xor di, di
                    mov bx, 02h
                    jmp EndLoop
            Pass:
                cmp al, ','
                    je ChangeToPoints
                ; Pass name
                mov auxiliarPass[di], al
                inc di
                jmp EndLoop
                ChangeToPoints:
                    xor di, di
                    mov bx, 03h
                    jmp EndLoop
            Points:
                cmp al, ','
                    je ChangeToTimes
                ; Points
                mov auxiliarPoint[di], al
                inc di
                jmp EndLoop
                ChangeToTimes:

                    ConvertToNumber auxiliarPoint
                    
                    xor di, di                
                    mov bx, 04h
                    jmp EndLoop
            Times:
                cmp al, '#'
                    je ENDGC
                cmp al, 59
                    je ChangeToUser
                ; Times
                mov auxiliarTimes[di], al
                inc di
                jmp EndLoop
                ChangeToUser:
                    xor di, di
                    mov bx, 01h                    
        
            EndLoop:
                Pop cx
        dec cx
            jne ReadLoop

        ENDGC:
            
    endm

;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
;\\\\\\\\\\\\\\\\     FILES     \\\\\\\\\\\\\\\\\\\\\\
;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

    ; GET ROUTE OF A FILE
    getRoute macro string
        local getCharacter, EndGC, Backspace
        Pushear
        xor si, si
        getCharacter:
            getChar
            ; If al == \n
            cmp al, 0dh
                je EndGC
            ; If al == \b
            cmp al, 08h
                je Backspace
            ; else
            mov string[si], al
            inc si
            jmp getCharacter
        Backspace:
            mov al, 24h
            dec si
            mov string[si], al
            jmp getCharacter
        EndGC:        
            mov al, 00h
            mov string[si], al
            Popear
    endm

    ; OPEN FILE
    OpenFile macro route, handler
        Pushear
        xor ax, ax
        xor dx, dx

        mov ah, 3dh
        mov al, 010b
        lea dx, route
        int 21h
        mov handler, ax
        ; JUMP IF AN ERROR OCCURRED WHILE OPENING THE FILE
        jc OpenError    
        Popear
    endm

    ; CLOSE FILE
    CloseFile macro handler
        Pushear

        xor ax, ax
        xor bx, bx

        mov ah, 3eh
        mov bx, handler
        int 21h
        ; JUMP IF THE FILE DOESNT CLOSE FINE
        jc CloseError
        Popear
    endm

    ; CREATE FILE
    CreateFile macro string, handler
        Pushear

        xor ax, ax
        xor cx, cx
        xor dx

        mov ah, 3ch
        mov cx, 00h
        lea dx, string
        int 21h
        mov handler, ax
        ; JUMP IF AN ERROR OCCURS WHILE CREATING THE FILE
        jc CreateError
        Popear
    endm

    ; WRITE ON FILE
    WriteOnFile macro handler, info, numBytes
        PUSH ax
        PUSH bx
        PUSH cx
        PUSh dx
        
        xor ax, ax
        xor bx, bx
        xor cx, cx
        xor dx, dx

        mov ah, 40h
        mov bx, handler
        mov cx, numBytes
        lea dx, info
        int 21h
        ; JUMP IF AN ERROR OCCURS DURING WRITING IN THE FILE
        jc WriteError

        POP dx
        POP cx
        POP bx
        POP ax
    endm

    ; READ FILE
    ReadFile macro handler, info, numBytes    

        Pushear

        xor ax, ax
        xor bx, bx
        xor cx, cx
        xor dx, dx

        mov ah, 3fh
        mov bx, handler
        mov cx, numBytes
        lea dx, info
        int 21h    
        jc ReadError

        Popear
    endm


;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
;\\\\\\\\\\\\\\\\\\\ CONVERSIONS \\\\\\\\\\\\\\\\\\\\
;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

    ConvertToNumber macro string
        local Begin, EndGC, PositiveSymbol, NegativeSymbol, Negative
        Push si
        
        xor ax, ax
        xor bx, bx
        xor cx, cx
        xor dx, dx
        mov bx, 10
        xor si, si
        ; Check signs
        Begin:
            mov cl, string[si]      
            ; If the ascii is +
            cmp cl, '+'
                je PositiveSymbol
            ; If the ascii is -
            cmp cl, '-'
                je NegativeSymbol
            ; If the ascii is less than the ascii of 0
            cmp cl, 48
                jl EndGC
            ; If the ascii is more than the ascii of 9
            cmp cl, 57
                jg EndGC
            inc si
            sub cl, 48  ; Subtract 48 to get the number
            mul bx      ; Multiply by 10
            add ax, cx

            jmp Begin
        PositiveSymbol:
            inc si
            jmp Begin
        NegativeSymbol:
            mov dx, 01h
            inc si
            jmp Begin
        Negative:
            neg ax
            xor dx, dx
        EndGC:        
            cmp dx, 01h
                je Negative    
            ; The string converted to number is in the registry ax
            Pop si
    endm

    ConvertToString macro string
        local Divide, Divide2, EndCr3, Negative, End2, EndGC
        Push si
        xor si, si
        xor cx, cx
        xor bx, bx
        xor dx, dx
        mov dl, 0ah
        test ax, 1000000000000000b
            jnz Negative
        jmp Divide2
        Negative:
            neg ax
            mov string[si], 45
            inc si
            jmp Divide2
        
        Divide:
            xor ah, ah
        Divide2:
            div dl
            inc cx
            Push ax
            cmp al, 00h
                je EndCr3
            jmp Divide
        EndCr3:
            pop ax
            add ah, 30h
            mov string[si], ah
            inc si
        Loop EndCr3
        mov ah, 24h
        mov string[si], ah
        inc si
        EndGC:
            Pop si
    endm

    ConvertToStringDH macro string, numberToConvert
        Push ax
        Push bx

        xor ax, ax
        xor bx, bx
        mov bl, 0ah
        mov al, numberToConvert
        div bl

        getNumber string, al
        getNumber string, ah

        Pop ax
        Pop bx
    endm


    getNumber macro string, numberToConvert
        local zero, one, two, three, four, five, six, seven, eight, nine
        local EndGC

        cmp numberToConvert, 00h
            je zero
        cmp numberToConvert, 01h
            je one
        cmp numberToConvert, 02h
            je two
        cmp numberToConvert, 03h
            je three
        cmp numberToConvert, 04h
            je four
        cmp numberToConvert, 05h
            je five
        cmp numberToConvert, 06h
            je six
        cmp numberToConvert, 07h
            je seven
        cmp numberToConvert, 08h
            je eight
        cmp numberToConvert, 09h
            je nine
        jmp EndGC

        zero:
            mov string[si], 30h
            inc si
            jmp EndGC
        one:
            mov string[si], 31h
            inc si
            jmp EndGC
        two:
            mov string[si], 32h
            inc si
            jmp EndGC
        three:
            mov string[si], 33h
            inc si
            jmp EndGC
        four:
            mov string[si], 34h
            inc si
            jmp EndGC
        five:
            mov string[si], 35h
            inc si
            jmp EndGC
        six:
            mov string[si], 36h
            inc si
            jmp EndGC
        seven:
            mov string[si], 37h
            inc si
            jmp EndGC
        eight:
            mov string[si], 38h
            inc si
            jmp EndGC
        nine:
            mov string[si], 39h
            inc si
            jmp EndGC
        EndGC:
    endm

;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
;\\\\\\\\\\\\\\\\\\ RECOVER THINGS \\\\\\\\\\\\\\\\\\
;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

    Pushear macro
        push ax
        push bx
        push cx
        push dx
        push si
        push di
    endm

    Popear macro                    
        pop di
        pop si
        pop dx
        pop cx
        pop bx
        pop ax
    endm

    PushearVideo macro array
        pushArreglo array
        push maximo     ; MAXIMUM HIGH
        push tamanoX    ; MAXIMUM WIDTH
        push espaciador ; DISTANCE BETWEEN BARS
        push cantidad   ; NUMBER OF BARS
        push time       ; SELECTED TIME FOR THE DELAY
    endm

    PoppearVideo macro array
        pop time
        pop cantidad
        pop espaciador
        pop tamanoX
        pop maximo
        popArreglo array
    endm
    
    TextMode macro
        ; RETURN TO TEXT MODE
        mov ax, 0003h
        int 10h
        mov ax, @data
        mov ds, ax
    endm

    GraphicMode macro
        ; BEGIN GRAPHIC MODE
        mov ax, 0013h           ; RESOLUTION OF 200Hex320Wi
        int 10h
        mov ax, 0A000h
        mov ds, ax              ; DS = A000h (MEMORY OF GRAPHICS)
    endm
