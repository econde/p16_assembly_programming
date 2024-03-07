Operações sobre valores numéricos
=================================

Nesta secção são realizadas operações sobre valores numéricos constantes
ou valores em variáveis.
As variáveis são representadas em registos do processador.



Afetação
--------
Considerando que as variáveis **a** e  **b** se encontram representadas nos registos R0 e R1,
afetar **a** com **b** corresponde a executar a instrução **mov rd, rs**
que copia o conteúdo do registo R1 para R0.

.. table:: Afetação de variável com outra variável
   :widths: auto
   :align: center
   :name: afetacao_com_variavel

   +----------------------------------+----------------------------------+
   | .. code-block:: c                | .. code-block:: asm              |
   |                                  |                                  |
   |    int16_t a, b;                 |    ;a = r0     b = r1            |
   |                                  |                                  |
   |    a = b;                        |    mov r0, r1                    |
   +----------------------------------+----------------------------------+

.. _afetacao com constante:

Afetação com constante
----------------------
As constantes podem ser escritas nas linguagens de programação em diversas bases de numeração,
utilizando-se para cada base uma notação sintática própria.
As bases e notações mais usuais estão representadas na :numref:`constantes`

.. table:: Definição de constantes numéricas
   :widths: auto
   :align: center
   :name: constantes

   +-----------------------+--------------------------------+-------------------+
   | Base de numeração     | Esquema sintático              | Exemplo           |
   +=======================+================================+===================+
   | decimal               | d\-\- (d:1..9; restantes 0..9) | 123               |
   +-----------------------+--------------------------------+-------------------+
   | binária               | 0b\-\-\-\-\-\-\-\- (0..1)      | 0b00110110        |
   +-----------------------+--------------------------------+-------------------+
   | octal                 | 0\-\- (0..7)                   | 023    (dezanove) |
   +-----------------------+--------------------------------+-------------------+
   | hexadecimal           | 0x\-\- (0..7,a..f,A..F)        | 0xff              |
   +-----------------------+--------------------------------+-------------------+


O P16 dispõe de duas instruções para carregamento de valores constantes em registo:
a instrução **mov  rd, #constant** que carrega uma constante representada a 8 *bits*
na parte menos significativa do registo e zero na parte mais significativa;
a instrução **movt  rd, #constant** que carrega um valor de 8 *bits*
na parte mais significativa do registo e mantém o conteúdo da parte menos significativa.

Para carregar valores numéricos entre 0 e 255 pode utilizar-se apenas uma instrução **mov**,
para valores maiores utiliza-se uma sequência **mov - movt**.

.. table:: Afetação com constante
   :widths: auto
   :align: center
   :name: afetacao_constante

   +--------+----------------------------------+----------------------------------+
   |        | .. code-block:: c                | .. code-block:: asm              |
   |        |                                  |                                  |
   | \(a\)  |    int16_t a;                    |    ;a = r0                       |
   |        |    a = 40;                       |    mov r0, #40                   |
   +--------+----------------------------------+----------------------------------+
   |        | .. code-block:: c                | .. code-block:: asm              |
   |        |                                  |                                  |
   | \(b\)  |    int16_t a;                    |    ;a = r0                       |
   |        |                                  |    mov  r0, #0xfe                |
   |        |    a = -2;                       |    movt r0, #0xff                |
   +--------+----------------------------------+----------------------------------+
   |        | .. code-block:: c                | .. code-block:: asm              |
   |        |                                  |                                  |
   | \(c\)  |    int16_t a;                    |    ;a = r0                       |
   |        |                                  |    mov  r0, #0x34                |
   |        |    a = 0x1234;                   |    movt r0, #0x12                |
   +--------+----------------------------------+----------------------------------+
   |        | .. code-block:: c                | .. code-block:: asm              |
   |        |                                  |                                  |
   |        |    #define   VALUE -2000         |    ;a = r0                       |
   | \(d\)  |    int16_t a;                    |    .equ VALUE, -2000             |
   |        |                                  |    mov  r0, #VALUE & 0xff        |
   |        |    a = VALUE;                    |    movt r0, #(VALUE >> 8) & 0xff |
   +--------+----------------------------------+----------------------------------+

