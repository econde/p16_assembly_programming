Operações sobre valores numéricos
=================================

Nesta secção são realizadas operações sobre valores numéricos constantes ou em variáveis.
As variáveis são representadas em registos do processador.

Afetação
--------
Considerando que as variáveis **a** e  **b** se encontram representadas nos registos R0 e R1,
afetar **a** com **b** corresponde a executar a instrução **mov rd, rs**
que copia o conteúdo do registo R1 para R0.

.. table:: Afectação de variável com outra variável
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
utilizando-se para cada base uma notação sintatica própria.
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

.. table:: Afectação com constante
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
A directiva ``.equ VALUE, -2000`` significa que no texto do programa,
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

Na :numref:`adicao_simples` a diferença entre o caso (a) e o caso (b) é apenas no tipo das variáveis --
(a) valores relativos; (b) valores naturais.
A operação de adição de valores representados em código dos complementos
utiliza exatamente a mesmo processo que a operação de adição de números naturais.
Por isso, se utiliza a instrução **add  rd, rn, rm** nos dois casos.

Subtração
^^^^^^^^^

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
   |    a = c + b;                    |    adc   r1, r3, r5                     |
   +----------------------------------+-----------------------------------------+

Os valores representados a 32 *bits* são guardados no processador em dois registos.
A variável **a** é guardada nos registos R0 e R1, com a parte menos significativa em R0
e a mais significativa em R1. As restantes variáves são noutros registos de modo semelhante.

A operação de adição das variáveis **c** e **d** é realizada em dois passos.
No primeiro passo a instrução ``add  r0, r2, r4`` adiciona
as partes menos significativas das variáveis **a** e **b**
afetando R0 com o resultado e a *flag* Carry com o arrasto.
No segundo passo a instrução ``adc  r1, r3, r5`` adiciona as partes mais significativas
das variáveis com o arrasto produzido na adição anterior (o valor do arrasto pode ser zero ou um).

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

Como na adição a 32 *bits*, primeiro são operadas as partes menos significativas
-- ``sub  r4, r0, r2``. Esta instrução subtrai R2 a R0,
afeta R4 com o resultado e a *flag* C (*carry*) com o arrasto (*borrow*).
A instrução ``sbc  r5, r1, r3`` opera as partes mais significativas
-- subtrai o arrasto mais R3 a R1 e afeta R5 com o resultado.

Multiplicação e divisão
^^^^^^^^^^^^^^^^^^^^^^^

O P16 não dispõe de instruções de multiplicação ou divisão.
Nos processadores em que isso acontece,
estas operações são realizadas programaticamente utilizando as outras instruções.

Exemplos de programação destas operações para o P16 na secção :ref:`multiply`
e na secção Divisão.

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

Afectar o *bit* de peso três da variável **a** com o valor 1,
mantendo o valor dos restantes *bits*.

A instrução ``mov r1, #(1 << 3)`` coloca o valor ``0000 0000 0000 1000`` em R1.
A instrução ``orr r0, r0, r1`` realiza a operação disjunção (*or*)
entre os *bits* das mesmas posições de R0 e R1.
O resultado é o valor original de R0 quando operado com 0 em R1 -- elemento neutro --
ou o valor 1 quando operado com 1 em R1 -- elemento absorvente.

.. table:: Afectar o *bit* três de **a** com 1.
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

Afectar o *bit* de peso doze da variável **a** com o valor 0,
mantendo o valor dos restantes *bits*.

As instruções ``mov r1, #(~(1 << 12) & 0xff)`` e ``movt r1, #(~(1 << 12) >> 8)``
colocam o valor **1110 1111 1111 1111** em R1.
A instrução ``and r0, r0, r1`` realiza a operação conjunção (*and*)
entre os *bits* das mesmas posições de R0 e R1.
O resultado é o valor original de R0 quando operado com 1 em R1 -- elemento neutro --
ou o valor 0 quando operado com 0 em R1 -- elemento absorvente.

.. table:: Afectar o *bit* três de **a** com 0.
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

Afectar o *bit* de peso quatro da variável **a**
com o valor do *bit* de peso treze da variável **b**, mantendo os restantes *bits*.

.. table:: Afectar o *bit* quatro de **a** com o valor do *bit* treze de **b**.
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
ao carregar as contantes nos registos do processador.
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


Avaliação de condições
----------------------

A avaliação de expressões booleanas
consiste em realizar operações aritméticas ou lógicas
que afectem as *flags*.
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

As comparações de valores numéricos baseiam-se no valor das *flags* N, V, C e/ou Z,
resultante de uma operação de subtracção.
A instrução de subtracção que normalmente se usa é a instrução **cmp  rn, rm**,
que é idêntica à instrução **sub  rd, rn, rm**,
com a diferença de não se aproveitar o resultado
(a diferença dos  operandos), apenas as *flags* são afectadas
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
A nmemónica NE corresponde à *flag* Z ser 0,
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
   |                                  |        bcc   if_end                 |
   |    if (a < b)                    |        mov   r2, r0                 |
   |        c = a;                    |    if_end:                          |
   +----------------------------------+-------------------------------------+

