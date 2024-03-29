.. _valores em memoria:

Valores em memória
==================

Modelo da memória
-----------------

A arquitetura do P16 endereça ao espaço de memória com palavras de 16 *bits*,
o que proporciona um alcance a :math:`2^{16}` (65536 ou 64 Ki) posições de memória.
Cada posição de memória armazena uma palavra de oito *bits* -- um *byte*,
sendo esta a unidade mínima de endereçamento.

A :numref:`p16_memory_space` representa o espaço de endereçamento.
Do lado esquerdo os endereços das posições de memória, que vão de `0x0000` a `0xffff`.
No interior, os conteúdos das posições de memória.
Por exemplo, a posição de memória com endereço `0xFFF9` contém o *byte* de valor `0xA7`.

.. figure:: figures/p16-memory-space.png
   :name: p16_memory_space
   :align: center
   :scale: 25%

   Representação do espaço de endereçamento do P16.

O P16 é classificado como um processador de 16 *bits*,
porque processa palavras formadas por 16 *bits* -- também designadas por *words*.
Armazenada em memória, uma *word* ocupa duas posições de memória consecutivas
e diz-se alinhada se ocupar como primeira posição, no sentido crescente dos endereços,
uma posição de endereço par -- o valor do *bit* de menor peso do endereço ser zero.

A :numref:`p16_memory_space` mostra o valor numérico 262 (0x0106),
representado numa palavra de 16 *bits*, armazenada em memória.
O *byte* de menor peso da palavra (0x06) ocupa a posição de memória de endereço 0xFFFC
e o *byte* de maior peso da palavra (0x01) ocupa a posição de memória de endereço 0xFFD.
O posicionamento em que a parte de menor peso da palavra ocupa um endereço menor
e a parte de maior peso ocupa um endereço maior, designa-se por *little-endian*.


.. _acesso a valores em memoria:

Acesso a valores em memória
---------------------------

No P16, o acesso a valores em memória faz-se utilizando as instruções LDR e STR.
A  instrução LDR copia dados da memória para os registos
e a instrução STR copia dados dos registos para a memória.
Os parâmetros destas instruções são um registo e um endereço de memória.
A especificação do endereço da posição de memória é feita através de registos
-- designa-se por endereçamento indireto. Este modo de endereçamento consiste em utilizar
o conteúdo de registos como endereço de memória. ::

   ldr    rd, [rn, ...]
   str    rs, [rn, ...]