:numref:`afetacao_constante` (a) – carregamento de valor positivo inferior a 256;
utiliza-se apenas uma instrução **mov** porque esta instrução coloca também a parte alta a zero.

:numref:`afetacao_constante` (b) – carregamento de um valor negativo.
-2 é representado em código dos complementos a 16 bits por 0xfffe.
A instrução **mov** carrega 0xfe na parte baixa de R0 e a instrução movt carrega a 0xff na parte alta.

:numref:`afetacao_constante` (c) – a instrução **mov** carrega o valor 0x34 na parte baixa de R0 e zero na parte alta.
Sendo o valor da constante superior a 256,
é necessária a instrução **movt** para carregar 0x12 na parte alta de R0
e assim formar o valor 0x1234 em R0.

:numref:`afetacao_constante` (d) – exemplifica uma programação genérica para qualquer valor numérico
no domínio de representação do tipo int16_t ou uint16_t.
A diretiva ``.equ VALUE, -2000`` significa que no texto do programa,
onde aparece ``VALUE`` pode ler-se ``-2000``.
Este valor tem uma representação a 16 *bits* equivalente a 0xf830.
A expressão ``VALUE & 0xff`` é igual a 0x30 e a expressão ``(VALUE >> 8) & 0xff`` é igual 0xf8.

Operações aritméticas
---------------------

