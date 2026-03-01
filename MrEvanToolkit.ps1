# =============================================================================
# MR EVAN INTELLIGENT REPAIR SYSTEM
# Console Avancado de Manutencao, Otimizacao e Seguranca Cibernetica.
# Versao: v2.0 Elite (Definitive SOC Edition)
# Autor: Evandro Lemos
# =============================================================================

$ErrorActionPreference = "SilentlyContinue"
$MRIRS_Version         = "v2.0 Elite"
$MRIRS_Width           = 105

# -----------------------------------------------------------------------------
# PILAR 7: SEGURANCA DO SCRIPT E ANTI-REMOTE
# -----------------------------------------------------------------------------
if ($env:SSH_CLIENT -or $env:SSH_TTY -or $PSSenderInfo) {
    Write-Host "[!] ALERTA CRITICO DE SEGURANCA [!]" -ForegroundColor Red
    Write-Host "Execucao remota detectada. Esta ferramenta so pode ser executada localmente." -ForegroundColor Yellow
    Start-Sleep 5
    exit
}

# -----------------------------------------------------------------------------
# ENGINE DE LOGGING ENTERPRISE
# -----------------------------------------------------------------------------
$global:LogDir = "$env:ProgramData\MrEvanIRS"
if (-not (Test-Path $global:LogDir)) { 
    try { New-Item -ItemType Directory -Path $global:LogDir -Force | Out-Null } catch {} 
}
$global:LogFile = "$global:LogDir\Enterprise_Audit.log"

function Write-MRLog {
    param([string]$Action, [string]$Status="INFO")
    try {
        $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        $user = [Environment]::UserName
        "[$timestamp] [USER: $user] [$Status] $Action" | Out-File -FilePath $global:LogFile -Append -Encoding UTF8
    } catch {}
}

Write-MRLog "Sessao v2.0 Elite iniciada." "START"

