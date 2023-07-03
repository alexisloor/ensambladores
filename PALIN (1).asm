;AUTORES: Adriana Murrieta, Andres Morales

.model small
.stack
.data
msg db "*****INGRESE MAXIMO 40 CARACTERES*****", "$"
msg2 db 13,10,13,10, 'Ingresa la palabra: ','$' ;mensaje de inicio
msg3 db 13,10,13,10, "DESEA INGRESAR OTRA PALABRA [1]SI O [2] NO: ", "$"
msg_err db 13,10, "CARACTER NO VALIDO", "$", 13,10   
nopalin db 13,10,13,10, "   >>>> LA PALABRA INGRESADA NO ES PALINDROMO <<<< $"
palin db 13,10,13,10, "   >>>> LA PALABRA INGRESADA ES PALINDROMO <<<< $"
cadena label byte ; se define la estructura de la cadena

campo db 40 dup (' ') ; Variable para guardar la cadena ingresada por teclado  
palabra db 40 dup('') ; Variable para guardar la cadena sin signos especiales                       


.code
.startup

mov ax,@data ;respalda los datos a introducir en
mov ds,ax ;los registros ds y es para que no se pierdan
push ds ;durante las instrucciones siguientes
pop es     
mov ah,09h ;peticion para mostrar mensaje
lea dx,msg  ;Muestra el mensaje inicial
int 21h      ; Interrupcion para mostar el mensaje


main:  ;inicia el programma
mov ah,09h ;peticion para mostrar mensaje
lea dx,msg2   ; Carga en dx el mensaje para pedir una cadena
int 21h        ;Interrupcion para imprimir el mensaje

mov ah,0ah ;peticion para introducir cadena
mov dx,offset cadena ;carga en dx la direccion de cadena
int 21h               ;interrupcion para ingresar el texto del mensaje

lea si,campo+2 ;mandamos la cadena al registro si para empezar a evaluar 
mov di,00d             ;Iniciamos en cero el contador de caracteres para la palabra a evaluar
call elim_espacio       ; Salta a eliminar los espacios de la cadena ingresada
          
          
elim_espacio: ;verifica si el caracter es espacio para descartarlo
mov al,[si]   ;movemos el caracter de si a al
cmp al,20h    ;verifica si es caracter o es espacio
jne elim_coma ;si es caracter, salta a elim_coma
inc si        ;suma 1 a la variable si 
jmp elim_espacio ;salta a elim_espacio  
  
  
elim_coma:   ;verifica si el caracter es coma para descartarlo
mov al,[si]  ;movemos el caracter de si a al
cmp al,2Ch   ;verifica si es caracter o es coma
jne elim_punto ;si es caracter, salta a elim_punto
inc si       ;suma 1 a la variable si 
jmp elim_espacio  ;salta a elim_espacio
  
  
elim_punto:   ;verifica si el caracter es punto para descartarlo
mov al,[si]   ;movemos el caracter de si a al
cmp al,2Eh ;verifica si es caracter o es espacio
jne elim_inte1 ;i es caracter, salta a elim_punto
inc si      ;suma 1 a la variable si 
jmp elim_espacio ;salta a elim_espacio
 
 
elim_inte1:  ;verifica si el caracter es signo de interrogacion para descartarlo
mov al,[si]  ;movemos el caracter de si a al
cmp al,3Fh ;verifica si es caracter o es signo de interrogacion
jne elim_excl1 ;si es caracter, salta a elim_espacio
inc si ;suma 1 a la variable si 
jmp elim_espacio ;salta a elim_espacio
  
  
elim_excl1: ;verifica si el caracter es signo de admiracion para descartarlo
mov al,[si]  ;movemos el caracter de si a al
cmp al,21h ;verifica si es caracter o signo de admiracion
jne elim_pyc ;si es caracter, salta a elim_pyc
inc si ;suma 1 a la variable si 
jmp elim_espacio ;salta a elim_espacio


