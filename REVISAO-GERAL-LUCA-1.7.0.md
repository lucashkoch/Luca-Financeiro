# Revisão geral do Luca — versão 1.7.0

## Direção do produto

O Luca deve priorizar quatro perguntas que alguém precisa responder rapidamente ao abrir um controle financeiro:

1. Quanto dinheiro realmente tenho disponível?
2. O que já gastei e em que categorias?
3. Quais contas e faturas ainda preciso pagar?
4. O que já está previsto para os próximos meses?

A evolução 1.7.0 prioriza confiabilidade, conferência e velocidade de uso antes de adicionar integrações ou indicadores sofisticados.

## Melhorias entregues

### 1. Histórico mais utilizável

- Paginação no servidor, com 25, 50 ou 100 itens por página.
- Filtro por categoria, além de busca, conta, tipo e período.
- Detalhamento de um lançamento específico e de seu grupo de parcelas sem depender das 1.000 movimentações mais recentes.
- Ações de editar, duplicar, dividir e excluir continuam ligadas ao registro correto.

### 2. Divisão de lançamentos por categoria

Uma única compra pode ser repartida em partes para relatórios e limites por categoria. A soma precisa fechar exatamente com o valor original em centavos. A divisão não gera transações bancárias adicionais nem altera o saldo da conta. É adequada para despesas compartilhadas ou compras consolidadas — por exemplo, manter um único lançamento de date e separar alimentação e lazer internamente.

Parcelamentos e saldos iniciais de fatura não podem ser divididos, para preservar o cronograma e o tratamento especial da dívida consolidada.

### 3. Recorrências com controle

- Uma regra pode ser pausada e reativada sem perder a configuração ou o histórico.
- A lista abre mostrando regras ativas, com filtros para pausadas e todas.
- Ao reativar uma recorrência vencida, o Luca avisa antes de recuperar ocorrências atrasadas.
- A pausa impede novas gerações, mas não apaga lançamentos já criados.

### 4. Fechamento mensal

Checklist por período para conferir movimentações, faturas, recorrências, limites e transferências, com observações salvas no perfil. O checklist é um lembrete operacional: não movimenta dinheiro, não bloqueia registros e não substitui a conciliação bancária.

### 5. Importação mais segura

O mesmo arquivo CSV, com conteúdo byte a byte idêntico, não pode ser importado novamente para a mesma conta. Arquivos reexportados ou modificados podem ter conteúdo parcialmente repetido; nesses casos, a revisão humana ainda é necessária.

### 6. Formulário mais leve

Campos avançados de parcelamento, saldo inicial e observações ficam recolhidos até serem necessários. Isso reduz o ruído para lançamentos comuns sem remover os recursos avançados.

## Referências de desenho de produto

Foram considerados padrões comuns em ferramentas de finanças pessoais, sem tentar reproduzir integralmente nenhum produto:

- Divisão de uma movimentação entre categorias para preservar um único registro e produzir relatórios mais precisos.
- Regras agendadas/recorrentes com geração automática ou revisão, incluindo recuperação controlada de vencimentos.
- Revisão de importações e detecção de duplicidade antes de afetar os registros financeiros.
- Orçamento por categorias e acompanhamento de compromissos, em vez de depender somente de um saldo agregado.

Essas referências inspiram decisões de experiência, não são integrações nem certificações de compatibilidade.

## O que foi deliberadamente deixado de fora

- **Sincronização bancária automática:** depende de um provedor, permissões e tratamento específico de dados financeiros; não deve ser simulada por scraping ou acesso a credenciais.
- **Cotações e carteira de investimentos em tempo real:** não ajudam a resolver o núcleo de fluxo de caixa e controle de faturas e exigem fontes de mercado e atualização contínua.
- **Gamificação, pontos e sequências:** podem distrair do objetivo financeiro e transformar um controle simples em uma experiência carregada.
- **Projeções automáticas com inteligência artificial:** não devem criar compromissos ou alterar saldos sem origem e confirmação claras.
- **Remoção de módulos existentes:** não foi feita; primeiro é necessário observar o uso real e garantir que os dados e fluxos tenham substitutos.

## Próximas prioridades sugeridas

1. **Conciliação por período e por cartão:** distinguir correspondências exatas, compras agrupadas, estornos e diferenças de data sem fazer alterações automáticas.
2. **Exportação e restauração testada de backup:** oferecer uma cópia legível, com verificação de integridade e instruções de restauração.
3. **Metas e limites com ritmo mensal:** mostrar valor planejado, realizado e restante, sem misturar despesas futuras com realizadas.
4. **Busca e edição em lote com prévia:** útil para corrigir categorias ou contas de vários registros, sempre com possibilidade de desfazer.
5. **Testes visuais com navegador em ambiente Windows:** os testes automatizados cobrem regras e presença de componentes, mas uma rodada visual real no computador de destino continua recomendada antes de mudanças grandes de navegação.

## Verificação da versão 1.7.0

- 196 testes automatizados aprovados.
- Verificação sintática de JavaScript (`node --check`).
- Compilação sintática de módulos Python (`py_compile`).
- Migrações aditivas: as novas tabelas auxiliares são criadas na inicialização e não exigem apagar ou substituir os registros financeiros existentes.
- O pacote de distribuição não deve conter `data/`, bancos SQLite, `.env`, credenciais, ambiente virtual, caches ou logs.

## Princípio de segurança financeira

Relatórios, previsões e conciliações precisam explicar de onde vem cada valor. Nenhuma melhoria visual deve transformar uma previsão em lançamento real, contar um pagamento de fatura como despesa de consumo, duplicar uma recorrência ou alterar o saldo sem uma ação clara do usuário.
