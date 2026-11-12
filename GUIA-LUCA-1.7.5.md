# Luca 1.7.5 — projeção contínua de recorrências no cartão

**Validação:** 218 testes automatizados aprovados.

## O que mudou

As faturas futuras agora incluem todas as cobranças previstas de recorrências ativas com pagamento em **Crédito**, pelos próximos **12 ciclos de fechamento** de cada cartão.

A projeção respeita a frequência e a data original da regra (semanal, mensal ou anual). Ela é apenas uma previsão: não altera `next_due_date`, não gera lançamentos e não grava ocorrências.

Quando uma cobrança real for gerada ou cadastrada manualmente com data, valor, forma de pagamento e descrição compatíveis, a previsão correspondente deixa de aparecer. Pagamentos/estornos reduzem valores já lançados, não previsões futuras.

Recorrências pausadas/inativas e as que usam Pix, Débito ou outra forma que não seja Crédito não entram nas faturas. Alterar o valor de uma regra reflete nas próximas previsões, sem reescrever lançamentos anteriores.

## Atualização no Windows

1. Feche o Luca e o serviço do Telegram, se estiverem abertos.
2. Faça uma cópia de segurança da pasta `data/` e do arquivo `.env`.
3. Extraia o ZIP 1.7.5 em uma pasta nova.
4. Copie a pasta `data/` e o `.env` da instalação anterior para a nova pasta.
5. Não copie `.venv`, `__pycache__` ou `.pytest_cache`.
6. Execute `iniciar.bat`.

Não é necessária migração estrutural do banco para esta versão.

## Como conferir

- Abra **Minhas contas** e confira a seção **Próximas faturas**. Cada ciclo mostra parcelas já cadastradas e previsões de recorrências no crédito.
- Abra **Ver fatura** de um mês futuro. Cada cobrança ainda não lançada aparece com a etiqueta **PREVISTO**.
- Pause uma recorrência para confirmar que ela deixa de aparecer nos ciclos futuros. Reative para voltar a projetá-la.
- Quando o lançamento real for gerado, ele substitui a previsão e o total da fatura não deve duplicar.

O total comprometido inclui a fatura atual, débitos anteriores em aberto e compras/parcelas mais recorrências previstas dentro do horizonte de 12 ciclos. Não representa o pagamento mínimo oficial calculado pelo emissor do cartão.
