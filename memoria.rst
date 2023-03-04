.. _valores em memoria:

Valores em memória
==================

Modelo da memória
-----------------

   A arquitetura do P16 define um espaço de endereçamento de 64 Ki posições de memória.
   Cada posição de memória armazena uma palavra de oito *bits* -- um *byte*,
   sendo esta a unidade mínima de endereçamento.

   A :numref:`p16_memory_sapce_bit` representa o espaço de memória ao nível binário.
   Do lado esquerdo os endereços das posições de memória, que vão de `0x0000` a `0xffff`.
   Do lado direito os conteúdos das posições de memória.
   Por exemplo, a posição de memória com endereço `0x0000` contém o *byte* de valor `0x56`
   e a posição de memória com endereço `0xfffd` contém o *byte* de valor `0x00`.

   .. figure:: figures/p16_memory_space_bit.png
      :name: p16_memory_sapce_bit
      :align: center
      :scale: 25%

      Representação do espaço e memória do P16 ao nível binário.

   O P16 é classificado como um processador de 16 *bits*,
   porque processa palavras formadas por 16 *bits* -- também designadas por *words*.
   Armazenada em memória, uma *word* ocupa duas posições de memória consecutivas
   e diz-se alinhada se ocupar como primeira posição, no sentido crescente dos endereços,
   uma posição de endereço par -- o valor do *bit* de menor peso do endereço ser zero.

   A :numref:`little_endian` mostra o valor numérico 262 (0x0106),
   representado em binário, numa palavra de 16 *bits*, armazenada em memória.
   O *byte* de menor peso da palavra (0x06) ocupa a posição de memória de endereço 0x0024
   e o *byte* de maior peso da palavra (0x01) ocupa a posição de memória de endereço 0x0025.
   O posicionamento em que a parte de menor peso da palavra ocupa um endereço menor
   e a parte de maior peso ocupa um endereço maior, designa-se por “little-endian”.

   .. figure:: figures/little_endian.png
      :name: little_endian
      :align: center
      :scale: 25%

      Representação em memória de uma palavra de 16 *bits*, alinhada,
      com posicionamento *little-endian*

   A :numref:`big_endian` mostra uma representação equivalente à da :numref:`little_endian`,
   mas em que o *byte* de menor peso do valor ocupa a posição de memória de endereço 0x0025
   e o *byte* de maior peso ocupa a posição de endereço 0x0024.
   O posicionamento em que a parte de menor peso da palavra ocupa um endereço maior
   e a parte de maior peso ocupa um endereço menor, designa-se por “big-endian”.

   .. figure:: figures/big_endian.png
      :name: big_endian
      :align: center
      :scale: 25%

      Representação em memória de uma palavra de 16 *bits*, alinhada,
      com posicionamento *big-endian*