# -----------------------------------------------------------------------------
# FUNCAO EULA (WEB SERVER EMBUTIDO NA MEMORIA COM VISUAL ELITE)
# -----------------------------------------------------------------------------
function Start-EULAListener {

    $port = 8899
    $accepted = $false

    try {
        $listener = New-Object System.Net.HttpListener
        $listener.Prefixes.Add("http://localhost:$port/")
        $listener.Start()
    }
    catch {
        Write-Host "Falha ao iniciar servidor EULA." -ForegroundColor Red
        Start-Sleep 4
        exit
    }

    Write-Host "Abrindo painel de seguranca no navegador..." -ForegroundColor Yellow

    # O HTML FICA DENTRO DO SCRIPT (Visual Corporativo Moderno)
    $eulaHTML = @"
<!DOCTYPE html>
<html lang="pt-BR">
<head>
<meta charset="UTF-8">
<title>Mr Evan IRS - Licença e Termos</title>
<style>
    :root {
        --bg: #09090b;
        --surface: #18181b;
        --text-primary: #f4f4f5;
        --text-secondary: #a1a1aa;
        --accent: #38bdf8;
        --danger: #ef4444;
        --danger-bg: rgba(239, 68, 68, 0.1);
        --success: #10b981;
        --success-disabled: #064e3b;
        --border: #27272a;
    }
    body {
        background-color: var(--bg);
        color: var(--text-primary);
        font-family: 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
        margin: 0;
        display: flex;
        justify-content: center;
        align-items: center;
        height: 100vh;
        overflow: hidden;
    }
    .wrapper {
        background-color: var(--surface);
        border-radius: 12px;
        box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.7);
        width: 100%;
        max-width: 750px;
        display: flex;
        flex-direction: column;
        max-height: 90vh;
        border: 1px solid var(--border);
    }
    .header {
        padding: 25px 30px;
        border-bottom: 1px solid var(--border);
        text-align: center;
        background-color: #1f1f22;
        border-top-left-radius: 12px;
        border-top-right-radius: 12px;
    }
    .header h1 { margin: 0; font-size: 22px; color: var(--accent); letter-spacing: 0.5px; }
    .header p { margin: 5px 0 0; color: var(--text-secondary); font-size: 13px; font-weight: 500;}
    
    .content {
        padding: 30px 40px;
        overflow-y: auto;
        flex-grow: 1;
        line-height: 1.7;
        color: #d4d4d8;
        font-size: 14px;
    }
    
    /* Scrollbar Customizada Estilo Mac/Dark */
    .content::-webkit-scrollbar { width: 8px; }
    .content::-webkit-scrollbar-track { background: var(--bg); border-radius: 4px; }
    .content::-webkit-scrollbar-thumb { background: #52525b; border-radius: 4px; }
    .content::-webkit-scrollbar-thumb:hover { background: #71717a; }

    h2 { color: var(--text-primary); font-size: 16px; margin-top: 30px; border-bottom: 1px solid var(--border); padding-bottom: 8px;}
    h2:first-of-type { margin-top: 0; }
    
    .warning-box {
        background-color: var(--danger-bg);
        border-left: 4px solid var(--danger);
        padding: 15px 20px;
        border-radius: 4px;
        margin: 20px 0;
        font-size: 14px;
    }
    .warning-box strong { color: var(--danger); }
    
    ul { padding-left: 20px; margin-top: 10px;}
    li { margin-bottom: 8px; }

    .footer-actions {
        padding: 20px 30px;
        background-color: #1f1f22;
        border-top: 1px solid var(--border);
        border-bottom-left-radius: 12px;
        border-bottom-right-radius: 12px;
        display: flex;
        justify-content: space-between;
        align-items: center;
    }
    
    .scroll-hint { font-size: 13px; color: var(--text-secondary); display: flex; align-items: center; gap: 8px;}
    .pulse-icon { display: inline-block; width: 8px; height: 8px; background-color: var(--danger); border-radius: 50%; animation: pulse 1.5s infinite; }
    @keyframes pulse { 0% { box-shadow: 0 0 0 0 rgba(239, 68, 68, 0.7); } 70% { box-shadow: 0 0 0 6px rgba(239, 68, 68, 0); } 100% { box-shadow: 0 0 0 0 rgba(239, 68, 68, 0); } }

    .buttons { display: flex; gap: 12px; }
    button {
        padding: 10px 24px;
        border: none;
        border-radius: 6px;
        font-size: 14px;
        font-weight: 600;
        cursor: pointer;
        transition: all 0.2s ease;
    }
    .btn-accept { background-color: var(--success); color: #000; }
    .btn-accept:hover:not(:disabled) { background-color: #34d399; transform: translateY(-1px); }
    .btn-accept:disabled { background-color: var(--success-disabled); color: #9ca3af; cursor: not-allowed; }
    
    .btn-reject { background-color: transparent; color: var(--danger); border: 1px solid var(--danger); }
    .btn-reject:hover { background-color: var(--danger-bg); }

    .status-screen { display: flex; flex-direction: column; align-items: center; justify-content: center; height: 100%; text-align: center; padding: 40px; }
    .status-screen h2 { border: none; font-size: 24px; margin-bottom: 10px; padding-bottom: 0; }
    .status-success h2 { color: var(--success); }
    .status-reject h2 { color: var(--danger); }
</style>
<script>
    function checkScroll() {
        const content = document.getElementById("scrollBox");
        const button = document.getElementById("acceptBtn");
        const hintText = document.getElementById("hintText");
        const pulse = document.getElementById("pulseDot");
        
        // Margem de erro de 20px para facilitar a liberação
        if (content.scrollTop + content.clientHeight >= content.scrollHeight - 20) {
            button.disabled = false;
            pulse.style.backgroundColor = "#10b981";
            pulse.style.animation = "none";
            hintText.innerText = "Leitura concluída. Você pode aceitar.";
            hintText.style.color = "#10b981";
        }
    }
    function acceptEULA() {
        fetch("/accept").then(() => {
            document.body.innerHTML = '<div class="wrapper"><div class="status-screen status-success"><h2>✓ Acesso Liberado</h2><p style="color:#a1a1aa;">Os termos foram aceitos e registrados pelo sistema.</p><h3 style="color:#f4f4f5; margin-top:20px;">Você pode fechar esta aba com segurança.</h3></div></div>';
        }).catch(() => alert("Erro na comunicação com o Mr Evan IRS."));
    }
    function rejectEULA() {
        fetch("/reject").then(() => {
            document.body.innerHTML = '<div class="wrapper"><div class="status-screen status-reject"><h2>✕ Acesso Negado</h2><p style="color:#a1a1aa;">Você optou por não aceitar as políticas de uso.</p><h3 style="color:#f4f4f5; margin-top:20px;">O script foi encerrado. Pode fechar esta aba.</h3></div></div>';
        }).catch(() => alert("Erro na comunicação com o Mr Evan IRS."));
    }
</script>
</head>
<body>
<div class="wrapper">
    <div class="header">
        <h1>END USER LICENSE AGREEMENT</h1>
        <p>CONTRATO DE LICENÇA DE USUÁRIO FINAL — MR EVAN IRS (v2.0 Elite)</p>
    </div>
    
    <div class="content" id="scrollBox" onscroll="checkScroll()">
        <div class="warning-box">
            <strong>AVISO DE SEGURANÇA:</strong> Leia atentamente as regras abaixo. Você precisa <strong>rolar a página até o final</strong> para habilitar o botão de aceite.
        </div>

        <h2>1. ACEITAÇÃO DOS TERMOS</h2>
        <p>Ao executar este software, você declara que leu, compreendeu e concorda integralmente com este contrato firmado com o autor <strong>Evandro Lemos</strong>.</p>

        <h2>2. CONCESSÃO DE LICENÇA E USO</h2>
        <p>O Mr Evan IRS é distribuído sob uma licença limitada, revogável e intransferível. Este sistema é liberado estritamente para uso <strong>pessoal e técnico autorizado</strong> em equipamentos próprios ou de clientes que deram consentimento explícito.</p>

        <h2>3. USOS ESTRITAMENTE PROIBIDOS</h2>
        <ul>
            <li>Uso da ferramenta para invasão (Hacking) ou acesso não autorizado a sistemas.</li>
            <li>Comercialização, revenda ou distribuição desta ferramenta como um serviço pago (SaaS).</li>
            <li>Ocultação ou remoção dos créditos do desenvolvedor original.</li>
            <li>Uso das ferramentas de bypass (utilman.exe) em máquinas furtadas ou sob investigação.</li>
        </ul>

        <h2>4. OPERAÇÕES DE ALTO RISCO (KERNEL)</h2>
        <p>Este sistema não é um simples "limpador". Ele realiza modificações em nível de Kernel (Núcleo) do Windows, interagindo com:</p>
        <ul>
            <li>Políticas de Grupo (GPO) e Registro do Windows (Regedit).</li>
            <li>Configurações de rede, Winsock, DNS e Firewall.</li>
            <li>Carregador de inicialização do Windows (BCD e MBR).</li>
        </ul>
        <div class="warning-box" style="margin-top: 10px;">
            O uso irresponsável de módulos SOC ou de Recuperação Offline pode causar <strong>Tela Azul da Morte (BSOD)</strong>, quebra de conectividade e corrupção de boot. Toda e qualquer alteração é feita por sua conta e risco.
        </div>

        <h2>5. PRIVACIDADE E TELEMETRIA (LGPD)</h2>
        <p>A ferramenta roda 100% localmente e não envia dados do seu computador para servidores ocultos. Consultas em APIs de Threat Intelligence (ipinfo.io e VirusTotal) são disparadas unicamente a seu comando, não incluindo dados pessoais sensíveis.</p>

        <h2>6. AUSÊNCIA DE GARANTIAS</h2>
        <p>O SOFTWARE É FORNECIDO "COMO ESTÁ". Em nenhuma circunstância o desenvolvedor será responsabilizado por perda de dados, danos ao hardware ou interrupção de negócios decorrentes do uso da ferramenta.</p>
    </div>

    <div class="footer-actions">
        <div class="scroll-hint">
            <span class="pulse-icon" id="pulseDot"></span>
            <span id="hintText">Role a caixa de texto até o fim para liberar acesso.</span>
        </div>
        <div class="buttons">
            <button class="btn-reject" onclick="rejectEULA()">RECUSAR</button>
            <button class="btn-accept" id="acceptBtn" onclick="acceptEULA()" disabled>EU CONCORDO</button>
        </div>
    </div>
</div>
</body>
</html>
"@

    Start-Process "http://localhost:$port/"

    while (-not $accepted) {
        $context = $listener.GetContext()
        $request = $context.Request
        $response = $context.Response

        if ($request.Url.AbsolutePath -eq "/") {
            $buffer = [System.Text.Encoding]::UTF8.GetBytes($eulaHTML)
            $response.ContentType = "text/html"
            $response.ContentLength64 = $buffer.Length
            $response.OutputStream.Write($buffer,0,$buffer.Length)
            $response.Close()
        }
        elseif ($request.Url.AbsolutePath -eq "/accept") {
            try { Write-MRLog "EULA aceito pelo usuario." "EULA" } catch {}
            $msg = "Confirmacao recebida."
            $buffer = [System.Text.Encoding]::UTF8.GetBytes($msg)
            $response.OutputStream.Write($buffer,0,$buffer.Length)
            $response.Close()
            $accepted = $true
        }
        elseif ($request.Url.AbsolutePath -eq "/reject") {
            Write-Host "`nACESSO NEGADO." -ForegroundColor Red
            Start-Sleep 4
            $listener.Stop()
            exit
        }
    }

    $listener.Stop()
    Write-Host "EULA ACEITO." -ForegroundColor Green
}

# -----------------------------------------------------------------------------
# CHECAGEM DE ADMIN
# -----------------------------------------------------------------------------
function Test-IsAdmin {
    try {
        $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
        $principal   = New-Object Security.Principal.WindowsPrincipal($currentUser)
        return $principal.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
    } catch { return $false }
}

if (-not (Test-IsAdmin)) {

    Write-Host "ATENCAO: Requer privilegios de ADMINISTRADOR." -ForegroundColor Yellow
    $resp = Read-Host "Deseja reabrir como Administrador agora? (S/N)"

    if ($resp -match "^[sS]") {
        $scriptPath = $MyInvocation.MyCommand.Path
        Start-Process powershell.exe -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$scriptPath`"" -Verb RunAs
        exit
    } else {
        exit
    }
}

# -----------------------------------------------------------------------------
# CHAMADA DO EULA
# -----------------------------------------------------------------------------
Start-EULAListener

# -----------------------------------------------------------------------------
# FUNCOES DE INTERFACE GRAFICA E FORMATACAO (UI)
# -----------------------------------------------------------------------------
function Pause-MR {
    Write-Host "`nPressione qualquer tecla para voltar ao menu..." -ForegroundColor DarkGray
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}

function Write-Separator { 
    Write-Host ("-" * $MRIRS_Width) -ForegroundColor DarkGray 
}

function Show-Center {
    param(
        [string]$Text, 
        [string]$Color = "White"
    )
    $trimmed = $Text.Trim()
    $pad = [math]::Floor(($MRIRS_Width - $trimmed.Length) / 2)
    if ($pad -lt 0) { 
        $pad = 0 
    }
    Write-Host ((" " * $pad) + $trimmed) -ForegroundColor $Color
}

function Show-Header {
    Clear-Host
    Write-Host ""
    Write-Separator
    Show-Center "███╗   ███╗██████╗     ███████╗██╗   ██╗██████╗ ███╗   ██╗" "Red"
    Show-Center "████╗ ████║██╔══██╗    ██╔════╝██║   ██║██╔══██╗████╗  ██║" "Red"
    Show-Center "██╔████╔██║██████╔╝    █████╗  ██║   ██║███████║██╔██╗ ██║" "Red"
    Show-Center "██║╚██╔╝██║██╔══██╗    ██╔══╝  ╚██╗ ██╔╝██╔══██║██║╚██╗██║" "Red"
    Show-Center "██║ ╚═╝ ██║██║  ██║    ███████╗ ╚████╔╝ ██║  ██║██║ ╚████║" "Red"
    Show-Center "╚═╝     ╚═╝╚═╝  ╚═╝    ╚══════╝  ╚═══╝  ╚═╝  ╚═╝╚═╝  ╚═══╝" "Red"
    Write-Host ""
    Show-Center "Intelligent Repair System" "Red"
    Show-Center "Created by Evandro Lemos" "DarkGray"
    Write-Host ""
    Show-Center "Versao $MRIRS_Version | Windows 10/11" "Gray"
    Write-Separator
    Show-Center "Use os numeros para navegar. 0 sempre volta/sai." "Gray"
    Write-Separator
    Write-Host ""
}
# -----------------------------------------------------------------------------
# MENU PRINCIPAL GIGANTE
# -----------------------------------------------------------------------------
function Show-MainMenu {
    Show-Header
    
    Write-Host " --- MANUTENCAO E REPAROS (USO GERAL) ---" -ForegroundColor DarkYellow
    
    Write-Host " [1] OTIMIZAR AGORA            " -ForegroundColor Cyan -NoNewline
    Write-Host "[LIMPEZA]  " -ForegroundColor Green -NoNewline
    Write-Host "- Limpar lixo, caches e privacidade do PC" -ForegroundColor Gray
    
    Write-Host " [2] WINDOWS / OFFICE          " -ForegroundColor Cyan -NoNewline
    Write-Host "[ATIVADOR] " -ForegroundColor DarkMagenta -NoNewline
    Write-Host "- Ativa o Windows e o Office para sempre" -ForegroundColor Gray
    
    Write-Host " [3] FERRAMENTAS GAMER         " -ForegroundColor Cyan -NoNewline
    Write-Host "[GAMER]    " -ForegroundColor Magenta -NoNewline
    Write-Host "- Aumenta FPS, reduz lag do mouse e do sistema" -ForegroundColor Gray
    
    Write-Host " [4] FERRAMENTAS SISTEMA       " -ForegroundColor Cyan -NoNewline
    Write-Host "[SISTEMA]  " -ForegroundColor Yellow -NoNewline
    Write-Host "- Repara erros, arruma internet e apaga inuteis" -ForegroundColor Gray
    
    Write-Host " [5] DIAGNOSTICO DO PC         " -ForegroundColor Cyan -NoNewline
    Write-Host "[INFO]     " -ForegroundColor Blue -NoNewline
    Write-Host "- EXTRATOR DE LICENCAS OEM, gargalo e saude" -ForegroundColor Gray
    
    Write-Host " [6] UTILITARIOS EXTRAS        " -ForegroundColor Cyan -NoNewline
    Write-Host "[EXTRAS]   " -ForegroundColor DarkCyan -NoNewline
    Write-Host "- Winget Auto-Installer, Backup de Drivers" -ForegroundColor Gray
    
    Write-Host "`n --- MODO AVANCADO E CIBERSEGURANCA ---" -ForegroundColor DarkYellow
    
    Write-Host " [7] MODO TECNICO AVANCADO     " -ForegroundColor Cyan -NoNewline
    Write-Host "[DANGER]   " -ForegroundColor Red -NoNewline
    Write-Host "- RADAR SPYWARE, ANALISE EDR E GOD MODE UNBRICK" -ForegroundColor Gray
    
    Write-Host " [8] RESTAURAR PADROES         " -ForegroundColor Cyan -NoNewline
    Write-Host "[UNDO]     " -ForegroundColor Green -NoNewline
    Write-Host "- Desfaz alteracoes e repara problemas" -ForegroundColor Gray
    
    Write-Host " [9] SUPORTE REMOTO            " -ForegroundColor Cyan -NoNewline
    Write-Host "[SUPORTE]  " -ForegroundColor Blue -NoNewline
    Write-Host "- AnyDesk e RustDesk direto como Administrador" -ForegroundColor Gray
    
    Write-Host " [10] RECUPERACAO OFFLINE      " -ForegroundColor Cyan -NoNewline
    Write-Host "[BOOT]     " -ForegroundColor DarkYellow -NoNewline
    Write-Host "- Ferramentas para uso em Pendrive (WinPE e SrtTrail)" -ForegroundColor Gray
    
    Write-Host " [11] MUDAR IDIOMA             " -ForegroundColor Cyan -NoNewline
    Write-Host "[LANG]     " -ForegroundColor White -NoNewline
    Write-Host "- Executar versoes em Ingles e Espanhol" -ForegroundColor Gray
    
    Write-Host "`n [0] SAIR DO SISTEMA           " -ForegroundColor Red -NoNewline
    Write-Host "[---]      " -ForegroundColor DarkGray -NoNewline
    Write-Host "- Fechar o Mr Evan IRS com seguranca" -ForegroundColor Gray
    Write-Host ""
}

# -----------------------------------------------------------------------------
# BLOCO 1 E 2: OTIMIZACAO E ATIVADOR
# -----------------------------------------------------------------------------
function Open-OptimizeMenu {
    do {
        Show-Header
        Write-Host "=== OTIMIZAR AGORA ===" -ForegroundColor Magenta
        Write-Host ""
        Write-Host " [1] OTIMIZACAO E FAXINA COMPLETA " -ForegroundColor Cyan -NoNewline
        Write-Host "[LIMPEZA]  " -ForegroundColor Green -NoNewline
        Write-Host "- Limpa tudo de uma vez (Rede, Update e Lixo)" -ForegroundColor Gray
        Write-Host " [2] LIMPEZA DE TEMPORARIOS       " -ForegroundColor Cyan -NoNewline
        Write-Host "[LIMPEZA]  " -ForegroundColor Green -NoNewline
        Write-Host "- Esvazia Lixeira, pasta Temp e Prefetch" -ForegroundColor Gray
        Write-Host " [3] CACHE DE NAVEGADORES         " -ForegroundColor Cyan -NoNewline
        Write-Host "[LIMPEZA]  " -ForegroundColor Green -NoNewline
        Write-Host "- Libera espaco do Chrome, Edge e Firefox" -ForegroundColor Gray
        Write-Host " [4] PRIVACIDADE E RASTROS        " -ForegroundColor Cyan -NoNewline
        Write-Host "[LIMPEZA]  " -ForegroundColor Green -NoNewline
        Write-Host "- Apaga Itens Recentes e Jump Lists" -ForegroundColor Gray
        Write-Host " [5] WINDOWS UPDATE E LOGS ERRO   " -ForegroundColor Cyan -NoNewline
        Write-Host "[LIMPEZA]  " -ForegroundColor Green -NoNewline
        Write-Host "- Apaga relatorios de erro (WER) antigos" -ForegroundColor Gray
        Write-Host " [6] OTIMIZAR REDE E DNS          " -ForegroundColor Cyan -NoNewline
        Write-Host "[LIMPEZA]  " -ForegroundColor Green -NoNewline
        Write-Host "- Executa FlushDNS para melhorar conexao" -ForegroundColor Gray
        Write-Host "`n [0] VOLTAR                       " -ForegroundColor Yellow -NoNewline
        Write-Host "[---]      " -ForegroundColor DarkGray -NoNewline
        Write-Host "- Retornar ao Menu Inicial" -ForegroundColor Gray
        Write-Host ""

        $opt = Read-Host "Escolha uma opcao"
        switch ($opt) {
            "1" {
                $c = Read-Host "Confirmar otimizacao completa do PC? (S/N)"
                if ($c -match "^[sS]") {
                    Write-Host "`n[1/5] Limpando arquivos temporarios da maquina..." -ForegroundColor Green
                    @($env:TEMP, "$env:WINDIR\Temp", "$env:WINDIR\Prefetch", "$env:LOCALAPPDATA\Temp") | ForEach-Object { try { Remove-Item -Path $_ -Recurse -Force -ErrorAction SilentlyContinue } catch {} }
                    Clear-RecycleBin -Force -ErrorAction SilentlyContinue
                    Write-Host "[2/5] Limpando caches pesados de navegadores de internet..." -ForegroundColor Green
                    @("$env:LOCALAPPDATA\Google\Chrome\User Data\*\Cache", "$env:LOCALAPPDATA\Microsoft\Edge\User Data\*\Cache") | ForEach-Object { try { Get-ChildItem -Path $_ -Force -Recurse -ErrorAction SilentlyContinue | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue } catch {} }
                    Write-Host "[3/5] Removendo rastros de uso e historico de privacidade..." -ForegroundColor Green
                    try { Remove-Item -Path "$env:APPDATA\Microsoft\Windows\Recent\*" -Force -ErrorAction SilentlyContinue } catch {}
                    try { Remove-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU" -Name "*" -ErrorAction SilentlyContinue } catch {}
                    Write-Host "[4/5] Limpando lixo residual do Windows Update..." -ForegroundColor Green
                    try { Remove-Item -Path "$env:WINDIR\SoftwareDistribution\Download\*" -Recurse -Force -ErrorAction SilentlyContinue } catch {}
                    try { ipconfig /flushdns | Out-Null } catch {}
                    Write-Host "[5/5] Iniciando limpeza de imagem profunda (DISM)..." -ForegroundColor Cyan
                    try { DISM.exe /Online /Cleanup-Image /StartComponentCleanup | Out-Null } catch {}
                    Write-Host "`nOtimizacao completa finalizada com exito!" -ForegroundColor Green; Pause-MR
                }
            }
            "2" { Write-Host "Limpando..."; @($env:TEMP, "$env:WINDIR\Temp", "$env:WINDIR\Prefetch") | ForEach-Object { try { Remove-Item -Path $_ -Recurse -Force -ErrorAction SilentlyContinue } catch {} }; Clear-RecycleBin -Force -ErrorAction SilentlyContinue; Write-Host "Arquivos limpos." -ForegroundColor Green; Pause-MR }
            "3" { Write-Host "Limpando..."; @("$env:LOCALAPPDATA\Google\Chrome\User Data\*\Cache", "$env:LOCALAPPDATA\Microsoft\Edge\User Data\*\Cache") | ForEach-Object { try { Get-ChildItem -Path $_ -Force -Recurse -ErrorAction SilentlyContinue | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue } catch {} }; Write-Host "Caches limpos." -ForegroundColor Green; Pause-MR }
            "4" { Write-Host "Apagando rastros..."; try { Remove-Item -Path "$env:APPDATA\Microsoft\Windows\Recent\*" -Force -ErrorAction SilentlyContinue } catch {}; try { Remove-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU" -Name "*" -ErrorAction SilentlyContinue } catch {}; Write-Host "Privacidade limpa." -ForegroundColor Green; Pause-MR }
            "5" { Write-Host "Limpando erros..."; try { Remove-Item -Path "$env:WINDIR\SoftwareDistribution\Download\*" -Recurse -Force -ErrorAction SilentlyContinue } catch {}; try { Remove-Item -Path "$env:ProgramData\Microsoft\Windows\WER\ReportArchive\*" -Recurse -Force -ErrorAction SilentlyContinue } catch {}; Write-Host "Logs apagados." -ForegroundColor Green; Pause-MR }
            "6" { try { ipconfig /flushdns | Out-Null; Write-Host "Rede otimizada." -ForegroundColor Green } catch {}; Pause-MR }
            "0" { return }
            default { Write-Host "Opcao invalida." -ForegroundColor Red; Pause-MR }
        }
    } while ($true)
}

function Open-ActivatorMenu {
    do {
        Show-Header
        Write-Host "=== WINDOWS / OFFICE ===" -ForegroundColor Magenta
        Write-Host ""
        Write-Host " [1] ATIVAR WINDOWS E OFFICE      " -ForegroundColor Cyan -NoNewline
        Write-Host "[ATIVADOR] " -ForegroundColor DarkMagenta -NoNewline
        Write-Host "- Abre script oficial MAS (massgrave.dev) vitalicio" -ForegroundColor Gray
        Write-Host " [2] BYPASS WIN 11 (TPM/CPU)      " -ForegroundColor Cyan -NoNewline
        Write-Host "[ATIVADOR] " -ForegroundColor DarkMagenta -NoNewline
        Write-Host "- Forca atualizacao em PCs incompativeis e abre o site" -ForegroundColor Gray
        Write-Host " [3] STATUS DA ATIVACAO           " -ForegroundColor Cyan -NoNewline
        Write-Host "[ATIVADOR] " -ForegroundColor DarkMagenta -NoNewline
        Write-Host "- Verifica e exibe janela provando se o PC esta ativado" -ForegroundColor Gray
        Write-Host "`n [0] VOLTAR                       " -ForegroundColor Yellow -NoNewline
        Write-Host "[---]      " -ForegroundColor DarkGray -NoNewline
        Write-Host "- Retornar ao Menu Inicial" -ForegroundColor Gray
        Write-Host ""

        $opt = Read-Host "Escolha uma opcao"
        switch ($opt) {
            "1" { Write-Host "Conectando ao GitHub..."; try { irm "https://get.activated.win" | iex } catch { Write-Host "Erro." -ForegroundColor Red }; Pause-MR }
            "2" {
                Write-Host "Injetando chaves no registro..." -ForegroundColor Yellow
                $path = "HKLM:\SYSTEM\Setup\MoSetup"
                try { if (-not (Test-Path $path)) { New-Item -Path $path -Force | Out-Null } } catch {}
                try { New-ItemProperty -Path $path -Name "AllowUpgradesWithUnsupportedTPMOrCPU" -Value 1 -PropertyType DWord -Force | Out-Null } catch {}
                Write-Host "Bypass aplicado! Abrindo site..." -ForegroundColor Green; try { Start-Process "https://www.microsoft.com/pt-br/software-download/windows11" } catch {}; Pause-MR
            }
            "3" { try { slmgr /xpr } catch {}; Pause-MR }
            "0" { return }
            default { Write-Host "Opcao invalida." -ForegroundColor Red; Pause-MR }
        }
    } while ($true)
}
# -----------------------------------------------------------------------------
# BLOCO 3: FERRAMENTAS GAMER E SISTEMA
# -----------------------------------------------------------------------------
function Open-GamerMenu {
    do {
        Show-Header
        Write-Host "=== FERRAMENTAS GAMER ===" -ForegroundColor Magenta
        Write-Host ""
        Write-Host " [1] REDUZIR LATENCIA (TIMER)   " -ForegroundColor Cyan -NoNewline
        Write-Host "[GAMER]   " -ForegroundColor Magenta -NoNewline
        Write-Host "- Abaixa tempo de resposta do Windows para 0.5ms" -ForegroundColor Gray
        Write-Host " [2] FORCAR PRIORIDADE ALTA     " -ForegroundColor Cyan -NoNewline
        Write-Host "[GAMER]   " -ForegroundColor Magenta -NoNewline
        Write-Host "- Foca processamento no executavel do seu jogo" -ForegroundColor Gray
        Write-Host " [3] DESATIVAR TELA CHEIA (FSO) " -ForegroundColor Cyan -NoNewline
        Write-Host "[GAMER]   " -ForegroundColor Magenta -NoNewline
        Write-Host "- Tira o lag do Alt+Tab nos jogos em tela cheia" -ForegroundColor Gray
        Write-Host " [4] DESBLOQUEAR NUCLEOS CPU    " -ForegroundColor Cyan -NoNewline
        Write-Host "[GAMER]   " -ForegroundColor Magenta -NoNewline
        Write-Host "- Forca 100% dos nucleos da CPU no boot/jogo" -ForegroundColor Gray
        Write-Host " [5] MOUSE PRECISAO 1:1         " -ForegroundColor Cyan -NoNewline
        Write-Host "[GAMER]   " -ForegroundColor Magenta -NoNewline
        Write-Host "- Remove aceleracao nativa do ponteiro (Para FPS)" -ForegroundColor Gray
        Write-Host " [6] OTIMIZAR TECLADO           " -ForegroundColor Cyan -NoNewline
        Write-Host "[GAMER]   " -ForegroundColor Magenta -NoNewline
        Write-Host "- Resposta rapida ao segurar teclas (Delay nulo)" -ForegroundColor Gray
        Write-Host " [7] REDUZIR PACOTES REDE       " -ForegroundColor Cyan -NoNewline
        Write-Host "[GAMER]   " -ForegroundColor Magenta -NoNewline
        Write-Host "- Otimiza TCP Ack para baixar o ping em partidas" -ForegroundColor Gray
        Write-Host " [8] DESATIVAR GAME BAR E DVR   " -ForegroundColor Cyan -NoNewline
        Write-Host "[GAMER]   " -ForegroundColor Magenta -NoNewline
        Write-Host "- Desliga gravacao em segundo plano da Microsoft" -ForegroundColor Gray
        Write-Host " [9] PLANO ENERGIA DESEMPENHO   " -ForegroundColor Cyan -NoNewline
        Write-Host "[GAMER]   " -ForegroundColor Magenta -NoNewline
        Write-Host "- Ativa modo maximo desempenho no hardware" -ForegroundColor Gray
        Write-Host "`n [0] VOLTAR                     " -ForegroundColor Yellow -NoNewline
        Write-Host "[---]     " -ForegroundColor DarkGray -NoNewline
        Write-Host "- Retornar ao Menu Inicial" -ForegroundColor Gray
        Write-Host ""

        $opt = Read-Host "Escolha uma opcao"
        switch ($opt) {
            "1" { 
                try { 
                    $code = '[DllImport("ntdll.dll")] public static extern int NtSetTimerResolution(uint d, bool s, ref uint c);'
                    Add-Type -MemberDefinition $code -Namespace Win32 -Name Nt -ErrorAction SilentlyContinue
                    $cur = 0; [Win32.Nt]::NtSetTimerResolution(5000, $true, [ref]$cur) | Out-Null
                    Write-Host "Timer fixado em 0.5ms. Mantenha esta janela aberta." -ForegroundColor Green 
                } catch { Write-Host "Erro na API de Tempo." -ForegroundColor Red }
                Pause-MR 
            }
            "2" {
                $nome = Read-Host "Digite o nome exato do executavel do jogo (ex: cs2.exe)"
                if ($nome) { 
                    try { 
                        $path = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\$nome\PerfOptions"
                        if (-not (Test-Path $path)) { New-Item -Path $path -Force | Out-Null }
                        Set-ItemProperty -Path $path -Name "CpuPriorityClass" -Value 3 -Type DWord -Force
                        Write-Host "Prioridade alta definida!" -ForegroundColor Green 
                    } catch {} 
                }
                Pause-MR
            }
            "3" { try { $path = "HKCU:\System\GameConfigStore"; if (-not (Test-Path $path)) { New-Item -Path $path -Force | Out-Null }; Set-ItemProperty -Path $path -Name "GameDVR_FSEBehaviorMode" -Value 2 -Type DWord -Force; Write-Host "FSO desativado." -ForegroundColor Green } catch {}; Pause-MR }
            "4" { Start-Process msconfig.exe -ArgumentList "/2"; Write-Host "Va em 'Inicializacao do Sistema' -> 'Opcoes Avancadas' e marque 'Numero de Processadores'."; Pause-MR }
            "5" { try { Set-ItemProperty -Path "HKCU:\Control Panel\Mouse" -Name "MouseSpeed" -Value "0" -Force; Set-ItemProperty -Path "HKCU:\Control Panel\Mouse" -Name "MouseThreshold1" -Value "0" -Force; Set-ItemProperty -Path "HKCU:\Control Panel\Mouse" -Name "MouseThreshold2" -Value "0" -Force; Write-Host "Aceleracao morta." -ForegroundColor Green } catch {}; Pause-MR }
            "6" { try { Set-ItemProperty -Path "HKCU:\Control Panel\Accessibility\Keyboard Response" -Name "AutoRepeatDelay" -Value "150" -Type DWord -Force; Write-Host "Teclado otimizado." -ForegroundColor Green } catch {}; Pause-MR }
            "7" { try { $ints = Get-Item "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\*" -ErrorAction SilentlyContinue; foreach ($i in $ints) { New-ItemProperty -Path $i.PSPath -Name "TcpAckFrequency" -Value 1 -PropertyType DWord -Force -ErrorAction SilentlyContinue | Out-Null }; Write-Host "Rede otimizada." -ForegroundColor Green } catch {}; Pause-MR }
            "8" { try { $p1 = "HKCU:\SOFTWARE\Microsoft\GameBar"; $p2 = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR"; if (-not (Test-Path $p1)) { New-Item -Path $p1 -Force | Out-Null }; if (-not (Test-Path $p2)) { New-Item -Path $p2 -Force | Out-Null }; Set-ItemProperty -Path $p1 -Name "ShowGameBar" -Value 0 -Type DWord -Force; Set-ItemProperty -Path $p2 -Name "AllowGameDVR" -Value 0 -Type DWord -Force; Write-Host "Game Bar desativada." -ForegroundColor Green } catch {}; Pause-MR }
            "9" { try { powercfg -setactive SCHEME_MIN | Out-Null; Write-Host "Plano ativado." -ForegroundColor Green } catch {}; Pause-MR }
            "0" { return }
            default { Write-Host "Opcao invalida." -ForegroundColor Red; Pause-MR }
        }
    } while ($true)
}

function Open-SystemToolsMenu {
    do {
        Show-Header
        Write-Host "=== FERRAMENTAS DO SISTEMA (PAGINA 1/2) ===" -ForegroundColor Yellow
        Write-Host ""
        Write-Host " [1] WINUTIL (CHRIS TITUS)        " -ForegroundColor Cyan -NoNewline
        Write-Host "[SISTEMA] " -ForegroundColor Yellow -NoNewline
        Write-Host "- Ferramenta grafica externa para Tweaks de Windows" -ForegroundColor Gray
        Write-Host " [2] REPARAR ARQUIVOS (SFC/DISM)  " -ForegroundColor Cyan -NoNewline
        Write-Host "[SISTEMA] " -ForegroundColor Yellow -NoNewline
        Write-Host "- Varre DLLs e conserta erros de inicializacao" -ForegroundColor Gray
        Write-Host " [3] ARRUMAR WINDOWS UPDATE       " -ForegroundColor Cyan -NoNewline
        Write-Host "[SISTEMA] " -ForegroundColor Yellow -NoNewline
        Write-Host "- Destrava servicos BITS e limpa updates bugados" -ForegroundColor Gray
        Write-Host " [4] ESCOLHER MELHOR DNS (REDE)   " -ForegroundColor Cyan -NoNewline
        Write-Host "[SISTEMA] " -ForegroundColor Yellow -NoNewline
        Write-Host "- Testa e aplica rotas rapidas (Cloudflare/Google)" -ForegroundColor Gray
        Write-Host " [5] DESCARREGAR CACHE DNS        " -ForegroundColor Cyan -NoNewline
        Write-Host "[SISTEMA] " -ForegroundColor Yellow -NoNewline
        Write-Host "- Limpa resolucoes antigas (ipconfig /flushdns)" -ForegroundColor Gray
        Write-Host " [6] CRIAR PONTO DE RESTAURACAO   " -ForegroundColor Cyan -NoNewline
        Write-Host "[SISTEMA] " -ForegroundColor Yellow -NoNewline
        Write-Host "- Salva as configuracoes antes de formatar" -ForegroundColor Gray
        Write-Host " [7] VERIFICAR DISCO (CHKDSK)     " -ForegroundColor Cyan -NoNewline
        Write-Host "[SISTEMA] " -ForegroundColor Yellow -NoNewline
        Write-Host "- Varre e corrige bad blocks no HD/SSD" -ForegroundColor Gray
        Write-Host " [8] MAIS FERRAMENTAS (PAGINA 2)  " -ForegroundColor Magenta -NoNewline
        Write-Host "[SISTEMA] " -ForegroundColor Yellow -NoNewline
        Write-Host "- Acessar Hosts, Variaveis e God Mode" -ForegroundColor Gray
        Write-Host "`n [0] VOLTAR                       " -ForegroundColor Yellow -NoNewline
        Write-Host "[---]     " -ForegroundColor DarkGray -NoNewline
        Write-Host "- Retornar ao Menu Inicial" -ForegroundColor Gray
        Write-Host ""

        $opt = Read-Host "Escolha uma opcao"
        switch ($opt) {
            "1" { try { irm "https://christitus.com/win" | iex } catch {}; Pause-MR }
            "2" { Show-Header; sfc.exe /scannow; DISM.exe /Online /Cleanup-Image /RestoreHealth; Pause-MR }
            "3" {
                try { Stop-Service wuauserv -Force -ErrorAction SilentlyContinue; Stop-Service bits -Force -ErrorAction SilentlyContinue } catch {}
                try { Remove-Item "$env:WINDIR\SoftwareDistribution\Download\*" -Recurse -Force -ErrorAction SilentlyContinue } catch {}
                try { Start-Service wuauserv -ErrorAction SilentlyContinue; Start-Service bits -ErrorAction SilentlyContinue } catch {}
                Write-Host "Update destravado." -ForegroundColor Green; Pause-MR
            }
            "4" {
                try {
                    $g = (Test-Connection 8.8.8.8 -Count 1 -ErrorAction SilentlyContinue).ResponseTime
                    $c = (Test-Connection 1.1.1.1 -Count 1 -ErrorAction SilentlyContinue).ResponseTime
                    $idx = (Get-NetAdapter | Where-Object Status -eq Up).InterfaceIndex
                    if ($c -le $g) { Set-DnsClientServerAddress -InterfaceIndex $idx -ServerAddresses @("1.1.1.1","1.0.0.1"); Write-Host "DNS Cloudflare aplicado!" -ForegroundColor Green } 
                    else { Set-DnsClientServerAddress -InterfaceIndex $idx -ServerAddresses @("8.8.8.8","8.8.4.4"); Write-Host "DNS Google aplicado!" -ForegroundColor Green }
                } catch { Write-Host "Erro na placa." -ForegroundColor Red }
                Pause-MR
            }
            "5" { try { ipconfig /flushdns | Out-Null; Write-Host "DNS Limpo." -ForegroundColor Green } catch {}; Pause-MR }
            "6" { try { Checkpoint-Computer -Description "Mr Evan IRS" -RestorePointType "MODIFY_SETTINGS" -ErrorAction Stop; Write-Host "Ponto criado." -ForegroundColor Green } catch {}; Pause-MR }
            "7" { Show-Header; chkdsk C: /scan; Pause-MR }
            "8" { Open-SystemToolsMenuPage2 }
            "0" { return }
            default { Write-Host "Opcao invalida." -ForegroundColor Red; Pause-MR }
        }
    } while ($true)
}

function Open-SystemToolsMenuPage2 {
    do {
        Show-Header
        Write-Host "=== FERRAMENTAS DO SISTEMA (PAGINA 2/2) ===" -ForegroundColor Yellow
        Write-Host ""
        Write-Host " [1] EDITAR ARQUIVO HOSTS         " -ForegroundColor Cyan -NoNewline
        Write-Host "[SISTEMA] " -ForegroundColor Yellow -NoNewline
        Write-Host "- Abre HOSTS no bloco de notas para bloquear sites" -ForegroundColor Gray
        Write-Host " [2] VARIAVEIS DE AMBIENTE        " -ForegroundColor Cyan -NoNewline
        Write-Host "[SISTEMA] " -ForegroundColor Yellow -NoNewline
        Write-Host "- Abre configuracoes avancadas do sistema" -ForegroundColor Gray
        Write-Host " [3] GERENCIADOR DE TAREFAS       " -ForegroundColor Cyan -NoNewline
        Write-Host "[SISTEMA] " -ForegroundColor Yellow -NoNewline
        Write-Host "- Atalho direto para aba de Inicializacao" -ForegroundColor Gray
        Write-Host " [4] PROGRAMAS E RECURSOS         " -ForegroundColor Cyan -NoNewline
        Write-Host "[SISTEMA] " -ForegroundColor Yellow -NoNewline
        Write-Host "- Abre o appwiz.cpl para desinstalar softwares" -ForegroundColor Gray
        Write-Host " [5] INFORMACOES DO SISTEMA       " -ForegroundColor Cyan -NoNewline
        Write-Host "[SISTEMA] " -ForegroundColor Yellow -NoNewline
        Write-Host "- Abre a ferramenta msinfo32" -ForegroundColor Gray
        Write-Host " [6] PING / TESTE DE LATENCIA     " -ForegroundColor Cyan -NoNewline
        Write-Host "[SISTEMA] " -ForegroundColor Yellow -NoNewline
        Write-Host "- Dispara pacotes para avaliar perda de conexao" -ForegroundColor Gray
        Write-Host " [7] RESETAR CACHE DE FONTES      " -ForegroundColor Cyan -NoNewline
        Write-Host "[SISTEMA] " -ForegroundColor Yellow -NoNewline
        Write-Host "- Conserta letras borradas ou quadradas" -ForegroundColor Gray
        Write-Host " [8] ATALHO 'GOD MODE'            " -ForegroundColor Cyan -NoNewline
        Write-Host "[SISTEMA] " -ForegroundColor Yellow -NoNewline
        Write-Host "- Cria pasta com +200 paineis na Area de Trabalho" -ForegroundColor Gray
        Write-Host "`n [0] VOLTAR (PAGINA 1)            " -ForegroundColor Yellow -NoNewline
        Write-Host "[---]     " -ForegroundColor DarkGray -NoNewline
        Write-Host "- Retornar a lista anterior" -ForegroundColor Gray
        Write-Host ""

        $opt = Read-Host "Escolha uma opcao"
        switch ($opt) {
            "1" { try { Start-Process notepad.exe -ArgumentList "$env:WINDIR\System32\drivers\etc\hosts" } catch {} }
            "2" { try { Start-Process "SystemPropertiesAdvanced.exe" } catch {} }
            "3" { try { Start-Process taskmgr.exe } catch {} }
            "4" { try { Start-Process appwiz.cpl } catch {} }
            "5" { try { Start-Process msinfo32.exe } catch {} }
            "6" { $alvo = Read-Host "Digite IP ou site"; if ($alvo) { try { Test-Connection $alvo -Count 4 } catch {} }; Pause-MR }
            "7" { try { Stop-Service FontCache -Force -ErrorAction SilentlyContinue; Remove-Item "$env:LOCALAPPDATA\Microsoft\Windows\Fonts\*.dat" -Force -ErrorAction SilentlyContinue; Start-Service FontCache -ErrorAction SilentlyContinue; Write-Host "Fontes resetadas." -ForegroundColor Green } catch {}; Pause-MR }
            "8" { try { New-Item -ItemType Directory -Path "$env:USERPROFILE\Desktop\GodMode.{ED7BA470-8E54-465E-825C-99712043E01C}" -Force | Out-Null; Write-Host "God Mode criado!" -ForegroundColor Green } catch {}; Pause-MR }
            "0" { return }
            default { Write-Host "Opcao invalida." -ForegroundColor Red; Pause-MR }
        }
    } while ($true)
}
# -----------------------------------------------------------------------------
# BLOCO 5 E 6: DIAGNOSTICO CORPORATIVO (SOC) E EXTRAS
# -----------------------------------------------------------------------------
function Run-AdvancedHealthMonitor {
    Show-Header
    Write-Host "=== HEALTH MONITOR AVANCADO (HARDWARE & FIRMWARE) ===" -ForegroundColor Cyan
    
    Write-Host "`n[+] Status de Seguranca do Boot (Firmware):" -ForegroundColor Yellow
    try {
        $tpm = Get-Tpm -ErrorAction SilentlyContinue
        if ($tpm.TpmPresent) { Write-Host " - Modulo TPM: Presente e Ativo (Versao $($tpm.TpmSpecVersion))" -ForegroundColor Green }
        else { Write-Host " - Modulo TPM: Desativado ou Inexistente" -ForegroundColor Red }
    } catch { Write-Host " - Modulo TPM: Nao suportado ou sem permissao." -ForegroundColor DarkGray }

    try {
        $sb = Confirm-SecureBootUEFI -ErrorAction SilentlyContinue
        if ($sb -eq $true) { Write-Host " - Secure Boot: ATIVADO" -ForegroundColor Green }
        else { Write-Host " - Secure Boot: DESATIVADO" -ForegroundColor Red }
    } catch { Write-Host " - Secure Boot: BIOS Legada ou Nao Suportado." -ForegroundColor DarkGray }

    Write-Host "`n[+] Saude dos Discos Fisicos (S.M.A.R.T):" -ForegroundColor Yellow
    try {
        $disks = Get-PhysicalDisk -ErrorAction SilentlyContinue
        foreach ($d in $disks) {
            $health = if ($d.HealthStatus -eq "Healthy") { "SAUDAVEL" } else { "CRITICO/FALHANDO" }
            $col = if ($health -eq "SAUDAVEL") { "Green" } else { "Red" }
            Write-Host " - Disco $($d.DeviceId) ($($d.MediaType)): $($d.FriendlyName) | Status: $health" -ForegroundColor $col
        }
    } catch { Write-Host " - Erro ao ler S.M.A.R.T." -ForegroundColor Red }

    Write-Host "`n[+] Status da Bateria (Apenas Laptops):" -ForegroundColor Yellow
    try {
        $bat = Get-CimInstance -ClassName Win32_Battery -ErrorAction SilentlyContinue
        if ($bat) {
            Write-Host " - Bateria detectada. Carga atual: $($bat.EstimatedChargeRemaining)%" -ForegroundColor Cyan
            Write-Host " - Status: $($bat.BatteryStatus)" -ForegroundColor Cyan
        } else {
            Write-Host " - Nenhuma bateria detectada (Desktop)." -ForegroundColor DarkGray
        }
    } catch { Write-Host " - Erro de WMI de bateria." -ForegroundColor DarkGray }

    Write-Host "`n[+] Protecao de Dados (BitLocker):" -ForegroundColor Yellow
    try {
        $bde = Get-BitLockerVolume -MountPoint "C:" -ErrorAction SilentlyContinue
        if ($bde.VolumeStatus -eq "FullyEncrypted") { Write-Host " - Unidade C: Encriptada e Protegida." -ForegroundColor Green }
        else { Write-Host " - Unidade C: Desprotegida (Sem BitLocker)." -ForegroundColor Red }
    } catch { Write-Host " - Servico BitLocker indisponivel nesta versao do Windows." -ForegroundColor DarkGray }

    Pause-MR
}

function Export-EnterpriseReport {
    Show-Header
    Write-Host "=== GERADOR DE DASHBOARD CORPORATIVO (SOC) ===" -ForegroundColor Magenta
    Write-Host "Coletando telemetria, seguranca e hardware para o relatorio visual..." -ForegroundColor Yellow
    
    $pcName = $env:COMPUTERNAME
    $date = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
    $basePath = "$env:USERPROFILE\Desktop\Auditoria_$pcName"
    
    try {
        if (-not (Test-Path $basePath)) { New-Item -Path $basePath -ItemType Directory -Force | Out-Null }
        
        # 1. COLETANDO HARDWARE
        Write-Host " -> Analisando Hardware..." -ForegroundColor DarkGray
        $os = Get-CimInstance Win32_OperatingSystem -ErrorAction SilentlyContinue
        $cpu = Get-CimInstance Win32_Processor | Select-Object -First 1 -ErrorAction SilentlyContinue
        $bios = Get-CimInstance Win32_BIOS -ErrorAction SilentlyContinue
        $sys = Get-CimInstance Win32_ComputerSystem -ErrorAction SilentlyContinue
        $ram = [math]::Round($sys.TotalPhysicalMemory / 1GB, 2)
        $disk = Get-CimInstance Win32_LogicalDisk -Filter "DeviceID='C:'" -ErrorAction SilentlyContinue
        $diskFree = [math]::Round($disk.FreeSpace / 1GB, 2)
        $diskTotal = [math]::Round($disk.Size / 1GB, 2)
        
        # 2. COLETANDO SEGURANCA (PARA OS INDICADORES DE RISCO)
        Write-Host " -> Auditando Seguranca..." -ForegroundColor DarkGray
        
        # UAC
        $uacReg = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -ErrorAction SilentlyContinue).EnableLUA
        $uacStatus = if ($uacReg -eq 1) { "Ativo (Seguro)" } else { "Desativado (Risco Critico)" }
        $uacClass = if ($uacReg -eq 1) { "badge success" } else { "badge danger" }
        
        # Secure Boot
        $sb = Confirm-SecureBootUEFI -ErrorAction SilentlyContinue
        $sbStatus = if ($sb -eq $true) { "Ativado" } elseif ($sb -eq $false) { "Desativado (Vulneravel)" } else { "Nao Suportado" }
        $sbClass = if ($sb -eq $true) { "badge success" } elseif ($sb -eq $false) { "badge danger" } else { "badge warning" }
        
        # Antivirus (Defender)
        $av = Get-CimInstance -Namespace "root\SecurityCenter2" -Class AntivirusProduct -ErrorAction SilentlyContinue
        $avName = if ($av) { $av.displayName[0] } else { "Nenhum Detectado" }
        $avClass = if ($av) { "badge success" } else { "badge danger" }

        # Firewall
        $fw = Get-NetFirewallProfile -Profile Domain,Public,Private -ErrorAction SilentlyContinue | Where-Object Enabled -eq 2 # 2 is false
        $fwStatus = if (-not $fw) { "Ativo e Protegendo" } else { "Perfis Desativados" }
        $fwClass = if (-not $fw) { "badge success" } else { "badge danger" }

        # S.M.A.R.T Disco
        $smart = Get-PhysicalDisk -ErrorAction SilentlyContinue | Where-Object HealthStatus -ne "Healthy"
        $smartStatus = if (-not $smart) { "Saudavel (OK)" } else { "Falha Iminente Detectada" }
        $smartClass = if (-not $smart) { "badge success" } else { "badge danger" }

        # Calculo de Risco Geral
        $riskScore = 0
        if ($uacReg -ne 1) { $riskScore += 30 }
        if ($sb -eq $false) { $riskScore += 20 }
        if (-not $av) { $riskScore += 30 }
        if ($fw) { $riskScore += 20 }
        
        $riskLevel = if ($riskScore -lt 20) { "Baixo" } elseif ($riskScore -lt 60) { "Medio" } else { "Alto (Critico)" }
        $riskClass = if ($riskScore -lt 20) { "success" } elseif ($riskScore -lt 60) { "warning" } else { "danger" }

        # 3. CONSTRUINDO O DASHBOARD HTML
        Write-Host " -> Gerando Dashboard HTML..." -ForegroundColor DarkGray
        
        $htmlPath = "$basePath\Dashboard_SOC_$date.html"
        $html = @"
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard de Auditoria - Mr Evan IRS</title>
    <style>
        :root { --bg: #0f172a; --card: #1e293b; --text: #f8fafc; --text-muted: #94a3b8; --accent: #3b82f6; --success: #10b981; --warning: #f59e0b; --danger: #ef4444; }
        body { font-family: 'Segoe UI', Roboto, Helvetica, Arial, sans-serif; background-color: var(--bg); color: var(--text); margin: 0; padding: 20px; line-height: 1.6; }
        .container { max-width: 1200px; margin: 0 auto; }
        .header { background-color: var(--card); padding: 30px; border-radius: 12px; text-align: center; box-shadow: 0 4px 6px rgba(0,0,0,0.2); border-top: 5px solid var(--accent); margin-bottom: 30px; }
        .header h1 { margin: 0; color: var(--text); font-size: 2.5em; letter-spacing: 1px; }
        .header p { color: var(--text-muted); margin-top: 10px; font-size: 1.1em; }
        
        .grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(350px, 1fr)); gap: 20px; margin-bottom: 30px; }
        .card { background-color: var(--card); padding: 25px; border-radius: 12px; box-shadow: 0 4px 6px rgba(0,0,0,0.2); }
        .card h2 { margin-top: 0; border-bottom: 1px solid #334155; padding-bottom: 15px; color: var(--text); display: flex; align-items: center; justify-content: space-between;}
        
        table { width: 100%; border-collapse: collapse; }
        td { padding: 12px 0; border-bottom: 1px solid #334155; }
        td:first-child { color: var(--text-muted); font-weight: 500; width: 40%; }
        td:last-child { color: var(--text); font-weight: 600; text-align: right; }
        tr:last-child td { border-bottom: none; }
        
        .badge { padding: 6px 12px; border-radius: 6px; font-size: 0.85em; font-weight: bold; display: inline-block; }
        .success { background-color: rgba(16, 185, 129, 0.15); color: var(--success); border: 1px solid var(--success); }
        .warning { background-color: rgba(245, 158, 11, 0.15); color: var(--warning); border: 1px solid var(--warning); }
        .danger { background-color: rgba(239, 68, 68, 0.15); color: var(--danger); border: 1px solid var(--danger); }
        
        .score-box { text-align: center; padding: 20px; border-radius: 12px; margin-bottom: 20px; }
        .score-box.success { background-color: rgba(16, 185, 129, 0.1); border: 2px solid var(--success); }
        .score-box.warning { background-color: rgba(245, 158, 11, 0.1); border: 2px solid var(--warning); }
        .score-box.danger { background-color: rgba(239, 68, 68, 0.1); border: 2px solid var(--danger); }
        .score-value { font-size: 3em; font-weight: bold; margin: 10px 0; line-height: 1; }
        
        .footer { text-align: center; margin-top: 50px; color: var(--text-muted); font-size: 0.9em; border-top: 1px solid #334155; padding-top: 20px; }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>Relatório Executivo de Integração</h1>
            <p>Auditoria de Segurança, Hardware e Compliance</p>
            <span class="badge" style="background:#334155; color:white; border:1px solid #475569; margin-top:10px;">Data da Varredura: $date</span>
        </div>

        <div class="score-box $riskClass">
            <h3 style="margin:0; color:inherit;">NÍVEL DE RISCO DO ENDPOINT</h3>
            <div class="score-value" style="color:var(--$riskClass);">$riskLevel</div>
            <p style="margin:0; color:var(--text-muted);">Pontuação Calculada: $riskScore / 100 (Quanto menor, mais seguro)</p>
        </div>

        <div class="grid">
            <div class="card">
                <h2>🛡️ Postura de Segurança</h2>
                <table>
                    <tr><td>Controle de Conta (UAC)</td><td><span class="$uacClass">$uacStatus</span></td></tr>
                    <tr><td>Secure Boot (UEFI)</td><td><span class="$sbClass">$sbStatus</span></td></tr>
                    <tr><td>Antivírus Principal</td><td><span class="$avClass">$avName</span></td></tr>
                    <tr><td>Firewall do Windows</td><td><span class="$fwClass">$fwStatus</span></td></tr>
                </table>
            </div>

            <div class="card">
                <h2>💻 Inventário de Hardware</h2>
                <table>
                    <tr><td>Fabricante / Modelo</td><td>$($sys.Manufacturer) - $($sys.Model)</td></tr>
                    <tr><td>Processador (CPU)</td><td>$($cpu.Name)</td></tr>
                    <tr><td>Memória RAM Total</td><td>$ram GB</td></tr>
                    <tr><td>Saúde do Disco (S.M.A.R.T)</td><td><span class="$smartClass">$smartStatus</span></td></tr>
                    <tr><td>Armazenamento (C:)</td><td>Livre: $diskFree GB / Total: $diskTotal GB</td></tr>
                </table>
            </div>

            <div class="card">
                <h2>⚙️ Sistema Operacional</h2>
                <table>
                    <tr><td>Estação de Trabalho</td><td>$pcName</td></tr>
                    <tr><td>Edição do SO</td><td>$($os.Caption)</td></tr>
                    <tr><td>Build Architecture</td><td>$($os.BuildNumber)</td></tr>
                    <tr><td>Versão da BIOS</td><td>$($bios.SMBIOSBIOSVersion)</td></tr>
                    <tr><td>Serial Number</td><td>$($bios.SerialNumber)</td></tr>
                </table>
            </div>
        </div>
        
        <div class="footer">
            Gerado automaticamente por <strong>Mr Evan Intelligent Repair System (v2.0 Elite)</strong><br>
            Ferramenta restrita para uso técnico e SOC.
        </div>
    </div>
</body>
</html>
"@
        $html | Set-Content -Path $htmlPath -Force -Encoding UTF8

        Write-Host "`n[OK] Dashboard HTML Gerado com Sucesso!" -ForegroundColor Green
        Write-Host "Caminho: $htmlPath" -ForegroundColor Cyan
        
        try { Write-MRLog "Gerou Dashboard HTML Profissional (Score: $riskScore)" "REPORT" } catch {}

        $abrir = Read-Host "`nDeseja abrir o Dashboard elegante no navegador agora? (S/N)"
        if ($abrir -match "^[sS]") { Start-Process $htmlPath }
    } catch {
        Write-Host "Falha ao gerar o relatorio executivo." -ForegroundColor Red
    }
    Pause-MR
}

function Manage-SystemBaseline {
    Show-Header
    Write-Host "=== ENGINE DE COMPARACAO DE BASELINE (SNAPSHOT) ===" -ForegroundColor Magenta
    Write-Host "Crie um DNA do sistema limpo e compare no futuro para achar anomalias.`n" -ForegroundColor DarkGray
    
    Write-Host " [1] Criar Snapshot (Estado Zero do Sistema)" -ForegroundColor Cyan
    Write-Host " [2] Comparar Sistema Atual com Snapshot Anterior" -ForegroundColor Yellow
    Write-Host "`n [0] Voltar" -ForegroundColor DarkGray
    
    $opt = Read-Host "`nEscolha"
    $baselinePath = "$global:LogDir\SystemBaseline.json"

    if ($opt -eq "1") {
        Write-Host "`n[+] Capturando a assinatura genetica do sistema (Servicos, Tarefas, Portas)..." -ForegroundColor Yellow
        try {
            $baseline = @{
                "Date" = (Get-Date -Format "yyyy-MM-dd HH:mm:ss")
                "Services" = (Get-Service | Where-Object Status -eq 'Running').Name
                "Ports" = (Get-NetTCPConnection -State Listen -ErrorAction SilentlyContinue).LocalPort | Select-Object -Unique
            }
            $baseline | ConvertTo-Json -Depth 3 | Set-Content $baselinePath -Force
            Write-Host "[OK] Snapshot criado e protegido em $baselinePath!" -ForegroundColor Green
            Write-MRLog "Criou um novo Snapshot de Baseline do Sistema" "SUCCESS"
        } catch { Write-Host "Erro ao gerar Snapshot." -ForegroundColor Red }
        Pause-MR
    }
    elseif ($opt -eq "2") {
        if (-not (Test-Path $baselinePath)) { 
            Write-Host "`n[X] Nenhum Snapshot encontrado. Formate a maquina ou limpe-a e crie um Snapshot (Opcao 1) primeiro." -ForegroundColor Red
            Pause-MR; return 
        }
        
        Write-Host "`n[+] Cruzando DNA atual com o Snapshot salvo..." -ForegroundColor Yellow
        try {
            $old = Get-Content $baselinePath | ConvertFrom-Json
            Write-Host "Snapshot de referencia data de: $($old.Date)`n" -ForegroundColor DarkGray
            
            $curServices = (Get-Service | Where-Object Status -eq 'Running').Name
            $curPorts = (Get-NetTCPConnection -State Listen -ErrorAction SilentlyContinue).LocalPort | Select-Object -Unique
            
            Write-Host "=== RESULTADO DA AUDITORIA ===" -ForegroundColor Red
            
            $newServ = Compare-Object -ReferenceObject $old.Services -DifferenceObject $curServices | Where-Object SideIndicator -eq '=>'
            if ($newServ) { 
                Write-Host "`n[!] NOVOS SERVICOS ATIVOS (Possivel Persistencia):" -ForegroundColor Yellow
                $newServ.InputObject | ForEach-Object { Write-Host "  -> $_" -ForegroundColor Red } 
            } else { Write-Host "`n[OK] Nenhum servico estranho adicionado." -ForegroundColor Green }
            
            $newPorts = Compare-Object -ReferenceObject $old.Ports -DifferenceObject $curPorts | Where-Object SideIndicator -eq '=>'
            if ($newPorts) { 
                Write-Host "`n[!] NOVAS PORTAS ESCUTANDO (Possivel Backdoor):" -ForegroundColor Yellow
                $newPorts.InputObject | ForEach-Object { Write-Host "  -> Porta TCP $_" -ForegroundColor Red } 
            } else { Write-Host "`n[OK] Nenhuma porta de rede nova aberta." -ForegroundColor Green }

            Write-MRLog "Executou comparacao de Baseline de Sistema" "AUDIT"
        } catch { Write-Host "Erro ao comparar Baseline." -ForegroundColor Red }
        Pause-MR
    }
}

function Open-DiagnosticsMenu {
    do {
        Show-Header
        Write-Host "=== DIAGNOSTICO DO PC E INVENTARIO (SOC LEVEL) ===" -ForegroundColor Blue
        Write-Host ""
        Write-Host " [1] Health Monitor Avancado (SMART, TPM, Bateria) " -ForegroundColor Cyan -NoNewline
        Write-Host "[INFO] " -ForegroundColor Blue -NoNewline
        Write-Host "- Checa a saude critica do hardware" -ForegroundColor Gray
        
        Write-Host " [2] Gerar Relatorio Corporativo (HTML/JSON)       " -ForegroundColor Cyan -NoNewline
        Write-Host "[INFO] " -ForegroundColor Blue -NoNewline
        Write-Host "- Exporta inventario profissional (Asset Tracking)" -ForegroundColor Gray
        
        Write-Host " [3] Extrator de Licencas OEM (BIOS e Registro)    " -ForegroundColor Cyan -NoNewline
        Write-Host "[INFO] " -ForegroundColor Blue -NoNewline
        Write-Host "- Resgata chaves ativadas na maquina" -ForegroundColor Gray
        
        Write-Host " [4] Abrir Informacoes Nativas do Sistema          " -ForegroundColor Cyan -NoNewline
        Write-Host "[INFO] " -ForegroundColor Blue -NoNewline
        Write-Host "- Abre a ferramenta nativa msinfo32" -ForegroundColor Gray
        
        Write-Host " [5] Monitor de Recursos em Tempo Real             " -ForegroundColor Cyan -NoNewline
        Write-Host "[INFO] " -ForegroundColor Blue -NoNewline
        Write-Host "- Analise de gargalo via resmon" -ForegroundColor Gray

        Write-Host " [6] ENGINE DE COMPARACAO DE BASELINE              " -ForegroundColor Magenta -NoNewline
        Write-Host "[SOC]  " -ForegroundColor Red -NoNewline
        Write-Host "- Cria Snapshot e detecta mudancas de malwares" -ForegroundColor Gray
        
        Write-Host "`n [0] VOLTAR                                        " -ForegroundColor Yellow -NoNewline
        Write-Host "[---]  " -ForegroundColor DarkGray -NoNewline
        Write-Host "- Retornar ao Menu Inicial" -ForegroundColor Gray
        Write-Host ""

        $opt = Read-Host "Escolha uma opcao"
        switch ($opt) {
            "1" { Run-AdvancedHealthMonitor; Write-MRLog "Rodou Health Monitor" }
            "2" { Export-EnterpriseReport; Write-MRLog "Exportou Relatorio Corporativo HTML" }
            "3" {
                Show-Header; Write-Host "Buscando Chaves..." -ForegroundColor Yellow
                $outPath = "$env:USERPROFILE\Desktop\Chaves_Cliente_MrEvan.txt"
                $content = @("=== EXTRATOR DE LICENCAS ===")
                try { $wmi = (Get-WmiObject -query 'select * from SoftwareLicensingService' -ErrorAction Stop).OA3xOriginalProductKey; if ($wmi) { $content += "Chave BIOS OEM: $wmi"; Write-Host "Chave BIOS: $wmi" -ForegroundColor Green } else { $content += "Chave BIOS: Nao encontrada." } } catch {}
                try { $reg = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SoftwareProtectionPlatform" -ErrorAction SilentlyContinue).BackupProductKeyDefault; if ($reg) { $content += "Chave Registro: $reg"; Write-Host "Chave Registro: $reg" -ForegroundColor Green } } catch {}
                try { Set-Content -Path $outPath -Value $content -Force; Start-Process notepad.exe -ArgumentList $outPath } catch {}
                Write-MRLog "Extraiu Licencas OEM"
                Pause-MR
            }
            "4" { try { Start-Process msinfo32.exe } catch {} }
            "5" { try { Start-Process resmon.exe } catch {} }
            "6" { Manage-SystemBaseline }
            "0" { return }
            default { Write-Host "Opcao invalida." -ForegroundColor Red; Pause-MR }
        }
    } while ($true)
}
function Open-ExtrasMenu {
    do {
        Show-Header
        Write-Host "=== UTILITARIOS EXTRAS E BACKUP FORENSE ===" -ForegroundColor DarkCyan
        Write-Host ""
        
        Write-Host " [1] KIT POS-FORMATACAO WINGET    " -ForegroundColor Cyan -NoNewline
        Write-Host "[EXTRAS]  " -ForegroundColor DarkCyan -NoNewline
        Write-Host "- Instala Chrome, WinRAR e PDF silenciosamente" -ForegroundColor Gray
        
        Write-Host " [2] BACKUP FORENSE AVANCADO      " -ForegroundColor Magenta -NoNewline
        Write-Host "[BACKUP]  " -ForegroundColor DarkCyan -NoNewline
        Write-Host "- Salva Drivers, Wi-Fi, Registro e IPs locais" -ForegroundColor Gray
        
        Write-Host " [3] LIMPEZA DE DISCO NATIVA      " -ForegroundColor Cyan -NoNewline
        Write-Host "[EXTRAS]  " -ForegroundColor DarkCyan -NoNewline
        Write-Host "- Abre a Limpeza (cleanmgr) para Windows.old" -ForegroundColor Gray
        
        Write-Host " [4] CONFIGURACOES ARMAZENAMENTO  " -ForegroundColor Cyan -NoNewline
        Write-Host "[EXTRAS]  " -ForegroundColor DarkCyan -NoNewline
        Write-Host "- Painel de espaco do Windows 10/11" -ForegroundColor Gray
        
        Write-Host "`n [0] VOLTAR                       " -ForegroundColor Yellow -NoNewline
        Write-Host "[---]     " -ForegroundColor DarkGray -NoNewline
        Write-Host "- Retornar ao Menu Inicial" -ForegroundColor Gray
        Write-Host ""

        $opt = Read-Host "Escolha uma opcao"
        switch ($opt) {
            "1" { 
                Show-Header; Write-Host "Instalando via Winget..." -ForegroundColor Yellow
                $apps = @("Google.Chrome", "RARLab.WinRAR", "geeksoftware.PDF24Creator", "Microsoft.PCManager", "WhatsApp.WhatsApp", "Adobe.Acrobat.Reader.64-bit")
                foreach ($app in $apps) { try { winget install $app --accept-source-agreements --accept-package-agreements --silent | Out-Null } catch {} }
                Write-Host "Kit instalado!" -ForegroundColor Green; Pause-MR 
            }
            "2" { 
                Show-Header
                Write-Host "=== BACKUP FORENSE E PREVENTIVO ===" -ForegroundColor Magenta
                $dest = "$env:USERPROFILE\Desktop\Backup_Forense_$env:COMPUTERNAME"
                Write-Host "Criando estrutura de cofres em $dest..." -ForegroundColor Yellow
                
                try { 
                    $null = New-Item -Path "$dest\Drivers_Originais" -ItemType Directory -Force
                    $null = New-Item -Path "$dest\Rede_e_WiFi" -ItemType Directory -Force
                    $null = New-Item -Path "$dest\Registro_Sistema" -ItemType Directory -Force
                } catch {}

                Write-Host "[1/4] Extraindo todos os Drivers de Terceiros (Pode demorar)..." -ForegroundColor Cyan
                try { Export-WindowsDriver -Online -Destination "$dest\Drivers_Originais" -ErrorAction SilentlyContinue | Out-Null } catch {}

                Write-Host "[2/4] Exportando senhas em texto limpo e perfis de Wi-Fi (XML)..." -ForegroundColor Cyan
                try { netsh wlan export profile key=clear folder="$dest\Rede_e_WiFi" | Out-Null } catch {}

                Write-Host "[3/4] Clonando chaves vitais do Registro (SYSTEM e SOFTWARE)..." -ForegroundColor Cyan
                try { 
                    reg export HKLM\System "$dest\Registro_Sistema\HKLM_System.reg" /y | Out-Null
                    reg export HKLM\Software "$dest\Registro_Sistema\HKLM_Software.reg" /y | Out-Null
                } catch {}

                Write-Host "[4/4] Salvando configuracoes de IP (DHCP/Estatico) e Tabela de Rotas..." -ForegroundColor Cyan
                try { 
                    ipconfig /all > "$dest\Rede_e_WiFi\IPConfig_Completo.txt"
                    route print > "$dest\Rede_e_WiFi\Rotas_Tabela.txt"
                    Get-NetAdapter -ErrorAction SilentlyContinue | Format-Table -AutoSize > "$dest\Rede_e_WiFi\Adaptadores.txt"
                } catch {}

                Write-Host "`nBackup Total concluido com sucesso! Salve a pasta num PenDrive." -ForegroundColor Green
                Pause-MR 
            }
            "3" { try { Start-Process cleanmgr.exe } catch {} }
            "4" { try { Start-Process "ms-settings:storage" } catch {} }
            "0" { return }
            default { Write-Host "Opcao invalida." -ForegroundColor Red; Pause-MR }
        }
    } while ($true)
}
# -----------------------------------------------------------------------------
# BLOCO 7: MODO TECNICO AVANCADO E CIBERSEGURANCA (COM AUTO-ROLLBACK)
# -----------------------------------------------------------------------------

function Invoke-AutoRollback {
    param([string]$FeatureName, [string]$RegKey = "", [switch]$BcdBackup)
    $rollbackDir = "$global:LogDir\Rollback_Backups"
    if (-not (Test-Path $rollbackDir)) { try { New-Item -ItemType Directory -Path $rollbackDir -Force | Out-Null } catch {} }
    
    $date = Get-Date -Format "yyyyMMdd_HHmmss"
    Write-Host "  [+] Criando Snapshot de Rollback (Seguranca: $FeatureName)..." -ForegroundColor DarkGray
    
    try {
        if ($RegKey -ne "") {
            $outFile = "$rollbackDir\RegBackup_$FeatureName`_$date.reg"
            & reg.exe export $RegKey $outFile /y 2>&1 | Out-Null
            Write-MRLog "Backup de Registro salvo em: $outFile" "ROLLBACK"
        }
        if ($BcdBackup) {
            $outFile = "$rollbackDir\BcdBackup_$FeatureName`_$date.bcd"
            & bcdedit.exe /export $outFile 2>&1 | Out-Null
            Write-MRLog "Backup de Boot BCD salvo em: $outFile" "ROLLBACK"
        }
    } catch { Write-Host "  [!] Aviso: Falha ao criar backup preventivo." -ForegroundColor Red }
}

function Run-NetworkRadarAPI {
    Show-Header
    Write-Host "=== RADAR DE ESPIONAGEM (THREAT INTELLIGENCE SCANNER) ===" -ForegroundColor Magenta
    Write-Host "Analisando conexoes ativas via ipinfo.io (HTTPS) com Cache Local...`n" -ForegroundColor Yellow
    
    try {
        $tcp = Get-NetTCPConnection -State Established -ErrorAction SilentlyContinue
        if (-not $tcp) {
            Write-Host "Nenhuma conexao externa capturada no NetStat." -ForegroundColor Green; Pause-MR; return
        }

        $externos = @()
        foreach ($c in $tcp) { 
            if ($c.RemoteAddress -notmatch "^(127\.|192\.168\.|10\.|172\.(1[6-9]|2[0-9]|3[0-1])\.|::1|0\.0\.0\.0)") { $externos += $c } 
        }
        $unicos = $externos | Select-Object RemoteAddress, OwningProcess -Unique
        
        if (-not $unicos) {
            Write-Host "PC Limpo. Nenhuma rota externa desconhecida detectada." -ForegroundColor Green
        } else {
            if (-not $global:IPCache) { $global:IPCache = @{} }
            foreach ($conn in $unicos) {
                $ip = $conn.RemoteAddress; $procId = $conn.OwningProcess; $procName = "Kernel/Oculto"
                if ($procId -gt 0) { try { $p = Get-Process -Id $procId -ErrorAction SilentlyContinue; if ($p -ne $null) { $procName = $p.ProcessName } } catch {} }
                if ($global:IPCache.ContainsKey($ip)) { $geo = $global:IPCache[$ip] } 
                else { try { $geo = Invoke-RestMethod -Uri "https://ipinfo.io/$ip/json" -UseBasicParsing -TimeoutSec 3 -ErrorAction Stop; $global:IPCache[$ip] = $geo } catch { $geo = $null } }
                
                if ($geo -ne $null) {
                    $country = if ($geo.country) { $geo.country } else { "???" }; $org = if ($geo.org) { $geo.org } else { "ASN Desconhecido" }
                    $isRisk = ($country -match "RU|CN|IR|KP") -or ($org -match "Hetzner|DigitalOcean|Tor|VPN|Proxy")
                    if ($isRisk) { Write-Host "[ALERTA: $procName (PID: $procId)] ---> $ip ($country) | Org: $org" -ForegroundColor Red } 
                    else { Write-Host "[Seguro: $procName] ---> $ip ($country) | Org: $org" -ForegroundColor Cyan }
                } else { Write-Host "[$procName] ---> $ip (Protegido ou IP Reservado)" -ForegroundColor DarkGray }
                Start-Sleep -Milliseconds 100 
            }
        }
    } catch { Write-Host "Erro ao varrer conexoes. Detalhe: $($_.Exception.Message)" -ForegroundColor Red }
    Pause-MR
}

function Run-EDRAnalysis {
    Show-Header
    Write-Host "=== ANALISE EDR EM NUVEM (INTEGRACAO VIRUSTOTAL) ===" -ForegroundColor Red
    Write-Host "Periciando executaveis invisiveis hospedados no AppData e ProgramData...`n" -ForegroundColor Yellow
    try {
        $suspectProcs = Get-Process -ErrorAction SilentlyContinue | Where-Object { $_.Path -match "AppData|Temp|ProgramData" } | Select-Object -Property Path -Unique
        if (-not $suspectProcs) { Write-Host "Executaveis verificados. Nenhum comportamento suspeito." -ForegroundColor Green } 
        else {
            $urlsToOpen = @()
            foreach ($proc in $suspectProcs) {
                try {
                    $hash = (Get-FileHash -Path $proc.Path -Algorithm SHA256 -ErrorAction Stop).Hash
                    Write-Host "Alvo Forense: $([System.IO.Path]::GetFileName($proc.Path))" -ForegroundColor Red
                    Write-Host "Caminho Absoluto: $($proc.Path)`nAssinatura Genetica: $hash`n" -ForegroundColor DarkGray
                    $urlsToOpen += "https://www.virustotal.com/gui/file/$hash"
                } catch {}
            }
            if ($urlsToOpen.Count -gt 0) {
                $abrir = Read-Host "Validar nas 70 Databases do VirusTotal online? (S/N)"
                if ($abrir -match "^[sS]") { foreach ($u in $urlsToOpen) { try { Start-Process $u } catch {}; Start-Sleep -Milliseconds 500 } }
            }
        }
    } catch {}
    Pause-MR
}

function Run-LocalSecurityAudit {
    Show-Header
    Write-Host "=== AUDITORIA DE SEGURANCA LOCAL E VULNERABILIDADES ===" -ForegroundColor Red
    Write-Host "Inspecionando politicas de seguranca e brechas do sistema operacional...`n" -ForegroundColor Yellow
    try { $smb = Get-WindowsOptionalFeature -Online -FeatureName SMB1Protocol -ErrorAction SilentlyContinue; if ($smb.State -eq "Enabled") { Write-Host "[!] ALERTA CRITICO: Protocolo SMBv1 esta ATIVADO." -ForegroundColor Red } else { Write-Host "[OK] SMBv1 esta Desativado." -ForegroundColor Green } } catch {}
    try { $ps2 = Get-WindowsOptionalFeature -Online -FeatureName MicrosoftWindowsPowerShellV2 -ErrorAction SilentlyContinue; if ($ps2.State -eq "Enabled") { Write-Host "[!] ALERTA: PowerShell v2 esta ATIVADO (Permite evasao de EDR/Antivirus)." -ForegroundColor Red } else { Write-Host "[OK] PowerShell v2 esta Desativado." -ForegroundColor Green } } catch {}
    try { $rdp = (Get-ItemProperty "HKLM:\System\CurrentControlSet\Control\Terminal Server").fDenyTSConnections; if ($rdp -eq 0) { Write-Host "[?] AVISO: Area de Trabalho Remota (RDP) esta ATIVA. Verifique exposicao." -ForegroundColor Yellow } else { Write-Host "[OK] RDP esta Bloqueado localmente." -ForegroundColor Green } } catch {}
    try { $uac = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System").EnableLUA; if ($uac -eq 0) { Write-Host "[!] CRITICO: UAC esta DESLIGADO. Malwares rodam com privilegios." -ForegroundColor Red } else { Write-Host "[OK] UAC (Controle de Conta de Usuario) esta Ativo." -ForegroundColor Green } } catch {}
    Write-Host "`n[+] Contas com Privilegios de Administrador Local:" -ForegroundColor Cyan
    try { $admins = Get-LocalGroupMember -SID "S-1-5-32-544" -ErrorAction SilentlyContinue; foreach ($a in $admins) { Write-Host "  -> $($a.Name) ($($a.ObjectClass))" -ForegroundColor DarkGray } } catch {}
    Pause-MR
}

function Run-PersistenceCheck {
    Show-Header
    Write-Host "=== VERIFICACAO DE PERSISTENCIA (FORENSE LEVE) ===" -ForegroundColor Red
    Write-Host "Rastreando mecanismos de auto-inicializacao usados por malwares...`n" -ForegroundColor Yellow
    Write-Host "[+] Entradas de Inicializacao (Registro HKLM):" -ForegroundColor Cyan
    try { $hklm = Get-ItemProperty "HKLM:\Software\Microsoft\Windows\CurrentVersion\Run" -ErrorAction SilentlyContinue; $props = $hklm.PSObject.Properties | Where-Object { $_.Name -notmatch "PSPath|PSParentPath|PSChildName|PSDrive|PSProvider" }; if ($props) { foreach ($p in $props) { Write-Host "  -> $($p.Name): $($p.Value)" -ForegroundColor DarkGray } } else { Write-Host "  -> Nenhuma entrada." -ForegroundColor Green } } catch {}
    Write-Host "`n[+] Entradas de Inicializacao (Registro HKCU):" -ForegroundColor Cyan
    try { $hkcu = Get-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run" -ErrorAction SilentlyContinue; $props = $hkcu.PSObject.Properties | Where-Object { $_.Name -notmatch "PSPath|PSParentPath|PSChildName|PSDrive|PSProvider" }; if ($props) { foreach ($p in $props) { Write-Host "  -> $($p.Name): $($p.Value)" -ForegroundColor DarkGray } } else { Write-Host "  -> Nenhuma entrada." -ForegroundColor Green } } catch {}
    Write-Host "`n[+] Tarefas Agendadas Suspeitas:" -ForegroundColor Cyan
    try { $tasks = Get-ScheduledTask -ErrorAction SilentlyContinue | Where-Object { $_.Author -notmatch "Microsoft" -and ($_.State -eq "Ready" -or $_.State -eq "Running") }; if ($tasks) { foreach ($t in $tasks) { Write-Host "  -> [$($t.State)] $($t.TaskName) (Autor: $($t.Author))" -ForegroundColor Yellow } } else { Write-Host "  -> Nenhuma tarefa suspeita." -ForegroundColor Green } } catch {}
    Write-Host "`n[+] Pastas de Inicializacao (Startup):" -ForegroundColor Cyan
    try { $startupAll = Get-ChildItem "$env:ALLUSERSPROFILE\Microsoft\Windows\Start Menu\Programs\Startup" -ErrorAction SilentlyContinue; $startupUser = Get-ChildItem "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup" -ErrorAction SilentlyContinue; foreach ($f in $startupAll) { Write-Host "  -> [Global] $($f.Name)" -ForegroundColor DarkGray }; foreach ($f in $startupUser) { Write-Host "  -> [Local]  $($f.Name)" -ForegroundColor DarkGray } } catch {}
    Pause-MR
}

function Run-NetworkDeepScan {
    Show-Header
    Write-Host "=== NETWORK DEEP SCAN (AUDITORIA DE INFRAESTRUTURA) ===" -ForegroundColor Red
    Write-Host "Inspecionando portas abertas, rotas e túneis de rede...`n" -ForegroundColor Yellow

    Write-Host "[+] Portas Locais Escutando (Listening - Possiveis Backdoors):" -ForegroundColor Cyan
    try {
        $ports = Get-NetTCPConnection -State Listen -ErrorAction SilentlyContinue | Select-Object LocalAddress, LocalPort, OwningProcess | Sort-Object LocalPort -Unique
        foreach ($p in $ports) {
            $procName = "Desconhecido"
            if ($p.OwningProcess -gt 0) {
                $proc = Get-Process -Id $p.OwningProcess -ErrorAction SilentlyContinue
                if ($proc) { $procName = $proc.ProcessName }
            }
            Write-Host "  -> Porta: $($p.LocalPort) | IP: $($p.LocalAddress) | Processo: $procName (PID: $($p.OwningProcess))" -ForegroundColor DarkGray
        }
    } catch { Write-Host "  -> Erro ao ler portas locais." -ForegroundColor Red }

    Write-Host "`n[+] Analise de Proxy no Sistema:" -ForegroundColor Cyan
    try {
        $proxy = Get-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings" -ErrorAction SilentlyContinue
        if ($proxy.ProxyEnable -eq 1) { Write-Host "  -> [!] ALERTA: Servidor Proxy ATIVADO ($($proxy.ProxyServer))" -ForegroundColor Red }
        else { Write-Host "  -> [OK] Nenhum Proxy local ativo." -ForegroundColor Green }
    } catch {}

    Write-Host "`n[+] Deteccao de VPNs e Interfaces Virtuais (Tunnels):" -ForegroundColor Cyan
    try {
        $vpns = Get-NetAdapter | Where-Object { $_.InterfaceDescription -match "VPN|TAP|TUN|WireGuard|OpenVPN|Cisco" -and $_.Status -eq "Up" }
        if ($vpns) {
            foreach ($v in $vpns) { Write-Host "  -> [!] VPN ATIVA: $($v.InterfaceDescription)" -ForegroundColor Yellow }
        } else { Write-Host "  -> [OK] Nenhuma VPN/Túnel virtual detectado ativo." -ForegroundColor Green }
    } catch {}

    Pause-MR
}

function Run-SystemIntegrityScan {
    Show-Header
    Write-Host "=== ANALISADOR DE INTEGRIDADE DO SISTEMA (CORE HASHES) ===" -ForegroundColor Red
    Write-Host "Verificando assinaturas digitais dos nucleos criticos do Windows...`n" -ForegroundColor Yellow

    # Lista de arquivos vitais que virus adoram sequestrar/substituir
    $coreFiles = @(
        "$env:WINDIR\System32\cmd.exe",
        "$env:WINDIR\explorer.exe",
        "$env:WINDIR\System32\lsass.exe",
        "$env:WINDIR\System32\winlogon.exe",
        "$env:WINDIR\System32\svchost.exe",
        "$env:WINDIR\System32\taskmgr.exe"
    )

    foreach ($file in $coreFiles) {
        if (Test-Path $file) {
            try {
                $sig = Get-AuthenticodeSignature -FilePath $file -ErrorAction SilentlyContinue
                if ($sig.Status -eq "Valid") {
                    Write-Host "[OK] Original   -> $(Split-Path $file -Leaf)" -ForegroundColor Green -NoNewline
                    Write-Host " (Assinado: $($sig.SignerCertificate.Subject))" -ForegroundColor DarkGray
                } else {
                    Write-Host "[!] CORROMPIDO -> $(Split-Path $file -Leaf)" -ForegroundColor Red -NoNewline
                    Write-Host " (Assinatura Invalida ou Modificada: $($sig.StatusMessage))" -ForegroundColor Yellow
                }
            } catch {
                Write-Host "[?] Falha ao ler -> $(Split-Path $file -Leaf)" -ForegroundColor DarkGray
            }
        } else {
            Write-Host "[X] DESAPARECIDO -> $(Split-Path $file -Leaf)" -ForegroundColor Red
        }
        Start-Sleep -Milliseconds 200
    }
    
    Write-Host "`n* Nota: Arquivos corrompidos indicam possivel infeccao Rootkit ou dano grave no SO." -ForegroundColor Yellow
    Pause-MR
}

function Run-GodModeUnbrick {
    Show-Header
    Write-Host "=== GOD MODE UNBRICK (SALVA-VIDAS DE SISTEMA) ===" -ForegroundColor Green
    
    # ROLLBACK AUTOMATICO ANTES DE ALTERAR!
    Invoke-AutoRollback -FeatureName "Policies_System_HKLM" -RegKey "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
    Invoke-AutoRollback -FeatureName "Policies_System_HKCU" -RegKey "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System"

    Write-Host "Estourando cadeados de malware e GPOs corrompidas..." -ForegroundColor Yellow
    $keys = @("HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\System", "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System", "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer")
    foreach ($k in $keys) {
        try { if (-not (Test-Path $k)) { New-Item -Path $k -Force -ErrorAction SilentlyContinue | Out-Null } } catch {}
        try { Set-ItemProperty -Path $k -Name "DisableTaskMgr" -Value 0 -ErrorAction SilentlyContinue; Set-ItemProperty -Path $k -Name "DisableRegistryTools" -Value 0 -ErrorAction SilentlyContinue; Set-ItemProperty -Path $k -Name "DisableCMD" -Value 0 -ErrorAction SilentlyContinue; Set-ItemProperty -Path $k -Name "NoFolderOptions" -Value 0 -ErrorAction SilentlyContinue } catch {}
    }
    try { Remove-Item "$env:windir\System32\GroupPolicy" -Recurse -Force -ErrorAction SilentlyContinue; gpupdate /force | Out-Null } catch {}
    Write-Host "Paineis administrativos desalgemados!" -ForegroundColor Green; Pause-MR
}

function Open-TechMenu {
    do {
        Show-Header
        Write-Host "=== MODO TECNICO AVANCADO (DANGER ZONE & SOC) ===" -ForegroundColor Red
        Write-Host ""
        
        Write-Host " --- FORENSE E CIBERSEGURANCA (ELITE) ---" -ForegroundColor DarkGray
        Write-Host " [1] RADAR DE ESPIONAGEM          " -ForegroundColor Magenta -NoNewline
        Write-Host "[VIRUS] " -ForegroundColor Red -NoNewline
        Write-Host "- Analisa conexoes ao vivo via API (ipinfo.io)" -ForegroundColor Gray
        
        Write-Host " [2] ANALISE EDR (VIRUSTOTAL)     " -ForegroundColor Magenta -NoNewline
        Write-Host "[VIRUS] " -ForegroundColor Red -NoNewline
        Write-Host "- Calcula Hash de AppData contra 70 motores" -ForegroundColor Gray
        
        Write-Host " [3] AUDITORIA DE SEGURANCA LOC.  " -ForegroundColor Magenta -NoNewline
        Write-Host "[SOC]   " -ForegroundColor Red -NoNewline
        Write-Host "- Checa vulnerabilidades: SMBv1, RDP e UAC" -ForegroundColor Gray
        
        Write-Host " [4] VERIFICAR PERSISTENCIA       " -ForegroundColor Magenta -NoNewline
        Write-Host "[SOC]   " -ForegroundColor Red -NoNewline
        Write-Host "- Lista Tarefas e arquivos Startups suspeitos" -ForegroundColor Gray
        
        Write-Host " [5] NETWORK DEEP SCAN            " -ForegroundColor Magenta -NoNewline
        Write-Host "[SOC]   " -ForegroundColor Red -NoNewline
        Write-Host "- Inspeciona portas escutando, proxys e VPNs" -ForegroundColor Gray
        
        Write-Host " [6] INTEGRIDADE DO SISTEMA       " -ForegroundColor Magenta -NoNewline
        Write-Host "[SOC]   " -ForegroundColor Red -NoNewline
        Write-Host "- Analisa assinaturas digitais de DLLs e EXEs vitais" -ForegroundColor Gray
        
        Write-Host " [7] GOD MODE UNBRICK (REGISTRO)  " -ForegroundColor Green -NoNewline
        Write-Host "[VIRUS] " -ForegroundColor Red -NoNewline
        Write-Host "- Destrava Regedit e CMD bloqueados por malware" -ForegroundColor Gray
        
        Write-Host " [8] PROTOCOLO DESINFECCAO NUCLEAR" -ForegroundColor Red -NoNewline
        Write-Host "[VIRUS] " -ForegroundColor Red -NoNewline
        Write-Host "- Corta malwares ocultos e abre Defender Offline" -ForegroundColor Gray
        
        Write-Host " [9] DECRAPIFIER (BLOATWARE)      " -ForegroundColor Red -NoNewline
        Write-Host "[VIRUS] " -ForegroundColor Red -NoNewline
        Write-Host "- Exclui McAfee, TikTok, Norton e patrocinados" -ForegroundColor Gray
        
        Write-Host " --- HARDENING E TWEAKS ---" -ForegroundColor DarkGray
        Write-Host " [10] DESATIVAR TELEMETRIA        " -ForegroundColor Cyan -NoNewline
        Write-Host "[TWEAK] " -ForegroundColor DarkYellow -NoNewline
        Write-Host "- Corta coleta de dados da Microsoft" -ForegroundColor Gray
        
        Write-Host " [11] DESATIVAR VBS (VIRTUALIZACAO)" -ForegroundColor Cyan -NoNewline
        Write-Host "[TWEAK] " -ForegroundColor DarkYellow -NoNewline
        Write-Host "- Desliga camada de seguranca para ganhar FPS" -ForegroundColor Gray
        
        Write-Host " [12] RESETAR REDE WINSOCK        " -ForegroundColor Cyan -NoNewline
        Write-Host "[TWEAK] " -ForegroundColor DarkYellow -NoNewline
        Write-Host "- Refaz as tabelas TCP/IP de adaptadores mortos" -ForegroundColor Gray
        
        Write-Host "`n [0] VOLTAR                       " -ForegroundColor Yellow -NoNewline
        Write-Host "[---]   " -ForegroundColor DarkGray -NoNewline
        Write-Host "- Retornar ao Menu Inicial" -ForegroundColor Gray
        Write-Host ""

        $opt = Read-Host "Escolha uma opcao"
        switch ($opt) {
            "1" { Run-NetworkRadarAPI }
            "2" { Run-EDRAnalysis }
            "3" { Run-LocalSecurityAudit }
            "4" { Run-PersistenceCheck }
            "5" { Run-NetworkDeepScan }
            "6" { Run-SystemIntegrityScan }
            "7" { Run-GodModeUnbrick }
            "8" {
                Write-Host "Derrubando Proxy..." -ForegroundColor Yellow
                try { Remove-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings" -Name "ProxyServer" -Force -ErrorAction SilentlyContinue } catch {}
                try { Get-Process | Where-Object { $_.Path -match "AppData|Temp" } | Stop-Process -Force -ErrorAction SilentlyContinue } catch {}
                $r = Read-Host "Agendar varredura do Defender Offline no proximo Boot e reiniciar? (S/N)"
                if ($r -match "^[sS]") { try { Start-MpWDOScan } catch {} }
                Pause-MR
            }
            "9" {
                Write-Host "Cacando Bloatware..." -ForegroundColor Yellow
                $bloat = @("*CandyCrush*", "*TikTok*", "*McAfee*", "*Norton*")
                foreach ($app in $bloat) { try { Get-AppxPackage -Name $app -AllUsers -ErrorAction SilentlyContinue | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue } catch {} }
                Write-Host "Concluido." -ForegroundColor Green; Pause-MR
            }
            "10" { try { Stop-Service DiagTrack -Force -ErrorAction SilentlyContinue; Set-Service DiagTrack -StartupType Disabled -ErrorAction SilentlyContinue; Write-Host "Telemetria Desativada." -ForegroundColor Green } catch {}; Pause-MR }
            "11" { try { bcdedit /set hypervisorlaunchtype off | Out-Null; Write-Host "VBS Off. Reinicie." -ForegroundColor Green } catch {}; Pause-MR }
            "12" { try { netsh winsock reset | Out-Null; ipconfig /flushdns | Out-Null; Write-Host "Rede recriada." -ForegroundColor Green } catch {}; Pause-MR }
            "0" { return }
            default { Write-Host "Opcao invalida." -ForegroundColor Red; Pause-MR }
        }
    } while ($true)
}
# -----------------------------------------------------------------------------
# BLOCOS 8 E 9: RESTORE E SUPORTE
# -----------------------------------------------------------------------------
function Open-RestoreMenu {
    do {
        Show-Header
        Write-Host "=== RESTAURAR PADROES (DESFAZER) ===" -ForegroundColor Green
        Write-Host ""
        Write-Host " [1] DESTRAVAR EXPLORER E BARRA   " -ForegroundColor Cyan -NoNewline
        Write-Host "[UNDO]    " -ForegroundColor Green -NoNewline
        Write-Host "- Reinicia a UI se a tela ficar preta" -ForegroundColor Gray
        Write-Host " [2] CONSERTAR MENU INICIAR QUEB. " -ForegroundColor Cyan -NoNewline
        Write-Host "[UNDO]    " -ForegroundColor Green -NoNewline
        Write-Host "- Forca reinstalacao dos pacotes (AppX)" -ForegroundColor Gray
        Write-Host " [3] REVERTER MENU DE CONTEXTO    " -ForegroundColor Cyan -NoNewline
        Write-Host "[UNDO]    " -ForegroundColor Green -NoNewline
        Write-Host "- Volta ao Clique Direito do Win11" -ForegroundColor Gray
        Write-Host " [4] RESETAR WINDOWS DEFENDER     " -ForegroundColor Cyan -NoNewline
        Write-Host "[UNDO]    " -ForegroundColor Green -NoNewline
        Write-Host "- Volta as configuracoes nativas" -ForegroundColor Gray
        Write-Host "`n [0] VOLTAR                       " -ForegroundColor Yellow -NoNewline
        Write-Host "[---]     " -ForegroundColor DarkGray -NoNewline
        Write-Host "- Retornar ao Menu Inicial" -ForegroundColor Gray
        Write-Host ""

        $opt = Read-Host "Escolha uma opcao"
        switch ($opt) {
            "1" { try { Stop-Process -Name explorer -Force -ErrorAction SilentlyContinue; Start-Process explorer.exe; Write-Host "Reiniciado." -ForegroundColor Green } catch {}; Pause-MR }
            "2" { Write-Host "Aguarde..."; try { Get-AppXPackage -AllUsers | Foreach {Add-AppxPackage -DisableDevelopmentMode -Register "$($_.InstallLocation)\AppXManifest.xml" -ErrorAction SilentlyContinue}; Write-Host "Reparado." -ForegroundColor Green } catch {}; Pause-MR }
            "3" { try { Remove-Item -Path "HKCU:\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}" -Recurse -Force -ErrorAction SilentlyContinue; Write-Host "Menu revertido." -ForegroundColor Green } catch {}; Pause-MR }
            "4" { try { & "C:\Program Files\Windows Defender\MpCmdRun.exe" -RestoreDefaults; Write-Host "Defender resetado." -ForegroundColor Green } catch {}; Pause-MR }
            "0" { return }
            default { Write-Host "Opcao invalida." -ForegroundColor Red; Pause-MR }
        }
    } while ($true)
}

function Open-SupportMenu {
    do {
        Show-Header
        Write-Host "=== SUPORTE REMOTO (ACESSO IMEDIATO) ===" -ForegroundColor Blue
        Write-Host ""
        Write-Host " [1] BAIXAR E ABRIR ANYDESK       " -ForegroundColor Cyan -NoNewline
        Write-Host "[SUPORTE] " -ForegroundColor Blue -NoNewline
        Write-Host "- Download oficial direto como Admin" -ForegroundColor Gray
        Write-Host " [2] BAIXAR E ABRIR RUSTDESK      " -ForegroundColor Cyan -NoNewline
        Write-Host "[SUPORTE] " -ForegroundColor Blue -NoNewline
        Write-Host "- Alternativa livre sem limitador de tempo" -ForegroundColor Gray
        Write-Host "`n [0] VOLTAR                       " -ForegroundColor Yellow -NoNewline
        Write-Host "[---]     " -ForegroundColor DarkGray -NoNewline
        Write-Host "- Retornar ao Menu Inicial" -ForegroundColor Gray
        Write-Host ""

        $opt = Read-Host "Escolha uma opcao"
        switch ($opt) {
            "1" { try { Invoke-WebRequest -Uri "https://download.anydesk.com/AnyDesk.exe" -OutFile "$env:USERPROFILE\Desktop\AnyDesk.exe" -UseBasicParsing; Start-Process "$env:USERPROFILE\Desktop\AnyDesk.exe"; Write-Host "Aberto!" -ForegroundColor Green } catch {}; Pause-MR }
            "2" { try { winget install RustDesk.RustDesk --silent --accept-source-agreements --accept-package-agreements | Out-Null; Write-Host "RustDesk Instalado!" -ForegroundColor Green } catch {}; Pause-MR }
            "0" { return }
            default { Write-Host "Opcao invalida." -ForegroundColor Red; Pause-MR }
        }
    } while ($true)
}

# -----------------------------------------------------------------------------
# BLOCO 10: RECUPERACAO OFFLINE (A SOLUCAO DO ERRO FATAL "$drv")
# -----------------------------------------------------------------------------
function Open-RecoveryMenu {
    do {
        Show-Header
        Write-Host "=== MODO RECUPERACAO OFFLINE (BOOT / WINPE) ===" -ForegroundColor DarkYellow
        Write-Host " NOTA: Ferramentas para rodar do Pendrive de Instalacao (Shift+F10)`n" -ForegroundColor DarkGray
        
        Write-Host " [1] Verificar particoes e discos (Diskpart list volume)" -ForegroundColor Cyan
        Write-Host " [2] Verificar integridade do sistema (SFC /offbootdir)" -ForegroundColor Cyan
        Write-Host " [3] Reparar Boot (Bootrec /fixmbr, /fixboot, /rebuildbcd)" -ForegroundColor Cyan
        Write-Host " [4] Verificar erros no disco (CHKDSK /f /r)" -ForegroundColor Cyan
        Write-Host " [5] Desativar Conta Administrador (Bypass utilman.exe)" -ForegroundColor Red
        Write-Host " [6] Backup Automatico de Usuarios (Robocopy offline)" -ForegroundColor Cyan
        Write-Host " [7] Detectar Criptografia BitLocker" -ForegroundColor Cyan
        Write-Host " [8] Restaurar BCD (Bcdboot)" -ForegroundColor Cyan
        Write-Host " [9] Reparar apontamento do Winload" -ForegroundColor Cyan
        Write-Host " [10] Diagnostico de falha de inicializacao (Ler SrtTrail.txt)" -ForegroundColor Cyan
        
        Write-Host "`n [0] Voltar ao menu principal" -ForegroundColor Yellow
        Write-Host ""

        $opt = Read-Host "Escolha uma opcao"
        switch ($opt) {
            "1" { "echo list volume | diskpart" | cmd; Pause-MR }
            "2" { 
                $drv = Read-Host "Digite a letra da unidade onde o Windows esta instalado (ex: C ou D)"
                if ($drv) { try { sfc /scannow "/offbootdir=$($drv):\" "/offwindir=$($drv):\Windows" } catch {} }
                Pause-MR 
            }
            "3" { try { bootrec /fixmbr; bootrec /fixboot; bootrec /rebuildbcd; Write-Host "Comandos MBR enviados." -ForegroundColor Green } catch {}; Pause-MR }
            "4" { 
                $drv = Read-Host "Digite a letra da unidade (ex: C)"
                if ($drv) { try { chkdsk "$($drv):" /f /r } catch {} }
                Pause-MR 
            }
            "5" { 
                $drv = Read-Host "Letra do Windows (ex: C ou D)"
                if ($drv) { 
                    try { 
                        Rename-Item "$($drv):\Windows\System32\utilman.exe" "utilman.exe.bak" -Force -ErrorAction Stop
                        Copy-Item "$($drv):\Windows\System32\cmd.exe" "$($drv):\Windows\System32\utilman.exe" -Force -ErrorAction Stop
                        Write-Host "Bypass Injetado com Sucesso! Reinicie e clique na acessibilidade." -ForegroundColor Green 
                    } catch { Write-Host "Erro. Unidade bloqueada." -ForegroundColor Red } 
                }
                Pause-MR 
            }
            "6" { Write-Host "Comando sugerido ignorando NTFS:`nrobocopy C:\Users E:\Backup /E /ZB /R:1 /W:1" -ForegroundColor Cyan; Pause-MR }
            "7" { 
                $drv = Read-Host "Letra da unidade (ex: C)"
                if ($drv) { try { manage-bde -status "$($drv):" } catch {} }
                Pause-MR 
            }
            "8" { 
                $drv = Read-Host "Letra do Windows (ex: C)"
                if ($drv) { try { bcdboot "$($drv):\Windows" /l pt-BR; Write-Host "Copiado." -ForegroundColor Green } catch {} }
                Pause-MR 
            }
            "9" { 
                $drv = Read-Host "Letra do Windows (ex: C)"
                if ($drv) { try { bcdedit /set "{default}" device partition="$($drv):"; bcdedit /set "{default}" osdevice partition="$($drv):"; Write-Host "Corrigido." -ForegroundColor Green } catch {} }
                Pause-MR 
            }
            "10"{ 
                $drv = Read-Host "Letra do Windows que deu Tela Azul (ex: C)"
                if ($drv) { 
                    $log = "$($drv):\Windows\System32\LogFiles\Srt\SrtTrail.txt"
                    if (Test-Path $log) { 
                        Write-Host "`nLendo ultimas linhas do relatorio..." -ForegroundColor Yellow
                        Get-Content $log -Tail 20 
                    } else { Write-Host "SrtTrail nao gerado." -ForegroundColor Red } 
                }
                Pause-MR 
            }
            "0" { return }
            default { Write-Host "Opcao invalida." -ForegroundColor Red; Pause-MR }
        }
    } while($true)
}
function Open-LanguageMenu {
    do {
        Show-Header
        Write-Host "=== MUDAR IDIOMA / CHANGE LANGUAGE ===" -ForegroundColor Cyan
        Write-Host ""
        
        Write-Host " [1] PORTUGUÊS (BR) " -ForegroundColor Green -NoNewline
        Write-Host "- Idioma Nativo Atual" -ForegroundColor Gray
        
        Write-Host " [2] ENGLISH (USA)  " -ForegroundColor DarkGray -NoNewline
        Write-Host "- Coming Soon (Roadmap)" -ForegroundColor Gray
        
        Write-Host " [3] ESPAÑOL (ES)   " -ForegroundColor DarkGray -NoNewline
        Write-Host "- Próximamente (Roadmap)" -ForegroundColor Gray
        
        Write-Host "`n [0] VOLTAR         " -ForegroundColor Yellow -NoNewline
        Write-Host "- Retornar ao Menu Inicial" -ForegroundColor Gray
        Write-Host ""

        $opt = Read-Host "Escolha uma opcao / Choose an option"
        switch ($opt) {
            "1" { 
                Write-Host "`n[OK] O sistema ja esta configurado para o idioma padrao: Portugues (BR)." -ForegroundColor Green
                Pause-MR 
            }
            "2" { 
                Write-Host "`n[ROADMAP] A traducao nativa para o Ingles (USA) esta em desenvolvimento e sera lancada exclusivamente na atualizacao v3.0 Global." -ForegroundColor Yellow
                Write-Host "The native English translation is under development and will be released in the v3.0 Global update." -ForegroundColor Cyan
                Pause-MR 
            }
            "3" { 
                Write-Host "`n[ROADMAP] A traducao nativa para o Espanhol esta em desarrollo e sera lancada exclusivamente na atualizacao v3.0 Global." -ForegroundColor Yellow
                Write-Host "La traduccion nativa al espanol esta en desarrollo y se lanzara en la actualizacion v3.0 Global." -ForegroundColor Cyan
                Pause-MR 
            }
            "0" { return }
            default { Write-Host "Opcao invalida / Invalid option." -ForegroundColor Red; Pause-MR }
        }
    } while ($true)
}

# -----------------------------------------------------------------------------
# O GRANDE MOTOR DE LOOP PRINCIPAL (BLINDADO E PROTEGIDO - v2.0 Elite)
# -----------------------------------------------------------------------------
do {
    Show-MainMenu
    $choice = Read-Host "Digite o numero da opcao desejada"

    switch ($choice) {
        "1" { Open-OptimizeMenu }
        "2" { Open-ActivatorMenu }
        "3" { Open-GamerMenu }
        "4" { Open-SystemToolsMenu }
        "5" { Open-DiagnosticsMenu }
        "6" { Open-ExtrasMenu }
        "7" { 
            Write-Host "`n[!] ACESSO RESTRITO: AREA DE RISCO E MANIPULACAO DE KERNEL" -ForegroundColor Red
            # O parametro -AsSecureString esconde o que voce digita (aparecem asteriscos)
            $pin = Read-Host "Digite a credencial de Engenheiro SOC (Padrao: mrevan)" -AsSecureString
            $pinPlain = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($pin))
            
            if ($pinPlain -eq "mrevan") {
                Write-Host "Autenticacao validada. Bem-vindo ao SOC." -ForegroundColor Green
                try { Write-MRLog "Acesso ao Modo Tecnico Concedido" "AUTH" } catch {}
                Start-Sleep -Milliseconds 600
                Open-TechMenu 
            } else {
                Write-Host "Acesso Negado. Credencial Invalida." -ForegroundColor Red
                try { Write-MRLog "Falha de autenticacao no Modo Tecnico" "AUTH_FAIL" } catch {}
                Start-Sleep -Seconds 2
            }
        }
        "8" { Open-RestoreMenu }
        "9" { Open-SupportMenu }
        "10"{ Open-RecoveryMenu }
        "11"{ Open-LanguageMenu }
        "0" {
            Write-Host "`nObrigado por utilizar o Mr Evan Intelligent Repair System v2.0 Elite!" -ForegroundColor Cyan
            Write-Host "O Terminal sera encerrado com seguranca..." -ForegroundColor DarkGray
            Start-Sleep -Seconds 2
            exit
        }
        default { 
            Write-Host "Opcao Invalida! Por favor, insira um numero valido da lista." -ForegroundColor Red
            Start-Sleep -Seconds 1 
        }
    }
} while ($true)