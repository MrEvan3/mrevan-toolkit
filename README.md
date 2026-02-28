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

<img width="836" height="651" alt="Captura de tela 2026-02-28 191134" src="https://github.com/user-attachments/assets/db3ef6df-b351-4d1f-a95c-7bbddd0ba4f4" />

<img width="844" height="537" alt="Captura de tela 2026-02-28 191825" src="https://github.com/user-attachments/assets/8e301804-e222-42c7-a3fd-c716757ea074" />

<img width="1212" height="917" alt="Captura de tela 2026-02-28 191510" src="https://github.com/user-attachments/assets/9977f6af-bd20-413a-a293-6244492821e6" />

---

# 📂 Estrutura Pública do Repositório

Este repositório contém:

- ✅ Módulos 1 a 8
- ✅ Dashboard HTML
- ✅ Threat Intelligence
- ✅ Diagnóstico Avançado
- ✅ Sistema de Reversão (Undo)
- ✅ Integração com MAS (Microsoft Activation Scripts)
  
<img width="1433" height="478" alt="Captura de tela 2026-02-28 192529" src="https://github.com/user-attachments/assets/bef6b917-14ef-4c05-b98c-9ae841434510" />

<img width="778" height="550" alt="Captura de tela 2026-02-28 194226" src="https://github.com/user-attachments/assets/8f022beb-33a4-4bfb-ad4a-74a3c63cef3c" />

<img width="853" height="490" alt="Captura de tela 2026-02-28 193805" src="https://github.com/user-attachments/assets/3596921c-f77b-4be8-9d5d-5570ed28a3a1" />

<img width="708" height="497" alt="Captura de tela 2026-02-28 193848" src="https://github.com/user-attachments/assets/b2a9edb9-64e1-4883-93bf-4ff38bdb4746" />


---

# 🟢 Módulos Nível 1 – Usuário Técnico

Ferramentas para:

- Limpeza profunda
- Otimização Gamer
- Verificação de integridade do sistema
- Backup rápido
- Análise básica de rede
- Correção de serviços

<img width="751" height="562" alt="Captura de tela 2026-02-28 193302" src="https://github.com/user-attachments/assets/b4fbb5f6-6238-41ee-9337-3741eeb60e40" />

<img width="771" height="547" alt="Captura de tela 2026-02-28 193441" src="https://github.com/user-attachments/assets/6eb10a8d-351d-462e-b25b-58521f24adeb" />

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

<img width="768" height="608" alt="Captura de tela 2026-02-28 192210" src="https://github.com/user-attachments/assets/82bde41f-029b-4382-82f6-28fb6d4f3045" />

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


<img width="699" height="603" alt="Captura de tela 2026-02-28 192309" src="https://github.com/user-attachments/assets/2b16c183-f9b3-42d2-8d1f-bbac8cd2fd78" />


---

# 🔐 Enterprise Documentation (Privado)

Os seguintes módulos fazem parte da documentação técnica privada:

- WinPE
- Recuperação Offline
- Procedimentos avançados de contingência
- Estratégias de recuperação em ambientes bloqueados

<img width="775" height="504" alt="Captura de tela 2026-02-28 192720" src="https://github.com/user-attachments/assets/44c40ad9-6e5f-47db-9305-9fbd594db044" />

<img width="830" height="973" alt="Captura de tela 2026-02-28 192954" src="https://github.com/user-attachments/assets/fff567ea-1735-4a81-8ad8-0ea29b0855b3" />


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
