Operações sobre valores booleanos
=================================

Em linguagem C uma variável do tipo ``bool`` pode assumir os valores ``true`` ou ``false``.
Em memória, uma variável do tipo ``bool`` ocupa um *byte* (uma posição de memória).
O valor numérico zero é avaliado como ``false`` e
um valor numérico diferente de zero é avaliado como ``true``.

Qualquer valor numérico do tipo char, short, int ou long
pode também ser avaliado como booleano, segundo o mesmo critério.

.. table:: Avaliação booleana de uma variável
   :widths: auto
   :align: center
   :name: bool_test

   +------------------------+------------------------+----------------------+------------------------+
   | .. code-block:: c      | .. code-block:: c      | .. code-block:: c    | .. code-block:: asm    |
   |                        |                        |                      |                        |
   |    bool a;             |    int a, b;           |    int a, b;         |    ; a = r0   b = r1   |
   |    int b;              |                        |                      |       add   r0, r0, #0 |
   |                        |                        |                      |       bzc   if_end     |
   |    if (a)              |    if (a)              |    if (a != 0)       |       mov   r1, #3     |
   |        b = 3           |        b = 3           |        b = 3         |    if_end:             |
   +------------------------+------------------------+----------------------+------------------------+
   | .. code-block:: c      | .. code-block:: c      | .. code-block:: c    | .. code-block:: asm    |
   |                        |                        |                      |                        |
   |    bool a;             |    int a, b;           |    int a, b;         |    ; a = r0   b = r1   |
   |    int b;              |                        |                      |       add   r0, r0, #0 |
   |                        |                        |                      |       bzs   if_end     |
   |    if (!a)             |    if (!a)             |    if (a == 0)       |       mov   r1, #3     |
   |        b = 3           |        b = 3           |        b = 3         |    if_end:             |
   +------------------------+------------------------+----------------------+------------------------+
   | \(a\)                  | \(a\)                  | \(b\)                | \(c\)                  |
   +------------------------+------------------------+----------------------+------------------------+

Na :numref:`bool_test`,  no que concerne à expressão do *if*,
o código da coluna (a) trata de avaliar ser a variável ``a`` tem o valor ``true`` ou ``false``.
Nas colunas (b) e (c), trata de avaliar ser a variável ``a`` é igual ou diferente de zero.
O que é equivalente, segundo o critério de representação dos valores booleanos.

A instrução ``add   r0, r0, #0`` ao adicionar zero a R0 não altera o valor original
mas afeta a flag Z em conformidade com o valor de **a**.
-- se **a** for zero a *flag* Z recebe 1; se **a** for diferente de zero a *flag* Z recebe 0.
A *flag* Z é afetada com o valor contrário ao valor booleano da expressão.

As operações de comparação (==, !=, <, >, <=, >=) produzem valores booleanos -- ``true`` ou ``false``.

Em linguagem C, um valor booleano pode ser afetado a uma variável de qualquer tipo numérico
ou ser operado com operadores numéricos.
Para este efeito, o valor booleano ``false`` é convertido no valor numérico **zero**
e o valor booleano ``true`` é convertido no valor numérico **um**.

.. table:: Afetação com expressão booleana.
   :widths: auto
   :align: center
   :name: assign_bool

   +----------------------------------+-------------------------------------+
   | .. code-block:: c                | .. code-block:: asm                 |
   |                                  |    :linenos:                        |
   |                                  |                                     |
   |                                  |    ; x = r0   y = r1                |
   |    int x, y;                     |    mov   r2, #20                    |
   |                                  |    cmp   r0, r2                     |
   |    y = x == 20;                  |    mrs   r1, cpsr                   |
   |                                  |    mov   r2, #1                     |
   |                                  |    and   r1, r1, r2                 |
   |                                  |                                     |
   | \(a\)                            | \(b\)                               |
   +----------------------------------+-------------------------------------+

No programa (a) da :numref:`assign_bool`, a variável **y** é afetada com o valor zero ou um,
resultante da conversão para valor numérico, do valor booleano resultado da expressão x == 20.

No programa (b) da :numref:`assign_bool`, a instrução ``cmp  r0, r2`` afeta a *flag* Z
com o resultado da comparação de **x** com 20 -- valor 1 se forem iguais; valor 0 se forem diferentes.
A instrução ``mrs  r1, cpsr`` copia o registo CPSR para R1.
A aplicação da máscara 0000 0000 0000 0001 (linhas 5 e 6), garante em R1
a representação numérica a 16 *bits* do valor da *flag* Z
que está posicionada no *bit* de menor peso de CPSR,
absorvendo o valor das outras *flags* que fazem parte deste registo.

