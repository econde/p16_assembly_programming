Função
======

“Função” é o termo que se usa na linguagem C para designar uma sequência de instruções
que realizam uma tarefa específica e pode ser invocada de diferentes contextos.
Também se usam na programação em geral termos como “rotina”, “subrotina”, “método”
(em linguagens OO) ou “procedimento” (SQL), com aproximadamente o mesmo significado.

O objectivo da sua utilização é subdividir e organizar os programas,
eventualmente extensos e complexos, em partes mais pequenas,
mais simples e reutilizáveis.

Neste texto usa-se o termo ”função”, por coerência com a utilização da linguagem C.

Uma característica importante num processador é o suporte à implementação de funções,
ou seja, a existência de um mecanismo que possibilite invocar um mesmo troço de programa
a partir de outro ponto do programa e retornar ao ponto de invocação.
Esta funcionalidade é concretizada pela acção que transfere a execução
para o endereço onde reside a função (de modo semelhante a uma instrução de salto)
e simultaneamente memoriza o endereço corrente.
A acção de retorno consiste em repor o endereço memorizado no PC.

No P16, durante a execução de uma instrução, o PC contém o endereço da instrução seguinte.
Se este valor for guardado como o endereço de retorno, fica assegurado o retorno à posição correta.
O endereço de retorno é guardado no registo R14, que devido a esta funcionalidade
tem também o nome de registo de ligação (*link register* ou LR).
A instrução BL, antes de afectar o PC com o endereço da função,
transfere o valor actual do PC para o LR.
O retorno ao ponto de invocação, faz-se copiando o conteúdo de LR para o PC.
Por exemplo, com a instrução ``mov  pc, lr``.

Função sem parâmetros
---------------------

Considere-se a sequência de duas chamadas à função ``void delay()``.

   .. table:: Chamada a função sem parâmetros.
      :widths: auto
      :align: center
      :name: call_function_void

      +----------------------+-------------------------------+
      | .. code-block:: c    | .. code-block:: asm           |
      |                      |    :linenos:                  |
      |                      |                               |
      |    ...               |    ...                        |
      |    delay();          |    bl     delay               |
      |    ...               |    ...                        |
      |    delay();          |    bl     delay               |
      |    ...               |    ...                        |
      |                      |                               |
      | \(a\)                | \(b\)                         |
      +----------------------+-------------------------------+

A chamada a função sem parâmetros e sem valor de retorno
corresponde apenas à execução da instrução bl.
No programa da :numref:`call_function_void` (b), a instrução ``bl delay`` (linhas 2 e 4)
salta para o endereço indicado pela *label* *delay*.

   .. table:: Programa de função sem parâmetros.
      :widths: auto
      :align: center
      :name: function_void

      +--------------------------------------+-------------------------------+
      | .. code-block:: c                    | .. code-block:: asm           |
      |                                      |    :linenos:                  |
      |    void delay(void) {                |                               |
      |        for (int i = 0; i < 100; ++i) |    delay:                     |
      |            ;                         |        mov    r0, #100        |
      |    }                                 |        mov    r1, #0          |
      |                                      |    for:                       |
      |                                      |        cmp    r1, r0          |
      |                                      |        bcc    for_end         |
      |                                      |        add    r1, r1, #1      |
      |                                      |        b      for             |
      |                                      |    for_end:                   |
      |                                      |        mov    pc, lr          |
      |                                      |                               |
      | \(a\)                                | \(b\)                         |
      +--------------------------------------+-------------------------------+

Na função **delay** a variável local **i** tem o âmbito do *for*.
Pode ser suportada num registo do processador.
No caso do programa da :numref:`function_void` (b), é suportada no registo R1.

   .. figure:: figures/bl1.png
      :name: bl1
      :align: center
      :scale: 16%

      Ilustração de chamada a função sem parâmetros

Na primeira chamada, no endereço 0x4306, o processador começa
por transferir o conteúdo de PC (0x4308) para LR
e em seguida afecta o PC com o endereço de **delay** (0x4076).
Na segunda chamada, no endereço 0x430e, o processador realiza acções semelhantes,
com a diferença do valor de LR ser 0x4310.
Ao executar a instrução ``mov pc, lr`` posicionada no final da função,
no endereço 0x4082, o processamento regressa ao endereço 0x4308
na primeira chamada e regressa ao endereço 0x4310
na segunda chamada.


Função com parâmetros
---------------------

