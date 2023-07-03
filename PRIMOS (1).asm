;PROGRAMA QUE MUESTRA n NUMEROS PRIMOS DESDE 1 HASTA n
;n ES UNA CIFRA DE 1 DIGITO INGRESADA POR EL USUARIO
.model small
.data
var1 db ?
var2 db ? 
var3 db ?
.stack
.code
.start up

mov ax,0000h
mov bx,0000h
mov cx,0000h

mov ah,01h
int 21h
sub al,30h
mov var2,al  
mov ax,0000h
mov al,1
mov var3,al
jmp convertir

valor:
mov ax,0000h
mov bx,0000h
mov cx,0000h
mov al,var3
add al,1
mov var3,al

calcular:
cmp al,ch
jnz dividir
mov al,var3
jz verificar

verificar:
cmp bh,2
jz convertir 
jnz valor

dividir:
add ch,1
div ch
cmp ah,0
jz aumentar
mov ah,00h 
mov al,var3
jnz calcular

aumentar:
add bh,1
mov al,var3
jmp calcular

convertir:
mov ah,00h
mov bl, 10   ;mueve 10 a bl
div bl       ;divide el contenido de ax para 10, el cociente se guarda en al y el residuo en ah
mov dh, ah   ;mueve el contenido de ah a dh  
mov dl, al   ;guarda el contenido de al en dl
mov ah, 00h  ;guarda 0 en ah
mov al, dh   ;mueve el contenido de dh a al
push ax      ;guarda el contenido de ax en la pila
mov ax, 0000h;guarda 0 en ax   
mov al, dl   ;guarda el cociente de la division en al
add cl, 1
cmp dl, 0    ;verifica si el cociente es 0
jnz convertir;si no se cumple lo anterior regresa a la etiqueta convertir
mov ah, 02h  ;esta linea y las 2 siguientes son para dejar un espacio entre cada numero ULAM
mov dl, 0h
int 21h
jz  mostrar  ;si dl es igual a 0 salta a la etiqueta mostrar
                               
mostrar:
sub cl, 1    ;decrementa cx en 1
pop ax       ;retira el ultimo valor ingresado en la pila y lo guarda en ax
mov ah, 02h  ;se coloca 02h en ah (funcion)
mov dl, al   ;se guarda el contenido de al en dl
add dl, 30h  ;se suma 30h a dl para obtener el caracter ascii correcto
int 21h      ;se llama a interrupcion 21h para mostrar el caracter por pantalla
cmp cl, 0    ;verifica si el contador llego a 1
jnz mostrar  ;si lo anterior no se cumple, salta a la etiqueta mostrar
jz comparar

comparar:  
add var1,1
mov ch,var2
cmp ch,var1
jnz valor 

