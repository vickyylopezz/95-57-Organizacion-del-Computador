global main
extern puts
extern gets
extern sscanf
extern printf

section .data
    msjIngMatriz                db  "Ingrese de la matriz %li",10,0
    msjIngMatrizFil             db  "el elemento en la fila %li columna %li",10,0
    msjIngCantMatrices          db  "Ingrese la cantidad de matrices con las que va a operar",0
    formatoInputNumero          db  "%li",0
    msjIngCantMatricesInvalido  db  "La cantidad de matrices debe ser de 2 a 5",0
    msjIngCantFilCol            db  "Ingrese la cantidad de filas y columnas que tendran las matrices, separados por un espacio",0
    formatoInputFilCol          db  "%hi %hi",0
    msjIngCantFilColInvalido    db  "La fila y columna debe ser un numero entre [1..8]",0
    indiceMatriz                dq  1
    indiceFila                  dq  1
    indiceCol                   dq  1
    ;msjDebug                    db  "llegue aca"
    auxiliarFila                dq  0
    auxiliarCol                 dq  0
    matrices         times 320 	dq  0
    formatoInputElemento        db  "%li",0
    msjElementoInvalido         db  "Elemento ingresado invalido, debe ser un numero entre -99 y 99, se pondra 0 en esa posicion",10,0
    posicionVector              dq  0
    msjElementoMatriz           dq  "  %li  ",0
    indiceVector                dq  1
    msjMostrarMatriz            db  "Matrices:",10,0
    indiceImprimir              dq  0
    msjNewLine                  dw  " ",10,0
    auxiliarImprimir            dq  0
    auxiliarMatrices            dq  0
    msjOpciones                 db  "Ingrese...",0
    opcionUno                   db  "1 para hacer resta de 2 o más matrices",0
    opcionDos                   db  "2 para ver si dos matrices son iguales",0
    opcionTres                  db  "3 para multiplicar una matriz por un valor escalar leído desde teclado",0
    opcionCuatro                db  "4 para modificar el valor de un elemento de una matriz",0
    opcionCinco                 db  "5 para consultar el valor de un elemento de una matriz",0
    msjOpcionInvalida           db  "Opcion invalida, debe ser un numero entre 1 y 5",0
    msjCuantasMatrices          db  "Ingrese cuantas matrices que quiere restar",0
    msjIngCantMatricesRestarInvalido    db  "Cantidad ingresada invalida",0
    msjCualesMatricesRestar     db  "Cuales de las anteriores matrices desea restar? Indicando 1 para la primer matriz, 2 para la segunda y asi sucesivamente. Ingrese en el orden que desea restarlas",0
    msjNumeroDeMatrizInvalido   db  "Numero de matriz invalido, vuelva a ingresar los numeros de las matrices nuevamente",0
        

section .bss
    inputCantMatrices     resq    10
    esValido              resb    1
    cantMatrices          resq    1
    plusRsp		          resq	  1
    inputCantFilCol       resb    50
    fila                  resw    1   
    columna               resw    1
    inputElemento         resq    1
    filas                 resq    1
    elemento              resq    1
    inputOpcion           resq    1
    opcion                resq    1
    inputCantMatricesRestar resq    1
    cantMatricesRestar    resq    1
    inputNumMatRestar     resq    1
    matricesRestar      times 5 resq 1
    numMatRestar          resq    1

section .text
main:
sub     rsp,8

    call ingresoCantMatrices

    call ingresoCantFilCol

    call ingresoMatrices 

    call imprimirMatrices

    call menuDeOpciones

add     rsp,8 
ret

ingresoCantMatrices:
    mov     rdi,msjIngCantMatrices
    call    puts

    mov     rdi,inputCantMatrices
    call    gets

validarCantMatrices:
    mov     byte[esValido],'N'

    mov     rdi,inputCantMatrices 
    mov     rsi,formatoInputNumero
    mov     rdx,cantMatrices

    call    checkAlign
    sub     rsp,[plusRsp]

    call    sscanf  
    add		rsp,[plusRsp]   ;add rsp,32               
    cmp     rax,1                   
    jl      cantMatricesInvalido

    cmp     qword[cantMatrices],2    
    jl      cantMatricesInvalido        
    cmp     qword[cantMatrices],5    
    jg      cantMatricesInvalido

    mov     byte[esValido],'S'   

ret

cantMatricesInvalido:
    mov     rdi,msjIngCantMatricesInvalido
    call    puts
    jmp     ingresoCantMatrices
ret   

ingresoCantFilCol:
    mov     rdi,msjIngCantFilCol
    call    puts

    mov     rdi,inputCantFilCol
    call    gets

