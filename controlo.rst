Controlo da execução
====================

if else
-------

.. table:: *if* sem *else*.
   :widths: auto
   :align: center
   :name: if_sample

   +----------------------------------+-------------------------------------+
   | .. code-block:: c                | .. code-block:: asm                 |
   |                                  |    :linenos:                        |
   |                                  |                                     |
   |    int i, j, k                   |    ; i = r0   j = r1    k = r2      |
   |                                  |       cmp    r0, r1                 |
   |    if (i >= j) {                 |       blo    if_end                 |
   |        k = 19;                   |       mov    r2, #19                |
   |        i = j;                    |       mov    r0, r1                 |
   |    }                             |    if_end:                          |
   |                                  |                                     |
   | \(a\)                            | \(b\)                               |
   +----------------------------------+-------------------------------------+

O código do bloco *if* (linhas 4 e 5) é colocado imediatamente após
o código de avaliação da condição (linhas 2 e 3).
Como determinar a condição da instrução de salto? Esta instrução realiza o salto
se a expressão do *if* for falsa.
A mnemónica da condição está relacionada com o primeiro operando da instrução *compare* anterior.
Há que refletir sobre o que este registo representa na expressão que está a ser avaliada
e determinar a condição que torna a expressão falsa.
A condição LO (*Lower*) da instrução ``blo  if_end``,
implica R0 menor que R1, que a verificar-se, significa que **i** é menor que **j**.

.. table:: *if* com *else*.
   :widths: auto
   :align: center
   :name: if_else

   +----------------------------------+-------------------------------------+
   | .. code-block:: c                | .. code-block:: asm                 |
   |                                  |    :linenos:                        |
   |                                  |                                     |
   |    int i, j, f;                  |    ; i = r5   j = r3   f = r2       |
   |                                  |       cmp    r5, r3                 |
   |    if (i == j) {                 |       bne    if_else                |
   |        f <<= 1;                  |       lsl    r2, r2, #1             |
   |        i++;                      |       add    r5, r5, #1             |
   |    } else {                      |       b      if_end                 |
   |        f >>= 2;                  |    if_else:                         |
   |        i -= 2;                   |       lsr    r2, r2, #2             |
   |    }                             |       sub    r5, r5, #2             |
   |    j++;                          |    if_end:                          |
   |                                  |       add    r3, r3, #1             |
   |                                  |                                     |
   | \(a\)                            | \(b\)                               |
   +----------------------------------+-------------------------------------+

A instrução ``cmp r5, r3`` realiza a subtracção R5 – R3 e afecta a *flag* Z com 1,
se a diferença for zero, significa que **i** (R5) e **j** (R3) são iguais.
No caso de *i* ser diferente de *j*, a *flag* Z é afectada com 0
e a instrução ``bne if_else`` "salta por cima" do bloco *if* (linhas 4 a 6)
directamente para o código do bloco *else* (linhas 8 e 9).
No caso de **i** ser igual a **j** a instrução ``bne if_else`` não realiza salto
e executa o bloco *if* (linhas 4 a 6).
Este bloco termina com um salto incondicional (linha 6),
para não executar o bloco *else* posicionado nas posições seguintes.

switch case
-----------

.. table:: *switch case*.
   :widths: auto
   :align: center
   :name: switch_case

   +----------------------------------+-------------------------------------+
   | .. code-block:: c                | .. code-block:: asm                 |
   |    :linenos:                     |    :linenos:                        |
   |                                  |                                     |
   |    int v, a;                     |    ; v = r0   a = r1                |
   |                                  |    switch_case_1:                   |
   |    switch (v) {                  |        mov   r2, #1                 |
   |        case 1:                   |        cmp   r0, r2                 |
   |            a = 11;               |        bne   switch_case_10         |
   |            break;                |        mov   r1, #11                |
   |        case 10:                  |        b     switch_break;          |
   |            a = 111;              |    switch_case_10:                  |
   |            break;                |        mov   r2, #10                |
   |        default:                  |        cmp   r0, #r2                |
   |            a = 0;                |        bne   switch_default         |
   |    }                             |        mov   r1, #111               |
   |                                  |        b     switch_break;          |
   |                                  |    switch_default:                  |
   |                                  |        mov   r1, #0                 |
   |                                  |    switch_break:                    |
   |                                  |                                     |
   | \(a\)                            | \(b\)                               |
   +----------------------------------+-------------------------------------+

