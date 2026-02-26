<# 
  Mr Evan Intelligent Repair System
  Console avançado de manutenção e otimização para Windows 10 e 11.
  Autor: MR EVAN + IA
#>

$ErrorActionPreference = "Stop"
$MRIRS_Version         = "v2.1.0"
$MRIRS_Width           = 100

# ------------------ SUPORTE BÁSICO ------------------

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
    if ($resp -match '^[sS]') {
        $scriptPath = $MyInvocation.MyCommand.Path
        if (-not $scriptPath) {
            Write-Host "Não foi possível localizar o caminho do script. Execute manualmente como administrador." -ForegroundColor Red
            pause
            exit
        }
        $argList = "-NoProfile -ExecutionPolicy Bypass -File `"$scriptPath`""
        Start-Process powershell.exe -ArgumentList $argList -Verb RunAs
        exit
    }
}

function Pause-MR {
    param(
        [string]$Mensagem = "Pressione qualquer tecla para voltar ao menu..."
    )
    Write-Host ""
    Write-Host $Mensagem -ForegroundColor DarkGray
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}

function Write-Separator {
    param([int]$Width = $MRIRS_Width)
    Write-Host ("-" * $Width) -ForegroundColor DarkGray
}

function Show-Center {
    param(
        [string]$Text,
        [string]$Color = "White"
    )
    $trimmed = $Text.Trim()
    $pad = [math]::Floor(($MRIRS_Width - $trimmed.Length) / 2)
    if ($pad -lt 0) { $pad = 0 }
    Write-Host ((" " * $pad) + $trimmed) -ForegroundColor $Color
}

# ------------------ CABEÇALHO / MENU PRINCIPAL ------------------

function Show-Header {
    Clear-Host
    Write-Host ""
    Show-Center "███████╗ ██████╗  █████╗ ███╗   ██╗" "Cyan"
    Show-Center "██╔════╝██╔═══██╗██╔══██╗████╗  ██║" "Cyan"
    Show-Center "█████╗  ██║   ██║███████║██╔██╗ ██║" "Cyan"
    Show-Center "██╔══╝  ██║   ██║██╔══██║██║╚██╗██║" "Cyan"
    Show-Center "██║     ╚██████╔╝██║  ██║██║ ╚████║" "Cyan"
    Show-Center "╚═╝      ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═══╝" "Cyan"
    Write-Host ""
    Show-Center "Mr Evan" "Red"
    Show-Center "Intelligent Repair System" "Red"
    Write-Host ""
    Show-Center "Versão $MRIRS_Version  |  Windows 10/11" "Gray"
    Write-Host ""
    Write-Separator
    Show-Center "Use os números para navegar. 0 sempre volta/sai." "Gray"
    Write-Separator
    Write-Host ""
}

function Show-MainMenu {
    Show-Header

    Write-Host " [1] OTIMIZAR AGORA        " -ForegroundColor Cyan -NoNewline
    Write-Host " [LIMPEZA]" -ForegroundColor Green

    Write-Host " [2] WINDOWS / OFFICE      " -ForegroundColor Cyan -NoNewline
    Write-Host " [ATIVADOR]" -ForegroundColor DarkMagenta

    Write-Host " [3] FERRAMENTAS GAMER     " -ForegroundColor Cyan -NoNewline
    Write-Host " [GAMER]" -ForegroundColor Magenta

    Write-Host " [4] FERRAMENTAS SISTEMA   " -ForegroundColor Cyan -NoNewline
    Write-Host " [SISTEMA]" -ForegroundColor Yellow

    Write-Host " [5] DIAGNÓSTICO DO PC     " -ForegroundColor Cyan -NoNewline
    Write-Host " [INFO]" -ForegroundColor Blue

    Write-Host " [6] UTILITÁRIOS EXTRAS    " -ForegroundColor Cyan -NoNewline
    Write-Host " [EXTRAS]" -ForegroundColor DarkCyan

    Write-Host ""
    Write-Host " [0] SAIR DO MR EVAN IRS   " -ForegroundColor Red
    Write-Host ""
}

# ------------------ BLOCO: LIMPEZA E OTIMIZAÇÃO ------------------

function Clear-TempFiles {
    Write-Host "Limpando arquivos temporários..." -ForegroundColor Green

    $paths = @(
        $env:TEMP,
        "$env:WINDIR\Temp",
        "$env:WINDIR\Prefetch",
        "$env:LOCALAPPDATA\Temp",
        "$env:LOCALAPPDATA\Microsoft\Windows\INetCache",
        "$env:LOCALAPPDATA\Microsoft\Windows\Explorer"
    )

    foreach ($p in $paths) {
        try {
            if (Test-Path $p) {
                Write-Host " - Limpando: $p" -ForegroundColor DarkGray
                Get-ChildItem -Path $p -Recurse -Force -ErrorAction SilentlyContinue |
                    Remove-Item -Force -Recurse -ErrorAction SilentlyContinue
            }
        } catch {
            Write-Host "   Falha ao limpar $p : $($_.Exception.Message)" -ForegroundColor DarkYellow
        }
    }

    try {
        Write-Host " - Esvaziando Lixeira..." -ForegroundColor DarkGray
        Clear-RecycleBin -Force -ErrorAction SilentlyContinue
    } catch {
        Write-Host "   Não foi possível esvaziar a Lixeira: $($_.Exception.Message)" -ForegroundColor DarkYellow
    }
}

function Clear-BrowserCaches {
    Write-Host "Limpando cache de navegadores..." -ForegroundColor Green

    $browserPaths = @(
        "$env:LOCALAPPDATA\Google\Chrome\User Data\*\Cache",
        "$env:LOCALAPPDATA\Microsoft\Edge\User Data\*\Cache",
        "$env:APPDATA\Mozilla\Firefox\Profiles\*\cache2",
        "$env:APPDATA\Opera Software\Opera Stable\Cache",
        "$env:LOCALAPPDATA\BraveSoftware\Brave-Browser\User Data\*\Cache"
    )

    foreach ($pattern in $browserPaths) {
        Get-ChildItem -Path $pattern -Force -Recurse -ErrorAction SilentlyContinue | ForEach-Object {
            try {
                Remove-Item $_.FullName -Recurse -Force -ErrorAction SilentlyContinue
            } catch {
            }
        }
    }
}

function Clear-DeepWindowsStuff {
    Write-Host "Limpando componentes avançados do Windows..." -ForegroundColor Green

    $wuPath = "$env:WINDIR\SoftwareDistribution\Download"
    if (Test-Path $wuPath) {
        try {
            Write-Host " - Limpando cache de Windows Update..." -ForegroundColor DarkGray
            Get-ChildItem $wuPath -Recurse -Force -ErrorAction SilentlyContinue |
                Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
        } catch {
            Write-Host "   Erro ao limpar SoftwareDistribution: $($_.Exception.Message)" -ForegroundColor DarkYellow
        }
    }

    $logPaths = @(
        "$env:WINDIR\Logs",
        "$env:ProgramData\Microsoft\Windows\WER\ReportArchive",
        "$env:ProgramData\Microsoft\Windows\WER\ReportQueue"
    )
    foreach ($lp in $logPaths) {
        if (Test-Path $lp) {
            try {
                Write-Host " - Limpando logs: $lp" -ForegroundColor DarkGray
                Get-ChildItem $lp -Recurse -Force -ErrorAction SilentlyContinue |
                    Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
            } catch {
                Write-Host "   Erro ao limpar $lp : $($_.Exception.Message)" -ForegroundColor DarkYellow
            }
        }
    }

    try {
        Write-Host "`nIniciando DISM /StartComponentCleanup (pode demorar)..." -ForegroundColor Cyan
        DISM.exe /Online /Cleanup-Image /StartComponentCleanup | Out-Null
        Write-Host "DISM /StartComponentCleanup concluído." -ForegroundColor Green
    } catch {
        Write-Host "Falha ao executar DISM: $($_.Exception.Message)" -ForegroundColor Red
    }
}

function Optimize-NetworkAndDNS {
    Write-Host "Otimizando DNS e cache de rede..." -ForegroundColor Green
    try {
        ipconfig /flushdns | Out-Null
        Write-Host " - DNS limpo (ipconfig /flushdns)." -ForegroundColor DarkGray
    } catch {
        Write-Host "   Falha ao limpar DNS: $($_.Exception.Message)" -ForegroundColor DarkYellow
    }

    try {
        $adapters = Get-DnsClientServerAddress -AddressFamily IPv4 -ErrorAction SilentlyContinue |
            Where-Object { $_.ServerAddresses }
        foreach ($ad in $adapters) {
            Write-Host (" - Ajustando DNS de {0} para 1.1.1.1 / 1.0.0.1" -f $ad.InterfaceAlias) -ForegroundColor DarkGray
            Set-DnsClientServerAddress -InterfaceIndex $ad.InterfaceIndex -ServerAddresses @("1.1.1.1", "1.0.0.1") -ErrorAction SilentlyContinue
        }
    } catch {
        Write-Host "   Não foi possível ajustar DNS automaticamente: $($_.Exception.Message)" -ForegroundColor DarkYellow
    }
}

