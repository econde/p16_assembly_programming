Valores numéricos
=================

Os valores numéricos são representados, ao nível da máquina, em binário, no sistema de significância posicional.
O conjunto dos números naturais têm uma representação direta
e o conjunto de números relativos são codificados em código dos complementos.
Na :numref:`tipos_c_kotlin` apresentam-se os identificadores de tipo,
assim como as dimensões de representação nas linguagens Kotlin e C.

Como a linguagem C não define dimensões concretas para
os tipos numéricos ``char``, ``int``, ``short`` e ``long``,
foi definido, ao nível da `biblioteca normalizada <https://en.cppreference.com/w/c/types/integer>`_,
a existência dos tipos ``intXX_t`` sendo ``XX``
o número de *bits* dessa representação concreta.
A variante ``uintXX_t`` representa valores no conjunto dos números naturais
e a variante ``intXX_t`` representa valores no conjunto dos números relativos.

.. table:: Tipos numéricos da linguagem C e Kotlin
   :widths: auto
   :align: center
   :name: tipos_c_kotlin

   +--------------------------------+-----------------------------------------------+--------------------------------------+
   | Linguagem Kotlin               |           Linguagem C                         | Processador                          |
   +===============+================+======================+========================+============+============+============+
   | **Relativos** | **Naturais**   | **Relativos**        | **Naturais**           | **16 bit** | **32 bit** | **64 bit** |
   +---------------+----------------+----------------------+------------------------+------------+------------+------------+
   | ``Byte``      | ``UByte``      | ``signed char``      | ``unsigned char``      | 1          | 1          | 1          |
   +---------------+----------------+----------------------+------------------------+------------+------------+------------+
   | ``Short``     | ``UShort``     | ``signed short int`` | ``unsigned short int`` | 2          | 2          | 2          |
   +---------------+----------------+----------------------+------------------------+------------+------------+------------+
   | ``Int``       | ``UInt``       | ``signed int``       | ``unsigned int``       | 2          | 4          | 4          |
   +---------------+----------------+----------------------+------------------------+------------+------------+------------+
   | ``Long``      | ``ULong``      | ``signed long int``  | ``unsigned long int``  | 4          | 4          | 8          |
   +---------------+----------------+----------------------+------------------------+------------+------------+------------+
   | ..            | ..             | ``int8_t``           | ``uint8_t``            | 1          | 1          | 1          |
   +---------------+----------------+----------------------+------------------------+------------+------------+------------+
   | ..            | ..             | ``int16_t``          | ``uint16_t``           | 2          | 2          | 2          |
   +---------------+----------------+----------------------+------------------------+------------+------------+------------+
   | ..            | ..             | ``int32_t``          | ``uint32_t``           | 4          | 4          | 4          |
   +---------------+----------------+----------------------+------------------------+------------+------------+------------+
   | ..            | ..             | ``int64_t``          | ``uint64_t``           | 8          | 8          | 8          |
   +---------------+----------------+----------------------+------------------------+------------+------------+------------+

O domínio de valores representável depende da dimensão da palavra em número de *bits*.
Na :numref:`tipos_dimensoes` apresentam-se os domínios de valores representáveis
para as dimensões de palavra de 8, 16, 32 e 64 *bits* para números naturais ou relativos.

A escolha, por parte do programador, do tipo da variável a empregar,
está relacionada com a utilização eficiente da memória,
face ao domínio de representação necessário no programa.


.. table:: Domínio de valores face à dimensão da palavra
   :widths: auto
   :align: center
   :name: tipos_dimensoes

   +----------+-----------------------------------+---------------------------------------------+
   | Dimensão | Naturais                          | Relativos                                   |
   +==========+============+======================+======================+======================+
   | (bits)   | **Mínimo** | **Máximo**           | **Mínimo**           | **Máximo**           |
   +----------+------------+----------------------+----------------------+----------------------+
   | 8        | 0          | 255                  | -128                 | +127                 |
   +----------+------------+----------------------+----------------------+----------------------+
   | 16       | 0          | 65535                | -32768               | +32767               |
   +----------+------------+----------------------+----------------------+----------------------+
   | 32       | 0          | 4294967295           | -2147483648          | +2147483647          |
   +----------+------------+----------------------+----------------------+----------------------+
   | 64       | 0          | 18446744073709551615 | -9223372036854775808 | +9223372036854775807 |
   +----------+------------+----------------------+----------------------+----------------------+