Acesso a valores em memória
---------------------------

   No P16, o acesso a valores em memória faz-se utilizando as instruções LDR e STR.
   A  instrução LDR copia dados da memória para os registos
   e a instrução STR copia dados dos registos para a memória.
   Nestas instruções, os parâmetros são um registo e a uma posição de memória.
   A especificação do endereço da posição de memória é feita através de registos
   -- endereçamento indirecto. Este modo de endereçamento consiste em utilizar
   o conteúdo de registos do processador como endereço de memória. ::

      ldr    rd, [rn, ...]
      str    rs, [rn, ...]

   Na instrução LDR, o registo **rd** é quem vai receber os dados a ler da memória.
   Na instrução STR, o registo **rs** é quem vai fornecer os dados a escrever na memória.
   Em ambas as instruções, o endereço é definido pela expressão entre parêntesis rectos --
   **[rn, ...]**. O endereço é calculado pela adição do conteúdo de **rn**
   com um segundo componente que pode ser um registo -- **[rn, rm]**
   ou uma constante -- **[rn, #constant]**.

   Num programa, antes da instrução LDR ou STR
   é necessário carregar o endereço da variável no registo **rn**.
   Para simplificar, vamos considerar nos exemplos seguintes,
   que se utiliza a variante com constante e que esta tem o valor zero.
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
   e afecta os 8 *bits* mais significativos com zero.
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
   para os 8 *bits* mais significativos (posicionamento *little ended*).

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

   .. table:: Escrever o valor 0x0x67a4 na variável **y**.
      :widths: auto
      :align: center
      :name: str

      +---------------------+-------------------------+------------------------------+
      | .. code-block:: c   | .. code-block:: asm     | .. image:: figures/str.png   |
      |                     |                         |    :scale: 10%               |
      |    uint16_t y;      |    ;r1 - address of x   |                              |
      |                     |    mov   r0, 0xa4       |                              |
      |    y = 0x67a4       |    movt  r0, 0x67       |                              |
      |                     |    str   r0, [r1]       |                              |
      +---------------------+-------------------------+------------------------------+

   A variável **y** é alojada em memória nas posições de memória 0x0006 e 0x0007.

   O endereço da variável **y** (endereço 0x0006) foi previamente carregado em R1.

   A instrução ``str  r0, [r1]`` copia o valor dos 8 *bits* menos significativos de R0 (valor 0xa4)
   para a posição de memória de endereço 0x0006
   e o valor dos 8 *bits* mais significativos de R0 (valor 0x67)
   para a posição de memória de endereço 0x0007 – posicionamento *little ended*.

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

A solução geral para carregamento de endereços nos registos do processador
passa por utilizar a instrução **ldr  rd, label**.
Esta instrução copia um valor expressoa a 16 *bits*,
armazenado em memória, no endereço definido por *label*,
para o registo **rd**.

   .. table:: Carregamento de endereço em registo.
      :widths: auto
      :align: center
      :name: load_address

      +----------------------------------+-------------------------------------+
      | .. code-block:: c                | .. code-block:: asm                 |
      |    :linenos:                     |    :linenos:                        |
      |                                  |                                     |
      |    uint8_t x = 55;               |        .data                        |
      |                                  |    x:                               |
      |    x++;                          |        .byte  0x55                  |
      |                                  |                                     |
      |                                  |        .text                        |
      |                                  |        mov    r1, #1                |
      |                                  |        ldr    r1, addressof_x       |
      |                                  |        ldrb   r0, [r1]              |
      |                                  |        add    r0, r0, #1            |
      |                                  |        strb   r0, [r1]              |
      |                                  |                                     |
      |                                  |    addressof_x:                     |
      |                                  |        .word  x                     |
      +----------------------------------+-------------------------------------+

O programa da :numref:`load_address` incrementa a variável **x** alojada em memória.
Ao nível da máquina, as operações a realizar são:
ler o conteúdo da variável de memória para registo;
incrementar esse registo;
voltar a escrever esse registo na variável em memória.

Para aceder à variável (ler – LDR ou escrever – STR) é necessário
carregar o endereço da variável num registo porque o P16 não dispõe de endereçamento directo.
A variável **x** é definida em linguagem *assembly*
pela label **x:** seguida da diretiva ``.byte 0x55``,
que significa reservar uma posição de memória inicializada com o valor 0x55.
A diretiva **.data** indica uma zona de memória para variáveis.

Em linguagem *assembly* uma *label* tem um valor associado que é o endereço de memória
do local onde foi colocada a *label:*.

No exemplo da :numref:`load_address`, o símbolo **x** tem um valor associado
que é o endereço da posição de memória assinalada por **x:**.
Essa posição de memória aloja a variável **x** cujo conteúdo inicial é 0x55.

A instrução ``ldr  r1, addressof_x`` carrega em R1 a palavra de 16 *bits*
alojada em memória na posição assinalada pela *label* ``addressof_x:``.
Esse conteúdo é o endereço da variável **x**, definido pela diretiva ``.word x``,
que reserva duas posições de memória inicializadas com o valor do simbolo **x**.

A instrução **ldr  rd,label** usa um método de endereçamento relativo ao PC,
para ler da posição de memória definida por *label*.
O código binário desta instrução, :numref:`ldr_label`,
tem um campo de 6 *bits* (imm6) para codificar,
a distância no espaço de endereçamento a que a *label* se encontra da instrução LDR,
em número de *words* (palavras de 16 *bits*),
no sentido crescente dos endereços.

   .. figure:: figures/ldr_label.png
      :name: ldr_label
      :align: center
      :scale: 20%

      Carregamento em registo do endereço de uma variável

A instrução ``ldr  r1, addressof_x`` carrega 0x6037 em R1 (endereço da variável **x**).
Este valor está armazenado em memória no endereço 0x4022 (posição indicada por ``addressof_x:``).
Esta instrução determina o valor 0x4022 adicionando ao valor atual do PC (0x400a)
o dobro do campo **imm6** (0xb) (0x4022 = 0x400a + 0x0b * 2).
Na fase de codificação binária do programa, o valor **imm6** é calculado como
metade da diferença entre o endereço de ``addressof_x`` e o valor atual do PC ((0x4022 – 0x400a) / 2).
Na fase de execução de uma instrução, o PC contém o endereço da instrução seguinte.
A instrução ``ldr  r1, addressof_x`` ocupa o endereço 0x4008 mas na altura
em que está a ser executada o valor do PC é 0x400a.

Valores em *array*
==================

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

      +------------------------------+-------------------------------+--------------------------------------+
      | .. code-block:: c            | .. code-block:: asm           | .. image:: figures/array_bytes.png   |
      |                              |                               |    :scale: 6%                        |
      |    uint8_t array[] = {       |    ; r0 = address of array    |                                      |
      |        2, 0x23, 0x54, 0x10}; |    ; r1 = i r2 = a            |                                      |
      |    uint16_t a;               |        mov   r1, #0           |                                      |
      |                              |        mov   r4, #10          |                                      |
      |    for (uint16_t i = 0;      |        b     for_cond         |                                      |
      |                 i < 10; ++i) |    for:                       |                                      |
      |        a += array[i]         |        ldrb  r3, [r0, r1]     |                                      |
      |                              |        add   r2, r2, r3       |                                      |
      |                              |        add   r1, r1, #1       |                                      |
      |                              |    for_cond:                  |                                      |
      |                              |        cmp   r1, r4           |                                      |
      |                              |        blo   for              |                                      |
      +------------------------------+-------------------------------+--------------------------------------+

No programa (b) da :numref:`array_bytes` assume-se que o endereço inicial do *array*
foi previamente carregado no registo R0 (endereço 0x4078).
Cada posição deste *array* ocupa uma posição de memória.
O endereço de ``array[i]`` é determinado pela instrução ``ldrb  r3, [r0, r1]``
adicionando o índice i, em R1, ao endereço base do *array* em r0.


   .. table:: Acesso a *array* de *words*.
      :widths: auto
      :align: center
      :name: array_words

      +-------------------------------+-------------------------------+--------------------------------------+
      | .. code-block:: c             | .. code-block:: asm           | .. image:: figures/array_words.png   |
      |                               |                               |    :scale: 5%                        |
      |    int16_t array[] = { 2,     |    ; r0 = address of array    |                                      |
      |        0x5022, 0x56, 0x1011}; |    ; r1 = i r2 = a            |                                      |
      |                               |        mov   r1, #0           |                                      |
      |    int16_t a;                 |        mov   r4, #10          |                                      |
      |                               |        b     for_cond         |                                      |
      |    for (uint16_t i = 0;       |    for:                       |                                      |
      |                 i < 10; ++i)  |        add   r3, r1, r1       |                                      |
      |        a += array[i]          |        ldr   r3, [r0, r3]     |                                      |
      |                               |        add   r2, r2, r3       |                                      |
      |                               |        add   r1, r1, #1       |                                      |
      |                               |    for_cond:                  |                                      |
      |                               |        cmp   r1, r4           |                                      |
      |                               |        blo   for              |                                      |
      +-------------------------------+-------------------------------+--------------------------------------+

No programa da :numref:`array_words`, os elementos do *array* são valores representados a 16 *bits*
-- ocupam duas posições de memória.
O acesso ao elemento ``array[i]`` é realizado pela instrução ``ldr  r3, [r0, r3]``
que acede à posição de memória que resulta da soma de R0 com R3.
Assume-se que R0 tem o endereço da primeira posição do *array* (endereço 0x4076)
e R3 a distância, em posições de memória,
entre o endereço de ``array[i]`` e o endereço de ``array[0]``.
Esta distância é definida pela instrução ``add  r3, r1, r1``
que multiplica o índice **i**, em R1, pela dimensão de cada elemento do *array* (2 bytes).