function Optimize-Now {
    Show-Header
    Write-Host "=== FAXINA COMPLETA E OTIMIZAÇÃO ===" -ForegroundColor Magenta
    Write-Host ""
    Write-Host " - Limpeza de arquivos temporários e lixeira" -ForegroundColor Gray
    Write-Host " - Limpeza de caches de navegador e Windows Update" -ForegroundColor Gray
    Write-Host " - Otimização básica de DNS e cache de rede" -ForegroundColor Gray
    Write-Host ""

    $c = Read-Host "Confirmar otimização completa? (S/N)"
    if ($c -notmatch '^[sS]') {
        Write-Host "Otimização cancelada." -ForegroundColor Yellow
        Pause-MR
        return
    }

    $totalMB = 0
    try { $before = Get-PSDrive C | Select-Object -ExpandProperty Free } catch { $before = $null }

    Clear-TempFiles
    Clear-BrowserCaches
    Clear-DeepWindowsStuff
    Optimize-NetworkAndDNS

    try {
        $after = Get-PSDrive C | Select-Object -ExpandProperty Free
        if ($before -and $after) {
            $totalMB = [math]::Round(($after - $before) / 1MB, 2)
        }
    } catch {}

    Write-Host ""
    Write-Separator
    Write-Host "RESUMO DA OTIMIZAÇÃO" -ForegroundColor Green
    if ($totalMB -gt 0) {
        Write-Host ("Espaço total liberado: {0} MB" -f $totalMB) -ForegroundColor Green
    } else {
        Write-Host "Espaço liberado: cálculo indisponível (mas a faxina foi feita)." -ForegroundColor Green
    }
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
        Write-Host " [2] Limpeza rápida (temporários + lixeira)" -ForegroundColor Cyan
        Write-Host " [3] Limpar apenas navegadores" -ForegroundColor Cyan
        Write-Host " [4] Limpar apenas Windows Update + logs" -ForegroundColor Cyan
        Write-Host " [5] Otimizar apenas DNS / rede" -ForegroundColor Cyan
        Write-Host ""
        Write-Host " [0] Voltar ao menu principal" -ForegroundColor Yellow
        Write-Host ""

        $opt = Read-Host "Escolha uma opção"
        switch ($opt) {
            "1" { Optimize-Now }
            "2" { Show-Header; Clear-TempFiles; Write-Host "`nLimpeza rápida concluída." -ForegroundColor Green; Pause-MR }
            "3" { Show-Header; Clear-BrowserCaches; Write-Host "`nCaches de navegadores limpos." -ForegroundColor Green; Pause-MR }
            "4" { Show-Header; Clear-DeepWindowsStuff; Write-Host "`nLimpeza de Update/logs concluída." -ForegroundColor Green; Pause-MR }
            "5" { Show-Header; Optimize-NetworkAndDNS; Pause-MR }
            "0" { return }
            default {
                Write-Host "Opção inválida." -ForegroundColor Red
                Pause-MR
            }
        }
    } while ($true)
}

# ------------------ BLOCO: REPAROS / SISTEMA ------------------

function Run-SFC {
    Write-Host "Executando verificação de arquivos do sistema (SFC /SCANNOW)..." -ForegroundColor Cyan
    Write-Host "Isso pode levar vários minutos. Aguarde até 100%." -ForegroundColor DarkGray
    try { sfc.exe /scannow } catch { Write-Host "Erro ao executar SFC: $($_.Exception.Message)" -ForegroundColor Red }
}

function Run-DISMRepair {
    Write-Host "Executando reparo da imagem do Windows (DISM /RestoreHealth)..." -ForegroundColor Cyan
    Write-Host "Isso também pode levar bastante tempo. Aguarde." -ForegroundColor DarkGray
    try { DISM.exe /Online /Cleanup-Image /RestoreHealth } catch { Write-Host "Erro ao executar DISM: $($_.Exception.Message)" -ForegroundColor Red }
}

function Run-CHKDSKScan {
    Write-Host "Verificando disco do sistema com CHKDSK /scan..." -ForegroundColor Cyan
    Write-Host "Esta verificação é online (sem reiniciar). Para reparos completos use CHKDSK /F manualmente." -ForegroundColor DarkGray
    try { chkdsk C: /scan } catch { Write-Host "Erro ao executar CHKDSK: $($_.Exception.Message)" -ForegroundColor Red }
}

function Create-RestorePoint {
    Write-Host "Criando ponto de restauração (se o recurso estiver ativado)..." -ForegroundColor Cyan
    try {
        Checkpoint-Computer -Description "Mr Evan IRS" -RestorePointType "MODIFY_SETTINGS"
        Write-Host "Ponto de restauração solicitado." -ForegroundColor Green
    } catch {
        Write-Host "Não foi possível criar o ponto de restauração: $($_.Exception.Message)" -ForegroundColor Yellow
    }
}

# ------------------ BLOCO: DEFENDER / SEGURANÇA ------------------

function Run-DefenderQuickScan {
    Write-Host "Iniciando verificação rápida do Microsoft Defender..." -ForegroundColor Cyan
    $cmd = Get-Command -Name Start-MpScan -ErrorAction SilentlyContinue
    if ($cmd) {
        try { Start-MpScan -ScanType QuickScan } catch { Write-Host "Erro ao usar Start-MpScan: $($_.Exception.Message)" -ForegroundColor Red }
    } else {
        $mpPaths = @(
            "$env:ProgramFiles\Windows Defender\MpCmdRun.exe",
            "$env:ProgramFiles\Windows Defender\Platform\*\MpCmdRun.exe"
        )
        $mp = Get-ChildItem -Path $mpPaths -ErrorAction SilentlyContinue |
            Sort-Object LastWriteTime -Descending | Select-Object -First 1
        if ($mp) {
            Start-Process -FilePath $mp.FullName -ArgumentList "-Scan -ScanType 1" -Wait
        } else {
            Write-Host "Microsoft Defender não encontrado ou desativado." -ForegroundColor Yellow
        }
    }
}

function Run-DefenderFullScan {
    Write-Host "Iniciando verificação completa do Microsoft Defender..." -ForegroundColor Cyan
    $cmd = Get-Command -Name Start-MpScan -ErrorAction SilentlyContinue
    if ($cmd) {
        try { Start-MpScan -ScanType FullScan } catch { Write-Host "Erro ao usar Start-MpScan: $($_.Exception.Message)" -ForegroundColor Red }
    } else {
        $mpPaths = @(
            "$env:ProgramFiles\Windows Defender\MpCmdRun.exe",
            "$env:ProgramFiles\Windows Defender\Platform\*\MpCmdRun.exe"
        )
        $mp = Get-ChildItem -Path $mpPaths -ErrorAction SilentlyContinue |
            Sort-Object LastWriteTime -Descending | Select-Object -First 1
        if ($mp) {
            Start-Process -FilePath $mp.FullName -ArgumentList "-Scan -ScanType 2" -Wait
        } else {
            Write-Host "Microsoft Defender não encontrado ou desativado." -ForegroundColor Yellow
        }
    }
}

# ------------------ BLOCO: DIAGNÓSTICO ------------------

function Show-SystemInfo {
    Write-Host "Coletando informações do sistema..." -ForegroundColor Cyan
    try {
        $os   = Get-CimInstance Win32_OperatingSystem
        $cpu  = Get-CimInstance Win32_Processor | Select-Object -First 1
        $gpu  = Get-CimInstance Win32_VideoController | Select-Object -First 1
        $ramGB = [math]::Round($os.TotalVisibleMemorySize / 1MB, 1)
        $uptime = (Get-Date) - $os.LastBootUpTime
        $drives = Get-CimInstance Win32_LogicalDisk -Filter "DriveType=3"

        Write-Host "`n=== SISTEMA OPERACIONAL ===" -ForegroundColor Green
        Write-Host ("Windows : {0}" -f $os.Caption)
        Write-Host ("Versão  : {0}  (Build {1})" -f $os.Version, $os.BuildNumber)
        Write-Host ("Ligado há: {0}d {1}h {2}m" -f $uptime.Days, $uptime.Hours, $uptime.Minutes)

        Write-Host "`n=== HARDWARE PRINCIPAL ===" -ForegroundColor Green
        Write-Host ("CPU : {0}" -f $cpu.Name)
        Write-Host ("GPU : {0}" -f $gpu.Name)
        Write-Host ("RAM : {0} GB" -f $ramGB)

        Write-Host "`n=== ARMAZENAMENTO ===" -ForegroundColor Green
        foreach ($d in $drives) {
            $totalGB = [math]::Round($d.Size / 1GB, 1)
            $freeGB  = [math]::Round($d.FreeSpace / 1GB, 1)
            $usedGB  = $totalGB - $freeGB
            $statusColor = if ($freeGB -lt ($totalGB * 0.1)) { 'Red' } else { 'Green' }
            Write-Host ("{0} - Total {1} GB | Usado {2} GB | Livre {3} GB" -f $d.DeviceID, $totalGB, $usedGB, $freeGB) -ForegroundColor $statusColor
        }

        Write-Host "`n=== CONEXÃO (PING) ===" -ForegroundColor Green
        try {
            $g  = Test-Connection -ComputerName "google.com" -Count 1 -ErrorAction Stop
            $cf = Test-Connection -ComputerName "1.1.1.1" -Count 1 -ErrorAction Stop
            Write-Host ("Google    : {0} ms" -f $g.ResponseTime) -ForegroundColor Cyan
            Write-Host ("Cloudflare: {0} ms" -f $cf.ResponseTime) -ForegroundColor Cyan
        } catch {
            Write-Host "Não foi possível medir latência de rede." -ForegroundColor Yellow
        }
    } catch {
        Write-Host "Erro ao obter informações do sistema: $($_.Exception.Message)" -ForegroundColor Red
    }
}

