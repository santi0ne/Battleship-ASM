

;-----------------------------------Macros------------------------------------------

;imprimir cualquier cadena de caracteres terminado en $
imprimir macro t
    lea dx, t
    mov ah, 09h
    int 21h    
endm 
    
;borrar contenido de pantalla
borrarPantalla macro
    mov ah,0Fh
    int 10h
    mov ah,0
    int 10h 
endm
    
    
generarNumAleatorio macro n
   mov ah, 00h       
   int 1Ah            
   mov  ax, dx
   xor  dx, dx
   mov  cx, n    
   div  cx 
      
endm 
      
;obtener indice de la cadena tablero a partir de las coordenadas x y
obtenerIndice macro x,y      
    mov al, 2
    mov bl, x
    mul bx
    add coordxy, al
    
    mov al, 19
    mov bl,y
    mul bx
    add coordxy,al    
endm

;obtener coordenadas de ubicacion de un navio, y guardarlas dentro de su array de ubicacion
obtenerUbicacion macro c,u,t,p,l
    
    mov si, offset u 
    mov dl,c 
    mov cx,t  
    l1+l: 
    mov [si],dl 
    add dl,p 
    inc si
    loop l1+l
            
endm  

obtenerCoordenadaDisparo macro c,u,t,p
    
    mov si, offset u 
    mov dl,c  
    mov [si],dl 
            
endm 


convertirNumero macro   
 
    conversion:   
    mov ah,00h 
    mov bl, 10   
    div bl       
    mov dh, ah     
    mov dl, al   
    mov ah, 00h  
    mov al, dh   
    push ax      
    mov ax, 0000h  
    mov al, dl   
    add contador, 1
    cmp dl, 0    
    jnz conversion
  
                               
endm

mostrarNumero macro 
    
    mostrar: 
    sub contador, 1    
    pop ax       
    mov ah, 02h  
    mov dl, al       
    add dl, 30h  
    int 21h      
    cmp contador, 0    
    jz mostrar 
    
endm

verificarEstadoFlota macro u,d,t,n
    
    cmp d,0 
    jz embarcacionCaida+n 
    imprimir estado1
    jnz salir+n
    
    embarcacionCaida+n: 
    imprimir estado3
    add embarcacionesHundidas,1  
    
    mov si, offset u
    mov cx,t  
    flota+n:
    mov bl,[si] 
    mov tablero[bx],'X' 
    inc si
    loop flota+n
     
    salir+n:    
    
endm 

validarCoordX macro x
    
    cmp x,41h
    jz salidax  
    
    cmp x,42h
    jz salidax
    
    cmp x,43h
    jz salidax
    
    cmp x,44h
    jz salidax
    
    cmp x,45h
    jz salidax
    
    cmp x,46h
    jz salidax
    
    cmp x,47h
    jz salidax
              
              
    imprimir espacio
    imprimir msgCoordError
    reingresarCoordenada1:
    mov ah,07h   
    int 21h 
    cmp al,0dh 
    jnz reingresarCoordenada1
    jmp pedirCoordenadas
      
    salidax: 
    
endm 

validarCoordY macro y
    
    cmp y,31h
    jz saliday  
    
    cmp y,32h
    jz saliday
    
    cmp y,33h
    jz saliday
    
    cmp y,34h
    jz saliday
    
    cmp y,35h
    jz saliday
    
    cmp y,36h
    jz saliday
    
    cmp y,37h
    jz saliday
              
              
    imprimir espacio
    imprimir msgCoordError
    reingresarCoordenada2:
    mov ah,07h   
    int 21h 
    cmp al,0dh 
    jnz reingresarCoordenada2
    jmp pedirCoordenadas
      
    saliday: 
    
endm 

verificarSiCoordNueva macro c,l
      
    mov si, offset l
    mov cx,21  
    verifCoord:
    mov bl,[si] 
    cmp bl,c
    jz  pedirNueva
    jnz terminar
    terminar: 
    inc si 
    loop verifCoord 
    jmp salida
    
    pedirNueva: 
    imprimir espacio
    imprimir msgCoordRepet
    reingresarCoordenada3:
    mov ah,07h   
    int 21h 
    cmp al,0dh 
    jnz reingresarCoordenada3
    jmp pedirCoordenadas 
    
    salida:
    

endm
    

.model small
.data 

;-----------------------------Datos y variables----------------------------------
         
