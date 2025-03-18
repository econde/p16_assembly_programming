.. _convencoes de programacao de funcoes:

Convenções de programação de funções
====================================

Com vista à estruturação dos programas de modo a fazer-se uma boa utilização dos
recursos (memória e processador)
e à reutilização e análise de partes de programas (funções e variáveis),
é conveniente usarem-se convenções de programação.
Designadamente, representação dos tipos de dados, parâmetros de funções, retorno de valor de funções e vocação dos registos.

Nos exemplos de programa apresentados são utilizadas as convenções descritas seguidamente.

Tipos de dados
--------------

Os tipos numéricos são codificados em código binário natural ou em código dos complementos para dois,
usando 8, 16, 32 ou 64 *bits*. Os dados dos programas são representados segundo estes tipos em valores simples ou em *array*.

.. table:: Representação dos tipos numéricos
   :widths: auto
   :align: center
   :name: representacao_tipos

   +----------------------------+----------+----------+
   | Tipo                       | Memória  | Registo  |
   |                            | (*bits*) | (*bits*) |
   +============================+==========+==========+
   | ``char``                   | 8        | 16       |
   +----------------------------+----------+----------+
   | ``short``                  | 16       | 16       |
   +----------------------------+----------+----------+
   | ``int``                    | 16       | 16       |
   +----------------------------+----------+----------+
   | ``long``                   | 32       | 32       |
   +----------------------------+----------+----------+
   | ``uint8_t`` e ``int8_t``   | 8        | 16       |
   +----------------------------+----------+----------+
   | ``uint16_t`` e ``int16_t`` | 16       | 16       |
   +----------------------------+----------+----------+
   | ``uint32_t`` e ``int32_t`` | 32       | 32       |
   +----------------------------+----------+----------+
   | ``uint64_t`` e ``int64_t`` | 64       | 64       |
   +----------------------------+----------+----------+

Na :numref:`representacao_tipos` apresentam-se as dimensões em número de *bits* com que são representados
os tipos numéricos em função do suporte material: memória principal ou registo do processador.

Os tipos representados na memória com 8 *bits* são representados
nos registos do processador com 16 *bits*.
Esta diferença visa preparar os valores para serem operados pelo P16,
que apenas realiza operações na dimensão dos registos.

O tipo **char** é um tipo para números naturais (*unsigned*) e os
tipos **short**, **int** e **long** são tipos para números relativos (*signed*).

Os tipos representados em memória com dimensões superiores a 16 *bits* ocupam os registos necessários até
perfazer a totalidade da dimensão ou são processados por partes.

Passagem de argumentos
----------------------

As funções que comportam parâmetros recebem os argumentos nos registos do processador,
ocupando a quantidade necessária, por ordem: R0, R1, R2 e R3. ::

   void f(uint16_t a,  int8_t b,  uint8_t c,  char d);
                  r0         r1          r2       r3


Os argumentos dos parâmetros de tipos representados a 8 *bits*
-- char, uint8_t ou int8_t -- são convertidos para representação a 16 *bits*.

.. table:: Passagem de argumentos de vários tipos
   :widths: auto
   :align: center
   :name: function_arguments_1

   +----------------------------------------------+-------------------------------+
   | .. code-block:: c                            | .. code-block:: asm           |
   |                                              |    :linenos:                  |
   |    uint16_t x = 20;                          |                               |
   |    int8_t y = -4;                            |        .data                  |
   |                                              |    x:                         |
   |    f(x, y, 10, 'a');                         |        .word    20            |
   |                                              |    y:                         |
   |                                              |        .byte    -4            |
   |                                              |                               |
   |                                              |        .text                  |
   |                                              |        ldr    r0, x_addr      |
   |                                              |        ldr    r0, [r0]        |
   |                                              |        ldr    r1, y_addr      |
   |                                              |        ldrb   r1, [r1]        |
   |                                              |        lsl    r1, r1, #8      |
   |                                              |        asr    r1, r1, #8      |
   |                                              |        mov    r2, #10         |
   |                                              |        mov    r3, #'a'        |
   |                                              |        bl     f               |
   |                                              |                               |
   |                                              |    x_addr:                    |
   |                                              |       .word   x               |
   |                                              |    y_addr:                    |
   |                                              |       .word   y               |
   |                                              |                               |
   | \(a\)                                        | \(b\)                         |
   +----------------------------------------------+-------------------------------+

