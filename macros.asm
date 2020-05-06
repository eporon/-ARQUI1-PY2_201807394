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

MakeSound macro value
    local Redj, Bluej, Yellowj, Greenj, WHitej, EndGC

    cmp value, 20
        jbe Redj
    cmp value, 40
        jbe Bluej
    cmp value, 60
        jbe Yellowj
    cmp value, 80
        jbe Greenj
    cmp value, 99
        jbe Whitej
    
    Redj:
        Sound 100
        jmp EndGC
    Bluej:
        Sound 300
        jmp EndGC
    Yellowj:
        Sound 500
        jmp EndGC
    Greenj:
        Sound 700
        jmp EndGC
    Whitej:
        Sound 900
    
    EndGC:
endm

; 1 - 20 : 100 | 21 - 40 : 300 | 41 - 60 : 500 | 61 - 80 : 700 | 81 - 99 : 900
; SOUND
Sound macro hz
    local SoundJMP, SoundOf, EndGC

    Push ax
    Push cx

    xor ax, ax
    xor cx, cx
    
    mov al, 86h
    out 43h, al
    mov ax, (1193180 / hz)
    out 42h, al
    mov al, ah
    out 42h, al 
    in  al, 61h
    or  al, 00000011b
    out 61h, al

    Delay time
    
    in al, 61h
    and al, 11111100b
    out 61h, al
    EndGC:
        Pop cx
        Pop ax
endm

