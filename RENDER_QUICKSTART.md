# 🚀 Deploy Rápido no Render

## ⚡ Início Rápido (5 minutos)

### 1️⃣ Execute o Script de Configuração

```powershell
.\render-setup.ps1
```

Isso vai:
- ✅ Gerar MASTER_KEY segura
- ✅ Criar arquivo com variáveis prontas
- ✅ Mostrar checklist do que fazer

### 2️⃣ Configure MongoDB Atlas (OBRIGATÓRIO)

1. Acesse → [mongodb.com/cloud/atlas](https://www.mongodb.com/cloud/atlas)
2. Crie conta (grátis)
3. Crie cluster M0 (gratuito)
4. Crie usuário do banco
5. Libere IP `0.0.0.0/0`
6. Copie connection string

**Exemplo de connection string:**
```
mongodb+srv://usuario:senha@cluster.xxxxx.mongodb.net/opensign
```

### 3️⃣ Configure Senha de App do Gmail

1. [myaccount.google.com](https://myaccount.google.com)
2. Segurança → Verificação em 2 etapas (ative)
3. Senhas de app → Gerar para "Email"
4. Copie a senha de 16 caracteres

### 4️⃣ Deploy no Render

**Opção A: Blueprint (Automático - Recomendado)**

1. Acesse [render.com](https://render.com)
2. New + → Blueprint
3. Conecte repositório GitHub
4. Selecione: vnschneider/OpenSign
5. Branch: staging
6. Apply

**Opção B: Manual**

Siga: `RENDER_DEPLOYMENT.md`

### 5️⃣ Configure Variáveis no Render

Use as variáveis geradas por `render-setup.ps1`:

**No serviço backend (opensign-server):**
- MASTER_KEY (a que foi gerada)
- MONGODB_URI (do Atlas)
- SMTP_USER_EMAIL (seu email)
- SMTP_PASS (senha de app de 16 chars)

**No serviço frontend (opensign-frontend):**
- PUBLIC_URL (após deploy, atualize com URL real)
- REACT_APP_SERVERURL (URL do backend + /api/app)

### 6️⃣ Aguarde Build

- Build leva ~10-15 minutos
- Acompanhe em: Deployments → Logs
- Quando mostrar "Live", está pronto! 🎉

### 7️⃣ Atualize URLs

Após primeiro deploy:
1. Copie URL do backend
2. Copie URL do frontend
3. Atualize variáveis conforme indicado
4. Aguarde redeploy

---

## 📚 Documentação Completa

- **Guia Passo a Passo:** `RENDER_DEPLOYMENT.md`
- **Checklist Interativo:** `RENDER_CHECKLIST.md`
- **Troubleshooting:** Ver `RENDER_DEPLOYMENT.md` seção "Troubleshooting"

---

## 💰 Custos

**Free Tier:**
- 750h/mês (1 serviço 24/7)
- MongoDB Atlas M0: Grátis
- **Total: $0/mês** ⚠️ Hiberna após 15 min

**Starter (Sem Hibernação):**
- $7/mês por serviço × 2 = $14/mês
- MongoDB Atlas M0: Grátis
- **Total: $14/mês**

---

## 🆘 Problemas?

1. Veja logs no Render
2. Consulte `RENDER_DEPLOYMENT.md`
3. Use `RENDER_CHECKLIST.md`

---

## ✅ Arquivos Importantes

- `render.yaml` - Configuração automática do Render
- `render-setup.ps1` - Script de configuração
- `.env.render` - Template de variáveis
- `RENDER_DEPLOYMENT.md` - Guia completo
- `RENDER_CHECKLIST.md` - Checklist interativo

---

**Boa sorte com seu deploy! 🎨**