validarFilCol:
    mov     byte[esValido],'N'   

    mov     rdi,inputCantFilCol         
    mov     rsi,formatoInputFilCol   
    mov     rdx,fila                
    mov     rcx,columna             
    call    checkAlign
    sub     rsp,[plusRsp]

    call    sscanf  
    add		rsp,[plusRsp]   ;add rsp,32    
    cmp     rax,2                   
    jl      filColInvalido

    cmp     word[fila],1    
    jl      filColInvalido        
    cmp     word[fila],8    
    jg      filColInvalido        

    cmp     word[columna],1 
    jl      filColInvalido        
    cmp     word[columna],8 
    jg      filColInvalido        

    mov     byte[esValido],'S'
    ret

filColInvalido:
    mov     rdi,msjIngCantFilColInvalido
    call    puts
    jmp     ingresoCantFilCol
ret

ingresoMatrices:

    sub     rcx,rcx             
    mov     rcx,[cantMatrices] 

mensajeIngMatrices:
    push    rcx
    
    mov     rdi,msjIngMatriz
    mov     rsi,qword[indiceMatriz]
    call    printf

    sub     rcx,rcx             
    mov     cx,[fila]

mensajeFila:
    mov     [auxiliarFila],rcx

    sub     rcx,rcx             
    mov     cx,[columna]

msjColumna:
    mov     [auxiliarCol],rcx

    mov     rdi,msjIngMatrizFil
    mov     rsi,qword[indiceFila]
    mov     rdx,qword[indiceCol]
    call    printf

    mov     rdi,inputElemento
    call gets

    sub     rbx,rbx
    mov     rbx,qword[indiceVector]
    sub     rbx,1
    
    imul    rbx,rbx,8
    mov     qword[posicionVector],rbx   

    inc     qword[indiceVector]
    call    validarElemento

    inc     qword[indiceCol]
    mov     rcx,[auxiliarCol]
    dec     rcx
    jnz     msjColumna

    mov     qword[indiceCol],1
    inc     qword[indiceFila]
    mov     rcx,[auxiliarFila]
    dec     rcx
    jnz     mensajeFila

    mov     qword[indiceFila],1
;--------- para que en el vector se guarden separadas las matrices y no todas juntas (no se si anda)
    ;sub     rbx,rbx
    ;mov     qword[indiceVector],64
    ;mov     rbx,qword[indiceMatriz]
    ;imul    rbx,qword[indiceVector]
;------------------------------
    inc     qword[indiceMatriz]
    pop     rcx
    dec     rcx
    jnz     mensajeIngMatrices

ret

validarElemento:
    mov     byte[esValido],'N'

    mov     rdi,inputElemento       
    mov     rsi,formatoInputElemento 
    mov     rdx,elemento
    call    checkAlign
    sub     rsp,[plusRsp]

    call    sscanf  
    add		rsp,[plusRsp]   ;add rsp,32    
    
    cmp     rax,1                  
    jl      elementoInvalido

    cmp     qword[elemento],-99    
    jl      elementoInvalido        
    cmp     qword[elemento],99    
    jg      elementoInvalido               

    mov     byte[esValido],'S'

    mov     rbx,qword[posicionVector]
    mov     rdx,qword[elemento]
    
    mov     qword[matrices+rbx],rdx

    ret

elementoInvalido:
    mov     rdi,msjElementoInvalido
    call    puts
ret

menuDeOpciones:
    mov     rdi,msjOpciones
    call    puts
    mov     rdi,opcionUno
    call    puts
    mov     rdi,opcionDos
    call    puts
    mov     rdi,opcionTres
    call    puts
    mov     rdi,opcionCuatro
    call    puts
    mov     rdi,opcionCinco
    call    puts

    mov     rdi,inputOpcion
    call    gets

    call    validarOpcion

    cmp     qword[opcion],1                   
    je      restaDeMatrices

    cmp     qword[opcion],2
    je      igualdadDeMatrices

    cmp     qword[opcion],3
    je      matrizPorEscalar

    cmp     qword[opcion],4
    je      modificiarValorDeMatriz

    cmp     qword[opcion],5
    je      consultarValorDeMatriz

ret

validarOpcion:
    mov     byte[esValido],'N'

    mov     rdi,inputOpcion 
    mov     rsi,formatoInputNumero
    mov     rdx,opcion

    call    checkAlign
    sub     rsp,[plusRsp]
    call    sscanf  
    add		rsp,[plusRsp]   ;add rsp,32  

    cmp     rax,1                   
    jl      opcionInvalida

    cmp     qword[opcion],1    
    jl      opcionInvalida        
    cmp     qword[opcion],5    
    jg      opcionInvalida

    mov     byte[esValido],'S'   

ret

opcionInvalida:
    mov     rdi,msjOpcionInvalida
    call    puts
    jmp     menuDeOpciones
ret

restaDeMatrices:
    mov     rdi,msjCuantasMatrices
    call    puts

    mov     rdi,inputCantMatricesRestar
    call    gets

    call    validarCantMatricesRestar

    mov     rdi,msjCualesMatricesRestar
    call    puts

    ;call    imprimirMatrices

    mov     qword[posicionVector],0

    sub     rcx,rcx
    mov     rcx,qword[cantMatricesRestar]

