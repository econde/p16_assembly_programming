Estrutura dos programas
=======================

.. _estrutura de programa:

Para assegurar a adequada versatilidade na utilização do espaço de endereçamento,
de acordo com as caraterísticas dos dispositivos de memória que o populam
e as necessidades da aplicação,
um programa é repartido por zonas de memória. Destacam-se três zonas:
zona de código binário das instruções, zona de variáveis e zona de *stack*.
Estas zonas de memória são designadas na literatura inglesa por *segment* ou *section*.
Aqui vais ser utilizado o termo "secção".

Vão ser definidos dois modelos de organização dos programas em secções:
um modelo mínimo e um modelo compatível com a linguagem C.

Modelo de organização mínimo
----------------------------

Neste modelo definem-se três secções:
   * **.text** -- para o código binário das instruções e dados constantes;
   * **.data** -- para as variáveis que são modificadas durante a execução do programa;
   * **.stack** -- para suporte da execução estruturada com base em rotinas (funções).

.. figure:: figures/section_map_min.png
   :name: section_map_min
   :align: center
   :scale: 12%

   Organização do programa em três secções

.data
.....

As variáveis são alojadas na secção **.data**.

+----------------------------------------------------------+--------------------------------------------------------+
| .. literalinclude:: code/multiply_add_add/multiply.s     | .. literalinclude:: code/multiply_add_add/multiply.s   |
|    :language: c                                          |    :language: asm                                      |
|    :lines: 95-97                                         |    :lines: 90,100-107                                  |
+----------------------------------------------------------+--------------------------------------------------------+

.text
.....

O código binário das instruções do programa, assim com dados auxiliares ao código,
são alojados na secção **.text**.

+----------------------------------------------------------+--------------------------------------------------------+
| .. literalinclude:: code/multiply_add_add/multiply.s     | .. literalinclude:: code/multiply_add_add/multiply.s   |
|    :language: c                                          |    :language: asm                                      |
|    :lines: 23-26                                         |    :lines: 29,33-49                                    |
+----------------------------------------------------------+--------------------------------------------------------+

.stack
......

A secção **.stack** é uma zona de memória para salvaguarda de dados temporários,
necessários à execução do programa.
O conteúdo inicial desta zona de memória é indiferente.

A diretiva ``.space`` na linha 33 da :numref:`map_min`
reserva a área de memória cuja dimensão pode ser ajustada através do
símbolo ``STACK_MAX_SIZE``.

Preparação
..........

O código do programa é organizado em funções. A primeira função a ser chamada
é a função **main** e todo o processamento útil é desencadeado a partir dela.

Após a ação reset, o P16 passa a executar código a partir do endereço 0x0000.
Neste endereço é localizado código que realiza
as necessárias preparações antes de invocar a função **main**
-- linha 11 da :numref:`map_min`.

Neste modelo mínimo de execução,
a preparação consiste apenas em inicializar o registo SP
com o endereço de topo da secção ``.stack`` --
linhas 10, 14 e 15 da :numref:`map_min`.

Localização
...........

A dimensão e a localização das secções no espaço de endereçamento
designa-se por mapa de memória.
As secções são localizadas pela ordem com que são escritas no ficheiro fonte do programa.
O endereço da secção seguinte é o endereço par imediatamente disponível
depois do fim da secção anterior.
A dimensão de cada secção depende do número de instruções
e do número de variáveis e respetivos tipos, definidos no seu interior.

.. literalinclude:: code/multiply_add_add/multiply.s
   :language: c
   :caption: Estrutura de código padrão para o modelo de organizaçãp mínimo
   :linenos:
   :name: map_min
   :lines: 1-16, 29-32, 87-93, 109-116

O código completo do programa utilizado como exemplo nesta secção pode ser descarregado daqui:
:download:`multiply.s<code/multiply_add_add/multiply.s>`.

O comando ::

   $ p16as multiply.s

gera os ficheiros multiply.hex e multiply.lst.

O mapa de memória do programa, que faz parte do ficheiro
:download:`multiply.lst<code/multiply_add_add/multiply.lst>`,
pode ser visualizado nas linhas 5 a 7 da
:numref:`multiply_lst`.

A secção **.text** começa no endereço 0x0000 por ser a que aparece em primeiro lugar
no ficheiro fonte do programa.

O endereço da secção **.data** é posterior à secção **.text** porque aparece em segundo lugar.
O seu endereço inicial é 0x0044 porque é essa a dimensão da secção anterior.

