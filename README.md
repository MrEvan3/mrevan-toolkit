# 🛠️ Mr Evan Intelligent Repair System (v1.0)

Bem-vindo ao **Mr Evan Intelligent Repair System**, um console interativo e avançado em PowerShell criado para otimizar, reparar e extrair o máximo de desempenho do Windows 10 e 11. 

Desenvolvido por **Evandro Lemos**, este toolkit centraliza dezenas de comandos complexos em um menu simples e direto, funcionando como um verdadeiro canivete suíço para técnicos de TI, gamers e power users.

---

## 🚀 Como executar

Você não precisa baixar nenhum arquivo manualmente para começar. Basta abrir o PowerShell como Administrador e copiar e colar o comando no PowerShell:

` ` `irm "https://raw.githubusercontent.com/MrEvan3/mrevan-toolkit/main/MrEvanToolkit.ps1" | iex
` ` `

**Aviso:** Privilégios de Administrador são estritamente necessários para aplicar edições de registro, modificar serviços e resetar adaptadores de rede de forma eficaz.


<img width="801" height="569" alt="Captura de tela 2026-02-27 023725" src="https://github.com/user-attachments/assets/1fbeb3f6-6afd-4652-8004-a0e1b0cdad4d" />

---

## ✨ Funcionalidades Detalhadas
O sistema é modular e dividido em categorias principais. Abaixo, detalhamos o que cada ferramenta faz no seu sistema:

### 🧹 [1] Otimizar Agora (Limpeza Profunda)
**Faxina Completa:** Limpa diretórios temporários (%TEMP%, Prefetch, INetCache), esvazia a Lixeira e remove caches locais de navegadores (Chrome, Edge, Firefox, Opera, Brave).

**Limpeza de Componentes:** Limpa o cache de downloads do Windows Update (SoftwareDistribution) e logs de erros arquivados do Windows (WER).

**Otimização de Imagem:** Executa o comando DISM /StartComponentCleanup para reduzir o tamanho da pasta WinSxS.

**Otimização de Rede:** Esvazia o cache DNS (ipconfig /flushdns) e altera o DNS de todos os adaptadores IPv4 ativos para o Cloudflare (1.1.1.1 / 1.0.0.1).

<img width="803" height="423" alt="Captura de tela 2026-02-26 225057" src="https://github.com/user-attachments/assets/7695910d-f5a5-4047-a37e-b02d510e810d" />

---

### 🔑 [2] Windows / Office (Ativador)
**Ativação MAS:** Executa o script oficial do repositório Microsoft Activation Scripts para ativar permanentemente o Windows e produtos Office suportados.

**Status:** Consulta o Software Licensing Management Tool (slmgr /xpr) para exibir o status de licenciamento atual da máquina.

<img width="795" height="457" alt="Captura de tela 2026-02-26 225142" src="https://github.com/user-attachments/assets/9716f9b8-97a2-4f03-9c09-92fa6707fe42" />

---

### 🎮 [3] Ferramentas Gamer (Baixa Latência)
**Timer Resolution:** Injeta código C# via PowerShell para chamar a API NtSetTimerResolution, reduzindo a latência interna do Windows para 0.5ms.

**Prioridade de CPU:** Modifica o registro (PerfOptions) para forçar o executável do seu jogo a rodar sempre em Prioridade Alta.

**Desativar FSO:** Desativa o Fullscreen Optimizations (GameDVR_FSEBehaviorMode), reduzindo engasgos e o lag ao dar Alt+Tab.

**Mouse 1:1:** Zera as chaves de aceleração do mouse no registro (MouseSpeed, MouseThreshold), garantindo precisão bruta.

**Otimização TCP:** Define o TcpAckFrequency como 1 no registro de rede, enviando pacotes instantaneamente para reduzir o ping.

**Plano de Energia:** Força o plano de Alto Desempenho do Windows (SCHEME_MIN) para evitar o "estacionamento" de núcleos da CPU.

**Game Bar/DVR:** Desativa completamente as gravações em segundo plano do Xbox Game Bar via Políticas de Grupo (GPO).

<img width="794" height="479" alt="Captura de tela 2026-02-26 225220" src="https://github.com/user-attachments/assets/c7ec48f5-f0e0-4d6e-a16f-be27d50d25de" />

---

### ⚙️ [4] Ferramentas do Sistema (Reparos Essenciais)
**WinUtil (Chris Titus):** Abre a aclamada ferramenta gráfica externa para tweaks do Windows.

**Arrumar Update:** Para serviços críticos (wuauserv, bits), limpa a pasta de downloads corrompidos e os reinicia, destravando atualizações congeladas.

**Auto-DNS:** Dispara testes de Ping (ICMP) simultâneos para o Google (8.8.8.8) e Cloudflare (1.1.1.1) e aplica automaticamente o de menor latência no seu adaptador de rede.

**Reparo SFC/DISM:** Varre a imagem do Windows em busca de corrupções sistêmicas e as repara online.

