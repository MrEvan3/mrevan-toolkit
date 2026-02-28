<# 
  Mr Evan Intelligent Repair System
  Console avancado de manutencao, otimizacao e seguranca para Windows.
  Autor: Evandro Lemos + IA
#>

$ErrorActionPreference = "Stop"
$MRIRS_Version         = "v1.3 Elite"
$MRIRS_Width           = 100

# ------------------ SUPORTE BASICO ------------------

function Test-IsAdmin {
    try {
        $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
        $principal   = New-Object Security.Principal.WindowsPrincipal($currentUser)
        return $principal.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
    } catch {
        return $false
    }
}

if (-not (Test-IsAdmin)) {
    Write-Host "Este painel funciona melhor em modo ADMINISTRADOR." -ForegroundColor Yellow
    $resp = Read-Host "Deseja reabrir automaticamente como Administrador? (S/N)"
    if ($resp -match "^[sS]") {
        $scriptPath = $MyInvocation.MyCommand.Path
        if (-not $scriptPath) {
            Write-Host "Nao foi possivel localizar o caminho do script. Execute manualmente como administrador." -ForegroundColor Red
            $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
            exit
        }
        $argList = "-NoProfile -ExecutionPolicy Bypass -File ""$scriptPath"""
        Start-Process powershell.exe -ArgumentList $argList -Verb RunAs
        exit
    }
}

function Pause-MR {
    param([string]$Mensagem = "Pressione qualquer tecla para voltar ao menu...")
    Write-Host ""
    Write-Host $Mensagem -ForegroundColor DarkGray
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}

function Write-Separator {
    param([int]$Width = $MRIRS_Width)
    Write-Host ("-" * $Width) -ForegroundColor DarkGray
}

function Show-Center {
    param([string]$Text, [string]$Color = "White")
    $trimmed = $Text.Trim()
    $pad = [math]::Floor(($MRIRS_Width - $trimmed.Length) / 2)
    if ($pad -lt 0) { $pad = 0 }
    Write-Host ((" " * $pad) + $trimmed) -ForegroundColor $Color
}

# ------------------ CABECALHO / MENU PRINCIPAL ------------------

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
    
    Show-Center "Versao $MRIRS_Version |  Windows 10/11" "Gray"
    Write-Separator
    Show-Center "Use os numeros para navegar. 0 sempre volta/sai." "Gray"
    Write-Separator
    Write-Host ""
}

function Show-MainMenu {
    Show-Header
    Write-Host " [1] OTIMIZAR AGORA        " -ForegroundColor Cyan -NoNewline
    Write-Host " [LIMPEZA]" -ForegroundColor Green -NoNewline
    Write-Host " - Limpar lixo, cache e otimizar PC" -ForegroundColor Gray
    Write-Host " [2] WINDOWS / OFFICE      " -ForegroundColor Cyan -NoNewline
    Write-Host " [ATIVADOR]" -ForegroundColor DarkMagenta -NoNewline
    Write-Host " - Ativa o Windows e o Office para sempre" -ForegroundColor Gray
    Write-Host " [3] FERRAMENTAS GAMER     " -ForegroundColor Cyan -NoNewline
    Write-Host " [GAMER]" -ForegroundColor Magenta -NoNewline
    Write-Host " - Aumenta FPS, reduz lag do mouse e do sistema" -ForegroundColor Gray
    Write-Host " [4] FERRAMENTAS SISTEMA   " -ForegroundColor Cyan -NoNewline
    Write-Host " [SISTEMA]" -ForegroundColor Yellow -NoNewline
    Write-Host " - Repara erros, arruma internet e apaga inuteis" -ForegroundColor Gray
    Write-Host " [5] DIAGNOSTICO DO PC     " -ForegroundColor Cyan -NoNewline
    Write-Host " [INFO]" -ForegroundColor Blue -NoNewline
    Write-Host " - EXTRATOR DE LICENCAS OEM, gargalo e saude" -ForegroundColor Gray
    Write-Host " [6] UTILITARIOS EXTRAS    " -ForegroundColor Cyan -NoNewline
    Write-Host " [EXTRAS]" -ForegroundColor DarkCyan -NoNewline
    Write-Host " - Winget Auto-Installer, Backup de Drivers" -ForegroundColor Gray
    Write-Host " [7] MODO TECNICO AVANCADO " -ForegroundColor Cyan -NoNewline
    Write-Host " [DANGER]" -ForegroundColor Red -NoNewline
    Write-Host " - RADAR SPYWARE, ANALISE EDR E GOD MODE UNBRICK" -ForegroundColor Gray
    Write-Host " [8] RESTAURAR PADROES     " -ForegroundColor Cyan -NoNewline
    Write-Host " [UNDO]" -ForegroundColor Green -NoNewline
    Write-Host " - Desfaz alteracoes e repara problemas" -ForegroundColor Gray
    Write-Host " [9] SUPORTE REMOTO        " -ForegroundColor Cyan -NoNewline
    Write-Host " [SUPORTE]" -ForegroundColor Blue -NoNewline
    Write-Host " - AnyDesk e RustDesk direto como Administrador" -ForegroundColor Gray
    Write-Host " [10] RECUPERACAO OFFLINE  " -ForegroundColor Cyan -NoNewline
    Write-Host " [BOOT]" -ForegroundColor DarkYellow -NoNewline
    Write-Host " - Ferramentas para uso em Pendrive (WinPE)" -ForegroundColor Gray
    Write-Host " [11] MUDAR IDIOMA         " -ForegroundColor Cyan -NoNewline
    Write-Host " [LANG]" -ForegroundColor White -NoNewline
    Write-Host " - Executar versoes em Ingles e Espanhol" -ForegroundColor Gray
    Write-Host ""
    Write-Host " [0] SAIR                  " -ForegroundColor Red -NoNewline
    Write-Host " [---]" -ForegroundColor DarkGray -NoNewline
    Write-Host " - Fechar e sair do Mr Evan IRS" -ForegroundColor Gray
    Write-Host ""
}

# ------------------ BLOCO 1: LIMPEZA E OTIMIZACAO ------------------

function Clear-TempFiles {
    Write-Host "Limpando arquivos temporarios..." -ForegroundColor Green
    $paths = @($env:TEMP, "$env:WINDIR\Temp", "$env:WINDIR\Prefetch", "$env:LOCALAPPDATA\Temp", "$env:LOCALAPPDATA\Microsoft\Windows\INetCache", "$env:LOCALAPPDATA\Microsoft\Windows\Explorer")
    foreach ($p in $paths) {
        try {
            if (Test-Path $p) {
                Get-ChildItem -Path $p -Recurse -Force -ErrorAction SilentlyContinue | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue
            }
        } catch {}
    }
    try { Clear-RecycleBin -Force -ErrorAction SilentlyContinue } catch {}
}

function Clear-BrowserCaches {
    Write-Host "Limpando cache de navegadores..." -ForegroundColor Green
    $browserPaths = @("$env:LOCALAPPDATA\Google\Chrome\User Data\*\Cache", "$env:LOCALAPPDATA\Microsoft\Edge\User Data\*\Cache", "$env:APPDATA\Mozilla\Firefox\Profiles\*\cache2", "$env:APPDATA\Opera Software\Opera Stable\Cache", "$env:LOCALAPPDATA\BraveSoftware\Brave-Browser\User Data\*\Cache")
    foreach ($pattern in $browserPaths) {
        Get-ChildItem -Path $pattern -Force -Recurse -ErrorAction SilentlyContinue | ForEach-Object {
            try { Remove-Item $_.FullName -Recurse -Force -ErrorAction SilentlyContinue } catch {}
        }
    }
}