.. literalinclude:: code/multiply_add_add/multiply.lst
   :language: c
   :caption: Mapa de memória
   :linenos:
   :name: multiply_lst
   :lines: 1-8

As instruções ``b  _start`` e ``b  .`` que aparem no início da secção **.text**
são localizadas respetivamente nos endereços 0x0000 e 0x0002.
Estes endereços são fixados pela arquitetura P16, como os pontos de entrada em execução
dos acontecimentos *reset* e interrupção, respetivamente.
Razão pela qual o código de preparação não é localizado exatamente no endereço 0x0000.

A instrução ``b  .`` no endereço 0x0002 é apenas figurativa.
Este programa não está capacitado para realizar processamento de interrupções.

Modelo compatível com a linguagem C
-----------------------------------

Num modelo de organização mais elaborado como o da linguagem C,
há a destacar a separação das variáveis por três secções:
   * **.data** -- secção para variáveis inicializadas;
   * **.bss** -- secção para variáveis não inicializadas (`Wikipedia <https://en.wikipedia.org/wiki/.bss>`_);
   * **.rodata** -- secção para constantes.

A razão para a criação da secção **.rodata** é esta poder ser alojada
em memória de apenas leitura (ROM).

A razão para a criação da secção **.bss** para as variáveis não inicializadas
é a redução da memória necessária para o armazenamento do programa.

Segundo a norma da linguagem C,
o código de inicialização preenche a secção **.bss**
com o valor zero, antes de invocar a função principal (**main**).

No que respeita ao código binário, é feita uma separação do código de preparação
-- secção **.startup** -- do código específico da aplicação -- secção **.text**.
Esta separação torna independentes as localizações destas duas categorias de código.

.. figure:: figures/program.png
   :name: program
   :align: center
   :scale: 12%

   Composição de um programa por secções, compatível com a linguagem C


Em computadores de uso genérico, em que o espaço de endereçamento é preenchido,
no todo ou em parte, por memória contígua,
a ordem de localização das secções costuma ser:
código, constantes, variáveis inicializadas, variáveis inicializadas com zero
e por fim o *stack*.

Em computadores de uso específico (sistemas embebidos) o espaço de memória
comporta normalmente uma zona de memória não volátil, de apenas leitura,
onde são localizados o código, as constantes e os valores iniciais das variáveis
-- secções **.startup**, **.text**, **.rodata** e cópia da **.data** --,
e uma zona de memória volátil, de leitura e escrita,
onde são localizadas as variáveis -- secções **.data**, **.bss** e **.stack**.

Na linguagem C as variáveis globais -- as que são definidas externamente às funções --,
como a variável **a** na linha 1
ou as variáveis locais estáticas, como a variável **b** na linha 4,
da :numref:`var_global_static_local`,
são alojadas nas secções .data, .bss ou .rodata, segundo certos atributos.

.. code-block:: c
   :linenos:
   :name: var_global_static_local
   :caption: Variável global e variável local estática

   int a;

   void function() {
           static int b;
           . . .
   }

.data
.....

Na secção **.data** são alojadas as variáveis com valores iniciais diferentes de zero.

