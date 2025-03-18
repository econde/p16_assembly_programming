Exemplos de programação
=======================

Nos programas de exemplo que se seguem foi suprimido o código de arranque.
Para gerar um executável deve juntar-se
o código apresentado na secção :ref:`codigo de arranque` deste documento.

.. _multiply:

Multiplicação
-------------

Nos processadores que não dispõem de instrução de multiplicação,
esta operação poderá ser realizada por programação.
Um algoritmo comummente utilizado baseia-se na aplicação das seguintes expressões:

.. math::

   P = M . m = M . (2^{n-1} . m_{n-1} + 2^{n-2} . m_{n-2} + ... + 4 . m_2 + 2 . m_1 + m_0) =

     = M . 2^{n-1} . m_{n-1} + M . 2^{n-2} . m_{n-2} + ... + M . 4 . m_2 + M . 2 . m_1 + M . m_0

onde m\ :sub:`x` representa cada um dos dígitos do multiplicador (m),
expresso em binário, com **x** a variar entre 0 e n - 1,
sendo n o número de *bits* do multiplicador (m).
A última expressão é um somatório de parcelas da forma M . 2\ :sup:`x` . m\ :sub:`x`.
A multiplicação de M por uma potência inteira de 2 (M.2\ :sup:`x`),
pode ser realizada por uma instrução de deslocamento para a esquerda de M.
O produto de M.2\ :sup:`x` por m\ :sub:`x`, será igual a M.2\ :sup:`x`
se o bit de índice **x** do multiplicador (m) for igual a um, ou será zero,
no caso de m\ :sub:`x` ser zero. A sequência conjunta destas três ações
-- deslocamento de M, produto lógico pelo *bit* m\ :sub:`x`
e adição deste resultado parcial, em somatório, até final
-- justifica a designação *shift-and-add*,
pela qual o algoritmo é conhecido.

Em linguagem C a operação de multiplicação é indicada pelo operador **\*** como na :numref:`multiply1`.
Ao nível da máquina, esta operação pode ser realizada por uma instrução específica de multiplicação,
ou, na sua falta, como no caso do P16, é realizada por uma função auxiliar de multiplicação,
numa situação equivalente à do programa da :numref:`multiply2`.

A utilização de uma função auxiliar, origina um código de chamada como o apresentado na :numref:`multiply3`.

Na secção **.data** definem-se as variáveis **m** e **n**, que servem como operandos (linhas 28 a 31)
e as variáveis **p** e **q** que recebem os resultados (linhas 32 a 35).

O código das linhas 2 a 6 diz respeito à invocação
da função **multiply** com as constantes 4 e 7 como argumentos.
Estes valores são carregados nos registos R0 e R1 (linhas 2 e 3)
como explicado em :ref:`afetacao com constante`.
O resultado, devolvido em R0, é guardado na variável **q** (linhas 5 e 6).

O código das linhas 8 a 14 diz respeito à invocação com
da função **multiply** com os valores das variáveis **m** e **n** como argumentos.
Estes valores são carregados nos registos R0 e R1 (linhas 8 a 11)
e resultado é guardado na variável **p** (linhas 13 e 14)
como explicado em :ref:`acesso a valores em memoria`.

.. table::
   :widths: auto
   :align: center
   :name: xxx

   +----------------------------------------------------------+--------------------------------------------------------+
   | .. literalinclude:: code/multiply_shift_add/multiply.s   | .. literalinclude:: code/multiply_shift_add/multiply.s |
   |    :language: c                                          |    :language: asm                                      |
   |    :lines: 90-93, 19-22                                  |    :lines: 4, 29, 33-57, 88, 96-103                    |
   |    :caption: Utilização de operador multiplicação        |    :caption: Chamada à função ``multiply``             |
   |    :name: multiply1                                      |    :linenos:                                           |
   |                                                          |    :name: multiply3                                    |
   +----------------------------------------------------------+                                                        |
   | .. literalinclude:: code/multiply_shift_add/multiply.s   |                                                        |
   |    :language: c                                          |                                                        |
   |    :lines: 90-93, 24-27                                  |                                                        |
   |    :caption: Utilização de função de multiplicação       |                                                        |
   |    :name: multiply2                                      |                                                        |
   |                                                          |                                                        |
   +----------------------------------------------------------+--------------------------------------------------------+

Na :numref:`multiply4` apresenta-se a função **multiply**
que implementa em linguagem C, o algoritmo enunciado acima.
Em cada ciclo *while* é adicionada à variável *product* uma parcela do somatório.

(As anotações entre **<** e **>** junto de parâmetros e variáveis locais
servem para indicar os registos que as suportam.)

.. literalinclude:: code/multiply_shift_add/multiply.s
   :language: c
   :lines: 59-68
   :caption: Função de multiplicação
   :name: multiply4

