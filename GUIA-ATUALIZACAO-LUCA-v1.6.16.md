# Luca 1.6.16 — duplicar lançamentos e revisão geral

## Novidade

Na tela **Lançamentos**, cada linha elegível tem o botão **Duplicar** (ícone de duas folhas). Ao clicar:

- o formulário abre preenchido com os dados do lançamento;
- a data é definida para hoje, mas pode ser alterada;
- o lançamento original permanece intacto;
- ao salvar, é criado um novo lançamento;
- se a origem for uma parcela, apenas o valor daquela parcela é copiado como um lançamento simples. O grupo de parcelas original não é duplicado;
- saldos iniciais consolidados de fatura não podem ser duplicados.

Confira descrição, conta, forma de pagamento, valor e data antes de salvar.

## Atualização

1. Feche o Luca.
2. Faça backup da pasta `data/` e do arquivo `.env`.
3. Extraia esta versão em uma pasta nova.
4. Copie a pasta `data/` e o `.env` antigos para a nova instalação.
5. Execute `iniciar.bat`.
6. Confira o histórico, o saldo das contas e as faturas antes de remover a versão anterior.

Não há migração de banco de dados nesta versão. Nenhum lançamento existente é alterado ou excluído. O `.env.example` não traz mais `LUCA_ACCESS_PASSWORD`, pois essa variável não tinha implementação; o login por perfil continua sendo usado.

## Revisão do projeto

Consulte `REVISAO-GERAL-LUCA-1.6.16.md` para as melhorias sugeridas, agrupadas por prioridade. Nesta versão, nenhuma tela ou funcionalidade financeira foi removida.
