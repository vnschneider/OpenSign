# 🎨 Guia Completo de Deploy do OpenSign no Render

Este guia mostra como fazer deploy do OpenSign no Render, uma excelente alternativa ao Railway.

---

## 📊 Por que Render?

- ✅ **Free tier generoso**: 750 horas/mês grátis
- ✅ **MongoDB incluído**: 512MB grátis
- ✅ **SSL automático** em todos os planos
- ✅ **Fácil de usar** e bem documentado
- ✅ **$7/mês** para tier pago (vs $22/mês Heroku)
- ⚠️ **Hibernação**: Free tier dorme após 15 min (primeiro acesso demora ~30s)

---

## 📋 Pré-requisitos

1. ✅ Conta no [Render](https://render.com) (pode usar GitHub)
2. ✅ Fork do OpenSign no GitHub
3. ✅ Email SMTP configurado (Gmail, Outlook, etc)
4. ✅ (Opcional) Bucket S3/DO Spaces para arquivos

---

## 🎯 Opções de Deploy

### **Opção 1: Blueprint (Automático) - RECOMENDADO**

Use o arquivo `render.yaml` para deploy com 1 clique!

### **Opção 2: Manual (Controle Total)**

Configure cada serviço manualmente.

---

## 🚀 Opção 1: Deploy com Blueprint (Mais Fácil)

### **Passo 1: Preparar o Repositório**

1. Certifique-se que o arquivo `render.yaml` está no seu repositório
2. Commit e push para o GitHub:
   ```bash
   git add render.yaml
   git commit -m "feat: add Render blueprint configuration"
   git push origin staging
   ```

### **Passo 2: Criar Projeto no Render**

1. Acesse [dashboard.render.com](https://dashboard.render.com)
2. Clique em **"New +"** → **"Blueprint"**
3. Conecte seu repositório GitHub
4. Selecione seu fork do OpenSign
5. Branch: `staging`
6. Render detectará o `render.yaml` automaticamente
7. Clique em **"Apply"**

### **Passo 3: Configurar Variáveis Sensíveis**

O Render criará os serviços, mas você precisa configurar:

#### **No serviço `opensign-server`:**

1. Vá em **Environment**
2. Configure:
   ```bash
   MASTER_KEY=<gere-chave-aleatoria-12-chars>
   SMTP_HOST=smtp.gmail.com
   SMTP_USER_EMAIL=seu-email@gmail.com
   SMTP_PASS=sua-senha-de-app
   ```

#### **Atualizar URLs:**

Após deploy, você terá URLs tipo:
- Server: `https://opensign-server.onrender.com`
- Frontend: `https://opensign-frontend.onrender.com`

Atualize as variáveis:

**No `opensign-server`:**
```bash
SERVER_URL=https://opensign-server.onrender.com/app
```

**No `opensign-frontend`:**
```bash
PUBLIC_URL=https://opensign-frontend.onrender.com
REACT_APP_SERVERURL=https://opensign-server.onrender.com/api/app
```

### **Passo 4: Aguardar Deploy**

- Render fará build de ambos os serviços (~10-15 minutos)
- Acompanhe em **Events** e **Logs**
- Quando aparecer "Live", está pronto! 🎉

---

## 🔧 Opção 2: Deploy Manual

### **Passo 1: Criar MongoDB**

1. No Render Dashboard, clique em **"New +"** → **"PostgreSQL"**
   - ⚠️ Render não tem MongoDB nativo - use **MongoDB Atlas**!

#### **Configurar MongoDB Atlas (Grátis):**

1. Acesse [mongodb.com/cloud/atlas](https://www.mongodb.com/cloud/atlas)
2. Crie conta gratuita
3. **Create Cluster** → **Shared (M0)** → **Create**
4. **Database Access**: Crie usuário/senha
5. **Network Access**: Adicione `0.0.0.0/0` (permite qualquer IP)
6. **Connect** → **Connect your application** → Copie a connection string
7. Substitua `<password>` pela senha do usuário

Sua string será tipo:
```
mongodb+srv://usuario:senha@cluster0.xxxxx.mongodb.net/opensign?retryWrites=true&w=majority
```

### **Passo 2: Criar Serviço do Backend**

1. **"New +"** → **"Web Service"**
2. Conecte seu repositório GitHub
3. Configure:

| Campo | Valor |
|---|---|
| **Name** | `opensign-server` |
| **Region** | Oregon (US West) |
| **Branch** | `staging` |
| **Root Directory** | `apps/OpenSignServer` |
| **Runtime** | Node |
| **Build Command** | `npm ci` |
| **Start Command** | `npm start` |
| **Plan** | Free |

4. **Environment Variables** (adicione todas):

```bash
NODE_ENV=production
APP_ID=opensign
appName=OpenSign
MASTER_KEY=<sua-chave-aleatoria>
MONGODB_URI=<sua-connection-string-do-atlas>
PARSE_MOUNT=/app
SERVER_URL=https://opensign-server.onrender.com/app
USE_LOCAL=true
SMTP_ENABLE=true
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USER_EMAIL=seu-email@gmail.com
SMTP_PASS=sua-senha-de-app
PORT=8080
```

5. Clique em **"Create Web Service"**

### **Passo 3: Criar Serviço do Frontend**

1. **"New +"** → **"Web Service"**
2. Mesmo repositório
3. Configure:

| Campo | Valor |
|---|---|
| **Name** | `opensign-frontend` |
| **Region** | Oregon (US West) |
| **Branch** | `staging` |
| **Root Directory** | `apps/OpenSign` |
| **Runtime** | Node |
| **Build Command** | `npm ci && npm run build` |
| **Start Command** | `npm start` |
| **Plan** | Free |

4. **Environment Variables**:

```bash
NODE_ENV=production
PUBLIC_URL=https://opensign-frontend.onrender.com
REACT_APP_SERVERURL=https://opensign-server.onrender.com/api/app
REACT_APP_APPID=opensign
GENERATE_SOURCEMAP=false
PORT=3000
```

5. Clique em **"Create Web Service"**

---

## ⚙️ Configurações Importantes

### **Email SMTP (Gmail)**

1. Acesse [myaccount.google.com](https://myaccount.google.com)
2. **Segurança** → **Verificação em 2 etapas** (ative)
3. Procure **"Senhas de app"**
4. Crie senha para "Email"
5. Use a senha de 16 caracteres em `SMTP_PASS`

### **Armazenamento de Arquivos**

#### **Opção 1: Local (Temporário)**
```bash
USE_LOCAL=true
```
- ⚠️ Arquivos podem ser perdidos em redeploys
- ✅ OK para testes

#### **Opção 2: S3/Digital Ocean Spaces (Produção)**
```bash
USE_LOCAL=false
DO_SPACE=seu-bucket
DO_ENDPOINT=ams3.digitaloceanspaces.com
DO_BASEURL=https://seu-bucket.ams3.digitaloceanspaces.com
DO_ACCESS_KEY_ID=sua-key
DO_SECRET_ACCESS_KEY=sua-secret
DO_REGION=ams3
```

### **Domínio Personalizado**

1. No Render, vá no serviço → **Settings**
2. **Custom Domain** → Adicione seu domínio
3. Configure DNS:
   ```
   CNAME: opensign.seudominio.com → opensign-frontend.onrender.com
   ```
4. Atualize variáveis de URL

---

## 🔍 Diferenças: Render vs Railway

| Característica | Render | Railway |
|---|---|---|
| **MongoDB Nativo** | ❌ Não (use Atlas) | ✅ Sim |
| **Free Tier** | 750h/mês | $5 crédito |
| **Hibernação** | ✅ Sim (free) | ❌ Não |
| **Preço Pago** | $7/mês | $5/mês |
| **Facilidade** | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |

---

## 🐛 Troubleshooting

### **Serviço não inicia**

1. Verifique **Logs** no dashboard
2. Confirme que `MONGODB_URI` está correta
3. Teste connection string do MongoDB Atlas

### **"This service is currently unavailable"**

- Free tier hibernou após 15 min
- Primeiro acesso demora ~30s para despertar
- Use plano pago ($7/mês) para evitar hibernação

### **Build falha**

1. Verifique **Root Directory** correto
2. Confirme **Build Command** está correto
3. Node.js deve ser 18, 20 ou 22

### **Frontend não conecta ao backend**

1. Verifique CORS no backend
2. Confirme `REACT_APP_SERVERURL` aponta para URL correta
3. Teste URL do backend manualmente: `https://opensign-server.onrender.com/app/health`

---

## 💰 Custos

### **Free Tier:**
- Web Services: 750h/mês (suficiente para 1 app rodando 24/7)
- MongoDB Atlas: 512MB grátis
- **Total: $0/mês** 🎉

### **Plano Pago (sem hibernação):**
- Web Service: $7/mês (cada)
- MongoDB Atlas: $0 (free tier M0)
- **Total: $14/mês** (2 serviços)

---

## 🎯 Checklist Rápido

- [ ] MongoDB Atlas configurado
- [ ] `render.yaml` no repositório
- [ ] Serviços criados no Render
- [ ] Variáveis de ambiente configuradas
- [ ] SMTP configurado com senha de app
- [ ] URLs atualizadas após deploy
- [ ] Testei acesso à aplicação
- [ ] Testei upload de documento
- [ ] Recebi email de teste

---

## 🆘 Suporte

- 📖 [Documentação Render](https://render.com/docs)
- 📖 [Documentação OpenSign](https://docs.opensignlabs.com)
- 💬 [Discord OpenSign](https://discord.com/invite/xe9TDuyAyj)

---

**Pronto para deploy no Render! 🎨**
