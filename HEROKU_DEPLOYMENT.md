# ⚠️ Heroku Deployment - NÃO RECOMENDADO

## 🚫 Por que NÃO usar Heroku?

**Heroku removeu o free tier em 2022** e agora é uma das opções **mais caras** do mercado:

### **Custos do Heroku:**
- **Eco Dyno**: $5/mês (hiberna após 30 min)
- **Basic Dyno**: $7/mês (sempre ativo)
- **MongoDB Atlas**: $15+/mês
- **Total mínimo**: ~$22-30/mês

### **Comparação de Preços:**

| Plataforma | Custo Mínimo | MongoDB | Total |
|---|---|---|---|
| **Railway** | $5/mês | Incluído | **$5/mês** |
| **Render** | $7/mês | Grátis (Atlas) | **$7/mês** |
| **Heroku** | $7/mês | $15+/mês | **$22+/mês** |

---

## 💡 Alternativas Recomendadas

### **Use uma destas plataformas:**

1. **🥇 Railway** - $5/mês tudo incluído
   - Veja: `RAILWAY_DEPLOYMENT.md`
   - Mais fácil e barato

2. **🥈 Render** - $7/mês (free tier disponível)
   - Veja: `RENDER_DEPLOYMENT.md`
   - Free tier com 750h/mês

3. **🥉 DigitalOcean** - $12/mês
   - Deploy oficial do OpenSign
   - Mais controle

---

## 📝 Se Ainda Assim Quiser Usar Heroku

### **Você precisará:**

1. **Conta Heroku** com cartão cadastrado
2. **MongoDB Atlas** (provedor externo)
3. **S3/DO Spaces** obrigatório (Heroku tem filesystem efêmero)
4. **~$22-30/mês** de budget

---

## 🔧 Deploy no Heroku (Passo a Passo)

### **Passo 1: Instalar Heroku CLI**

```bash
# Windows (PowerShell)
winget install Heroku.HerokuCLI

# Ou baixe em: https://devcenter.heroku.com/articles/heroku-cli
```

### **Passo 2: Login**

```bash
heroku login
```

### **Passo 3: Criar Aplicação**

```bash
cd c:\Users\FAB-PRO\Documents\GitHub\OpenSign
heroku create opensign-seu-nome
```

### **Passo 4: Configurar MongoDB Atlas**