;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
;\\\\\\\\\\\\\\\ SORTING METHODS \\\\\\\\\\\\\\\\\\\\\
;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

    ; -------------------- BUBBLE SORT -------------------- ;
        BubbleSortNoGraph macro array, ascOdec
            local JUMP3, JUMP2, JUMP1, Ascendent, Descendent
            push di
            ; GET THE SIZE OF NON ZERO ATRIBUTES OF THE ARRAY AND MOVE IT TO THE BX REGISTRY
            xor di, di            
            inc di
            inc di
            mov forV, 00h
            JUMP3:
                mov si, di
                inc si
                inc si
            JUMP2:
                mov ax, array[di]   ; al
                mov dx, array[si]   ; ah
                cmp dx, 00h
                    je JUMP1
                mov bl, ascOdec
                cmp bl, 01h
                    je Ascendent
                Descendent:
                    cmp ax, dx
                        jge JUMP1
                    ;Sound ax
                    mov array[di], dx
                    mov array[si], ax
                    jmp JUMP1
                Ascendent:
                    cmp ax, dx
                        jle JUMP1
                    ;Sound ax
                    mov array[di], dx
                    mov array[si], ax
            JUMP1:
                inc si
                inc si
                cmp si, SIZEOF array
                    jnz JUMP2
                inc di
                inc di
                inc forV
                ;mov cx, SIZEOF array
                ;dec cx
                mov cx, forV
                cmp cx, count
                    jnz JUMP3
            pop di
        endm

        BubbleSort macro array, ascOdec
            local JUMP3, JUMP2, JUMP1, Ascendent, Descendent
            push di
            ; GET THE SIZE OF NON ZERO ATRIBUTES OF THE ARRAY AND MOVE IT TO THE BX REGISTRY
            xor di, di            
            inc di
            inc di
            mov forV, 00h
            JUMP3:
                mov si, di
                inc si
                inc si
            JUMP2:
                mov ax, array[di]   ; al
                mov dx, array[si]   ; ah
                cmp dx, 00h
                    je JUMP1
                mov bl, ascOdec
                cmp bl, 01h
                    je Ascendent
                Descendent:
                    cmp ax, dx
                        jge JUMP1
                    mov array[di], dx
                    mov array[si], ax
                    Pushear
                    GraphOnScreen array
                    Popear
                    Pushear
                    MakeSound ax
                    Popear
                    jmp JUMP1
                Ascendent:
                    cmp ax, dx
                        jle JUMP1
                    mov array[di], dx
                    mov array[si], ax
                    Pushear
                    GraphOnScreen array
                    Popear
                    Pushear
                    MakeSound ax
                    Popear
            JUMP1:
                inc si
                inc si
                cmp si, SIZEOF array
                    jnz JUMP2
                inc di
                inc di
                inc forV
                ;mov cx, SIZEOF array
                ;dec cx
                mov cx, forV
                cmp cx, count
                    jnz JUMP3
            pop di
        endm

    ; -------------------- SHELL SORT -------------------- ;
        ShellSort macro array, ascOdec
            ; TODO: Realizar esta parte del ShellSort. Comparar con el de Herberth y con codigo alto nivel. Y el de XMLSort
        endm

    ; -------------------- QUICK SORT -------------------- ;
        QuickSort macro array, ascOdec, major, minor
            ; TODO: Realizar esta parte del QuickSort. Comparar con el de Herberth y con codigo alto nivel. Y el de XMLSort
            local EndGC, Sort
            print aber
            getChar
            Pushear
            
                xor ax, ax
                xor bx, bx
                xor cx, cx 
                xor si, si
                xor di, di

                mov si, minor
                mov MINORV, si
                mov di, major
                mov MAJORV, di

                ; if LOW < HIGH Then Sort. Else End
                cmp si, di
                    jl Sort
                jmp EndGC

            Sort:

                ; pivot = partition(array, ascOdec, low, high)
                GetPartition array, ascOdec, minor, major
                mov pivot, ax

                dec pivot
                Push pivot
                Push MINORV
                ;QuickSort array, ascOdec, pivot, MINORV
                Pop MINORV
                Pop pivot
                add pivot, 2
                ;QuickSort array, ascOdec, MAJORV, pivot                
            EndGC:
                Popear
        endm

        GetPartition macro array, ascOdec, minor, major
            local ForR, Descendent, Ascendent, Swap, ContinueFor
            mov ax, array[2 * major]
            mov pivot, ax                   ;int pivot = arr[high];
            mov di, minor                   ;int i = (low - 1);
            dec di                          ;int i = (low - 1);
            dec di
        
            mov si, minor                     ; j = low
            ForR:
                mov ax, array[si]           ; arr[j]

                ; Compare ascendent or descendent                
                mov bl, ascOdec
                cmp bl, 01h
                    je Ascendent                            

                Descendent:
                    cmp ax, pivot
                        jg Swap
                    jmp ContinueFor
                Ascendent:
                    cmp ax, pivot               ; arr[j] < pivot
                        jl Swap
                    jmp ContinueFor
                Swap:
                    inc di                  ; i++
                    inc di
                    mov bx, array[di]       ; arr[i]
                    mov array[si], bx       ; arr[j] = arr[i] actual Value
                    mov array[di], ax       ; arr[i] = arr[j] last Value
                ContinueFor:
                    inc si                      ; j++
                    inc si
                    cmp si, major               ; j <= high
                        jle ForR
            ;     swap(&arr[i + 1], &arr[high])
            inc di                              ; i + 1
            inc si
            mov ax, array[di]                   ; arr[i+1]
            mov bx, array[major]                ; arr[high]
            mov array[di], bx                   ; arr[i+1] = arr[high] actualValue
            mov array[major], ax                ; arr[high] = arr[i+1] lastValue

            mov ax, di                          ; return i + 1
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
        Clean file, SIZEOF file, 32
        
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

    ReadFileOfLevels macro string
        local EndGC, Case0
        print string
        getChar
        mov countOfLevels, 00h
        xor si, si
        xor di, di
        ; Cases
            Case0:
                ; ------N------
                cmp string[si], 78
                    je Case1
                jmp EndGC
            Case1:
                ; ------I------
                inc si
                cmp string[si], 73
                    je Case2
                jmp JErrorOnFile
            Case2:
                ; ------V------
                inc si
                cmp string[si], 86
                    je Case3
                jmp JErrorOnFile
            Case3:
                ; ------E------
                inc si
                cmp string[si], 69
                    je Case4
                jmp JErrorOnFile
            Case4:
                ; ------L------
                inc si
                cmp string[si], 76
                    je Case5
                jmp JErrorOnFile
            Case5:
                ; ------;------
                inc si
                cmp string[si], 59
                    je Case6
                jmp JErrorOnFile
            ; ------Name of Level------
            Case6:                
                inc si
                mov al, string[si]
                cmp al, 59
                    je Case7    ; Change times
                cmp countOfLevels, 00h
                    je Level1
                cmp countOfLevels, 01h
                    je Level2
                cmp countOfLevels, 02h
                    je Level3
                cmp countOfLevels, 03h
                    je Level4
                cmp countOfLevels, 04h
                    je Level5
                ; Fill Levels
                    Level6:
                        mov strlevel6[di], al
                        inc di
                    jmp Case6
                    Level1:
                        mov strlevel1[di], al
                        inc di
                    jmp Case6
                    Level2:
                        mov strlevel2[di], al
                        inc di
                    jmp Case6
                    Level3:
                        mov strlevel3[di], al
                        inc di
                    jmp Case6
                    Level4:
                        mov strlevel4[di], al
                        inc di
                    jmp Case6
                    Level5:
                        mov strlevel5[di], al
                        inc di
                    jmp Case6
            Case7:
                inc si
                cmp string[si], 59
                    je Case8
                jmp Case7
            Case8:
                inc si
                cmp string[si], 59
                    je Case9
                jmp Case8
            Case9:
                inc si
                cmp string[si], 59
                    je Case10
                jmp Case9
            Case10:
                inc si
                cmp string[si], 59
                    je Case11
                jmp Case10
            Case11:
                inc si
                cmp string[si], 59
                    je Case12
                jmp Case11
            ; COLOR
            Case12:
                
        EndGC:
    endm

