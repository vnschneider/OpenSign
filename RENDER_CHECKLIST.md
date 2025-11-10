# ✅ Checklist Completo - Deploy no Render

Use este checklist para garantir que tudo está configurado corretamente.

---

## 📦 Fase 1: Preparação (Antes do Render)

### MongoDB Atlas (Obrigatório)

- [ ] Criei conta no [MongoDB Atlas](https://www.mongodb.com/cloud/atlas)
- [ ] Criei cluster gratuito (M0)
- [ ] Configurei usuário e senha
- [ ] Adicionei `0.0.0.0/0` no Network Access
- [ ] Copiei a connection string
- [ ] Substitui `<password>` pela senha real
- [ ] Salvei a connection string em local seguro

**Minha connection string:**
```
mongodb+srv://usuario:senha@cluster.xxxxx.mongodb.net/opensign
```

### Email SMTP

- [ ] Acessei [myaccount.google.com](https://myaccount.google.com)
- [ ] Ativei verificação em 2 etapas
- [ ] Gerei senha de app para "Email"
- [ ] Copiei senha de 16 caracteres
- [ ] Salvei senha em local seguro

**Meu email:** ___________________

**Senha de app:** ___________________

### Gerar MASTER_KEY

- [ ] Executei `.\render-setup.ps1`
- [ ] Copiei a MASTER_KEY gerada
- [ ] Salvei em local seguro

**Minha MASTER_KEY:** ___________________

---

## 🎨 Fase 2: Configuração no Render

### Criar Conta

- [ ] Acessei [render.com](https://render.com)
- [ ] Criei conta (usei login do GitHub)
- [ ] Conectei meu repositório GitHub
- [ ] Confirmei acesso ao repositório OpenSign

### Deploy Método 1: Blueprint (Recomendado)

- [ ] Commitei arquivo `render.yaml` no repositório
- [ ] No Render: New + → Blueprint
- [ ] Selecionei repositório vnschneider/OpenSign
- [ ] Branch: staging
- [ ] Cliquei em "Apply"
- [ ] Aguardei criação dos serviços

**OU**

### Deploy Método 2: Manual

#### Serviço 1: Backend (opensign-server)

- [ ] New + → Web Service
- [ ] Repositório: vnschneider/OpenSign
- [ ] Name: `opensign-server`
- [ ] Region: Oregon
- [ ] Branch: staging
- [ ] Root Directory: `apps/OpenSignServer`
- [ ] Runtime: Node
- [ ] Build Command: `npm ci`
- [ ] Start Command: `npm start`
- [ ] Plan: Free (ou Starter)

#### Serviço 2: Frontend (opensign-frontend)

- [ ] New + → Web Service
- [ ] Repositório: vnschneider/OpenSign
- [ ] Name: `opensign-frontend`
- [ ] Region: Oregon
- [ ] Branch: staging
- [ ] Root Directory: `apps/OpenSign`
- [ ] Runtime: Node
- [ ] Build Command: `npm ci && npm run build`
- [ ] Start Command: `npm start`
- [ ] Plan: Free (ou Starter)

---

## ⚙️ Fase 3: Configurar Variáveis de Ambiente

### Backend (opensign-server)

Acesse o serviço → Environment → Add Environment Variable

**Variáveis Obrigatórias:**

- [ ] `NODE_ENV=production`
- [ ] `APP_ID=opensign`
- [ ] `appName=OpenSign`
- [ ] `MASTER_KEY=<minha-key-gerada>`
- [ ] `MONGODB_URI=<minha-connection-string>`
- [ ] `PARSE_MOUNT=/app`
- [ ] `USE_LOCAL=true`
- [ ] `SMTP_ENABLE=true`
- [ ] `SMTP_HOST=smtp.gmail.com`
- [ ] `SMTP_PORT=587`
- [ ] `SMTP_USER_EMAIL=<meu-email>`
- [ ] `SMTP_PASS=<minha-senha-de-app>`
- [ ] `PORT=8080`

**URLs (adicionar depois):**

- [ ] `SERVER_URL=https://<meu-backend>.onrender.com/app`

### Frontend (opensign-frontend)

Acesse o serviço → Environment → Add Environment Variable

**Variáveis Obrigatórias:**

- [ ] `NODE_ENV=production`
- [ ] `REACT_APP_APPID=opensign`
- [ ] `GENERATE_SOURCEMAP=false`
- [ ] `PORT=3000`

**URLs (adicionar depois):**

- [ ] `PUBLIC_URL=https://<meu-frontend>.onrender.com`
- [ ] `REACT_APP_SERVERURL=https://<meu-backend>.onrender.com/api/app`

---

## 🔗 Fase 4: Obter URLs e Atualizar

### Copiar URLs dos Serviços

Após primeiro deploy, copie as URLs:

**Backend URL:** ___________________
Exemplo: `https://opensign-server-abc123.onrender.com`

**Frontend URL:** ___________________
Exemplo: `https://opensign-frontend-xyz789.onrender.com`

### Atualizar Variáveis

- [ ] Backend → `SERVER_URL=https://<backend-url>/app`
- [ ] Frontend → `PUBLIC_URL=https://<frontend-url>`
- [ ] Frontend → `REACT_APP_SERVERURL=https://<backend-url>/api/app`
- [ ] Salvei alterações
- [ ] Aguardei redeploy automático (~5-10 min)

---

## 🧪 Fase 5: Testar Aplicação

### Acesso Inicial

- [ ] Acessei a URL do frontend
- [ ] Página carregou corretamente (sem erros)
- [ ] Formulário de cadastro/login apareceu

### Criar Conta

- [ ] Criei conta de teste
- [ ] Recebi email de verificação
- [ ] Confirmei email
- [ ] Fiz login com sucesso

### Testar Funcionalidades

- [ ] Dashboard carregou
- [ ] Fiz upload de documento PDF
- [ ] Adicionei signatário
- [ ] Coloquei campos de assinatura
- [ ] Enviei para assinar
- [ ] Recebi email de notificação
- [ ] Abri link de assinatura
- [ ] Assinei documento
- [ ] Download do documento funcionou

---

## 🔐 Fase 6: Segurança e Produção

### Checklist de Segurança

- [ ] `MASTER_KEY` é única e aleatória (não é exemplo)
- [ ] Não commitei arquivos `.env` com secrets
- [ ] Usei senha de app do Gmail (não senha normal)
- [ ] Connection string do MongoDB não está no código
- [ ] Variáveis sensíveis estão apenas no Render

### Para Produção (Recomendado)

- [ ] Configurei armazenamento S3/DO Spaces
  - [ ] `USE_LOCAL=false`
  - [ ] Configurei variáveis DO_*
- [ ] Upgrade para plano pago ($7/mês cada serviço)
- [ ] Configurei domínio personalizado
- [ ] Configurei backups do MongoDB Atlas
- [ ] Testei fluxo completo em produção

---

## 📊 Informações do Deploy

**Data do Deploy:** ___________________

**URLs:**
- Frontend: ___________________
- Backend: ___________________

**Plano Usado:**
- [ ] Free Tier (hibernação após 15 min)
- [ ] Starter ($7/mês por serviço)

**Armazenamento:**
- [ ] Local (temporário)
- [ ] S3/DO Spaces (produção)

**Custos Mensais Estimados:**
- Free Tier: $0/mês
- Starter (2 serviços): $14/mês
- MongoDB Atlas M0: $0/mês
- S3/DO Spaces: ~$5/mês (se usar)

**Total: $_____/mês**

---

## 🐛 Troubleshooting

### Se algo deu errado:

- [ ] Revisei logs no Render (Logs tab)
- [ ] Verifiquei se todas as variáveis estão corretas
- [ ] Testei connection string do MongoDB
- [ ] Confirmei que senha de app do Gmail está correta
- [ ] Verifiquei se URLs estão atualizadas
- [ ] Li o arquivo RENDER_DEPLOYMENT.md

---

## ✅ Deploy Completo!

Se todos os itens acima estão marcados, parabéns! 🎉

Seu OpenSign está rodando no Render com sucesso!

**Próximos passos:**
1. Configure sua organização
2. Personalize templates de email
3. Convide usuários
4. Comece a assinar documentos!

---

## 📝 Notas Adicionais

_______________________________________________________________

_______________________________________________________________

_______________________________________________________________

_______________________________________________________________
