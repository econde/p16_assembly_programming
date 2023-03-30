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
expresso em binário, com **x** a variar entre 0 e n – 1,
sendo n o número de *bits* do multiplicador (m).
A última expressão é um somatório de parcelas da forma M . 2\ :sup:`x` . m\ :sub:`x`.
A multiplicação de M por uma potência inteira de 2 (M.2\ :sup:`x`),
pode ser realizada por uma instrução de deslocamento para a esquerda de M.
O produto de M.2\ :sup:`x` por m\ :sub:`x`, será igual a M.2\ :sup:`x`
se o bit de índice **x** do multiplicador (m) for igual a um, ou será zero,
no caso de m\ :sub:`x` ser zero. A sequência conjunta destas três acções
-- deslocamento de M, produto lógico pelo *bit* m\ :sub:`x`
e adição deste resultado parcial, em somatório, até final
-- justifica a designação *shift-and-add*,
pela qual o algoritmo é conhecido.

Em linguagem C a operação de multiplicação é indicada pelo operador **\*** como na :numref:`multiply1`.
Ao nível da máquina, esta operação pode ser realizada por uma instrução específica de multiplicação,
ou, na sua falta, como no caso do P16, é realizada por uma função auxiliar de multiplicação,
numa situação equivalente à do programa da :numref:`multiply2`.

A utilização de uma função auxiliar, origina um código de chamada como o apresentado na :numref:`multiply3`.

Na secção **.data** definem-se as variáveis **m** e **n**, que servem como operandos (linhas 2 a 5)
e na secção **.bss** definem-se as variáveis **p** e **q** que recebem os resultados (linhas 8 a 11).

O código das linhas 17 a 21 diz respeito à invocação
da função **multiply** com as constantes 4 e 7 como argumentos.
Estes valores são carregados nos registos R0 e R1 (linhas 17 e 18)
como explicado em :ref:`afetacao com constante`.
O resultado, devolvido em R0, é guardado na variável **q** (linhas 20 e 21).

O código das linhas 23 a 29 diz respeito à invocação com
da função **multiply** com os valores das variáveis **m** e **n** como argumentos.
Estes valores são carregados nos registos R0 e R1 (linhas 23 a 26)
e resultado é guardado na variável **p** (linhas 28 e 29)
como explicado em :ref:`acesso a valores em memoria`.

.. table::
   :widths: auto
   :align: center
   :name: xxx

   +----------------------------------------------------------+--------------------------------------------------------+
   | .. literalinclude:: code/multiply_shift_add/multiply.s   | .. literalinclude:: code/multiply_shift_add/multiply.s |
   |    :language: c                                          |    :language: asm                                      |
   |    :lines: 27-30, 46-49                                  |    :lines: 33-44, 56-83                                |
   |    :caption: Utilização de operador multiplicação        |    :caption: Chamada da função de multiplicação        |
   |    :name: multiply1                                      |    :linenos:                                           |
   |                                                          |    :name: multiply3                                    |
   +----------------------------------------------------------+                                                        |
   | .. literalinclude:: code/multiply_shift_add/multiply.s   |                                                        |
   |    :language: c                                          |                                                        |
   |    :lines: 27-30, 51-54                                  |                                                        |
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
   :lines: 86-95
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
   :lines: 97-110
   :caption: Função de multiplicação em *assembly*
   :linenos:
   :name: multiply5

**Código fonte:** :download:`multiply.s<code/multiply_shift_add/multiply.s>`



Divisão
-------

.. O programa seguinte implementa o algoritmo de divisão *shift-and-subtract*.
   Este algoritmo executa um número de iterações igual ao número de bits dos operandos.



Pesquisar um valor num *array*
------------------------------

Neste exemplo é apresentada a programação da função **search**
que procura o valor ``value`` no *array* ``array`` com ``array_size`` elementos.
Caso encontre retorna o indíce da posição onde encontrou,
caso não encontre retorna -1. ::

   int16_t search(uint16_t array[], uint8_t array_size, uint16_t value);

Na :numref:`search1` é apresentado um programa de utilização da função
**search** com duas invocações.

.. literalinclude:: code/search/search.s
   :language: c
   :lines: 26-33
   :caption: Chamada da função **search** em linguagem C
   :linenos:
   :name: search1

Na :numref:`search2` é apresentada uma tradução do programa da :numref:`search1`
para liguagem *assembly*. Da linha 1 até à linha 14 apresenta-se a definicão
dos *arrays* **table1** e **table2** e das variáveis **p** e **q**.
A escrita de sucessivos valores como argumento da diretiva **.word** corresponde
a reservar em memória uma sequência de *words* iniciadas com esses valores.
As *labels* **table1_end** e **table2_end** são utilizadas como referências
no cálculo da dimensão dos *arrays* **table1** e **table2**.
A diferença ``table1_end - table1`` é o número de posições de memória
ocupadas pelo *array* **table1**. O número de elementos é metade deste valor,
porque cada elemento ocupa duas posições de memória (linhas 21 e 28).

