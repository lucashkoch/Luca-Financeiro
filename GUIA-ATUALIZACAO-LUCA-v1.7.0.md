# Atualização do Luca para a versão 1.7.0

Esta versão adiciona ferramentas de organização e conferência financeira. A atualização do banco é aditiva: cria tabelas auxiliares e preserva as contas, lançamentos, parcelamentos e recorrências existentes.

## Antes de atualizar

1. Feche o Luca e o serviço em segundo plano, caso esteja ativo.
2. Faça uma cópia de segurança da pasta `data/`.
3. Guarde uma cópia do arquivo `.env`.
4. Extraia o ZIP da versão 1.7.0 em uma pasta nova. Não extraia por cima da instalação em uso.
5. Copie a pasta `data/` e o `.env` para a nova instalação. Não copie `.venv`, caches ou logs.
6. Execute `iniciar.bat`. As novas tabelas serão criadas automaticamente na inicialização.
7. Confira se a lateral do aplicativo apresenta `LUCA V1.7.0`.

Mantenha a instalação anterior e o backup até conferir seus saldos, histórico e faturas. O ZIP distribuído não contém seu banco de dados ou seu `.env`.

## O que mudou

### Histórico paginado e filtros

- O histórico carrega 25, 50 ou 100 lançamentos por página.
- Inclui filtro por categoria além de tipo, conta, texto e período.
- A API permite abrir um lançamento específico e carregar seu grupo de parcelas, mesmo que o registro seja antigo.
- Ao excluir o último registro de uma página, o servidor ajusta a página para a última página ainda existente.

### Dividir um lançamento entre categorias

Use o botão de divisão na linha de uma movimentação simples. Cada parte exige descrição, categoria e valor. A soma das partes precisa ser exatamente igual ao valor original; o Luca mostra a diferença antes de habilitar o salvamento.

A divisão não cria novas movimentações e não muda o saldo da conta. Ela altera a classificação usada em relatórios e limites por categoria. O histórico continua mostrando uma única movimentação com um indicador de quantas categorias a compõem. Parcelas de uma compra parcelada e saldos iniciais de fatura não podem ser divididos.

Para desfazer, abra a mesma divisão e escolha **Remover divisão**. Os relatórios voltam a usar a categoria original do lançamento.

### Pausar e reativar recorrências

A lista mostra recorrências ativas e pausadas. Pausar impede futuras gerações, mas preserva a regra e os lançamentos históricos. Reativar volta a incluir a regra no agendamento. A pausa não desfaz ocorrências que já foram geradas anteriormente.

### Fechamento mensal

Em Relatórios, selecione o mês e marque as conferências realizadas: lançamentos, faturas, recorrências, limites e transferências. As marcações são salvas automaticamente; observações podem ser salvas no botão próprio. O checklist é um registro de conferência, não bloqueia nem altera lançamentos.

### Formulário mais enxuto

Parcelamento, saldo inicial de fatura e observações ficam dentro de **Parcelamento, saldo inicial e observações**. O grupo abre automaticamente quando o lançamento usa parcelas ou é editado como saldo inicial.

### Proteção na importação de CSV

O Luca calcula uma assinatura SHA-256 do conteúdo do arquivo e registra a importação por conta. Reenviar exatamente o mesmo arquivo para a mesma conta não cria os lançamentos outra vez. O bloqueio é por arquivo idêntico; um CSV reexportado ou modificado ainda deve ser conferido antes de importar.

## Cuidados importantes

- Ao dividir um lançamento, verifique se todas as partes somam o total original. A validação é feita em centavos.
- Duplicar um lançamento que já está dividido cria uma cópia simples, sem copiar automaticamente a divisão. Isso é informado no formulário para que você revise a classificação.
- Pausar uma recorrência não exclui lançamentos já gerados.
- O fechamento mensal não substitui a conciliação com o extrato/fatura oficial do banco.

## Estruturas adicionadas

- `transaction_splits`: partes de um lançamento para classificação por categoria.
- `monthly_reviews`: checklist e observações por mês e perfil.
- `csv_import_batches`: histórico das importações para evitar reprocessar o mesmo arquivo na mesma conta.

As novas estruturas são criadas por `init_db()` e não exigem intervenção manual no SQLite.
