Exemplos de programação
=======================

Nos exemplos de programação que se seguem foi suprimido o código de arranque.
Para gerar um executável deve juntar-se
o a definição das secções **.startup** e **.stack**
apresentadas na secção :ref:`codigo de arranque` deste documento.

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
numa situação equivalente à programa na :numref:`multiply2`.

Caso se utilize uma função auxiliar,
ambas as programações originam um código de chamada como o apresentado na :numref:`multiply3`.

Na secção **.data** definem-se as variáveis **m** e **n**, que servem como operandos (linhas 2 a 5)
e na secção **.bss** as variáveis **p** e **q** que recebem os resultados (linhas 8 a 11).

O código das linhas 17 a 21 diz respeito à invocação
da função **multiply** com as constantes 4 e 7 como argumentos.
Este valores são nos registos R0 e R1, nas linhas 17 e 18
como explicado em :ref:`afetacao com constante`.
O resultado, devolvido em R0, é guardado na variável **q** (linhas 20 e 21).

O código das linhas 23 a 29 diz respeito à invocação com
as variáveis **m** e **n** como argumentos.
Estes argumentos são carregados no registos R0 e R1 (linhas 23 a 26)
e o resultado é guardado na variável **p** (linhas 28 e 29)
como explicado em :ref:`valores em memoria`.



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
que implementa em linguagem C o algoritmo enunciado acima.
(As anotações entre **<** e **>** junto de parâmetros e variáveis
servem para evidenciar os registos que as suportam.

.. literalinclude:: code/multiply_shift_add/multiply.s
   :language: c
   :lines: 86-95
   :caption: Função de multiplicação
   :name: multiply4

A implementação em linguagem *assembly* da função **multiply**,
apresentada na :numref:`multiply5`, segue a :ref:`convencoes de programacao de funcoes`.
Designadamente:
assume que os argumentos da função -- **multiplicand** e **multiplier** --
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

**Geração do executável:** ::

   pas multiply.s


Divisão
-------

O programa seguinte implementa o algoritmo de divisão *shift-and-subtract*.
Este algoritmo executa um número de iterações igual ao número de bits dos operandos.

Pesquisar um valor num *array*
------------------------------

Neste exemplo é apresentada a programação de uma função
que procura um dado valor num *array* de valores numéricos (**search**).
Caso encontre retorna o indíce da posição onde encontrou
caso não encontre retorna -1.

Na :numref:`search1` é apresentado um programa de utilização da função
**search** com duas invocações.

.. literalinclude:: code/search/search.s
   :language: c
   :lines: 26-34
   :caption: Procura um valor num *array*
   :linenos:
   :name: search1

Na :numref:`search2` é apresentada uma tradução do programa da :numref:`search1`
para liguagem *assembly*.

Da linha 1 até à linha 16 apresenta-se a definicão das variáveis **table1**, **table2**, **p** e **q**.
A escrita de sucessivos valores como argumento da diretiva **.word** corresponde
a reservar em memória uma sequência de *words* iniciadas com esses valores.
As *labels* **table1_end** e **table2_end** são utilizadas como referências
no cálculo da dimensão dos *arrays*.

Por exemplo, a diferença ``table1_end - table1`` dá o número de posições de memória
ocupadas por ``table1``. O número de posições deste *array* é metade deste valor,
porque cada elemento ocupa duas posições de memória (.word).

A passagem de um *array* como argumento de uma função,
concretiza-se carregando o endereço da primeira posição do *array*
no registo correspondente à posição do parâmetro (linhas 21 e 28).
Esta carregamento utiliza o método explicado em :ref:`carregamento de endereco em registo`.

.. literalinclude:: code/search/search.s
   :language: asm
   :lines: 36-78
   :caption: Chamada da função de procura em *assembly*
   :linenos:
   :name: search2



Ordenar um *array* de valores inteiros
--------------------------------------

Chamadas encadeadas de funções
------------------------------

Chamada recursiva
-----------------