msgBien1 db '-------------------------------------------------',10,13 
         db '-------------------Battleship--------------------',10,13 
         db '-------------------------------------------------',10,13 
         db '                  Instrucciones:                 ',10,13  
         db '                                                 ',10,13
         db '  Tu mision es derribar todas las embarcaciones  ',10,13
         db '                   del enemigo!                  ',10,13
         db '                                                 ',10,13
         db '    1. Se presentara un tablero de 7x7 celdas    ',10,13
         db '                     enemiga.                    ',10,13
         db '                                                 ',10,13 
         db ' 2. Debes ingresar las coordenadas donde quieres ',10,13
         db '     disparar un misil. Ejemplo: Coordenada D5   ',10,13
         db '                                                 ',10,13
         db '                   A B C D E F G                 ',10,13   
         db '                 1 - - - - - - -                 ',10,13
         db '                 2 - - - - - - -                 ',10,13
         db '                 3 - - - - - - -                 ',10,13
         db '                 4 - - - - - - -                 ',10,13
         db '                 5 - - - X - - -                 ',10,13
         db '                 6 - - - - - - -                 ',10,13
         db '                 7 - - - - - - -                 ',10,13,
         db '                                                 ',10,13
         db '         Presiona ENTER para continuar ->        ',10,13,'$' 
         

msgBien2 db '                                                 ',10,13
         db '3. Si tu misil le da a una embarcacion enemiga la',10,13
         db '  coordenada cambiara a un 1, caso contrario se  ',10,13
         db '                  marcara con un 0.              ',10,13
         db '                                                 ',10,13
         db '  4. Tendras 21 misiles para acabar con la flota ',10,13
         db '   enemiga formada por un Portaviones (5 celdas) , ',10,13 
         db '  un Crucero(4 celdas) y un Submarino (3 celdas) ',10,13
         db '                                                 ',10,13
         db '                  Buena suerte!!!                ',10,13
         db '                                                 ',10,13
         db ' NOTA: Presiona CTRL+E en cualquier momento para ',10,13
         db '                 salir del juego.                ',10,13
         db '                                                 ',10,13 
         db '      Presiona ENTER para empezar a jugar        ',10,13,'$'
         
msgCarga db '-------------------------------------------------',10,13 
         db '-------------------------------------------------',10,13 
         db '-------------------------------------------------',10,13
         db '-------------------------------------------------',10,13 
         db '-------------------------------------------------',10,13 
         db '-------------------------------------------------',10,13 
         db '--------------- Generando tablero ---------------',10,13
         db '-------------------------------------------------',10,13 
         db '-------------------------------------------------',10,13 
         db '-------------------------------------------------',10,13   
         db '-------------------------------------------------',10,13
         db '-------------------------------------------------',10,13 
         db '-------------------------------------------------',10,13,'$' 
         
msgBorr  db '-------------------------------------------------',10,13 
         db '-------------------------------------------------',10,13 
         db '-------------------------------------------------',10,13
         db '-------------------------------------------------',10,13 
         db '-------------------------------------------------',10,13 
         db '-------------------------------------------------',10,13 
         db '------------- Preparando nuevo juego ------------',10,13
         db '-------------------------------------------------',10,13 
         db '-------------------------------------------------',10,13 
         db '-------------------------------------------------',10,13   
         db '-------------------------------------------------',10,13
         db '-------------------------------------------------',10,13 
         db '-------------------------------------------------',10,13,'$'
         
msgFin   db '-------------------------------------------------',10,13 
         db '-------------------------------------------------',10,13 
         db '-------------------------------------------------',10,13
         db '-------------------------------------------------',10,13 
         db '-------------------------------------------------',10,13 
         db '---------------- Cerrando juego.... -------------',10,13 
         db '-------------------------------------------------',10,13
         db '-------------- Gracias por jugar  :) ------------',10,13 
         db '-------------------------------------------------',10,13 
         db '-------------------------------------------------',10,13   
         db '-------------------------------------------------',10,13
         db '-------------------------------------------------',10,13 
         db '-------------------------------------------------',10,13,'$'


cabecera db '-----------------------------------------------',10,13 
         db '----------------- Battleship ------------------',10,13 
         db '-----------------------------------------------',10,13 
         db '               Acabalos a todos!               ',10,13 
         db '                                               ',10,13
         db '                                               ',10,13,'$'
         

estado1  db '-----------------------------------------------',10,13
         db '           Estado: Impacto confirmado          ',10,13
         db '-----------------------------------------------',10,13
         db '                                               ',10,13
         db '          Presiona ENTER para continuar        ',10,13,'$'