Na instrução LDR, o registo **rd** é quem vai receber os dados a ler da memória.
Na instrução STR, o registo **rs** é quem vai fornecer os dados a escrever na memória.
Em ambas as instruções, o endereço da memória é definido pela expressão entre parêntesis retos --
**[rn, ...]**. O endereço é calculado pela adição do conteúdo de **rn**
com um segundo componente que pode ser um registo -- **[rn, rm]**
ou uma constante -- **[rn, #constant]**.

O endereçamento indireto em que o endereço é definido por duas componentes,
designa-se por endereçamento indexado.
A primeira componente tem o nome de base
e a segunda componente tem o nome de índice.
A base é sempre um registo -- **rn** --, o índice pode ser um registo -- **rm** --
ou uma constante -- **#constant**.

Este esquema de endereçamento é adaptado ao acesso a valores em *array*,
em que o registo base recebe o endereço inicial do *array*
e a segunda componente é utilizada como índice do *array*
(daí a designação de índice).

Nos exemplos seguintes, vão ser realizados acessos a variáveis simples,
basta utilizar a componente base.
Vai ser considerada a variante de instrução com índice constante igual a zero -- **[rn, #0]**
-- situação em que se pode usar a sintaxe **ldr  rd, [rn]** ou **str  rd, [rn]**.


.. rubric :: Ler variável de 8 *bits*

.. table:: Ler a variável **x**, de 8 *bits*, para R0.
   :widths: auto
   :align: center
   :name: ldrb

   +------------------------+------------------------+---------------------------------+
   | .. code-block:: c      | .. code-block:: asm    | .. image:: figures/ldrb.png     |
   |                        |                        |    :scale: 10%                  |
   |    uint8_t z, x = 23;  |    ;r0 - z             |                                 |
   |                        |    ;r1 - address of x  |                                 |
   |    z = x;              |    ldrb    r0, [r1]    |                                 |
   +------------------------+------------------------+---------------------------------+

A variável **x**, do tipo ``uint8_t``, representada em memória com 8 *bits*,
é alojada na posição de endereço ``0x0005``.

No registo R1 foi previamente carregado o endereço da variável **x** (endereço 0x0005).

A instrução ``ldrb  r0, [r1]`` copia o conteúdo da posição de memória de endereço ``0x0005``
-- o valor 0x23 -- para os 8 *bits* menos significativos de R0
e afeta os 8 *bits* mais significativos com zero.
O valor da variável **x** fica neste momento representado com 16 *bits* no registo R0.

.. rubric :: Ler variável de 16 *bits*

.. table:: Ler a variável **y**, de 16 *bits*, para R0.
   :widths: auto
   :align: center
   :name: ldr

   +-----------------------------+-----------------------+----------------------------+
   | .. code-block:: c           | .. code-block:: asm   | .. image:: figures/ldr.png |
   |                             |                       |    :scale: 10%             |
   |    uint16_t w, y = 0x3e7a;  |    ;r0 - w            |                            |
   |                             |    ;r1 - address of y |                            |
   |    w = y;                   |    ldr    r0, [r1]    |                            |
   +-----------------------------+-----------------------+----------------------------+

A variável **y**, do tipo ``uint16_t``, representada em memória com 16 *bits*,
ocupa as posições de endereços 0x0006 e 0x0007.

No registo R1 foi previamente carregado o endereço da variável **y** (endereço 0x0006).

A instrução ``ldr  r0, [r1]`` copia dois *bytes* da memória para o registo R0.
O conteúdo da posição de memória de endereço 0x0006  -- valor 0x7a --
para os 8 *bits* menos significativos de R0
e o conteúdo da posição de memória de endereço 0x0007 -- valor 0x3e --
para os 8 *bits* mais significativos (posicionamento *little endian*).

.. rubric :: Escrever em variável de 8 *bits*

.. table:: Escrever o valor 0x9b na variável **x**.
   :widths: auto
   :align: center
   :name: strb

   +-------------------------+-----------------------+------------------------------+
   | .. code-block:: c       | .. code-block:: asm   | .. image:: figures/strb.png  |
   |                         |                       |    :scale: 10%               |
   |    uint8_t  x;          |    ;r1 - address of x |                              |
   |                         |    mov    r0, #0x9b   |                              |
   |    x = 0x9b;            |    strb   r0, [r1]    |                              |
   +-------------------------+-----------------------+------------------------------+

A variável **x**, do tipo ``uint8_t``, representada em memória com 8 *bits*,
é alojada na posição de endereço ``0x0005``.

O endereço da variável **x** (endereço 0x0005) foi previamente carregado em R1.

A instrução ``strb  r0, [r1]`` copia o valor dos 8 *bits* menos significativos de R0
(valor 0x9b), para a posição de memória de endereço 0x0005.
Esta instrução é indiferente ao valor presente nos 8 *bits* mais significativos de R0.

.. rubric :: Escrever em variável de 16 *bits*

.. table:: Escrever o valor 0x67a4 na variável **y**.
   :widths: auto
   :align: center
   :name: str

   +---------------------+-------------------------+------------------------------+
   | .. code-block:: c   | .. code-block:: asm     | .. image:: figures/str.png   |
   |                     |                         |    :scale: 10%               |
   |    uint16_t y;      |    ;r1 - address of y   |                              |
   |                     |    mov   r0, 0xa4       |                              |
   |    y = 0x67a4       |    movt  r0, 0x67       |                              |
   |                     |    str   r0, [r1]       |                              |
   +---------------------+-------------------------+------------------------------+

A variável **y** é alojada em memória nas posições de memória 0x0006 e 0x0007.

O endereço da variável **y** (endereço 0x0006) foi previamente carregado em R1.

A instrução ``str  r0, [r1]`` copia o valor dos 8 *bits* menos significativos de R0 (valor 0xa4)
para a posição de memória de endereço 0x0006
e o valor dos 8 *bits* mais significativos de R0 (valor 0x67)
para a posição de memória de endereço 0x0007 – posicionamento *little endian*.

Valores em *array*
------------------

*Arrays* são sequências de variáveis do mesmo tipo,
alojadas em posições de memória contíguas.
As posições do *array* são definidas pelo índice.
O índice 0 corresponde ao endereço mais baixo e os restantes índices a endereços mais altos.
Os acessos aos elementos do *array* são realizados
pelas instruções de endereçamento baseado e indexado: ::

   ldr rd, [rn, rm]   ldr rd, [rn, #imm4]
   str rd, [rn, rm]   str rd, [rn, #imm4]

se se tratar de *array* de *words* ou ::

   ldrb rd, [rn, rm]   ldrb rd, [rn, #imm3]
   strb rd, [rn, rm]   strb rd, [rn, #imm3]

se se tratar de um *array* de *bytes*.

Estas instruções determinam o endereço de acesso à memória somando a **rn**
uma segunda componente: **rm** ou uma constante (**imm4** ou **imm3**).
Em **rn** carrega-se o endereço da primeira posição do *array*
e através da segunda componente (**rm**, **imm4** ou **imm3**)
define-se a posição a que se pretende aceder.

**imm4** e **imm3** representam valores constantes representados com quatro ou três *bits*, respetivamente.


.. table:: Acesso a *array* de *bytes*.
   :widths: auto
   :align: center
   :name: array_bytes

   +---------------------------------------------+-------------------------------+--------------------------------------+
   | .. code-block:: c                           | .. code-block:: asm           | .. image:: figures/array_bytes.png   |
   |                                             |                               |    :scale: 6%                        |
   |    uint8_t array[] = {2, 0x23, 0x54, 0x10}; |    ; r0 - address of array    |                                      |
   |    uint16_t a;                              |    ; r1 - i r2 - a            |                                      |
   |                                             |        mov   r1, #0           |                                      |
   |    for (uint16_t i = 0; i < 10; ++i)        |        mov   r4, #10          |                                      |
   |        a += array[i]                        |        b     for_cond         |                                      |
   |                                             |    for:                       |                                      |
   |                                             |        ldrb  r3, [r0, r1]     |                                      |
   |                                             |        add   r2, r2, r3       |                                      |
   |                                             |        add   r1, r1, #1       |                                      |
   |                                             |    for_cond:                  |                                      |
   |                                             |        cmp   r1, r4           |                                      |
   |                                             |        blo   for              |                                      |
   +---------------------------------------------+-------------------------------+--------------------------------------+

No programa (b) da :numref:`array_bytes` assume-se que o endereço inicial do *array*
foi previamente carregado no registo R0 (endereço 0x4078).
Cada posição deste *array* ocupa uma posição de memória.
O endereço de ``array[i]`` é determinado pela instrução ``ldrb  r3, [r0, r1]``
adicionando o índice i, em R1, ao endereço base do *array* em R0.


.. table:: Acesso a *array* de *words*.
   :widths: auto
   :align: center
   :name: array_words

   +----------------------------------------------------+-------------------------------+--------------------------------------+
   | .. code-block:: c                                  | .. code-block:: asm           | .. image:: figures/array_words.png   |
   |                                                    |                               |    :scale: 5%                        |
   |    int16_t array[] = {2, 0x5022, 0x56, 0x1011};    |    ; r0 - address of array    |                                      |
   |    int16_t a;                                      |    ; r1 - i r2 - a            |                                      |
   |                                                    |        mov   r1, #0           |                                      |
   |    for (uint16_t i = 0; i < 10; ++i)               |        mov   r4, #10          |                                      |
   |        a += array[i]                               |        b     for_cond         |                                      |
   |                                                    |    for:                       |                                      |
   |                                                    |        add   r3, r1, r1       |                                      |
   |                                                    |        ldr   r3, [r0, r3]     |                                      |
   |                                                    |        add   r2, r2, r3       |                                      |
   |                                                    |        add   r1, r1, #1       |                                      |
   |                                                    |    for_cond:                  |                                      |
   |                                                    |        cmp   r1, r4           |                                      |
   |                                                    |        blo   for              |                                      |
   +----------------------------------------------------+-------------------------------+--------------------------------------+

No programa da :numref:`array_words`, os elementos do *array* são valores representados a 16 *bits*
-- ocupam duas posições de memória.
O acesso ao elemento ``array[i]`` é realizado pela instrução ``ldr  r3, [r0, r3]``
que acede à posição de memória que resulta da soma de R0 com R3.
Assume-se que R0 tem o endereço da primeira posição do *array* (endereço 0x4076)
e R3 a distância, em posições de memória,
entre o endereço de ``array[i]`` e o endereço de ``array[0]``.
Esta distância é definida pela instrução ``add  r3, r1, r1``
que multiplica o índice **i**, em R1, pela dimensão de cada elemento do *array* (2 bytes).


Carregamento de valores com aumento de *bits*
---------------------------------------------

Valores dos tipos ``int8_t`` ou ``uint8_t`` são representados em memória com 8 *bits*.
Como o P16 realiza operações de dados a 16 *bits*,
estes valores ao serem carregados em registo,
para serem posteriormente operados, devem ser convertidos para representação a 16 *bits*.

No caso do tipo ``uint8_t``, como a instrução LDRB coloca a parte alta do registo a zero,
nada mais há a fazer.
No caso do tipo ``int8_t``, é necessário propagar o valor do *bit* de sinal
(posição 7) para todos os *bits* da posição 8 até à posição 15.
Para tal pode usar-se o seguinte código depois da instrução LDRB: ::

   lsl	r0, #8
   asr	r0, #8

Com LSL o *bit* de sinal (posição 7) é deslocado para a posição 15
e com ASR é recolocado na posição 7.
A instrução ``asr  r0, #8`` ao deslocar R0 para a direita mantém na posição 15
o valor original e preenche as posições até à 7 com esse valor.

.. _carregamento de endereco em registo:

Carregamento de endereço em registo
-----------------------------------

O programa da :numref:`load_address` incrementa a variável **x** alojada em memória.
Ao nível da máquina, as operações a realizar são:
ler o conteúdo da variável de memória para registo;
incrementar esse registo;
voltar a escrever esse registo na variável em memória.

.. table:: Carregamento de endereço em registo.
   :widths: auto
   :align: center
   :name: load_address

   +----------------------------------+-------------------------------------+
   | .. code-block:: c                | .. code-block:: asm                 |
   |                                  |    :linenos:                        |
   |                                  |                                     |
   |    uint8_t x = 55;               |        .data                        |
   |                                  |    x:                               |
   |    x++;                          |        .byte  0x55                  |
   |                                  |                                     |
   |                                  |        .text                        |
   |                                  |        ldr    r1, x_addr            |
   |                                  |        ldrb   r0, [r1]              |
   |                                  |        add    r0, r0, #1            |
   |                                  |        strb   r0, [r1]              |
   |                                  |                                     |
   |                                  |    x_addr:                          |
   |                                  |        .word  x                     |
   +----------------------------------+-------------------------------------+

A variável **x** é definida em linguagem *assembly*
pela *label* **x:** seguida da diretiva ``.byte 0x55``,
que significa reservar uma posição de memória inicializada com o valor 0x55 (linhas 2 e 3).
A diretiva **.data** indica uma zona de memória para variáveis.

Em linguagem *assembly* uma *label* tem um valor associado que é o endereço de memória
assinalado pela *label*.
No exemplo da :numref:`load_address`, a *label* **x** tem um valor associado
que é o endereço da posição de memória assinalada por **x:** (a que contém 0x55).

Para aceder à variável **x**
-- copiar o seu conteúdo para registo ou alterar o seu conteúdo com o valor de um registo --
utilizam-se, respetivamente, as instruções ``ldrb  r0, [r1]`` e ``strb  [r0, [r1]``
(ver secção :ref:`acesso a valores em memoria`).
A utilização destas instruções implica carregar previamente em R1,
o endereço de **x**.

A solução geral para carregar endereços em registos
passa por utilizar a instrução **ldr  rd, label**.
Esta instrução copia um valor expresso a 16 *bits*,
armazenado em memória, no endereço definido por *label*,
para o registo **rd**.

A instrução ``ldr  r1, x_addr`` carrega em R1 a palavra de 16 *bits*
alojada em memória na posição assinalada pela *label* ``x_addr:``.
Esse conteúdo é o endereço da variável **x**, definido pela diretiva ``.word x``,
que reserva duas posições de memória inicializadas com o valor da *label* **x**.

A instrução **ldr  rd, label** usa um método de endereçamento relativo ao PC,
para definir o endereço da posição de memória especificada por *label*.
Esse endereço é obtido adicionando o valor atual do PC
à constante codificada no campo imm6 do código binário da instrução (ver :numref:`ldr_label`).
Este campo codifica a distância,
no espaço de endereçamento, a que *label* se encontra da instrução **ldr  rd, label**,
em número de *words* (palavras de 16 *bits*),
no sentido crescente dos endereços.

.. figure:: figures/ldr_label.png
   :name: ldr_label
   :align: center
   :scale: 20%

   Carregamento em registo do endereço de uma variável

A instrução ``ldr  r1, x_addr`` carrega 0x6037 em R1 (endereço da variável **x**).
Este valor está armazenado em memória no endereço 0x4022 (posição indicada por ``x_addr:``).
Esta instrução determina o valor 0x4022 adicionando ao valor atual do PC (0x400a)
o dobro do campo **imm6** (0xb) (0x4022 = 0x400a + 0x0b * 2).
Na fase de codificação binária do programa, o valor **imm6** é calculado como
metade da diferença entre o endereço de ``x_addr`` e o valor atual do PC ((0x4022 – 0x400a) / 2).
Na fase de execução de uma instrução, o PC contém o endereço da instrução seguinte.
A instrução ``ldr  r1, x_addr`` ocupa o endereço 0x4008 mas na altura
em que está a ser executada o valor do PC é 0x400a.

