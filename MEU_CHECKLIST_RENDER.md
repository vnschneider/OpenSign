# ✅ Seu Checklist Personalizado - Deploy no Render

## 🎯 CONFIGURAÇÃO PERSONALIZADA

**Email SMTP:** ✅ Já configurado (Umbler - EFO Conecta)
- Host: `smtp.umbler.com`
- Email: `naoresponda@efoconecta.online`
- Porta: `587`

---

## 📦 O QUE VOCÊ PRECISA FAZER:

### ✅ 1. MongoDB Atlas (15 minutos)

**OBRIGATÓRIO** - Render não tem MongoDB nativo.

1. **Acesse:** https://www.mongodb.com/cloud/atlas
2. **Crie conta** (pode usar Google/GitHub)
3. **Create Deployment:**
   - [ ] Cluster Tier: **M0 (FREE)**
   - [ ] Provider: **AWS**
   - [ ] Region: **us-east-1** (ou São Paulo se disponível)
   - [ ] Name: **opensign-db**
4. **Create Database User:**
   - [ ] Username: `opensign_user`
   - [ ] Password: [gere senha forte]
   - [ ] Clique em "Add User"
5. **Network Access:**
   - [ ] Add IP Address
   - [ ] Allow Access from Anywhere
   - [ ] IP: `0.0.0.0/0`
   - [ ] Clique em "Confirm"
6. **Get Connection String:**
   - [ ] Databases → Connect → Drivers
   - [ ] Driver: Node.js
   - [ ] Copie a string
   - [ ] Substitua `<password>` pela senha real
   - [ ] Adicione `/opensign` no final

**Sua connection string final:**
```
mongodb+srv://opensign_user:SUA_SENHA_AQUI@cluster0.xxxxx.mongodb.net/opensign?retryWrites=true&w=majority
```

**⚠️ IMPORTANTE:** Salve esta string em local seguro! Você vai precisar dela.

---

### ✅ 2. Gerar MASTER_KEY (1 minuto)

Execute o script:

```powershell
.\render-setup.ps1
```

- [ ] Copiei a MASTER_KEY gerada
- [ ] Salvei em local seguro

**Minha MASTER_KEY:** ___________________________________

---

### ✅ 3. Commit e Push (2 minutos)

```powershell
git add .
git commit -m "feat: configure Render deployment with Umbler SMTP"
git push origin staging
```

- [ ] Fiz commit dos arquivos
- [ ] Fiz push para GitHub

---

### ✅ 4. Deploy no Render (10 minutos)

#### Opção A: Blueprint (Automático - RECOMENDADO)

1. **Acesse:** https://dashboard.render.com
2. **Crie conta** (use login do GitHub)
3. **New + → Blueprint**
4. **Connect GitHub:**
   - [ ] Autorize acesso ao GitHub
   - [ ] Selecione repositório: `vnschneider/OpenSign`
5. **Configure:**
   - [ ] Branch: `staging`
   - [ ] Render detectará `render.yaml`
6. **Apply:**
   - [ ] Clique em "Apply"
   - [ ] Render criará 2 serviços automaticamente

**Serviços criados:**
- [ ] opensign-server (backend)
- [ ] opensign-frontend (frontend)

---

### ✅ 5. Configurar MongoDB no Render (3 minutos)

**⚠️ IMPORTANTE:** O Render vai tentar criar PostgreSQL por padrão. Você precisa:

1. **Remover serviço MongoDB do Blueprint:**
   - [ ] Na tela de criação, **desmarque** o serviço "opensign-mongodb"
   - [ ] Ou delete depois se já foi criado

2. **Configurar MongoDB Atlas no Backend:**
   - [ ] Acesse serviço `opensign-server`
   - [ ] Environment → Find Variable `MONGODB_URI`
   - [ ] Substitua pelo valor do MongoDB Atlas
   - [ ] Cole sua connection string completa
   - [ ] Save Changes

---

### ✅ 6. Atualizar MASTER_KEY (1 minuto)

No serviço **opensign-server**:

- [ ] Environment → Find Variable `MASTER_KEY`
- [ ] Substitua pela que você gerou
- [ ] Save Changes

---

### ✅ 7. Aguardar Build (10-15 minutos)