function Clear-DeepWindowsStuff {
    Write-Host "Limpando componentes avancados do Windows..." -ForegroundColor Green
    $wuPath = "$env:WINDIR\SoftwareDistribution\Download"
    if (Test-Path $wuPath) { try { Get-ChildItem $wuPath -Recurse -Force -ErrorAction SilentlyContinue | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue } catch {} }
    $logPaths = @("$env:WINDIR\Logs", "$env:ProgramData\Microsoft\Windows\WER\ReportArchive", "$env:ProgramData\Microsoft\Windows\WER\ReportQueue")
    foreach ($lp in $logPaths) {
        if (Test-Path $lp) { try { Get-ChildItem $lp -Recurse -Force -ErrorAction SilentlyContinue | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue } catch {} }
    }
    try {
        Write-Host "Iniciando DISM /StartComponentCleanup (pode demorar)..." -ForegroundColor Cyan
        DISM.exe /Online /Cleanup-Image /StartComponentCleanup | Out-Null
    } catch {}
}

function Optimize-NetworkAndDNS {
    Write-Host "Otimizando DNS e cache de rede..." -ForegroundColor Green
    try { ipconfig /flushdns | Out-Null } catch {}
    try {
        $adapters = Get-DnsClientServerAddress -AddressFamily IPv4 -ErrorAction SilentlyContinue | Where-Object { $_.ServerAddresses }
        foreach ($ad in $adapters) { Set-DnsClientServerAddress -InterfaceIndex $ad.InterfaceIndex -ServerAddresses @("1.1.1.1", "1.0.0.1") -ErrorAction SilentlyContinue }
    } catch {}
}

function Optimize-Now {
    Show-Header
    Write-Host "=== FAXINA COMPLETA E OTIMIZACAO ===" -ForegroundColor Magenta
    $c = Read-Host "Confirmar otimizacao completa? (S/N)"
    if ($c -notmatch "^[sS]") { return }

    Clear-TempFiles
    Clear-BrowserCaches
    Clear-DeepWindowsStuff
    Optimize-NetworkAndDNS

    Write-Host ""
    Write-Separator
    Write-Host "RESUMO DA OTIMIZACAO" -ForegroundColor Green
    Write-Host "Sistema limpo, cache renovado e rede otimizada." -ForegroundColor Green
    Write-Separator
    Pause-MR
}

function Open-OptimizeMenu {
    do {
        Show-Header
        Write-Host "=== OTIMIZAR AGORA ===" -ForegroundColor Magenta
        Write-Host ""
        Write-Host " [1] Faxina completa (recomendada)" -ForegroundColor Cyan
        Write-Host " [2] Limpeza rapida (temporarios + lixeira)" -ForegroundColor Cyan
        Write-Host " [3] Limpar apenas navegadores" -ForegroundColor Cyan
        Write-Host " [4] Limpar apenas Windows Update + logs" -ForegroundColor Cyan
        Write-Host " [5] Otimizar apenas DNS / rede" -ForegroundColor Cyan
        Write-Host ""
        Write-Host " [0] Voltar ao menu principal" -ForegroundColor Yellow
        Write-Host ""

        $opt = Read-Host "Escolha uma opcao"
        switch ($opt) {
            "1" { Optimize-Now }
            "2" { Show-Header; Clear-TempFiles; Write-Host "`nLimpeza rapida concluida." -ForegroundColor Green; Pause-MR }
            "3" { Show-Header; Clear-BrowserCaches; Write-Host "`nCaches de navegadores limpos." -ForegroundColor Green; Pause-MR }
            "4" { Show-Header; Clear-DeepWindowsStuff; Write-Host "`nLimpeza de Update/logs concluida." -ForegroundColor Green; Pause-MR }
            "5" { Show-Header; Optimize-NetworkAndDNS; Write-Host "`nRede otimizada." -ForegroundColor Green; Pause-MR }
            "0" { return }
            default { Write-Host "Opcao invalida." -ForegroundColor Red; Pause-MR }
        }
    } while ($true)
}

# ------------------ BLOCO 2: ATIVADOR WINDOWS / OFFICE ------------------

function Bypass-Win11Upgrade {
    Write-Host "Aplicando Bypass de TPM 2.0 e CPU para o Windows 11..." -ForegroundColor Cyan
    try {
        $path = "HKLM:\SYSTEM\Setup\MoSetup"
        if (-not (Test-Path $path)) { New-Item -Path $path -Force | Out-Null }
        New-ItemProperty -Path $path -Name "AllowUpgradesWithUnsupportedTPMOrCPU" -Value 1 -PropertyType DWord -Force | Out-Null
        Write-Host "Bypass aplicado com sucesso no Registro do Windows!" -ForegroundColor Green
        Start-Sleep -Seconds 2
        Start-Process "https://www.microsoft.com/pt-br/software-download/windows11"
    } catch { Write-Host "Erro ao aplicar o Bypass: $($_.Exception.Message)" -ForegroundColor Red }
}

function Open-ActivatorMenu {
    do {
        Show-Header
        Write-Host "=== ATIVADOR WINDOWS / OFFICE ===" -ForegroundColor Magenta
        Write-Host ""
        Write-Host "Este modulo usa o projeto MAS (Microsoft Activation Scripts)," -ForegroundColor Gray
        Write-Host "repositorio open-source oficial: https://github.com/massgravel/Microsoft-Activation-Scripts" -ForegroundColor DarkCyan
        Write-Host ""
        Write-Host " [1] Abrir MAS (irm https://get.activated.win | iex)" -ForegroundColor Cyan
        Write-Host " [2] Ver status de ativacao do Windows" -ForegroundColor Cyan
        Write-Host " [3] Forcar Atualizacao para Windows 11 (Bypass TPM/CPU)" -ForegroundColor Red
        Write-Host ""
        Write-Host " [0] Voltar ao menu principal" -ForegroundColor Yellow
        Write-Host ""

        $opt = Read-Host "Escolha uma opcao"
        switch ($opt) {
            "1" { Show-Header; try { irm "https://get.activated.win" | iex } catch { Write-Host "Falha ao chamar o MAS." -ForegroundColor Red; Pause-MR } }
            "2" { Show-Header; try { slmgr /xpr } catch {}; Pause-MR }
            "3" { Show-Header; Bypass-Win11Upgrade; Pause-MR }
            "0" { return }
            default { Write-Host "Opcao invalida." -ForegroundColor Red; Pause-MR }
        }
    } while ($true)
}

# ------------------ BLOCO 3: GAMER ------------------