**Telemetria:** Interrompe e desativa o serviço DiagTrack, impedindo a coleta de dados de uso em segundo plano pela Microsoft.

<img width="799" height="477" alt="Captura de tela 2026-02-26 225642" src="https://github.com/user-attachments/assets/ad7814f3-d425-4c51-ada0-176ca5aed16d" />

<img width="805" height="472" alt="Captura de tela 2026-02-26 235934" src="https://github.com/user-attachments/assets/251fea4b-089c-4d6e-bff2-ab9c7d84fdac" />

---

### 📊 [5] Diagnóstico do PC
**Monitoramento:** Traz um relatório rápido do sistema exibindo SO, build, modelo da CPU, GPU, quantidade de RAM, tempo de atividade (uptime), e capacidade/espaço livre de todos os discos físicos.

<img width="808" height="468" alt="Captura de tela 2026-02-27 000005" src="https://github.com/user-attachments/assets/d6db0cff-35ec-4373-8032-59459af1728e" />

---

### 🧰 [6] Utilitários Extras
**Acesso Rápido:** Atalhos para menus vitais que costumam ficar escondidos no Windows: Limpeza de Disco (cleanmgr), Configurações de Armazenamento, Programas e Recursos (appwiz.cpl) e Propriedades de Desempenho Visual.

<img width="794" height="465" alt="Captura de tela 2026-02-26 225728" src="https://github.com/user-attachments/assets/9947d0a9-a58a-4158-af73-c0913da20b5d" />

---

### ⚠️ [7] Modo Técnico Avançado (Danger Zone)
**Desativar VBS:** Altera o bcdedit e o registro para desligar o Virtualization-Based Security e a Integridade de Memória, liberando desempenho bruto de CPU para jogos intensos.

**Limpeza Nuclear (ResetBase):** Força o DISM a destruir backups de atualizações antigas (/ResetBase). Libera dezenas de gigabytes, mas impossibilita a desinstalação do update atual.

**Reset de Pilha de Rede:** Executa comandos agressivos (netsh winsock reset, netsh int ip reset) para resolver problemas crônicos de conexão e IPs falsos.

**Wipe de Logs:** Usa o wevtutil para limpar absolutamente todos os logs do Visualizador de Eventos.

**Cortar Web do Menu Iniciar:** Adiciona a política DisableSearchBoxSuggestions para impedir que o Iniciar pesquise no Bing, tornando a busca local instantânea.

**Modo Pânico:** Reseta o Firewall do Windows aos padrões de fábrica e desbloqueia a conta nativa e oculta de Super Administrador.

**Boot Seguro:** Configura o bcdedit para forçar a máquina a reiniciar diretamente no Modo de Segurança com Rede.

<img width="797" height="463" alt="Captura de tela 2026-02-26 230853" src="https://github.com/user-attachments/assets/b4230aee-fdaf-47bb-83d5-f961ecd7861f" />

---

### 🔄 [8] Restaurar Padrões (Desfazer)
**Segurança do Windows:** Restaura as configurações padrão e políticas do Microsoft Defender em caso de bloqueios.

**Explorer e Barra de Tarefas:** Destrava e reinicia a interface gráfica, limpando o cache de ícones corrompidos.

**Microsoft Store:** Reseta o cache da loja oficial (wsreset) para corrigir problemas de download ou aplicativos que não abrem.

**Menu Iniciar:** Re-registra todos os pacotes AppX do sistema para consertar o Menu Iniciar e a barra de pesquisa travada.

**Menu de Contexto:** Desfaz o clique-direito clássico e restaura o design moderno original do Windows 11.

**Arquivo HOSTS:** Limpa bloqueios e redirecionamentos, restaurando o arquivo de rede para o formato padrão da Microsoft.

**DNS Automático:** Remove os servidores DNS customizados e volta a utilizar o DHCP automático do seu roteador.

**Pesquisa Web:** Remove a restrição e reativa os resultados da internet nas buscas nativas do Menu Iniciar.

**Reparo do Office:** Atalho direto para iniciar o processo seguro de Reparo Online do Microsoft 365.

**Plano de Energia:** Devolve o sistema ao plano "Equilibrado" (Balanced), focado em economizar bateria e reduzir o uso do hardware.


<img width="803" height="597" alt="Captura de tela 2026-02-27 022948" src="https://github.com/user-attachments/assets/2a683846-97a9-411a-9c3c-09f1bd81830a" />

---

### 🌐 [9] Acesso Remoto (AnyDesk)
**Suporte Imediato:** Descarrega a versão mais recente do AnyDesk diretamente dos servidores oficiais e guarda o ficheiro no Ambiente de Trabalho.

**Privilégios Máximos:** O utilitário é iniciado automaticamente com permissões de Administrador, garantindo que o técnico remoto possa interagir com ecrãs de segurança (UAC) e realizar reparações profundas sem perder a conexão.

