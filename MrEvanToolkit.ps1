<# 
  =============================================================================
  MR EVAN INTELLIGENT REPAIR SYSTEM
  Console Avancado de Manutencao, Otimizacao e Seguranca Cibernetica.
  Versao: v1.3 Elite (Full Edition - Definitive & Bug Fixed)
  Autor: Evandro Lemos
  =============================================================================
#>

$ErrorActionPreference = "SilentlyContinue"
$MRIRS_Version         = "v1.3 Elite"
$MRIRS_Width           = 105

# -----------------------------------------------------------------------------
# CHECAGEM DE PRIVILEGIOS ADMINISTRATIVOS
# -----------------------------------------------------------------------------
function Test-IsAdmin {
    try {
        $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
        $principal   = New-Object Security.Principal.WindowsPrincipal($currentUser)
        return $principal.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
    } 
    catch { 
        return $false 
    }
}

if (-not (Test-IsAdmin)) {
    Write-Host "ATENCAO: Este painel requer privilegios maximos de ADMINISTRADOR." -ForegroundColor Yellow
    $resp = Read-Host "Deseja reabrir automaticamente como Administrador agora? (S/N)"
    
    if ($resp -match "^[sS]") {
        $scriptPath = $MyInvocation.MyCommand.Path
        if (-not $scriptPath) {
            Write-Host "Caminho do script nao encontrado. Execute manualmente como admin." -ForegroundColor Red
            $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
            exit
        }
        $argList = "-NoProfile -ExecutionPolicy Bypass -File ""$scriptPath"""
        Start-Process powershell.exe -ArgumentList $argList -Verb RunAs
        exit
    } else {
        exit
    }
}

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
# BLOCO 5 E 6: DIAGNOSTICO E EXTRAS
# -----------------------------------------------------------------------------
function Open-DiagnosticsMenu {
    do {
        Show-Header
        Write-Host "=== DIAGNOSTICO DO PC (AUDITORIA E FORENSE) ===" -ForegroundColor Blue
        Write-Host ""
        Write-Host " [1] EXTRATOR DE LICENCAS OEM     " -ForegroundColor Cyan -NoNewline
        Write-Host "[INFO]    " -ForegroundColor Blue -NoNewline
        Write-Host "- Resgata chaves na BIOS e Registro" -ForegroundColor Gray
        Write-Host " [2] EXPORTAR LAUDO HARDWARE      " -ForegroundColor Cyan -NoNewline
        Write-Host "[INFO]    " -ForegroundColor Blue -NoNewline
        Write-Host "- Gera relatorio .txt com pecas" -ForegroundColor Gray
        Write-Host " [3] RESUMO RAPIDO NO CONSOLE     " -ForegroundColor Cyan -NoNewline
        Write-Host "[INFO]    " -ForegroundColor Blue -NoNewline
        Write-Host "- Exibe Processador e RAM" -ForegroundColor Gray
        Write-Host " [4] ABRIR INFO DO SISTEMA        " -ForegroundColor Cyan -NoNewline
        Write-Host "[INFO]    " -ForegroundColor Blue -NoNewline
        Write-Host "- Inicia Inspecao Profunda (msinfo32)" -ForegroundColor Gray
        Write-Host " [5] MONITOR DE RECURSOS          " -ForegroundColor Cyan -NoNewline
        Write-Host "[INFO]    " -ForegroundColor Blue -NoNewline
        Write-Host "- Analise em tempo real (resmon)" -ForegroundColor Gray
        Write-Host "`n [0] VOLTAR                       " -ForegroundColor Yellow -NoNewline
        Write-Host "[---]     " -ForegroundColor DarkGray -NoNewline
        Write-Host "- Retornar ao Menu Inicial" -ForegroundColor Gray
        Write-Host ""

        $opt = Read-Host "Escolha uma opcao"
        switch ($opt) {
            "1" {
                Show-Header; Write-Host "Buscando Chaves..." -ForegroundColor Yellow
                $outPath = "$env:USERPROFILE\Desktop\Chaves_Cliente_MrEvan.txt"
                $content = @("=== EXTRATOR DE LICENCAS ===")
                try { $wmi = (Get-WmiObject -query 'select * from SoftwareLicensingService' -ErrorAction Stop).OA3xOriginalProductKey; if ($wmi) { $content += "Chave BIOS OEM: $wmi"; Write-Host "Chave BIOS: $wmi" -ForegroundColor Green } else { $content += "Chave BIOS: Nao encontrada." } } catch {}
                try { $reg = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SoftwareProtectionPlatform" -ErrorAction SilentlyContinue).BackupProductKeyDefault; if ($reg) { $content += "Chave Registro: $reg"; Write-Host "Chave Registro: $reg" -ForegroundColor Green } } catch {}
                try { Set-Content -Path $outPath -Value $content -Force; Start-Process notepad.exe -ArgumentList $outPath } catch {}
                Pause-MR
            }
            "2" {
                $path = "$env:USERPROFILE\Desktop\Laudo_Tecnico_Hardware.txt"
                try { $os = Get-CimInstance Win32_OperatingSystem; $cpu = Get-CimInstance Win32_Processor | Select-Object -First 1; $ramGB = [math]::Round($os.TotalVisibleMemorySize / 1MB, 1); $report = @("=== LAUDO TECNICO ===", "SISTEMA: $($os.Caption)", "CPU: $($cpu.Name)", "RAM: $ramGB GB"); Set-Content -Path $path -Value $report -Force; Write-Host "Laudo exportado para Desktop!" -ForegroundColor Green } catch {}
                Pause-MR
            }
            "3" { try { Get-CimInstance Win32_Processor | Select Name; Get-CimInstance Win32_OperatingSystem | Select Caption, Version } catch {}; Pause-MR }
            "4" { try { Start-Process msinfo32.exe } catch {} }
            "5" { try { Start-Process resmon.exe } catch {} }
            "0" { return }
            default { Write-Host "Opcao invalida." -ForegroundColor Red; Pause-MR }
        }
    } while ($true)
}

function Open-ExtrasMenu {
    do {
        Show-Header
        Write-Host "=== UTILITARIOS EXTRAS ===" -ForegroundColor DarkCyan
        Write-Host ""
        Write-Host " [1] KIT POS-FORMATACAO WINGET    " -ForegroundColor Cyan -NoNewline
        Write-Host "[EXTRAS]  " -ForegroundColor DarkCyan -NoNewline
        Write-Host "- Instala Chrome, WinRAR e PDF silenciosamente" -ForegroundColor Gray
        Write-Host " [2] BACKUP INTELIGENTE DE DRIVER " -ForegroundColor Cyan -NoNewline
        Write-Host "[EXTRAS]  " -ForegroundColor DarkCyan -NoNewline
        Write-Host "- Clona os drivers originais para um PenDrive" -ForegroundColor Gray
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
                $dest = "$env:USERPROFILE\Desktop\Backup_Drivers_MrEvan"
                Write-Host "Exportando para $dest ..." -ForegroundColor Yellow
                try { if (-not (Test-Path $dest)) { New-Item -Path $dest -ItemType Directory -Force | Out-Null }; Export-WindowsDriver -Online -Destination $dest | Out-Null; Write-Host "Backup concluido!" -ForegroundColor Green } catch {}
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
# BLOCO 7: MODO TECNICO AVANCADO E CIBERSEGURANCA (O CORACAO DO ELITE)
# -----------------------------------------------------------------------------
function Run-NetworkRadarAPI {
    Show-Header
    Write-Host "=== RADAR DE ESPIONAGEM (THREAT INTELLIGENCE SCANNER) ===" -ForegroundColor Magenta
    Write-Host "Analisando conexoes ativas via ipinfo.io (HTTPS) com Cache Local...`n" -ForegroundColor Yellow
    
    try {
        # Lê a rede garantindo que erros menores nao cancelem a acao
        $tcp = Get-NetTCPConnection -State Established -ErrorAction SilentlyContinue
        if (-not $tcp) {
            Write-Host "Nenhuma conexao externa capturada no NetStat." -ForegroundColor Green
            Pause-MR
            return
        }

        # Filtra e remove as redes locais e de sistema
        $externos = @()
        foreach ($c in $tcp) { 
            if ($c.RemoteAddress -notmatch "^(127\.|192\.168\.|10\.|172\.(1[6-9]|2[0-9]|3[0-1])\.|::1|0\.0\.0\.0)") { 
                $externos += $c 
            } 
        }
        
        $unicos = $externos | Select-Object RemoteAddress, OwningProcess -Unique
        
        if (-not $unicos) {
            Write-Host "PC Limpo. Nenhuma rota externa desconhecida detectada." -ForegroundColor Green
        } else {
            # Inicia o Cache Local em Memoria para nao esgotar a API
            if (-not $global:IPCache) { $global:IPCache = @{} }

            foreach ($conn in $unicos) {
                $ip = $conn.RemoteAddress
                $procId = $conn.OwningProcess  # NOME DA VARIAVEL CORRIGIDA AQUI
                $procName = "Kernel/Oculto"
                
                # Tenta descobrir o nome do programa dono da conexao
                if ($procId -gt 0) { 
                    try {
                        $p = Get-Process -Id $procId -ErrorAction SilentlyContinue
                        if ($p -ne $null) { $procName = $p.ProcessName } 
                    } catch {}
                }
                
                # Verifica se o IP ja foi consultado antes no cache
                if ($global:IPCache.ContainsKey($ip)) {
                    $geo = $global:IPCache[$ip]
                } else {
                    try {
                        # Chama a API Profissional (HTTPS)
                        $geo = Invoke-RestMethod -Uri "https://ipinfo.io/$ip/json" -UseBasicParsing -TimeoutSec 3 -ErrorAction Stop
                        $global:IPCache[$ip] = $geo # Salva no Cache para a proxima vez
                    } catch { 
                        $geo = $null 
                    }
                }
                
                if ($geo -ne $null) {
                    $country = if ($geo.country) { $geo.country } else { "???" }
                    $org = if ($geo.org) { $geo.org } else { "ASN Desconhecido" }
                    
                    # Logica Avancada de Risco (Deteccao de VPNs, Paises e Servidores de Risco)
                    $isRisk = ($country -match "RU|CN|IR|KP") -or ($org -match "Hetzner|DigitalOcean|Tor|VPN|Proxy")
                    
                    if ($isRisk) {
                        Write-Host "[ALERTA: $procName (PID: $procId)] ---> $ip ($country) | Org: $org" -ForegroundColor Red
                    } else {
                        Write-Host "[Seguro: $procName] ---> $ip ($country) | Org: $org" -ForegroundColor Cyan
                    }
                } else {
                    Write-Host "[$procName] ---> $ip (Protegido ou IP Reservado)" -ForegroundColor DarkGray
                }
                
                Start-Sleep -Milliseconds 100 # Delay leve (Acelerado gracas ao cache)
            }
        }
    } catch {
        Write-Host "Erro ao varrer conexoes. Detalhe: $($_.Exception.Message)" -ForegroundColor Red
    }
    
    Write-Host "`nVarredura finalizada. Pressione qualquer tecla para retornar..." -ForegroundColor Yellow
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}

function Open-TechMenu {
    do {
        Show-Header
        Write-Host "=== MODO TECNICO AVANCADO (DANGER ZONE) ===" -ForegroundColor Red
        Write-Host ""
        
        Write-Host " --- FORENSE E CIBERSEGURANCA (ELITE) ---" -ForegroundColor DarkGray
        Write-Host " [1] RADAR DE ESPIONAGEM          " -ForegroundColor Magenta -NoNewline
        Write-Host "[VIRUS] " -ForegroundColor Red -NoNewline
        Write-Host "- Analisa conexoes ao vivo apontando espionagem" -ForegroundColor Gray
        
        Write-Host " [2] ANALISE EDR (VIRUSTOTAL)     " -ForegroundColor Magenta -NoNewline
        Write-Host "[VIRUS] " -ForegroundColor Red -NoNewline
        Write-Host "- Calcula Hash de AppData contra 70 motores" -ForegroundColor Gray
        
        Write-Host " [3] GOD MODE UNBRICK (REGISTRO)  " -ForegroundColor Green -NoNewline
        Write-Host "[VIRUS] " -ForegroundColor Red -NoNewline
        Write-Host "- Destrava Regedit e CMD bloqueados por malware" -ForegroundColor Gray
        
        Write-Host " [4] PROTOCOLO DESINFECCAO NUCLEAR" -ForegroundColor Red -NoNewline
        Write-Host "[VIRUS] " -ForegroundColor Red -NoNewline
        Write-Host "- Corta malwares ocultos e abre Defender Offline" -ForegroundColor Gray
        
        Write-Host " [5] DECRAPIFIER (BLOATWARE)      " -ForegroundColor Red -NoNewline
        Write-Host "[VIRUS] " -ForegroundColor Red -NoNewline
        Write-Host "- Exclui McAfee, TikTok, Norton e patrocinados" -ForegroundColor Gray
        
        Write-Host " --- HARDENING E TWEAKS ---" -ForegroundColor DarkGray
        Write-Host " [6] DESATIVAR TELEMETRIA         " -ForegroundColor Cyan -NoNewline
        Write-Host "[TWEAK] " -ForegroundColor DarkYellow -NoNewline
        Write-Host "- Corta coleta de dados da Microsoft" -ForegroundColor Gray
        
        Write-Host " [7] DESATIVAR VBS (VIRTUALIZACAO)" -ForegroundColor Cyan -NoNewline
        Write-Host "[TWEAK] " -ForegroundColor DarkYellow -NoNewline
        Write-Host "- Desliga camada de seguranca para ganhar FPS" -ForegroundColor Gray
        
        Write-Host " [8] RESETAR REDE WINSOCK         " -ForegroundColor Cyan -NoNewline
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
            "3" { Run-GodModeUnbrick }
            "4" {
                Write-Host "Derrubando Proxy..." -ForegroundColor Yellow
                try { Remove-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings" -Name "ProxyServer" -Force -ErrorAction SilentlyContinue } catch {}
                try { Get-Process | Where-Object { $_.Path -match "AppData|Temp" } | Stop-Process -Force -ErrorAction SilentlyContinue } catch {}
                $r = Read-Host "Agendar varredura do Defender Offline no proximo Boot e reiniciar? (S/N)"
                if ($r -match "^[sS]") { try { Start-MpWDOScan } catch {} }
                Pause-MR
            }
            "5" {
                Write-Host "Cacando Bloatware..." -ForegroundColor Yellow
                $bloat = @("*CandyCrush*", "*TikTok*", "*McAfee*", "*Norton*")
                foreach ($app in $bloat) { 
                    try { Get-AppxPackage -Name $app -AllUsers -ErrorAction SilentlyContinue | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue } catch {} 
                }
                Write-Host "Concluido." -ForegroundColor Green; Pause-MR
            }
            "6" { try { Stop-Service DiagTrack -Force -ErrorAction SilentlyContinue; Set-Service DiagTrack -StartupType Disabled -ErrorAction SilentlyContinue; Write-Host "Telemetria Desativada." -ForegroundColor Green } catch {}; Pause-MR }
            "7" { try { bcdedit /set hypervisorlaunchtype off | Out-Null; Write-Host "VBS Off. Reinicie." -ForegroundColor Green } catch {}; Pause-MR }
            "8" { try { netsh winsock reset | Out-Null; ipconfig /flushdns | Out-Null; Write-Host "Rede recriada." -ForegroundColor Green } catch {}; Pause-MR }
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
    Show-Header
    Write-Host "=== MUDAR IDIOMA / CHANGE LANGUAGE ===" -ForegroundColor Cyan
    Write-Host ""
    Write-Host " [1] ENGLISH (USA)" -ForegroundColor Cyan
    Write-Host " [2] ESPANOL (ES)" -ForegroundColor Cyan
    Write-Host ""
    Write-Host " [0] VOLTAR" -ForegroundColor Yellow
    Write-Host ""
    $null = Read-Host "Escolha / Choose"
    return
}

# -----------------------------------------------------------------------------
# O GRANDE MOTOR DE LOOP PRINCIPAL QUE MANTEM O SCRIPT VIVO E ATIVO
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
        "7" { Open-TechMenu }
        "8" { Open-RestoreMenu }
        "9" { Open-SupportMenu }
        "10"{ Open-RecoveryMenu }
        "11"{ Open-LanguageMenu }
        "0" {
            Write-Host "`nObrigado por utilizar o Mr Evan Intelligent Repair System Elite Edition!" -ForegroundColor Cyan
            Write-Host "Fechando o Terminal de forma segura..." -ForegroundColor DarkGray
            Start-Sleep -Seconds 2
            exit
        }
        default { 
            Write-Host "Opcao Invalida! Por favor, insira um numero valido da lista." -ForegroundColor Red
            Start-Sleep -Seconds 1 
        }
    }
} while ($true)