function Open-DiagnosticsMenu {
    do {
        Show-Header
        Write-Host "=== DIAGNÓSTICO DO PC ===" -ForegroundColor Magenta
        Write-Host ""
        Write-Host " [1] Diagnóstico rápido no console" -ForegroundColor Cyan
        Write-Host " [2] Abrir 'Informações do Sistema' (msinfo32)" -ForegroundColor Cyan
        Write-Host " [3] Abrir 'Monitor de Recursos' (resmon)" -ForegroundColor Cyan
        Write-Host " [4] Abrir 'Ferramenta de Diagnóstico do DirectX' (dxdiag)" -ForegroundColor Cyan
        Write-Host ""
        Write-Host " [0] Voltar ao menu principal" -ForegroundColor Yellow
        Write-Host ""

        $opt = Read-Host "Escolha uma opção"
        switch ($opt) {
            "1" { Show-Header; Show-SystemInfo; Pause-MR }
            "2" { Start-Process msinfo32.exe; Pause-MR }
            "3" { Start-Process resmon.exe; Pause-MR }
            "4" { Start-Process dxdiag.exe; Pause-MR }
            "0" { return }
            default {
                Write-Host "Opção inválida." -ForegroundColor Red
                Pause-MR
            }
        }
    } while ($true)
}

# ------------------ BLOCO: GAMER ------------------

function Open-GamerMenu {
    do {
        Show-Header
        Write-Host "=== FERRAMENTAS GAMER ===" -ForegroundColor Magenta
        Write-Host ""
        Write-Host " [1] Modo desempenho máximo (energia + foco em jogos)" -ForegroundColor Cyan
        Write-Host " [2] Desativar Xbox Game Bar / DVR" -ForegroundColor Cyan
        Write-Host " [3] Otimizar rede para jogos (DNS Cloudflare)" -ForegroundColor Cyan
        Write-Host " [4] Restaurar algumas configurações gamer" -ForegroundColor Cyan
        Write-Host ""
        Write-Host " [0] Voltar ao menu principal" -ForegroundColor Yellow
        Write-Host ""

        $opt = Read-Host "Escolha uma opção"
        switch ($opt) {
            "1" {
                Write-Host "Ativando plano de energia de alto desempenho (quando disponível)..." -ForegroundColor Green
                try { powercfg -setactive SCHEME_MIN | Out-Null } catch { Write-Host "Não foi possível aplicar o plano de alto desempenho." -ForegroundColor Yellow }
                Pause-MR
            }
            "2" {
                Write-Host "Desativando Xbox Game Bar e DVR..." -ForegroundColor Green
                try {
                    New-Item -Path "HKCU:\SOFTWARE\Microsoft\GameBar" -Force | Out-Null
                    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\GameBar" -Name "ShowGameBar" -Value 0 -Type DWord -Force
                    New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR" -Force | Out-Null
                    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR" -Name "AllowGameDVR" -Value 0 -Type DWord -Force
                    Write-Host "Game Bar e gravação em segundo plano desativadas (reinicie os jogos)." -ForegroundColor Green
                } catch {
                    Write-Host "Falha ao ajustar Game Bar/DVR: $($_.Exception.Message)" -ForegroundColor Yellow
                }
                Pause-MR
            }
            "3" {
                Optimize-NetworkAndDNS
                Pause-MR
            }
            "4" {
                Write-Host "Restaurando configurações gamer para o padrão..." -ForegroundColor Green
                try {
                    Remove-Item "HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR" -Recurse -Force -ErrorAction SilentlyContinue
                    Write-Host "Políticas de Game DVR removidas. Ajuste o restante nas Configurações do Windows." -ForegroundColor Green
                } catch {
                    Write-Host "Falha ao restaurar configurações: $($_.Exception.Message)" -ForegroundColor Yellow
                }
                Pause-MR
            }
            "0" { return }
            default {
                Write-Host "Opção inválida." -ForegroundColor Red
                Pause-MR
            }
        }
    } while ($true)
}

# ------------------ BLOCO: FERRAMENTAS DO SISTEMA ------------------

function Open-SystemToolsMenu {
    do {
        Show-Header
        Write-Host "=== FERRAMENTAS DO SISTEMA ===" -ForegroundColor Magenta
        Write-Host ""
        Write-Host " [1] Criar ponto de restauração" -ForegroundColor Cyan
        Write-Host " [2] SFC /SCANNOW (arquivos de sistema)" -ForegroundColor Cyan
        Write-Host " [3] DISM /RestoreHealth (reparo da imagem)" -ForegroundColor Cyan
        Write-Host " [4] CHKDSK /scan (verificar disco C:)" -ForegroundColor Cyan
        Write-Host " [5] Reset básico do Windows Update" -ForegroundColor Cyan
        Write-Host " [6] Ver informações avançadas do sistema" -ForegroundColor Cyan
        Write-Host ""
        Write-Host " [0] Voltar ao menu principal" -ForegroundColor Yellow
        Write-Host ""

        $opt = Read-Host "Escolha uma opção"
        switch ($opt) {
            "1" { Show-Header; Create-RestorePoint; Pause-MR }
            "2" { Show-Header; Run-SFC; Pause-MR }
            "3" { Show-Header; Run-DISMRepair; Pause-MR }
            "4" { Show-Header; Run-CHKDSKScan; Pause-MR }
            "5" {
                Show-Header
                Write-Host "Reiniciando componentes principais do Windows Update..." -ForegroundColor Green
                try {
                    net stop wuauserv bits cryptsvc /y | Out-Null
                    Remove-Item "$env:WINDIR\SoftwareDistribution\Download\*" -Recurse -Force -ErrorAction SilentlyContinue
                    net start wuauserv bits cryptsvc | Out-Null
                    Write-Host "Reset básico concluído. Verifique por atualizações novamente." -ForegroundColor Green
                } catch {
                    Write-Host "Falha ao resetar Windows Update: $($_.Exception.Message)" -ForegroundColor Yellow
                }
                Pause-MR
            }
            "6" { Show-Header; Show-SystemInfo; Pause-MR }
            "0" { return }
            default {
                Write-Host "Opção inválida." -ForegroundColor Red
                Pause-MR
            }
        }
    } while ($true)
}

# ------------------ BLOCO: ATIVADOR WINDOWS / OFFICE ------------------

function Open-ActivatorMenu {
    do {
        Show-Header
        Write-Host "=== ATIVADOR WINDOWS / OFFICE ===" -ForegroundColor Magenta
        Write-Host ""
        Write-Host "Este módulo usa o projeto MAS (Microsoft Activation Scripts)," -ForegroundColor Gray
        Write-Host "repositório open-source oficial:" -ForegroundColor Gray
        Write-Host "  https://github.com/massgravel/Microsoft-Activation-Scripts" -ForegroundColor DarkCyan
        Write-Host ""
        Write-Host " [1] Abrir MAS (irm https://get.activated.win | iex)" -ForegroundColor Cyan
        Write-Host " [2] Ver status de ativação do Windows" -ForegroundColor Cyan
        Write-Host " [3] Abrir página do MAS no navegador" -ForegroundColor Cyan
        Write-Host ""
        Write-Host " [0] Voltar ao menu principal" -ForegroundColor Yellow
        Write-Host ""

        $opt = Read-Host "Escolha uma opção"
        switch ($opt) {
            "1" {
                Show-Header
                Write-Host "Chamando o MAS..." -ForegroundColor Green
                try { irm "https://get.activated.win" | iex } catch { Write-Host "Falha ao chamar o MAS: $($_.Exception.Message)" -ForegroundColor Red; Pause-MR }
            }
            "2" {
                Show-Header
                Write-Host "Verificando status de ativação do Windows..." -ForegroundColor Green
                try { slmgr /xpr } catch { Write-Host "Falha ao consultar slmgr." -ForegroundColor Yellow }
                Pause-MR
            }
            "3" {
                Start-Process "https://github.com/massgravel/Microsoft-Activation-Scripts"
                Pause-MR
            }
            "0" { return }
            default {
                Write-Host "Opção inválida." -ForegroundColor Red
                Pause-MR
            }
        }
    } while ($true)
}

# ------------------ BLOCO: EXTRAS ------------------

function Open-ExtrasMenu {
    do {
        Show-Header
        Write-Host "=== UTILITÁRIOS EXTRAS ===" -ForegroundColor Magenta
        Write-Host ""
        Write-Host " [1] Limpeza de Disco (cleanmgr)" -ForegroundColor Cyan
        Write-Host " [2] Configurações de Armazenamento" -ForegroundColor Cyan
        Write-Host " [3] Gerenciador de Tarefas (Inicialização)" -ForegroundColor Cyan
        Write-Host " [4] Programas e Recursos (desinstalar apps)" -ForegroundColor Cyan
        Write-Host " [5] Segurança do Windows" -ForegroundColor Cyan
        Write-Host " [6] Propriedades de Desempenho (efeitos visuais)" -ForegroundColor Cyan
        Write-Host ""
        Write-Host " [0] Voltar ao menu principal" -ForegroundColor Yellow
        Write-Host ""

        $opt = Read-Host "Escolha uma opção"
        switch ($opt) {
            "1" { Start-Process cleanmgr.exe }
            "2" { Start-Process "ms-settings:storage" }
            "3" { Start-Process taskmgr.exe }
            "4" { Start-Process appwiz.cpl }
            "5" { Start-Process "windowsdefender:" }
            "6" { Start-Process SystemPropertiesPerformance.exe }
            "0" { return }
            default {
                Write-Host "Opção inválida." -ForegroundColor Red
                Pause-MR
            }
        }
    } while ($true)
}