;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
;\\\\\\\\\\\\\\\\\    ADMIN    \\\\\\\\\\\\\\\\\\\\\\\
;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

    TOPPOINTSMACRO macro 
        local InitialGraph, ENDGC, SelectBubble, SelectQuick, GoToMenu, ShowFile
        ; MOSTRAR ARCHIVO DE TOPS
            BubbleSortNoGraph pointsO, 00h            
            mov ax, pointsO[02h]
            mov MAXVALUE, ax
        ;CreateTopFile
            ;CreateTopFile
            ;ShowFile:            
            ;    getChar
            ;    cmp al, 32
            ;        jne ShowFile
        ; MOSTRAR GRAFICA INICIAL                   
            ReadFileOfUsers file
            GraphOnScreen pointsO
        ; ESCUCHAR BARRA ESPACIADORA
        InitialGraph:
            getChar
            cmp al, 32
                jne InitialGraph
        TextMode
        ; MOSTRAR MENU DE ORDENAMIENTO
            SelectSortingMethod
        ; SELECCIONAR VELOCIDAD
            SelectVelocity
        ; SELECCIONAR ASCENDENTE O DESCENDENTE
            SelectAscOrDes
        ; ESCUCHAR BARRA ESPACIADORA
            ReadFileOfUsers file
            GraphOnScreen pointsO
        ; INICIAR ORDENAMIENTO Y GRAFICADA
            cmp ORDERTYPE, 00h
                je SelectBubble
            cmp ORDERTYPE, 01h
                je SelectQuick
            BubbleSort pointsO, ascOdesOPT
            ;ShellSort pointsO, ascOdesOPT
            jmp ENDGC
            SelectBubble:
                BubbleSort pointsO, ascOdesOPT
                jmp ENDGC
            SelectQuick:
                BubbleSort pointsO, ascOdesOPT
                ;QuickSort pointsO, ascOdesOPT, 0, count                
        ; ESCUCHAR BARRA PARA TERMINAR
        ENDGC:
            GraphOnScreen pointsO
            getChar
            cmp al, ' '
                je GoToMenu
            jmp ENDGC
        GoToMenu:
            TextMode
            jmp AdminMenu
    endm

    CreateTopFile macro
        local LoopReport, EndFile, WriteReport, ReadLoop, EndRead, ChangeToPass, ChangeToPoints, ChangeToTimes, ChangeToUser, Times, Points, Pass, Names, PutUserInFile
        ;Report
        xor si, si          ; To travel through the Report
        xor di, di          ; To travel through the fileOfUsers

        ConcatText Report, reportHeader, SIZEOF reportHeader
        
        mov indexPoints, 00h
        mov cx, 0Ah
        LoopReport:
            Push cx
            Push si
            xor si, si
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
                jmp EndFile

                Names:
                    cmp al, ','
                        je ChangeToPass
                    mov auxiliarUser[di], al
                    inc di
                    jmp EndRead
                    ChangeToPass:
                        print auxiliarUser
                        getChar
                        xor di, di
                        mov bx, 02h
                        jmp EndRead
                Pass:
                    cmp al, ','
                        je ChangeToPoints
                    jmp EndRead
                    ChangeToPoints:
                        xor di, di
                        mov bx, 03h
                        jmp EndRead
                Points:
                    cmp al, ','
                        je ChangeToTimes
                    mov auxiliarPoint[di], al
                    inc di
                    jmp EndRead
                    ChangeToTimes:
                        mov di, indexPoints
                        ConvertToNumber auxiliarPoint

                        cmp ax, pointsO[di]
                            je PutUserInFile
                        xor di, di
                        mov bx, 04h
                        jmp EndRead
                        PutUserInFile:
                            mov FLAGREPORT, 01h
                            jmp EndRead
                Times:
                    cmp al, '#'
                        je EndFile
                    cmp al, 59
                        je ChangeToUser
                    cmp auxiliarTimes[di], al
                    inc di
                    jmp EndRead
                    ChangeToUser:
                        cmp FLAGREPORT, 01h
                            je WriteReport
                        xor di, di
                        mov bx, 01h
                        Clean auxiliarUser, SIZEOF auxiliarUser, '$'
                        Clean auxiliarPoint , SIZEOF auxiliarPoint, '$'
                        Clean auxiliarTimes, SIZEOF auxiliarTimes, '$'
            EndRead:
                Pop cx
            dec cx
                jne ReadLoop
            WriteReport:
                Pop si
                mov Report[si], 13
                inc si
                mov Report[si], 10
                ConcatText Report, auxiliarUser, SIZEOF auxiliarUser
                mov Report[si], 32
                inc si
                mov Report[si], 32
                inc si
                mov Report[si], 32
                inc si
                ConcatText Report, auxiliarPoint, SIZEOF auxiliarPoint
                mov Report[si], 32
                inc si
                mov Report[si], 32
                inc si
                mov Report[si], 32
                inc si
                ConcatText Report, auxiliarTimes, SIZEOF auxiliarTimes
                mov Report[si], 32
                inc si
                mov Report[si], 32
                inc si
                mov Report[si], 32
                inc si            
                mov FLAGREPORT, 00h
            EndFile:
                inc indexPoints
                Pop cx
        dec cx
            jne LoopReport
        
    endm

    TOPTIMESMACRO macro
        local InitialGraph, ENDGC, SelectBubble, SelectQuick, GoToMenu
        ; MOSTRAR ARCHIVO DE TOPS
            BubbleSortNoGraph timesO, 01h            
            mov ax, timesO[02h]
            mov MINVALUE, ax
        ;CreateTopFile
            ;CreateTopFile
            ;ShowFile:            
            ;    getChar
            ;    cmp al, 32
            ;        jne ShowFile
        ; MOSTRAR GRAFICA INICIAL                   
            ReadFileOfUsers file
            GraphOnScreen timesO
        ; ESCUCHAR BARRA ESPACIADORA
        InitialGraph:
            getChar
            cmp al, 32
                jne InitialGraph
        TextMode
        ; MOSTRAR MENU DE ORDENAMIENTO
            SelectSortingMethod
        ; SELECCIONAR VELOCIDAD
            SelectVelocity
        ; SELECCIONAR ASCENDENTE O DESCENDENTE
            SelectAscOrDes
        ; ESCUCHAR BARRA ESPACIADORA
            ReadFileOfUsers file
            GraphOnScreen timesO
        ; INICIAR ORDENAMIENTO Y GRAFICADA
            cmp ORDERTYPE, 00h
                je SelectBubble
            cmp ORDERTYPE, 01h
                je SelectQuick
            BubbleSort timesO, ascOdesOPT
            ;ShellSort timesO, ascOdesOPT
            jmp ENDGC
            SelectBubble:
                BubbleSort timesO, ascOdesOPT
                jmp ENDGC
            SelectQuick:
                BubbleSort timesO, ascOdesOPT
                ;QuickSort timesO, ascOdesOPT, 0, count                
        ; ESCUCHAR BARRA PARA TERMINAR
        ENDGC:
            GraphOnScreen timesO
            getChar
            cmp al, ' '
                je GoToMenu
            jmp ENDGC
        GoToMenu:
            TextMode
            jmp AdminMenu
    endm

    SelectSortingMethod macro
        local begin, EndGC, ChooseBubblue, ChooseQuick, ChooseShell
        begin:
            print msgSelectSort
            getChar
            cmp al, '1'
                je ChooseBubblue
            cmp al, '2'
                je ChooseQuick
            cmp al, '3'
                je ChooseShell
            jmp begin
        ChooseBubblue:
            mov ORDERTYPE, 00h
            jmp EndGC
        ChooseQuick:
            mov ORDERTYPE, 01h
            jmp EndGC
        ChooseShell:
            mov ORDERTYPE, 02h
        EndGC:
    endm

    SelectVelocity macro
        local begin, EndGC, ZeroVel, OneVel, TwoVel, ThreeVel, FourVel, FiveVel, SixVel, SevenVel, EightVel, NineVel
        begin:
            print msgSelectVel
            getChar
            cmp al, '0'
                jb begin
            cmp al, '9'
                ja begin
            mov selectedVel, al
            sub al, 48
            mov velocity, al
            cmp velocity, 00h
                je ZeroVel
            cmp velocity, 01h
                je OneVel
            cmp velocity, 02h
                je TwoVel
            cmp velocity, 03h
                je ThreeVel
            cmp velocity, 04h
                je FourVel
            cmp velocity, 05h
                je FiveVel
            cmp velocity, 06h
                je SixVel
            cmp velocity, 07h
                je SevenVel
            cmp velocity, 08h
                je EightVel
            cmp velocity, 09h
                je NineVel

            ZeroVel:
                mov time, 1000
                jmp EndGC
            OneVel:
                mov time, 900
                jmp EndGC
            TwoVel:
                mov time, 800
                jmp EndGC
            ThreeVel:
                mov time, 700
                jmp EndGC
            FourVel:
                mov time, 600
                jmp EndGC
            FiveVel:
                mov time, 500
                jmp EndGC
            SixVel:
                mov time, 400
                jmp EndGC
            SevenVel:
                mov time, 300
                jmp EndGC
            EightVel:
                mov time, 200
                jmp EndGC
            NineVel:
                mov time, 100
                jmp EndGC
        EndGC:
    endm

    SelectAscOrDes macro
        local begin, EndGC, ASC, DES
        begin:
            print msgSelectAoD
            getChar
            cmp al, '1'
                je ASC
            cmp al, '2'
                je DES
            jmp begin
        ASC:
            mov ascOdesOPT, 01h
            jmp EndGC
        DES:
            mov ascOdesOPT, 00h
        EndGC:
    endm

    GraphOnScreen macro array
        ; MODO VIDEO
            GraphicMode
        ; ENCABEZADO
            GraphHeader
        ; DIBUJARARREGLO
            GraphArray array            
    endm

    GraphArray macro array
        local TEN, FIFTEEN, TWENTY, WhileDraw, Draw, TENWHILE, FIFTEENWHILE, TWENTYWHILE, MoveIndex

        xor ax, ax
        xor bx, bx
        xor cx, cx
        xor dx, dx
        xor si, si

        inc si
        inc si

        
        mov cx, count

        cmp count, 10
            jbe TEN
        cmp count, 15
            jbe FIFTEEN
        cmp count, 20
            jbe TWENTY
        TEN:
            ; For the number
            mov bl, 10
            ; For the bar
            mov dx, 67
            jmp WhileDraw
        FIFTEEN:
            ; For the number
            mov bl, 5
            ; For the bar
            mov dx, 30
            jmp WhileDraw
        TWENTY:
            ; For the number
            mov bl, 10
            ; For the bar
            mov dx, 77
        
        WhileDraw:
                        
            Push cx
            mov ax, array[si]                                  
            cmp ax, 00h
                ja Draw
            jmp MoveIndex

            Draw:
                Push ax
                ConvertToString number
                GraphString number, bl, 21, WHITE
                Pop ax
                ; GET COLOR BY VALUE
                GetColor ax
                ; GET THE VALUE OF THE HEIGHT
                mov ax, array[si]
                Push bx
                mov bl, 02h
                mul bl
                
                cmp count, 10
                    jbe TENWHILE
                cmp count, 15
                    jbe FIFTEENWHILE
                cmp count, 20
                    jbe TWENTYWHILE
                
                TENWHILE:
                    ; DRAW BAR
                    GraphBar dx, 330, 40, ax, SELECTEDCOLOR
                    add dx, 48
                    Pop bx
                    add bl, 6
                    jmp MoveIndex
                FIFTEENWHILE:
                    ; DRAW BAR
                    GraphBar dx, 330, 33, ax, SELECTEDCOLOR
                    add dx, 40
                    Pop bx
                    add bl, 5
                    jmp MoveIndex
                TWENTYWHILE:
                    ; DRAW BAR
                    GraphBar dx, 330, 20, ax, SELECTEDCOLOR                    
                    add dx, 24
                    Pop bx
                    add bl, 3
                    jmp MoveIndex
            MoveIndex:
                inc si
                inc si
                Pop cx
                dec cx
                cmp cx, 00h
                    jne WhileDraw
    endm

    GetColor macro value
        local COLORRED, COLORBLUE, COLORYELLOW, COLORGREEN, COLORWHITE, EndGC
        
        cmp value, 20
            jbe COLORRED
        cmp value, 40
            jbe COLORBLUE
        cmp value, 60
            jbe COLORYELLOW
        cmp value, 80
            jbe COLORGREEN
        cmp value, 99
            jbe COLORWHITE

        COLORRED:
            xor ax, ax
            mov al, RED
            mov SELECTEDCOLOR, al
            jmp EndGC
        COLORBLUE:
            xor ax, ax
            mov al, BLUE
            mov SELECTEDCOLOR, al
            jmp EndGC
        COLORYELLOW:
            xor ax, ax
            mov al, YELLOW
            mov SELECTEDCOLOR, al
            jmp EndGC
        COLORGREEN:
            xor ax, ax
            mov al, GREEN
            mov SELECTEDCOLOR, al
            jmp EndGC
        COLORWHITE:
            xor ax, ax
            mov al, WHITE
            mov SELECTEDCOLOR, al
        EndGC:
    endm

                ; dx int int ax  SELECTEDCOLOR
    GraphBar macro x, y, Wi, He, COLOR
        local WhileHeight, WhileWidth
        mov HEIGHTVALUE, ax

        mov cx, ax
        mov xPos2, x
        mov yPos2, y
        WhileHeight:
            Push cx
            mov WIDTHVALUE, Wi
            mov cx, WIDTHVALUE
            WhileWidth:
                Push cx
                ;x - y - color
                printPixel xPos2, yPos2, COLOR
                inc xPos2
                Pop cx
            Loop WhileWidth
            Pop cx
            dec yPos2

            mov xPos2, x
        Loop WhileHeight
        ;getChar
    endm

    GraphHeader macro
        LOCAL BubbleGraph, QuickGraph, ShellGraph, GraphTime, GraphVelocity
        xor ax, ax

        cmp ORDERTYPE, 00h
            je BubbleGraph
        cmp ORDERTYPE, 01h
            je QuickGraph
        cmp ORDERTYPE, 02h
            je ShellGraph
        BubbleGraph:
            GraphString strBubble, 2, 1, WHITE
            jmp GraphTime
        QuickGraph:
            GraphString strQuick, 2, 1, WHITE
            jmp GraphTime
        ShellGraph:
            GraphString strShell, 2, 1, WHITE
        
        GraphTime:
            GraphString strSeconds, 38, 1, WHITE

        GraphVelocity:
            GraphString strVelocity, 62, 1, WHITE
            GraphString selectedVel, 74, 1, WHITE

    endm

    GraphString macro string, x, y, COLOR
        local WhileDraw
        Pushear

        xor ax, ax
        ;xor bx, bx
        xor cx, cx
        xor si, si

        mov xPos, x

        mov cx, SIZEOF string
        moveCursor y, x

        WhileDraw:
            Push cx
            mov ah, 09h
            mov al, string[si]
            mov bh, 00h
            mov bl, COLOR
            mov cx, 01h
            int 10h
            inc xPos
            moveCursor y, xPos
            inc si
            Pop cx
        Loop WhileDraw

        Popear
    endm