ingresoMatricesARestar:
    mov     qword[auxiliarMatrices],rcx
    mov     rdi,inputNumMatRestar
    call    gets

    call    validarNumMatRestar

    mov     rcx,qword[auxiliarMatrices]
    dec     rcx
    jnle     ingresoMatricesARestar

resta:



ret

validarNumMatRestar:
    mov     byte[esValido],'N'

    mov     rdi,inputNumMatRestar 
    mov     rsi,formatoInputNumero
    mov     rdx,numMatRestar

    call    checkAlign
    sub     rsp,[plusRsp]

    call    sscanf  
    add		rsp,[plusRsp]   ;add rsp,32               
    cmp     rax,1                   
    jl      numMatRestarInvalido

    cmp     qword[numMatRestar],1    
    jl      numMatRestarInvalido    
    mov     rcx,qword[cantMatricesRestar]    
    cmp     qword[numMatRestar],rcx 
    jg      numMatRestarInvalido

    mov     rdx,qword[numMatRestar]
    mov     rbx,qword[posicionVector]
    mov     qword[matricesRestar+rbx],rdx
    inc     qword[posicionVector]
    imul    rbx,qword[posicionVector],8
    mov     qword[posicionVector],rbx

    mov     byte[esValido],'S'
ret

numMatRestarInvalido:
    mov     rdi,msjNumeroDeMatrizInvalido
    call    puts
    ;jmp     ingresoMatricesARestar
    ;call     restaDeMatrices
ret

validarCantMatricesRestar:
    mov     byte[esValido],'N'

    mov     rdi,inputCantMatricesRestar 
    mov     rsi,formatoInputNumero
    mov     rdx,cantMatricesRestar

    call    checkAlign
    sub     rsp,[plusRsp]

    call    sscanf  
    add		rsp,[plusRsp]   ;add rsp,32  

    cmp     rax,1                   
    jl      cantMatricesRestarInvalido

    cmp     qword[cantMatricesRestar],2    
    jl      cantMatricesRestarInvalido    
    mov     rcx,qword[cantMatrices]    
    cmp     qword[cantMatricesRestar],rcx 
    jg      cantMatricesRestarInvalido

    mov     byte[esValido],'S'
ret

cantMatricesRestarInvalido:
    mov     rdi,msjIngCantMatricesRestarInvalido
    call    puts
    jmp     restaDeMatrices
ret

igualdadDeMatrices:
ret

matrizPorEscalar:
ret

modificiarValorDeMatriz:
ret

consultarValorDeMatriz:
ret
    
imprimirMatrices:

	mov rax, 0
	mov rdi, msjMostrarMatriz
	sub rsp, 8
	call printf
	add rsp, 8

    sub rbx,rbx
    mov rbx,0

    sub rcx,rcx
    mov rcx,qword[cantMatrices]

imprimir:
    mov qword[auxiliarMatrices],rcx

    sub rcx,rcx
    mov cx,word[fila]

loopImprimirFilas:
    mov     qword[auxiliarFila],rcx
    sub     rcx,rcx
    mov     cx,word[columna]

loopImprimirElementoCol:
    mov     qword[auxiliarCol],rcx

    mov     rax,qword[matrices+rbx]
    mov     qword[elemento],rax

    mov     rdi,msjElementoMatriz
    mov     rsi,qword[elemento]
    
    sub rsp, 8
	call printf
	add rsp, 8

    inc     qword[auxiliarImprimir]
    imul    rbx,qword[auxiliarImprimir],8

    mov     rcx,qword[auxiliarCol]
    dec     rcx
    jnz     loopImprimirElementoCol

    mov     rdi,msjNewLine
    call    puts

    mov     rcx,qword[auxiliarFila]
    dec     rcx
    jnz     loopImprimirFilas

    mov     rdi,msjNewLine
    call    puts

    mov     rcx,qword[auxiliarMatrices]
    dec     rcx
    jnz     imprimir

ret

;--------------------------------------------------------
;           CheckAlign
;--------------------------------------------------------
checkAlign:
	push rax
	push rbx
;	push rcx
	push rdx
	push rdi

	mov   qword[plusRsp],0
	mov		rdx,0

	mov		rax,rsp		
	add     rax,8		;para sumar lo q restó la CALL 
	add		rax,32	;para sumar lo que restaron las PUSH
	
	mov		rbx,16
	idiv	rbx			;rdx:rax / 16   resto queda en RDX

	cmp     rdx,0		;Resto = 0?
	je		finCheckAlign
;mov rdi,msj
;call puts
	mov   qword[plusRsp],8
finCheckAlign:
	pop rdi
	pop rdx
;	pop rcx
	pop rbx
	pop rax
	ret