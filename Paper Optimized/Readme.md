</div>
<div align="center">

# Paper (Super-Optimized)

</div>

##  📃 | Descrição
Aqui se encontra a explicação sobre as otimizações que este Egg contém...

Lembre-se, otimizado não quer dizer menos uso de RAM, pelo contrário, ele irá usar o máximo para fazer o coletor de lixo funcionar adequadamente.

Esta é a fonte que foi usada para fazer este Egg:

https://www.spigotmc.org/threads/guide-server-optimization%E2%9A%A1.283181/

</div>
<div align="center">

##  Otimizações

</div>

## 🗂 | Arquivos

###  📄 | bukkit.yml

| Variável | Original | Modificado | Saiba mais |
|--|--|--|--|
| monsters | 70 | 50 | limite de monstros |
| animals | 10 | 8 | limite de animais |
| water-animals | 5 | 3 |  limite de animais aquáticos |
| ambient | 15 | 1 |  limite de criaturas de ambiente (como morcegos)  |
| period-in-ticks | 600 |400  | frequência com que o sistema de coleta de lixo limpa as partes não utilizadas |
| monster-spawns | 1| 2| determina o tempo de espera entre o aparecimento de monstros |

###  📄 | paper-world-defaults.yml

| Variável | Original | Modificado | Saiba mais |
|--|--|--|--|
| max-auto-save-chunks-per-tick | 24 | 8 | Número máximo de chunks salvos por tick |
| prevent-moving-into-unloaded-chunks | false | true |  Jogadores podem se mover sobre blocos não carregados |
| max-entity-collisions | 8 | 2 | Interrompe o processamento de colisões depois que esse valor é atingido |
| disable-chest-cat-detection | false | true | Abrir baús mesmo que tenham um gato sentado em cima deles |
| creative-arrow-despawn-rate | default | 180 | A taxa na qual as flechas disparadas por jogadores no modo criativo são geradas |
| non-player-arrow-despawn-rate | default | 180 | A taxa na qual as flechas disparadas de entidades não-jogadores são lançadas. |
| disable-move-event | false | true | Desativa ```InventoryMoveItemEvent```. Melhora drasticamente o desempenho do funil, mas pode quebrar alguns plug-ins que usam essa variavel. |
| allow-non-player-entities-on-scoreboards | true | false | Diminuir ligeiramente a quantidade de tempo que o servidor gasta calculando colisões de entidades. |
| keep-spawn-loaded-range | 10 | 8 | O valor dos pedaços ao redor do spawn para manter carregado. |
| container-update | 1 | 2 | A taxa na qual o servidor atualiza contêineres(baus, fornos...) e inventários. |
| grass-spread | 1 | 2 | Define o atras no qual o servidor tenta espalhar a grama. |
| mob-spawner | 1 | 2 | Define a frequência do cálculo de spawn de entidades pelos geradores de mobs no mundo |

###  📄 | spigot.yml

| Variável | Original | Modificado | Saiba mais |
|--|--|--|--|
| item | 2.5 | 4.0 |  |
| exp | 3.0 | 6.0 |  |
| mob-spawn-range | 8 | 6 |  |
| arrow-despawn-rate | 1200 | 300 |  |
| nerf-spawner-mobs | false | true |  |
| animals | 32 | 16 |  |
| monsters | 32 | 24 |  |
| misc | 16 | 8 |  |
| tile | 50 | 1000 |  |
| entity | 50 | 1000 |  |

###  📄 | server.properties

| Variável | Original | Modificado | Saiba mais |
|--|--|--|--|
| network-compression-threshold | 256 | 512 |  |

## ⚙️ | Inicialização

