# Atualização do Luca — versão 1.6.12

Esta versão corrige o cálculo e a edição de compras parceladas.

## O que mudou

- No formulário do painel, o valor informado com mais de uma parcela é o **valor de cada parcela**. O Luca mostra o total calculado (valor mensal × quantidade).
- No assistente em linguagem natural, frases como “comprei por R$ 1.500 em 5 parcelas” são tratadas como valor total; frases como “5 parcelas de R$ 300 cada” são tratadas como valor por parcela. A prévia informa qual interpretação foi usada.
- Parcelas com datas futuras passam a compor o planejamento do crédito, mesmo se a primeira parcela ainda não venceu. O mês da primeira parcela aparece em “Crédito deste mês”; os meses seguintes aparecem em “Parcelas futuras”. Elas não reduzem o saldo bancário nem entram no resultado realizado antes da data.
- É possível editar uma compra parcelada inteira a partir de qualquer uma de suas parcelas. O Luca recalcula datas e valores de todas as parcelas do grupo.

## Atualizar

1. Feche o Luca.
2. Faça backup de `data/` e `.env`.
3. Extraia a versão 1.6.12 em uma pasta nova.
4. Copie o `.env` e a pasta `data/` da instalação anterior. Não copie `.venv/`.
5. Execute `iniciar.bat`. A instalação automática de áudio continua funcionando.

Não há migração estrutural do banco nesta versão.

## Corrigir uma compra já cadastrada com o valor dividido incorretamente

O Luca não altera automaticamente compras antigas, porque não tem como saber se o valor salvo originalmente era o total da compra ou o valor mensal pretendido. Para corrigir um grupo como “Sócio Furacão”:

1. Abra **Histórico financeiro** e localize qualquer parcela de “Sócio Furacão”.
2. Clique no lápis. O Luca abrirá a compra inteira e mostrará a quantidade de parcelas.
3. No campo **Valor de cada parcela**, informe `124,16` (o valor mensal que você queria).
4. Confira se a quantidade está em `12` e se a primeira data está em `23/11/2026`.
5. Salve. O Luca atualizará as 12 parcelas para R$ 124,16 cada, com total de R$ 1.489,92.

Se a primeira parcela estiver em novembro, a composição esperada será R$ 124,16 em “Crédito deste mês” e R$ 1.365,76 em “Parcelas futuras”, antes de pagamentos. Os valores efetivos serão recalculados conforme pagamentos já registrados.

## Verificações

- 172 testes automatizados aprovados.
- Testes de criação de 12 parcelas de R$ 124,16, primeira data futura, composição mensal do crédito, edição de grupo e pagamento FIFO.
- Sintaxe Python e JavaScript verificada.