<img width="815" height="637" alt="Captura de tela 2026-02-27 022643" src="https://github.com/user-attachments/assets/861a651b-ca65-4452-aa81-7029d4e3c868" />

---

### 🚑 [10] Recuperação Offline (Modo Boot/WinPE)
**Diagnóstico e Partições:** Lista discos via `diskpart` para localizar a instalação do Windows, detecta o status do BitLocker e lê o log de falhas de inicialização do sistema (`SrtTrail.txt`).

**Reparo de Imagem e Disco:** Executa o SFC Offline para restaurar arquivos do sistema corrompidos e o CHKDSK para corrigir setores defeituosos diretamente no disco inativo.

**Reparo de Inicialização:** Automatiza a reconstrução do boot (MBR/BCD) via `bootrec`, restaura o BCD com `bcdboot` e corrige o apontamento do OS Device no Winload.

**Backup de Emergência:** Usa o poder do `robocopy` para realizar o backup completo dos arquivos dos usuários para um pendrive ou HD externo, pulando erros de leitura e arquivos bloqueados.

**Bypass de Senha:** Substitui temporariamente o `utilman.exe` pelo CMD para permitir a redefinição de senhas locais pela tela de bloqueio, com função automática para reverter a alteração e apagar os rastros.

<img width="807" height="598" alt="Captura de tela 2026-02-27 022835" src="https://github.com/user-attachments/assets/f08843d7-d0c7-42b3-8ae0-359a49132466" />


> #### 📖 Guia Passo a Passo: Quebra de Senha via Pendrive (Bypass Utilman)
> 1. **Prepare o Pendrive:** Baixe o script `MrEvanToolkit.ps1` e salve-o na raiz de um pendrive de instalação do Windows.
> 2. **Dê o Boot:** Inicie o PC problemático pelo pendrive. Quando a primeira tela azul de instalação do Windows aparecer, pressione **Shift + F10** para abrir o CMD.
> 3. **Abra o Script:** No CMD, digite `powershell` e dê Enter. Depois, chame o script digitando o caminho do seu pendrive (ex: `E:\MrEvanToolkit.ps1`) para abrir o painel.
> 4. **Inicie o Bypass:** No menu principal, escolha a opção **10** *(Recuperação Offline)* e depois a opção **5** *(Desativar Conta Administrador)*.
> 5. **Identifique o Windows:** O script perguntará a letra onde o Windows está instalado. No modo boot (WinPE), a letra geralmente muda para **D** ou **E**. Use a opção 1 do menu de Recuperação para listar os discos caso tenha dúvida.
> 6. **Injete o Código:** Pressione **1** para ativar o bypass. O script fará o backup do utilman original e o substituirá pelo CMD. Feche tudo e reinicie o PC normalmente sem o pendrive.
> 7. **Mude a Senha:** Na tela de bloqueio do Windows (onde pede a senha), clique no botão de **Acessibilidade** (canto inferior direito). Um CMD com privilégios máximos se abrirá. Digite o comando `control userpasswords2` para abrir a interface gráfica ou `net user [nome_do_usuario] *` para redefinir a senha ali mesmo. Feche o CMD e entre no Windows com a nova senha.
> 8. **Limpe os Rastros (Importante):** Após acessar o Windows com sucesso, volte a dar boot pelo pendrive, abra o script novamente (Opção 10 > Opção 5) e pressione **2** para restaurar o `utilman.exe` original e deixar o sistema seguro como antes.

---

## 🏆 Créditos e Ferramentas de Terceiros
Este toolkit automatiza muitos processos e também se apoia nos ombros de gigantes do código aberto. O Mr Evan IRS executa integrações com os seguintes projetos de terceiros:

**[Microsoft Activation Scripts (MAS)](https://github.com/massgravel/Microsoft-Activation-Scripts):** Criado por massgravel. Utilizado no menu [2] para ativação legítima via HWID/KMS38 do Windows e Office.

**[WinUtil](https://github.com/ChrisTitusTech/winutil):** Criado por Chris Titus Tech. Invocado no menu [4] como uma alternativa gráfica e complementar.

<img width="1518" height="485" alt="Captura de tela 2026-02-26 225944" src="https://github.com/user-attachments/assets/16ce03ed-0af9-43a8-bd56-42f0220ad2da" />

<img width="1419" height="740" alt="Captura de tela 2026-02-26 230044" src="https://github.com/user-attachments/assets/10fdd408-a68a-4ce9-9209-9dbf1de78090" />

Todo o restante do código em PowerShell, lógica de menus e rotinas de automação foram escritos e compilados por Evandro Lemos.

---

## 📋 Requisitos e Licença
**SO:** Windows 10 ou Windows 11.

**Ambiente:** PowerShell 5.1 ou superior.

---

**Licença:** Desenvolvido sob a [Licença MIT e Termos de Uso](LICENSE.md).

Este software é fornecido "como está", sem garantias de qualquer tipo. Use as ferramentas avançadas com cuidado e certifique-se de entender as modificações aplicadas ao sistema.