# ------------------ LOOP PRINCIPAL ------------------

do {
    Show-MainMenu
    $choice = Read-Host "Digite o número da opção desejada"

    switch ($choice) {
        "1" { Open-OptimizeMenu }
        "2" { Open-ActivatorMenu }
        "3" { Open-GamerMenu }
        "4" { Open-SystemToolsMenu }
        "5" { Open-DiagnosticsMenu }
        "6" { Open-ExtrasMenu }
        "0" { break }
        default {
            Write-Host "Opção inválida. Digite um número do menu." -ForegroundColor Red
            Pause-MR
        }
    }
} while ($true)

Write-Host ""
Write-Host "Obrigado por usar o Mr Evan Intelligent Repair System!" -ForegroundColor Cyan
Write-Host "Fechando..." -ForegroundColor DarkGray
Start-Sleep -Seconds 1

<# 
  Mr Evan Intelligent Repair System
  Console avançado de manutenção e otimização para Windows 10 e 11.
  Autor: MR EVAN + IA
#>

$ErrorActionPreference = "Stop"
$MRIRS_Version         = "v2.0.0"

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
    if ($resp -match '^[sS]') {
        $scriptPath = $MyInvocation.MyCommand.Path
        if (-not $scriptPath) {
            Write-Host "Não foi possível localizar o caminho do script. Execute manualmente como administrador." -ForegroundColor Red
            pause
            exit
        }
        $argList = "-NoProfile -ExecutionPolicy Bypass -File `"$scriptPath`""
        Start-Process powershell.exe -ArgumentList $argList -Verb RunAs
        exit
    }
}

function Pause-MR {
    param(
        [string]$Mensagem = "Pressione qualquer tecla para voltar ao menu..."
    )
    Write-Host ""
    Write-Host $Mensagem -ForegroundColor DarkGray
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}

function Write-Separator {
    param([int]$Width = 80)
    Write-Host ("-" * $Width) -ForegroundColor DarkGray
}

function Show-Header {
    Clear-Host
    $width = 80

    Write-Host ""
    Write-Host "   ████╗  ██████╗      ███████╗██╗   ██╗ █████╗ ███╗  ██╗" -ForegroundColor Cyan
    Write-Host "  ██╔═██╗██╔════╝      ██╔════╝██║   ██║██╔══██╗████╗ ██║" -ForegroundColor Cyan
    Write-Host "  █████╔╝██║  ███╗     █████╗  ██║   ██║███████║██╔██╗██║" -ForegroundColor Cyan
    Write-Host "  ██╔═██╗██║   ██║     ██╔══╝  ██║   ██║██╔══██║██║╚████║" -ForegroundColor Cyan
    Write-Host "  ██║  ██╗╚██████╔╝    ██║     ╚██████╔╝██║  ██║██║ ╚███║" -ForegroundColor Cyan
    Write-Host "  ╚═╝  ╚═╝ ╚═════╝     ╚═╝      ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚══╝" -ForegroundColor Cyan
    Write-Host ""

    $center = { param($text, $color)
        $pad = [math]::Max(0, [math]::Floor(($width - $text.Length) / 2))
        Write-Host (" " * $pad + $text) -ForegroundColor $color
    }

    & $center "Mr Evan" 'Red'
    & $center "Intelligent Repair System" 'Red'
    Write-Host ""
    & $center ("Versão $MRIRS_Version  |  Windows 10/11") 'Gray'
    Write-Host ""
    Write-Separator -Width $width
    & $center "Use os números para navegar. 0 sempre volta/sai." 'Gray'
    Write-Separator -Width $width
    Write-Host ""
}

function Show-MainMenu {
    Show-Header

    Write-Host " [1] OTIMIZAR AGORA        " -ForegroundColor Cyan -NoNewline
    Write-Host " [LIMPEZA]" -ForegroundColor Green

    Write-Host " [2] WINDOWS / OFFICE      " -ForegroundColor Cyan -NoNewline
    Write-Host " [ATIVADOR]" -ForegroundColor DarkMagenta

    Write-Host " [3] FERRAMENTAS GAMER     " -ForegroundColor Cyan -NoNewline
    Write-Host " [GAMER]" -ForegroundColor Magenta

    Write-Host " [4] FERRAMENTAS SISTEMA   " -ForegroundColor Cyan -NoNewline
    Write-Host " [SISTEMA]" -ForegroundColor Yellow

    Write-Host " [5] DIAGNÓSTICO DO PC     " -ForegroundColor Cyan -NoNewline
    Write-Host " [INFO]" -ForegroundColor Blue

    Write-Host " [6] UTILITÁRIOS EXTRAS    " -ForegroundColor Cyan -NoNewline
    Write-Host " [EXTRAS]" -ForegroundColor DarkCyan

    Write-Host ""
    Write-Host " [0] SAIR DO MR EVAN IRS   " -ForegroundColor Red
    Write-Host ""
}

function Clear-TempFiles {
    Write-Host "Limpando arquivos temporários..." -ForegroundColor Green

    $paths = @(
        $env:TEMP,
        "$env:WINDIR\Temp",
        "$env:WINDIR\Prefetch",
        "$env:LOCALAPPDATA\Temp",
        "$env:LOCALAPPDATA\Microsoft\Windows\INetCache",
        "$env:LOCALAPPDATA\Microsoft\Windows\Explorer"
    )

    foreach ($p in $paths) {
        try {
            if (Test-Path $p) {
                Write-Host " - Limpando: $p" -ForegroundColor DarkGray
                Get-ChildItem -Path $p -Recurse -Force -ErrorAction SilentlyContinue |
                    Remove-Item -Force -Recurse -ErrorAction SilentlyContinue
            }
        } catch {
            Write-Host "   Falha ao limpar $p : $($_.Exception.Message)" -ForegroundColor DarkYellow
        }
    }

    try {
        Write-Host " - Esvaziando Lixeira..." -ForegroundColor DarkGray
        Clear-RecycleBin -Force -ErrorAction SilentlyContinue
    } catch {
        Write-Host "   Não foi possível esvaziar a Lixeira: $($_.Exception.Message)" -ForegroundColor DarkYellow
    }
}

function Clear-BrowserCaches {
    Write-Host "Limpando cache de navegadores..." -ForegroundColor Green

    $browserPaths = @(
        "$env:LOCALAPPDATA\Google\Chrome\User Data\*\Cache",
        "$env:LOCALAPPDATA\Microsoft\Edge\User Data\*\Cache",
        "$env:APPDATA\Mozilla\Firefox\Profiles\*\cache2",
        "$env:APPDATA\Opera Software\Opera Stable\Cache",
        "$env:LOCALAPPDATA\BraveSoftware\Brave-Browser\User Data\*\Cache"
    )

    foreach ($pattern in $browserPaths) {
        Get-ChildItem -Path $pattern -Force -Recurse -ErrorAction SilentlyContinue | ForEach-Object {
            try {
                Remove-Item $_.FullName -Recurse -Force -ErrorAction SilentlyContinue
            } catch {
            }
        }
    }
}

function Clear-DeepWindowsStuff {
    Write-Host "Limpando componentes avançados do Windows..." -ForegroundColor Green

    $wuPath = "$env:WINDIR\SoftwareDistribution\Download"
    if (Test-Path $wuPath) {
        try {
            Write-Host " - Limpando cache de Windows Update..." -ForegroundColor DarkGray
            Get-ChildItem $wuPath -Recurse -Force -ErrorAction SilentlyContinue |
                Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
        } catch {
            Write-Host "   Erro ao limpar SoftwareDistribution: $($_.Exception.Message)" -ForegroundColor DarkYellow
        }
    }

    $logPaths = @(
        "$env:WINDIR\Logs",
        "$env:ProgramData\Microsoft\Windows\WER\ReportArchive",
        "$env:ProgramData\Microsoft\Windows\WER\ReportQueue"
    )
    foreach ($lp in $logPaths) {
        if (Test-Path $lp) {
            try {
                Write-Host " - Limpando logs: $lp" -ForegroundColor DarkGray
                Get-ChildItem $lp -Recurse -Force -ErrorAction SilentlyContinue |
                    Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
            } catch {
                Write-Host "   Erro ao limpar $lp : $($_.Exception.Message)" -ForegroundColor DarkYellow
            }
        }
    }

    try {
        Write-Host "`nIniciando DISM /StartComponentCleanup (pode demorar)..." -ForegroundColor Cyan
        DISM.exe /Online /Cleanup-Image /StartComponentCleanup | Out-Null
        Write-Host "DISM /StartComponentCleanup concluído." -ForegroundColor Green
    } catch {
        Write-Host "Falha ao executar DISM: $($_.Exception.Message)" -ForegroundColor Red
    }
}