A implementação em linguagem *assembly* da função **multiply**,
apresentada na :numref:`multiply5`, segue a :ref:`convencoes de programacao de funcoes`.
Designadamente, assume que os argumentos da função -- **multiplicand** e **multiplier** --
estão presentes nos registos R0 e R1;
o resultado da função -- produto de **multiplicand** por **multiplier** --
produzido em R2 é transferido para R0 antes da função retornar;
o registo R2 foi utilizado para suporte à variável local **product** sem necessidade de ser preservado.

A assunção de que os argumentos estão presentes em R0 e R1
é coerente com a programação realizada na :numref:`multiply3`.

.. literalinclude:: code/multiply_shift_add/multiply.s
   :language: asm
   :lines: 70-83
   :caption: Função de multiplicação em *assembly*
   :linenos:
   :name: multiply5

**Código fonte:** :download:`multiply.s<code/multiply_shift_add/multiply.s>`



Divisão
-------

O algoritmo de divisão apresentado é a versão binária do algoritmo normalmente utilizado
para dividir com papel e lápis.

Neste algoritmo, o dividendo é percorrido da extremidade esquerda para a direita --
do dígito mais significativo para o menos significativo.

Na versão binária, tem um número de passos igual ao número de bits do dividendo.
Em cada passo são realizadas as seguintes operações:
   1. É extraido um dígito do dividendo -- um bit. Este bit assume peso unitário em cada passo (linhas 5 e 6).
   2. O quociente e o resto obtidos no passo anterior, são promovidos ao peso seguinte (linhas 7 e 8).
   3. É criado um dividendo intermédio formado pelo resto promovido adicionado ao dígito extraído do dividendo (linha 9).
   4. Deste dividendo intermédio é extraido o maior múltiplo possível do divisor (linhas 10 -- 12).
      Na base binária o múltiplo possível é apenas o valor 1.
   5. Esse múltiplo adiciona-se ao quociente e o que fica da extração é o resto (linhas 11 e 12).

Este algoritmo é também designado por *shift-and-subtract*.

.. literalinclude:: code/divide_shift_sub/divide.s
   :language: c
   :lines: 46-61
   :caption: Função de divisão em C
   :linenos:
   :name: divide1

A implementação em linguagem *assembly* da função ``divide``,
apresentada na :numref:`divide2`, segue a :ref:`convencoes de programacao de funcoes`.
Designadamente, assume que os argumentos da função -- ``dividend`` e ``divisor`` --
estão presentes nos registos R0 e R1;
o resultado da função -- quociente de ``dividend`` por ``divisor`` --
produzido em R4 é transferido para R0 antes da função retornar (linha 17).
Sendo uma função folha, deve dar-se preferência aos registos R0-R3 para suporte às variáveis locais.
Os registos R0 e R1 estão ocupados com argumentos. Como as variáveis locais são três,
o registo R4 foi utilizado para suportar a variável local ``quocient``
porque os registos R2 e R3 foram utiizados para as variáveis ``i`` e ``rest``.

Segundo as convenções, o conteúdo dos registos R4 e seguintes devem ser preservado,
caso estes registos sejam utilizados.
O que justifica a realização de PUSH/POP de R4 nas linhas 2 e 18.

.. literalinclude:: code/divide_shift_sub/divide.s
   :language: asm
   :lines: 64-82
   :caption: Função de divisão em *assembly*
   :linenos:
   :name: divide2

**Código fonte:** :download:`divide.s<code/divide_shift_sub/divide.s>`


Procurar um valor num *array*
-----------------------------

A função **search** procura ``value`` em ``array`` com ``array_size`` elementos.
Caso encontre, retorna o índice da posição onde encontrou,
caso não encontre, retorna -1. ::

   int16_t search(uint16_t array[], uint8_t array_size, uint16_t value);

Na :numref:`search1` é apresentado um programa de utilização da função
**search** com duas invocações.

.. literalinclude:: code/search/search.s
   :language: c
   :lines: 86-89, 14-17
   :caption: Chamada da função **search** em linguagem C
   :linenos:
   :name: search1

Na :numref:`search2` é apresentada uma tradução do programa da :numref:`search1`
para linguagem *assembly*. Da linha 30 até à linha 42 apresenta-se a definição
dos *arrays* ``table1`` e ``table2`` e das variáveis ``p`` e ``q``.
A escrita de sucessivos valores como argumento da diretiva ``.word`` corresponde
a reservar em memória uma sequência de *words* iniciadas com esses valores.
As *labels* ``table1_end`` e ``table2_end`` são utilizadas como referências
no cálculo da dimensão dos *arrays* ``table1`` e ``table2``.
A diferença ``table1_end - table1`` é o número de posições de memória
ocupadas pelo *array* ``table1``. O número de elementos é metade deste valor,
porque cada elemento ocupa duas posições de memória (linhas 6 e 13).

A passagem de um *array* como argumento de uma função,
concretiza-se carregando o endereço da primeira posição do *array*
no registo correspondente ao parâmetro (linhas 5 e 12).
Este carregamento utiliza o método descrito em :ref:`carregamento de endereco em registo`.

