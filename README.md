# Shonen Fight 🥊

> **Assista à demonstração do jogo no YouTube:** [Clique aqui para ver o vídeo do projeto](https://www.youtube.com/watch?v=pAq2kalHOBQ) 📺

---

## 📌 Sobre o Projeto
O **Shonen Fight** é um jogo de luta em estilo de arena 2D pixel art, desenvolvido como projeto prático para a cadeira de **Game Engine** na faculdade. 

O objetivo principal do projeto foi aplicar conceitos fundamentais de arquitetura de jogos, lógica de colisões, manipulação de inputs complexos e gerenciamento de estados (`State Machines`) dentro de um motor de jogos.

---

## 🎮 Mecânicas do Jogo
* **Sistema de Combo Dinâmico:** Ataques sequenciais (`ATTACK_1`, `ATTACK_2`, `ATTACK_3`) com timings específicos para cancelamento e encadeamento de golpes.
* **Máquina de Estados Sólida (`State Machine`):** Todo o comportamento dos personagens (movimentação livre, pulo, defesa, hit stun, knockdown e especiais) é controlado por estados numéricos, evitando bugs de travamento de animação.
* **Menu de Especiais Modular:** Sistema de comando avançado através de botões combinados (`LB + X` no controle ou atalhos customizados no teclado) que gerencia o gasto de barras de energia de forma inteligente e automatizada.
* **Suporte a Gamepad e Teclado:** Mapeamento simultâneo para até dois jogadores locais (`Player 1` e `Player 2`).

---

## 🛠️ Tecnologias Utilizadas
* **Engine:** GameMaker
* **Linguagem:** GML (GameMaker Language)