A implementação do *switch/case* consiste em encadear um conjunto de *ifs*,
um para cada caso.

do while
--------

.. table:: *do while*.
   :widths: auto
   :align: center
   :name: do_while

   +----------------------------------+-------------------------------------+
   | .. code-block:: c                | .. code-block:: asm                 |
   |    :linenos:                     |    :linenos:                        |
   |                                  |                                     |
   |    int v, z;                     |    ; v = r0   z = r1                |
   |                                  |    do_while:                        |
   |    do {                          |        lsr    r0, r0, #1            |
   |        v >> 1;                   |        add    r1, r1, #1            |
   |        z += 1;                   |        sub    r0, r0, #0            |
   |    } while (v != 0) {            |        bne    do_while              |
   |                                  |                                     |
   | \(a\)                            | \(b\)                               |
   +----------------------------------+-------------------------------------+

A programação *assembly* segue a ordem de escrita e de execução da programação em C
-- primeiro executa o corpo de instruções (linhas 3 e 4) e no final avalia a condição (linhas 5 e 6).

while
-----

.. table:: *while*
   :widths: auto
   :align: center
   :name: while

   +-----------------------------+---------------------------+------------------------------+
   | .. code-block:: c           | .. code-block:: asm       | .. code-block:: asm          |
   |                             |    :linenos:              |    :linenos:                 |
   |                             |                           |                              |
   |    int v, z;                |    ; v = r0   z = r1      |    ; v = r0   z = r1         |
   |                             |    while:                 |    while:                    |
   |    while (v != 0) {         |        sub    r0, r0, #0  |        b      while_cond     |
   |        v >> 1;              |        beq    while_end   |    while_do:                 |
   |        z += 1;              |        lsr    r0, r0, #1  |        lsr    r0, r0, #1     |
   |    }                        |        add    r1, r1, #1  |        add    r1, r1, #1     |
   |                             |        b      while       |    while_cond:               |
   |                             |    while_end:             |        sub    r0, r0, #0     |
   |                             |                           |        bne    while_do       |
   |                             |                           |                              |
   | \(a\)                       | \(b\)                     | \(c\)                        |
   +-----------------------------+---------------------------+------------------------------+

O programa (b) da :numref:`while` é escrito e executado pela ordem da linguagem C
-- primeiro a avaliação da condição (linhas 3 e 4) e depois o bloco de instruções do *while* (linhas 5 e 6).
Com esta programação, o processador executa 5 instruções durante o ciclo (linhas 3 a 7),
entre elas duas instruções *branch* (linhas 4 e 7).
No program (c) da :numref:`while` o programa é escrito como num *do while*,
com a avaliação da condição no final (linhas 8 e 9).
O *while* começa com um salto incondicional (linha 3) para a avaliação da condição (linhas 8 e 9),
porque esta deve ser executada em primeiro lugar.
Esta programação resulta na supressão de uma instrução *branch* durante o ciclo,
relativamente à programação apresentada na versão (b), o que a torna preferível.
A supressão de uma instrução num ciclo, pode equivaler a uma redução significtiva de processamento,
porque essa instrução é executada múliplas vezes.

for
---

.. table:: *for*.
   :widths: auto
   :align: center
   :name: for

   +--------------------------------------+-------------------------------------+
   | .. code-block:: c                    | .. code-block:: asm                 |
   |    :linenos:                         |    :linenos:                        |
   |                                      |                                     |
   |    int i, a;                         |    ; i = r0   a = r1   n = r2       |
   |                                      |        mov    r0, #0                |
   |    for (i = 0, a = 1; i < n; ++i) {  |        mov    r1, #1                |
   |        a <<= 1;                      |        b      for_cond              |
   |    }                                 |    for:                             |
   |                                      |        lsl    r1, r1, #1            |
   |                                      |        add    r0, r0, #1            |
   |                                      |    for_cond:                        |
   |                                      |        cmp    r0, r2                |
   |                                      |        blo    for                   |
   |                                      |                                     |
   | \(a\)                                | \(b\)                               |
   +--------------------------------------+-------------------------------------+

A instrução ::

   for (expression1; expression2; expression3)
       statement;

é equivalente a ::

   expression1;
   while (expression2) {
       statement;
       expression3;
   }

A programação *assembly* apresentada na :numref:`for` (b) reflecte esta equivalência,
com o *while* implementado na variante mais eficiente -- :numref:`while` (c).