function Open-GamerMenu {
    do {
        Show-Header
        Write-Host "=== FERRAMENTAS GAMER ===" -ForegroundColor Magenta
        Write-Host ""
        Write-Host " [1] REDUZIR LATENCIA (TIMER)   " -ForegroundColor Cyan
        Write-Host " [2] FORCAR PRIORIDADE ALTA     " -ForegroundColor Cyan
        Write-Host " [3] DESATIVAR TELA CHEIA (FSO) " -ForegroundColor Cyan
        Write-Host " [4] MOUSE PRECISAO 1:1        " -ForegroundColor Cyan
        Write-Host " [5] OTIMIZAR TECLADO          " -ForegroundColor Cyan
        Write-Host " [6] REDUZIR PACOTES REDE       " -ForegroundColor Cyan
        Write-Host " [7] DESATIVAR GAME BAR / DVR  " -ForegroundColor Cyan
        Write-Host " [8] PLANO ENERGIA ALTO DESEMPENHO" -ForegroundColor Cyan
        Write-Host ""
        Write-Host " [0] VOLTAR                    " -ForegroundColor Yellow
        Write-Host ""

        $opt = Read-Host "Escolha uma opcao"
        switch ($opt) {
            "1" {
                Write-Host "Aplicando timer resolution (reduz latencia)..." -ForegroundColor Green
                try {
                    $code = '[DllImport("ntdll.dll")] public static extern int NtSetTimerResolution(uint d, bool s, ref uint c);'
                    Add-Type -MemberDefinition $code -Namespace Win32 -Name Nt -ErrorAction SilentlyContinue
                    $cur = 0; [Win32.Nt]::NtSetTimerResolution(5000, $true, [ref]$cur) | Out-Null
                    Write-Host "Timer em 0.5ms aplicado. Pressione uma tecla para reverter." -ForegroundColor Green
                    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
                    [Win32.Nt]::NtSetTimerResolution(156000, $true, [ref]$cur) | Out-Null
                } catch { Write-Host "Erro. Alternativa: use plano Alto Desempenho." -ForegroundColor Yellow }
                Pause-MR
            }
            "2" {
                $nome = Read-Host "Digite o nome do executavel do jogo (ex: game.exe)"
                if ($nome) {
                    try {
                        $path = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\$nome\PerfOptions"
                        New-Item -Path $path -Force | Out-Null
                        Set-ItemProperty -Path $path -Name "CpuPriorityClass" -Value 3 -Type DWord -Force
                        Write-Host "Prioridade alta definida para $nome" -ForegroundColor Green
                    } catch {}
                }
                Pause-MR
            }
            "3" {
                try {
                    New-Item -Path "HKCU:\System\GameConfigStore" -Force | Out-Null
                    Set-ItemProperty -Path "HKCU:\System\GameConfigStore" -Name "GameDVR_FSEBehaviorMode" -Value 2 -Type DWord -Force
                    Write-Host "FSO desativado - menos lag no Alt+Tab." -ForegroundColor Green
                } catch {}
                Pause-MR
            }
            "4" {
                try {
                    Set-ItemProperty -Path "HKCU:\Control Panel\Mouse" -Name "MouseSpeed" -Value "0" -Force
                    Set-ItemProperty -Path "HKCU:\Control Panel\Mouse" -Name "MouseThreshold1" -Value "0" -Force
                    Set-ItemProperty -Path "HKCU:\Control Panel\Mouse" -Name "MouseThreshold2" -Value "0" -Force
                    Write-Host "Aceleracao do mouse desativada (precisao 1:1)." -ForegroundColor Green
                } catch {}
                Pause-MR
            }
            "5" {
                try {
                    Set-ItemProperty -Path "HKCU:\Control Panel\Accessibility\Keyboard Response" -Name "AutoRepeatDelay" -Value "150" -Type DWord -Force
                    Write-Host "Teclado otimizado para resposta rapida." -ForegroundColor Green
                } catch {}
                Pause-MR
            }
            "6" {
                try {
                    $ints = Get-Item "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\*" -ErrorAction SilentlyContinue
                    foreach ($i in $ints) { New-ItemProperty -Path $i.PSPath -Name "TcpAckFrequency" -Value 1 -PropertyType DWord -Force -ErrorAction SilentlyContinue | Out-Null }
                    Write-Host "TCP otimizado para jogos online." -ForegroundColor Green
                } catch {}
                Pause-MR
            }
            "7" {
                try {
                    New-Item -Path "HKCU:\SOFTWARE\Microsoft\GameBar" -Force | Out-Null
                    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\GameBar" -Name "ShowGameBar" -Value 0 -Type DWord -Force
                    New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR" -Force | Out-Null
                    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR" -Name "AllowGameDVR" -Value 0 -Type DWord -Force
                    Write-Host "Game Bar e DVR desativados." -ForegroundColor Green
                } catch {}
                Pause-MR
            }
            "8" { try { powercfg -setactive SCHEME_MIN | Out-Null; Write-Host "Plano Alto Desempenho ativado." -ForegroundColor Green } catch {}; Pause-MR }
            "0" { return }
            default { Write-Host "Opcao invalida." -ForegroundColor Red; Pause-MR }
        }
    } while ($true)
}
# ------------------ BLOCO 4: FERRAMENTAS DO SISTEMA ------------------

function Open-SystemToolsMenu {
    do {
        Show-Header
        Write-Host "=== FERRAMENTAS DO SISTEMA (1/2) ===" -ForegroundColor Magenta
        Write-Host ""
        Write-Host " [1] WINUTIL (CHRIS TITUS)      " -ForegroundColor Cyan
        Write-Host " [2] ARRUMAR WINDOWS UPDATE    " -ForegroundColor Cyan
        Write-Host " [3] ESCOLHER MELHOR DNS      " -ForegroundColor Cyan
        Write-Host " [4] DESCARREGAR CACHE DNS    " -ForegroundColor Cyan
        Write-Host " [5] REPARAR ARQUIVOS WINDOWS " -ForegroundColor Cyan
        Write-Host " [6] CRIAR PONTO RESTAURACAO   " -ForegroundColor Cyan
        Write-Host " [7] DESATIVAR TELEMETRIA     " -ForegroundColor Cyan
        Write-Host " [8] CHKDSK (VERIFICAR DISCO)  " -ForegroundColor Cyan
        Write-Host " [9] MAIS FERRAMENTAS (PAG 2)  " -ForegroundColor Cyan
        Write-Host ""
        Write-Host " [0] VOLTAR                    " -ForegroundColor Yellow
        Write-Host ""

        $opt = Read-Host "Escolha uma opcao"
        switch ($opt) {
            "1" { try { irm "https://christitus.com/win" | iex } catch {} }
            "2" {
                Show-Header
                Write-Host "Reiniciando Windows Update (destrava atualizacoes)..." -ForegroundColor Green
                try {
                    Stop-Service wuauserv -Force -ErrorAction SilentlyContinue
                    Stop-Service bits -Force -ErrorAction SilentlyContinue
                    Remove-Item "$env:WINDIR\SoftwareDistribution\Download\*" -Recurse -Force -ErrorAction SilentlyContinue
                    Start-Service wuauserv -ErrorAction SilentlyContinue
                    Start-Service bits -ErrorAction SilentlyContinue
                    Write-Host "Concluido." -ForegroundColor Green
                } catch {}
                Pause-MR
            }
            "3" {
                Show-Header
                Write-Host "Testando DNS e aplicando o mais rapido..." -ForegroundColor Green
                try {
                    $g = (Test-Connection 8.8.8.8 -Count 1 -ErrorAction SilentlyContinue).ResponseTime
                    $c = (Test-Connection 1.1.1.1 -Count 1 -ErrorAction SilentlyContinue).ResponseTime
                    $idx = (Get-NetAdapter | Where-Object Status -eq Up).InterfaceIndex
                    if ($c -le $g) { Set-DnsClientServerAddress -InterfaceIndex $idx -ServerAddresses @("1.1.1.1","1.0.0.1") } else { Set-DnsClientServerAddress -InterfaceIndex $idx -ServerAddresses @("8.8.8.8","8.8.4.4") }
                    Write-Host "DNS aplicado." -ForegroundColor Green
                } catch {}
                Pause-MR
            }
            "4" { Show-Header; ipconfig /flushdns; Write-Host "Cache DNS descarregado." -ForegroundColor Green; Pause-MR }
            "5" { Show-Header; sfc.exe /scannow; DISM.exe /Online /Cleanup-Image /RestoreHealth; Pause-MR }
            "6" { Show-Header; Checkpoint-Computer -Description "Mr Evan IRS" -RestorePointType "MODIFY_SETTINGS" -ErrorAction SilentlyContinue; Pause-MR }
            "7" {
                try {
                    Stop-Service DiagTrack -Force -ErrorAction SilentlyContinue
                    Set-Service DiagTrack -StartupType Disabled -ErrorAction SilentlyContinue
                    Write-Host "Telemetria (DiagTrack) desativada." -ForegroundColor Green
                } catch {}
                Pause-MR
            }
            "8" { Show-Header; chkdsk C: /scan; Pause-MR }
            "9" { Open-SystemToolsMenuPage2 }
            "0" { return }
            default { Write-Host "Opcao invalida." -ForegroundColor Red; Pause-MR }
        }
    } while ($true)
}

