Recomendações para escrita em linguagem *assembly*
==================================================

Na escrita de programas em geral, usam-se convenções de formatação para facilitar
a leitura do programa por parte do humano.
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
  (começados por \';\' ou envolvidos por /\* \*/).

* Cada linha contém apenas uma label, uma instrução ou uma directiva.

* Para definir as colunas deve usar-se o carácter TAB
  configurado com a largura de oito espaços.

* As linhas com *label* não devem conter nenhum outro elemento.
  Isso permite usar *labels* compridas sem desalinhar a tabulação
  e criar separações na sequência de instruções,
  que ajudam na interpretação do programa.
