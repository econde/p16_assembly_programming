Estrutura dos programas
=======================

Para sustentar a adequada versatilidade na utilização do espaço de endereçamento,
um programa completo é organizado em secções.
As secções mais comuns são: secção para código de inicialização -- **.startup**;
secção para o *stack* -- **.stack**; secção para variáveis inicializadas -- **.data**;
secção para variáveis não inicializadas (segundo a norma da linguagem C são inicializadas com zero) -- **.bss**;
secção para constantes -- **.rodata**
e secção para o código do programa -- **.text**.

.. figure:: figures/program.png
   :name: program
   :align: center
   :scale: 12%

   Composição de um programa por secções

Após a acção *reset* o P16 passa a executar código a partir do endereço 0x0000.
Por isso, a secção **.startup** deve ser localizada no endereço 0x0000
(é o que acontece por omissão, se, como é usual,
for esta a primeira secção do ficheiro fonte).
As restantes secções podem ser localizadas em qualquer endereço do espaço de endereçamento.

Em computadores de uso genérico, em que o espaço de endereçamento é preenchido,
no todo ou em parte, por memória contígua,
a ordem de localização das secções costuma ser:
código, constantes, variáveis inicializadas, variáveis inicilizadas com zero
e por fim o *stack*.

Em computadores de uso específico (sistemas embebidos) o espaço de memória
comporta normalmente uma zona de memória não volátil, de apenas leitura,
onde são localizados o código e as constantes -- secções **.startup**, **.text** e **.rodata** --,
e uma zona de memória volátil, de leitura e escrita,
onde são localizadas as variáveis -- secções **.data**, **.bss** e **.stack**.

.. _codigo de arranque:

Código de arranque
------------------

O SDP16 é um sistema de uso genérico para teste de programas,
com memória volátil do tipo SRAM
na primeira metade do espaço de endereçamento -- endereços de 0x0000 a 0xffff.

O programa da :numref:`startup_code` apresenta-se como um exemplo de código de arranque
que prepara um ambiente de execução estruturado para o SDP16.

.. code-block:: asm
   :linenos:
   :caption: Código de arranque
   :name: startup_code

   	.section .startup
   	b	_start
   	b	.

   _start:
   	ldr	sp, addressof_stack_top
   	mov	r0, pc
   	add	lr, r0, #4
   	ldr	pc, addressof_main
   	b	.

   addressof_stack_top:
   	.word	stack_top

   addressof_main:
   	.word	main

   	.text
   	.rodata
   	.data
   	.bss

   	.stack
   	.equ	STACK_SIZE, 1024
   	.space	STACK_SIZE
   stack_top:

   ;------------------------------

   	.text
   main:
   	; ... código da função main
   	mov	pc, lr

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

No exemplo, a área de memória para *stack* é definida com a directiva **.space**
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

A definição do conteúdo destas secções pode
ser escrito depois da linha 28, repetindo-se a diretiva de secção sem alterar a localização
(`ver aqui <https://p16-assembler.readthedocs.io/pt/latest/pas_assembly_language.html#seccoes>`_).

A localização das secções pode ser alterada através de opções de invocação do p16as
(`ver aqui <https://p16-assembler.readthedocs.io/pt/latest/pas_utilizacao.html#localizacao-das-seccoes>`_).

Nas linhas 7 e 9 encontra-se uma sequência de instruções 
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
   ldr   pc, addressof_main

supera a limitação de alcance, ao carregar diretamente no PC
o endereço da função ``main`` -- ``ldr   pc, addressof_main``.
As duas instruções anteriores servem para carregar em LR
o endereço de retorno.
A instrução ``mov   r0, pc`` coloca em R0 o valor atual de PC,
que é o endereço da instrução ADD,
e a instrução ``add  lr, r0, #4``, ao adicionar quatro a R0,
coloca em LR o endereço da instrução que se encontrar a seguir a LDR.

