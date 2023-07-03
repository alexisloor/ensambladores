name "Factorial"  
            
mov ax, 05h  ;inicializacion de variables, en este caso se calcula el factorial de 5
             ;el valor inicial de ax puede ser cambiado segun se requiera
             ;valores de 7 en adelante causan desbordamiento al dividir para 10, porque
             ;el cociente resultante no cabe en 16 bits (RECOMIENDO MEJORARLO). 
mov cx, ax   ;guarda el valor de ax en cx

calcular:  
sub cx, 1    ;decrementa en 1 cx
mul cx       ;multiplica cx por ax y almacena el resultado en ax
cmp cx, 1    ;verifica si cx es igual a 1
jz  convertir;si cx es igual a 1 salta a la etiqueta convertir (NO SOLICITADO EN LA LECCION)
jnz calcular ;si cx no es igual a 1 salta a la etiqueta calcular 
             ;LO QUE SIGUE ES PARA MOSTRAR X PANTALLA EL FACTORIAL
             ;SE CONVIERTE Y MUESTRA DIGITO POR DIGITO, APLICANDO DIVISIONES SUCESIVAS PARA 10
              
convertir:
mov bl, 10   ;mueve 10 a bl
div bl       ;divide el contenido de ax para 10, el cociente se guarda en al y el residuo en ah
mov dh, ah   ;mueve el contenido de ah a dh  
mov dl, al   ;mueve 0 a ah
mov ah, 00h  ;mueve el contenido de dh a al
mov al, dh   ;mueve el contenido de dh a al
push ax      ;guarda el contenido de ax en la pila
mov ax, 0000h;guarda 0 en ax
mov al, dl   ;guarda el cociente de la division en al
add cx, 1
cmp dl, 0    ;verifica si el cociente es 0
jnz convertir;si no se cumple lo anterior regresa a la etiqueta convertir
jz  mostrar  ;si dl es igual a 0 salta a la etiqueta mostrar

mostrar:
sub cx, 1    ;decrementa cx en 1
pop ax       ;retira el ultimo valor ingresado en la pila y lo guarda en ax
mov ah, 02h  ;se coloca 02h en ah (funcion)
mov dl, al   ;se guarda el contenido de al en dl
add dl, 30h  ;se suma 30h a dl para obtener el caracter ascii correcto
int 21h      ;se llama a interrupcion 21h para mostrar el caracter por pantalla
cmp cx, 1    ;verifica si el contador llego a 1
jnz mostrar  ;si lo anterior no se cumple, salta a la etiqueta mostrar

salir: 

      