function Optimize-NetworkAndDNS {
    Write-Host "Otimizando DNS e cache de rede..." -ForegroundColor Green
    try {
        ipconfig /flushdns | Out-Null
        Write-Host " - DNS limpo (ipconfig /flushdns)." -ForegroundColor DarkGray
    } catch {
        Write-Host "   Falha ao limpar DNS: $($_.Exception.Message)" -ForegroundColor DarkYellow
    }

    try {
        $adapters = Get-DnsClientServerAddress -AddressFamily IPv4 -ErrorAction SilentlyContinue |
            Where-Object { $_.ServerAddresses }
        foreach ($ad in $adapters) {
            Write-Host (" - Ajustando DNS de {0} para 1.1.1.1 / 1.0.0.1" -f $ad.InterfaceAlias) -ForegroundColor DarkGray
            Set-DnsClientServerAddress -InterfaceIndex $ad.InterfaceIndex -ServerAddresses @("1.1.1.1", "1.0.0.1") -ErrorAction SilentlyContinue
        }
    } catch {
        Write-Host "   Não foi possível ajustar DNS automaticamente: $($_.Exception.Message)" -ForegroundColor DarkYellow
    }
}

function Run-SFC {
    Write-Host "Executando verificação de arquivos do sistema (SFC /SCANNOW)..." -ForegroundColor Cyan
    Write-Host "Isso pode levar vários minutos. Aguarde até 100%." -ForegroundColor DarkGray
    try {
        sfc.exe /scannow
    } catch {
        Write-Host "Erro ao executar SFC: $($_.Exception.Message)" -ForegroundColor Red
    }
}

function Run-DISMRepair {
    Write-Host "Executando reparo da imagem do Windows (DISM /RestoreHealth)..." -ForegroundColor Cyan
    Write-Host "Isso também pode levar bastante tempo. Aguarde." -ForegroundColor DarkGray
    try {
        DISM.exe /Online /Cleanup-Image /RestoreHealth
    } catch {
        Write-Host "Erro ao executar DISM: $($_.Exception.Message)" -ForegroundColor Red
    }
}

function Run-CHKDSKScan {
    Write-Host "Verificando disco do sistema com CHKDSK /scan..." -ForegroundColor Cyan
    Write-Host "Esta verificação é online (sem reiniciar). Para reparos completos use CHKDSK /F manualmente." -ForegroundColor DarkGray
    try {
        chkdsk C: /scan
    } catch {
        Write-Host "Erro ao executar CHKDSK: $($_.Exception.Message)" -ForegroundColor Red
    }
}

function Create-RestorePoint {
    Write-Host "Criando ponto de restauração (se o recurso estiver ativado)..." -ForegroundColor Cyan
    try {
        Checkpoint-Computer -Description "Mr Evan IRS" -RestorePointType "MODIFY_SETTINGS"
        Write-Host "Ponto de restauração solicitado." -ForegroundColor Green
    } catch {
        Write-Host "Não foi possível criar o ponto de restauração: $($_.Exception.Message)" -ForegroundColor Yellow
    }
}

function Run-DefenderQuickScan {
    Write-Host "Iniciando verificação rápida do Microsoft Defender..." -ForegroundColor Cyan

    $cmd = Get-Command -Name Start-MpScan -ErrorAction SilentlyContinue
    if ($cmd) {
        try {
            Start-MpScan -ScanType QuickScan
        } catch {
            Write-Host "Erro ao usar Start-MpScan: $($_.Exception.Message)" -ForegroundColor Red
        }
    } else {
        $mpPaths = @(
            "$env:ProgramFiles\Windows Defender\MpCmdRun.exe",
            "$env:ProgramFiles\Windows Defender\Platform\*\MpCmdRun.exe"
        )
        $mp = Get-ChildItem -Path $mpPaths -ErrorAction SilentlyContinue |
            Sort-Object LastWriteTime -Descending | Select-Object -First 1
        if ($mp) {
            Start-Process -FilePath $mp.FullName -ArgumentList "-Scan -ScanType 1" -Wait
        } else {
            Write-Host "Microsoft Defender não encontrado ou desativado." -ForegroundColor Yellow
        }
    }
}

function Run-DefenderFullScan {
    Write-Host "Iniciando verificação completa do Microsoft Defender..." -ForegroundColor Cyan
    $cmd = Get-Command -Name Start-MpScan -ErrorAction SilentlyContinue
    if ($cmd) {
        try {
            Start-MpScan -ScanType FullScan
        } catch {
            Write-Host "Erro ao usar Start-MpScan: $($_.Exception.Message)" -ForegroundColor Red
        }
    } else {
        $mpPaths = @(
            "$env:ProgramFiles\Windows Defender\MpCmdRun.exe",
            "$env:ProgramFiles\Windows Defender\Platform\*\MpCmdRun.exe"
        )
        $mp = Get-ChildItem -Path $mpPaths -ErrorAction SilentlyContinue |
            Sort-Object LastWriteTime -Descending | Select-Object -First 1
        if ($mp) {
            Start-Process -FilePath $mp.FullName -ArgumentList "-Scan -ScanType 2" -Wait
        } else {
            Write-Host "Microsoft Defender não encontrado ou desativado." -ForegroundColor Yellow
        }
    }
}

function Show-SystemInfo {
    Write-Host "Coletando informações do sistema..." -ForegroundColor Cyan
    try {
        $os   = Get-CimInstance Win32_OperatingSystem
        $cpu  = Get-CimInstance Win32_Processor | Select-Object -First 1
        $gpu  = Get-CimInstance Win32_VideoController | Select-Object -First 1
        $ramGB = [math]::Round($os.TotalVisibleMemorySize / 1MB, 1)
        $uptime = (Get-Date) - $os.LastBootUpTime

        $drives = Get-CimInstance Win32_LogicalDisk -Filter "DriveType=3"

        Write-Host "`n=== SISTEMA OPERACIONAL ===" -ForegroundColor Green
        Write-Host ("Windows : {0}" -f $os.Caption)
        Write-Host ("Versão  : {0}  (Build {1})" -f $os.Version, $os.BuildNumber)
        Write-Host ("Ligado há: {0}d {1}h {2}m" -f $uptime.Days, $uptime.Hours, $uptime.Minutes)

        Write-Host "`n=== HARDWARE PRINCIPAL ===" -ForegroundColor Green
        Write-Host ("CPU : {0}" -f $cpu.Name)
        Write-Host ("GPU : {0}" -f $gpu.Name)
        Write-Host ("RAM : {0} GB" -f $ramGB)

        Write-Host "`n=== ARMAZENAMENTO ===" -ForegroundColor Green
        foreach ($d in $drives) {
            $totalGB = [math]::Round($d.Size / 1GB, 1)
            $freeGB  = [math]::Round($d.FreeSpace / 1GB, 1)
            $usedGB  = $totalGB - $freeGB
            $statusColor = if ($freeGB -lt ($totalGB * 0.1)) { 'Red' } else { 'Green' }
            Write-Host ("{0} - Total {1} GB | Usado {2} GB | Livre {3} GB" -f $d.DeviceID, $totalGB, $usedGB, $freeGB) -ForegroundColor $statusColor
        }

        Write-Host "`n=== CONEXÃO (PING) ===" -ForegroundColor Green
        try {
            $g  = Test-Connection -ComputerName "google.com" -Count 1 -ErrorAction Stop
            $cf = Test-Connection -ComputerName "1.1.1.1" -Count 1 -ErrorAction Stop
            Write-Host ("Google    : {0} ms" -f $g.ResponseTime) -ForegroundColor Cyan
            Write-Host ("Cloudflare: {0} ms" -f $cf.ResponseTime) -ForegroundColor Cyan
        } catch {
            Write-Host "Não foi possível medir latência de rede." -ForegroundColor Yellow
        }
    } catch {
        Write-Host "Erro ao obter informações do sistema: $($_.Exception.Message)" -ForegroundColor Red
    }
}

function Open-ExtrasMenu {
    do {
        Show-Header
        Write-Host "=== UTILITÁRIOS EXTRAS ===" -ForegroundColor Magenta
        Write-Host ""
        Write-Host " [1] Limpeza de Disco (cleanmgr)" -ForegroundColor Cyan
        Write-Host " [2] Configurações de Armazenamento" -ForegroundColor Cyan
        Write-Host " [3] Gerenciador de Tarefas (Inicialização)" -ForegroundColor Cyan
        Write-Host " [4] Programas e Recursos (desinstalar apps)" -ForegroundColor Cyan
        Write-Host " [5] Segurança do Windows" -ForegroundColor Cyan
        Write-Host " [6] Propriedades de Desempenho (efeitos visuais)" -ForegroundColor Cyan
        Write-Host ""
        Write-Host " [0] Voltar ao menu principal" -ForegroundColor Yellow
        Write-Host ""

        $opt = Read-Host "Escolha uma opção"
        switch ($opt) {
            "1" { Start-Process cleanmgr.exe }
            "2" { Start-Process "ms-settings:storage" }
            "3" { Start-Process taskmgr.exe }
            "4" { Start-Process appwiz.cpl }
            "5" { Start-Process "windowsdefender:" }
            "6" { Start-Process SystemPropertiesPerformance.exe }
            "0" { return }
            default {
                Write-Host "Opção inválida." -ForegroundColor Red
                Pause-MR
            }
        }
    } while ($true)
}