+----------------------------------------------------+----------------------------------------------------------+
| .. code-block:: c                                  | .. code-block:: asm                                      |
|                                                    |                                                          |
|                                                    |           .data                                          |
|    uint8_t x = 23;                                 |   x:                                                     |
|                                                    |           .byte   23                                     |
|    static int i = 10000;                           |   i:                                                     |
|                                                    |           .word   10000                                  |
|    int integers[] = {100, 200, 300, 400};          |   integers:                                              |
|                                                    |           .word   100, 200, 30, 400                      |
|    char vowels[] = {'a', 'e', 'i', 'o', 'u';       |   vowels:                                                |
|                                                    |           .byte   'a', 'e', 'i', 'o', 'u                 |
|    char message[] = "Aqui, tudo bem!";             |   message:                                               |
|                                                    |           .asciz  "Aqui, tudo bem!"                      |
|    uint16_t bitmap[] = {                           |   bitmap:                                                |
|            0xA008, 0x0450, 0x7888, 0x4554, 0x9900  |           .word   0xA008, 0x0450, 0x7888, 0x4554, 0x9900 |
|    };                                              |                                                          |
|                                                    |                                                          |
|    uint32_t bigger = {0x7FFF3355};                 |   bigger:                                                |
|                                                    |           .word   0x3355, 0x7FFF                         |
+----------------------------------------------------+----------------------------------------------------------+


.bss
....

Na secção **.bss** são alojadas as variáveis com valores iniciais iguais a zero.

Na linguagem C as variáveis globais sem valor inicial explícito,
são inicializadas a zero.

+----------------------------------------------------+----------------------------------------------------------+
| .. code-block:: c                                  | .. code-block:: asm                                      |
|                                                    |                                                          |
|                                                    |           .bss                                           |
|    uint8_t x;                                      |   x:                                                     |
|                                                    |           .byte   0                                      |
|    int i = 0;                                      |   i:                                                     |
|                                                    |           .word   0                                      |
|    int integers[1000];                             |   integers:                                              |
|                                                    |           .space  1000 * 2, 0                            |
|    char vowels[20];                                |   vowels:                                                |
|                                                    |           .space  20, 0                                  |
|    uint16_t bitmap[10] = {0};                      |   bitmap:                                                |
|                                                    |           .space  10 * 2                                 |
|    static uint32_t bigger;                         |   bigger:                                                |
|                                                    |           .word   0, 0                                   |
+----------------------------------------------------+----------------------------------------------------------+

.rodata
.......

As constantes são alojadas na secção **.rodata**.

+-------------------------------------+---------------------------------------+
| .. code-block:: c                   | .. code-block:: asm                   |
|                                     |                                       |
|                                     |           .rodata                     |
|    const uint8_t x = 23;            |   x:                                  |
|                                     |           .byte   23                  |
|    const char newline = '\n';       |   newline:                            |
|                                     |           .byte   'n'                 |
|    static const int pi = 31415;     |   pi:                                 |
|                                     |           .word   31415               |
|    print("String literal\n");       |   L0:                                 |
|                                     |           .asciz  "String literal\n"  |
+-------------------------------------+---------------------------------------+

.startup
........

A secção **.startup** é uma secção de código. É separa da secção **.text**
para que estas secções possam ser localizadas separadamente.
A secção **.startup** tem obrigatoriamente que abranger o endereço 0x0000.

.. _codigo de arranque:

Código de arranque para o SDP16
-------------------------------

O SDP16 é um sistema de uso genérico para teste de programas.
A primeira metade do se espaço de endereçamento -- endereços de 0x0000 a 0x7fff --,
está preenchido com memória SRAM (volátil).
Os programas em teste são carregados nesta zona, a partir do endereço 0x0000.

Após a ação *reset*, o P16 passa a executar código a partir do endereço 0x0000.
Por isso, a secção **.startup** deve ser localizada no endereço 0x0000
(é o que acontece por omissão, se, como é usual,
for esta a primeira secção do ficheiro fonte).
As restantes secções podem ser localizadas em qualquer endereço do espaço de endereçamento.

O programa da :numref:`startup_code` apresenta-se como um exemplo de código de arranque
que prepara um ambiente de execução estruturado para o SDP16, compatível com linguagem C.
Este estabelece a existência e a posição das secções como descritas na :numref:`program`,
inicializa o registo SP com endereço de topo da secção **.stack**
e realiza uma chamada com ligação à função **main**.

.. literalinclude:: code/histogram/vowel.s
   :language: asm
   :caption: Código de arranque
   :linenos:
   :name: startup_code
   :lines: 1-5, 17-27, 32-36, 40-44

Como o endereço 0x0002 é reservado ao atendimento de interrupções,
a primeira instrução a executar, localizada no endereço 0x0000,
é **b  _start** para que a execução prossiga noutro local.
Mesmo quando não se utilizam as interrupções,
o endereço 0x0002 deve ser preenchido pela instrução **b  .** (surge necessariamente na linha 3).
Se, por algum erro, o processador atender uma interrupção inesperada,
o processamento não se descontrola -- o processador ficará retido a executar indefinidamente esta instrução.

Para suporte à execução do programa,
entendido como uma cadeia hierárquica de chamadas a funções,
conforme ocorre na linguagem C, é necessário definir a área de memória dedicada ao *stack*
e a inicialização do registo *stack pointer* (SP) antes de se invocar a função **main**.

No exemplo, a área de memória para *stack* é definida com a diretiva **.space**
com a dimensão de 1024 *bytes*, confinada entre o início da secção *.stack*
e a *label* **stack_top** (linhas 24 a 26).
O registo SP é inicializado, na linha 6, com o valor da *label* **stack_top**
-- que corresponde ao endereço a seguir ao endereço mais alto da secção **.stack**
-- porque no P16 o empilhamento evolui no sentido descendente
com decremento prévio do apontador na instrução **push** (*full descending stack*).

A instrução **b  .** que vemos na linha 10,
mantém a execução controlada no caso da função **main** retornar.

As definições que aparecem nas linhas 1, 18, 19, 20, 21 e 23,
definem a existência das secções
**.startup**, **.text** e **.rodata**, **.data**, **.bss** e **.stack**,
assim como a sua localização relativa no espaço de endereçamento.
A definição do conteúdo das secções pode
ser escrita em qualquer lugar do restante programa.
Basta repetir a diretiva de secção.
(`ver aqui <https://p16-assembler.readthedocs.io/pt/latest/pas_assembly_language.html#seccoes>`_).

A localização das secções pode ser definida explicitamente
através de opções de invocação do p16as
(`ver aqui <https://p16-assembler.readthedocs.io/pt/latest/pas_utilizacao.html#seccoes>`_).

Nas linhas 7 a 9 encontra-se uma sequência de instruções
que realiza um salto com ligação para a função ``main``,
equivalente a ``bl  main``.
Este código visa ultrapassar o limite de alcance da instrução BL.

O endereço do salto é calculado como um deslocamento, ascendente ou descendente,
em relação ao PC (endereçamento relativo).
O número limitado de *bits* no código binário da instrução BL,
para codificação deste deslocamento,
tem como efeito uma limitação no alcance do salto.

O deslocamento é codificado com 11 *bits* em código de complementos
-- um valor positivo provoca um avanço no PC e um valor negativo provoca um recuo.
Como os saltos são sempre para endereços pares,
o *bit* de menor peso não é registado no código da instrução, sendo utilizados apenas 10 bits.
Na prática o intervalo situa-se entre os endereços PC + 1022 e PC - 1024.
Um endereço fora deste intervalo não é alcançável pela instrução BL.

A sequência ::

   mov   r0, pc
   add   lr, r0, #4
   ldr   pc, main_addr

supera a limitação de alcance, ao carregar diretamente no PC
o endereço da função ``main`` -- ``ldr   pc, main_addr``.
As duas instruções anteriores servem para carregar em LR
o endereço de retorno.
A instrução ``mov   r0, pc`` coloca em R0 o valor atual de PC,
que é o endereço da instrução ADD,
e a instrução ``add  lr, r0, #4``, ao adicionar quatro a R0,
coloca em LR o endereço da instrução que se encontrar a seguir a LDR.

Inicialização da secção **.bss**
--------------------------------

A secção **.bss** destina-se a alojar variáveis sem valor inicial explícito.
A justificação para a exitência de uma secção separada da secção **.data**,
onde são alojadas as variáveis com valor inicial explícito,
é a não necessidade de ocupar espaço no ficheiro objeto
(do Inglês `object file <https://en.wikipedia.org/wiki/Object_file>`_).
No caso do P16, o ficheiro objeto é o ficheiro produzido pelo **p16as** com extensão **hex**.

A linguagem C define que variáveis estáticas sem valor inicial explícito
são alojadas na secção **.bss** e inicializadas a zero.
Faz parte da preparação do ambiente de execução compatível com a linguagem C,
a inicialização a zero da àrea de memória atribuida à secção **.bss**.

Na :numref:`startup_code` apresenta-se um módulo de arranque para o PDS16
em o código das linhas 6 a 15 é responsável por esta operação.

Este código baseia-se nas *labels* ``bss_start`` e ``bss_end``.
Estas são pré-definidas nas linhas 37 e 39 como marcação de início
e de fim da secção **.bss**. Todo o conteúdo da secção **.bss** é inserida depois da *label* ``bss_start``
(`ver aqui <https://p16-assembler.readthedocs.io/pt/latest/pas_assembly_language.html#seccoes>`_).
A secção **.bss_end**, utilizada apenas para inserção da label ``bss_end``,
permanecerá por localização implicíta imediatamente após a secção **.bss**
(`ver aqui <https://p16-assembler.readthedocs.io/pt/latest/pas_utilizacao.html#localizacao-das-seccoes>`_).

A instrução ``str  r2, [r0]``, na linhs 11, escreve sucessivamente *words*
de valor zero nas posições de memória indicadas por R0.
Este vai iterar, de dois em dois endereços, desde o endereço de ``bss_start``
até ao endereço de ``bss_end``, presente em R1.
Estes endereços são pares porque correspondem a endereços de início de secção,
que por definição, são sempre pares.

.. literalinclude:: code/histogram/vowel.s
   :language: asm
   :caption: Código de arranque com inicialização de **.bss**
   :linenos:
   :name: startup_code_bss
   :lines: 1-44

O código completo do programa utilizado como exemplo nesta secção pode ser descarregado daqui:
:download:`vowel.s<code/histogram/vowel.s>`.