.. literalinclude:: code/search/search.s
   :language: asm
   :lines: 1, 20-46, 83-84, 92-103
   :caption: Chamada da função **search** em linguagem *assembly*
   :linenos:
   :name: search2

.. literalinclude:: code/search/search.s
   :language: c
   :lines: 49-55
   :caption: Função **search** em linguagem C
   :linenos:
   :name: search3

Na :numref:`search3` os parâmetros da função ``search``
e a variável local ``i`` são assinalados com os registos que os suportam.
Por exemplo, na linha 1 ``<r0> uint16_t array[]``
significa que o argumento deste parâmetro é recebido no registo R0.

.. literalinclude:: code/search/search.s
   :language: asm
   :lines: 57-79
   :caption: Função **search** em linguagem *assembly*
   :linenos:
   :name: search4

Na :numref:`search4`, o registo R3 suporta a variável **i** que é usada como índice de acesso ao *array*.
No cálculo do endereço de cada posição ``a[i]``, é necessário multiplicar R3 por dois
porque os elementos do *array* ocupam duas posições de memória.
A instrução ``add  r4, r3, r3`` (linha 7) realiza essa multiplicação afetando R4 com R3 * 2.

O registo R4 foi preservado em cumprimento da convenção de :ref:`utilizacao dos registos`.

**Código fonte:** :download:`search.s<code/search/search.s>`

Ordenar um *array* de valores inteiros
--------------------------------------

O programa seguinte realiza a ordenação de um *array* de números inteiros relativos
por ordem crescente, utilizando uma variante do algoritmo de ordenação *bubble sort*.

.. literalinclude:: code/bubble_sort/bubble_sort.s
   :language: c
   :lines: 85-88, 13-15
   :caption: Chamada da função bubble_sort em linguagem C
   :linenos:
   :name: bubble_sort1

.. literalinclude:: code/bubble_sort/bubble_sort.s
   :language: asm
   :lines: 17-26, 90-96
   :caption: Chamada da função bubble_sort em linguagem *assembly*
   :linenos:
   :name: bubble_sort2

.. literalinclude:: code/bubble_sort/bubble_sort.s
   :language: c
   :lines: 28-41
   :caption: Função de ordenação de *array* de inteiros em linguagem C
   :linenos:
   :name: bubble_sort3

.. literalinclude:: code/bubble_sort/bubble_sort.s
   :language: asm
   :lines: 44-78
   :caption: Função de ordenação de *array* de inteiros em linguagem *assembly*
   :linenos:
   :name: bubble_sort4

**Código fonte:** :download:`bubble_sort.s<code/bubble_sort/bubble_sort.s>`

Chamadas encadeadas de funções
------------------------------

Histograma de vogais
....................

.. literalinclude:: code/histogram/vowel.s
   :language: c
   :lines: 164-172, 117-122
   :caption: Chamada da função histogram_vowel em linguagem C
   :linenos:
   :name: vowel1

.. literalinclude:: code/histogram/vowel.s
   :language: asm
   :lines: 125-158, 174-189
   :caption: Chamada da função histogram_vowel em linguagem *assembly*
   :linenos:
   :name: vowel2

.. literalinclude:: code/histogram/vowel.s
   :language: c
   :lines: 73-81
   :caption: Função histogram_vowel em linguagem C
   :linenos:
   :name: vowel3

.. literalinclude:: code/histogram/vowel.s
   :language: asm
   :lines: 83-113
   :caption: Função histogram_vowel em linguagem *assembly*
   :linenos:
   :name: vowel4

.. literalinclude:: code/histogram/vowel.s
   :language: c
   :lines: 17-33
   :caption: Função which_vowel em linguagem C
   :linenos:
   :name: vowel5

.. literalinclude:: code/histogram/vowel.s
   :language: asm
   :lines: 36-70
   :caption: Função which_vowel em linguagem *assembly*
   :linenos:
   :name: vowel6

**Código fonte:** :download:`vowel.s<code/histogram/vowel.s>`

Chamada recursiva
-----------------

.. literalinclude:: code/factorial/factorial.s
   :language: c
   :lines: 116-119,14-17
   :caption: Chamada da função factorial em linguagem C
   :linenos:
   :name: factorial_sort1

.. literalinclude:: code/factorial/factorial.s
   :language: asm
   :lines: 114,121-127,1,19-40
   :caption: Chamada da função factorial em linguagem *assembly*
   :linenos:
   :name: factorial_sort2

.. literalinclude:: code/factorial/factorial.s
   :language: c
   :lines: 44-51
   :caption: Função factorial em linguagem C
   :linenos:
   :name: factorial_sort3

.. literalinclude:: code/factorial/factorial.s
   :language: asm
   :lines: 55-74
   :caption: Função factorial em linguagem *assembly*
   :linenos:
   :name: factorial_sort4

**Código fonte:** :download:`factorial.s<code/factorial/factorial.s>`