A passagem de um *array* como argumento de uma função,
concretiza-se carregando o endereço da primeira posição do *array*
no registo correspondente ao parâmetro (linhas 20 e 27).
Este carregamento utiliza o método explicado em :ref:`carregamento de endereco em registo`.

.. literalinclude:: code/search/search.s
   :language: asm
   :lines: 35-68
   :caption: Chamada da função **search** em linguagem *assembly*
   :linenos:
   :name: search2

.. literalinclude:: code/search/search.s
   :language: c
   :lines: 80-87
   :caption: Função **search** em linguagem C
   :linenos:
   :name: search3

Na :numref:`search3` os parâmetros da função **search**
e a variável local **i** são assinalados com os registos que os suportam.
Por exemplo, na linha 1 ``<r0> uint16_t array[]``
significa que o argumento deste parâmetro é recebido no registo R0.

.. literalinclude:: code/search/search.s
   :language: asm
   :lines: 90-113
   :caption: Função **search** em linguagem *assembly*
   :linenos:
   :name: search4

Na :numref:`search4`, o registo R3 suporta a variável **i** que é usada como índice de acesso ao *array*.
No cálculo do endereço de cada posição ``a[i]``, é necessário multiplicar R3 por dois
porque os elementos do *array* ocupam duas posições de memória.
A instrução ``add  r4, r3, r3`` (linha 8) realiza essa multiplicação afetando R4 com R3 * 2.

O registo R4 foi preservado em cumprimento da convenção de :ref:`utilizacao dos registos`.

**Código fonte:** :download:`search.s<code/search/search.s>`

Ordenar um *array* de valores inteiros
--------------------------------------

O programa seguinte realiza a ordenação de um *array* de números relativos
por ordem crescente, utilizando uma variante do algoritmo de ordenação *bubble sort*.

.. literalinclude:: code/bubble_sort/bubble_sort.s
   :language: c
   :lines: 27-33
   :caption: Chamada da função bubble_sort em linguagem C
   :linenos:
   :name: bubble_sort1

.. literalinclude:: code/bubble_sort/bubble_sort.s
   :language: asm
   :lines: 35-51
   :caption: Chamada da função bubble_sort em linguagem *assembly*
   :linenos:
   :name: bubble_sort2

.. literalinclude:: code/bubble_sort/bubble_sort.s
   :language: c
   :lines: 54-67
   :caption: Função de ordenação de *array* de inteiros em linguagem C
   :linenos:
   :name: bubble_sort3

.. literalinclude:: code/bubble_sort/bubble_sort.s
   :language: asm
   :lines: 70-104
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
   :lines: 129-144
   :caption: Chamada da função histogram_vowel em linguagem C
   :linenos:
   :name: vowel1

.. literalinclude:: code/histogram/vowel.s
   :language: asm
   :lines: 145-205
   :caption: Chamada da função histogram_vowel em linguagem *assembly*
   :linenos:
   :name: vowel2

.. literalinclude:: code/histogram/vowel.s
   :language: c
   :lines: 83-90
   :caption: Função histogram_vowel em linguagem C
   :linenos:
   :name: vowel3

.. literalinclude:: code/histogram/vowel.s
   :language: asm
   :lines: 92-123
   :caption: Função histogram_vowel em linguagem *assembly*
   :linenos:
   :name: vowel4

.. literalinclude:: code/histogram/vowel.s
   :language: c
   :lines: 26-43
   :caption: Função find_vowel em linguagem C
   :linenos:
   :name: vowel5

.. literalinclude:: code/histogram/vowel.s
   :language: asm
   :lines: 45-80
   :caption: Função find_vowel em linguagem *assembly*
   :linenos:
   :name: vowel6
  
**Código fonte:** :download:`vowel.s<code/histogram/vowel.s>`

Chamada recursiva
-----------------

.. literalinclude:: code/factorial/factorial.s
   :language: c
   :lines: 27-33
   :caption: Chamada da função factorial em linguagem C
   :linenos:
   :name: factorial_sort1

.. literalinclude:: code/factorial/factorial.s
   :language: asm
   :lines: 35-67
   :caption: Chamada da função factorial em linguagem *assembly*
   :linenos:
   :name: factorial_sort2

.. literalinclude:: code/factorial/factorial.s
   :language: c
   :lines: 71-78
   :caption: Função factorial em linguagem C
   :linenos:
   :name: factorial_sort3

.. literalinclude:: code/factorial/factorial.s
   :language: asm
   :lines: 80-101
   :caption: Função factorial em linguagem *assembly*
   :linenos:
   :name: factorial_sort4

**Código fonte:** :download:`factorial.s<code/factorial/factorial.s>`
