Estrutura dos programas
=======================

Para sustentar a adequada versatilidade na utilização do espaço de endereçamento,
um programa completo é organizado em secções.
As secções mais comuns são: secção para código de inicialização -- **.startup**;
secção para o *stack* -- **.stack**; secção para variáveis inicializadas -- **.data**;
secção para variáveis inicializadas com zero -- **.bss**;
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

.. _codigo de arranque:

Código de arranque
------------------

.. code-block:: asm
   :linenos:

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

   	.data
   	;  ... variáveis do programa

   	.text
   main:
   	; ... código da função main
   	mov	pc, lr

   	.section	.stack
   	.space	1024
   stack_top:

Como o endereço 0x0002 é reservado ao atendimento de interrupções,
a primeira instrução a executar, localizada no endereço 0x0000,
é **b _start** -- para prosseguir a execução noutro local.
Mesmo quando não se utilizam as interrupções,
o endereço 0x0002 deve ser preenchido pela instrução **b .** (surge necessariamente na linha 3).
Se, por algum erro, o processador atender uma interrupção inesperada
o processamento não se descontrola -- o processador ficará retido a executar indefinidamente esta instrução.

Para suporte à execução do programa,
entendido como uma cadeia hierárquica de chamadas a funções,
conforme ocorre na linguagem C, é necessário definir a área de memória dedicada ao *stack*
e a inicialização do registo *stack pointer* (SP) antes de se invocar a função **main**.

No exemplo, a área de memória para *stack* é definida com a directiva **.space**
com a dimensão de 1024 *bytes*, confinada entre o início da secção *.stack*
e a *label* **stack_top** (linhas 26 a 28).
O registo SP é inicializado, na linha 6, com o valor da *label* **stack_top**
-- que corresponde ao endereço a seguir ao endereço mais alto da secção **.stack**
-- porque no P16 o empilhamento evolui no sentido descendente
com decremento prévio do apontador na instrução **push** (*full descending stack*).

A instrução **b .** que vemos na linha 10,
mantém a execução controlada no caso da função **main** retornar.

.. _convencoes de programacao de funcoes:

Convenções de programação de funções
====================================
Para reutilizar as mesmas funções em diversos programas
e para que essas funções possam ser escritas por programadores diferentes,
é conveniente usar regras que facilitem a interoperabilidade.
Designadamente, representação dos tipos de dados, parâmetros de funções, retorno de valor de funções e vocação dos registos.

Nos exemplos de programa apresentados são utilizadas as convenções descritas seguidamente.

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

Utilização dos registos
-----------------------

Uma função pode usar os registos de R0 a R3 sem ter de preservar o seu conteúdo original.
Os restantes registos de R4 a R12 devem ser preservados.

Na perspectiva de função chamadora, a função chamada pode modificar os registos R0 a R3, LR e CPSR;

Na perspectiva da função chamada, os conteúdos dos registos de R4 a R12 têm de ser mantidos,
independentemente de serem ou não utilizados.

Recomendações para escrita em linguagem *assembly*
==================================================

Na escrita de programas em geral, usam-se convenções de formatação para facilitar a leitura.
Em seguida lista-se um conjunto de regras geralmente utilizadas na programação em linguagem *assembly*
e que são aplicadas nos programas de exemplo.

* O texto do programa é escrito em letra minúscula,
  excepto os identificadores de constantes.

* Nos identificadores formados por várias palavras
  usa-se como separador o carácter ‘_’ (sublinhado).

* O programa é disposto na forma de uma tabela de quatro colunas.
  Na primeira coluna insere-se apenas a *label* (se existir),
  na segunda coluna a mnemónica da instrução ou a directiva,
  na terceira coluna os parâmetros da instrução ou da directiva
  e na quarta coluna os comentários até ao fim da linha
  (começados por \';\' ou envolvidos por \'/\* \*/\').

* Cada linha contém apenas uma label, uma instrução ou uma directiva.

* Para definir as colunas deve usar-se o carácter TAB
  configurado com a largura de oito espaços.

* As linhas com *label* não devem conter nenhum outro elemento.
  Isso permite usar *labels* compridas sem desalinhar a tabulação
  e cria separações na sequência de instruções,
  que ajuda na interpretação do programa.