Avaliação de condições
----------------------

A avaliação de condições que geram valores booleanos
consiste em realizar operações aritméticas ou lógicas
que afetem as *flags*.
Estas operações devem ser escolhidas de modo que a análise do valor das *flags*
seja conclusiva em relação àquilo que se quer avaliar.

Comparação de valores numéricos
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. table:: Operadores de comparação numérica
   :widths: auto
   :align: center
   :name: compare_numbers

   +------------------+-------------------+----------------------------+
   | **==** igualdade | **>** maior que   | **>=** maior ou igual a    |
   +------------------+-------------------+----------------------------+
   | **!=** diferença | **<** menor que   | **<=** menor ou igual a    |
   +------------------+-------------------+----------------------------+

A comparação de valores numéricos baseia-se no valor das *flags* N, V, C e/ou Z,
resultante de uma operação de subtração.
A instrução de subtração que normalmente se usa é a instrução **cmp  rn, rm**,
que é idêntica à instrução **sub  rd, rn, rm**,
com a diferença de não se aproveitar o resultado
(a diferença dos  operandos), apenas as *flags* são afetadas
em conformidade com o resultado.

.. table:: Comparação \"igual a\".
   :widths: auto
   :align: center
   :name: compare_equal

   +----------------------------------+-------------------------------------+
   | .. code-block:: c                | .. code-block:: asm                 |
   |                                  |                                     |
   |                                  |    ; a = r0   b = r1   c = r2       |
   |    int a, b, c;                  |        cmp   r0, r1                 |
   |                                  |        bzc   if_end                 |
   |    if (a == b)                   |        mov   r2, r0                 |
   |        c = a;                    |    if_end:                          |
   +----------------------------------+-------------------------------------+

No programa da :numref:`compare_equal` a instrução ``mov  r2, r0``, correspondente a ``c = a``,
não deve ser executada se **a** for diferente de **b**.
A instrução ``cmp  r0, r1`` ao realizar a subtração de R1 a R0,
afeta a *flag* Z com 1 se **a** e **b** forem iguais
e afeta a *flag* Z com 0 se forem diferentes.
Portanto, a instrução ``mov  r2, r0`` não deve ser executada se Z for 0.
É o que resulta da utilização da instrução ``bzc  if_end`` (*Branch if flag Zero is Clear*).
Esta instrução transfere a execução para a posição do programa indicada pela *label* ``if_end`` se a *flag* Z for 0.

A instrução BZC tem o nome alternativo BNE (*Branch if Not Equal*), que permite
escrever o programa em *assembly* de forma mais direta.
A mnemónica NE corresponde à *flag* Z ser 0,
porque a *flag* Z é afetada com 0 se os operandos não forem iguais.
Em coerência, a instrução BZS (*Branch if flag Zero is Set*)
tem o nome alternativo BEQ (*Branch if Equal*).

.. table:: Comparação \"menor que\".
   :widths: auto
   :align: center
   :name: compare_less_than

   +----------------------------------+-------------------------------------+
   | .. code-block:: c                | .. code-block:: asm                 |
   |    :linenos:                     |                                     |
   |                                  |    ; a = r0   b = r1   c = r2       |
   |    int a, b, c;                  |        cmp   r0, r1                 |
   |                                  |        bcs   if_end                 |
   |    if (a < b)                    |        mov   r2, r0                 |
   |        c = a;                    |    if_end:                          |
   +----------------------------------+-------------------------------------+

No programa da :numref:`compare_less_than` a instrução ``mov  r2, r0``, correspondente a ``c = a``,
não deve ser executada se **a** for maior ou igual a **b**.
A instrução ``cmp  r0, r1`` ao realizar a subtração de R1 a R0
afeta a *flag* C com 0 se **a** for menor que **b**
e afeta a *flag* C com 1 se **a** for maior ou igual a **b**.
A *flag* C assume o valor contrário ao do arrasto da subtração da posição de peso 16
para a posição de peso 15.
Assim, a instrução ``mov  r2, r0`` não deve ser executada se a *flag* C for 1,
que é o que resulta da utilização da instrução ``bcs  if_end`` (*Branch if flag Carry is Set*).
Esta instrução transfere a execução para a posição do programa indicada pela *label* ``if_end`` se a *flag* C for 1.