Considere-se a sequência de duas chamadas à função **multiply**
com a seguinte assinatura:

   ``uint16_t multiply(uint8_t multiplying, uint8_t multiplier);``

   .. table:: Chamada de função com parâmetros
      :widths: auto
      :align: center
      :name: call_function_param

      +--------------------------------------+-------------------------------+
      | .. code-block:: c                    | .. code-block:: asm           |
      |                                      |    :linenos:                  |
      |    ...                               |                               |
      |    product[2] = multiply(4, 10);     |    mov    r0, #4              |
      |    product[3] = multiply(8, 10);     |    mov    r1, #10             |
      |    ...                               |    bl     multiply            |
      |                                      |    str    r0, [r4, #4]        |
      |                                      |    mov    r0, #8              |
      |                                      |    mov    r1, #12             |
      |                                      |    bl     multiply            |
      |                                      |    str    r0, [r4, #6]        |
      |                                      |                               |
      | \(a\)                                | \(b\)                         |
      +--------------------------------------+-------------------------------+

A função **multiply** tem dois parâmetros -- **multiplying** e **multiplier**
ambos do tipo **uint8_t** -- e retorna um valor do tipo **uint16_t**.
Na fase de chamada, antes da execução de *bl* é necessário passar os argumentos.
O que corresponde a colocar os valores dos argumentos no local que dá suporte aos parâmetros.
Nesta função utilizam-se o registo R0 para passar o primeiro argumento
e o registo R1 para passar o segundo argumento.

No programa (b) da :numref:`call_function_param`, na primeira chamada,
os argumentos 4 e 10, são carregados em R0 e R1 (linhas 1 e 2), respectivamente;
na segunda chamada os argumentos 8 e 12, são carregados em R0 e R1 (linhas 5 e 6), respectivamente.

   .. table:: Programação de função com parâmetros
      :widths: auto
      :align: center
      :name: function_param

      +----------------------------------------------+-------------------------------+
      | .. code-block:: c                            | .. code-block:: asm           |
      |                                              |    :linenos:                  |
      |    uint16_t multiply(uint8_t multiplying,    |                               |
      |                      uint8_t multiplier) {   |    multiply:                  |
      |        uint16_t product = 0;                 |       mov   r2, #0            |
      |        while ( multiplier > 0 ) {            |    while:                     |
      |            product += multiplying;           |       sub   r1, r1, #0        |
      |            multiplier--;                     |       beq   while_end         |
      |        }                                     |       add   r2, r2, r0        |
      |        return product;                       |       sub   r1, r1, #1        |
      |    }                                         |       b     while             |
      |                                              |    while_end:                 |
      |                                              |       mov   r0, r2            |
      |                                              |       mov   pc, lr            |
      |                                              |                               |
      | \(a\)                                        | \(b\)                         |
      +----------------------------------------------+-------------------------------+

No (b) programa :numref:`function_param` assume-se que
os registos de suporte aos parâmetros – R0 e R1 – já contêm os argumentos.
A variável local **product** como não prevalece para além do âmbito desta função
é suportada no registo R2, entre as linhas 2 e 10.
O valor de retorno da função -- o resultado da multiplicação -- é depositado no registo R0 (linha 10).

   .. figure:: figures/bl2.png
      :name: bl2
      :align: center
      :scale: 16%

      Ilustração de chamada a função com parâmetros

Na :numref:`bl2` a instrução ``mov pc, lr``, no endereço 0x8984,
faz o processador retornar ao endereço 0x8a08 na primeira chamada
e ao endereço 0x8a10 na segunda chamada.
Nestas posições estão as instruções ``str r0,[r4,…]``
para guardar o valor retornado pela função **multiply**
que vem no registo R0.

*Stack*
=======

O *stack* é uma zona de memória para salvaguarda temporária
de dados do programa de diversa natureza.
O seu nome advém do tipo de estrutura de dados que implementa ser do tipo *last-in-first-out* (LIFO),
também designada por *stack*.
Esta estrutura de dados tem um funcionamento análogo a uma pilha de objectos:
só se consegue retirar da pilha o objecto que se encontra no topo
-- o que foi lá colocado mais recentemente --
e só se consegue colocar um novo objecto sobre o topo da pilha
-- apenas sobre o objecto anteriormente lá colocado.

O P16 dispõe de um registo específico e duas instruções para manusear o *stack*.
O registo R13, neste contexto designado *stack pointer* (SP),
destina-se a guardar permanentemente o endereço corrente do topo do *stack*.
A instrução **push** coloca o conteúdo de um registo no topo do *stack*
e a instrução **pop** retira um valor do topo do *stack*,
colocando-o num registo.
As instruções **push** e **pop** transferem o conteúdo completo de um registo (uma *word*),
ou seja, não é possível transferir apenas um *byte* como acontece
com as instruções **ldrb** e **strb**.

A instrução **push** começa por decrementar o registo SP de duas unidades
e em seguida transfere o conteúdo do registo indicado para a posição do *stack*
definida por SP.

A instrução **push  rs** é equivalente à sequência ::

   sub  sp, sp, #2
   str  rs, [sp]

A instrução **pop** realiza a operação inversa do **push**.
Começa por incrementar o registo SP de duas unidades
e em seguida transfere o conteúdo da posição do *stack*,
definida por SP, para o registo indicado.

A instrução **pop  rd** é equivalente à sequência ::

   ldr  rd, [sp]
   add  sp, sp, #2

.. figure:: figures/push.png
   :name: push
   :align: center
   :scale: 24%

   Ilustração do funcionamento da instrução **push**

A :numref:`push` ilustra o efeito da execução da instrução **push r11**.
Antes da execução o SP contém o endereço 0x4008.
Ao executar a instrução **push** o processador começa
por decrementar o SP de duas unidades passando para 0x4006.
Em seguida escreve o *byte* menos significativo de R11 (0x55)
na posição de endereço 0x4006
e o byte mais significativo de R11 (0x33) na posição de endereço 0x4007.
O posicionamento dos *bytes* segue o critério *little-ended*.


.. figure:: figures/pop.png
   :name: pop
   :align: center
   :scale: 24%

   Ilustração do funcionamento da instrução **pop**

A :numref:`pop` ilustra o efeito da execução da instrução **pop r12**.
Antes da execução o SP contém o endereço 0x4006.
Ao executar a instrução **pop**, o processador começa por
transferir o conteúdo da posição de endereço 0x4006 (0x55)
para o *byte* menos significativo de R12
e o conteúdo da posição de endereço 0x4006 (0x33)
para o *byte* mais significativo de R12.
Em seguida incrementa o SP para o endereço 0x4008.
O conteúdo das posições de memória 0x4006 e 0x4007 não é alterado,
mas estas posições ficam disponíveis para serem reutilizadas
na próxima instrução **push**.

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

   void f(uint8_t a,  uint16_t b,  int8_t c,  int16_t d)
                  r0           r1         r2          r3

Se os argumentos ocuparem mais que os quatro registos, os restantes são passados no *stack*.
Sendo o argumento mais à direita o primeiro a ser empilhado. ::

   void f(uint8_t a,  uint16_t b,  int8_t c,  int16_t d,  int8_t e,  int16_t f)
                  r0           r1         r2          r3      stack[1]    stack[0]

Se o tipo do parâmetro for um valor codificado a 32 *bits*,
a passagem utiliza dois registos consecutivos.
Cabendo ao registo de menor índice a parte de menor peso do argumento. ::

   void f(uint8_t a,   uint32_t b,  int8_t c)
                  r0            r2:r1      r3

Se o parâmetro for um *array*, independentemente do tipo dos elementos,
o que é passado como argumento é o endereço da primeira posição do *array*. ::

   void f(uint16_t array[], uint8_t dim)
                   r0               r1

Os argumentos de parâmetros dos tipos representados a 8 *bits*
-- char, uint8_t ou int8_t -- são convertidos para representação a 16 *bits*.


Valor de retorno
----------------

O valor de retorno de uma função, caso exista, é devolvido no registo R0.
Se for um valor representado a 32 *bits* é devolvido no par de registos R1:R0,
com a parte de menor peso em R0.
Se o valor de retorno for de tipo representado a 8 *bits* -- char, uint8_t ou int8_t
-- será retornado em R0 com representação a 16 bits.

.. _carregamento de endereco em registo:
.. _utilizacao dos registos:

Utilização dos registos
-----------------------

Uma função pode utilizar os registos de R0 a R3 sem ter de preservar o seu conteúdo original.
Os restantes registos de R4 a R12 devem ser preservados.

Na perspectiva de função chamadora, a função chamada pode modificar os registos R0 a R3, LR e CPSR;

Na perspectiva da função chamada, os conteúdos dos registos de R4 a R12 têm de ser mantidos,
independentemente de serem ou não utilizados.