1. Acesse [mongodb.com/cloud/atlas](https://www.mongodb.com/cloud/atlas)
2. Crie cluster gratuito (M0)
3. Configure usuário e senha
4. Network Access: `0.0.0.0/0`
5. Copie connection string

### **Passo 5: Configurar S3/Digital Ocean Spaces**

⚠️ **OBRIGATÓRIO** - Heroku não mantém arquivos entre deploys!

1. Crie bucket no Digital Ocean ou AWS S3
2. Obtenha Access Key e Secret Key

### **Passo 6: Configurar Variáveis**

```bash
# App Config
heroku config:set APP_ID=opensign
heroku config:set REACT_APP_APPID=opensign
heroku config:set NODE_ENV=production
heroku config:set appName=OpenSign

# URLs (substitua opensign-seu-nome.herokuapp.com pela sua URL)
heroku config:set PUBLIC_URL=https://opensign-seu-nome.herokuapp.com
heroku config:set REACT_APP_SERVERURL=https://opensign-seu-nome.herokuapp.com/api/app
heroku config:set SERVER_URL=https://opensign-seu-nome.herokuapp.com/api/app

# Segurança
heroku config:set MASTER_KEY=$(openssl rand -base64 12)

# Database (substitua pela sua connection string)
heroku config:set MONGODB_URI="mongodb+srv://usuario:senha@cluster.xxxxx.mongodb.net/opensign"

# Parse
heroku config:set PARSE_MOUNT=/app

# Storage - OBRIGATÓRIO S3/DO SPACES!
heroku config:set USE_LOCAL=false
heroku config:set DO_SPACE=seu-bucket
heroku config:set DO_ENDPOINT=ams3.digitaloceanspaces.com
heroku config:set DO_BASEURL=https://seu-bucket.ams3.digitaloceanspaces.com
heroku config:set DO_ACCESS_KEY_ID=sua-key
heroku config:set DO_SECRET_ACCESS_KEY=sua-secret
heroku config:set DO_REGION=ams3

# Email
heroku config:set SMTP_ENABLE=true
heroku config:set SMTP_HOST=smtp.gmail.com
heroku config:set SMTP_PORT=587
heroku config:set SMTP_USER_EMAIL=seu-email@gmail.com
heroku config:set SMTP_PASS=sua-senha-de-app
```

### **Passo 7: Criar Procfile**

Crie arquivo `Procfile` na raiz do projeto:

```bash
web: cd apps/OpenSignServer && npm start
```

### **Passo 8: Criar Build Script**

Crie `package.json` na raiz (se não existir):

```json
{
  "name": "opensign-heroku",
  "version": "1.0.0",
  "scripts": {
    "heroku-prebuild": "echo Preparando build",
    "heroku-postbuild": "cd apps/OpenSignServer && npm ci && cd ../OpenSign && npm ci && npm run build"
  },
  "engines": {
    "node": "18.x"
  }
}
```

### **Passo 9: Deploy**

```bash
git add Procfile package.json
git commit -m "feat: add Heroku configuration"
git push heroku staging:main
```

### **Passo 10: Escalar Dyno**

```bash
heroku ps:scale web=1
```

---

## 📊 Custos Detalhados

### **Plano Eco (Hibernação):**
- Eco Dyno: $5/mês
- MongoDB Atlas M0: $0 (grátis)
- DO Spaces: $5/mês
- **Total: $10/mês**
- ⚠️ Hiberna após 30 min de inatividade

### **Plano Basic (Sempre Ativo):**
- Basic Dyno: $7/mês
- MongoDB Atlas M0: $0 (grátis)
- DO Spaces: $5/mês
- **Total: $12/mês**
- ✅ Sempre ativo

### **Plano com MongoDB Pago:**
- Basic Dyno: $7/mês
- MongoDB Atlas M10: $15/mês
- DO Spaces: $5/mês
- **Total: $27/mês**

---

## 🐛 Problemas Comuns

### **Buildpack não encontrado**

```bash
heroku buildpacks:set heroku/nodejs
```

### **Timeout durante build**

- Heroku tem limite de 15 minutos para build
- OpenSign pode demorar mais
- Use CI/CD externo se necessário

### **Arquivos desaparecem**

- Heroku tem filesystem efêmero
- **OBRIGATÓRIO usar S3/DO Spaces**
- Configure `USE_LOCAL=false`

### **Erro de memória**

```bash
# Aumentar limite de memória (custa mais)
heroku config:set NODE_OPTIONS="--max-old-space-size=2048"
```

---

## 💭 Conclusão

**Heroku é viável tecnicamente, mas:**

- ❌ **3-6x mais caro** que Railway/Render
- ❌ **S3/DO Spaces obrigatório** (custo extra)
- ❌ **Sem free tier**
- ❌ **Builds podem ser problemáticos**
- ❌ **Menor custo-benefício**

### **Recomendações Finais:**

1. **Para produção séria**: Use **DigitalOcean** ou **VPS com Docker**
2. **Para começar rápido**: Use **Railway** ($5/mês)
3. **Para free tier**: Use **Render** (750h/mês grátis)
4. **Evite Heroku**: A menos que já tenha infraestrutura lá

---

## 📚 Recursos

- [Documentação Heroku](https://devcenter.heroku.com/)
- [MongoDB Atlas Docs](https://docs.atlas.mongodb.com/)
- [Digital Ocean Spaces](https://www.digitalocean.com/products/spaces)

---

**Considere fortemente usar Railway ou Render! 🚂🎨**
