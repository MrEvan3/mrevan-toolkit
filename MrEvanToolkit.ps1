<# 
  Mr Evan Intelligent Repair System
  Console avançado de manutenção e otimização para Windows 10 e 11.
  Autor: Evandro Lemos + IA
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
    Write-Separator
    
    # Mr Evan em destaque (Blocos Unicode)
    Show-Center "█▀▄▀█ █▀█   █▀▀ █░█ ▄▀█ █▄░█" "Red"
    Show-Center "█░▀░█ █▀▄   ██▄ ▀▄▀ █▀█ █░▀█" "Red"
    Write-Host ""
    
    Show-Center "Intelligent Repair System" "Red"
    Show-Center "Created by Evandro Lemos" "DarkGray"
    Write-Host ""
    
    Show-Center "Versao $MRIRS_Version  |  Windows 10/11" "Gray"
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
    Write-Host " - Mostra pecas, gargalo e saude do sistema" -ForegroundColor Gray
    Write-Host " [6] UTILITARIOS EXTRAS    " -ForegroundColor Cyan -NoNewline
    Write-Host " [EXTRAS]" -ForegroundColor DarkCyan -NoNewline
    Write-Host " - Limpeza de disco, tarefas, programas e mais" -ForegroundColor Gray
    Write-Host " [7] MODO TECNICO AVANCADO " -ForegroundColor Cyan -NoNewline
    Write-Host " [DANGER]" -ForegroundColor Red -NoNewline
    Write-Host " - Reparos profundos, debloat e reset de rede" -ForegroundColor Gray
    Write-Host ""
    Write-Host " [0] SAIR                  " -ForegroundColor Red -NoNewline
    Write-Host " [---]" -ForegroundColor DarkGray -NoNewline
    Write-Host " - Fechar e sair do Mr Evan IRS" -ForegroundColor Gray
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
        Write-Host " [1] REDUZIR LATENCIA (TIMER)   " -ForegroundColor Cyan -NoNewline
        Write-Host " [GAMER]" -ForegroundColor Magenta -NoNewline
        Write-Host " - Abaixa o tempo de resposta do Windows" -ForegroundColor Gray
        Write-Host " [2] FORCAR PRIORIDADE ALTA     " -ForegroundColor Cyan -NoNewline
        Write-Host " [GAMER]" -ForegroundColor Magenta -NoNewline
        Write-Host " - Foca o processador no seu jogo" -ForegroundColor Gray
        Write-Host " [3] DESATIVAR TELA CHEIA (FSO) " -ForegroundColor Cyan -NoNewline
        Write-Host " [GAMER]" -ForegroundColor Magenta -NoNewline
        Write-Host " - Tira o lag do Alt+Tab nos jogos" -ForegroundColor Gray
        Write-Host " [4] DESBLOQUEAR NUCLEOS CPU   " -ForegroundColor Cyan -NoNewline
        Write-Host " [GAMER]" -ForegroundColor Magenta -NoNewline
        Write-Host " - Forca 100% do processador no jogo" -ForegroundColor Gray
        Write-Host " [5] MOUSE PRECISAO 1:1        " -ForegroundColor Cyan -NoNewline
        Write-Host " [GAMER]" -ForegroundColor Magenta -NoNewline
        Write-Host " - Remove aceleracao do Windows" -ForegroundColor Gray
        Write-Host " [6] OTIMIZAR TECLADO          " -ForegroundColor Cyan -NoNewline
        Write-Host " [GAMER]" -ForegroundColor Magenta -NoNewline
        Write-Host " - Resposta rapida ao segurar teclas" -ForegroundColor Gray
        Write-Host " [7] REDUZIR PACOTES REDE       " -ForegroundColor Cyan -NoNewline
        Write-Host " [GAMER]" -ForegroundColor Magenta -NoNewline
        Write-Host " - Otimiza TCP para jogos online" -ForegroundColor Gray
        Write-Host " [8] DESATIVAR GAME BAR / DVR  " -ForegroundColor Cyan -NoNewline
        Write-Host " [GAMER]" -ForegroundColor Magenta -NoNewline
        Write-Host " - Desliga gravacao em segundo plano" -ForegroundColor Gray
        Write-Host " [9] PLANO ENERGIA ALTO DESEMPENHO" -ForegroundColor Cyan -NoNewline
        Write-Host " [GAMER]" -ForegroundColor Magenta -NoNewline
        Write-Host " - Ativa modo maximo desempenho" -ForegroundColor Gray
        Write-Host ""
        Write-Host " [0] VOLTAR                    " -ForegroundColor Yellow -NoNewline
        Write-Host " [---]" -ForegroundColor DarkGray -NoNewline
        Write-Host " - Retornar ao Menu Inicial" -ForegroundColor Gray
        Write-Host ""

        $opt = Read-Host "Escolha uma opcao"
        switch ($opt) {
            "1" {
                Write-Host "Aplicando timer resolution (reduz latencia)..." -ForegroundColor Green
                try {
                    $code = @'
[DllImport("ntdll.dll")] public static extern int NtSetTimerResolution(uint d, bool s, ref uint c);
'@
                    Add-Type -MemberDefinition $code -Namespace Win32 -Name Nt -ErrorAction SilentlyContinue
                    $cur = 0; [Win32.Nt]::NtSetTimerResolution(5000, $true, [ref]$cur) | Out-Null
                    Write-Host "Timer em 0.5ms aplicado. Pressione uma tecla para reverter." -ForegroundColor Green
                    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
                    [Win32.Nt]::NtSetTimerResolution(156000, $true, [ref]$cur) | Out-Null
                } catch { Write-Host "Requer privilegios de admin. Alternativa: use plano Alto Desempenho." -ForegroundColor Yellow }
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
                    } catch { Write-Host "Falha: $($_.Exception.Message)" -ForegroundColor Yellow }
                }
                Pause-MR
            }
            "3" {
                try {
                    New-Item -Path "HKCU:\System\GameConfigStore" -Force | Out-Null
                    Set-ItemProperty -Path "HKCU:\System\GameConfigStore" -Name "GameDVR_FSEBehaviorMode" -Value 2 -Type DWord -Force
                    Write-Host "FSO (Fullscreen Optimizations) desativado - menos lag no Alt+Tab." -ForegroundColor Green
                } catch { Write-Host "Falha: $($_.Exception.Message)" -ForegroundColor Yellow }
                Pause-MR
            }
            "4" {
                Write-Host "Ativando plano de energia Alto Desempenho (usa todos os nucleos)..." -ForegroundColor Green
                try { powercfg -setactive SCHEME_MIN | Out-Null; Write-Host "Concluido." -ForegroundColor Green } catch { Write-Host "Nao foi possivel." -ForegroundColor Yellow }
                Pause-MR
            }
            "5" {
                try {
                    Set-ItemProperty -Path "HKCU:\Control Panel\Mouse" -Name "MouseSpeed" -Value "0" -Force
                    Set-ItemProperty -Path "HKCU:\Control Panel\Mouse" -Name "MouseThreshold1" -Value "0" -Force
                    Set-ItemProperty -Path "HKCU:\Control Panel\Mouse" -Name "MouseThreshold2" -Value "0" -Force
                    Write-Host "Aceleracao do mouse desativada (precisao 1:1)." -ForegroundColor Green
                } catch { Write-Host "Falha: $($_.Exception.Message)" -ForegroundColor Yellow }
                Pause-MR
            }
            "6" {
                try {
                    Set-ItemProperty -Path "HKCU:\Control Panel\Accessibility\Keyboard Response" -Name "AutoRepeatDelay" -Value "150" -Type DWord -Force
                    Write-Host "Teclado otimizado para resposta rapida." -ForegroundColor Green
                } catch { Write-Host "Falha: $($_.Exception.Message)" -ForegroundColor Yellow }
                Pause-MR
            }
            "7" {
                Optimize-NetworkAndDNS
                try {
                    $ints = Get-Item "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\*" -ErrorAction SilentlyContinue
                    foreach ($i in $ints) {
                        New-ItemProperty -Path $i.PSPath -Name "TcpAckFrequency" -Value 1 -PropertyType DWord -Force -ErrorAction SilentlyContinue | Out-Null
                    }
                    Write-Host "TCP otimizado para jogos online." -ForegroundColor Green
                } catch {}
                Pause-MR
            }
            "8" {
                try {
                    New-Item -Path "HKCU:\SOFTWARE\Microsoft\GameBar" -Force | Out-Null
                    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\GameBar" -Name "ShowGameBar" -Value 0 -Type DWord -Force
                    New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR" -Force | Out-Null
                    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR" -Name "AllowGameDVR" -Value 0 -Type DWord -Force
                    Write-Host "Game Bar e DVR desativados." -ForegroundColor Green
                } catch { Write-Host "Falha: $($_.Exception.Message)" -ForegroundColor Yellow }
                Pause-MR
            }
            "9" {
                try { powercfg -setactive SCHEME_MIN | Out-Null; Write-Host "Plano Alto Desempenho ativado." -ForegroundColor Green } catch { Write-Host "Nao foi possivel." -ForegroundColor Yellow }
                Pause-MR
            }
            "0" { return }
            default {
                Write-Host "Opcao invalida." -ForegroundColor Red
                Pause-MR
            }
        }
    } while ($true)
}

