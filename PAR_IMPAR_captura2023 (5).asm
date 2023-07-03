.model small        ;modelo de memoria
.data               ;comienzo del segmento de datos
var1 db ?           
msg1 db 'INGRESE UN NUMERO: $'
msg2 db ' EL NUMERO INGRESADO ES PAR $'
msg3 db ' EL NUMERO INGRESADO ES IMPAR $'
.code               ;comienzo del segmento de codigo
.start              ;inicio de las instrucciones

mov ah, 09h         ;funcion para mostrar cadena de caracteres
lea dx, msg1        ;load efective address---> coloca contenido de variable msg1 en dx 
int 21h             ;interrupcion para mostrar contenido de dx en pantalla
mov ah, 01h         ;funcion para captura de dato
int 21h             ;interrupcion para captura de dato (ASCII), se almacena en al
sub al, 30h         ;convertir codigo ASCII capturado al valor ingresado por el usuario
mov var1, al
jmp par_impar

par_impar:
mov ax, 0
mov al, var1
mov bl, 2
div bl
cmp ah, 0
je  msg_par
jne msg_impar 

msg_par:
mov ah,09h
lea dx,msg2
int 21h
jmp salir

msg_impar:
mov ah,09h
lea dx,msg3
int 21h
jmp salir

salir:
.exit
end