No programa da :numref:`compare_less_than` a instrução ``mov  r2, r0``, correspondente a ``c = a``,
não deve ser executada se **a** for maior ou igual a **b**.
A instrução ``cmp  r0, r1`` ao realizar a subtração de R1 a R0
afeta a *flag* C com 1 se **a** for menor a **b**
e afeta a *flag* C com 0 se **a** for maior ou igual a **b**.
A *flag* C assume o valor do arrasto da subtração da posição de peso 16 para a posição de peso 15.
Assim, a instrução ``mov  r2, r0`` não deve ser executada se a *flag* C for 0,
que é o que resulta da utilização da instrução ``bcc  if_end`` (*Branch if flag Carry is Clear*).
Esta instrução transfere a execução para a posição do programa indicada pela *label* ``if_end`` se a *flag* C for 0.

A instrução BCC tem o nome alternativo BHS (*Branch if Higher or Same*).
Onde está a ``bcc  if_end`` poderia estar ``bhs  if_end``.
A nmemónica HS corresponde à *flag* C ser 0,
o que acontece se numa instrução CMP ou SUB o subtraendo for maior ou igual ao subtrator.

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
a solução apresentada realiza a subtracção com os operandos em posições invertidas
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
Para isso realizam-se operações sobre a variável que tranfiram o valor desse *bit*
para a uma *flag*.

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

Valores booleanos
-----------------

Em linguagem C não existem variáveis do tipo booleano.
No entanto qualquer valor numérico do tipo char, short, int ou long
pode ser avaliado do ponto de vista booleano.
O critério é o seguinte: o valor numérico zero é avaliado como **falso**;
um valor numérico diferente de zero é avaliado como **verdadeiro**.

.. table:: Avaliação booleana de uma variável
   :widths: auto
   :align: center
   :name: bool_test

   +------------------------+----------------------+------------------------+
   | .. code-block:: c      | .. code-block:: c    | .. code-block:: asm    |
   |                        |                      |                        |
   |    int a, b;           |    int a, b;         |    ; a = r0   b = r1   |
   |                        |                      |       add   r0, r0, #0 |
   |    if (a)              |    if (a != 0)       |       bzc   if_end     |
   |        b = 3           |        b = 3         |       mov   r1, #3     |
   |                        |                      |    if_end:             |
   +------------------------+----------------------+------------------------+
   | .. code-block:: c      | .. code-block:: c    | .. code-block:: asm    |
   |                        |                      |                        |
   |    int a, b;           |    int a, b;         |    ; a = r0   b = r1   |
   |                        |                      |       add   r0, r0, #0 |
   |    if (!a)             |    if (a == 0)       |       bzs   if_end     |
   |        b = 3           |        b = 3         |       mov   r1, #3     |
   |                        |                      |    if_end:             |
   +------------------------+----------------------+------------------------+
   | \(a\)                  | \(b\)                | \(c\)                  |
   +------------------------+----------------------+------------------------+

No programa :numref:`bool_test` o código das colunas (a) e (b) é equivalente.
Em ambos os casos se pretende avaliar se a variável **a** é igual ou diferente de zero.
A instrução ``add   r0, r0, #0`` ao adicionar zero a R0 não altera o valor original
mas afecta a flag Z em conformidade com o valor de **a**.
-- se **a** for zero a *flag* Z recebe 1; se **a** for diferente de zero a *flag* Z recebe 0.
A *flag* Z é afetada com o valor contrário ao valor booleano.

Das operações de comparação (==, !=, <, >, <=, >=) resultam valores booleanos – verdadeiro ou falso.

Em linguagem C um valor booleano pode ser afectado a uma variável de qualquer tipo numérico
ou ser operado com operadores numéricos.
Para este efeito é necessário convertor o valor booleano para valor numérico.
O critério é o seguinte: o valor booleano **falso** é equivalente ao valor numérico **zero**
e o valor booleano **verdadeiro** é equivalente ao valor numérico **um**.

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

No programa (a) da :numref:`assign_bool`, a variável **y** é afectada com o valor zero ou um,
resultante da conversão para valor numérico, do valor booleano resultado da expressão x == 20.

No programa (b) da :numref:`assign_bool`, a instrução ``cmp  r0, r2`` afecta a *flag* Z
com o resultado da comparação de **x** com 20 -- valor 1 se forem iguais; valor 0 se forem diferentes.
A instrução ``mrs  r1, cpsr`` copia o registo CPSR para R1.
A aplicação da máscara 0000 0000 0000 0001 (linhas 5 e 6), garante em R1
a representação numérica a 16 *bits* do valor da *flag* Z
que está posicionada no *bit* de menor peso de CPSR,
absorvendo o valor das outras *flags* que fazem parte deste registo.

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
as restantes sub-expressões já não serão avaliadas (*lazy avaluation*).
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
