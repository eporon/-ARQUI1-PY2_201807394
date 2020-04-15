include macros.asm

.model small

; STACK SEGMENT
.stack

; DATA SEGMENT
.data

    ; SPECIAL CHARACTERS
        newLine db 13, 10, '$'
        cleanChar db '             ', '$'
        tab db 9, '$'
    ; END SPECIAL CHARACTERS

    ; PRINCIPAL MENU
        msgPrincipal db 13, 10, 9, '-!-!-!_MENU PRINCIPAL_!-!-!-', 13, 10, 9, 9,  '1.) Ingresar', 13, 10, 9, 9,  '2.) Registrar', 13, 10, 9, 9,  '3.) Salir', 13, 10, '$'
    ; LOGIN AND REGISTRY
        msgLoginUser db 'Ingrese Usuario: ', '$'
        msgLoginPass db 'Ingrese Contrasenia: ', '$'
        auxUser db 20 dup('$')
        auxPass db 20 dup('$')
    
    ; USERS MENU
        msgHeaderUser db 13, 10, 9, 'UNIVERSIDAD DE SAN CARLOS DE GUATEMALA', 13, 10, 9, 'FACULTAD DE INGENIERIA', 13, 10, 9, 'CIENCIAS Y SISTEMAS', 13, 10, 9, 'ARQUITECTURA DE COMPUTADORES Y ENSAMBLADORES 1', 13, 10, 9, 'NOMBRE: ANGEL MANUEL MIRANDA ASTURIAS', 13, 10, 9, 'CARNET: 201807394', 13, 10, 9, 'SECCION: A', 13, 10, 13, 10, 9, 9, '1.) Iniciar Juego', 13, 10, 9, 9, '2.) Cargar Juego', 13, 10, 9, 9, '3.) Salir', 13, 10, '$'

    ; ADMIN MENU
        msgHeaderAdmin db 13, 10, 9, 'UNIVERSIDAD DE SAN CARLOS DE GUATEMALA', 13, 10, 9, 'FACULTAD DE INGENIERIA', 13, 10, 9, 'CIENCIAS Y SISTEMAS', 13, 10, 9, 'ARQUITECTURA DE COMPUTADORES Y ENSAMBLADORES 1', 13, 10, 9, 'NOMBRE: ANGEL MANUEL MIRANDA ASTURIAS', 13, 10, 9, 'CARNET: 201807394', 13, 10, 9, 'SECCION: A', 13, 10, 13, 10, 9, 9, '1.) Top 10 puntos', 13, 10, 9, 9, '2.) Top 10 tiempo', 13, 10, 9, 9, '3.) Salir', 13, 10, '$'

    ; USERS
        file db 1500 dup('$')
        route db 'users.us'
        handlerUsers dw ?

    ; GAME VARIABLES
        actualUser db 20 dup('$')
        actualLevel db 20 dup('$')
        ; pointsNumber 
        pointsLabel db 5 dup('$')
        ; timeNumber
        timeLabel db '00:00:00', '$'

    ; ERRORS
        errorExistingUser db 'El usuario ingresado ya existe. Escribe otro usuario', '$'
        errorInvalidPass db 'Contraseña incorrecta, debe de solo contener digitos', '$'
        msgErrorWrite db 'Error al escribir en el archivo', '$'
        msgErrorOpen db 'Error al abrir el archivo. Puede que no exista o la extension este mala', '$'
        msgErrorCreate db 'Error al crear el archivo', '$'
        msgErrorClose db 'Error al cerrar el archivo', '$'
        msgErrorRead db 'Error al leer el archivo', '$'

; CODE SEGMENT
.code

main proc

    mov ax, @data
    mov ds, ax

    Start:
        ClearConsole
        ; MENU
        print msgPrincipal
        getChar
        
        cmp al, 31h
            je Login
        cmp al, 32h
            je Registry
        cmp al, 33h
            je Exit
        jmp Start
    Registry:
        ReadUsers file, route, handlerUsers
        ClearConsole

        print msgLoginUser
        getText auxUser

        CheckExistingUser auxUser

        print msgLoginPass
        getText auxPass

        CheckPass auxPass
        
        jmp Start
    Login:
        ReadUsers file, route, handlerUsers

    UserMenu:

    AdminMenu:

    Exit:
        mov ah, 4ch     ; END PROGRAM
        xor al, al
        int 21h
    ; ERRORS
        WriteError:
            print msgErrorWrite
            getChar
            jmp Start
        OpenError:
            print msgErrorOpen
            getChar
            jmp Start
        CreateError:
            print msgErrorCreate
            getChar
            jmp Start
        CloseError:
            print msgErrorClose
            getChar
            jmp Start
        ReadError:
            print msgErrorRead
            getChar
            jmp Start
        JErrorExistingUser:
            
        JErrorInvalidPass:

main endp

end