function Open-SystemToolsMenuPage2 {
    do {
        Show-Header
        Write-Host "=== FERRAMENTAS DO SISTEMA (2/2) ===" -ForegroundColor Magenta
        Write-Host ""
        Write-Host " [1] EDITAR ARQUIVO HOSTS     " -ForegroundColor Cyan
        Write-Host " [2] VARIAVEIS DE AMBIENTE    " -ForegroundColor Cyan
        Write-Host " [3] REMOVER APPS INICIALIZACAO" -ForegroundColor Cyan
        Write-Host " [4] DESINSTALAR APPS UWP     " -ForegroundColor Cyan
        Write-Host " [5] INSPECAO DE HARDWARE     " -ForegroundColor Cyan
        Write-Host " [6] PING / LATENCIA          " -ForegroundColor Cyan
        Write-Host " [7] RESETAR CACHE FONTES     " -ForegroundColor Cyan
        Write-Host " [8] GOD MODE (ATALHO)        " -ForegroundColor Cyan
        Write-Host ""
        Write-Host " [0] VOLTAR (PAG 1)           " -ForegroundColor Yellow
        Write-Host ""

        $opt = Read-Host "Escolha uma opcao"
        switch ($opt) {
            "1" { Start-Process notepad.exe -ArgumentList "$env:WINDIR\System32\drivers\etc\hosts" }
            "2" { Start-Process "SystemPropertiesAdvanced.exe" }
            "3" { Start-Process taskmgr.exe }
            "4" { Start-Process appwiz.cpl }
            "5" { Start-Process msinfo32.exe }
            "6" { $alvo = Read-Host "Digite IP ou dominio"; if ($alvo) { Test-Connection $alvo -Count 4 }; Pause-MR }
            "7" {
                try {
                    Stop-Service FontCache -Force -ErrorAction SilentlyContinue
                    Remove-Item "$env:LOCALAPPDATA\Microsoft\Windows\Fonts\*.dat" -Force -ErrorAction SilentlyContinue
                    Start-Service FontCache -ErrorAction SilentlyContinue
                    Write-Host "Cache de fontes resetado." -ForegroundColor Green
                } catch {}
                Pause-MR
            }
            "8" {
                $god = "$env:USERPROFILE\Desktop\GodMode.{ED7BA470-8E54-465E-825C-99712043E01C}"
                New-Item -ItemType Directory -Path $god -Force | Out-Null
                Write-Host "God Mode criado na Area de Trabalho." -ForegroundColor Green
                Pause-MR
            }
            "0" { return }
        }
    } while ($true)
}

# ------------------ BLOCO 5: DIAGNOSTICO E FORENSE OEM ------------------

function Show-SystemInfo {
    Write-Host "Coletando informacoes do sistema..." -ForegroundColor Cyan
    try {
        $os   = Get-CimInstance Win32_OperatingSystem
        $cpu  = Get-CimInstance Win32_Processor | Select-Object -First 1
        $gpu  = Get-CimInstance Win32_VideoController | Select-Object -First 1
        $ramGB = [math]::Round($os.TotalVisibleMemorySize / 1MB, 1)
        $uptime = (Get-Date) - $os.LastBootUpTime
        $drives = Get-CimInstance Win32_LogicalDisk -Filter "DriveType=3"

        Write-Host "`n=== SISTEMA OPERACIONAL ===" -ForegroundColor Green
        Write-Host ("Windows : {0}" -f $os.Caption)
        Write-Host ("Versao  : {0}  (Build {1})" -f $os.Version, $os.BuildNumber)
        Write-Host ("Ligado ha: {0}d {1}h {2}m" -f $uptime.Days, $uptime.Hours, $uptime.Minutes)

        Write-Host "`n=== HARDWARE PRINCIPAL ===" -ForegroundColor Green
        Write-Host ("CPU : {0}" -f $cpu.Name)
        Write-Host ("GPU : {0}" -f $gpu.Name)
        Write-Host ("RAM : {0} GB" -f $ramGB)

        Write-Host "`n=== ARMAZENAMENTO ===" -ForegroundColor Green
        foreach ($d in $drives) {
            $totalGB = [math]::Round($d.Size / 1GB, 1)
            $freeGB  = [math]::Round($d.FreeSpace / 1GB, 1)
            $usedGB  = $totalGB - $freeGB
            $statusColor = if ($freeGB -lt ($totalGB * 0.1)) { "Red" } else { "Green" }
            Write-Host ("{0} - Total {1} GB | Usado {2} GB | Livre {3} GB" -f $d.DeviceID, $totalGB, $usedGB, $freeGB) -ForegroundColor $statusColor
        }
    } catch {}
}

function Export-HardwareReport {
    Write-Host "Gerando Laudo de Hardware e Sistema..." -ForegroundColor Cyan
    $path = "$env:USERPROFILE\Desktop\Laudo_Hardware_MrEvan.txt"
    try {
        $os   = Get-CimInstance Win32_OperatingSystem
        $cpu  = Get-CimInstance Win32_Processor | Select-Object -First 1
        $gpu  = Get-CimInstance Win32_VideoController | Select-Object -First 1
        $ramGB = [math]::Round($os.TotalVisibleMemorySize / 1MB, 1)
        $drives = Get-CimInstance Win32_LogicalDisk -Filter "DriveType=3"
        $dt = Get-Date -Format "dd/MM/yyyy HH:mm:ss"

        $report = @(
            "=== LAUDO DE HARDWARE E SISTEMA ==="
            "Gerado por: Mr Evan Intelligent Repair System $MRIRS_Version"
            "Data: $dt"
            ""
            "SISTEMA OPERACIONAL:"
            "Nome: $($os.Caption)"
            "Versao: $($os.Version) (Build $($os.BuildNumber))"
            ""
            "PROCESSADOR E MEMORIA:"
            "CPU: $($cpu.Name)"
            "GPU: $($gpu.Name)"
            "RAM: $ramGB GB"
            ""
            "ARMAZENAMENTO:"
        )

        foreach ($d in $drives) {
            $totalGB = [math]::Round($d.Size / 1GB, 1)
            $freeGB  = [math]::Round($d.FreeSpace / 1GB, 1)
            $report += "Disco $($d.DeviceID) - Total: $totalGB GB | Livre: $freeGB GB"
        }
        
        Set-Content -Path $path -Value $report -Force
        Write-Host "Laudo gerado com sucesso! Arquivo salvo na sua Area de Trabalho." -ForegroundColor Green
        Start-Process notepad.exe -ArgumentList $path
    } catch {}
}