estado2  db '-----------------------------------------------',10,13
         db '            Estado: Impacto fallido            ',10,13
         db '-----------------------------------------------',10,13
         db '                                               ',10,13
         db '          Presiona ENTER para continuar        ',10,13,'$'

estado3  db '-----------------------------------------------',10,13
         db '           Estado:Embarcacion hundida          ',10,13 
         db '-----------------------------------------------',10,13
         db '                                               ',10,13
         db '          Presiona ENTER para continuar        ',10,13,'$'
         
msgGanador  db '-----------------------------------------------',10,13 
            db '      Derribaste toda la flota enemiga!!!      ',10,13  
            db '                                               ',10,13
            db '                  Ganaste!!!                   ',10,13
            db '-----------------------------------------------',10,13
            db '                                               ',10,13
            db '                                               ',10,13
            db '        Pulsa ENTER para jugar de nuevo        ',10,13
            db '                                               ',10,13
            db '       Pulsa CTRL+E para salir del juego       ',10,13,'$'
             

msgPerdedor db '-----------------------------------------------',10,13 
            db '            Te quedaste sin misiles            ',10,13  
            db '                                               ',10,13
            db '                  Perdiste :(                  ',10,13
            db '-----------------------------------------------',10,13
            db '                                               ',10,13 
            db '                                               ',10,13
            db '        Ubicacion de las embarcaciones         ',10,13 
            db '                                               ',10,13
            db '       P=Portaviones C=Crucero S=Submarino     ',10,13
            db '                                               ',10,13,'$'
            
msgPerdedor2 db '                                               ',10,13
             db '         Pulsa ENTER para jugar de nuevo       ',10,13
             db '                                               ',10,13
             db '        Pulsa CTRL+E para salir del juego      ',10,13,'$'
            
         
espacio db 10,13,'$'
        
                                                      
tablero db 09,09,'  A B C D E F G',10,13   
        db 09,09,'1 - - - - - - -',10,13
        db 09,09,'2 - - - - - - -',10,13
        db 09,09,'3 - - - - - - -',10,13
        db 09,09,'4 - - - - - - -',10,13
        db 09,09,'5 - - - - - - -',10,13
        db 09,09,'6 - - - - - - -',10,13
        db 09,09,'7 - - - - - - -',10,13,'$' 
        
;la tabla tiene indices del 0 al 6 en filas y columnas, donde la coordenada A1 
;dentro de la cadena de caracteres 'tablero' es igual a 23. Por lo que para acceder a una
;coordenada de la tabla se debe seguir el calculo tablero[23+2(x)+19(y)] donde 'x' es el 
;indice de las filas,y 'y' es el indice de columna. 
        
;ejemplo: para acceder a la coordenada C4, se necesita el indice 2,3 de la tabla, y se debe 
;acceder al indice de la cadena 'tablero' con la operacion 23+2(2)+19(3)=84. En resumen el 
;indice de 2,3 de la tabla es igual a tablero[84].
        
        
tableroCopia db 09,09,'  A B C D E F G',10,13   
             db 09,09,'1 - - - - - - -',10,13
             db 09,09,'2 - - - - - - -',10,13
             db 09,09,'3 - - - - - - -',10,13
             db 09,09,'4 - - - - - - -',10,13
             db 09,09,'5 - - - - - - -',10,13
             db 09,09,'6 - - - - - - -',10,13
             db 09,09,'7 - - - - - - -',10,13,'$' 
             
;variables de coordenadas que ingresa el usuario             
ingresoCoordUser1 db 10,13 
                  db 'Misil ','$'

ingresoCoordUser2 db ', ingresar celda a atacar (Ejemplo A4): ','$' 

msgCoordError db '                                                 ',10,13
              db '              Coordenada no valida!              ',10,13
              db '                                                 ',10,13
              db '    Presiona ENTER para reingresar coordenada    ','$' 
              
msgCoordRepet db '                                                 ',10,13
              db '             Coordenada ya ingresada             ',10,13
              db '                                                 ',10,13
              db '    Presiona ENTER para reingresar coordenada    ','$'
              
msgEspera  db '                                                 ',10,13
           db '            Calculando trayectoria...            ',10,13,'$'
                            

cxMisiles db 1    ;se utiliza como contador de misiles y turnos
coordenadaUser db 0,0,0 
turnosJuego db 21

;variables del portaviones        
tamanioPort dw 5 
ubicacionPort db 0,0,0,0,0 
disparosPort db 5 

