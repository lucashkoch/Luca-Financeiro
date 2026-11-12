# Luca 1.6.13 — Guia de atualização

A versão 1.6.13 adiciona parcelamentos com sequência original e parcelas restantes, geração automática e idempotente de recorrências, saldos iniciais de fatura fora das despesas de consumo, ciclo de cartão em conta bancária e prévia de conciliação CSV.

## Instalação

1. Feche o Luca e faça backup de `data/` e `.env`.
2. Extraia esta versão em uma pasta nova.
3. Copie `.env` e `data/` da instalação anterior. Não copie `.venv/`.
4. Inicie com `iniciar.bat`; as migrações são aplicadas automaticamente.
5. Em **Minhas contas → Fatura**, configure Nubank com fechamento dia `17` e vencimento dia `24`.
6. Abra **Ver fatura** e envie o CSV do Nubank em **Conferir com o CSV do Nubank**.

## Parcelamentos

Ao criar ou editar um parcelamento, escolha se o valor informado é o valor total da compra ou o valor de cada parcela. Preencha o total original, a próxima parcela real e a quantidade restante. Exemplo: próxima `5/12`, restantes `8`. O Luca cria apenas `5/12` até `12/12`.

A edição de grupos antigos não é automática. Consulte `docs/upgrading-to-v1.6.13.md` para os números mais recentes de parcela que aparecem no CSV enviado e para instruções de correção segura.

## Recorrências

O Luca gera lançamentos vencidos automaticamente ao iniciar e a cada minuto enquanto estiver ligado. Desligado, ele recupera o que venceu na próxima inicialização. O botão manual continua disponível, mas repetições não criam uma segunda ocorrência.

## Conciliação

A comparação CSV é uma prévia somente leitura. Ela mostra o que foi localizado, o que só consta no Nubank, o que só consta no Luca e correspondências ambíguas. Você escolhe o que cadastrar ou corrigir; nenhum dado é alterado em lote.

Consulte [`docs/upgrading-to-v1.6.13.md`](docs/upgrading-to-v1.6.13.md) para detalhes e limitações.
