# Luca 1.7.1 — guia de atualização

## O que mudou

O cadastro de compras parceladas voltou ao modelo simples. No lançamento, você informa:

1. A quantidade total de parcelas.
2. Se o valor digitado é o **valor total da compra** ou o **valor de cada parcela**.

Exemplos:

- Compra de R$ 1.200 em 12 vezes: escolha **Valor total da compra**. O Luca cria 12 parcelas de R$ 100,00.
- Compra em 5 vezes de R$ 80: escolha **Valor de cada parcela**. O Luca cria 5 parcelas de R$ 80,00, totalizando R$ 400,00.

Novos parcelamentos sempre começam em 1/N e são programados mensalmente a partir da data informada.

## Histórico existente

Nenhum parcelamento já salvo é renumerado ou apagado. Compras antigas que tenham sido registradas, por exemplo, de 5/12 até 12/12 continuam com essa numeração. Ao editar um grupo antigo, o Luca lê os números das parcelas salvas e preserva a sequência, sem pedir que você informe a próxima parcela nem quantas parcelas restam.

## Atualização

1. Feche o Luca.
2. Faça backup da pasta `data/` e do arquivo `.env`.
3. Extraia esta versão em uma pasta nova.
4. Copie `data/` e `.env` da instalação anterior para a nova pasta.
5. Não copie a pasta `.venv`.
6. Execute `iniciar.bat`.

Não é necessária migração de banco de dados. Mantenha a instalação antiga até conferir os saldos e alguns parcelamentos no histórico.