elim_pyc:   ;verifica si el caracter es punto y coma para descartarlo
mov al,[si] ;movemos el caracter de si a al
cmp al,21h ;verifica si es caracter o es punto y coma
jne elim_dp ;si es caracter, salta a  elim_dp
inc si ;suma 1 a la variable si 
jmp elim_espacio ;salta a elim_espacio 
   
   
elim_dp:    ;verifica si el caracter son los dos puntos para descartarlo
mov al,[si]  ;movemos el caracter de si a al
cmp al,3Bh ;verifica si es caracter o dos puntos
jne mayus_minus ;si es caracter, salta a mayus_minus
inc si ;suma 1 a la variable si 
jmp elim_espacio ;salta a elim_espacio
   
   
mayus_minus:  ;Convierte toda la cadena ingresada a mayusculas
cmp al,122   ; Compara el caracter con el maximo valor ascii de un caracter en minuscula
ja disp       ;Si el caracter es mayor salta a disp

cmp al, 96     ;Compara el caracter con el minimo valor ascii de un caracter en minuscula
jng disp       ;Si el caracter es menor salta a disp

        
sub al, 32       ;Resta 32 a al para convertirla a mayuscula


disp:     ;Almacena la cadena sin simbolos especiales
mov palabra[di],al; Guarda en palabra el caracter contenido en al 

cmp al,0dh        ;Compara si es un enter
je set_cont       ;Si encuentra el enter salta a set_cont
inc si            ;Incrementa el contador de caracteres de la palabra ingresada
inc di            ;Incrementa el contador de caracteres para la palabra a evaluar 
jmp elim_espacio  ;Salta a eliminar_espacio para obtener otro caracter 


set_cont:   ; Modifica el valor de los contadores
dec di       ;decrementa di
mov si, 00h        ; Encera el contador de caracteres
jmp comparar       ;Salta a comparar


comparar:    ; Verifica si la palabra es palindroma 
mov al, palabra[di] ;  mueve a al los caracteres almacenado en palabra de derecha a izquierda
cmp palabra[si],al   ; Compara el caracter guardado en al con el caracter de palabra  de izquierda a derecha
jnz no_palin          ;Si no son iguales salta a no es palindromo


cmp si,di          ; Compara si ambos contadores son iguales
jz si_palin        ; Si ambos son iguales la palabra es palindroma

cmp si+1,di        ;Compara el valor de los contadores para validar cuando la cantidad de caracteres de una palabra es par

inc si             ; Incrementa si
dec di             ; Decrementa di
jz pal_par         ;Salta a pal_par en caso de que la palabra sea par

jnz comparar       ; Si no son iguales sigue recorriendo la cadena 

pal_par:
mov al, palabra[di] ;  mueve a al los caracteres almacenado en palabra de derecha a izquierda
cmp palabra[si],al   ; Compara el caracter guardado en al con el caracter de palabra  de izquierda a derecha
jnz no_palin 
jz si_palin

no_palin:   ; Muestra el mensaje de que la palabra no es palindroma
mov ah,09h  ; peticion para mostrar mensaje
lea dx, nopalin  ;Carga en dx el mensaje guardado en nopalin
int 21h          ;Interrupcion para mostar el mensaje
jmp loop1        ;Salta a preguntar si quiere ingresar otra palabra


si_palin:   ; Muestra el mensaje de que la palabra es palindroma
mov ah,09h  ; peticion para mostrar mensaje
lea dx, palin ;Carga en dx el mensaje guardado en palin
int 21h       ;Interrupcion para mostar el mensaje
jmp loop1     ;Salta a preguntar si quiere ingresar otra palabra
   
                   
loop1:      ; Loop para pedir al usuario otra palabra o salir 
mov ah,09h   ; peticion para mostrar mensaje
lea dx,msg3  ; Carga en dx el mensaje guardado en nopalin
int 21h      ; Interrupcion para mostar el mensaje

mov ah,01h   ;Peticion para ingresar un caracter
int 21h      ;Interrupcion para pedir caracter      

cmp al,31h   ;Compara si ingreso 1
jz main      ;Si es asi vuelve a pedir que ingrese una palabra para validarla

cmp al,32h   ; Compara si ingreso 2
jz salir     ; si es asi sale del programa
jnz imp_Error ; si no es 1 ni 2 muestra un mensaje de error
  
  
imp_Error: ;muestra un mensaje de error
mov ah,09h ; peticion para mostrar mensaje
lea dx,msg_err ; Carga en dx el mensaje guardado en msg_err
int 21h       ; Interrupcion para mostar el mensaje
jmp loop1     ;Salta a preguntar si quiere ingresar otra palabra


salir:        ; Termina la ejecucion del programa

 

end