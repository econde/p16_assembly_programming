Valores em registo
==================

Na programação em *assembly* do P16,
tendo como referência a linguagem C,
considera-se que os tipos básicos são representados com as dimensões em *bits*
indicadas na :numref:`tipos_dimensoes`.

.. table:: Dimensões dos tipos básicos da linguagem C na arquitetura P16
   :widths: auto
   :align: center
   :name: tipos_dimensoes

   +----------+-----------+
   | Tipo     | Dimensão  |
   +==========+===========+
   | char     | 8         |
   +----------+-----------+
   | short    | 16        |
   +----------+-----------+
   | int      | 16        |
   +----------+-----------+
   | long     | 32        |
   +----------+-----------+

O tipo tpo ``char`` considera-se equivalente a ``unsigned char``.

Os registos e as operações do P16 operam sobre valores a 16 *bits*.
Ao carregar um valor do tipo ``char``, ``int8_t`` ou ``uint8_t``
num registo do processador é necessário extender a representação desse valor
para representação a 16 *bits*.
Para o tipo ``char`` e ``uint8_t`` a extensão consiste em afetar
os *bits* das posições 8 a 15 com o valor zero.
Para o tipo ``int8_t`` a extensão consiste em afetar os *bits* das posições 8 a 15
com o valor do bit da posição 7 (*bit* de sinal).
A questão levanta-se nos tipos char, int8_t e uint8_t.
 do processador Na exemplifca-se o carregamento de valores de tipos básicos em registos do processdor
