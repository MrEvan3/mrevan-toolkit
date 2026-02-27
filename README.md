# 🛠️ Mr Evan Intelligent Repair System (v2.1.0)

Bem-vindo ao **Mr Evan Intelligent Repair System**, um console interativo e avançado em PowerShell criado para otimizar, reparar e extrair o máximo de desempenho do Windows 10 e 11. 

---


🚀 Como executar

Você não precisa baixar nenhum arquivo manualmente para começar. Basta abrir o PowerShell como Administrador e colar o comando abaixo:

 irm "https://raw.githubusercontent.com/MrEvan3/mrevan-toolkit/main/MrEvanToolkit.ps1" | iex

 <img width="795" height="451" alt="Captura de tela 2026-02-26 224929" src="https://github.com/user-attachments/assets/dbfd55bc-b84d-4dca-acaf-a1e5909b3ee3" />


---

Aviso: Privilégios de Administrador são estritamente necessários para aplicar edições de registro, modificar serviços e resetar adaptadores de rede de forma eficaz.

---

✨ Funcionalidades Detalhadas
O sistema é modular e dividido em categorias principais. Abaixo, detalhamos o que cada ferramenta faz no seu sistema:

🧹 [1] Otimizar Agora (Limpeza Profunda)
Faxina Completa: Limpa diretórios temporários (%TEMP%, Prefetch, INetCache), esvazia a Lixeira e remove caches locais de navegadores (Chrome, Edge, Firefox, Opera, Brave).

Limpeza de Componentes: Limpa o cache de downloads do Windows Update (SoftwareDistribution) e logs de erros arquivados do Windows (WER).

Otimização de Imagem: Executa o comando DISM /StartComponentCleanup para reduzir o tamanho da pasta WinSxS.

Otimização de Rede: Esvazia o cache DNS (ipconfig /flushdns) e altera o DNS de todos os adaptadores IPv4 ativos para o Cloudflare (1.1.1.1 / 1.0.0.1).

<img width="803" height="423" alt="Captura de tela 2026-02-26 225057" src="https://github.com/user-attachments/assets/7695910d-f5a5-4047-a37e-b02d510e810d" />

---

🔑 [2] Windows / Office (Ativador)
Ativação MAS: Executa o script oficial do repositório Microsoft Activation Scripts para ativar permanentemente o Windows e produtos Office suportados.

Status: Consulta o Software Licensing Management Tool (slmgr /xpr) para exibir o status de licenciamento atual da máquina.

<img width="795" height="457" alt="Captura de tela 2026-02-26 225142" src="https://github.com/user-attachments/assets/9716f9b8-97a2-4f03-9c09-92fa6707fe42" />

---


🎮 [3] Ferramentas Gamer (Baixa Latência)
Timer Resolution: Injeta código C# via PowerShell para chamar a API NtSetTimerResolution, reduzindo a latência interna do Windows para 0.5ms.

Prioridade de CPU: Modifica o registro (PerfOptions) para forçar o executável do seu jogo a rodar sempre em Prioridade Alta.

Desativar FSO: Desativa o Fullscreen Optimizations (GameDVR_FSEBehaviorMode), reduzindo engasgos e o lag ao dar Alt+Tab.

Mouse 1:1: Zera as chaves de aceleração do mouse no registro (MouseSpeed, MouseThreshold), garantindo precisão bruta.

Otimização TCP: Define o TcpAckFrequency como 1 no registro de rede, enviando pacotes instantaneamente para reduzir o ping.

Plano de Energia: Força o plano de Alto Desempenho do Windows (SCHEME_MIN) para evitar o "estacionamento" de núcleos da CPU.

Game Bar/DVR: Desativa completamente as gravações em segundo plano do Xbox Game Bar via Políticas de Grupo (GPO).

---
<img width="794" height="479" alt="Captura de tela 2026-02-26 225220" src="https://github.com/user-attachments/assets/c7ec48f5-f0e0-4d6e-a16f-be27d50d25de" />
---

⚙️ [4] Ferramentas do Sistema (Reparos Essenciais)
WinUtil (Chris Titus): Abre a aclamada ferramenta gráfica externa para tweaks do Windows.