function Optimize-Now {
    Show-Header
    Write-Host "=== OTIMIZAÇÃO COMPLETA ===" -ForegroundColor Magenta
    Write-Host ""
    Write-Host " - Limpeza de arquivos temporários e lixeira" -ForegroundColor Gray
    Write-Host " - Limpeza de caches de navegador e Windows Update" -ForegroundColor Gray
    Write-Host " - Otimização básica de DNS e cache de rede" -ForegroundColor Gray
    Write-Host ""

    $c = Read-Host "Confirmar otimização agora? (S/N)"
    if ($c -notmatch '^[sS]') {
        Write-Host "Otimização cancelada." -ForegroundColor Yellow
        Pause-MR
        return
    }

    $totalMB = 0

    try {
        $before = Get-PSDrive C | Select-Object -ExpandProperty Free
    } catch {
        $before = $null
    }

    Clear-TempFiles
    Clear-BrowserCaches
    Clear-DeepWindowsStuff
    Optimize-NetworkAndDNS

    try {
        $after = Get-PSDrive C | Select-Object -ExpandProperty Free
        if ($before -and $after) {
            $totalMB = [math]::Round(($after - $before) / 1MB, 2)
        }
    } catch {
    }

    Write-Host ""
    Write-Separator
    Write-Host "RESUMO DA OTIMIZAÇÃO" -ForegroundColor Green
    if ($totalMB -gt 0) {
        Write-Host ("Espaço total liberado: {0} MB" -f $totalMB) -ForegroundColor Green
    } else {
        Write-Host "Espaço liberado: cálculo indisponível (mas a faxina foi feita)." -ForegroundColor Green
    }
    Write-Host "Sistema limpo, cache renovado e rede otimizada." -ForegroundColor Green
    Write-Separator
    Pause-MR
}

function Open-ActivatorMenu {
    Show-Header
    Write-Host "=== ATIVADOR WINDOWS / OFFICE ===" -ForegroundColor Magenta
    Write-Host ""
    Write-Host "Este módulo usa o projeto MAS (Microsoft Activation Scripts)," -ForegroundColor Gray
    Write-Host "repositório open-source oficial:" -ForegroundColor Gray
    Write-Host "  https://github.com/massgravel/Microsoft-Activation-Scripts" -ForegroundColor DarkCyan
    Write-Host ""
    Write-Host "O script será chamado pelo comando recomendado:" -ForegroundColor Gray
    Write-Host "  irm https://get.activated.win | iex" -ForegroundColor Cyan
    Write-Host ""

    $c = Read-Host "Deseja abrir o ativador MAS agora? (S/N)"
    if ($c -match '^[sS]') {
        try {
            irm "https://get.activated.win" | iex
        } catch {
            Write-Host "Falha ao chamar o MAS: $($_.Exception.Message)" -ForegroundColor Red
            Pause-MR
        }
    } else {
        Write-Host "Ativador cancelado." -ForegroundColor Yellow
        Pause-MR
    }
}

function Apply-GamerTweaks {
    Show-Header
    Write-Host "=== FERRAMENTAS GAMER ===" -ForegroundColor Magenta
    Write-Host ""
    Write-Host " [1] Modo desempenho máximo (energia + foco em jogos)" -ForegroundColor Cyan
    Write-Host " [2] Desativar Xbox Game Bar / DVR" -ForegroundColor Cyan
    Write-Host " [3] Otimizar rede para jogos (DNS Cloudflare)" -ForegroundColor Cyan
    Write-Host " [4] Restaurar algumas configurações padrão" -ForegroundColor Cyan
    Write-Host ""
    Write-Host " [0] Voltar ao menu principal" -ForegroundColor Yellow
    Write-Host ""

    $opt = Read-Host "Escolha uma opção"
    switch ($opt) {
        "1" {
            Write-Host "Ativando plano de energia de alto desempenho (quando disponível)..." -ForegroundColor Green
            try {
                powercfg -setactive SCHEME_MIN | Out-Null
            } catch {
                Write-Host "Não foi possível aplicar o plano de alto desempenho." -ForegroundColor Yellow
            }
            Pause-MR
        }
        "2" {
            Write-Host "Desativando Xbox Game Bar e DVR..." -ForegroundColor Green
            try {
                New-Item -Path "HKCU:\SOFTWARE\Microsoft\GameBar" -Force | Out-Null
                Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\GameBar" -Name "ShowGameBar" -Value 0 -Type DWord -Force
                New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR" -Force | Out-Null
                Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR" -Name "AllowGameDVR" -Value 0 -Type DWord -Force
                Write-Host "Game Bar e gravação em segundo plano desativadas (reinicie os jogos)." -ForegroundColor Green
            } catch {
                Write-Host "Falha ao ajustar Game Bar/DVR: $($_.Exception.Message)" -ForegroundColor Yellow
            }
            Pause-MR
        }
        "3" {
            Optimize-NetworkAndDNS
            Pause-MR
        }
        "4" {
            Write-Host "Restaurando algumas configurações gamer para o padrão..." -ForegroundColor Green
            try {
                Remove-Item "HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR" -Recurse -Force -ErrorAction SilentlyContinue
                Write-Host "Políticas de Game DVR removidas (use a Configurações do Windows para ajustar o resto)." -ForegroundColor Green
            } catch {
                Write-Host "Falha ao restaurar configurações: $($_.Exception.Message)" -ForegroundColor Yellow
            }
            Pause-MR
        }
        "0" { return }
        default {
            Write-Host "Opção inválida." -ForegroundColor Red
            Pause-MR
        }
    }
}

function Open-SystemToolsMenu {
    do {
        Show-Header
        Write-Host "=== FERRAMENTAS DO SISTEMA ===" -ForegroundColor Magenta
        Write-Host ""
        Write-Host " [1] Criar ponto de restauração" -ForegroundColor Cyan
        Write-Host " [2] SFC /SCANNOW (arquivos de sistema)" -ForegroundColor Cyan
        Write-Host " [3] DISM /RestoreHealth (reparo da imagem)" -ForegroundColor Cyan
        Write-Host " [4] CHKDSK /scan (verificar disco C:)" -ForegroundColor Cyan
        Write-Host " [5] Reset básico do Windows Update" -ForegroundColor Cyan
        Write-Host " [6] Mostrar informações avançadas do sistema" -ForegroundColor Cyan
        Write-Host ""
        Write-Host " [0] Voltar ao menu principal" -ForegroundColor Yellow
        Write-Host ""

        $opt = Read-Host "Escolha uma opção"
        switch ($opt) {
            "1" { Create-RestorePoint; Pause-MR }
            "2" { Run-SFC; Pause-MR }
            "3" { Run-DISMRepair; Pause-MR }
            "4" { Run-CHKDSKScan; Pause-MR }
            "5" {
                Write-Host "Reiniciando componentes principais do Windows Update..." -ForegroundColor Green
                try {
                    net stop wuauserv bits cryptsvc /y | Out-Null
                    Remove-Item "$env:WINDIR\SoftwareDistribution\Download\*" -Recurse -Force -ErrorAction SilentlyContinue
                    net start wuauserv bits cryptsvc | Out-Null
                    Write-Host "Reset básico concluído. Verifique por atualizações novamente." -ForegroundColor Green
                } catch {
                    Write-Host "Falha ao resetar Windows Update: $($_.Exception.Message)" -ForegroundColor Yellow
                }
                Pause-MR
            }
            "6" { Show-SystemInfo; Pause-MR }
            "0" { return }
            default {
                Write-Host "Opção inválida." -ForegroundColor Red
                Pause-MR
            }
        }
    } while ($true)
}

function Open-DiagnosticsMenu {
    Show-Header
    Write-Host "=== DIAGNÓSTICO RÁPIDO DO PC ===" -ForegroundColor Magenta
    Show-SystemInfo
    Pause-MR
}

do {
    Show-MainMenu
    $choice = Read-Host "Digite o número da opção desejada"

    switch ($choice) {
        "1" { Optimize-Now }
        "2" { Open-ActivatorMenu }
        "3" { Apply-GamerTweaks }
        "4" { Open-SystemToolsMenu }
        "5" { Open-DiagnosticsMenu }
        "6" { Open-ExtrasMenu }
        "0" { break }
        default {
            Write-Host "Opção inválida. Digite um número do menu." -ForegroundColor Red
            Pause-MR
        }
    }
} while ($true)

Write-Host ""
Write-Host "Obrigado por usar o Mr Evan Intelligent Repair System!" -ForegroundColor Cyan
Write-Host "Fechando..." -ForegroundColor DarkGray
Start-Sleep -Seconds 1

<# 
    MR EVAN TOOLKIT - Painel de Manutenção Windows 10/11
    Autor: Você + IA
    Objetivo: Limpeza, reparos e utilidades em um único painel.
#>

# ------------------ CONFIGURAÇÕES INICIAIS ------------------

# Força saída imediata se der erro inesperado
$ErrorActionPreference = "Stop"

# Detecta se está em modo administrador
function Test-IsAdmin {
    try {
        $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
        $principal   = New-Object Security.Principal.WindowsPrincipal($currentUser)
        return $principal.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
    } catch {
        return $false
    }
}

