# 🛠️ Mr Evan Intelligent Repair System (v2.0 Elite)

> A Estação de Batalha Definitiva para Técnicos, Engenheiros SOC e Power Users.

Desenvolvido por **Evandro Lemos (Mr Evan IRS)**, o Mr Evan Intelligent Repair System é um console avançado em PowerShell para auditoria, otimização, reparo profundo e inteligência de ameaças no Windows 10 e 11.

Com arquitetura modular, dashboard HTML e integração com APIs de Threat Intelligence, o projeto consolida operações críticas em um único ambiente técnico.

---

## 🚀 Execução Rápida (Sem Instalação)

Abra o **PowerShell como Administrador** e execute:

```powershell
irm "https://raw.githubusercontent.com/MrEvan3/mrevan-toolkit/main/MrEvanToolkit.ps1" | iex
```

⚠️ Privilégios administrativos são obrigatórios.

---

## 📸 Interface

![Menu Principal](images/menu-principal.png)

![Dashboard Dark Mode](images/dashboard-darkmode.png)

---

# 📂 Estrutura Pública do Repositório

Este repositório contém:

- ✅ Módulos 1 a 8
- ✅ Dashboard HTML
- ✅ Threat Intelligence
- ✅ Diagnóstico Avançado
- ✅ Sistema de Reversão (Undo)
- ✅ Integração com MAS (Microsoft Activation Scripts)

---

# 🟢 Módulos Nível 1 – Usuário Técnico

Ferramentas para:

- Limpeza profunda
- Otimização Gamer
- Verificação de integridade do sistema
- Backup rápido
- Análise básica de rede
- Correção de serviços

---

# 🔴 Módulos Nível 2 – SOC / Engenharia

⚠️ Operações críticas em nível de sistema.

Inclui:

- Radar de IP (ipinfo.io)
- Consulta EDR (VirusTotal)
- Validação de Hash do Kernel
- Network Deep Scan
- God Mode Unbrick
- Modo Técnico Avançado (Danger Zone)

![Radar SOC](images/radar-soc.png)

---

# 🚑 Recuperação Offline (Modo Boot / WinPE)
A ferramenta definitiva de resgate de ecrã azul. Para usar, arranque o PC a partir de uma PenDrive com o instalador do Windows, pressione **Shift+F10** para abrir o CMD e corra o script.
- Repara tabelas de partições e o **Winload.efi** com comandos como **bootrec** e **bcdboot**.
- Extrai logs de falha (SrtTrail.txt) e copia ficheiros bloqueados com **Robocopy**.

## 📖 Guia Passo a Passo: Quebra ou Alteração de Palavra-Passe (Bypass Utilman)
1. Prepare a PenDrive: Salve o MrEvanToolkit.ps1 na raiz de uma PenDrive de instalação do Windows.

2. Dê o Boot: Inicie o PC pela PenDrive. Quando aparecer a tela do Windows, prima Shift + F10 para abrir o CMD.

3. Abra o Script: Digite powershell, dê Enter. Digite o caminho da PenDrive (ex: D:\MrEvanToolkit.ps1).

4. Injete o Código: Vá à opção 10, depois 5. Escolha a letra do seu disco. O script substituirá a ferramenta de Acessibilidade pelo CMD (utilman.exe).

5. Mude a Senha: Reinicie o PC normalmente. No ecrã de login, clique no ícone de "Acessibilidade". Abrir-se-á um terminal negro (Nível Root).

6. Digite control userpasswords2 para redefinir qualquer senha ou net user [nome_do_usuario] *.

7. ⚠️ Limpe os Rastos: Após entrar no Windows, repita o processo de Boot pela PenDrive, vá novamente à Opção 10 > 5 e escolha desfazer a injeção para fechar a vulnerabilidade.

---

# 🔐 Enterprise Documentation (Privado)

Os seguintes módulos fazem parte da documentação técnica privada:

- WinPE
- Recuperação Offline
- Procedimentos avançados de contingência
- Estratégias de recuperação em ambientes bloqueados

📌 Não estão totalmente detalhados neste repositório público.

---

# ⚠️ Funcionalidades Sensíveis

O projeto inclui ferramentas avançadas como:

- Recuperação de acesso via utilman.exe (para uso legítimo e autorizado)
- Integração com Microsoft Activation Scripts (MAS)
- Modificações em:
  - Registro do Windows
  - Firewall
  - Serviços críticos
  - Adaptadores de rede
  - BCD / Bootloader

Uso inadequado pode causar:

- Instabilidade
- Falha de inicialização
- Corrupção de dados

---

# 🔒 Segurança e Responsabilidade

O script:

- Não coleta dados para servidores externos
- Pode consultar APIs públicas (ipinfo.io / VirusTotal)
- Não armazena informações pessoais

O uso é de responsabilidade exclusiva do operador.

---

# 📜 Licença

Este projeto é distribuído sob a:

**Free Personal Use License (Proprietary)**  
Copyright © 2026 Evandro Lemos  
All Rights Reserved.

❌ Redistribuição proibida  
❌ Uso comercial proibido  
❌ Modificação para revenda proibida  

Para licenciamento comercial, entre em contato com o autor.

---

# 🧠 Filosofia do Projeto

Transparência. Controle. Engenharia real.

> “A diferença entre um sistema comprometido e uma máquina blindada é conhecimento aplicado.”  
> — Mr Evan IRS