| Otimização | Variável |
|--|--|
| (0) Geral | ```java -Xms128M -Xmx${SERVER_MEMORY}M -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 -Dusing.aikars.flags=https://mcflags.emc.gs -Daikars.new.flags=true -jar ${SERVER_JARFILE}``` |
| (1) 1GB RAM | ```java -Xmx1G -Xms1G -Xmn128m -XX:+DisableExplicitGC -XX:+UseNUMA -XX:MaxTenuringThreshold=15 -XX:MaxGCPauseMillis=30 -XX:GCPauseIntervalMillis=150 -XX:-UseGCOverheadLimit -XX:+UseBiasedLocking -XX:SurvivorRatio=8 -XX:TargetSurvivorRatio=90 -XX:MaxTenuringThreshold=15 -Dfml.ignorePatchDiscrepancies=true -Dfml.ignoreInvalidMinecraftCertificates=true -XX:+UseCompressedOops -XX:+OptimizeStringConcat  -XX:ReservedCodeCacheSize=2048m -XX:+UseCodeCacheFlushing -XX:SoftRefLRUPolicyMSPerMB=2000 -XX:ParallelGCThreads=10 -jar ${SERVER_JARFILE}``` |
| (2) 2GB RAM | ```java -Xmx1536M -Xms2G -Xmn384m -XX:+DisableExplicitGC -XX:+UseNUMA -XX:MaxTenuringThreshold=15 -XX:MaxGCPauseMillis=30 -XX:GCPauseIntervalMillis=150 -XX:-UseGCOverheadLimit -XX:+UseBiasedLocking -XX:SurvivorRatio=8 -XX:TargetSurvivorRatio=90 -XX:MaxTenuringThreshold=15 -Dfml.ignorePatchDiscrepancies=true -Dfml.ignoreInvalidMinecraftCertificates=true -XX:+UseCompressedOops -XX:+OptimizeStringConcat  -XX:ReservedCodeCacheSize=2048m -XX:+UseCodeCacheFlushing -XX:SoftRefLRUPolicyMSPerMB=2000 -XX:ParallelGCThreads=10 -jar ${SERVER_JARFILE}``` |
| (3) 3Gb RAM | ```java -Xmx2560M -Xms3G -Xmn768m -XX:+DisableExplicitGC -XX:+UseNUMA -XX:MaxTenuringThreshold=15 -XX:MaxGCPauseMillis=30 -XX:GCPauseIntervalMillis=150 -XX:-UseGCOverheadLimit -XX:+UseBiasedLocking -XX:SurvivorRatio=8 -XX:TargetSurvivorRatio=90 -XX:MaxTenuringThreshold=15 -Dfml.ignorePatchDiscrepancies=true -Dfml.ignoreInvalidMinecraftCertificates=true -XX:+UseCompressedOops -XX:+OptimizeStringConcat  -XX:ReservedCodeCacheSize=2048m -XX:+UseCodeCacheFlushing -XX:SoftRefLRUPolicyMSPerMB=10000 -XX:ParallelGCThreads=10 -jar ${SERVER_JARFILE}``` |
| (4) 4+Gb RAM | ```java -Xmx3584M -Xms4G -Xmn768m -XX:+DisableExplicitGC -XX:+UseNUMA -XX:MaxTenuringThreshold=15 -XX:MaxGCPauseMillis=30 -XX:GCPauseIntervalMillis=150 -XX:-UseGCOverheadLimit -XX:+UseBiasedLocking -XX:SurvivorRatio=8 -XX:TargetSurvivorRatio=90 -XX:MaxTenuringThreshold=15 -Dfml.ignorePatchDiscrepancies=true -Dfml.ignoreInvalidMinecraftCertificates=true -XX:+UseCompressedOops -XX:+OptimizeStringConcat  -XX:ReservedCodeCacheSize=2048m -XX:+UseCodeCacheFlushing -XX:SoftRefLRUPolicyMSPerMB=10000 -XX:ParallelGCThreads=10 -XX:+AlwaysPreTouch -XX:+ParallelRefProcEnabled -XX:+PerfDisableSharedMem -XX:-UsePerfData -jar ${SERVER_JARFILE}``` |
| (5) 4GB RAM / 4threads / 4cores | ```java -Xms2G -Xmx2G -Xmn384m -XX:+AlwaysPreTouch -XX:+DisableExplicitGC -XX:+ParallelRefProcEnabled -XX:+PerfDisableSharedMem -XX:+UseCompressedOops -XX:-UsePerfData -XX:MaxGCPauseMillis=200 -XX:ParallelGCThreads=4 -XX:ConcGCThreads=2 -XX:+UseG1GC -XX:InitiatingHeapOccupancyPercent=50 -XX:G1HeapRegionSize=1 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=8 -jar ${SERVER_JARFILE}``` |
| (6) 8+GB RAM / 8threads / 4cores | ```java -Xms4G -Xmx4G -Xmn512m -XX:+AlwaysPreTouch -XX:+DisableExplicitGC -XX:+ParallelRefProcEnabled -XX:+PerfDisableSharedMem -XX:-UsePerfData -XX:MaxGCPauseMillis=200 -XX:ParallelGCThreads=8 -XX:ConcGCThreads=2 -XX:+UseG1GC -XX:InitiatingHeapOccupancyPercent=50 -XX:G1HeapRegionSize=1 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=8 -jar ${SERVER_JARFILE}``` |
| (7) 12+GB RAM | ```java -Xms11G -Xmx12G -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=40 -XX:G1MaxNewSizePercent=50 -XX:G1HeapRegionSize=16M -XX:G1ReservePercent=15 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=20 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 -Dusing.aikars.flags=https://mcflags.emc.gs -Daikars.new.flags=true -jar ${SERVER_JARFILE}``` |

## 🐳 | Docker

O Docker que este Egg está usando se denomina Azul Zulu. É conhecido por sua baixa latência, alto desempenho e coletor de lixo eficiente.