# ------------------ BLOCO: FERRAMENTAS DO SISTEMA ------------------

function Open-SystemToolsMenu {
    do {
        Show-Header
        Write-Host "=== FERRAMENTAS DO SISTEMA (1/2) ===" -ForegroundColor Magenta
        Write-Host ""
        Write-Host " [1] WINUTIL (CHRIS TITUS)      " -ForegroundColor Cyan -NoNewline
        Write-Host " [SISTEMA]" -ForegroundColor Yellow -NoNewline
        Write-Host " - Ferramenta externa super completa" -ForegroundColor Gray
        Write-Host " [2] ARRUMAR WINDOWS UPDATE    " -ForegroundColor Cyan -NoNewline
        Write-Host " [SISTEMA]" -ForegroundColor Yellow -NoNewline
        Write-Host " - Destrava atualizacoes presas" -ForegroundColor Gray
        Write-Host " [3] ESCOLHER MELHOR DNS      " -ForegroundColor Cyan -NoNewline
        Write-Host " [SISTEMA]" -ForegroundColor Yellow -NoNewline
        Write-Host " - Muda a rede para a mais rapida" -ForegroundColor Gray
        Write-Host " [4] DESCARREGAR CACHE DNS    " -ForegroundColor Cyan -NoNewline
        Write-Host " [SISTEMA]" -ForegroundColor Yellow -NoNewline
        Write-Host " - Limpa cache DNS (flush)" -ForegroundColor Gray
        Write-Host " [5] REPARAR ARQUIVOS WINDOWS " -ForegroundColor Cyan -NoNewline
        Write-Host " [SISTEMA]" -ForegroundColor Yellow -NoNewline
        Write-Host " - SFC + DISM (tela azul e erros)" -ForegroundColor Gray
        Write-Host " [6] CRIAR PONTO RESTAURACAO   " -ForegroundColor Cyan -NoNewline
        Write-Host " [SISTEMA]" -ForegroundColor Yellow -NoNewline
        Write-Host " - Ponto de restauracao do sistema" -ForegroundColor Gray
        Write-Host " [7] DESATIVAR TELEMETRIA     " -ForegroundColor Cyan -NoNewline
        Write-Host " [SISTEMA]" -ForegroundColor Yellow -NoNewline
        Write-Host " - Impede o Windows de te rastrear" -ForegroundColor Gray
        Write-Host " [8] CHKDSK (VERIFICAR DISCO)  " -ForegroundColor Cyan -NoNewline
        Write-Host " [SISTEMA]" -ForegroundColor Yellow -NoNewline
        Write-Host " - Verifica e corrige erros no disco" -ForegroundColor Gray
        Write-Host " [9] MAIS FERRAMENTAS (PAG 2)  " -ForegroundColor Cyan -NoNewline
        Write-Host " [SISTEMA]" -ForegroundColor Yellow -NoNewline
        Write-Host " - Ajustes avancados, HOSTS, etc." -ForegroundColor Gray
        Write-Host ""
        Write-Host " [0] VOLTAR                    " -ForegroundColor Yellow -NoNewline
        Write-Host " [---]" -ForegroundColor DarkGray -NoNewline
        Write-Host " - Retornar ao Menu Inicial" -ForegroundColor Gray
        Write-Host ""

        $opt = Read-Host "Escolha uma opcao"
        switch ($opt) {
            "1" {
                try { irm "https://christitus.com/win" | iex } catch { Write-Host "Erro ao abrir WinUtil: $($_.Exception.Message)" -ForegroundColor Red }
                Pause-MR
            }
            "2" {
                Show-Header
                Write-Host "Reiniciando Windows Update (destrava atualizacoes)..." -ForegroundColor Green
                try {
                    Stop-Service wuauserv -Force -ErrorAction SilentlyContinue
                    Stop-Service bits -Force -ErrorAction SilentlyContinue
                    Remove-Item "$env:WINDIR\SoftwareDistribution\Download\*" -Recurse -Force -ErrorAction SilentlyContinue
                    Start-Service wuauserv -ErrorAction SilentlyContinue
                    Start-Service bits -ErrorAction SilentlyContinue
                    Write-Host "Concluido. Verifique por atualizacoes." -ForegroundColor Green
                } catch { Write-Host "Falha: $($_.Exception.Message)" -ForegroundColor Yellow }
                Pause-MR
            }
            "3" {
                Show-Header
                Write-Host "Testando DNS (Google vs Cloudflare) e aplicando o mais rapido..." -ForegroundColor Green
                try {
                    $g = (Test-Connection 8.8.8.8 -Count 1 -ErrorAction SilentlyContinue).ResponseTime
                    $c = (Test-Connection 1.1.1.1 -Count 1 -ErrorAction SilentlyContinue).ResponseTime
                    $idx = (Get-NetAdapter | Where-Object Status -eq Up).InterfaceIndex
                    if ($c -le $g) { Set-DnsClientServerAddress -InterfaceIndex $idx -ServerAddresses @("1.1.1.1","1.0.0.1") } else { Set-DnsClientServerAddress -InterfaceIndex $idx -ServerAddresses @("8.8.8.8","8.8.4.4") }
                    Write-Host "DNS aplicado." -ForegroundColor Green
                } catch { Write-Host "Falha: $($_.Exception.Message)" -ForegroundColor Yellow }
                Pause-MR
            }
            "4" {
                Show-Header
                ipconfig /flushdns
                Write-Host "Cache DNS descarregado." -ForegroundColor Green
                Pause-MR
            }
            "5" {
                Show-Header
                Run-SFC
                Write-Host ""
                Run-DISMRepair
                Pause-MR
            }
            "6" { Show-Header; Create-RestorePoint; Pause-MR }
            "7" {
                try {
                    Stop-Service DiagTrack -Force -ErrorAction SilentlyContinue
                    Set-Service DiagTrack -StartupType Disabled -ErrorAction SilentlyContinue
                    Write-Host "Telemetria (DiagTrack) desativada." -ForegroundColor Green
                } catch { Write-Host "Falha: $($_.Exception.Message)" -ForegroundColor Yellow }
                Pause-MR
            }
            "8" { Show-Header; Run-CHKDSKScan; Pause-MR }
            "9" { Open-SystemToolsMenuPage2 }
            "0" { return }
            default {
                Write-Host "Opcao invalida." -ForegroundColor Red
                Pause-MR
            }
        }
    } while ($true)
}

