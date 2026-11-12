# Luca 1.6.15 — recorrências dentro do detalhe da fatura

## O que mudou

- A tela **Minhas contas → Ver fatura** agora mostra a próxima ocorrência de cada recorrência ativa paga em **Crédito** quando sua data pertence ao ciclo selecionado.
- Essas linhas são identificadas como **PREVISTO** e entram no total da fatura.
- Quando o lançamento é gerado automaticamente ou cadastrado manualmente no mesmo dia e valor, a previsão deixa de aparecer e o lançamento real assume seu lugar. Isso evita duplicidade.
- A tabela **Recorrências** agora exibe a forma de pagamento, facilitando conferir quais regras devem entrar no cartão.

## Conferência do Nubank — dezembro/2026

A imagem enviada mostra R$ 670,00: Nexfit R$ 119,60; Airbnb R$ 225,00; Amazon R$ 17,36; MercadoLivre R$ 32,47; Amazon Br R$ 104,97; Sócio Furacão R$ 124,16; Pier Seguradora R$ 46,44. Os quatro lançamentos que aparecem no detalhe atual do Luca somam R$ 379,80. As recorrências de Academia e Sócio Furacão somam mais R$ 243,76. O Seguro/Pier precisa ser cadastrado como recorrência de crédito de R$ 46,44, com próxima data 22/11/2026, caso essa seja a próxima cobrança real.

Na previsão atual de R$ 654,17, também aparecem iCloud de R$ 19,90 e Spotify de R$ 10,71, que não constam na imagem da fatura de dezembro do Nubank. Se essas duas cobranças forem pagas por débito/Pix ou outra conta, edite suas recorrências para usar a forma correta em vez de Crédito. Não altere a forma sem confirmar como o pagamento realmente ocorre. Internet não aparece na previsão de crédito atual.

Com as três recorrências no crédito (Academia, Sócio Furacão e Seguro/Pier) e iCloud/Spotify fora do crédito, os quatro lançamentos já cadastrados + três previsões somam R$ 670,00.

## Atualização

1. Feche o Luca e faça backup da pasta `data/` e do arquivo `.env`.
2. Extraia a versão 1.6.15 em uma pasta nova.
3. Copie `data/` e `.env` da instalação anterior.
4. Não copie a pasta `.venv`; execute `iniciar.bat` para recriar o ambiente conforme o guia geral.
5. Na tela Recorrências, confira a forma de pagamento e cadastre Seguro Celular/Pier como Crédito, mensal, R$ 46,44, próxima data 22/11/2026, caso essa seja a próxima cobrança real.
6. Abra **Minhas contas → Nubank → Ver fatura → Dezembro/2026**. O total deve refletir as recorrências previstas e os lançamentos já cadastrados.

O pacote não contém banco de dados pessoal nem `.env`.