;variables del crucero        
tamanioCruc dw 4 
ubicacionCruc db 0,0,0,0 
disparosCruc db 4  

;variables del submarino        
tamanioSub dw 3 
ubicacionSub db 0,0,0
disparosSub db 3  

embarcacionesHundidas db 0 

var1x db 0   ;para guardar coordenada x que se pasara al macro obtenerIndice
var2y db 0   ;para guardar coordenada y que se pasara al macro obtenerIndice
var3o db 0   ;para guardar si un navio estara horizontal o vertical
var4s db 0   ;para guardar salto en la tabla (dependiendo si es horizontal o vertical)  

coordxy db 23d ;indice inicial (coordenada 0,0)

contador db 0 

coordenadasIngresadas db 21 dup (0)
contadorC db 0 
        
.code   

.startup 
    
;-----------------------------Pantalla de bienvenida----------------------------------

inicio: 

borrarPantalla
imprimir msgBien1 

;ingreso de tecla para segunda pantalla de bienvenida
cambiarPantalla1:  ;cambiarPantallaX sirve para saber si el jugador quiere seguir o salir del juego
mov ah,07h   
int 21h   
cmp al,05h         ;verificar si el usuario ingreso CTRL+E
jz cerrarJuego
cmp al,0dh         ;verificar si el usuario ingreso ENTER
jnz cambiarPantalla1

borrarPantalla   
imprimir msgBien2

;ingreso de tecla para empezar juego
cambiarPantalla2:
mov ah,07h   
int 21h
cmp al,05h
jz cerrarJuego 
cmp al,0dh 
jnz cambiarPantalla2

           
borrarPantalla
imprimir msgCarga


;------------------------Ubicacion aleatoria de embarcaciones--------------------------

mov ax,0
mov bx,0
mov cx,0 

;PORTAVIONES
 
;se ubica el portaviones de forma aleatoria
ubicarPortaviones: 
mov coordxy,23d
mov ax,0
mov bx,0
mov cx,0
mov dx,0 

;obtener de forma aleatoria si el portaviones sera horizontal o vertical
generarNumAleatorio 2 
mov var3o,dl

cmp var3o,0
jz portHorizontal
jnz portVertical


;si el portaviones estara sera horizontal
portHorizontal:
mov var4s,2
generarNumAleatorio 3
mov var1x, dl  
generarNumAleatorio 7
mov var2y, dl
jmp generarUbicacionPort

;si el portaviones estara sera vertical
portVertical:
mov var4s,19
generarNumAleatorio 7
mov var1x, dl  
generarNumAleatorio 3
mov var2y, dl
jmp generarUbicacionPort 

 
;se genera la ubicacion del portaviones dependiendo de si es vertical u horizontal
generarUbicacionPort:    
obtenerIndice var1x,var2y
mov bx,tamanioPort 
obtenerUbicacion coordxy,ubicacionPort,bx,var4s,p

;se ubica el portaviones en una copia del tablero
mov bl,ubicacionPort[0]
mov tableroCopia[bx],'P'
 
mov bl,ubicacionPort[1]
mov tableroCopia[bx],'P'

mov bl,ubicacionPort[2]
mov tableroCopia[bx],'P'

mov bl,ubicacionPort[3]
mov tableroCopia[bx],'P'

mov bl,ubicacionPort[4]
mov tableroCopia[bx],'P'   



;CRUCERO 
 
;se ubica el crucero de forma aleatoria
ubicarCrucero: 
mov coordxy,23d
mov ax,0
mov bx,0
mov cx,0
mov dx,0 

;obtener de forma aleatoria si el crucero sera horizontal o vertical
generarNumAleatorio 2 
mov var3o,dl

cmp var3o,0
jz crucHorizontal
jnz crucVertical


;si el crucero estara sera horizontal
crucHorizontal:
mov var4s,2
generarNumAleatorio 4
mov var1x, dl  
generarNumAleatorio 7
mov var2y, dl
jmp generarUbicacionCruc

;si el crucero estara sera vertical
crucVertical:
mov var4s,19
generarNumAleatorio 7
mov var1x, dl  
generarNumAleatorio 4
mov var2y, dl
jmp generarUbicacionCruc 

 
;se genera la ubicacion del crucero dependiendo de si es vertical u horizontal
generarUbicacionCruc:    
obtenerIndice var1x,var2y
mov bx,tamanioCruc 
obtenerUbicacion coordxy,ubicacionCruc,bx,var4s,c 