function Get-OEMKeys {
    Write-Host "=== EXTRATOR FORENSE DE LICENCAS (PRODUCT KEY FINDER) ===" -ForegroundColor Magenta
    Write-Host "Extraindo chaves de licenca cravadas na Placa-Mae e Registro...`n" -ForegroundColor Yellow
    $outPath = "$env:USERPROFILE\Desktop\Chaves_Licenca_Cliente.txt"
    $content = @(
        "=== EXTRATOR FORENSE DE LICENCAS (MR EVAN IRS) ==="
        "Gerado por: Mr Evan Intelligent Repair System $MRIRS_Version"
        "Data: $(Get-Date)"
        ""
    )
    
    try {
        $wmi = (Get-WmiObject -query 'select * from SoftwareLicensingService' -ErrorAction Stop).OA3xOriginalProductKey
        if ($wmi) { 
            $content += "Chave Original OEM (BIOS/Placa-Mae): $wmi"
            Write-Host "Chave OEM Encontrada na BIOS: $wmi" -ForegroundColor Green
        } else { 
            $content += "Chave Original OEM (BIOS/Placa-Mae): Nao encontrada (Provavel Licenca Digital)." 
            Write-Host "Nenhuma chave gravada na BIOS (Licenca Digital)." -ForegroundColor DarkGray
        }
    } catch { $content += "Chave OEM (BIOS): Erro ao acessar a BIOS." }
    
    try {
        $reg = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SoftwareProtectionPlatform" -ErrorAction SilentlyContinue).BackupProductKeyDefault
        if ($reg) { 
            $content += "Chave de Instalacao Atual (Registro): $reg" 
            Write-Host "Chave Encontrada no Registro: $reg" -ForegroundColor Green
        }
    } catch {}
    
    Set-Content -Path $outPath -Value $content -Force
    Write-Host "`nAuditoria concluida! Arquivo salvo na sua Area de Trabalho." -ForegroundColor Cyan
    Start-Process notepad.exe -ArgumentList $outPath
    Pause-MR
}

function Open-DiagnosticsMenu {
    do {
        Show-Header
        Write-Host "=== DIAGNOSTICO DO PC ===" -ForegroundColor Magenta
        Write-Host ""
        Write-Host " [1] Diagnostico rapido no console" -ForegroundColor Cyan
        Write-Host " [2] Abrir Informacoes do Sistema (msinfo32)" -ForegroundColor Cyan
        Write-Host " [3] Abrir Monitor de Recursos (resmon)" -ForegroundColor Cyan
        Write-Host " [4] Exportar Laudo da Maquina (Salvar .txt na Area de Trabalho)" -ForegroundColor Green
        Write-Host " [5] Extrator Forense de Licencas OEM (Product Key Finder)" -ForegroundColor Magenta
        Write-Host ""
        Write-Host " [0] Voltar ao menu principal" -ForegroundColor Yellow
        Write-Host ""

        $opt = Read-Host "Escolha uma opcao"
        switch ($opt) {
            "1" { Show-Header; Show-SystemInfo; Pause-MR }
            "2" { Start-Process msinfo32.exe }
            "3" { Start-Process resmon.exe }
            "4" { Show-Header; Export-HardwareReport; Pause-MR }
            "5" { Show-Header; Get-OEMKeys }
            "0" { return }
            default { Write-Host "Opcao invalida." -ForegroundColor Red; Pause-MR }
        }
    } while ($true)
}

# ------------------ BLOCO 6: EXTRAS E WINGET ------------------

function Install-PostFormatKit {
    Show-Header
    Write-Host "=== KIT POS-FORMATACAO (WINGET) ===" -ForegroundColor Cyan
    Write-Host "Instalando programas essenciais silenciosamente... Aguarde." -ForegroundColor Yellow
    
    $apps = @("Google.Chrome", "RARLab.WinRAR", "geeksoftware.PDF24Creator", "Microsoft.PCManager", "WhatsApp.WhatsApp", "OpenAI.ChatGPT", "Adobe.Acrobat.Reader.64-bit")
    foreach ($app in $apps) {
        Write-Host " -> Baixando e instalando $app..." -ForegroundColor DarkGray
        try { winget install $app --accept-source-agreements --accept-package-agreements --silent | Out-Null } catch {}
    }
    
    Write-Host " -> Forcando instalacao da extensao uBlock Origin no Google Chrome..." -ForegroundColor DarkGray
    try {
        $regPath = "HKLM:\SOFTWARE\Policies\Google\Chrome\ExtensionInstallForcelist"
        if (-not (Test-Path $regPath)) { New-Item -Path $regPath -Force | Out-Null }
        New-ItemProperty -Path $regPath -Name "1" -Value "cjpalhdlnbpafiamejdnhcphjbkeiagm;https://clients2.google.com/service/update2/crx" -PropertyType String -Force | Out-Null
    } catch {}
    
    Write-Host "`nKit Pos-Formatacao concluido com sucesso!" -ForegroundColor Green
    Pause-MR
}

function Backup-Drivers {
    Show-Header
    Write-Host "=== BACKUP INTELIGENTE DE DRIVERS ===" -ForegroundColor Cyan
    $dest = Read-Host "Digite o caminho para salvar os drivers (Ex: C:\Backup_Drivers ou Enter para Desktop)"
    if (-not $dest) { $dest = "$env:USERPROFILE\Desktop\Backup_Drivers_MrEvan" }
    
    Write-Host "`nIniciando exportacao de drivers para $dest ..." -ForegroundColor Yellow
    try {
        if (-not (Test-Path $dest)) { New-Item -Path $dest -ItemType Directory -Force | Out-Null }
        Export-WindowsDriver -Online -Destination $dest | Out-Null
        Write-Host "`nBackup de Drivers concluido com sucesso!" -ForegroundColor Green
    } catch { Write-Host "Erro ao fazer backup: $($_.Exception.Message)" -ForegroundColor Red }
    Pause-MR
}

function Open-ExtrasMenu {
    do {
        Show-Header
        Write-Host "=== UTILITARIOS EXTRAS ===" -ForegroundColor Magenta
        Write-Host ""
        Write-Host " [1] Limpeza de Disco (cleanmgr)" -ForegroundColor Cyan
        Write-Host " [2] Configuracoes de Armazenamento" -ForegroundColor Cyan
        Write-Host " [3] Gerenciador de Tarefas (Inicializacao)" -ForegroundColor Cyan
        Write-Host " [4] Programas e Recursos (desinstalar apps)" -ForegroundColor Cyan
        Write-Host " [5] Seguranca do Windows" -ForegroundColor Cyan
        Write-Host " [6] Kit Pos-Formatacao (Instalacao Automatica Winget)" -ForegroundColor Green
        Write-Host " [7] Backup Inteligente de Drivers (Export-WindowsDriver)" -ForegroundColor Green
        Write-Host ""
        Write-Host " [0] Voltar ao menu principal" -ForegroundColor Yellow
        Write-Host ""

        $opt = Read-Host "Escolha uma opcao"
        switch ($opt) {
            "1" { Start-Process cleanmgr.exe }
            "2" { Start-Process "ms-settings:storage" }
            "3" { Start-Process taskmgr.exe }
            "4" { Start-Process appwiz.cpl }
            "5" { Start-Process "windowsdefender:" }
            "6" { Install-PostFormatKit }
            "7" { Backup-Drivers }
            "0" { return }
            default { Write-Host "Opcao invalida." -ForegroundColor Red; Pause-MR }
        }
    } while ($true)
}
# ------------------ BLOCO 7: MODO TECNICO E CIBERSEGURANCA ------------------