A instrução BCS tem o nome alternativo BHS (*Branch if Higher or Same*).
Onde está a ``bcs  if_end`` poderia estar ``bhs  if_end``.
A mnemónica HS corresponde à *flag* C ser 1,
o que acontece se numa instrução CMP ou SUB se o subtraendo for maior ou igual ao subtrator.

A sequência ::

   cmp  rm, rn
   bhs  label

pode ter a seguinte leitura:
a instrução BHS realiza "salto" se **rm** for maior ou igual que **rn**.

.. table:: Comparação \"maior que\".
   :widths: auto
   :align: center
   :name: compare_greater_than

   +----------------------------------+-------------------------------------+
   | .. code-block:: c                | .. code-block:: asm                 |
   |    :linenos:                     |                                     |
   |                                  |    ; a = r0   b = r1   c = r2       |
   |    int a, b, c;                  |        cmp   r1, r0                 |
   |                                  |        bhs   if_end                 |
   |    if (a > b)                    |        mov   r2, r0                 |
   |        c = a;                    |    if_end:                          |
   +----------------------------------+-------------------------------------+

Para avaliar a condição **a > b** no programa da :numref:`compare_greater_than`
com base na mesma instrução ``cmp r0, r1`` a condição de salto seria a contrária
à do programa da :numref:`compare_less_than` -- seria "saltar" se menor ou igual (*Lower or Same*).

Como no P16 não existe a suposta instrução de salto BLS,
a solução apresentada realiza a subtração com os operandos em posições invertidas
(``cmp  r1, r0``) e continua a aplicar BHS.

A instrução ``cmp  r1, r0`` afeta a *flag* C com 1 se **a** for maior que **b**
e afeta a *flag* C com 0 se **a** for menor ou igual a **b**.

.. table:: Condições de comparação de números.
   :widths: auto
   :align: center
   :name: compare_conditions

   +-----------------+-----------------+------------------+--------------------+
   | Condição        | Operação        | Números naturais | Números relativos  |
   +=================+=================+==================+====================+
   | ``if (a < b)``  | ``cmp  r0, r1`` | ``bhs``          | ``bge``            |
   +-----------------+-----------------+------------------+--------------------+
   | ``if (a <= b)`` | ``cmp  r1, r0`` | ``blo``          | ``blt``            |
   +-----------------+-----------------+------------------+--------------------+
   | ``if (a > b)``  | ``cmp  r1, r0`` | ``bhs``          | ``bge``            |
   +-----------------+-----------------+------------------+--------------------+
   | ``if (a >= b)`` | ``cmp  r0, r1`` | ``blo``          | ``blt``            |
   +-----------------+-----------------+------------------+--------------------+

Na :numref:`compare_conditions` apresentam-se soluções de programação
para as quatro relações possíveis de comparação.

Na comparação de números relativos, codificados em código de complementos,
devem ser utilizadas as instruções BGE (*Branch if Greater or Equal*)
ou BLT (*Branch if Less Than*).

Regra prática: a mnemónica da instrução *branch*
aplica-se ao primeiro operando da instrução *compare* anterior.

Testar o valor de um *bit*
^^^^^^^^^^^^^^^^^^^^^^^^^^

Testar o valor de um *bit* de uma variável consiste em fazer refletir
o valor desse *bit* numa das *flags* do processador.
Para isso realizam-se operações sobre a variável que transfiram o valor desse *bit*
para uma *flag*.

.. table:: Testar o valor de um *bit*
   :widths: auto
   :align: center
   :name: bit_test

   +-----------------------------+---------------------------+------------------------------+
   | .. code-block:: c           | .. code-block:: asm       | .. code-block:: asm          |
   |                             |    :linenos:              |    :linenos:                 |
   |                             |                           |                              |
   |    #define N 2              |    ; a = r0   b = r1      |    ; a = r0   b = r1         |
   |                             |       .equ  N, 2          |       .equ  N, 2             |
   |    int16_t a, b;            |                           |                              |
   |                             |       mov   r2, #(1 << N) |       ror   r0, r0, #(N + 1) |
   |    if ((a & (1 << N)) != 0) |       and   r2, r0, r2    |       bcc   if_end           |
   |        b = 3                |       bzs   if_end        |       mov   r1, #3           |
   |                             |       mov   r1, #3        |    if_end:                   |
   |                             |    if_end:                |                              |
   +-----------------------------+---------------------------+------------------------------+
   | \(a\)                       | \(b\)                     | \(c\)                        |
   +-----------------------------+---------------------------+------------------------------+