;se valida que ninguna ubicacion de crucero choque con ubicaciones ocupadas
mov si, offset ubicacionCruc 
mov cx,4  
loopCruc: 
mov bl,[si] 
cmp tableroCopia[bx],'-' 
jnz  ubicarCrucero:
inc si
loop loopCruc:  

;se ubica el crucero en una copia del tablero                                                             
mov bl,ubicacionCruc[0]
mov tableroCopia[bx],'C'
 
mov bl,ubicacionCruc[1]
mov tableroCopia[bx],'C'

mov bl,ubicacionCruc[2] 
mov tableroCopia[bx],'C'
  
mov bl,ubicacionCruc[3] 
mov tableroCopia[bx],'C'


;SUBMARINO
 
;se ubica el submarino de forma aleatoria
ubicarSubmarino:   
mov coordxy,23d
mov ax,0
mov bx,0
mov cx,0
mov dx,0  

;obtener de forma aleatoria si el submarino sera horizontal o vertical
generarNumAleatorio 2 
mov var3o,dl

cmp var3o,0
jz subHorizontal
jnz subVertical


;si el submarino estara sera horizontal
subHorizontal:
mov var4s,2
generarNumAleatorio 5
mov var1x, dl  
generarNumAleatorio 7
mov var2y, dl
jmp generarUbicacionSub

;si el submarino estara sera vertical
subVertical:
mov var4s,19
generarNumAleatorio 7
mov var1x, dl  
generarNumAleatorio 5
mov var2y, dl
jmp generarUbicacionSub 

 
;se genera la ubicacion del submarino dependiendo de si es vertical u horizontal
generarUbicacionSub:    
obtenerIndice var1x,var2y
mov bx,tamanioSub 
obtenerUbicacion coordxy,ubicacionSub,bx,var4s,s

;se valida que ninguna ubicacion de crucero choque con ubicaciones ocupadas
mov si, offset ubicacionSub 
mov cx,3  
loopSub: 
mov bl,[si] 
cmp tableroCopia[bx],'-' 
jnz  ubicarSubmarino:
inc si
loop loopSub:  


;se ubica el portaviones en una copia del tablero
mov bl,ubicacionSub[0]
mov tableroCopia[bx],'S'
 
mov bl,ubicacionSub[1]
mov tableroCopia[bx],'S'

mov bl,ubicacionSub[2] 
mov tableroCopia[bx],'S'


;-----------------------------Logica del juego----------------------------------

mov ax,0
mov bx,0 
mov cx,0 
mov dx,0

mov var1x,0
mov var2y,0 

  
loopJuego: 

pedirCoordenadas:
borrarPantalla 
imprimir cabecera
imprimir tablero

;impresion de linea con mensaje para pedir una coordenada 
imprimir ingresoCoordUser1 
mov al,cxMisiles
convertirNumero           ;convertir numero del misil por lanzar
mostrarNumero             ;mostrar numero del misil por lanzar
imprimir ingresoCoordUser2 

;se obtiene indicie de tablero donde caera el misil


;validacion de ingreso de coordenada x
CoordX:
mov ah,01h   
int 21h
cmp al,05h
jz cerrarJuego
validarCoordX al 
mov coordenadaUser[0], al 

;validacion de ingreso de coordenada y
CoordY:
mov ah,01h   
int 21h 
cmp al,05h
jz cerrarJuego
validarCoordY al 
mov coordenadaUser[1], al

imprimir espacio
imprimir msgEspera

;Obtencion de indice del tablero  
mov dl,coordenadaUser[0]
sub dl,41h
mov var1x,dl

mov dl,coordenadaUser[1]
sub dl,31h
mov var2y,dl 

mov coordxy,23d 

obtenerIndice var1x,var2y

;validar si la coordenada ya ha sido ingresada o no
verificarSiCoordNueva  coordxy,coordenadasIngresadas

 
;agregar coordenada nueva a las ya ingresadas
mov bl,contadorC 
mov al,coordxy
mov coordenadasIngresadas[bx],al
add contadorC,1 

mov bx,0
mov ax,0
mov bl,coordxy

add cxMisiles,1 
sub turnosJuego,1

 
;verificar si el disparo acerto o no
cmp tableroCopia[bx],'-'
jz disparoNoAcertado 
jnz disparoAcertado


;si acierta: 
disparoAcertado:

;verificar si el submarino se hundio
verificarSub:
cmp tableroCopia[bx],'S'
jz submarinoAlcanzado 
jnz verificarCruc
 
