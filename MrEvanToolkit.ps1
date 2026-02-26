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