Arrumar Update: Para serviços críticos (wuauserv, bits), limpa a pasta de downloads corrompidos e os reinicia, destravando atualizações congeladas.

Auto-DNS: Dispara testes de Ping (ICMP) simultâneos para o Google (8.8.8.8) e Cloudflare (1.1.1.1) e aplica automaticamente o de menor latência no seu adaptador de rede.

Reparo SFC/DISM: Varre a imagem do Windows em busca de corrupções sistêmicas e as repara online.

Telemetria: Interrompe e desativa o serviço DiagTrack, impedindo a coleta de dados de uso em segundo plano pela Microsoft.

---

📊 [5] Diagnóstico do PC
Monitoramento: Traz um relatório rápido do sistema exibindo SO, build, modelo da CPU, GPU, quantidade de RAM, tempo de atividade (uptime), e capacidade/espaço livre de todos os discos físicos.

Atalhos Ocultos: Oferece acesso direto para as ferramentas nativas de diagnóstico da Microsoft (msinfo32, resmon, dxdiag).

<img width="799" height="477" alt="Captura de tela 2026-02-26 225642" src="https://github.com/user-attachments/assets/ad7814f3-d425-4c51-ada0-176ca5aed16d" />

---


🧰 [6] Utilitários Extras
Acesso Rápido: Atalhos para menus vitais que costumam ficar escondidos no Windows: Limpeza de Disco (cleanmgr), Configurações de Armazenamento, Programas e Recursos (appwiz.cpl) e Propriedades de Desempenho Visual.

---


⚠️ [7] Modo Técnico Avançado (Danger Zone)
Desativar VBS: Altera o bcdedit e o registro para desligar o Virtualization-Based Security e a Integridade de Memória, liberando desempenho bruto de CPU para jogos intensos.

Limpeza Nuclear (ResetBase): Força o DISM a destruir backups de atualizações antigas (/ResetBase). Libera dezenas de gigabytes, mas impossibilita a desinstalação do update atual.

Reset de Pilha de Rede: Executa comandos agressivos (netsh winsock reset, netsh int ip reset) para resolver problemas crônicos de conexão e IPs falsos.

Wipe de Logs: Usa o wevtutil para limpar absolutamente todos os logs do Visualizador de Eventos.

Cortar Web do Menu Iniciar: Adiciona a política DisableSearchBoxSuggestions para impedir que o Iniciar pesquise no Bing, tornando a busca local instantânea.

Modo Pânico: Reseta o Firewall do Windows aos padrões de fábrica e desbloqueia a conta nativa e oculta de Super Administrador.

Boot Seguro: Configura o bcdedit para forçar a máquina a reiniciar diretamente no Modo de Segurança com Rede.

<img width="794" height="465" alt="Captura de tela 2026-02-26 225728" src="https://github.com/user-attachments/assets/650368d7-1f20-41dd-b89e-6c34c97ca393" />

---


🏆 Créditos e Ferramentas de Terceiros
Este toolkit automatiza muitos processos e também se apoia nos ombros de gigantes do código aberto. O Mr Evan IRS executa integrações com os seguintes projetos de terceiros:

: Criado por massgravel. Utilizado no menu [2] para ativação legítima via HWID/KMS38 do Windows e Office.

: Criado por Chris Titus Tech. Invocado no menu [4] como uma alternativa gráfica e complementar.

<img width="1518" height="485" alt="Captura de tela 2026-02-26 225944" src="https://github.com/user-attachments/assets/16ce03ed-0af9-43a8-bd56-42f0220ad2da" />

<img width="1419" height="740" alt="Captura de tela 2026-02-26 230044" src="https://github.com/user-attachments/assets/10fdd408-a68a-4ce9-9209-9dbf1de78090" />


(Todo o restante do código em PowerShell, lógica de menus e rotinas de automação foram escritos e compilados por Evandro Lemos).

---


📋 Requisitos e Licença
SO: Windows 10 ou Windows 11.

Ambiente: PowerShell 5.1 ou superior.

---


Licença: Desenvolvido sob a .

Este software é fornecido "como está", sem garantias de qualquer tipo. Use as ferramentas avançadas com cuidado e certifique-se de entender as modificações aplicadas ao sistema.
