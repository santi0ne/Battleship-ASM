;macros

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
    
    

.model small
.data
         
msgBienv db '-------------------------------------------------',10,13 
         db '------------------Batalla naval------------------',10,13 
         db '-------------------------------------------------',10,13 
         db '                  Instrucciones:                 ',10,13  
         db '                                                 ',10,13
         db '1.-                                              ',10,13 
         db 'Presiona cualquier tecla para empezar a jugar    ',10,13,'$'
         
msgCarga db '-------------------------------------------------',10,13 
         db '-------------------------------------------------',10,13 
         db '-------------------------------------------------',10,13 
         db '---------------Cargando tablero...---------------',10,13   
         db '-------------------------------------------------',10,13
         db '-------------------------------------------------',10,13 
         db '-------------------------------------------------',10,13,'$'
           
  
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

;variables del portaviones        
tamanioPort dw 5 
ubicacionPort db 0,0,0,0,0  

;variables del crucero        
tamanioCruc dw 4 
ubicacionCruc db 0,0,0,0  

;variables del submarino        
tamanioSub dw 3 
ubicacionSub db 0,0,0  

var1x db 0   ;para guardar coordenada x que se pasara al macro obtenerIndice
var2y db 0   ;para guardar coordenada y que se pasara al macro obtenerIndice
var3o db 0   ;para guardar si un navio estara horizontal o vertical
var4s db 0   ;para guardar salto en la tabla (dependiendo si es horizontal o vertical)  

coordxy db 23d ;indice inicial (coordenada 0,0) 
        
.code   

.startup 

imprimir msgBienv

;ingreso de enter para empezar juego
mov ah,01h   
int 21h
            
borrarPantalla
imprimir msgCarga


mov ax,0
mov bx,0
mov cx,0 

 
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

mov bl,ubicacionPort[0]
mov tablero[bx],'P' 
mov bl,ubicacionPort[1]
mov tablero[bx],'P'
mov bl,ubicacionPort[2]
mov tablero[bx],'P'
mov bl,ubicacionPort[3]
mov tablero[bx],'P'
mov bl,ubicacionPort[4]
mov tablero[bx],'P'   



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


mov si, offset ubicacionCruc 
mov cx,4  
loopCruc: 
mov bl,[si] 
cmp tablero[bx],'-' 
jnz  ubicarCrucero:
inc si
loop loopCruc:  
                                                             
mov bl,ubicacionCruc[0]
mov tablero[bx],'C' 
mov bl,ubicacionCruc[1]
mov tablero[bx],'C'
mov bl,ubicacionCruc[2] 
mov tablero[bx],'C'  
mov bl,ubicacionCruc[3] 
mov tablero[bx],'C'

 
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

mov si, offset ubicacionSub 
mov cx,3  
loopSub: 
mov bl,[si] 
cmp tablero[bx],'-' 
jnz  ubicarSubmarino:
inc si
loop loopSub:  

mov bl,ubicacionSub[0]
mov tablero[bx],'S' 
mov bl,ubicacionSub[1]
mov tablero[bx],'S'
mov bl,ubicacionSub[2] 
mov tablero[bx],'S'
  

borrarPantalla
imprimir tablero