.. rubric :: Argumento a 32 *bits*

Se o tipo do parâmetro for um valor codificado a 32 *bits*,
o argumento é colocado em dois registos consecutivos.
Cabendo ao registo de menor índice a parte de menor peso do argumento. ::

   void f(uint8_t a,   int32_t b,  int c);
                 r0        r2:r1      r3

No programa (b) da :numref:`function_arguments_2`,
a variável ``x`` é definida na linha 3 com a diretiva ``.word``.
Os dois argumentos têm o efeito de reservar espaço para duas *words* em memória.
A *word* de endereço menor (a primeira no sentido da escrita) recebe a parte de menor peso
e a seguinte recebe a parte de maior peso.
Como o número é negativo a parte de maior peso tem todos os *bits* a 1,
por isso se utilizou a expressão ``~0`` para a inicializar.

.. table:: Passagem de argumento codificado a 32 bits
   :widths: auto
   :align: center
   :name: function_arguments_2

   +----------------------------------------------+-------------------------------+
   | .. code-block:: c                            | .. code-block:: asm           |
   |                                              |    :linenos:                  |
   |    int32_t x = -20;                          |                               |
   |    int y = 10000;                            |        .data                  |
   |                                              |    x:                         |
   |    f(-4, x, y);                              |        .word    -20, ~0       |
   |                                              |    y:                         |
   |                                              |        .word    10000         |
   |                                              |                               |
   |                                              |        .text                  |
   |                                              |        mov    r0, #-4 & 0xff  |
   |                                              |        movt   r0, #-4 >> 8    |
   |                                              |        ldr    r2, x_addr      |
   |                                              |        ldr    r1, [r2, #0]    |
   |                                              |        ldr    r2, [r2, #2]    |
   |                                              |        ldr    r3, y_addr      |
   |                                              |        ldrb   r3, [r3]        |
   |                                              |        bl     f               |
   |                                              |                               |
   |                                              |    x_addr:                    |
   |                                              |       .word   x               |
   |                                              |    y_addr:                    |
   |                                              |       .word   y               |
   |                                              |                               |
   | \(a\)                                        | \(b\)                         |
   +----------------------------------------------+-------------------------------+


.. rubric ::  *Array* como parâmetro

Se o parâmetro for um *array*, independentemente do tipo dos elementos,
o que é passado como argumento é o endereço da primeira posição do *array*. ::

   void f(uint16_t array[], uint16_t array_size);
                     r0               r1

No programa da :numref:`function_arguments_3`, o primeiro argumento
é o endereço da primeira posição do *array*. Em *assembly* corresponde à *label* ``array:``.
É carregado em R0 com a instrução ``ldr r0, array_addr``
da forma convencional de carregamento de endereços de variáveis em registo
-- :ref:`carregamento de endereco em registo`.

O segundo argumento é o número de elementos do *array*.
Este valor é calculado pela diferença de endereços das *labels* ``array_end:``
e ``array:`` (linha 8), que é a dimensão do *array* em número de *bytes*,
dividida pela dimensão de cada elemento do *array* -- ``lsr    r1, r1, #1``.

.. table:: Passagem de array como argumento
   :widths: auto
   :align: center
   :name: function_arguments_3

   +----------------------------------------------+---------------------------------------------+
   | .. code-block:: c                            | .. code-block:: asm                         |
   |                                              |    :linenos:                                |
   |    int16_t array[] = {-20, 0, 10, -15};      |                                             |
   |                                              |        .data                                |
   |    f(array, sizeof array / sizeof array[0]); |    array:                                   |
   |                                              |        .word    -20, 0, 10, -15             |
   |                                              |    array_end:                               |
   |                                              |                                             |
   |                                              |        .text                                |
   |                                              |        ldr    r0, array_addr                |
   |                                              |        mov    r1, #(array_end - array) / 2  |
   |                                              |        bl     f                             |
   |                                              |                                             |
   |                                              |    array_addr:                              |
   |                                              |        .word   array                        |
   |                                              |                                             |
   | \(a\)                                        | \(b\)                                       |
   +----------------------------------------------+---------------------------------------------+


.. rubric :: Argumentos em *stack*

Se os argumentos ocuparem mais que os quatro registos, os restantes são passados no *stack*.
Sendo o argumento que se escreve mais à direita na linguagem C, o primeiro a ser empilhado. ::

   int16_t sum(int8_t a, int16_t b, int8_t c, int16_t d, int8_t e, int16_t f)
                     r0         r1        r2         r3     stack      stack

No programa (b) da :numref:`function_arguments_4` começa por se processar os
argumentos a passar em *stack*. Nas linhas 14 a 16 empilha-se o argumento -3.
Primeiro -3 é carregado em R0 pelos *movs* das linhas 14 e 15
e em seguida empilhado no *stack* com a instrução ``push r0``.

O argumento ``z`` sofre um processo semelhante,
primeiro o seu conteúdo é carregado em R0 (linhas 17 a 20)
e em seguida é empilhado na posição seguinte do *stack*.
Note que este parâmetro (``int8_t e``) é de tipo representado a 8 *bits*,
mas é passado com representação a 16 *bits*,
tal como acontece com a passagem em registo.

Os restantes argumentos são passados nos registos R0 a R3 da forma convencional (linhas 22 a 29).

.. table:: Passagem de mais de quatro argumentos
   :widths: auto
   :align: center
   :name: function_arguments_4

   +----------------------------------------------+---------------------------------------+
   | .. code-block:: c                            | .. code-block:: asm                   |
   |                                              |    :linenos:                          |
   |    int8_t x = -55;                           |                                       |
   |    int16_t y = 2000;                         |        .data                          |
   |    int8_t z = +100;                          |    x:                                 |
   |    int16_t w;                                |        .byte    -55                   |
   |                                              |    y:                                 |
   |    w = sum(x, y, 2, 3, z, -3);               |        .word    2000                  |
   |                                              |    z:                                 |
   |                                              |        .byte    +100                  |
   |                                              |    w:                                 |
   |                                              |        .word    0                     |
   |                                              |                                       |
   |                                              |        .text                          |
   |                                              |        mov    r0, #-3 &0xff           |
   |                                              |        movt   r0, #-3 >> 8            |
   |                                              |        push   r0                      |
   |                                              |        ldr    r0, z_addr              |
   |                                              |        ldrb   r0, [r0]                |
   |                                              |        lsl    r0, r0, #8              |
   |                                              |        asr    r0, r0, #8              |
   |                                              |        push   r0                      |
   |                                              |        ldr    r0, x_addr              |
   |                                              |        ldrb   r0, [r0]                |
   |                                              |        lsl    r0, r0, #8              |
   |                                              |        asr    r0, r0, #8              |
   |                                              |        ldr    r1, y_addr              |
   |                                              |        ldr    r1, [r1]                |
   |                                              |        mov    r2, #2                  |
   |                                              |        mov    r3, #3                  |
   |                                              |        bl     sum                     |
   |                                              |        mov    r1, #4                  |
   |                                              |        add    sp, r1, sp              |
   |                                              |        ldr    r1, w_addr              |
   |                                              |        str    r0, [r1]                |
   |                                              |                                       |
   |                                              |    x_addr:                            |
   |                                              |        .word  x                       |
   |                                              |    y_addr:                            |
   |                                              |        .word  y                       |
   |                                              |    z_addr:                            |
   |                                              |        .word  z                       |
   |                                              |    w_addr:                            |
   |                                              |        .word  w                       |
   |                                              |                                       |
   | \(a\)                                        | \(b\)                                 |
   +----------------------------------------------+---------------------------------------+


Depois do regresso, a partir da linha 31, é necessário recolocar o registo SP
na posição que tinha antes da linha 16 -- antes do empilhamento do primeiro argumento.

A solução mais intuitiva seria realizar dois *pops* para compensar os *pushs* das linhas 16 e 21.
Seria uma solução viável. Como não é necessário recuperar os conteúdos,
basta \"mover\" o SP duas posições para trás.
Operação que é realizada pela instrução ``add  sp, r1, sp``,
que adiciona quatro unidades ao registo SP.

.. table:: Receção de mais de quatro argumentos
   :widths: auto
   :align: center
   :name: function_arguments_5

   +--------------------------------------------------+---------------------------------------+
   | .. code-block:: c                                | .. code-block:: asm                   |
   |                                                  |    :linenos:                          |
   |    int16_t sum(int8_t a, int16_t b, int8_t c,    |                                       |
   |                int16_t d, int8_t e, int16_t f) { |        .text                          |
   |        return a + b + c + d + e + f;             |    sum:                               |
   |    }                                             |        add   r0, r0, r1               |
   |                                                  |        add   r0, r0, r2               |
   |                                                  |        add   r0, r0, r3               |
   |                                                  |        ldr   r1, [sp]                 |
   |                                                  |        add   r0, r0, r1               |
   |                                                  |        ldr   r1, [sp, #2]             |
   |                                                  |        add   r0, r0, r1               |
   |                                                  |        mov   pc, lr                   |
   |                                                  |                                       |
   | \(a\)                                            | \(b\)                                 |
   +--------------------------------------------------+---------------------------------------+


O programa (b) da :numref:`function_arguments_5`
mostra como aceder aos argumentos passados em *stack*,
utilizando a instrução **ldr** com base no registo SP (linhas 6 e 8).
Este método dispensa a necessidade de desempilhar os argumentos (*pops*).

Valor de retorno
----------------

O valor de retorno de uma função, caso exista, é devolvido no registo R0.
Se for um valor representado a 32 *bits* é devolvido no par de registos R1:R0,
com a parte de menor peso em R0.
Se o valor de retorno for de tipo representado a 8 *bits* -- char, uint8_t ou int8_t
-- será retornado em R0 com representação a 16 bits.

.. _utilizacao dos registos:

Utilização dos registos
-----------------------

Uma função pode utilizar os registos de R0 a R3 sem preservar o seu conteúdo original.
Os restantes registos -- de R4 a R12 e SP -- devem ser preservados.

Na perspetiva de função chamadora, no regresso da invocação a outra função,
o conteúdo dos registos R0 a R3, LR e CPSR podem vir alterados;
o conteúdo dos registos R4 a R12 e o SP não pode vir alterados.

Na perspectiva inversa, a função chamada, deve salvar e restaurar os registos que utilizar de R4 a R12
e assegurar que, imediatamente após a execução da instrução de retorno,
o registo SP aponta a mesma posição de *stack* que apontava
imediatamente antes da execução da instrução de chamada a função.

Os registos R4 a R12 são designados por *callee saved* porque deve ser
a função chamada a preservá-los se os utilizar.

Os registos R0 e R3 são designados por *caller saved* porque deve ser
a função chamadora a preservá-los ao chamar outra função,
caso não queira perder o seu conteúdo.
Deve-se admitir que a função chamada os modifica.

Aplicação das convenções
------------------------

A execução de um programa realiza uma sucessão de chamadas a funções
que pode ser representada por um grafo na forma de árvore.
As últimas funções na cadeia de chamadas, as que não chamam outras funções,
surgem representadas nos extremos do grafo, na posição das folhas da árvore,
e são designadas por \"funções folha\". As restantes funções, as que chamam
outras funções, e são representadas nos nós de ligação dos ramos,
são designadas por \"funções não folha\".

No desenvolvimento de programas em *assembly* é vantajosa a utilização de
padrões de programação e critérios de escolha de registos,
de acordo com as convenções.
Estas práticas facilitam tanto a escrita como a análise dos programas,
e também conduzem à produção de programas eficientes.

Função folha
.............

Na programação de uma função folha deve dar-se preferência à utilização dos registos R0 a R3.
Este registos podem ser utilizados sem se preservar o seu conteúdo.
No caso de não serem suficientes, recorre-se à utilização de registos *callee saved* (R4 a R12).

.. literalinclude:: code/find_min/find_min.s
   :language: c
   :lines: 47-53
   :caption: Função **find_min** em linguagem C
   :linenos:
   :name: find_min3

Na :numref:`find_min3` a função **find_min** possui dois parâmetros
e duas variáveis locais **min** e **i**. Os registos que os suportam são assinalados com <rx>.
Por exemplo, na linha 1 ``<r0> uint16_t array[]``
significa que o argumento deste parâmetro é recebido no registo R0.
Os registos R0 e R1 são utilizados para parâmetros.
Os registo R2 e R3 são os escolhidos para as variáveis locais **min** e **i**.

.. literalinclude:: code/find_min/find_min.s
   :language: asm
   :lines: 55-73
   :caption: Função **find_min** em linguagem *assembly*
   :linenos:
   :name: find_min4

Na :numref:`find_min4`, o registo R3 suporta a variável **i** que é usada como índice de acesso ao *array*.
No cálculo do endereço de cada posição ``array[i]``, é necessário multiplicar R3 por dois,
porque os elementos do *array* ocupam duas posições de memória.
A instrução ``add  r4, r3, r3`` (linha 9) realiza essa multiplicação afetando R4 com R3 * 2.

Como os registos R0 a R3 estão todos a ser utilizados, teve que se recorrer a R4 para este
cálculo intermédio. Segundo a convenção -- :ref:`utilizacao dos registos` --
o conteúdo deste registo deve ser preservado,
o que justifica a utilização das instruções ``push r4`` e ``pop r4``.


Função não folha
.................

A função não folha caracteriza-se por conter chamadas a outras funções.
Para realizar estas chamadas são necessários os registos R0 a R3 para passar os
argumentos a essas funções. Esses registos surgem, ao início da função,
ocupados pelos seus próprio argumentos.
Para libertar este registos e preservar os argumentos, necessários ao longo da função,
transfere-se o seu conteúdo para registos *callee saved*, logo à entrada da função.
Assim, os registos R0 a R3 ficam disponíveis para passar argumentos às funções chamadas,
como também, para serem utilizados em operações intermédias.

A utilização de registos *callee saved* (R4 a R12), tanto para manter argumentos,
como para suportar variáveis locais
garante a manutenção destes dados durante o tempo de vida da função.
Pela aplicação das convenções, as funções chamadas encarregam-se de preservar
o conteúdo destes registos caso necessitem de os utilizar.

.. literalinclude:: code/array_square/array_square.s
   :language: c
   :lines: 34-39
   :caption: Função **array_square** em linguagem C
   :linenos:
   :name: array_square3

A função ``array_square`` apresentada na :numref:`array_square3`,
é uma função não folha, pois invoca a função ``multiply``.
Os argumentos ``result``, ``array`` e ``array_size``,
assim como a variável local ``i``, constituem dados estáveis
que devem ser mantidos durante toda a execução da função.
Os registos R4, R5 e R6 são escolhidos para os argumentos e o registo R7 para a variável local.
Estes registos foram os escolhidos porque, segundo a convenção -- :ref:`utilizacao dos registos` --
a função ``multiply`` não os vai alterar, o que dispensa a função ``array_square``
de qualquer ação de preservação dos seus conteúdos.

.. literalinclude:: code/array_square/array_square.s
   :language: asm
   :lines: 41-66
   :caption: Função **array_square** em linguagem *assembly*
   :linenos:
   :name: array_square4

Nas linhas 7, 8 e 9, os conteúdo dos argumentos são transferidos para os registos
onde vão permanecer durante toda a execução da função.
Na linha 10 a variável ``i`` é inicializada com zero.

A sequência de *pushs* e *pops* nas linha 3 a 6 e 22 a 25,
tratam de salvar e restaurar os conteúdos originais dos registos R4 a R7.
Esta ação resulta da necessidade de cumprir a convenção,
em relação à função chamadora de ``array_square``.
Essa função ao aplicar o mesmo critério, utiliza também esses registos para os
seus dados estáveis.

Uma solução alternativa seria a de envolver o código de chamada com *pushs* e *pops*
dos registos com dados estáveis. Essa solução seria pior porque no caso da chamada à função
ser repetida, como no caso da chamada a ``multiply``, essas instruções seriam executadas
em todas as repetições.

No P16 a instrução BL guarda o endereço de retorno no registo LR.
À entrada de uma função este registo contém o endereço de retorno dessa função.
Se no seu interior for realizada a chamada a outra função como é o caso da
chamada de ``bl multiply``, o registo LR vai receber novo endereço de retorno.
Não sendo tomada nenhuma ação, o endereço de retorno original seria perdido.
É isso que justifica a instrução ``push lr`` na linha 1 para salvar o endereço de retorno original
e a instrução ``pop pc`` na linha 26 para a respetiva reposição.
Como a reposição é para o registo PC, tem também como efeito o retorno à função chamadora.