O programa da :numref:`bit_test` testa o valor do *bit* da terceira posição
(peso 2) da variável **a**.

Na versão (b), é realizada uma operação *and* entre a variável
e uma constante formada por zeros e um 1 na posição que se pretende testar.
Esta constante designam-se por máscara.
Neste caso a máscara tem o valor 0000 0000 0000 0100.
O valor 1 na posição N, sendo o elemento neutro da operação *and*, faz com que
o resultado da instrução ``and r3, r0, r2`` seja zero,
no caso do *bit* da posição N da variável ser 0
ou diferente de zero no caso do *bit* da posição N da variável ser 1.
A *flag* Z é afetada com o valor contrário ao do *bit* que se pretende testar.

Na versão (c), o *bit* da variável que se pretende testar
é deslocado para a *flag* C pela instrução ``ror   r0, #(N + 1)``.
O número de posições a deslocar é N + 1.

Em ambos os casos a instrução *branch* "salta por cima" da instrução
``mov  r1, #3`` (b = 3) quando o *bit* em avaliação é 0.

Operadores booleanos
--------------------

.. table:: Operadores booleanos
   :widths: auto
   :align: center

   +---------------------+----------------------+-----------------+
   | **||** disjunção    | **&&** conjunção     | **!** negação   |
   +---------------------+----------------------+-----------------+

Em geral nas linguagens de programação,
a avaliação dos operandos da disjunção ou conjunção realiza-se da esquerda para a direita
(ordem de leitura do texto).
Nesta avaliação, assim que for encontrado um resultado igual ao elemento absorvente,
as restantes sub-expressões já não serão avaliadas (*lazy evaluation*).
A utilização deste critério visa a não realização de processamento desnecessário.
Pelo conhecimento que o programador tiver dos dados,
deve começar por escrever, em primeiro lugar,
as sub-expressões cujo resultado mais provável evite o processamento das seguintes.

.. table:: Expressão com operação conjunção.
   :widths: auto
   :align: center
   :name: and_operation

   +----------------------------------+-------------------------------------+
   | .. code-block:: c                | .. code-block:: asm                 |
   |    :linenos:                     |    :linenos:                        |
   |                                  |                                     |
   |    int a, b, c;                  |    ; a = r0   b = r1   c = r2       |
   |                                  |       mov    r3, #3                 |
   |    if (a >= 3 && b >= 3)         |       cmp    r0, r3                 |
   |        c += 3;                   |       blo    if_end                 |
   |                                  |       cmp    r1, r3                 |
   |                                  |       blo    if_end                 |
   |                                  |       add    r2, r2, #3             |
   |                                  |    if_end:                          |
   |                                  |                                     |
   | \(a\)                            | \(b\)                               |
   +----------------------------------+-------------------------------------+

No programa (b) da ::numref:`and_operation`,
se o resultado da avaliação de ``a >= 3`` (linhas 2 e 3) for falso,
a sub-expressão ``b >= 3`` (linhas 5 e 6) já não será avaliada,
nem o bloco do *if* (linha 7) será executado.

.. table:: Expressão com operação disjunção.
   :widths: auto
   :align: center
   :name: or_operation

   +----------------------------------+-------------------------------------+
   | .. code-block:: c                | .. code-block:: asm                 |
   |    :linenos:                     |    :linenos:                        |
   |                                  |                                     |
   |    int a, b, c;                  |    ; a = r0   b = r1   c = r2       |
   |                                  |       mov    r3, #3                 |
   |    if (a >= 3 || b >= 3)         |       cmp    r0, r3                 |
   |        c += 3;                   |       bhs    if_then                |
   |                                  |       cmp    r1, r3                 |
   |                                  |       blo    if_end                 |
   |                                  |    if_then:                         |
   |                                  |       add    r2, r2, #3             |
   |                                  |    if_end:                          |
   |                                  |                                     |
   | \(a\)                            | \(b\)                               |
   +----------------------------------+-------------------------------------+

No programa (b) da ::numref:`or_operation`,
se o resultado da avaliação de ``a >= 3`` (linhas 2 e 3) for verdadeiro,
a sub-expressão ``b >= 3`` (linhas 5 e 6) já não será avaliada,
e o bloco do *if* (linha 8) é imediatamente executado.
