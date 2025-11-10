# Script PowerShell para configurar Render
# Execute: .\render-setup.ps1

Write-Host ""
Write-Host "🎨 OpenSign - Configuração para Render" -ForegroundColor Cyan
Write-Host "=======================================" -ForegroundColor Cyan
Write-Host ""

# Gerar MASTER_KEY
$MASTER_KEY = -join ((65..90) + (97..122) + (48..57) | Get-Random -Count 16 | ForEach-Object {[char]$_})

Write-Host "✅ MASTER_KEY gerada: " -ForegroundColor Green -NoNewline
Write-Host $MASTER_KEY -ForegroundColor Yellow
Write-Host ""

Write-Host "📋 CHECKLIST - O que você precisa fazer:" -ForegroundColor Yellow
Write-Host ""
Write-Host "  1. ✅ Criar conta no MongoDB Atlas (grátis)" -ForegroundColor White
Write-Host "     → https://www.mongodb.com/cloud/atlas" -ForegroundColor Gray
Write-Host ""
Write-Host "  2. ✅ Criar cluster gratuito (M0)" -ForegroundColor White
Write-Host "     → Cluster Name: opensign-db" -ForegroundColor Gray
Write-Host "     → Provider: AWS" -ForegroundColor Gray
Write-Host "     → Region: us-east-1 (ou mais próximo de você)" -ForegroundColor Gray
Write-Host ""
Write-Host "  3. ✅ Criar usuário do banco" -ForegroundColor White
Write-Host "     → Database Access → Add New User" -ForegroundColor Gray
Write-Host "     → Username: opensign_user" -ForegroundColor Gray
Write-Host "     → Password: [gere uma senha forte]" -ForegroundColor Gray
Write-Host ""
Write-Host "  4. ✅ Liberar acesso de rede" -ForegroundColor White
Write-Host "     → Network Access → Add IP Address" -ForegroundColor Gray
Write-Host "     → Allow Access from Anywhere: 0.0.0.0/0" -ForegroundColor Gray
Write-Host ""
Write-Host "  5. ✅ Obter Connection String" -ForegroundColor White
Write-Host "     → Databases → Connect → Connect your application" -ForegroundColor Gray
Write-Host "     → Copie a string que parece com:" -ForegroundColor Gray
Write-Host "       mongodb+srv://opensign_user:<password>@cluster.xxxxx.mongodb.net/" -ForegroundColor DarkGray
Write-Host ""
Write-Host "  6. ✅ Email SMTP já configurado (Umbler)" -ForegroundColor White
Write-Host "     → Host: smtp.umbler.com" -ForegroundColor Gray
Write-Host "     → Email: naoresponda@efoconecta.online" -ForegroundColor Gray
Write-Host "     → Senha já incluída nas variáveis" -ForegroundColor Gray
Write-Host ""
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host ""
Write-Host "📝 VARIÁVEIS PARA CONFIGURAR NO RENDER:" -ForegroundColor Yellow
Write-Host ""

$envVars = @"
# ===== COPIE E COLE NO RENDER =====

# Segurança
MASTER_KEY=$MASTER_KEY

# MongoDB Atlas (SUBSTITUA com sua connection string)
MONGODB_URI=mongodb+srv://opensign_user:SUA_SENHA@cluster.xxxxx.mongodb.net/opensign?retryWrites=true&w=majority

# Email SMTP (Umbler - EFO Conecta)
SMTP_ENABLE=true
SMTP_HOST=smtp.umbler.com
SMTP_PORT=587
SMTP_USER_EMAIL=naoresponda@efoconecta.online
SMTP_PASS=478E-rb(iT7Lu

# App Config (NÃO ALTERE)
NODE_ENV=production
APP_ID=opensign
REACT_APP_APPID=opensign
appName=OpenSign
PARSE_MOUNT=/app
USE_LOCAL=true
PORT=8080

# URLs (ATUALIZE após criar os serviços no Render)
SERVER_URL=https://opensign-server-XXXX.onrender.com/app
PUBLIC_URL=https://opensign-frontend-XXXX.onrender.com
REACT_APP_SERVERURL=https://opensign-server-XXXX.onrender.com/api/app
GENERATE_SOURCEMAP=false
"@

Write-Host $envVars
Write-Host ""
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host ""

# Salvar em arquivo
$outputFile = ".env.render.generated"
$envVars | Out-File -FilePath $outputFile -Encoding UTF8

Write-Host "✅ Variáveis salvas em: " -ForegroundColor Green -NoNewline
Write-Host $outputFile -ForegroundColor Yellow
Write-Host ""
Write-Host "🎯 PRÓXIMOS PASSOS:" -ForegroundColor Yellow
Write-Host ""
Write-Host "  1. Configure MongoDB Atlas (links acima)" -ForegroundColor White
Write-Host "  2. Configure senha de app do Gmail" -ForegroundColor White
Write-Host "  3. Acesse https://render.com e crie conta" -ForegroundColor White
Write-Host "  4. Siga o guia: " -ForegroundColor White -NoNewline
Write-Host "RENDER_DEPLOYMENT.md" -ForegroundColor Cyan
Write-Host "  5. Use o arquivo: " -ForegroundColor White -NoNewline
Write-Host "render.yaml" -ForegroundColor Cyan -NoNewline
Write-Host " para deploy automático" -ForegroundColor White
Write-Host ""
Write-Host "📖 Documentação completa: RENDER_DEPLOYMENT.md" -ForegroundColor Cyan
Write-Host ""
