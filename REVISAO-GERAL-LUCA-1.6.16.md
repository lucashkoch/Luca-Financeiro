# Revisão geral do Luca — v1.6.16

## Resumo executivo

O Luca já tem uma base funcional sólida para finanças pessoais: FastAPI, SQLite, painel HTML/CSS/JavaScript sem framework, banco individual por perfil, migrações aditivas e testes automatizados. O foco recomendado agora é reduzir a fricção de uso e consolidar regras financeiras, não adicionar muitos módulos novos.

## O que vale manter

- **Lançamentos, contas, transferências e pagamentos de fatura:** formam o núcleo financeiro e precisam continuar separados para não duplicar despesas.
- **Parcelamentos e recorrências:** são funcionalidades diferentes e devem continuar com cadastros e previsões separados.
- **Faturas por ciclo e conciliação CSV:** são especialmente úteis para validar cartões. A conciliação deve continuar sendo somente leitura até o usuário confirmar alterações.
- **Limites, metas e contas de reserva/investimento:** podem continuar, mas não precisam disputar espaço com os fluxos diários.
- **Devendo / A receber:** manter como módulo independente, pois representa compromissos entre pessoas e não deve alterar automaticamente o saldo bancário sem liquidação.
- **Backup, exportação e importação:** manter visíveis e documentados; são recursos de proteção dos dados.

## O que simplificar na interface

1. **Agrupar a navegação:** manter Visão geral, Lançamentos e Contas como acessos principais. Agrupar Limites, Metas e Economias/Investimentos em Planejamento. Colocar Categorias e integrações menos usadas em Configurações/Avançado. Não apagar as telas nem os dados.
2. **Formulário de lançamento progressivo:** mostrar primeiro tipo, valor, descrição, categoria, conta, pagamento e data. Deixar parcelamento, saldo inicial e observações em uma seção “Mais opções”. Isso reduz a quantidade de campos visíveis sem retirar recursos.
3. **Ações por linha:** manter Editar, Duplicar e Excluir, mas usar ícones discretos com rótulos acessíveis e confirmação clara para exclusão de grupos parcelados.
4. **Cartões:** a visão principal deve priorizar Fatura atual, Próximas faturas e Total comprometido. Os totais precisam abrir o detalhamento que os compõe; não reapresentar dívida inicial em mais de um indicador.
5. **Integrações opcionais:** Telegram, Ollama e transcrição de áudio devem ficar em uma área avançada e ter configuração de ativação clara. Não devem ocupar espaço no fluxo básico de registrar e conferir despesas.

## Melhorias de produto recomendadas, por prioridade

### Prioridade alta

- **Duplicar lançamento (implementado na v1.6.16):** abre um formulário preenchido, usa hoje como data inicial, preserva os dados essenciais e só grava após salvar. Parcelas são copiadas como uma única movimentação, nunca como grupo completo. Saldo inicial de fatura não pode ser duplicado.
- **Paginação no histórico:** a API aceita no máximo 1.000 linhas por consulta. A tela deve caminhar para paginação real, para que o histórico não pare de mostrar itens em bases maiores.
- **Conciliação de lançamentos agrupados:** oferecer uma forma de conciliar um grupo de compras do banco contra um lançamento consolidado no Luca (por exemplo, três despesas do mesmo date agrupadas em uma linha), sem forçar correspondência individual falsa.
- **Testes de navegador:** os testes atuais cobrem regras de API/finanças e verificações estáticas da interface. Adicionar um pequeno conjunto de testes de ponta a ponta para cadastro, edição, duplicação, recorrências e faturas.

### Prioridade média

- **Pausar recorrência:** permitir pausar e reativar uma assinatura sem excluí-la e recadastrar tudo.
- **Prévia de recorrências:** mostrar quais ocorrências entrarão nas próximas faturas antes de serem materializadas como lançamentos.
- **Fechamento mensal assistido:** checklist de contas conciliadas, faturas conferidas e pendências, sem bloquear alterações nem alterar lançamentos automaticamente.
- **Importação CSV orientada:** mapear colunas do banco, mostrar prévia e detectar duplicatas antes de importar. A ferramenta de conciliação de fatura deve continuar separada da importação geral.

### Prioridade baixa

- Anexar comprovantes a lançamentos, somente se houver necessidade real de guardar recibos.
- Tags personalizadas e busca avançada, se as categorias atuais deixarem de ser suficientes.

## O que eu não adicionaria agora

- Sincronização bancária automática de terceiros sem uma integração confiável e autorizada.
- Cotações de ações, criptoativos ou recomendações de investimento: não são essenciais para o objetivo principal do Luca e aumentam manutenção e dependência externa.
- Gamificação, pontos, níveis ou excesso de notificações.
- Um novo módulo separado para cada tipo de movimentação. É melhor aperfeiçoar os fluxos existentes.

## Pontos técnicos para acompanhar

- `app/main.py`, `app/static/app.js` e `app/telegram_bot.py` concentram bastante lógica. A divisão em serviços/routers deve ser incremental, acompanhada por testes, em vez de uma refatoração grande de uma vez.
- A configuração `LUCA_ACCESS_PASSWORD` foi retirada do `.env.example`: não havia implementação que a utilizasse. O login por perfil segue sendo a proteção normal do painel.
- O acesso remoto deve continuar sendo tratado como implantação separada: HTTPS, cookies Secure, backups persistentes, firewall e controle de acesso. A configuração local em `127.0.0.1` não deve ser exposta diretamente à internet.
- O conjunto de recursos Telegram/áudio é opcional e mais complexo que o núcleo financeiro. Vale revisar a ativação e a instalação das dependências de áudio para que não interfiram na experiência de quem só usa o painel.

## Decisão desta versão

A v1.6.16 implementa a duplicação segura e remove uma configuração de exemplo sem efeito. A revisão não remove telas financeiras ou dados existentes. As demais sugestões ficam como um roteiro priorizado para evitar adicionar complexidade sem necessidade.