# Auto-elevar se não for admin
if (-not (Test-IsAdmin)) {
    Write-Host "Este painel funciona melhor em modo ADMINISTRADOR." -ForegroundColor Yellow
    $resp = Read-Host "Deseja reabrir automaticamente como Administrador? (S/N)"
    if ($resp -match '^[sS]') {
        $scriptPath = $MyInvocation.MyCommand.Path
        if (-not $scriptPath) {
            Write-Host "Não foi possível localizar o caminho do script. Execute manualmente como administrador." -ForegroundColor Red
            pause
            exit
        }
        $argList = "-NoProfile -ExecutionPolicy Bypass -File `"$scriptPath`""
        Start-Process powershell.exe -ArgumentList $argList -Verb RunAs
        exit
    }
}

# Função de pausa amigável
function Pause-MR {
    param(
        [string]$Mensagem = "Pressione qualquer tecla para voltar ao menu..."
    )
    Write-Host ""
    Write-Host $Mensagem -ForegroundColor DarkGray
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}

# ------------------ VISUAL / CABEÇALHO ------------------

function Show-Header {
    Clear-Host
    $width = 70

    $linha = ("═" * ($width - 2))
    Write-Host ("╔{0}╗" -f $linha) -ForegroundColor DarkCyan

    $titulo = " MR EVAN TOOLKIT "
    $espacos = $width - 2 - $titulo.Length
    $esq = [int]([math]::Floor($espacos / 2))
    $dir = $espacos - $esq
    $linhaTitulo = (" " * $esq) + $titulo + (" " * $dir)
    Write-Host ("║{0}║" -f $linhaTitulo) -ForegroundColor DarkCyan

    Write-Host ("╚{0}╝" -f $linha) -ForegroundColor DarkCyan
    Write-Host ""
    Write-Host "  Painel avançado de manutenção para Windows 10 e 11" -ForegroundColor Gray
    Write-Host "  Use os números para escolher uma opção. 0 sempre volta/sai." -ForegroundColor Gray
    Write-Host ""
}

function Show-MainMenu {
    Show-Header
    Write-Host " [1] Limpeza rápida" -ForegroundColor Cyan
    Write-Host " [2] Limpeza profunda" -ForegroundColor Cyan
    Write-Host " [3] Reparos do sistema" -ForegroundColor Cyan
    Write-Host " [4] Segurança / Anti-vírus (Defender)" -ForegroundColor Cyan
    Write-Host " [5] Informações do PC" -ForegroundColor Cyan
    Write-Host " [6] Ferramentas extras do Windows" -ForegroundColor Cyan
    Write-Host ""
    Write-Host " [0] Sair do MR EVAN" -ForegroundColor Yellow
    Write-Host ""
}

# ------------------ FUNÇÕES DE LIMPEZA ------------------

function Clear-TempFiles {
    Write-Host "Limpando arquivos temporários..." -ForegroundColor Green

    $paths = @(
        $env:TEMP,
        "$env:WINDIR\Temp",
        "$env:WINDIR\Prefetch",
        "$env:LOCALAPPDATA\Temp",
        "$env:LOCALAPPDATA\Microsoft\Windows\INetCache",
        "$env:LOCALAPPDATA\Microsoft\Windows\Explorer"
    )

    foreach ($p in $paths) {
        try {
            if (Test-Path $p) {
                Write-Host " - Limpando: $p" -ForegroundColor DarkGray
                Get-ChildItem -Path $p -Recurse -Force -ErrorAction SilentlyContinue | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue
            }
        } catch {
            Write-Host "   Falha ao limpar $p : $($_.Exception.Message)" -ForegroundColor DarkYellow
        }
    }

    # Esvazia Lixeira
    try {
        Write-Host " - Esvaziando Lixeira..." -ForegroundColor DarkGray
        Clear-RecycleBin -Force -ErrorAction SilentlyContinue
    } catch {
        Write-Host "   Não foi possível esvaziar a Lixeira: $($_.Exception.Message)" -ForegroundColor DarkYellow
    }

    Write-Host "`nLimpeza rápida concluída." -ForegroundColor Green
}

function Clear-BrowserCaches {
    Write-Host "Limpando cache de navegadores..." -ForegroundColor Green

    $browserPaths = @(
        "$env:LOCALAPPDATA\Google\Chrome\User Data\*\Cache",
        "$env:LOCALAPPDATA\Microsoft\Edge\User Data\*\Cache",
        "$env:APPDATA\Mozilla\Firefox\Profiles\*\cache2",
        "$env:APPDATA\Opera Software\Opera Stable\Cache",
        "$env:LOCALAPPDATA\BraveSoftware\Brave-Browser\User Data\*\Cache"
    )

    foreach ($pattern in $browserPaths) {
        Get-ChildItem -Path $pattern -Force -Recurse -ErrorAction SilentlyContinue | ForEach-Object {
            try {
                Remove-Item $_.FullName -Recurse -Force -ErrorAction SilentlyContinue
            } catch {
                # ignora arquivos em uso
            }
        }
    }

    Write-Host "`nCaches de navegadores limpos (quando encontrados)." -ForegroundColor Green
}

function Clear-DeepWindowsStuff {
    Write-Host "Limpeza profunda de componentes do Windows..." -ForegroundColor Green

    # Limpa cache de atualizações do Windows
    $wuPath = "$env:WINDIR\SoftwareDistribution\Download"
    if (Test-Path $wuPath) {
        try {
            Write-Host " - Limpando cache de Windows Update..." -ForegroundColor DarkGray
            Get-ChildItem $wuPath -Recurse -Force -ErrorAction SilentlyContinue | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
        } catch {
            Write-Host "   Erro ao limpar SoftwareDistribution: $($_.Exception.Message)" -ForegroundColor DarkYellow
        }
    }

    # Limpa arquivos de logs e relatórios de erro
    $logPaths = @(
        "$env:WINDIR\Logs",
        "$env:ProgramData\Microsoft\Windows\WER\ReportArchive",
        "$env:ProgramData\Microsoft\Windows\WER\ReportQueue"
    )
    foreach ($lp in $logPaths) {
        if (Test-Path $lp) {
            try {
                Write-Host " - Limpando logs: $lp" -ForegroundColor DarkGray
                Get-ChildItem $lp -Recurse -Force -ErrorAction SilentlyContinue | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
            } catch {
                Write-Host "   Erro ao limpar $lp : $($_.Exception.Message)" -ForegroundColor DarkYellow
            }
        }
    }

    # DISM StartComponentCleanup (não é agressivo como ResetBase)
    try {
        Write-Host "`nIniciando DISM /StartComponentCleanup (pode demorar)..." -ForegroundColor Cyan
        DISM.exe /Online /Cleanup-Image /StartComponentCleanup | Out-Null
        Write-Host "DISM /StartComponentCleanup concluído." -ForegroundColor Green
    } catch {
        Write-Host "Falha ao executar DISM: $($_.Exception.Message)" -ForegroundColor Red
    }

    Write-Host "`nLimpeza profunda concluída." -ForegroundColor Green
}

# ------------------ FUNÇÕES DE REPARO ------------------

function Run-SFC {
    Write-Host "Executando verificação de arquivos do sistema (SFC /SCANNOW)..." -ForegroundColor Cyan
    Write-Host "Isso pode levar vários minutos. Aguarde até 100%." -ForegroundColor DarkGray
    try {
        sfc.exe /scannow
    } catch {
        Write-Host "Erro ao executar SFC: $($_.Exception.Message)" -ForegroundColor Red
    }
}

function Run-DISM {
    Write-Host "Executando reparo da imagem do Windows (DISM /RestoreHealth)..." -ForegroundColor Cyan
    Write-Host "Isso também pode levar bastante tempo. Aguarde." -ForegroundColor DarkGray
    try {
        DISM.exe /Online /Cleanup-Image /RestoreHealth
    } catch {
        Write-Host "Erro ao executar DISM: $($_.Exception.Message)" -ForegroundColor Red
    }
}

function Run-CHKDSK {
    Write-Host "Verificando disco do sistema com CHKDSK /scan..." -ForegroundColor Cyan
    Write-Host "Esta verificação é online (sem reiniciar). Para reparos completos use CHKDSK /F manualmente." -ForegroundColor DarkGray
    try {
        chkdsk C: /scan
    } catch {
        Write-Host "Erro ao executar CHKDSK: $($_.Exception.Message)" -ForegroundColor Red
    }
}

function Create-RestorePoint {
    Write-Host "Criando ponto de restauração (se o recurso estiver ativado)..." -ForegroundColor Cyan
    try {
        Checkpoint-Computer -Description "MR EVAN Toolkit" -RestorePointType "MODIFY_SETTINGS"
        Write-Host "Ponto de restauração solicitado." -ForegroundColor Green
    } catch {
        Write-Host "Não foi possível criar o ponto de restauração: $($_.Exception.Message)" -ForegroundColor Yellow
    }
}

# ------------------ FUNÇÕES DE SEGURANÇA ------------------

function Run-DefenderQuickScan {
    Write-Host "Iniciando verificação rápida do Microsoft Defender..." -ForegroundColor Cyan

    $cmd = Get-Command -Name Start-MpScan -ErrorAction SilentlyContinue
    if ($cmd) {
        try {
            Start-MpScan -ScanType QuickScan
        } catch {
            Write-Host "Erro ao usar Start-MpScan: $($_.Exception.Message)" -ForegroundColor Red
        }
    } else {
        # fallback via MpCmdRun.exe
        $mpPaths = @(
            "$env:ProgramFiles\Windows Defender\MpCmdRun.exe",
            "$env:ProgramFiles\Windows Defender\Platform\*\MpCmdRun.exe"
        )
        $mp = Get-ChildItem -Path $mpPaths -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -Descending | Select-Object -First 1
        if ($mp) {
            Start-Process -FilePath $mp.FullName -ArgumentList "-Scan -ScanType 1" -Wait
        } else {
            Write-Host "Microsoft Defender não encontrado ou desativado." -ForegroundColor Yellow
        }
    }
}

function Run-DefenderFullScan {
    Write-Host "Iniciando verificação completa do Microsoft Defender..." -ForegroundColor Cyan
    $cmd = Get-Command -Name Start-MpScan -ErrorAction SilentlyContinue
    if ($cmd) {
        try {
            Start-MpScan -ScanType FullScan
        } catch {
            Write-Host "Erro ao usar Start-MpScan: $($_.Exception.Message)" -ForegroundColor Red
        }
    } else {
        $mpPaths = @(
            "$env:ProgramFiles\Windows Defender\MpCmdRun.exe",
            "$env:ProgramFiles\Windows Defender\Platform\*\MpCmdRun.exe"
        )
        $mp = Get-ChildItem -Path $mpPaths -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -Descending | Select-Object -First 1
        if ($mp) {
            Start-Process -FilePath $mp.FullName -ArgumentList "-Scan -ScanType 2" -Wait
        } else {
            Write-Host "Microsoft Defender não encontrado ou desativado." -ForegroundColor Yellow
        }
    }
}

# ------------------ INFORMAÇÕES DO SISTEMA ------------------

function Show-SystemInfo {
    Write-Host "Coletando informações do sistema..." -ForegroundColor Cyan
    try {
        $os = Get-CimInstance Win32_OperatingSystem
        $cpu = Get-CimInstance Win32_Processor | Select-Object -First 1
        $ramGB = [math]::Round($os.TotalVisibleMemorySize / 1MB, 1)

        $drives = Get-CimInstance Win32_LogicalDisk -Filter "DriveType=3"

        Write-Host "`n=== Sistema Operacional ===" -ForegroundColor Green
        Write-Host ("Nome: {0}" -f $os.Caption)
        Write-Host ("Versão: {0}" -f $os.Version)
        Write-Host ("Build: {0}" -f $os.BuildNumber)

        Write-Host "`n=== Processador ===" -ForegroundColor Green
        Write-Host ("CPU: {0}" -f $cpu.Name)
        Write-Host ("Núcleos: {0} | Threads: {1}" -f $cpu.NumberOfCores, $cpu.NumberOfLogicalProcessors)

        Write-Host "`n=== Memória RAM ===" -ForegroundColor Green
        Write-Host ("Total: {0} GB" -f $ramGB)

        Write-Host "`n=== Discos ===" -ForegroundColor Green
        foreach ($d in $drives) {
            $totalGB = [math]::Round($d.Size / 1GB, 1)
            $freeGB  = [math]::Round($d.FreeSpace / 1GB, 1)
            $usedGB  = $totalGB - $freeGB
            Write-Host ("{0}: Total {1} GB | Usado {2} GB | Livre {3} GB" -f $d.DeviceID, $totalGB, $usedGB, $freeGB)
        }
    } catch {
        Write-Host "Erro ao obter informações do sistema: $($_.Exception.Message)" -ForegroundColor Red
    }
}

# ------------------ FERRAMENTAS EXTRAS ------------------

function Open-ExtrasMenu {
    do {
        Show-Header
        Write-Host " FERRAMENTAS EXTRAS DO WINDOWS" -ForegroundColor Magenta
        Write-Host ""
        Write-Host " [1] Abrir Limpeza de Disco (cleanmgr)" -ForegroundColor Cyan
        Write-Host " [2] Abrir Configurações de Armazenamento" -ForegroundColor Cyan
        Write-Host " [3] Abrir Gerenciador de Tarefas (inicialização)" -ForegroundColor Cyan
        Write-Host " [4] Abrir Programas e Recursos (desinstalar apps)" -ForegroundColor Cyan
        Write-Host " [5] Abrir Segurança do Windows" -ForegroundColor Cyan
        Write-Host ""
        Write-Host " [0] Voltar ao menu principal" -ForegroundColor Yellow
        Write-Host ""

        $opt = Read-Host "Selecione uma opção"
        switch ($opt) {
            "1" {
                Start-Process cleanmgr.exe
            }
            "2" {
                Start-Process "ms-settings:storage"
            }
            "3" {
                Start-Process taskmgr.exe
            }
            "4" {
                Start-Process appwiz.cpl
            }
            "5" {
                Start-Process "windowsdefender:"
            }
            "0" { return }
            default {
                Write-Host "Opção inválida." -ForegroundColor Red
                Pause-MR
            }
        }
    } while ($true)
}

# ------------------ SUB-MENUS PRINCIPAIS ------------------

function Open-CleanQuick {
    Show-Header
    Write-Host " LIMPEZA RÁPIDA" -ForegroundColor Magenta
    Write-Host ""
    Write-Host " - Arquivos temporários (usuário e sistema)" -ForegroundColor Gray
    Write-Host " - Cache do Explorer e miniaturas" -ForegroundColor Gray
    Write-Host " - Lixeira" -ForegroundColor Gray
    Write-Host ""
    $c = Read-Host "Confirmar limpeza rápida? (S/N)"
    if ($c -match '^[sS]') {
        Clear-TempFiles
    } else {
        Write-Host "Limpeza rápida cancelada." -ForegroundColor Yellow
    }
    Pause-MR
}

function Open-CleanDeep {
    Show-Header
    Write-Host " LIMPEZA PROFUNDA" -ForegroundColor Magenta
    Write-Host ""
    Write-Host " - Tudo da limpeza rápida" -ForegroundColor Gray
    Write-Host " - Cache de navegadores (Chrome, Edge, Firefox, Opera, Brave)" -ForegroundColor Gray
    Write-Host " - Cache de Windows Update e logs de erro" -ForegroundColor Gray
    Write-Host " - DISM StartComponentCleanup (otimiza WinSxS)" -ForegroundColor Gray
    Write-Host ""
    $c = Read-Host "Esta operação pode demorar. Deseja continuar? (S/N)"
    if ($c -match '^[sS]') {
        Clear-TempFiles
        Clear-BrowserCaches
        Clear-DeepWindowsStuff
    } else {
        Write-Host "Limpeza profunda cancelada." -ForegroundColor Yellow
    }
    Pause-MR
}

function Open-RepairMenu {
    do {
        Show-Header
        Write-Host " REPAROS DO SISTEMA" -ForegroundColor Magenta
        Write-Host ""
        Write-Host " [1] Criar ponto de restauração" -ForegroundColor Cyan
        Write-Host " [2] SFC /SCANNOW (arquivos de sistema)" -ForegroundColor Cyan
        Write-Host " [3] DISM /RestoreHealth (imagem do Windows)" -ForegroundColor Cyan
        Write-Host " [4] CHKDSK /scan (verificar disco C:)" -ForegroundColor Cyan
        Write-Host ""
        Write-Host " [0] Voltar ao menu principal" -ForegroundColor Yellow
        Write-Host ""

        $opt = Read-Host "Selecione uma opção"
        switch ($opt) {
            "1" { Create-RestorePoint; Pause-MR }
            "2" { Run-SFC; Pause-MR }
            "3" { Run-DISM; Pause-MR }
            "4" { Run-CHKDSK; Pause-MR }
            "0" { return }
            default {
                Write-Host "Opção inválida." -ForegroundColor Red
                Pause-MR
            }
        }
    } while ($true)
}

function Open-SecurityMenu {
    do {
        Show-Header
        Write-Host " SEGURANÇA / ANTI-VÍRUS" -ForegroundColor Magenta
        Write-Host ""
        Write-Host " [1] Verificação rápida do Microsoft Defender" -ForegroundColor Cyan
        Write-Host " [2] Verificação completa do Microsoft Defender" -ForegroundColor Cyan
        Write-Host " [3] Abrir painel Segurança do Windows" -ForegroundColor Cyan
        Write-Host ""
        Write-Host " [0] Voltar ao menu principal" -ForegroundColor Yellow
        Write-Host ""

        $opt = Read-Host "Selecione uma opção"
        switch ($opt) {
            "1" { Run-DefenderQuickScan; Pause-MR }
            "2" { Run-DefenderFullScan; Pause-MR }
            "3" { Start-Process "windowsdefender:"; Pause-MR }
            "0" { return }
            default {
                Write-Host "Opção inválida." -ForegroundColor Red
                Pause-MR
            }
        }
    } while ($true)
}

# ------------------ LOOP PRINCIPAL ------------------

do {
    Show-MainMenu
    $choice = Read-Host "Digite o número da opção desejada"

    switch ($choice) {
        "1" { Open-CleanQuick }
        "2" { Open-CleanDeep }
        "3" { Open-RepairMenu }
        "4" { Open-SecurityMenu }
        "5" { Show-Header; Show-SystemInfo; Pause-MR }
        "6" { Open-ExtrasMenu }
        "0" { break }
        default {
            Write-Host "Opção inválida. Digite um número do menu." -ForegroundColor Red
            Pause-MR
        }
    }
} while ($true)

Write-Host ""
Write-Host "Obrigado por usar o MR EVAN Toolkit!" -ForegroundColor Cyan
Write-Host "Fechando..." -ForegroundColor DarkGray
Start-Sleep -Seconds 1