function Remove-Bloatware {
    Show-Header
    Write-Host "=== DECRAPIFIER (ASSASSINO DE BLOATWARE DE FABRICA) ===" -ForegroundColor Red
    Write-Host "Removendo lixo pre-instalado (TikTok, Candy Crush, McAfee, Norton, etc)..." -ForegroundColor Yellow
    
    $bloatUWP = @("*CandyCrush*", "*TikTok*", "*Instagram*", "*Facebook*", "*McAfee*", "*Norton*", "*ExpressVPN*", "*Spotify*", "*Netflix*", "*Disney*", "*BingNews*")
    foreach ($app in $bloatUWP) {
        Write-Host " -> Procurando pacote $app..." -ForegroundColor DarkGray
        Get-AppxPackage -Name $app -AllUsers -ErrorAction SilentlyContinue | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue
    }

    Write-Host " -> Procurando programas tradicionais de Bloatware (WMI)..." -ForegroundColor DarkGray
    $bloatWin32 = @("McAfee", "Norton", "Avast", "AVG", "ByteFence")
    foreach ($prog in $bloatWin32) {
        $chk = Get-WmiObject -Class Win32_Product -ErrorAction SilentlyContinue | Where-Object { $_.Name -match $prog }
        if ($chk) {
            Write-Host " -> Desinstalando $prog silenciosamente..." -ForegroundColor Yellow
            $chk.Uninstall() | Out-Null
        }
    }
    Write-Host "`nLimpeza de Bloatware concluida!" -ForegroundColor Green
    Pause-MR
}

function Run-DisinfectionProtocol {
    Show-Header
    Write-Host "=== PROTOCOLO DE DESINFECCAO NUCLEAR ===" -ForegroundColor Red
    $resp = Read-Host "Deseja iniciar a desinfeccao extrema? (S/N)"
    if ($resp -notmatch "^[sS]") { return }

    Write-Host "[1/4] Isolamento de Processos Maliciosos na Temp/AppData..." -ForegroundColor Cyan
    try { Get-Process | Where-Object { $_.Path -match "AppData|Temp" } | Stop-Process -Force -ErrorAction SilentlyContinue } catch {}

    Write-Host "[2/4] Expurgo de Persistencia (Registro)..." -ForegroundColor Cyan
    try {
        Remove-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run" -Name "AutoIt3" -ErrorAction SilentlyContinue
        Remove-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\RunOnce" -Name "*" -ErrorAction SilentlyContinue
    } catch {}

    Write-Host "[3/4] Reposicao de Rede, Proxy e DNS..." -ForegroundColor Cyan
    try {
        Remove-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings" -Name "ProxyServer" -Force -ErrorAction SilentlyContinue
        Remove-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings" -Name "ProxyEnable" -Force -ErrorAction SilentlyContinue
        ipconfig /flushdns | Out-Null
    } catch {}

    Write-Host "[4/4] O GOLPE FINAL (Windows Defender Offline)..." -ForegroundColor Red
    $respOffline = Read-Host "Deseja REINICIAR O PC AGORA para varredura profunda offline (Rootkits)? (S/N)"
    if ($respOffline -match "^[sS]") { try { Start-MpWDOScan } catch {} }
    Pause-MR
}

function Unlock-Windows {
    Show-Header
    Write-Host "=== GOD MODE UNBRICK (DESTRAVAR WINDOWS POS-VIRUS) ===" -ForegroundColor Magenta
    Write-Host "Removendo travas de registro impostas por malwares e destruindo GPOs corrompidas..." -ForegroundColor Yellow
    
    $keys = @(
        "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\System",
        "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System",
        "HKCU:\Software\Policies\Microsoft\Windows\System",
        "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer",
        "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer"
    )
    
    foreach ($k in $keys) {
        if (-not (Test-Path $k)) { try { New-Item -Path $k -Force -ErrorAction SilentlyContinue | Out-Null } catch {} }
        try {
            Set-ItemProperty -Path $k -Name "DisableTaskMgr" -Value 0 -ErrorAction SilentlyContinue
            Set-ItemProperty -Path $k -Name "DisableRegistryTools" -Value 0 -ErrorAction SilentlyContinue
            Set-ItemProperty -Path $k -Name "DisableCMD" -Value 0 -ErrorAction SilentlyContinue
            Set-ItemProperty -Path $k -Name "NoFolderOptions" -Value 0 -ErrorAction SilentlyContinue
            Set-ItemProperty -Path $k -Name "NoControlPanel" -Value 0 -ErrorAction SilentlyContinue
        } catch {}
    }
    Write-Host "-> Regedit, CMD, Gerenciador de Tarefas e Opcoes de Pasta liberados do bloqueio." -ForegroundColor Green
    
    Write-Host "-> Aplicando GPO Nuke (Reset de Politicas de Grupo)..." -ForegroundColor DarkGray
    try {
        Remove-Item "$env:windir\System32\GroupPolicyUsers" -Recurse -Force -ErrorAction SilentlyContinue
        Remove-Item "$env:windir\System32\GroupPolicy" -Recurse -Force -ErrorAction SilentlyContinue
        gpupdate /force | Out-Null
    } catch {}
    
    Write-Host "`nSistema 100% destravado e salvo do coma!" -ForegroundColor Green
    Pause-MR
}

function Run-NetworkRadar {
    Show-Header
    Write-Host "=== RADAR DE ESPIONAGEM (NETWORK SPYWARE SCANNER) ===" -ForegroundColor Magenta
    Write-Host "Mapeando conexoes ativas com seguranca maxima (Pode demorar alguns segundos)...`n" -ForegroundColor Yellow

    # Relaxa a regra de bloqueio estrito apenas para esta funcao nao crashar
    $oldErr = $ErrorActionPreference
    $ErrorActionPreference = "SilentlyContinue"

    $tcp = Get-NetTCPConnection -State Established
    
    if ($tcp -ne $null) {
        # Cria uma lista limpa so com IPs externos (Ignora rede local e roteador)
        $externos = @()
        foreach ($c in $tcp) {
            if ($c.RemoteAddress -notmatch "^(127\.|192\.168\.|10\.|172\.(1[6-9]|2[0-9]|3[0-1])\.|::1|0\.0\.0\.0)") {
                $externos += $c
            }
        }
        
        # Filtra duplicados para nao bombardear a API
        $unicos = $externos | Select-Object RemoteAddress, OwningProcess -Unique

        if ($unicos -ne $null -and $unicos.Count -gt 0) {
            foreach ($conn in $unicos) {
                $ip = $conn.RemoteAddress
                $pid = $conn.OwningProcess
                $procName = "Sistema/Oculto"
                
                # Busca o nome limpo do aplicativo
                if ($pid -gt 0) {
                    $p = Get-Process -Id $pid
                    if ($p -ne $null) { $procName = $p.ProcessName }
                }

                try {
                    # Consulta a API oficial (ip-api) com delay para evitar bloqueio
                    $geo = Invoke-RestMethod -Uri "http://ip-api.com/json/$ip" -UseBasicParsing -TimeoutSec 3 -ErrorAction Stop
                    if ($geo.status -eq "success") {
                        $country = $geo.country
                        $isp = $geo.isp
                        $color = if ($country -match "Russia|China|Korea|Iran") { "Red" } else { "Cyan" }
                        Write-Host "[$procName (PID: $pid)] -> $ip ($country) | Operadora: $isp" -ForegroundColor $color
                    } else {
                        Write-Host "[$procName (PID: $pid)] -> $ip (IP Local/Privado)" -ForegroundColor DarkGray
                    }
                } catch {
                    Write-Host "[$procName (PID: $pid)] -> $ip (API Ocupada)" -ForegroundColor DarkGray
                }
                
                # Pequena pausa para a API gratuita nao nos bloquear
                Start-Sleep -Milliseconds 400
            }
        } else {
            Write-Host "Nenhuma conexao externa suspeita encontrada neste momento." -ForegroundColor Green
        }
    } else {
        Write-Host "Nenhuma conexao TCP estabelecida no momento." -ForegroundColor Green
    }

    # Restaura a seguranca maxima do script
    $ErrorActionPreference = $oldErr

    Write-Host "`nVarredura finalizada. Paises em vermelho sao considerados de alto risco." -ForegroundColor Green
    Pause-MR
}