;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
;\\\\\\\\\\\\\\\\    TESTING    \\\\\\\\\\\\\\\\\\\\\\
;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

    ReadFileOfUsers macro file
        local ENDGC, ReadLoop, Names, Pass, Points, Times, EndLoop
        local ChangeToPass, ChangeToPoints, ChangeToTimes, ChangeToUser        
        local AdminUserJMP

        ;Clean pointsO, SIZEOF pointsO, 00h

        ; For the file.
        ; ',' for the separation of information
        ; 13, 10 for the separation of users
        ; user,pass,maxPoints,minTime
        ; '#' for the end of file
        xor di, di
        xor si, si

        cmp count, 20
            jge JErrorMaxUsers

        mov ax, 00h
        mov count[00h], ax
        mov indexPoints, 00h
        
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
                    mov ax, count
                    inc ax
                    mov count, ax
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
                    mov di, indexPoints
                    
                    ConvertToNumber auxiliarPoint                    
                    
                    mov pointsO[di], ax

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
                    mov di, indexPoints

                    ConvertToNumber auxiliarTimes

                    mov timesO[di], ax

                    inc di
                    inc di
                    mov indexPoints, di

                    xor di, di
                    mov bx, 01h                    
        
            EndLoop:
                Pop cx
        dec cx
            jne ReadLoop

        ENDGC:
            dec count
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
        Pushear
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
            Popear
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
        mov ah, 00h
        mov al, 18
        int 10h
        
    endm