submarinoAlcanzado:
mov tablero[bx],'1'
sub disparosSub,1 
verificarEstadoFlota ubicacionSub,disparosSub,3,1
jmp salirDisparo  


;verificar si el crucero se hundio
verificarCruc:
cmp tableroCopia[bx],'C'
jz cruceroAlcanzado
jnz verificarPort 

cruceroAlcanzado:
mov tablero[bx],'1'
sub disparosCruc,1 
verificarEstadoFlota ubicacionCruc,disparosCruc,4,2
jmp salirDisparo  


;verificar si el portavion se hundio
verificarPort:
cmp tableroCopia[bx],'P'
jz portavionesAlcanzado

portavionesAlcanzado:
mov tablero[bx],'1'
sub disparosPort,1 
verificarEstadoFlota ubicacionPort,disparosPort,5,3
jmp salirDisparo
              
              
;si el disparo no acierta
disparoNoAcertado: 
mov tablero[bx],'0'
imprimir estado2
jmp salirDisparo 


;verifica si las 3 embarcaciones se hundieron
salirDisparo:
cmp embarcacionesHundidas,3
jz terminarJuego  

;caso contrario el juego sigue
cambiarPantalla3:
mov ah,07h   
int 21h
cmp al,05h
jz cerrarJuego 
cmp al,0dh 
jnz cambiarPantalla3 

cmp turnosJuego,0
jnz loopJuego 
jmp juegoPerdido


;si el jugador gana
terminarJuego:

cambiarPantalla4:
mov ah,07h   
int 21h
cmp al,05h
jz cerrarJuego 
cmp al,0dh 
jnz cambiarPantalla4  

borrarPantalla
imprimir msgGanador

mov ah,07h  
int 21h 
cmp al,05h 
jz cerrarJuego  
jmp salir 


;si el jugador pierde
juegoPerdido:

;se presentan las ubicaciones de las embarcaciones
mov si, offset ubicacionSub
mov cx,3  
respuesta1:
mov bl,[si] 
mov tablero[bx],'S' 
inc si
loop respuesta1   

mov si, offset ubicacionCruc
mov cx,4  
respuesta2:
mov bl,[si] 
mov tablero[bx],'C' 
inc si
loop respuesta2

mov si, offset ubicacionPort
mov cx,5  
respuesta3:
mov bl,[si] 
mov tablero[bx],'P' 
inc si
loop respuesta3

borrarPantalla
imprimir msgPerdedor
imprimir tablero
imprimir msgPerdedor2

cambiarPantalla5:
mov ah,07h   
int 21h 
cmp al,05h
jz cerrarJuego 
cmp al,0dh
jnz cambiarPantalla5
jmp salir

salir: 

borrarPantalla
imprimir msgBorr

;limpieza de datos

mov si, offset ubicacionSub
mov cx,3  
limpieza1:
mov bl,[si] 
mov tablero[bx],'-' 
mov tableroCopia[bx],'-'
mov [si],0 
inc si
loop limpieza1   

mov si, offset ubicacionCruc
mov cx,4  
limpieza2:
mov bl,[si] 
mov tablero[bx],'-'
mov tableroCopia[bx],'-'
mov [si],0 
inc si
loop limpieza2

mov si, offset ubicacionPort
mov cx,5  
limpieza3:
mov bl,[si] 
mov tablero[bx],'-'
mov tableroCopia[bx],'-'
mov [si],0 
inc si
loop limpieza3

mov si, offset coordenadasIngresadas
mov cx,21  
limpieza4:
mov bl,[si]
cmp bl,0
jz terminarLimp
jnz limpiar

limpiar: 
mov tablero[bx],'-'
mov tableroCopia[bx],'-'
mov [si],0 
inc si
loop limpieza4 
terminarLimp: 

mov disparosPort, 5
mov disparosCruc, 4 
mov disparosSub, 3 
mov embarcacionesHundidas, 0 
mov turnosJuego, 21
mov cxMisiles, 1
mov coordxy,23d  
mov contador, 0 
mov contadorC, 0 

mov ax,0
mov bx,0 
mov cx,0 
mov dx,0
mov sp,0
mov bp,0
mov si,0
mov di,0

jmp inicio

 
;si el jugadro presiona CTRL+E 
cerrarJuego:

borrarPantalla
imprimir msgFin 

mov cx,100
espera:
sub cx,1
cmp cx,0
jnz espera

end