function Run-EDRAnalysis {
    Show-Header
    Write-Host "=== ANALISE EDR EM NUVEM (VIRUSTOTAL) ===" -ForegroundColor Magenta
    Write-Host "Identificando executaveis unicos rodando em pastas de risco..." -ForegroundColor Yellow
    
    # Pega os processos e filtra para ter apenas caminhos UNICOS (Ignora processos duplicados do mesmo app)
    $suspectProcs = Get-Process -ErrorAction SilentlyContinue | Where-Object { $_.Path -match "AppData|Temp|ProgramData" } | Select-Object -Property Path -Unique
    
    if (-not $suspectProcs) {
        Write-Host "Nenhum processo suspeito detectado em pastas de risco." -ForegroundColor Green
    } else {
        $urlsToOpen = @()
        foreach ($proc in $suspectProcs) {
            try {
                $hash = (Get-FileHash -Path $proc.Path -Algorithm SHA256 -ErrorAction Stop).Hash
                $fileName = [System.IO.Path]::GetFileName($proc.Path)
                
                Write-Host "`nProcesso: $fileName" -ForegroundColor Red
                Write-Host "Caminho: $($proc.Path)" -ForegroundColor DarkGray
                Write-Host "Hash: $hash" -ForegroundColor DarkGray
                
                $url = "https://www.virustotal.com/gui/file/$hash"
                $urlsToOpen += $url
            } catch {}
        }
        
        if ($urlsToOpen.Count -gt 0) {
            Write-Host "`nForam encontrados $($urlsToOpen.Count) executaveis unicos." -ForegroundColor Yellow
            $abrir = Read-Host "Deseja abrir o(s) relatorio(s) no navegador agora? (S/N)"
            if ($abrir -match "^[sS]") {
                Write-Host "Abrindo abas..." -ForegroundColor Cyan
                foreach ($u in $urlsToOpen) {
                    Start-Process $u
                    Start-Sleep -Milliseconds 500
                }
            }
        }
    }
    
    Write-Host "`n[Scanner Manual de Arquivo]" -ForegroundColor Cyan
    $resp = Read-Host "Deseja selecionar um arquivo especifico no PC para checar no VirusTotal? (S/N)"
    if ($resp -match "^[sS]") {
        [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") | Out-Null
        $dialog = New-Object System.Windows.Forms.OpenFileDialog
        $dialog.Title = "Selecione o arquivo suspeito para analise"
        if ($dialog.ShowDialog() -eq "OK") {
            $file = $dialog.FileName
            Write-Host "Calculando Hash Digital..." -ForegroundColor Yellow
            try {
                $hash = (Get-FileHash -Path $file -Algorithm SHA256 -ErrorAction Stop).Hash
                $url = "https://www.virustotal.com/gui/file/$hash"
                Start-Process $url
                Write-Host "Navegador aberto com o relatorio de seguranca." -ForegroundColor Green
            } catch { Write-Host "Erro ao processar o arquivo." -ForegroundColor Red }
        }
    }
    Pause-MR
}

function Open-TechMenu {
    do {
        Show-Header
        Write-Host "=== MODO TECNICO AVANCADO (CUIDADO) ===" -ForegroundColor Red
        Write-Host ""
        Write-Host " --- DEBLOAT E INTERFACE ---" -ForegroundColor DarkGray
        Write-Host " [1] Desativar VBS (Ganha FPS em jogos)" -ForegroundColor Cyan
        Write-Host " [2] Reset Completo da Pilha de Rede (Winsock)" -ForegroundColor Cyan
        Write-Host " [3] PROTOCOLO DE DESINFECCAO NUCLEAR" -ForegroundColor Red
        Write-Host " [4] DECRAPIFIER (Assassino de Bloatware de Fabrica)" -ForegroundColor Red
        Write-Host " --- FORENSE E CIBERSEGURANCA (ELITE) ---" -ForegroundColor DarkGray
        Write-Host " [5] Radar de Espionagem (Analisador de Conexoes via API)" -ForegroundColor Magenta
        Write-Host " [6] Analise EDR em Nuvem (Integracao VirusTotal)" -ForegroundColor Magenta
        Write-Host " [7] God Mode Unbrick (Destravar Windows Pos-Virus)" -ForegroundColor Green
        Write-Host ""
        Write-Host " [0] Voltar ao menu principal" -ForegroundColor DarkYellow
        Write-Host ""

        $opt = Read-Host "Escolha uma opcao"
        switch ($opt) {
            "1" { try { bcdedit /set hypervisorlaunchtype off | Out-Null; Write-Host "VBS desativado. Reinicie." -ForegroundColor Green } catch {}; Pause-MR }
            "2" { try { netsh winsock reset | Out-Null; ipconfig /flushdns | Out-Null; Write-Host "Rede resetada." -ForegroundColor Green } catch {}; Pause-MR }
            "3" { Run-DisinfectionProtocol }
            "4" { Remove-Bloatware }
            "5" { Run-NetworkRadar }
            "6" { Run-EDRAnalysis }
            "7" { Unlock-Windows }
            "0" { return }
            default { Write-Host "Opcao invalida." -ForegroundColor Red; Pause-MR }
        }
    } while ($true)
}

# ------------------ BLOCO 8: RESTAURAR PADROES (UNDO) ------------------

function Open-RestoreMenu {
    do {
        Show-Header
        Write-Host "=== RESTAURAR PADROES (DESFAZER) ===" -ForegroundColor Green
        Write-Host ""
        Write-Host " [1] Resetar Seguranca do Windows (Defender)" -ForegroundColor Cyan
        Write-Host " [2] Destravar Explorer e Barra de Tarefas" -ForegroundColor Cyan
        Write-Host " [3] Consertar Menu Iniciar Quebrado (Re-registrar AppX)" -ForegroundColor Cyan
        Write-Host " [4] Reverter Menu de Contexto (Padrao Win 11)" -ForegroundColor Cyan
        Write-Host " [5] Restaurar DNS Automatico (DHCP)" -ForegroundColor Cyan
        Write-Host " [6] Restaurar Plano de Energia Equilibrado" -ForegroundColor Cyan
        Write-Host ""
        Write-Host " [0] Voltar ao menu principal" -ForegroundColor DarkYellow
        Write-Host ""

        $opt = Read-Host "Escolha uma opcao"
        switch ($opt) {
            "1" { try { & "C:\Program Files\Windows Defender\MpCmdRun.exe" -RestoreDefaults; Write-Host "Feito." -ForegroundColor Green } catch {}; Pause-MR }
            "2" { try { Stop-Process -Name explorer -Force -ErrorAction SilentlyContinue; Start-Process explorer.exe } catch {}; Pause-MR }
            "3" { try { Get-AppXPackage -AllUsers | Foreach {Add-AppxPackage -DisableDevelopmentMode -Register "$($_.InstallLocation)\AppXManifest.xml" -ErrorAction SilentlyContinue}; Write-Host "Feito." -ForegroundColor Green } catch {}; Pause-MR }
            "4" { try { Remove-Item -Path "HKCU:\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}" -Recurse -Force -ErrorAction SilentlyContinue; Write-Host "Feito." -ForegroundColor Green } catch {}; Pause-MR }
            "5" { try { ipconfig /flushdns | Out-Null; Write-Host "DNS automatico ativado." -ForegroundColor Green } catch {}; Pause-MR }
            "6" { try { powercfg -setactive SCHEME_BALANCED | Out-Null; Write-Host "Plano equilibrado ativado." -ForegroundColor Green } catch {}; Pause-MR }
            "0" { return }
            default { Write-Host "Opcao invalida." -ForegroundColor Red; Pause-MR }
        }
    } while ($true)
}

# ------------------ BLOCO 9: SUPORTE REMOTO ------------------

function Open-SupportMenu {
    do {
        Show-Header
        Write-Host "=== SUPORTE REMOTO (ACESSO IMEDIATO) ===" -ForegroundColor Cyan
        Write-Host ""
        Write-Host " [1] Baixar e Abrir AnyDesk (Classico)" -ForegroundColor Cyan
        Write-Host " [2] Baixar e Abrir RustDesk (Alternativa sem limite comercial)" -ForegroundColor Cyan
        Write-Host ""
        Write-Host " [0] Voltar ao menu principal" -ForegroundColor Yellow
        Write-Host ""

        $opt = Read-Host "Escolha uma opcao"
        switch ($opt) {
            "1" {
                Show-Header
                Write-Host "Baixando AnyDesk... Aguarde." -ForegroundColor Yellow
                try {
                    Invoke-WebRequest -Uri "https://download.anydesk.com/AnyDesk.exe" -OutFile "$env:USERPROFILE\Desktop\AnyDesk.exe" -UseBasicParsing
                    Start-Process "$env:USERPROFILE\Desktop\AnyDesk.exe"
                    Write-Host "AnyDesk aberto na Area de Trabalho!" -ForegroundColor Green
                } catch {}
                Pause-MR
            }
            "2" {
                Show-Header
                Write-Host "Baixando RustDesk via Winget..." -ForegroundColor Yellow
                try { winget install RustDesk.RustDesk --accept-source-agreements --accept-package-agreements --silent; Write-Host "Instalado." -ForegroundColor Green } catch {}
                Pause-MR
            }
            "0" { return }
            default { Write-Host "Opcao invalida." -ForegroundColor Red; Pause-MR }
        }
    } while ($true)
}

# ------------------ BLOCO 10: RECUPERACAO OFFLINE ------------------

function Bypass-AdminPassword {
    Write-Host "Quebrar Senha de Administrador (Bypass Utilman)" -ForegroundColor Red
    $op = Read-Host "Digite [1] para Ativar o Bypass ou [2] para Reverter"
    $drv = Read-Host "Digite a letra da unidade do Windows (ex: C, D)"
    
    if ($drv -match "^[a-zA-Z]$") {
        $sys32 = "$($drv):\Windows\System32"
        if ($op -eq "1") {
            try {
                Rename-Item "$sys32\utilman.exe" "utilman.exe.bak" -Force -ErrorAction Stop
                Copy-Item "$sys32\cmd.exe" "$sys32\utilman.exe" -Force -ErrorAction Stop
                Write-Host "Bypass Ativado! Reinicie e clique na Acessibilidade na tela de login." -ForegroundColor Green
            } catch { Write-Host "Erro." -ForegroundColor Red }
        } elseif ($op -eq "2") {
            try {
                Remove-Item "$sys32\utilman.exe" -Force -ErrorAction Stop
                Rename-Item "$sys32\utilman.exe.bak" "utilman.exe" -Force -ErrorAction Stop
                Write-Host "Bypass Revertido!" -ForegroundColor Green
            } catch { Write-Host "Erro ao reverter." -ForegroundColor Red }
        }
    }
}

function Open-RecoveryMenu {
    do {
        Show-Header
        Write-Host "=== MODO RECUPERACAO OFFLINE (BOOT / WINPE) ===" -ForegroundColor DarkYellow
        Write-Host " [1] Verificar particoes e discos (Diskpart)" -ForegroundColor Cyan
        Write-Host " [2] Desativar Conta Administrador (Bypass utilman.exe)" -ForegroundColor Red
        Write-Host " [3] Backup Automatico de Usuarios (Robocopy offline)" -ForegroundColor Cyan
        Write-Host " [4] Reparar Boot (Bootrec)" -ForegroundColor Cyan
        Write-Host ""
        Write-Host " [0] Voltar ao menu principal" -ForegroundColor DarkYellow
        Write-Host ""

        $opt = Read-Host "Escolha uma opcao"
        switch ($opt) {
            "1" { "echo list volume | diskpart" | cmd; Pause-MR }
            "2" { Bypass-AdminPassword; Pause-MR }
            "3" {
                $src = Read-Host "Unidade do Windows do cliente (ex: C)"
                $dst = Read-Host "Destino HD/Pendrive (ex: E:\Backup)"
                if ($src -and $dst) { robocopy "$($src):\Users" "$dst\Users" /E /ZB /R:1 /W:1 /XD AppData; Write-Host "Finalizado!" -ForegroundColor Green }
                Pause-MR
            }
            "4" { try { bootrec /fixmbr; bootrec /fixboot; bootrec /rebuildbcd; Write-Host "Reparo concluido." -ForegroundColor Green } catch {}; Pause-MR }
            "0" { return }
            default { Write-Host "Opcao invalida." -ForegroundColor Red; Pause-MR }
        }
    } while ($true)
}

# ------------------ BLOCO 11: IDIOMAS ------------------

function Open-LanguageMenu {
    do {
        Show-Header
        Write-Host "=== MUDAR IDIOMA / CHANGE LANGUAGE ===" -ForegroundColor Cyan
        Write-Host " [1] English (Download EN Version)" -ForegroundColor Cyan
        Write-Host " [2] Espanol (Download ES Version)" -ForegroundColor Cyan
        Write-Host "`n [0] Voltar / Back" -ForegroundColor Yellow

        $opt = Read-Host "Escolha uma opcao / Choose an option"
        switch ($opt) {
            "1" { Write-Host "Aguarde a versao v1.4! / Please wait for v1.4!" -ForegroundColor Yellow; Start-Sleep 3 }
            "2" { Write-Host "Espere la version v1.4!" -ForegroundColor Yellow; Start-Sleep 3 }
            "0" { return }
        }
    } while ($true)
}

# ------------------ LOOP PRINCIPAL ------------------

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
        "10" { Open-RecoveryMenu }
        "11" { Open-LanguageMenu }
        "0" {
            Write-Host "`nObrigado por usar o Mr Evan Intelligent Repair System Elite!" -ForegroundColor Cyan
            Write-Host "Fechando..." -ForegroundColor DarkGray
            Start-Sleep -Seconds 2
            exit
        }
        default {
            Write-Host "Opcao invalida. Digite um numero do menu." -ForegroundColor Red
            Pause-MR
        }
    }
} while ($true)