function Open-SystemToolsMenuPage2 {
    do {
        Show-Header
        Write-Host "=== FERRAMENTAS DO SISTEMA (2/2) ===" -ForegroundColor Magenta
        Write-Host ""
        Write-Host " [1] EDITAR ARQUIVO HOSTS     " -ForegroundColor Cyan -NoNewline
        Write-Host " [SISTEMA]" -ForegroundColor Yellow -NoNewline
        Write-Host " - Abre HOSTS para edicao" -ForegroundColor Gray
        Write-Host " [2] VARIAVEIS DE AMBIENTE    " -ForegroundColor Cyan -NoNewline
        Write-Host " [SISTEMA]" -ForegroundColor Yellow -NoNewline
        Write-Host " - Abre variaveis do sistema" -ForegroundColor Gray
        Write-Host " [3] REMOVER APPS INICIALIZACAO" -ForegroundColor Cyan -NoNewline
        Write-Host " [SISTEMA]" -ForegroundColor Yellow -NoNewline
        Write-Host " - Abre Gerenciador de Tarefas (inicializacao)" -ForegroundColor Gray
        Write-Host " [4] DESINSTALAR APPS UWP     " -ForegroundColor Cyan -NoNewline
        Write-Host " [SISTEMA]" -ForegroundColor Yellow -NoNewline
        Write-Host " - Abre Programas e Recursos" -ForegroundColor Gray
        Write-Host " [5] INSPECAO DE HARDWARE     " -ForegroundColor Cyan -NoNewline
        Write-Host " [SISTEMA]" -ForegroundColor Yellow -NoNewline
        Write-Host " - Abre Informacoes do Sistema (msinfo32)" -ForegroundColor Gray
        Write-Host " [6] PING / LATENCIA          " -ForegroundColor Cyan -NoNewline
        Write-Host " [SISTEMA]" -ForegroundColor Yellow -NoNewline
        Write-Host " - Testa ping para IP ou dominio" -ForegroundColor Gray
        Write-Host " [7] RESETAR CACHE FONTES     " -ForegroundColor Cyan -NoNewline
        Write-Host " [SISTEMA]" -ForegroundColor Yellow -NoNewline
        Write-Host " - Corrige fontes borradas" -ForegroundColor Gray
        Write-Host " [8] GOD MODE (ATALHO)        " -ForegroundColor Cyan -NoNewline
        Write-Host " [SISTEMA]" -ForegroundColor Yellow -NoNewline
        Write-Host " - Cria pasta God Mode na area de trabalho" -ForegroundColor Gray
        Write-Host ""
        Write-Host " [0] VOLTAR (PAG 1)           " -ForegroundColor Yellow -NoNewline
        Write-Host " [---]" -ForegroundColor DarkGray -NoNewline
        Write-Host " - Retornar a pagina anterior" -ForegroundColor Gray
        Write-Host ""

        $opt = Read-Host "Escolha uma opcao"
        switch ($opt) {
            "1" { Start-Process notepad.exe -ArgumentList "$env:WINDIR\System32\drivers\etc\hosts"; Pause-MR }
            "2" { Start-Process "SystemPropertiesAdvanced.exe"; Pause-MR }
            "3" { Start-Process taskmgr.exe; Pause-MR }
            "4" { Start-Process appwiz.cpl; Pause-MR }
            "5" { Start-Process msinfo32.exe; Pause-MR }
            "6" {
                $alvo = Read-Host "Digite IP ou dominio (ex: 8.8.8.8 ou google.com)"
                if ($alvo) {
                    Write-Host "Testando $alvo ..." -ForegroundColor Cyan
                    Test-Connection $alvo -Count 4
                }
                Pause-MR
            }
            "7" {
                try {
                    Stop-Service FontCache -Force -ErrorAction SilentlyContinue
                    Remove-Item "$env:LOCALAPPDATA\Microsoft\Windows\Fonts\*.dat" -Force -ErrorAction SilentlyContinue
                    Start-Service FontCache -ErrorAction SilentlyContinue
                    Write-Host "Cache de fontes resetado." -ForegroundColor Green
                } catch { Write-Host "Falha: $($_.Exception.Message)" -ForegroundColor Yellow }
                Pause-MR
            }
            "8" {
                $god = "$env:USERPROFILE\Desktop\GodMode.{ED7BA470-8E54-465E-825C-99712043E01C}"
                New-Item -ItemType Directory -Path $god -Force | Out-Null
                Write-Host "God Mode criado na Area de Trabalho." -ForegroundColor Green
                Pause-MR
            }
            "0" { return }
            default {
                Write-Host "Opcao invalida." -ForegroundColor Red
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

# ------------------ BLOCO: MODO TÉCNICO / AVANÇADO ------------------

function Disable-VBS {
    Write-Host "Desativando Virtualization-Based Security (VBS)..." -ForegroundColor Cyan
    try {
        bcdedit /set hypervisorlaunchtype off | Out-Null
        New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\DeviceGuard" -Name "EnableVirtualizationBasedSecurity" -Value 0 -PropertyType DWord -Force -ErrorAction SilentlyContinue | Out-Null
        Write-Host "VBS desativado. Reinicie o PC para aplicar o ganho de FPS." -ForegroundColor Green
    } catch { Write-Host "Erro: $($_.Exception.Message)" -ForegroundColor Red }
}

function Disable-BackgroundApps {
    Write-Host "Matando apps em segundo plano..." -ForegroundColor Cyan
    try {
        New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" -Name "GlobalUserDisabled" -Value 1 -PropertyType DWord -Force -ErrorAction SilentlyContinue | Out-Null
        Write-Host "Apps em segundo plano desativados com sucesso." -ForegroundColor Green
    } catch { Write-Host "Erro: $($_.Exception.Message)" -ForegroundColor Red }
}

function Disable-SearchIndexing {
    Write-Host "Desativando Indexação do Windows (WSearch)..." -ForegroundColor Cyan
    try {
        Stop-Service WSearch -Force -ErrorAction SilentlyContinue
        Set-Service WSearch -StartupType Disabled -ErrorAction SilentlyContinue
        Write-Host "Indexação desativada (Ideal para SSDs)." -ForegroundColor Green
    } catch { Write-Host "Erro: $($_.Exception.Message)" -ForegroundColor Red }
}

function Run-NuclearCleanup {
    Write-Host "Iniciando Limpeza Nuclear (ResetBase)... Isso pode demorar!" -ForegroundColor Red
    try {
        DISM.exe /Online /Cleanup-Image /StartComponentCleanup /ResetBase
        Write-Host "Limpeza nuclear concluída. Atualizações antigas destruídas." -ForegroundColor Green
    } catch { Write-Host "Erro: $($_.Exception.Message)" -ForegroundColor Red }
}

function Reset-NetworkStack {
    Write-Host "Resetando Pilha de Rede (Winsock/IP)..." -ForegroundColor Cyan
    try {
        netsh winsock reset | Out-Null
        netsh int ip reset | Out-Null
        ipconfig /release | Out-Null
        ipconfig /renew | Out-Null
        ipconfig /flushdns | Out-Null
        Write-Host "Rede resetada de fábrica com sucesso." -ForegroundColor Green
    } catch { Write-Host "Erro: $($_.Exception.Message)" -ForegroundColor Red }
}

function Clear-AllEventLogs {
    Write-Host "Limpando TODOS os Logs de Eventos do Windows..." -ForegroundColor Cyan
    try {
        Get-WinEvent -ListLog * -Force -ErrorAction SilentlyContinue | Where-Object { $_.RecordCount -gt 0 } | ForEach-Object {
            wevtutil cl $_.LogName
        }
        Write-Host "Logs de eventos completamente apagados. Ficha limpa!" -ForegroundColor Green
    } catch { Write-Host "Erro: $($_.Exception.Message)" -ForegroundColor Red }
}

function Set-SafeModeBoot {
    Write-Host "Configurando boot para MODO DE SEGURANÇA (com rede)..." -ForegroundColor Yellow
    try {
        bcdedit /set "{default}" safeboot network | Out-Null
        Write-Host "O PC iniciará em Modo de Segurança no próximo boot." -ForegroundColor Green
        Write-Host "DICA: Para reverter depois, digite no terminal: bcdedit /deletevalue {default} safeboot" -ForegroundColor DarkGray
    } catch { Write-Host "Erro: $($_.Exception.Message)" -ForegroundColor Red }
}

function Disable-WebSearch {
    Write-Host "Cortando a Web do Menu Iniciar..." -ForegroundColor Cyan
    try {
        $path = "HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer"
        if (-not (Test-Path $path)) { New-Item -Path $path -Force | Out-Null }
        New-ItemProperty -Path $path -Name "DisableSearchBoxSuggestions" -Value 1 -PropertyType DWord -Force | Out-Null
        Write-Host "Pesquisa Web desativada. Reinicie o Windows Explorer para aplicar." -ForegroundColor Green
    } catch { Write-Host "Erro: $($_.Exception.Message)" -ForegroundColor Red }
}

function Restore-ClassicContextMenu {
    Write-Host "Restaurando Clique Direito Clássico (Win 11)..." -ForegroundColor Cyan
    try {
        New-Item -Path "HKCU:\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" -Force | Out-Null
        Write-Host "Menu clássico restaurado. Reinicie o Windows Explorer para aplicar." -ForegroundColor Green
    } catch { Write-Host "Erro: $($_.Exception.Message)" -ForegroundColor Red }
}

function Get-BatteryReport {
    Write-Host "Gerando relatório detalhado de saúde da bateria..." -ForegroundColor Cyan
    try {
        $outPath = "$env:USERPROFILE\Desktop\BatteryReport.html"
        powercfg /batteryreport /output $outPath | Out-Null
        Write-Host "Relatório salvo em: $outPath" -ForegroundColor Green
        Start-Process $outPath
    } catch { Write-Host "Erro: $($_.Exception.Message)" -ForegroundColor Red }
}

function Get-SmartStatus {
    Write-Host "Lendo status S.M.A.R.T. dos discos físicos..." -ForegroundColor Cyan
    Write-Host ""
    try {
        Get-PhysicalDisk | Format-Table DeviceId, MediaType, OperationalStatus, HealthStatus -AutoSize
    } catch { Write-Host "Erro: $($_.Exception.Message)" -ForegroundColor Red }
}

function Reset-FirewallTotal {
    Write-Host "Resetando regras do Firewall para o padrão de fábrica..." -ForegroundColor Red
    try {
        netsh advfirewall reset | Out-Null
        Write-Host "Firewall resetado com sucesso." -ForegroundColor Green
    } catch { Write-Host "Erro: $($_.Exception.Message)" -ForegroundColor Red }
}

function Enable-SuperAdmin {
    Write-Host "Desbloqueando a conta de Super Administrador..." -ForegroundColor Yellow
    try {
        net user administrador /active:yes 2>$null
        net user administrator /active:yes 2>$null
        Write-Host "Conta de Administrador ativada! Ela estará disponível na tela de login." -ForegroundColor Green
    } catch { Write-Host "Erro: $($_.Exception.Message)" -ForegroundColor Red }
}

function Reset-FolderPermissions {
    Write-Host "Restaurando permissões da pasta do seu usuário (Icacls)..." -ForegroundColor Cyan
    try {
        $userPath = $env:USERPROFILE
        icacls "$userPath" /q /c /t /reset | Out-Null
        Write-Host "Permissões originais restauradas com sucesso para $userPath." -ForegroundColor Green
    } catch { Write-Host "Erro: $($_.Exception.Message)" -ForegroundColor Red }
}

function Open-TechMenu {
    do {
        Show-Header
        Write-Host "=== MODO TÉCNICO AVANÇADO (CUIDADO) ===" -ForegroundColor Red
        Write-Host ""
        Write-Host " --- DEBLOAT EXTREMO ---" -ForegroundColor DarkGray
        Write-Host " [1] Desativar VBS (Ganha FPS em jogos)" -ForegroundColor Cyan
        Write-Host " [2] Matar Apps em Segundo Plano" -ForegroundColor Cyan
        Write-Host " [3] Desabilitar Indexação do Windows (WSearch)" -ForegroundColor Cyan
        Write-Host " --- REPAROS E INTERFACE ---" -ForegroundColor DarkGray
        Write-Host " [4] Limpeza Nuclear do Windows Update" -ForegroundColor Cyan
        Write-Host " [5] Reset Completo da Pilha de Rede" -ForegroundColor Cyan
        Write-Host " [6] Limpar TODOS os Logs de Eventos" -ForegroundColor Cyan
        Write-Host " [7] Cortar a Web do Menu Iniciar" -ForegroundColor Cyan
        Write-Host " [8] Restaurar Clique Direito Clássico (Win 11)" -ForegroundColor Cyan
        Write-Host " --- MODO PÂNICO E DIAGNÓSTICO ---" -ForegroundColor DarkGray
        Write-Host " [9] Gerar Relatório de Saúde da Bateria" -ForegroundColor Cyan
        Write-Host " [10] Leitura S.M.A.R.T. dos Discos" -ForegroundColor Cyan
        Write-Host " [11] Reset Total do Firewall" -ForegroundColor Cyan
        Write-Host " [12] Desbloquear a Conta Super Administrador" -ForegroundColor Cyan
        Write-Host " [13] Forçar Próximo Boot em Modo de Segurança" -ForegroundColor Yellow
        Write-Host ""
        Write-Host " [0] Voltar ao menu principal" -ForegroundColor DarkYellow
        Write-Host ""

        $opt = Read-Host "Escolha uma opção"
        switch ($opt) {
            "1" { Disable-VBS; Pause-MR }
            "2" { Disable-BackgroundApps; Pause-MR }
            "3" { Disable-SearchIndexing; Pause-MR }
            "4" { Run-NuclearCleanup; Pause-MR }
            "5" { Reset-NetworkStack; Pause-MR }
            "6" { Clear-AllEventLogs; Pause-MR }
            "7" { Disable-WebSearch; Pause-MR }
            "8" { Restore-ClassicContextMenu; Pause-MR }
            "9" { Get-BatteryReport; Pause-MR }
            "10" { Get-SmartStatus; Pause-MR }
            "11" { Reset-FirewallTotal; Pause-MR }
            "12" { Enable-SuperAdmin; Pause-MR }
            "13" { Set-SafeModeBoot; Pause-MR }
            "0" { return }
            default { Write-Host "Opção inválida." -ForegroundColor Red; Pause-MR }
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
        "7" { Open-TechMenu }
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