.. table:: Operadores aritméticos
   :widths: auto
   :align: center

   +-----------------+----------------------+--------------------------------+---------------------+
   | **+** adição    | **\*** multiplicação | **%** resto da divisão inteira | **++** incremento   |
   +-----------------+----------------------+--------------------------------+---------------------+
   | **-** subtração | **/** divisão        |                                | **\-\-** decremento |
   +-----------------+----------------------+--------------------------------+---------------------+

Adição
^^^^^^

.. table:: Adição de variáveis
   :widths: auto
   :align: center
   :name: adicao_simples

   +--------+----------------------------------+----------------------------------+
   |        | .. code-block:: c                | .. code-block:: asm              |
   |        |                                  |                                  |
   |        |    int16_t a, b;                 |    ; a = r0  b = r1              |
   | \(a\)  |                                  |                                  |
   |        |    a = a + b;                    |    add  r0, r0, r1               |
   +--------+----------------------------------+----------------------------------+
   |        | .. code-block:: c                | .. code-block:: asm              |
   |        |                                  |                                  |
   |        |    uint16_t a, b;                |    ; a = r0  b = r1              |
   | \(b\)  |                                  |                                  |
   |        |    a = a + b;                    |    add  r0, r0, r1               |
   +--------+----------------------------------+----------------------------------+

Na :numref:`adicao_simples` apresenta-se a programação da adição de variáveis --
no caso (a), variáveis para números relativos e no caso (b), variáveis para números naturais.
Ao nível da máquina ambas as operação são realizadas exatamente da mesma forma
pela instrução  **add  rd, rn, rm**. A diferença está na forma como se interpretam
os operandos e os resultados.

No caso dos números naturais, os valores são representados diretamente em binário.
Nos registos apenas podem ser representados valores no domínio :math:`0` a :math:`2^{16} - 1`.
Se o resultado ultrapassar este domínio é assinalado arrasto na *flag* Carry, que fica com valor 1.

No caso dos números relativos, os valores são representados em código dos complementos.
Nos registos apenas podem ser representados valores no domínio :math:`-2^{15}` a :math:`+2^{15} - 1`.
No caso do resultado ultrapassar este domínio,
o que pode aconter se os operandos forem ambos positivos ou ambos negativos,
é assinalado erro na *flag* Overflow, que fica com o valor 1.

.. _operacao subtracao:

Subtração
^^^^^^^^^

.. table:: Subtração de variáveis
   :widths: auto
   :align: center
   :name: subtracao

   +--------+----------------------------------+----------------------------------+
   |        | .. code-block:: c                | .. code-block:: asm              |
   |        |                                  |                                  |
   |        |    uint16_t a, b;                |    ; a = r0  b = r1              |
   | \(a\)  |                                  |                                  |
   |        |    a = a - b;                    |    sub  r0, r0, r1               |
   +--------+----------------------------------+----------------------------------+
   |        | .. code-block:: c                | .. code-block:: asm              |
   |        |                                  |                                  |
   |        |    int16_t a, b;                 |    ; a = r0  b = r1              |
   | \(b\)  |                                  |                                  |
   |        |    a = a - b;                    |    sub  r0, r0, r1               |
   +--------+----------------------------------+----------------------------------+

Na :numref:`subtracao` apresenta-se a programação da subtração
de variáveis.

A instrução **sub  rd, rn, rm** afeta o registo **rd**
com o valor do registo **rn** menos o valor do registo **rm**. Além disso afeta também a *flag* C com informação de arrasto.

Para interpretar o funcionamento da instrução SUB,
pode aplicar-se o seguinte modelo: como resultado da instrução **sub**,
o registo **rd** recebe a soma do valor do registo **rn**
com o complemento para :math:`2^{16}` do valor do registo **rm** e
a *flag* C recebe o arrasto produzido por esta adição.

No caso do valor de **rn** ser maior que o valor de **rm**,
a operação de subtração não produziria arrasto (*borrow*).
No entanto, nesta relação de valores, a adição do complemento de **rm** com **rn** produz arrasto (*carry*)
e a *flag* C firará com 1.

Se, pelo contrário, o valor de **rn** for menor que o valor de **rm**,
a operação de subtração produziria arrasto (*borrow*), mas a *flag* C ficará com 0.

Expressão com adição e subtração
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. table:: Expressão com adição e subtração
   :widths: auto
   :align: center
   :name: adicao_subtracao

   +----------------------------------+--------------------------------------+
   | .. code-block:: c                | .. code-block:: asm                  |
   |                                  |                                      |
   |    int16_t a, b, c, d;           |    ; a = r0  b = r1  c = r2  d = r3  |
   |                                  |    add   r0, r2, r1                  |
   |    a = c + b – d;                |    sub   r0, r0, r3                  |
   +----------------------------------+--------------------------------------+

A instrução ``add  r0, r2, r1`` adiciona as variáveis **c** e **b** (R2 e R1, respetivamente)
e deixa o resultado intermédio em **a** (R0).
A instrução ``sub  r0, r0, r3`` subtrai a variável **d** (R3) do resultado intermédio em R0
e coloca o resultado final em **a** (R0).

Adição a 32 *bits*
^^^^^^^^^^^^^^^^^^

.. table:: Adição de valores a 32 *bits*
   :widths: auto
   :align: center
   :name: adicao_32_bits

   +----------------------------------+-----------------------------------------+
   | .. code-block:: c                | .. code-block:: asm                     |
   |                                  |                                         |
   |    int32_t a, b, c;              |    ; a = r1:r0   b = r3:r2   c = r5:r4  |
   |                                  |    add   r0, r2, r4                     |
   |    a = b + c;                    |    adc   r1, r3, r5                     |
   +----------------------------------+-----------------------------------------+

Os valores representados a 32 *bits* são guardados no processador em dois registos.
A variável **a** é guardada nos registos R0 e R1, com a parte menos significativa em R0
e a mais significativa em R1. As variáveis **c** e **d** são guardadas nos registos R3:R2 e R5:R4,
de modo semelhante.

A operação de adição das variáveis **b** e **c** é realizada em dois passos.
No primeiro passo a instrução ``add  r0, r2, r4`` adiciona
as partes menos significativas das variáveis **a** e **b**
afetando R0 com o resultado e a *flag* Carry com o arrasto.
No segundo passo a instrução ``adc  r1, r3, r5`` adiciona as partes mais significativas
das variáveis com o arrasto produzido na adição anterior.

Subtração a 32 *bits*
^^^^^^^^^^^^^^^^^^^^^

.. table:: Subtração de valores a 32 *bits*
   :widths: auto
   :align: center
   :name: subtracao_32_bits

   +----------------------------------+-----------------------------------------+
   | .. code-block:: c                | .. code-block:: asm                     |
   |                                  |                                         |
   |    int32_t a, b, c;              |    ; a = r1:r0   b = r3:r2   c = r5:r4  |
   |                                  |    sub   r4, r0, r2                     |
   |    c = a - b;                    |    sbc   r5, r1, r3                     |
   +----------------------------------+-----------------------------------------+

À semelhança da adição a 32 *bits*, é utilizada a combinação das instruções SUB e SBC.
A instrução ``sub  r4, r0, r2`` opera as partes menos significativas subtraindo R2 a R0.
R4 é afetado com a diferença e a *flag* C com informação de arrasto (ver :ref:`operacao subtracao`).

A instrução ``sbc  r5, r1, r3`` opera as partes mais significativas, subtraindo R3 ou R3 - 1 a R1.
R5 é afetado com a diferença e a *flag* C com informação de arrasto,
como na instrução SUB.

Na instrução **sbc  rd, rn, rm**, o valor a subtrair ao valor do registo **rn**
depende da *flag* C. Se C for 0, subtrai o valor do registo **rm** menos 1;
se C for 1 subtrai o valor do registo **rm**.

A instrução SBC opera segundo o seguinte modelo matemático:

:math:`rd = rn - rm - 1 + C = rn + (2^{16} - rm) - 1 + C = rn + (not(rm) + 1) - 1 + C = rn + not(rm) + C`



Multiplicação e divisão
^^^^^^^^^^^^^^^^^^^^^^^

O P16 não dispõe de instruções de multiplicação ou divisão.
Estas operações terão que ser realizadas programaticamente,
utilizando as outras instruções.

Exemplos de programação destas operações para o P16
são apresentados no capítulo Exemplos
nas secções :ref:`multiply` e Divisão.

Operações bit-a-bit (*bitwise*)
-------------------------------

Deslocar à direita
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Deslocar um valor para a direita equivale a
dividir esse valor por dois elevado ao número de posições deslocadas.

.. table:: Deslocar um valor para a direita
   :widths: auto
   :align: center
   :name: shift_right

   +--------+----------------------------------+----------------------------------+
   |        | .. code-block:: c                | .. code-block:: asm              |
   |        |                                  |                                  |
   |        |    uint16_t a;                   |    ; a = r0                      |
   | \(a\)  |                                  |                                  |
   |        |    a = a >> 1;                   |    lsr  r0, r0, #1               |
   +--------+----------------------------------+----------------------------------+
   |        | .. code-block:: c                | .. code-block:: asm              |
   |        |                                  |                                  |
   |        |    int16_t a;                    |    ; a = r0                      |
   | \(b\)  |                                  |                                  |
   |        |    a = a >> 1;                   |    asr  r0, r0, #1               |
   +--------+----------------------------------+----------------------------------+
   |        | .. code-block:: c                | .. code-block:: asm              |
   |        |                                  |                                  |
   |        |    uint32_t a;                   |    ; a = r1:r0                   |
   | \(c\)  |                                  |    lsr  r1, r1, #1               |
   |        |    a = a >> 1;                   |    rrx  r0, r0                   |
   +--------+----------------------------------+----------------------------------+
   |        | .. code-block:: c                | .. code-block:: asm              |
   |        |                                  |                                  |
   |        |    uint32_t a;                   |    ; a = r1:r0                   |
   | \(d\)  |                                  |    lsr  r0, r0, #4               |
   |        |    a = a >> 4;                   |    lsl  r2, r1, #(16 – 4)        |
   |        |                                  |    add  r0, r0, r2               |
   |        |                                  |    lsr  r1, r1, #4               |
   +--------+----------------------------------+----------------------------------+

Deslocar à esquerda
^^^^^^^^^^^^^^^^^^^
Deslocar um valor para a esquerda equivale
a multiplicar esse valor por dois elevado ao número de posições deslocadas.

.. table:: Deslocar um valor para a esquerda
   :widths: auto
   :align: center
   :name: shift_left

   +--------+----------------------------------+----------------------------------+
   |        | .. code-block:: c                | .. code-block:: asm              |
   |        |                                  |                                  |
   |        |    uint16_t a;                   |    ; a = r0                      |
   | \(a\)  |                                  |                                  |
   |        |    a = a << 1;                   |    lsl  r0, r0, #1               |
   +--------+----------------------------------+----------------------------------+
   |        | .. code-block:: c                | .. code-block:: asm              |
   |        |                                  |                                  |
   |        |    int16_t a;                    |    ; a = r0                      |
   | \(b\)  |                                  |                                  |
   |        |    a = a << 1;                   |    lsl  r0, r0, #1               |
   +--------+----------------------------------+----------------------------------+
   |        | .. code-block:: c                | .. code-block:: asm              |
   |        |                                  |                                  |
   |        |    uint32_t a;                   |    ; a = r1:r0                   |
   | \(c\)  |                                  |    lsl  r0, r0, #1               |
   |        |    a = a << 1;                   |    adc  r1, r1, r1               |
   +--------+----------------------------------+----------------------------------+
   |        | .. code-block:: c                | .. code-block:: asm              |
   |        |                                  |                                  |
   |        |    uint32_t a;                   |    ; a = r1:r0                   |
   | \(d\)  |                                  |    lsl  r1, r1, #4               |
   |        |    a = a << 4;                   |    lsr  r2, r0, #(16 - 4)        |
   |        |                                  |    add  r1, r1, r2               |
   |        |                                  |    lsl  r0, r0, #4               |
   +--------+----------------------------------+----------------------------------+


Rodar
^^^^^

Rodar uma palavra para a direita significa inserir nas posições de maior peso,
os *bits* que saem das posições de menor peso;
rodar uma palavra para a esquerda significa inserir nas posições de menor peso
os bits que saem das posições de maior peso.

.. table:: Rotação de valores
   :widths: auto
   :align: center
   :name: rotacao_valores

   +----------------------------------+-----------------------------------------+
   |  Rodar o valor de R0             | .. code-block:: asm                     |
   |  três posições para a direita.   |                                         |
   |                                  |    ror  r0, r0, #3                      |
   +----------------------------------+-----------------------------------------+
   | Rodar o valor de R0              | .. code-block:: asm                     |
   | cinco posições para a esquerda.  |                                         |
   |                                  |    ror  r0, r0, #(16 – 5)               |
   +----------------------------------+-----------------------------------------+


Deslocar um número variável de posições
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

O P16 não dispõe de instrução que permita deslocar o conteúdo de um registo
um número variável de posições. O terceiro parâmetro das instruções de deslocamento,
que define o número de posições a deslocar, é sempre uma constante.

Para deslocar um número variável de posições é necessário elaborar um programa.

Na :numref:`variable_shift` (b) apresenta-se uma solução
que realiza um número de iterações igual ao número de posições a deslocar (valor do registo R1),
deslocando uma posição em cada iteração (linha 5).

A solução apresentada na :numref:`variable_shift` (c) executa o deslocamento em
quatro passos (instruções ``lsl r0, r0, #X`` (linhas 4, 8, 12 e 16).
Em cada passo deslocar deslocar uma, duas, quatro ou oito posições,
perfazendo um máximo de quinze posições.

O número de posições a deslocar é representado pelos quatro *bits* de menor peso de R1.
Por exemplo, no terceiro passo (linha 10 a 12) é testado o *bit* de peso dois de R1.
Se este *bit* for 1, R0 é deslocado quatro posições. Se for 0, R0 não é deslocado.

O programa da :numref:`variable_shift` (b) demora a executar um tempo igual ao de 2 + 5 \* n instruções
enquanto o programa da :numref:`variable_shift` (c) demora o tempo igual ao de 8 a 12 instruções.

.. table:: Deslocamento de um número variável de posições
   :widths: auto
   :align: center
   :name: variable_shift

   +-------------------+---------------------------+-----------------------------+
   | .. code-block:: c | .. code-block:: asm       | .. code-block:: asm         |
   |                   |    :linenos:              |    :linenos:                |
   |                   |                           |                             |
   |    int16_t a, n;  |    ;a = r0   n = r1       |    ;a = r0   n = r1         |
   |                   |       add  r1, r1, #0     |        lsr  r1, r1, #1      |
   |    a <<= n;       |       bzs  shift_end      |        bcc  shift_1         |
   |                   |    shift:                 |        lsl  r0, r0, #1      |
   |                   |       lsl  r0, r0, #1     |    shift_1:                 |
   |                   |       sub  r1, r1, #1     |        lsr  r1, r1, #1      |
   |                   |       bzc  shift          |        bcc  shift_2         |
   |                   |    shift_end:             |        lsl  r0, r0, #2      |
   |                   |                           |    shift_2:                 |
   |                   |                           |        lsr  r1, r1, #1      |
   |                   |                           |        bcc  shift_4         |
   |                   |                           |        lsl  r0, r0, #4      |
   |                   |                           |    shift_4:                 |
   |                   |                           |        lsr  r1, r1, #1      |
   |                   |                           |        bcc  shift_8         |
   |                   |                           |        lsl  r0, r0, #8      |
   |                   |                           |    shift_8:                 |
   |                   |                           |                             |
   | \(a\)             | \(b\)                     | \(c\)                       |
   +-------------------+---------------------------+-----------------------------+

Afetar um *bit* com 1
^^^^^^^^^^^^^^^^^^^^^

Afetar o *bit* de peso três da variável **a** com o valor 1,
mantendo o valor dos restantes *bits*.

A instrução ``mov r1, #(1 << 3)`` coloca o valor ``0000 0000 0000 1000`` em R1.
A instrução ``orr r0, r0, r1`` realiza a operação disjunção (*or*)
entre os *bits* das mesmas posições de R0 e R1.
O resultado é o valor original de R0 quando operado com 0 em R1 -- elemento neutro --
ou o valor 1 quando operado com 1 em R1 -- elemento absorvente.

.. table:: Afetar o *bit* três de **a** com 1.
   :widths: auto
   :align: center
   :name: set_bit

   +----------------------------------+-------------------------------------+
   | .. code-block:: c                | .. code-block:: asm                 |
   |                                  |                                     |
   |    uint16_t a;                   |    ; a = r0                         |
   |                                  |    mov   r1, #(1 << 3)              |
   |    a |= 1 << 3;                  |    orr   r0, r0, r1                 |
   +----------------------------------+-------------------------------------+

Afetar um *bit* com 0
^^^^^^^^^^^^^^^^^^^^^

Afetar o *bit* de peso doze da variável **a** com o valor 0,
mantendo o valor dos restantes *bits*.

As instruções ``mov r1, #(~(1 << 12) & 0xff)`` e ``movt r1, #(~(1 << 12) >> 8)``
colocam o valor **1110 1111 1111 1111** em R1.
A instrução ``and r0, r0, r1`` realiza a operação conjunção (*and*)
entre os *bits* das mesmas posições de R0 e R1.
O resultado é o valor original de R0 quando operado com 1 em R1 -- elemento neutro --
ou o valor 0 quando operado com 0 em R1 -- elemento absorvente.

.. table:: Afetar o *bit* três de **a** com 0.
   :widths: auto
   :align: center
   :name: clear_bit

   +----------------------------------+-------------------------------------+
   | .. code-block:: c                | .. code-block:: asm                 |
   |                                  |                                     |
   |    uint16_t a;                   |    ; a = r0                         |
   |                                  |    mov   r1, #(~(1 << 12) & 0xff)   |
   |                                  |    movt  r1, #(~(1 << 12) >> 8)     |
   |    a &= ~(1 << 12);              |    and   r0, r0, r1                 |
   +----------------------------------+-------------------------------------+


Afetar um *bit* de variável com o *bit* de outra variável
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Afetar o *bit* de peso quatro da variável **a**
com o valor do *bit* de peso treze da variável **b**, mantendo os restantes *bits*.

.. table:: Afetar o *bit* quatro de **a** com o valor do *bit* treze de **b**.
   :widths: auto
   :align: center
   :name: assign_bit

   +----------------------------------+-------------------------------------+
   | .. code-block:: c                | .. code-block:: asm                 |
   |                                  |                                     |
   |    uint16_t a, b;                |    ; a = r0   b = r1   tmp = r2     |
   |                                  |    lsr   r2, r1, #(13 - 4)          |
   |    uint16_t tmp = b >> (13 - 4); |    mov   r3, #(1 << 4)              |
   |    tmp &= (1 << 4);              |    and   r2, r2, r3                 |
   |    a &= ~(1 << 4);               |    mvn   r3, r3                     |
   |    a |= tmp;                     |    and   r0, r0, r3                 |
   |                                  |    orr   r0, r0, r2                 |
   +----------------------------------+-------------------------------------+


Multiplicar por constante
^^^^^^^^^^^^^^^^^^^^^^^^^

A multiplicação de uma variável por uma constante pode ser realizada,
sem recurso a instrução de multiplicação
ou a programa genérico de multiplicação.
Veja-se o seguinte exemplo:

a * 21 = a * (16 + 4 + 1) = a * 16 + a * 4 + a * 1

A constante 21 é decomposta em parcelas de valor igual a potências de dois.
As multiplicações parciais são realizadas por instruções de deslocamento.

.. table:: Multiplicar por constante.
   :widths: auto
   :align: center
   :name: mult_const

   +----------------------------------+-------------------------------------+
   | .. code-block:: c                | .. code-block:: asm                 |
   |                                  |                                     |
   |    uint16_t a, b;                |    ; a = r0   b = r1                |
   |                                  |    mov  r1, r0       ; a * 1        |
   |    uint16_t b = a * 21;          |    lsl  r0, r0, #2                  |
   |                                  |    add  r1, r1, r0   ; + a * 4      |
   |                                  |    lsl  r0, r0, #2                  |
   |                                  |    add  r1, r1, r0   ; + a * 16     |
   +----------------------------------+-------------------------------------+


Conversão entre tipos numéricos
-------------------------------

A representação dos tipos numéricos diferem entre si no número de *bits*
e na representação de sinal.
Existe por vezes a necessidade de alterar a representação de valores.
Por exemplo, afetar um valor guardado numa variável representada a oito *bits* (int8_t)
a uma variável representada a dezasseis *bits* (int16_t), ou o contrário.

Conversão sem perda de informação
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Na conversão de tipo cujo domínio de representação está contido no domínio
de representação do tipo destino --
representação com menos *bits* para representação com mais *bits* --
não há perda de informação.
Para manter a mesma representação numérica os *bits* de maior peso
recebem o valor zero no caso de valores naturais
ou o valor do *bit* de sinal no caso de valores relativos.

Nos exemplos da :numref:`convert_to_wider` a conversão de 8 para 16 *bits* dá-se
ao carregar as constantes nos registos do processador.
Como o P16 realiza apenas operações a 16 *bits*,
os valores originalmente representados 8 *bits* devem ser representados a 16 *bits*
ao serem carregados nos registos do processador.

Nos casos  (a) e (b) da :numref:`convert_to_wider`, o aumento para 16 *bits*
consiste em acrescentar zero na parte alta de R0.
Esse resultado é obtido pela funcionamento das instruções ``mov  r0, #10`` e ``mov  r0, #22``
que afetam a parte alta de R0 com zero.

Nos casos (c) e (d) da :numref:`convert_to_wider`, o aumento para 16 *bits*
consiste em propagar o *bit* de sinal para a parte alta do destino. No caso (c)
a parte alta de R0 recebe 0xff porque se trata de representar o valor -3.
No caso (d) a parte alta da variável, representada em R2, recebe em todas
as posições um valor igual ao *bit* de maior peso de R0 (*bit* de sinal do valor original).

.. table:: Conversão de tipo menor para tipo maior
   :widths: auto
   :align: center
   :name: convert_to_wider

   +--------+----------------------------------+----------------------------------+
   |        | .. code-block:: c                | .. code-block:: asm              |
   |        |                                  |                                  |
   |        |    uint8_t a;                    |    ; a = r0   b = r1             |
   | \(a\)  |    uint16_t b;                   |                                  |
   |        |    a = 10;                       |    mov   r0, #10                 |
   |        |    b = a;                        |    mov   r1, r0                  |
   +--------+----------------------------------+----------------------------------+
   |        | .. code-block:: c                | .. code-block:: asm              |
   |        |                                  |                                  |
   |        |    uint8_t a;                    |    ; a = r0   b = r1             |
   | \(b\)  |    int16_t b;                    |                                  |
   |        |    a = 22;                       |    mov   r0, #22                 |
   |        |    b = a;                        |    mov   r1, r0                  |
   +--------+----------------------------------+----------------------------------+
   |        | .. code-block:: c                | .. code-block:: asm              |
   |        |                                  |                                  |
   |        |    int8_t a;                     |    ; a = r0   b = r1             |
   | \(c\)  |    int16_t b;                    |                                  |
   |        |    a = -3;                       |    mov   r0, #-3                 |
   |        |    b = a;                        |    movt  r0, #0xff               |
   |        |                                  |    mov   r1, r0                  |
   +--------+----------------------------------+----------------------------------+
   |        | .. code-block:: c                | .. code-block:: asm              |
   |        |                                  |                                  |
   |        |    int16_t a;                    |    ; a = r0   b = r2:r1          |
   | \(d\)  |    int32_t b;                    |    mov   r1, r0                  |
   |        |    b = a;                        |    mov   r2, r0                  |
   |        |                                  |    asr   r2, r2, #15             |
   +--------+----------------------------------+----------------------------------+

Conversão com perda de informação
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Na conversão de tipo cujo domínio de representação é diferente
do domínio de representação do tipo destino, pode haver perda de informação.
Para o evitar cabe ao programador garantir
que o valor a converter é representável no domínio do tipo destino.

.. table:: Conversão com possível perda de informação
   :widths: auto
   :align: center
   :name: convert_diferent_domain

   +--------+----------------------------------+----------------------------------+
   |        | .. code-block:: c                | .. code-block:: asm              |
   |        |                                  |                                  |
   |        |    uint16_t a;                   |    ; a = r0   b = r1             |
   | \(a\)  |    uint8_t b;                    |    mov   r2, #0xff               |
   |        |    b = a;                        |    and   r1, r0, r2              |
   +--------+----------------------------------+----------------------------------+
   |        | .. code-block:: c                | .. code-block:: asm              |
   |        |                                  |                                  |
   |        |    int32_t a;                    |    ; a = r1:r0   b = r2          |
   | \(b\)  |    int16_t b;                    |                                  |
   |        |    b = a;                        |    mov   r2, r0                  |
   +--------+----------------------------------+----------------------------------+