- [ ] Backend: Deployments → Ver logs
- [ ] Frontend: Deployments → Ver logs
- [ ] Aguardar status "Live" em ambos

**Status:**
- [ ] Backend: Live ✅
- [ ] Frontend: Live ✅

---

### ✅ 8. Copiar URLs dos Serviços (1 minuto)

Após deploy bem-sucedido:

**Backend URL:** _______________________________________________
(Exemplo: `https://opensign-server-abc123.onrender.com`)

**Frontend URL:** _______________________________________________
(Exemplo: `https://opensign-frontend-xyz789.onrender.com`)

---

### ✅ 9. Atualizar URLs nos Serviços (3 minutos)

#### No serviço **opensign-server**:

- [ ] Environment → Edit `SERVER_URL`
- [ ] Novo valor: `https://[SUA-URL-BACKEND]/app`
- [ ] Save Changes

#### No serviço **opensign-frontend**:

- [ ] Environment → Edit `PUBLIC_URL`
- [ ] Novo valor: `https://[SUA-URL-FRONTEND]`
- [ ] Environment → Edit `REACT_APP_SERVERURL`
- [ ] Novo valor: `https://[SUA-URL-BACKEND]/api/app`
- [ ] Save Changes

**Aguardar redeploy automático (~5 min)**

- [ ] Backend redesployou ✅
- [ ] Frontend redesployou ✅

---

### ✅ 10. Testar Aplicação (5 minutos)

1. **Acesso inicial:**
   - [ ] Acessei URL do frontend
   - [ ] Página carregou sem erros
   - [ ] Formulário de cadastro apareceu

2. **Criar conta:**
   - [ ] Criei conta de teste
   - [ ] Recebi email de verificação (verifique spam)
   - [ ] Confirmei email
   - [ ] Fiz login

3. **Testar funcionalidades:**
   - [ ] Dashboard carregou
   - [ ] Upload de PDF funcionou
   - [ ] Adicionei campos de assinatura
   - [ ] Enviei documento para assinar
   - [ ] Recebi email de notificação

---

## 🎉 Deploy Completo!

Se todos os itens acima estão marcados, seu OpenSign está rodando! 🚀

### 📊 Informações do Deploy

**Data:** _____/_____/_____

**URLs:**
- Frontend: _______________________________________________
- Backend: _______________________________________________

**Plano:**
- [ ] Free Tier (hibernação após 15 min)
- [ ] Starter ($7/mês × 2 serviços = $14/mês)

**Custos Mensais:**
- Render: $____/mês
- MongoDB Atlas M0: $0/mês
- **Total: $____/mês**

---

## 🐛 Problemas Comuns

### ❌ "Service Unavailable"
- [ ] Verifiquei logs do serviço
- [ ] Confirme se `MONGODB_URI` está correto
- [ ] Teste connection string do MongoDB manualmente

### ❌ "Build Failed"
- [ ] Verifiquei logs de build
- [ ] Root Directory está correto?
- [ ] Build Command está correto?

### ❌ "Emails não chegam"
- [ ] Verifiquei SMTP_* estão corretos
- [ ] Verifiquei spam
- [ ] Testei enviar email manualmente via Umbler

### ❌ "Frontend não carrega"
- [ ] Verifiquei se URLs estão corretas
- [ ] Confirme se backend está "Live"
- [ ] Verifiquei CORS no backend

---

## 📝 Credenciais (Guarde em Local Seguro!)

**MongoDB Atlas:**
- Username: opensign_user
- Password: _____________________
- Connection String: _____________________

**Render:**
- MASTER_KEY: _____________________

**SMTP (Umbler):**
- Host: smtp.umbler.com
- Email: naoresponda@efoconecta.online
- Senha: 478E-rb(iT7Lu ✅

---

## 🎯 Próximos Passos

Após deploy bem-sucedido:

1. [ ] Configure sua organização no app
2. [ ] Personalize templates de email
3. [ ] Convide usuários
4. [ ] (Opcional) Configure domínio personalizado
5. [ ] (Produção) Configure S3/DO Spaces para storage

---

## 🆘 Precisa de Ajuda?

- 📖 Guia completo: `RENDER_DEPLOYMENT.md`
- ⚡ Início rápido: `RENDER_QUICKSTART.md`
- 🔧 Execute: `.\render-setup.ps1`

---

**Boa sorte! 🎨**
