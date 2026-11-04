# Changelog

## 1.4.3 — correções de recorrências e preferências

- Corrigido o erro `Cannot read properties of null (reading 'closest')` ao salvar recorrências: o formulário agora é capturado antes das operações assíncronas.
- Corrigido o salvamento da forma de pagamento em recorrências, incluindo seu identificador; a geração das parcelas recorrentes preserva o meio selecionado.
- Adicionado cadastro de categorias por perfil, com arquivamento e reativação sem apagar o histórico de lançamentos.
- Categorias cadastradas ficam disponíveis em lançamentos, recorrências e limites mensais.
- Adicionada preferência de forma de pagamento padrão, ao lado da conta padrão.
- Novos lançamentos e novas recorrências já abrem com banco e forma de pagamento padrão selecionados.
- Corrigidas outras rotinas assíncronas de formulários que poderiam usar `event.currentTarget` depois do envio.
- Preferência de pagamento padrão aplicada também às interpretações sem forma de pagamento explícita no assistente web e no Telegram.
- 84 testes automatizados aprovados.

## 1.4.2 — 2026-11-04

### Interpretação de lançamentos
- Ampliação das formas naturais de expressar despesas, receitas, depósitos e transferências.
- Reconhecimento de valores falados por extenso, valores compactos (`2k`, `2,5k`), contos/pilas e centavos falados.
- Suporte adicional a datas relativas e escritas por extenso, além de variações de parcelamento (`5x`, `5 vezes`, `cinco parcelas`).
- Limpeza de descrições com remoção de datas, horários, palavras de pagamento e referências de conta.
- Nova categoria **Esportes** e regras contextuais para compras de tênis, atividades esportivas, Vendas e reembolsos.
- Transferências como “mandei/enviei da conta A para conta B” só são inferidas quando as duas contas estão reconhecidas.
- Corrigida colisão entre valores como `R$ 99` e o aplicativo 99; o número não classifica por si só como Transporte.

### Áudio e transcrição
- Modelo padrão alterado para `medium`, com contexto de português brasileiro e vocabulário financeiro.
- Cache do modelo Whisper carregado para evitar recarregar a rede neural a cada áudio.
- Instalador usa o interpretador exato da `.venv` usada pelo serviço e valida `faster-whisper` e `ctranslate2`.
- Novo diagnóstico autenticado em `/assistant/audio/status`, com caminho do Python, versões e erro de importação.
- Telegram diferencia biblioteca ausente de falha de DLL, dependência interna, download do modelo ou decodificação do áudio.

### Compatibilidade
- Sem alteração de schema e sem migração de banco.
- 75 testes automatizados aprovados nesta release.

## 1.4.1 — 2026-11-04

### Aparência e personalização
- Configurações por perfil para fonte (Inter, Manrope, Space Grotesk ou fonte do sistema).
- Escala geral da interface de 90%, 100%, 110% ou 120%.
- Densidade confortável ou compacta, persistida no banco privado de cada usuário.
- Prévia da tipografia antes de salvar as preferências.

### Visão geral
- Dois indicadores dedicados no dashboard: **A receber de pessoas** e **A pagar a pessoas**.
- Valores calculados a partir dos compromissos pendentes, já descontando quitações parciais.
- Compromissos entre pessoas não são somados ao saldo bancário nem ao patrimônio líquido.

### Economias e investimentos
- Nova área baseada nas contas existentes dos tipos Poupança e Investimento.
- Totalizadores separados de economias, investimentos e total combinado.
- Ações de aplicar/guardar e resgatar/retirar por transferência entre contas.
- Exibição das metas existentes para acompanhar objetivos.
- Nenhuma tabela financeira duplicada: saldos vêm do razão das contas.

### Compatibilidade e testes
- Nenhuma migração destrutiva ou alteração necessária nas tabelas de movimentações.
- 63 testes automatizados aprovados na suíte desta release.
